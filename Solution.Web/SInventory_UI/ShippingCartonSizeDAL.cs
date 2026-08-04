using System;
using System.Collections.Generic;
using System.Data;
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
            values (" + aShippingCartonSize.CaseId + ",'" + aShippingCartonSize.ProductCode + "','" + aShippingCartonSize.PcsPerCase + "','" + aShippingCartonSize.CaseQty + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool HasPcsPerCase(ShippingCartonSize aShippingCartonSize)
        {
            string query = "select * from tblProductCase where ProductCode = '" + aShippingCartonSize.ProductCode + "'";
            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    return true;
                }
            }
            return false;
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
            string query = "select * from tblProductCase where CaseId = '" + ID + "'";
            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            ShippingCartonSize aShippingCartonSize = new ShippingCartonSize();
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    aShippingCartonSize.CaseId = Int32.Parse(dataReader["CaseId"].ToString());
                    aShippingCartonSize.ProductCode = dataReader["ProductCode"].ToString();
                    aShippingCartonSize.CaseQty = dataReader["CaseQty"].ToString();
                    aShippingCartonSize.PcsPerCase = dataReader["PcsPerCase"].ToString();
                }
            }
            return aShippingCartonSize;
        }

        public bool UpdateShippingCartonSizeInfo(ShippingCartonSize aShippingCartonSize)
        {

            string query = @"UPDATE tblProductCase SET ProductCode='" + aShippingCartonSize.ProductCode + "',CaseQty='" + aShippingCartonSize.CaseQty + "',PcsPerCase='" + aShippingCartonSize.PcsPerCase + "' WHERE CaseId=" + aShippingCartonSize.CaseId + "";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
    }
}
