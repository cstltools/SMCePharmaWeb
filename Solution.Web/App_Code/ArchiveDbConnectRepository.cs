using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using Dapper;

public sealed class ArchiveDbConnectRecord
{
    public int SL { get; set; }
    public string FY { get; set; }
    public string DataBaseName { get; set; }
}

public sealed class ArchiveDbConnectActionResult
{
    public bool IsSuccess { get; set; }
    public bool IsExistingRecord { get; set; }
    public string Message { get; set; }
}

public sealed class ArchiveDbConnectRepository
{
    private readonly string _connectionString;
    private readonly string _jobName;

    public ArchiveDbConnectRepository()
    {
        string connectionStringName = ConfigurationManager.AppSettings["DatabaseBackupConnectionStringName"];
        if (string.IsNullOrWhiteSpace(connectionStringName))
        {
            connectionStringName = "SolutionConnectionStringSSIDB";
        }

        ConnectionStringSettings connectionSettings = ConfigurationManager.ConnectionStrings[connectionStringName];
        if (connectionSettings == null || string.IsNullOrWhiteSpace(connectionSettings.ConnectionString))
        {
            throw new ConfigurationErrorsException("Connection string '" + connectionStringName + "' is not configured.");
        }

        _connectionString = connectionSettings.ConnectionString;
        _jobName = ConfigurationManager.AppSettings["DatabaseBackupJobName"];

        if (string.IsNullOrWhiteSpace(_jobName))
        {
            _jobName = "Society_DB_Backup_Job";
        }
    }

    public string JobName
    {
        get { return _jobName; }
    }

    public IList<ArchiveDbConnectRecord> GetRecentEntries()
    {
        List<ArchiveDbConnectRecord> records = new List<ArchiveDbConnectRecord>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        using (var reader = connection.ExecuteReader(
            @"SELECT TOP (100)
                  SL,
                  ISNULL(LTRIM(RTRIM(FY)), '') AS FY,
                  ISNULL(LTRIM(RTRIM(DataBaseName)), '') AS DataBaseName
              FROM dbo.tblArcDBConnect
              ORDER BY SL DESC;"))
        {
            while (reader.Read())
            {
                ArchiveDbConnectRecord record = new ArchiveDbConnectRecord();
                record.SL = Convert.ToInt32(reader["SL"]);
                record.FY = Convert.ToString(reader["FY"]);
                record.DataBaseName = Convert.ToString(reader["DataBaseName"]);
                records.Add(record);
            }
        }

        return records;
    }

    public ArchiveDbConnectActionResult SaveAndStartJob(string fy, string databaseName)
    {
        fy = (fy ?? string.Empty).Trim();
        databaseName = (databaseName ?? string.Empty).Trim();

        if (string.IsNullOrWhiteSpace(fy) || string.IsNullOrWhiteSpace(databaseName))
        {
            return new ArchiveDbConnectActionResult
            {
                IsSuccess = false,
                Message = "FY and Database Name are required."
            };
        }

        bool isExistingRecord;

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();

            isExistingRecord = EntryExists(connection, fy, databaseName);
            if (!isExistingRecord)
            {
                InsertEntry(connection, fy, databaseName);
            }

            try
            {
                StartJob(connection);

                return new ArchiveDbConnectActionResult
                {
                    IsSuccess = !isExistingRecord,
                    IsExistingRecord = isExistingRecord,
                    Message = isExistingRecord
                        ? "An entry for this FY already exists. Backup job has been started."
                        : "Entry saved and backup job has been started."
                };
            }
            catch (SqlException exception)
            {
                if (IsJobAlreadyRunning(exception))
                {
                    return new ArchiveDbConnectActionResult
                    {
                        IsSuccess = !isExistingRecord,
                        IsExistingRecord = isExistingRecord,
                        Message = isExistingRecord
                            ? "An entry for this FY already exists and the backup job is already running."
                            : "Entry saved and the backup job is already running."
                    };
                }

                return new ArchiveDbConnectActionResult
                {
                    IsSuccess = false,
                    IsExistingRecord = isExistingRecord,
                    Message = (isExistingRecord
                        ? "An entry for this FY already exists, but the backup job could not be started. "
                        : "Data saved, but the backup job could not be started. ") + exception.Message
                };
            }
        }
    }

    private static bool EntryExists(SqlConnection connection, string fy, string databaseName)
    {
        int count = connection.ExecuteScalar<int>(
            @"SELECT COUNT(1)
              FROM dbo.tblArcDBConnect
              WHERE ISNULL(LTRIM(RTRIM(FY)), '') = @FY;",
            new { FY = fy });

        return count > 0;
    }

    private static void InsertEntry(SqlConnection connection, string fy, string databaseName)
    {
        connection.Execute(
            @"INSERT INTO dbo.tblArcDBConnect (FY, DataBaseName)
              VALUES (@FY, @DataBaseName);",
            new { FY = fy, DataBaseName = databaseName });
    }

    private void StartJob(SqlConnection connection)
    {
        connection.Execute("EXEC msdb.dbo.sp_start_job @job_name = @JobName;", new { JobName = _jobName });
    }

    private static bool IsJobAlreadyRunning(SqlException exception)
    {
        if (exception == null || string.IsNullOrWhiteSpace(exception.Message))
        {
            return false;
        }

        string message = exception.Message;
        return message.IndexOf("already running", StringComparison.OrdinalIgnoreCase) >= 0
               || message.IndexOf("pending request", StringComparison.OrdinalIgnoreCase) >= 0;
    }
}
