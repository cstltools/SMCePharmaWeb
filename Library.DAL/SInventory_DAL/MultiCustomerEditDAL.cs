using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Library.DAL.SInventory_DAL
{
    public class MultiCustomerEditDAL
    {
        private static readonly HashSet<string> SearchColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "RegionCode",
            "ComUnitCode",
            "DistrictCode",
            "AreaCode",
            "MiaCode",
            "MarketCode"
        };

        private static readonly HashSet<string> UpdateColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "RegionCode",
            "ComUnitCode",
            "ComUnitName",
            "DisCode",
            "AreaCode",
            "MIACode",
            "MarketCode",
            "MarketName"
        };

        private static readonly Regex FragmentValueRegex = new Regex(
            @"(?<column>[A-Za-z0-9_]+)\s*=\s*'(?<value>[^']*)'",
            RegexOptions.Compiled);

        public bool UpdateDataForCustomer(string parameter, string customerId)
        {
            List<SqlParameter> parameters;
            string setClause = BuildSetClause(parameter, out parameters);
            if (string.IsNullOrWhiteSpace(setClause))
            {
                return false;
            }

            string insertQuery = @"UPDATE dbo.tblCustMaster SET " + setClause + " WHERE CustomerMasterId=@CustomerMasterId";
            parameters.Add(new SqlParameter("@CustomerMasterId", SInventorySql.DbValue(customerId)));
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public DataTable LoadCusteomer(string parameter)
        {
            List<SqlParameter> parameters;
            string whereClause = BuildWhereClause(parameter, out parameters);
            string query = @"SELECT * FROM dbo.View_CustomerMaster " + whereClause;
            return SInventorySql.GetDataTable(query, parameters);
        }

        public DataTable CHeckInvice(string custimerId)
        {
            string query = @"SELECT * FROM dbo.tblInvoice WHERE CustomerMasterId=@CustomerMasterId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerMasterId", SInventorySql.DbValue(custimerId))
            });
        }

        private static string BuildWhereClause(string fragment, out List<SqlParameter> parameters)
        {
            parameters = new List<SqlParameter>();
            List<string> conditions = new List<string>();

            foreach (Match match in FragmentValueRegex.Matches(fragment ?? string.Empty))
            {
                string column = match.Groups["column"].Value;
                if (!SearchColumns.Contains(column))
                {
                    continue;
                }

                string parameterName = "@p" + parameters.Count;
                conditions.Add(column + "=" + parameterName);
                parameters.Add(new SqlParameter(parameterName, SInventorySql.DbValue(match.Groups["value"].Value)));
            }

            return conditions.Count == 0 ? string.Empty : " WHERE " + string.Join(" AND ", conditions);
        }

        private static string BuildSetClause(string fragment, out List<SqlParameter> parameters)
        {
            parameters = new List<SqlParameter>();
            List<string> assignments = new List<string>();

            foreach (Match match in FragmentValueRegex.Matches(fragment ?? string.Empty))
            {
                string column = match.Groups["column"].Value;
                if (!UpdateColumns.Contains(column))
                {
                    continue;
                }

                string parameterName = "@p" + parameters.Count;
                assignments.Add(column + "=" + parameterName);
                parameters.Add(new SqlParameter(parameterName, SInventorySql.DbValue(match.Groups["value"].Value)));
            }

            return string.Join(",", assignments);
        }
    }
}
