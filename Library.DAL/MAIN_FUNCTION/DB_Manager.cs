using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Dapper;

namespace Library.DAL.MAIN_FUNCTION
{
    internal class DB_Manager
    {
        SqlTransaction dbTransaction;
        SqlConnection dbConnection;
        private IDataReader dataReader;
        private DataTable dt;
        private DataSet ds;
        bool ActionStatus;

        internal void CreateConnection(string DataBaseName)
        {
            dbConnection = new SqlConnection(DB_Connection.GenerateString(DataBaseName));
            if (dbConnection.State != ConnectionState.Open)
            {
                dbConnection.Open();
                // Transaction is started lazily on first write (see ExecuteNonQueryAction),
                // not here, so read-only calls don't hold locks for the whole page lifecycle.
            }
        }

        internal void CloseConnection()
        {
            if (dbConnection.State == ConnectionState.Open)
            {
                if (dbTransaction != null)
                {
                    dbTransaction.Commit();
                    dbTransaction.Dispose();
                }

                dbConnection.Close();
            }
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

        private int ExecuteNonQueryAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist,
            string PrimaryKeyParameter, bool IsPrimaryKey)
        {

            int pk = 0;
            try
            {
                if (dbTransaction == null)
                {
                    dbTransaction = dbConnection.BeginTransaction();
                }

                var dp = ToDynamicParameters(SqlParameterlist);
                if (IsPrimaryKey)
                {
                    dp.Add(PrimaryKeyParameter, dbType: DbType.Int32, direction: ParameterDirection.Output, size: 10);
                    if (dbConnection.Execute(StoreProcedureName, dp, dbTransaction, 12000000, CommandType.StoredProcedure) > 0)
                    {
                        pk = dp.Get<int?>(PrimaryKeyParameter) ?? 0;
                    }
                    else
                    {
                        pk = 0;
                    }
                }
                else
                {
                    if (dbConnection.Execute(StoreProcedureName, dp, dbTransaction, 12000000, CommandType.StoredProcedure) > 0)
                    {
                        pk = 1;
                    }
                    else
                    {
                        pk = 0;
                    }
                }
            }
            catch (Exception ex)
            {
                if (dbTransaction != null)
                {
                    dbTransaction.Rollback();
                }
                dbConnection.Close();
            }
            return pk;
        }

        internal bool SaveAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist)
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

        internal DataTable GetDataTableAction(string StoreProcedureName)
        {
            dt = new DataTable();
            try
            {
                using (var reader = (System.Data.Common.DbDataReader)dbConnection.ExecuteReader(
                    StoreProcedureName, transaction: dbTransaction, commandTimeout: 12000000, commandType: CommandType.StoredProcedure))
                {
                    dt.Load(reader);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        internal DataTable GetDataTableAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist)
        {
            dt = new DataTable();

            try
            {
                using (var reader = (System.Data.Common.DbDataReader)dbConnection.ExecuteReader(
                    StoreProcedureName, ToDynamicParameters(SqlParameterlist), dbTransaction, 12000000, CommandType.StoredProcedure))
                {
                    dt.Load(reader);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
        //internal void LoadAction(RadioButtonList rdl)
        //{
        //    string query = @"select * from tblAction where IsShow=1 ";
        //    CreateConnection(DB_Names.CSTLUA_DB);
        //    DataTable dtAction = GetDataTableAction("sp_GET_GetActionName");
        //    CloseConnection();
        //    rdl.DataSource = dtAction;
        //    rdl.DataTextField = "ActionText";
        //    rdl.DataValueField = "ActionId";
        //    rdl.DataBind();

        //}
        internal DataSet GetDataSetAction(string StoreProcedureName)
        {
            ds = new DataSet();
            try
            {
                using (var reader = (System.Data.Common.DbDataReader)dbConnection.ExecuteReader(
                    StoreProcedureName, transaction: dbTransaction, commandTimeout: 12000000, commandType: CommandType.StoredProcedure))
                {
                    do
                    {
                        var table = new DataTable();
                        table.Load(reader);
                        ds.Tables.Add(table);
                    } while (!reader.IsClosed && reader.NextResult());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return ds;
        }

        internal DataSet GetDataSetAction(string StoreProcedureName, List<SqlParameter> SqlParameterlist)
        {
            ds = new DataSet();
            try
            {
                using (var reader = (System.Data.Common.DbDataReader)dbConnection.ExecuteReader(
                    StoreProcedureName, ToDynamicParameters(SqlParameterlist), dbTransaction, 12000000, CommandType.StoredProcedure))
                {
                    do
                    {
                        var table = new DataTable();
                        table.Load(reader);
                        ds.Tables.Add(table);
                    } while (!reader.IsClosed && reader.NextResult());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return ds;
        }

        internal IDataReader GetDataReaderAction(string StoreProcedure, List<SqlParameter> SqlParameterlist,
            string DataBaseName)
        {
            try
            {
                dataReader = dbConnection.ExecuteReader(
                    StoreProcedure, ToDynamicParameters(SqlParameterlist), dbTransaction, 12000000, CommandType.StoredProcedure);
                return dataReader;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void LoadDropDownListData(DropDownList dropDownList, string DisplayField, string ValueField, string StoreProcedure, List<SqlParameter> SqlParameterlist)
        {
            try
            {
                DataTable dataDDL = new DataTable();
                dataDDL = GetDataTableAction(StoreProcedure, SqlParameterlist);
                dropDownList.DataTextField = DisplayField;
                dropDownList.DataValueField = ValueField;
                dropDownList.DataSource = dataDDL;
                dropDownList.DataBind();
                dropDownList.Items.Insert(0, new ListItem("Select--------------------", String.Empty));
                dropDownList.SelectedIndex = 0;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

        public void LoadDropDownListData(DropDownList dropDownList, string DisplayField, string ValueField, string StoreProcedure)
        {
            try
            {
                DataTable dataDDL = new DataTable();
                dataDDL = GetDataTableAction(StoreProcedure);
                dropDownList.DataTextField = DisplayField;
                dropDownList.DataValueField = ValueField;
                dropDownList.DataSource = dataDDL;
                dropDownList.DataBind();
                dropDownList.Items.Insert(0, new ListItem("Select--------------------", String.Empty));
                dropDownList.SelectedIndex = 0;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

    }
}
