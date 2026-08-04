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
    public class ShippingCartonSizeDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveShippingCartonSize(ShippingCartonSize aShippingCartonSize)
        {
            string insertQuery = @"insert into tblProductCase (CaseId,ProductCode,PcsPerCase,CaseQty) 
            values (@CaseId,@ProductCode,@PcsPerCase,@CaseQty)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CaseId", aShippingCartonSize.CaseId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aShippingCartonSize.ProductCode)),
                new SqlParameter("@PcsPerCase", SInventorySql.DbValue(aShippingCartonSize.PcsPerCase)),
                new SqlParameter("@CaseQty", SInventorySql.DbValue(aShippingCartonSize.CaseQty))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasPcsPerCase(ShippingCartonSize aShippingCartonSize)
        {
            string query = "select top 1 CaseId from tblProductCase where ProductCode = @ProductCode";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aShippingCartonSize.ProductCode))
            };
            return SInventorySql.Exists(query, parameters);
        }
        public void LoadProduct(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblProduct ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ProductName", "ProductCode", queryStr);
        }
        public DataTable LoadShippingCartonSize()
        {
            string query = @"SELECT * from tblProductCase
            LEFT JOIN dbo.tblProduct ON dbo.tblProductCase.ProductCode = dbo.tblProduct.ProductCode ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public ShippingCartonSize ShippingCartonSizeEditLoad(string ID)
        {
            string query = "select * from tblProductCase where CaseId = @CaseId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CaseId", SInventorySql.DbValue(ID))
            };
            DataTable cartonTable = SInventorySql.GetDataTable(query, parameters);
            ShippingCartonSize aShippingCartonSize = new ShippingCartonSize();
            if (cartonTable.Rows.Count > 0)
            {
                DataRow row = cartonTable.Rows[0];
                aShippingCartonSize.CaseId = Int32.Parse(row["CaseId"].ToString());
                aShippingCartonSize.ProductCode = row["ProductCode"].ToString();
                aShippingCartonSize.CaseQty = row["CaseQty"].ToString();
                aShippingCartonSize.PcsPerCase = row["PcsPerCase"].ToString();
            }
            return aShippingCartonSize;
        }

        public bool UpdateShippingCartonSizeInfo(ShippingCartonSize aShippingCartonSize)
        {

            string query = @"UPDATE tblProductCase SET ProductCode=@ProductCode,CaseQty=@CaseQty,PcsPerCase=@PcsPerCase WHERE CaseId=@CaseId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aShippingCartonSize.ProductCode)),
                new SqlParameter("@CaseQty", SInventorySql.DbValue(aShippingCartonSize.CaseQty)),
                new SqlParameter("@PcsPerCase", SInventorySql.DbValue(aShippingCartonSize.PcsPerCase)),
                new SqlParameter("@CaseId", aShippingCartonSize.CaseId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
