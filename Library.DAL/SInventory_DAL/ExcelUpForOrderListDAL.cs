using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class ExcelUpForOrderListDAL
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public void LoadmanufacturerName(DropDownList ddl)
        {
            string queryStr = "select * from tblManufacturer";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public bool XLDataGridToDbByRow(String SalesCentre, String SalesCentreName, String MIOName, String TerritoryCode, String FECode,
                                                        String DZSMCode, String CustomerID, String CustomerName, String ProductCode, String ProductName, decimal OrderQty, decimal GrossValue, String OrderCode, DateTime SubmissionDate,
                                                       String MIOCode, int OrderMasterID)
        {
            string insertQuery = @"insert into tblOrderListDetail (OrderMasterID,SalesCentre, SalesCentreName, MIOName, TerritoryCode, FECode,DZSMCode, CustomerID, CustomerName, ProductCode, ProductName, OrderQty, GrossValue, OrderCode, SubmissionDate,MIOCode) 
            values (@OrderMasterID,@SalesCentre,@SalesCentreName,@MIOName,@TerritoryCode,@FECode,@DZSMCode,@CustomerID,@CustomerName,@ProductCode,@ProductName,@OrderQty,@GrossValue,@OrderCode,@SubmissionDate,@MIOCode)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@OrderMasterID", OrderMasterID),
                new SqlParameter("@SalesCentre", SInventorySql.DbValue(SalesCentre)),
                new SqlParameter("@SalesCentreName", SInventorySql.DbValue(SalesCentreName)),
                new SqlParameter("@MIOName", SInventorySql.DbValue(MIOName)),
                new SqlParameter("@TerritoryCode", SInventorySql.DbValue(TerritoryCode)),
                new SqlParameter("@FECode", SInventorySql.DbValue(FECode)),
                new SqlParameter("@DZSMCode", SInventorySql.DbValue(DZSMCode)),
                new SqlParameter("@CustomerID", SInventorySql.DbValue(CustomerID)),
                new SqlParameter("@CustomerName", SInventorySql.DbValue(CustomerName)),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(ProductName)),
                new SqlParameter("@OrderQty", OrderQty),
                new SqlParameter("@GrossValue", GrossValue),
                new SqlParameter("@OrderCode", SInventorySql.DbValue(OrderCode)),
                new SqlParameter("@SubmissionDate", SubmissionDate),
                new SqlParameter("@MIOCode", SInventorySql.DbValue(MIOCode))
            });
        }
        public bool SaveOrderDAL(OrderListMasterDAO aOrderListMasterDAO)
        {
            string insertQuery = @"insert into tblOrderListMaster (OrderMasterID,ManufacId,DocumentDate,GenerateOrder,EntryBy,EntryDate) 
            values (@OrderMasterID,@ManufacId,@DocumentDate,@GenerateOrder,@EntryBy,@EntryDate)";
                                 

            return SInventorySql.Execute(insertQuery, OrderListMasterParameters(aOrderListMasterDAO));
        }
        public DataTable LoadOrder()
        {
            string query = @"SELECT TOP 10 * FROM dbo.tblOrderListMaster
                INNER JOIN dbo.tblManufacturer ON tblOrderListMaster.ManufacId = tblManufacturer.ManufacId
                where GenerateOrder=0 
                ORDER BY DocumentDate DESC ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadMigobyID(int OrderMasterID)
        {
            string query = @"SELECT GenerateOrder,OrderMasterID FROM dbo.tblOrderListMaster
           INNER JOIN dbo.tblManufacturer ON tblOrderListMaster.ManufacId = tblManufacturer.ManufacId
           where OrderMasterID = @OrderMasterID";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderMasterID", OrderMasterID)
            });
        }
        public bool DeleteData(int OrderMasterID)
        {
            string query = @"DELETE FROM dbo.tblOrderListMaster WHERE OrderMasterID = @OrderMasterID";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderMasterID", OrderMasterID)
            });
        }
        public bool DeleteDetailData(int OrderMasterID)
        {
            string query = @"DELETE FROM dbo.tblOrderListDetail WHERE OrderMasterID = @OrderMasterID";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderMasterID", OrderMasterID)
            });
        }

        public DataTable LoadOrder(string id)
        {
            string query = @"SELECT * FROM dbo.tblOrderListDetail
                
                WHERE OrderMasterID = @OrderMasterID";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderMasterID", SInventorySql.DbValue(id))
            });
        }
        public DataTable LoadMigoDate(string parameter)
        {
            List<SqlParameter> parameters;
            string filter = BuildOrderDateFilter(parameter, out parameters);
            string query = @"SELECT  * FROM dbo.tblOrderListMaster  left JOIN dbo.tblManufacturer ON tblOrderListMaster.ManufacId = tblManufacturer.ManufacId Where GenerateOrder=0" + filter;
            return SInventorySql.GetDataTable(query, parameters);
        }

        public int TransfarOrderID_DAL(int id)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderMasterID_In", id));
            return aCommonInternalDal.RunStoreProcedure("sp_OrderGenerationFromUploadOrder", aSqlParameterList, "SSIDB");
        }

        private static List<SqlParameter> OrderListMasterParameters(OrderListMasterDAO orderListMaster)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@OrderMasterID", orderListMaster.OrderMasterID),
                new SqlParameter("@ManufacId", orderListMaster.ManufacId),
                new SqlParameter("@DocumentDate", orderListMaster.DocumentDate),
                new SqlParameter("@GenerateOrder", orderListMaster.GenerateOrder),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(orderListMaster.EntryBy)),
                new SqlParameter("@EntryDate", orderListMaster.EntryDate)
            };
        }

        private static string BuildOrderDateFilter(string parameter, out List<SqlParameter> parameters)
        {
            parameters = new List<SqlParameter>();
            if (string.IsNullOrWhiteSpace(parameter))
            {
                return string.Empty;
            }

            List<string> values = ExtractQuotedValues(parameter);
            string filter = string.Empty;
            int valueIndex = 0;

            if (parameter.IndexOf("ManufacId", StringComparison.OrdinalIgnoreCase) >= 0 && values.Count > valueIndex)
            {
                filter += " and tblOrderListMaster.ManufacId = @ManufacId";
                parameters.Add(new SqlParameter("@ManufacId", SInventorySql.DbValue(values[valueIndex])));
                valueIndex++;
            }

            if (parameter.IndexOf("DocumentDate", StringComparison.OrdinalIgnoreCase) >= 0 && values.Count >= valueIndex + 2)
            {
                filter += " and DocumentDate between @FromDate and @ToDate";
                parameters.Add(new SqlParameter("@FromDate", SInventorySql.DbValue(values[valueIndex])));
                parameters.Add(new SqlParameter("@ToDate", SInventorySql.DbValue(values[valueIndex + 1])));
            }

            return filter;
        }

        private static List<string> ExtractQuotedValues(string parameter)
        {
            List<string> values = new List<string>();
            if (string.IsNullOrWhiteSpace(parameter))
            {
                return values;
            }

            int start = 0;
            while (start < parameter.Length)
            {
                start = parameter.IndexOf("'", start, StringComparison.Ordinal);
                if (start < 0)
                {
                    break;
                }

                int end = parameter.IndexOf("'", start + 1, StringComparison.Ordinal);
                if (end < 0)
                {
                    values.Add(parameter.Substring(start + 1).Trim());
                    break;
                }

                values.Add(parameter.Substring(start + 1, end - start - 1).Trim());
                start = end + 1;
            }

            return values;
        }
    }
}
