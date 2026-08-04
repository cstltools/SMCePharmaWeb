using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Dapper;

namespace Library.DAL.DataManager
{
    public class DataAccessManagerOld
    {
        private SqlConnection sqlConnection = null;
        private SqlCommand sqlCommand = null;
        private SqlDataReader sqlDataReader = null;
        private SqlTransaction sqlTransaction = null;
        private SqlDataAdapter sqlDataAdapter = null;
        private const int CommandTimeout = 199000000;
        private bool isException;
        private bool returnValue = true;
        private string ConnectionString(string database)
        {
            return @"data source=" + SqlUserAccess.DataSource + ";Initial Catalog=" + database +
                   ";Integrated Security=false; User Id=" +
                   SqlUserAccess.UserName + "; password=" + SqlUserAccess.PassWord + "; MultipleActiveResultSets=True;";

            //return @"data source=" + SqlUserAccess.DataSource + ";Initial Catalog=" + database +
            //";Integrated Security=true;";
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
        public bool SqlConnectionOpen(string database)
        {
            try
            {
                sqlConnection = new SqlConnection(ConnectionString(database));

                if (sqlConnection.State != ConnectionState.Open)
                {
                    sqlConnection.Open();
                    // Transaction is started lazily on first write (see ExecuteNonQueryData),
                    // not here, so read-only calls don't hold locks for the whole page lifecycle.
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
                    if (sqlCommand != null) sqlCommand.Dispose();
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
        public SqlDataReader GetSqlDataReader(string StoreProcedure, bool IsBigData = false)
        {
            try
            {
                sqlCommand = new SqlCommand
                {
                    Connection = sqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = StoreProcedure,
                    Transaction = sqlTransaction,
                    CommandTimeout = 199000000
                };
                if (IsBigData)
                {
                    sqlCommand.CommandTimeout = CommandTimeout;
                }

                sqlDataReader = sqlCommand.ExecuteReader();
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
        public SqlDataReader GetSqlDataReader(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                sqlCommand = new SqlCommand
                {
                    Connection = sqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = StoreProcedure,
                    Transaction = sqlTransaction,
                    CommandTimeout = 199000000
                };

                sqlCommand.Parameters.Clear();
                sqlCommand.Parameters.AddRange(SqlParameterList.ToArray());
                if (IsBigData)
                {
                    sqlCommand.CommandTimeout = CommandTimeout;
                }



                sqlDataReader = sqlCommand.ExecuteReader();
                sqlCommand.Parameters.Clear();
            }
            catch (SqlException sqlException)
            {
                isException = true;
                sqlDataReader = null;
                throw sqlException;
            }
            finally
            {
                sqlCommand.Parameters.Clear();
                sqlCommand.Dispose();
                if (isException)
                {
                    SqlConnectionClose(true);
                }

            }
            return sqlDataReader;
        }



        public DataTable GetDataTable(string StoreProcedure, bool IsBigData = false)
        {
            return GetDataTable(StoreProcedure, (List<SqlParameter>)null, IsBigData);
        }
        public DataTable GetDataTable(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            DataTable dt = new DataTable();

            try
            {
                int timeout = IsBigData ? CommandTimeout : 199000000;
                using (var reader = (System.Data.Common.DbDataReader)sqlConnection.ExecuteReader(
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
        public DataSet GetDataSet(string StoreProcedure, bool IsBigData = false)
        {
            return GetDataSet(StoreProcedure, (List<SqlParameter>)null, IsBigData);
        }
        public DataSet GetDataSet(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            DataSet ds = new DataSet();
            try
            {
                int timeout = IsBigData ? CommandTimeout : 199000000;
                using (var reader = (System.Data.Common.DbDataReader)sqlConnection.ExecuteReader(
                    StoreProcedure, ToDynamicParameters(SqlParameterList), sqlTransaction, timeout, CommandType.StoredProcedure))
                {
                    do
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        ds.Tables.Add(dt);
                    } while (!reader.IsClosed && reader.NextResult());
                }
            }
            catch (SqlException sqlException)
            {
                isException = true;
                ds = null;
                throw sqlException;
            }
            finally
            {
                if (isException)
                {
                    SqlConnectionClose(true);
                }

            }
            return ds;
        }
        private int ExecuteNonQueryData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsPrimaryKey = true, bool IsBigData = false)
        {
            int primaryKey = 0;
            try
            {
                if (sqlTransaction == null)
                {
                    sqlTransaction = sqlConnection.BeginTransaction();
                }

                int? timeout = IsBigData ? CommandTimeout : (int?)null;
                var scalar = sqlConnection.ExecuteScalar(
                    StoreProcedure, ToDynamicParameters(SqlParameterList), sqlTransaction, timeout, CommandType.StoredProcedure);
                primaryKey = Convert.ToInt32(scalar);
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
        public int SaveDataReturnPrimaryKey(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            int primaryKey = 0;
            try
            {
                primaryKey = ExecuteNonQueryData(StoreProcedure, SqlParameterList, true, IsBigData);
            }
            catch (SqlException sqlException)
            {
                throw sqlException;
            }
            return primaryKey;
        }
        private bool ExecuteNonQueryData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                if (sqlTransaction == null)
                {
                    sqlTransaction = sqlConnection.BeginTransaction();
                }

                int timeout = IsBigData ? CommandTimeout : 199000000;
                sqlConnection.Execute(
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
        public bool SaveData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                returnValue = ExecuteNonQueryData(StoreProcedure, SqlParameterList, IsBigData);
            }
            catch (SqlException sqlException)
            {
                returnValue = false;
                throw sqlException;
            }
            return returnValue;
        }
        /// <summary>
        /// After Updating Data a Boolean will be Returned
        /// </summary>
        /// <param name="StoreProcedure"></param>
        /// <param name="SqlParameterList"></param>
        /// <returns></returns>
        public bool UpdateData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                returnValue = ExecuteNonQueryData(StoreProcedure, SqlParameterList, IsBigData);
            }
            catch (SqlException sqlException)
            {
                returnValue = false;
                throw sqlException;
            }
            return returnValue;
        }
        /// <summary>
        /// After Deleting Data a Boolean will be Returned
        /// </summary>
        /// <param name="StoreProcedure"></param>
        /// <param name="SqlParameterList"></param>
        /// <returns></returns>
        public bool DeleteData(string StoreProcedure, List<SqlParameter> SqlParameterList, bool IsBigData = false)
        {
            try
            {
                returnValue = ExecuteNonQueryData(StoreProcedure, SqlParameterList, IsBigData);
            }
            catch (SqlException sqlException)
            {
                returnValue = false;
                throw sqlException;
            }
            return returnValue;
        }

        //public IEnumerable<Dictionary<string, object>> Serialize(SqlDataReader reader)
        //{
        //    var results = new List<Dictionary<string, object>>();
        //    var cols = new List<string>();
        //    for (var i = 0; i < reader.FieldCount; i++)
        //        cols.Add(reader.GetName(i));

        //    while (reader.Read())
        //        results.Add(SerializeRow(cols, reader));

        //    return results;
        //}

        public List<Dictionary<string, object>> Serialize(SqlDataReader dr)
        {
            var results = new List<Dictionary<string, object>>();
            while (dr.Read())
            {
                var row = new Dictionary<string, object>();
                for (int i = 0; i < dr.FieldCount; i++)
                {
                    var key = dr.GetName(i);
                    if (!row.ContainsKey(key)) // Ensure unique keys
                    {
                        row[key] = dr.IsDBNull(i) ? null : dr.GetValue(i);
                    }
                }
                results.Add(row);
            }
            return results;
        }

        private Dictionary<string, object> SerializeRow(IEnumerable<string> cols,
            SqlDataReader reader)
        {
            var result = new Dictionary<string, object>();
            foreach (var col in cols)
                result.Add(col, reader[col]);
            return result;
        }

    }
}