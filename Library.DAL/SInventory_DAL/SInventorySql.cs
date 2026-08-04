using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Dapper;

namespace Library.DAL.SInventory_DAL
{
    internal static class SInventorySql
    {
        internal static object DbValue(object value)
        {
            return value ?? DBNull.Value;
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

        internal static DataTable GetDataTable(string query, List<SqlParameter> parameters)
        {
            DataAccessManager accessManager = new DataAccessManager();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                return accessManager.GetDataTableByText(query, parameters);
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        internal static bool Exists(string query, List<SqlParameter> parameters)
        {
            return GetDataTable(query, parameters).Rows.Count > 0;
        }

        internal static bool Execute(string query, List<SqlParameter> parameters)
        {
            ClsCommonInternalDAL commonInternalDal = new ClsCommonInternalDAL();
            return commonInternalDal.UpdateDataByUpdateCommandNew(query, parameters);
        }

        /// Executes a write against the caller-supplied connection/transaction so it
        /// participates in the caller's atomic unit of work instead of auto-committing on its own.
        internal static bool Execute(string query, List<SqlParameter> parameters, SqlTransaction transaction)
        {
            if (transaction == null)
            {
                return Execute(query, parameters);
            }

            return transaction.Connection.Execute(query, ToDynamicParameters(parameters), transaction) > 0;
        }

        internal static DataTable GetDataTable(string query, List<SqlParameter> parameters, SqlTransaction transaction)
        {
            if (transaction == null)
            {
                return GetDataTable(query, parameters);
            }

            DataTable dt = new DataTable();
            using (var reader = (System.Data.Common.DbDataReader)transaction.Connection.ExecuteReader(
                query, ToDynamicParameters(parameters), transaction))
            {
                dt.Load(reader);
            }
            return dt;
        }
    }
}
