
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using Dapper;

namespace Library.DAL.DataManager
{
    

    public class DataAccessManager_daaw
    {
        private SqlConnection sqlConnection;
        private SqlTransaction sqlTransaction;
        private SqlDataReader sqlDataReader;
        private const int DefaultCommandTimeout = 180; // seconds

        private bool isException;
        private bool returnValue;

        private string ConnectionString(string database)
        {
            // ???????? Encrypt/TrustServerCertificate ??? ??? (????????? ?????????? ??????)
            return "Data Source=" + SqlUserAccess.DataSource +
                   ";Initial Catalog=" + database +
                   ";Integrated Security=false;User ID=" + SqlUserAccess.UserName +
                   ";Password=" + SqlUserAccess.PassWord +
                   ";Encrypt=True;TrustServerCertificate=True;";
            // ??????:
            // ";Integrated Security=true;"
        }

        // ---------- Core guards ----------
        private void EnsureOpen(string database)
        {
            var cs = ConnectionString(database);

            if (sqlConnection == null)
            {
                sqlConnection = new SqlConnection(cs);
            }
            else if (!string.Equals(sqlConnection.ConnectionString, cs, StringComparison.Ordinal))
            {
                SafeDispose(sqlConnection);
                sqlConnection = new SqlConnection(cs);
            }

            if (sqlConnection.State == ConnectionState.Broken)
            {
                try { sqlConnection.Close(); } catch { }
            }
            if (sqlConnection.State != ConnectionState.Open)
            {
                sqlConnection.Open();
            }

            // completed transaction ??? null ??? ???
            if (sqlTransaction != null && sqlTransaction.Connection == null)
                sqlTransaction = null;
        }

        private static void SafeDispose(IDisposable d)
        {
            try { if (d != null) d.Dispose(); } catch { }
        }

        private static DynamicParameters ToDynamicParameters(List<SqlParameter> parameters)
        {
            var dp = new DynamicParameters();
            if (parameters != null)
            {
                foreach (var p in parameters)
                {
                    dp.Add(p.ParameterName, p.Value, p.DbType, p.Direction,
                        p.Size > 0 ? (int?)p.Size : null);
                }
            }
            return dp;
        }


private static int SafeScalarToInt(object scalar)
{
    if (scalar == null || scalar == DBNull.Value) return 0;

    if (scalar is int)     return (int)scalar;
    if (scalar is short)   return (short)scalar;
    if (scalar is byte)    return (byte)scalar;

    if (scalar is long)    return checked((int)(long)scalar);
    if (scalar is decimal) return decimal.ToInt32((decimal)scalar);
    if (scalar is double)  return checked((int)Convert.ToDouble(scalar, CultureInfo.InvariantCulture));
    if (scalar is float)   return checked((int)Convert.ToSingle(scalar, CultureInfo.InvariantCulture));

    if (scalar is string)
    {
        int tmp;
        if (int.TryParse((string)scalar, NumberStyles.Integer, CultureInfo.InvariantCulture, out tmp))
            return tmp;
        // fall through to throw below
    }

    try
    {
        // General fallback for IConvertible types
        return Convert.ToInt32(scalar, CultureInfo.InvariantCulture);
    }
    catch (Exception)
    {
        throw new InvalidCastException(
            "ExecuteScalar returned a non-integer value of type " +
            scalar.GetType().FullName);
    }
}

        // ---------- Connection open/close ----------
        public bool SqlConnectionOpen(string database)
        {
            isException = false;
            returnValue = false;

            try
            {
                EnsureOpen(database);        // ???? ????; ???????????? ????? ???? ???? ??
                returnValue = true;
                return true;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public bool SqlConnectionClose(bool isRollBack = false)
        {
            isException = false;
            returnValue = true;

            try
            {
                // reader ????? ??? ????
                if (sqlDataReader != null)
                {
                    try { if (!sqlDataReader.IsClosed) sqlDataReader.Close(); } catch { }
                    sqlDataReader = null;
                }

                // ???????????? alive ????? ????/????????
                if (sqlTransaction != null && sqlTransaction.Connection != null)
                {
                    try
                    {
                        if (isRollBack) sqlTransaction.Rollback();
                        else sqlTransaction.Commit();
                    }
                    finally
                    {
                        SafeDispose(sqlTransaction);
                        sqlTransaction = null;
                    }
                }

                // ??????? dispose
                if (sqlConnection != null && sqlConnection.State != ConnectionState.Closed)
                {
                    try { sqlConnection.Close(); } catch { }
                }
                SafeDispose(sqlConnection);
                sqlConnection = null;

                return true;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
            finally
            {
                if (isException) returnValue = false;
            }
        }

        // ---------- READ (DataReader) ----------
        // ???: Reader-? ???????????? attach ??? ????; CommandBehavior.CloseConnection ????? ????
        public SqlDataReader GetSqlDataReader(string storeProcedure, bool isBigData = false, string database = null)
        {
            isException = false;

            try
            {
                if (database != null) EnsureOpen(database);
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");

                var cmd = new SqlCommand(storeProcedure, sqlConnection)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout
                };

                // Reader ???? command/txn dispose ??? ???? ??�CloseConnection ??????? ????
                sqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                return sqlDataReader;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public SqlDataReader GetSqlDataReader(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;

            try
            {
                if (database != null) EnsureOpen(database);
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");

                var cmd = new SqlCommand(storeProcedure, sqlConnection)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout
                };

                if (parameters != null && parameters.Count > 0)
                    cmd.Parameters.AddRange(parameters.ToArray());

                sqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                return sqlDataReader;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        // ---------- READ (DataTable / DataSet) ----------
        public DataTable GetDataTable(string storeProcedure, bool isBigData = false, string database = null)
        {
            return GetDataTable(storeProcedure, (List<SqlParameter>)null, isBigData, database);
        }

        public DataTable GetDataTable(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            var dt = new DataTable();

            try
            {
                if (database != null) EnsureOpen(database);
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");

                int timeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout;
                using (var reader = (System.Data.Common.DbDataReader)sqlConnection.ExecuteReader(
                    storeProcedure, ToDynamicParameters(parameters), sqlTransaction, timeout, CommandType.StoredProcedure))
                {
                    dt.Load(reader);
                }
                return dt;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public DataTable GetDataTableByText(string queryText, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            var dt = new DataTable();

            try
            {
                if (database != null) EnsureOpen(database);
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");

                int timeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout;
                using (var reader = (System.Data.Common.DbDataReader)sqlConnection.ExecuteReader(
                    queryText, ToDynamicParameters(parameters), sqlTransaction, timeout, CommandType.Text))
                {
                    dt.Load(reader);
                }
                return dt;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public DataSet GetDataSet(string storeProcedure, bool isBigData = false, string database = null)
        {
            return GetDataSet(storeProcedure, (List<SqlParameter>)null, isBigData, database);
        }

        public DataSet GetDataSet(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            var ds = new DataSet();

            try
            {
                if (database != null) EnsureOpen(database);
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");

                int timeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout;
                using (var reader = (System.Data.Common.DbDataReader)sqlConnection.ExecuteReader(
                    storeProcedure, ToDynamicParameters(parameters), sqlTransaction, timeout, CommandType.StoredProcedure))
                {
                    // DataTable.Load consumes one result set AND advances the reader to the
                    // next one by itself. The previous loop called NextResult() on top of
                    // that, so every second result set was skipped: a proc returning 3 sets
                    // yielded tables [1st, 3rd], and a proc returning 2 yielded only the 1st.
                    while (!reader.IsClosed)
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        if (dt.Columns.Count == 0) break;   // reader exhausted
                        ds.Tables.Add(dt);
                    }
                }
                return ds;
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        // ---------- WRITE ----------
        private int ExecuteNonQueryScalarInt(string storeProcedure, List<SqlParameter> parameters, bool isBigData)
        {
            // writes-?? ??? tx ???????
            if (sqlTransaction == null || sqlTransaction.Connection == null)
            {
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");
                sqlTransaction = sqlConnection.BeginTransaction();
            }

            int timeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout;
            var scalar = sqlConnection.ExecuteScalar(
                storeProcedure, ToDynamicParameters(parameters), sqlTransaction, timeout, CommandType.StoredProcedure);
            return SafeScalarToInt(scalar);
        }

        private bool ExecuteNonQueryVoid(string storeProcedure, List<SqlParameter> parameters, bool isBigData)
        {
            if (sqlTransaction == null || sqlTransaction.Connection == null)
            {
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");
                sqlTransaction = sqlConnection.BeginTransaction();
            }

            int timeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout;
            sqlConnection.Execute(
                storeProcedure, ToDynamicParameters(parameters), sqlTransaction, timeout, CommandType.StoredProcedure);
            return true;
        }

        private int ExecuteNonQueryText(string queryText, List<SqlParameter> parameters, bool isBigData)
        {
            if (sqlTransaction == null || sqlTransaction.Connection == null)
            {
                if (sqlConnection == null || sqlConnection.State != ConnectionState.Open)
                    throw new InvalidOperationException("Connection is not open.");
                sqlTransaction = sqlConnection.BeginTransaction();
            }

            int timeout = isBigData ? Math.Max(DefaultCommandTimeout, 600) : DefaultCommandTimeout;
            return sqlConnection.Execute(
                queryText, ToDynamicParameters(parameters), sqlTransaction, timeout, CommandType.Text);
        }

        /// After Saving Data Only Identity Value will be Returned
        public int SaveDataReturnPrimaryKey(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            try
            {
                if (database != null) EnsureOpen(database);
                return ExecuteNonQueryScalarInt(storeProcedure, parameters, isBigData);
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        /// After Saving Data a Boolean will be Returned
        public bool SaveData(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            try
            {
                if (database != null) EnsureOpen(database);
                return ExecuteNonQueryVoid(storeProcedure, parameters, isBigData);
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public bool UpdateData(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            try
            {
                if (database != null) EnsureOpen(database);
                return ExecuteNonQueryVoid(storeProcedure, parameters, isBigData);
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public bool DeleteData(string storeProcedure, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            try
            {
                if (database != null) EnsureOpen(database);
                return ExecuteNonQueryVoid(storeProcedure, parameters, isBigData);
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        public int ExecuteTextNonQuery(string queryText, List<SqlParameter> parameters, bool isBigData = false, string database = null)
        {
            isException = false;
            try
            {
                if (database != null) EnsureOpen(database);
                return ExecuteNonQueryText(queryText, parameters, isBigData);
            }
            catch (SqlException)
            {
                isException = true;
                throw;
            }
        }

        // ---------- Utility (serialize) ----------
        public IEnumerable<Dictionary<string, object>> Serialize(SqlDataReader reader)
        {
            var results = new List<Dictionary<string, object>>();

            // Precompute column names and ensure uniqueness by suffixing duplicates
            int fieldCount = reader.FieldCount;
            var rawNames = new string[fieldCount];
            for (int i = 0; i < fieldCount; i++)
                rawNames[i] = reader.GetName(i);

            var nameMap = new string[fieldCount];
            var seen = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < fieldCount; i++)
            {
                var name = string.IsNullOrEmpty(rawNames[i]) ? string.Format("Column{0}", i) : rawNames[i];

                int count;
                if (seen.TryGetValue(name, out count))
                {
                    count++;
                    seen[name] = count;
                    nameMap[i] = string.Format("{0}_{1}", name, count); // e.g., Id, Id_2, Id_3...
                }
                else
                {
                    seen[name] = 1;
                    nameMap[i] = name;
                }
            }

            while (reader.Read())
            {
                // Use case-insensitive comparer if your SQL can differ by case only
                var row = new Dictionary<string, object>(fieldCount, StringComparer.OrdinalIgnoreCase);
                for (int i = 0; i < fieldCount; i++)
                {
                    object value = reader.IsDBNull(i) ? null : reader.GetValue(i);
                    row[nameMap[i]] = value;
                }
                results.Add(row);
            }

            return results;
        }


    }

}
