using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class ProductDiscountDAL
    {
        public bool SaveProductDiscount(ProductDiscount aProductDiscount)
        {
            string insertQuery = @"insert into tblProductDiscount (DiscountId,ProductCode,CustomerMasterId,DiscountPercentage,Status,ActiveDate,InactiveDate) 
            values (@DiscountId,@ProductCode,@CustomerMasterId,@DiscountPercentage,@Status,@ActiveDate,@InactiveDate)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@DiscountId", aProductDiscount.DiscountId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aProductDiscount.ProductCode)),
                new SqlParameter("@CustomerMasterId", aProductDiscount.CustomerMasterId),
                new SqlParameter("@DiscountPercentage", aProductDiscount.DiscountPercentage),
                new SqlParameter("@Status", SInventorySql.DbValue(aProductDiscount.Status)),
                new SqlParameter("@ActiveDate", aProductDiscount.ActiveDate),
                new SqlParameter("@InactiveDate", aProductDiscount.InactiveDate)
            });
        }

        public bool HasProductDiscountName(ProductDiscount aProductDiscount)
        {
            string query = "select * from tblProductDiscount where ProductCode = @ProductCode";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aProductDiscount.ProductCode))
            });
        }

        public DataTable LoadProductDiscount()
        {
            string query = @"SELECT * from tblProductDiscount
            LEFT JOIN dbo.tblCustMaster ON dbo.tblProductDiscount.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
            LEFT JOIN dbo.tblProduct ON dbo.tblProductDiscount.ProductCode=dbo.tblProduct.ProductCode";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }
        public DataTable LoadProductDiscount(string fromdate,string todate)
        {
            string query = @"SELECT (MIACode+'-'+MIAName)MIAName,* from tblProductDiscount
            LEFT JOIN dbo.tblCustMaster ON dbo.tblProductDiscount.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
            LEFT JOIN dbo.tblProduct ON dbo.tblProductDiscount.ProductCode=dbo.tblProduct.ProductCode WHERE ActiveDate BETWEEN @FromDate AND @ToDate";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", SInventorySql.DbValue(fromdate)),
                new SqlParameter("@ToDate", SInventorySql.DbValue(todate))
            });
        }
        public void LoadCustomerMaster(DropDownList ddl,string marketId)
        {
            string queryStr = "SELECT * FROM dbo.tblCustMaster WHERE CustomerMasterId IN (SELECT DISTINCT CustomerMasterId FROM dbo.View_CustomerMaster WHERE MarketId=@MarketId)";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@MarketId", SInventorySql.DbValue(marketId))
            });
            ddl.DataTextField = "CustomerName";
            ddl.DataValueField = "CustomerMasterId";
            ddl.DataBind();
        }
        public void LoadSalesCenter(DropDownList ddl)
        {
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>());
            ddl.DataTextField = "ComUnitName";
            ddl.DataValueField = "ComUnitId";
            ddl.DataBind();
        }
        public void LoadArea(DropDownList ddl,string comUnitId)
        {
            string queryStr = "SELECT * FROM dbo.tblArea WHERE AreaId IN (SELECT AreaId FROM dbo.View_CustomerMaster WHERE ComUnitId=@ComUnitId)";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId))
            });
            ddl.DataTextField = "AreaName";
            ddl.DataValueField = "AreaId";
            ddl.DataBind();
        }
        public void LoadMarket(DropDownList ddl, string areaId)
        {
            string queryStr = "SELECT * FROM dbo.tblMarket WHERE MarketId IN (SELECT DISTINCT MarketId FROM dbo.View_CustomerMaster WHERE AreaId=@AreaId)";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@AreaId", SInventorySql.DbValue(areaId))
            });
            ddl.DataTextField = "MarketName";
            ddl.DataValueField = "MarketId";
            ddl.DataBind();
        }
        

        public ProductDiscount ProductDiscountEditLoad(string ID)
        {
            string query = "select * from tblProductDiscount where DiscountId = @DiscountId";
            DataTable discountTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DiscountId", SInventorySql.DbValue(ID))
            });
            ProductDiscount aProductDiscount = new ProductDiscount();
            if (discountTable.Rows.Count > 0)
            {
                DataRow discountRow = discountTable.Rows[0];
                aProductDiscount.DiscountId = Int32.Parse(discountRow["DiscountId"].ToString());
                aProductDiscount.ProductCode = discountRow["ProductCode"].ToString();
                aProductDiscount.CustomerMasterId = Convert.ToInt32(discountRow["CustomerMasterId"].ToString());
                aProductDiscount.DiscountPercentage = Convert.ToDecimal(discountRow["DiscountPercentage"].ToString());
                aProductDiscount.Status = discountRow["Status"].ToString();
                aProductDiscount.ActiveDate = Convert.ToDateTime(discountRow["ActiveDate"].ToString());
                aProductDiscount.InactiveDate = Convert.ToDateTime(discountRow["InactiveDate"].ToString());
            }
            return aProductDiscount;
        }

        public bool UpdateProductDiscountInfo(ProductDiscount aProductDiscount)
        {
            string query = @"UPDATE tblProductDiscount SET ProductCode=@ProductCode,CustomerMasterId=@CustomerMasterId,DiscountPercentage=@DiscountPercentage,ActiveDate=@ActiveDate,InactiveDate=@InactiveDate WHERE DiscountId=@DiscountId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aProductDiscount.ProductCode)),
                new SqlParameter("@CustomerMasterId", aProductDiscount.CustomerMasterId),
                new SqlParameter("@DiscountPercentage", aProductDiscount.DiscountPercentage),
                new SqlParameter("@ActiveDate", aProductDiscount.ActiveDate),
                new SqlParameter("@InactiveDate", aProductDiscount.InactiveDate),
                new SqlParameter("@DiscountId", aProductDiscount.DiscountId)
            });
        }
    }
}
