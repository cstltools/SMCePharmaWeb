using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Library.DAL.SInventory_DAL
{
    public class ProformaPrintListDal
    {
        private static readonly Regex InvoiceDateRegex = new Regex(
            @"InvoiceDate\s+BETWEEN\s+'(?<from>[^']*)'\s+AND\s+'(?<to>[^']*)'",
            RegexOptions.IgnoreCase | RegexOptions.Compiled);

        private static readonly Regex ComUnitRegex = new Regex(
            @"I\.ComUnitId\s*=\s*'(?<value>[^']*)'",
            RegexOptions.IgnoreCase | RegexOptions.Compiled);

        private static readonly Regex ManufacRegex = new Regex(
            @"tblD\.ManufacId\s*=\s*'(?<value>[^']*)'",
            RegexOptions.IgnoreCase | RegexOptions.Compiled);

        private static readonly Regex MarketRegex = new Regex(
            @"tblMarket\.MarketId\s*=\s*'(?<value>[^']*)'",
            RegexOptions.IgnoreCase | RegexOptions.Compiled);

        private static string BuildFilterClause(string pram, List<SqlParameter> parameters)
        {
            List<string> filters = new List<string>();
            string filterText = pram ?? string.Empty;

            Match invoiceDateMatch = InvoiceDateRegex.Match(filterText);
            if (invoiceDateMatch.Success)
            {
                filters.Add("InvoiceDate BETWEEN @InvoiceDateFrom AND @InvoiceDateTo");
                parameters.Add(new SqlParameter("@InvoiceDateFrom", SInventorySql.DbValue(invoiceDateMatch.Groups["from"].Value)));
                parameters.Add(new SqlParameter("@InvoiceDateTo", SInventorySql.DbValue(invoiceDateMatch.Groups["to"].Value)));
            }

            AddFilter(filters, parameters, ComUnitRegex, filterText, "I.ComUnitId", "@ComUnitId");
            AddFilter(filters, parameters, ManufacRegex, filterText, "tblD.ManufacId", "@ManufacId");
            AddFilter(filters, parameters, MarketRegex, filterText, "tblMarket.MarketId", "@MarketId");

            return filters.Count == 0 ? string.Empty : " WHERE " + string.Join(" AND ", filters);
        }

        private static void AddFilter(List<string> filters, List<SqlParameter> parameters, Regex regex, string filterText, string columnName, string parameterName)
        {
            Match match = regex.Match(filterText);
            if (!match.Success)
            {
                return;
            }

            filters.Add(columnName + " = " + parameterName);
            parameters.Add(new SqlParameter(parameterName, SInventorySql.DbValue(match.Groups["value"].Value)));
        }

        public DataTable LoadInvoice(string pram)
        {
            string query = @"SELECT  * 				
        FROM tblInvoice I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
                    INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode ";

            List<SqlParameter> parameters = new List<SqlParameter>();
            query += BuildFilterClause(pram, parameters) + " order by OrderNo";

            return SInventorySql.GetDataTable(query, parameters);
        }

        public DataTable LoadInvoiceSubdeport(string pram)
        {
            string query = @"SELECT  * 				
        FROM tblSubInvoiceMaster I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
                    INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode ";

            List<SqlParameter> parameters = new List<SqlParameter>();
            query += BuildFilterClause(pram, parameters) + " order by OrderNo";

            return SInventorySql.GetDataTable(query, parameters);
        }
    }
}
