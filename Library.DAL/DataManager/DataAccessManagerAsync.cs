using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.Http;
using System.Threading.Tasks;
using Dapper;

using ListItem = System.Web.UI.WebControls.ListItem;
namespace Library.DAL.DataManager
{
    public class DataAccessManagerAsync
    {
        private SqlConnection sqlConnection = null;
        private SqlDataReader sqlDataReader = null;
        private SqlTransaction sqlTransaction = null;
        private const int CommandTimeout = 120000;
        private bool isException;
        private bool returnValue = true;
        private string ConnectionString(string database)
        {
            return @"data source=" + SqlUserAccess.DataSource + ";Initial Catalog=" + database +
                   ";Integrated Security=false; User Id=" +
                   SqlUserAccess.UserName + "; password=" + SqlUserAccess.PassWord + ";";

            //return @"data source=" + SqlUserAccess.DataSource + ";Initial Catalog=" + database +
            //    ";Integrated Security=true;";

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

        public async Task<bool> SqlConnectionOpen(string database)
        {
            try
            {
                sqlConnection = new SqlConnection(ConnectionString(database));

                if (sqlConnection.State != ConnectionState.Open)
                {
                   await sqlConnection.OpenAsync();
                    sqlTransaction = (SqlTransaction)sqlConnection.BeginTransaction();

                }
            }
            catch (SqlException sqlException)
            {
                isException = true;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    returnValue = false;
                }

            }
            return returnValue;
        }

        public bool SqlConnectionClose(bool IsRollBack = false)
        {
            try
            {
                if (sqlConnection.State == ConnectionState.Open)
                {
                    if (sqlTransaction != null)
                    {
                        if (sqlDataReader != null)
                        {
                            sqlDataReader.Close();

                        }
                        if (IsRollBack)
                        {
                            sqlTransaction.Rollback();
                        }
                        else
                        {
                            sqlTransaction.Commit();
                        }
                        sqlTransaction.Dispose();
                    }
                    sqlConnection.Close();
                }

            }
            catch (SqlException sqlException)
            {
                isException = true;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    returnValue = false;
                }

            }

            return returnValue;
        }
        public async Task<SqlDataReader> GetSqlDataReaderAsync(string StoreProcedure, bool IsBigData = false)
        {
            try
            {
                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                sqlDataReader = (SqlDataReader)await sqlConnection.ExecuteReaderAsync(
                    StoreProcedure, transaction: sqlTransaction, commandTimeout: timeout, commandType: CommandType.StoredProcedure);
            }
            catch (SqlException sqlException)
            {
                isException = true;
                sqlDataReader = null;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }

            }
            return sqlDataReader;
        }
        public async Task<SqlDataReader> GetSqlDataReaderAsync(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                sqlDataReader = (SqlDataReader)await sqlConnection.ExecuteReaderAsync(
                    StoreProcedure, ToDynamicParameters(SqlParameterList), sqlTransaction, timeout, CommandType.StoredProcedure);
            }
            catch (SqlException sqlException)
            {
                isException = true;
                sqlDataReader = null;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }

            }
            return sqlDataReader;
        }
        public async Task<DataTable> GetDataTableAsync(string StoreProcedure, bool IsBigData = false)
        {
            DataTable dt = new DataTable();

            try
            {
                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                using (var reader = (System.Data.Common.DbDataReader)await sqlConnection.ExecuteReaderAsync(
                    StoreProcedure, transaction: sqlTransaction, commandTimeout: timeout, commandType: CommandType.StoredProcedure))
                {
                    dt.Load(reader);
                }
            }
            catch (SqlException sqlException)
            {
                isException = true;
                dt = null;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }

            }
            return dt;
        }
        public async Task<DataTable> GetDataTableAsync(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            DataTable dt = new DataTable();

            try
            {
                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                using (var reader = (System.Data.Common.DbDataReader)await sqlConnection.ExecuteReaderAsync(
                    StoreProcedure, ToDynamicParameters(SqlParameterList), sqlTransaction, timeout, CommandType.StoredProcedure))
                {
                    dt.Load(reader);
                }
            }
            catch (SqlException sqlException)
            {
                isException = true;
                dt = null;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }
            }
            return dt;
        }

        private async Task<int> ExecuteNonQueryData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsPrimaryKey = true, bool IsBigData = false)
        {
            int primaryKey = 0;
            try
            {
                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                var result = await sqlConnection.ExecuteScalarAsync(
                    StoreProcedure, ToDynamicParameters(SqlParameterList), sqlTransaction, timeout, CommandType.StoredProcedure);
                primaryKey = Convert.ToInt32(result);
            }
            catch (SqlException sqlException)
            {
                returnValue = false;
                isException = true;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }
            }
            return primaryKey;
        }
        /// <summary>
        /// After Saving Data Only Identity Value will be Returned
        /// </summary>
        /// <param name="StoreProcedure"></param>
        /// <param name="SqlParameterList"></param>
        /// <returns></returns>
        private async Task<bool> ExecuteNonQueryData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                await sqlConnection.ExecuteAsync(
                    StoreProcedure, ToDynamicParameters(SqlParameterList), sqlTransaction, timeout, CommandType.StoredProcedure);
            }
            catch (SqlException sqlException)
            {
                returnValue = false;
                isException = true;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }
            }

            return returnValue;
        }
        /// <summary>
        /// After Saving Data a Boolean will be Returned
        /// </summary>
        /// <param name="StoreProcedure"></param>
        /// <param name="SqlParameterList"></param>
        /// <returns></returns>

    }
}
