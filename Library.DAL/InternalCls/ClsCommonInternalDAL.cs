using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using Dapper;

namespace Library.DAL.InternalCls
{
    public class ClsCommonInternalDAL
    {
        private static string ConnStr(string dataBaseName)
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["SolutionConnectionString" + dataBaseName].ConnectionString;
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

        internal void LoadDropDownValueWithoutDataBase(DropDownList ddl, string displayField, string valueField, string queryString)
        {
            try
            {
                DataTable dataDDL = new DataTable();
                using (var connection = new SqlConnection(ConnStr("SSIDB")))
                using (var reader = (DbDataReader)connection.ExecuteReader(
                    "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure))
                {
                    dataDDL.Load(reader);
                }
                ddl.DataTextField = displayField;
                ddl.DataValueField = valueField;
                ddl.DataSource = dataDDL;
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem("--------Select---------", String.Empty));
                ddl.SelectedIndex = 0;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

        internal void LoadDropDownValueWithoutDataBase(DropDownList ddl, string displayField, string valueField, string queryString, List<SqlParameter> parameters)
        {
            DataTable dataDDL = new DataTable();

            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                queryString, ToDynamicParameters(parameters), commandTimeout: 99000000, commandType: CommandType.Text))
            {
                dataDDL.Load(reader);
            }

            ddl.DataTextField = displayField;
            ddl.DataValueField = valueField;
            ddl.DataSource = dataDDL;
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("--------Select---------", String.Empty));
            ddl.SelectedIndex = 0;
        }

        internal bool DeleteAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist)
        {
            try
            {
                ActionStatus =
                    Convert.ToBoolean(ExecuteNonQueryAction(StoreProcedureName, SqlParameterlist, string.Empty, false));
            }
            catch (Exception ex)
            {
                ActionStatus = false;
            }
            return ActionStatus;
        }

        internal DataTable GetDataTableAction(string StoreProcedureName, string dataBaseName)
        {
            DataTable dt = new DataTable();

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                StoreProcedureName, commandTimeout: 99000000, commandType: CommandType.StoredProcedure))
            {
                dt.Load(reader);
            }

            return dt;
        }

        /// WARNING: Caller MUST close the returned IDataReader (Dispose) to avoid leaks.
        internal IDataReader DataContainerDataReader(string queryString)
        {
            var connection = new SqlConnection(ConnStr("SSIDB"));

            // ExecuteReader থেকে reader close করলে cmd/connection-ও বন্ধ হবে (connection closed argument-e passed).
            // Caller must: using (var r = dal.DataContainerDataReader(sql)) { ... }
            return connection.ExecuteReader(
                "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 60, commandType: CommandType.StoredProcedure);
        }

        internal DataTable DataContainerDataTable(string queryString)
        {
            DataTable table = new DataTable();

            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 90, commandType: CommandType.StoredProcedure))
            {
                table.Load(reader);
            }

            return table;
        }

        internal int SaveDataByInsertCommandWithIdentity(string queryString, List<SqlParameter> aSqlParameterlist, string dataBaseName)
        {
            int pk = 0;

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            {
                var dp = ToDynamicParameters(aSqlParameterlist);
                dp.Add("@ID", dbType: DbType.Int32, direction: ParameterDirection.Output, size: 20);

                if (connection.Execute(queryString + "; SELECT @ID = SCOPE_IDENTITY();", dp, commandTimeout: 60, commandType: CommandType.Text) > 0)
                    pk = dp.Get<int?>("@ID") ?? 0;
            }

            return pk;
        }


        internal bool SaveDataByInsertCommand(string queryString)
        {
            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            {
                return connection.Execute(
                    "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 60, commandType: CommandType.StoredProcedure) > 0;
            }
        }


        internal bool UpdateDataByUpdateCommandNew(string queryString, List<SqlParameter> aSqlParameterlist)
        {
            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            {
                return connection.Execute(
                    queryString, ToDynamicParameters(aSqlParameterlist), commandTimeout: 60, commandType: CommandType.Text) > 0;
            }
        }

        internal bool UpdateDataByUpdateCommand(string queryString)
        {
            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            {
                return connection.Execute(
                    "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure) > 0;
            }
        }

        internal void LoadDropDownValue(DropDownList ddl, string displayField, string valueField, string queryString, string dataBaseName)
        {
            DataTable dt = new DataTable();

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 60, commandType: CommandType.StoredProcedure))
            {
                dt.Load(reader);
            }

            ddl.DataTextField = displayField;
            ddl.DataValueField = valueField;
            ddl.DataSource = dt;
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("--------Select---------", string.Empty));
            ddl.SelectedIndex = 0;
        }

        internal IDataReader DataContainerDataReader(string queryString, string dataBaseName)
        {
            var connection = new SqlConnection(ConnStr(dataBaseName));

            return connection.ExecuteReader(
                "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure);
        }

        internal DataTable DataContainerDataTable(string queryString, string dataBaseName)
        {
            DataTable table = new DataTable();

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 90, commandType: CommandType.StoredProcedure))
            {
                table.Load(reader);
            }

            return table;
        }

        internal DataTable DataContainerDataTable(string queryString, List<SqlParameter> parameters, string dataBaseName)
        {
            DataTable table = new DataTable();

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                queryString, ToDynamicParameters(parameters), commandTimeout: 90, commandType: CommandType.Text))
            {
                table.Load(reader);
            }

            return table;
        }

        internal bool SaveDataByInsertCommand(string queryString, string dataBaseName)
        {
            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            {
                return connection.Execute(
                    "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure) > 0;
            }
        }

        internal bool SaveDataByInsertCommand(string queryString, List<SqlParameter> parameters, string dataBaseName)
        {
            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            {
                return connection.Execute(
                    queryString, ToDynamicParameters(parameters), commandTimeout: 60, commandType: CommandType.Text) > 0;
            }
        }

        internal bool UpdateAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist)
        {
            try
            {
                ActionStatus =
                    Convert.ToBoolean(ExecuteNonQueryAction(StoreProcedureName, SqlParameterlist, string.Empty, false));
            }
            catch (Exception ex)
            {

                ActionStatus = false;
            }

            return ActionStatus;
        }

        internal bool UpdateDataByUpdateCommand(string queryString, string dataBaseName)
        {
            try
            {
                using (var connection = new SqlConnection(ConnStr(dataBaseName)))
                {
                    return connection.Execute(
                        "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure) > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        internal bool DeleteDataByDeleteCommand(string queryString)
        {
            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            {
                return connection.Execute(
                    "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure) > 0;
            }
        }


        internal bool DeleteDataByDeleteCommand(string queryString, string dataBaseName)
        {
            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            {
                return connection.Execute(
                    "ExecuteAllSqlQueryByStoreProcedure", new { Query = queryString }, commandTimeout: 99000000, commandType: CommandType.StoredProcedure) > 0;
            }
        }

        internal int RunStoreProcedure(string sp, List<SqlParameter> aSqlParameterlist, string dataBaseName)
        {
            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            {
                return connection.Execute(
                    sp, ToDynamicParameters(aSqlParameterlist), commandTimeout: 99000000, commandType: CommandType.StoredProcedure) > 0 ? 1 : 0;
            }
        }

        // Like RunStoreProcedure, but reads back a BIT OUTPUT parameter instead of trusting
        // rows-affected as a success signal (rows-affected is unusable for procs with multiple
        // INSERT/UPDATE statements and SET NOCOUNT ON).
        internal bool RunStoreProcedureWithSuccessOutput(string sp, List<SqlParameter> aSqlParameterlist, string outputParameterName, string dataBaseName)
        {
            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            {
                var dp = ToDynamicParameters(aSqlParameterlist);
                connection.Execute(sp, dp, commandTimeout: 99000000, commandType: CommandType.StoredProcedure);
                return dp.Get<bool?>(outputParameterName) ?? false;
            }
        }

        // SP Insert Method
        bool ActionStatus;
        internal int SaveAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist,
            string PrimaryKeyParameter)
        {
            int pk = 0;
            try
            {
                pk = ExecuteNonQueryAction(StoreProcedureName, SqlParameterlist, PrimaryKeyParameter, true);
            }
            catch (Exception ex)
            {
                pk = 0;
            }
            return pk;
        }

        private int ExecuteNonQueryAction(string storeProcedureName, List<SqlParameter> sqlParameterList,
                                     string primaryKeyParameter, bool isPrimaryKey)
        {
            int pk = 0;

            using (var connection = new SqlConnection(ConnStr("SSIDB")))
            {
                var dp = ToDynamicParameters(sqlParameterList);
                if (isPrimaryKey && !string.IsNullOrEmpty(primaryKeyParameter))
                    dp.Add(primaryKeyParameter, dbType: DbType.Int32, direction: ParameterDirection.Output, size: 10);

                if (connection.Execute(storeProcedureName, dp, commandTimeout: 60, commandType: CommandType.StoredProcedure) > 0)
                {
                    pk = (isPrimaryKey && !string.IsNullOrEmpty(primaryKeyParameter))
                        ? dp.Get<int?>(primaryKeyParameter) ?? 0
                        : 1;
                }
                else
                {
                    pk = 0;
                }
            }

            return pk;
        }


        internal DataTable GetDataTableAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist, string dataBaseName)
        {
            DataTable dt = new DataTable();

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                StoreProcedureName, ToDynamicParameters(SqlParameterlist), commandTimeout: 99000000, commandType: CommandType.StoredProcedure))
            {
                dt.Load(reader);
            }

            return dt;
        }

        internal DataTable GetDataTableUsingReader(string storeProcedureName, List<SqlParameter> sqlParameterList, string dataBaseName)
        {
            DataTable dt = new DataTable();

            using (var connection = new SqlConnection(ConnStr(dataBaseName)))
            using (var reader = (DbDataReader)connection.ExecuteReader(
                storeProcedureName, ToDynamicParameters(sqlParameterList), commandTimeout: 99000000, commandType: CommandType.StoredProcedure))
            {
                dt.Load(reader);
            }

            return dt;
        }


    }
}
