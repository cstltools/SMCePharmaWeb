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
    public class DCStoreDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDataForDhakaStock(DCStore aReceive)
        {
            string insertQuery = @"insert into tblDCStore (ReceiveId,ProductCode,ProductName,PackSize,BatchNo,Quantity,ExpDate,ReceiveDate,ChalanNo,ChalanDate,ComUnitId,StorageLocation) 
            values (@ReceiveId,@ProductCode,@ProductName,@PackSize,@BatchNo,@Quantity,@ExpDate,@ReceiveDate,@ChalanNo,@ChalanDate,@ComUnitId,@StorageLocation)";
            return SInventorySql.Execute(insertQuery, DcStoreParameters(aReceive));
        }
        
        public bool SaveDataForCurrentStock(CurrentStock aReceive)
        {
            string insertQuery = @"insert into tblCurrentStock (StockId,ProductCode,ProductName,PackSize,Quantity,ComUnitId,ComUnitCode) 
            values (@StockId,@ProductCode,@ProductName,@PackSize,@Quantity,@ComUnitId,@ComUnitCode)";
            return SInventorySql.Execute(insertQuery, CurrentStockParameters(aReceive));
        }

        public bool HasProductcode(CurrentStock aReceive)
        {
            string query = "select * from tblCurrentStock where ProductCode = @ProductCode";
            return SInventorySql.Exists(query, SingleParameter("@ProductCode", aReceive.ProductCode));
        }

        public DataTable CurrentStockQty(CurrentStock aReceive)
        {
            string query = "select * from tblCurrentStock where ProductCode = @ProductCode";
            return SInventorySql.GetDataTable(query, SingleParameter("@ProductCode", aReceive.ProductCode));
        }

        public DataTable LoadCountryStockView()
        {
            string query = @"SELECT * FROM tblDCStore ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DCStore DhakaStockEditLoad(string ReceiveId)
        {
            string query = "select * from tblDCStore where ReceiveId = @ReceiveId";
            DataTable dataTable = SInventorySql.GetDataTable(query, SingleParameter("@ReceiveId", ReceiveId));
            DCStore aReceive = new DCStore();
            if (dataTable.Rows.Count > 0)
            {
                DataRow row = dataTable.Rows[0];
                aReceive.StockId = Int32.Parse(row["ReceiveId"].ToString());
                aReceive.ProductCode = row["ProductCode"].ToString();
                aReceive.ProductName = row["ProductName"].ToString();
                aReceive.PackSize = row["PackSize"].ToString();
                aReceive.BatchNo = row["BatchNo"].ToString();
                aReceive.Quantity = Convert.ToDecimal(row["Quantity"].ToString());
                aReceive.ExpDate = Convert.ToDateTime(row["ExpDate"].ToString());
                aReceive.ReceiveDate = Convert.ToDateTime(row["ReceiveDate"].ToString());
            }
            return aReceive;
        }
       
        public bool UpdateDhakaStock(DCStore aReceive)
        {
            string query = @"UPDATE tblDCStore SET ProductName=@ProductName,ProductCode=@ProductCode,PackSize=@PackSize,BatchNo=@BatchNo,Quantity=@Quantity,ExpDate=@ExpDate,ReceiveDate=@ReceiveDate WHERE ReceiveId=@ReceiveId";
            return SInventorySql.Execute(query, DcStoreParameters(aReceive));
        }
       
        public DataTable StockCheck(string stockid)
        {
            string query = @"SELECT * from tblCurrentStock where StockId = @StockId";
            return SInventorySql.GetDataTable(query, SingleParameter("@StockId", stockid.Trim()));
        }
        public DataTable LoadProductCode(string productId, string ManuID)
        {
            string query = @"SELECT * FROM tblProduct left join tblUnitPrice on tblProduct.ProductCode=tblUnitPrice.ProductCode where tblProduct.ProductCode=@ProductCode ";
            return SInventorySql.GetDataTable(query, SingleParameter("@ProductCode", productId.Trim()));
        }

        public DataTable LoadProductCodeNew(string productId)
        {
            string query = @"SELECT * FROM tblProduct left join tblUnitPrice on tblProduct.ProductCode=tblUnitPrice.ProductCode where tblProduct.ProductCode=@ProductCode";
            return SInventorySql.GetDataTable(query, SingleParameter("@ProductCode", productId.Trim()));
        }
        public DataTable GetProductStock(string productId)
        {
            string query = @"SELECT SUM(Quantity)AS Qty FROM dbo.tblCentralStore WHERE ProductId=@ProductId";
            return SInventorySql.GetDataTable(query, SingleParameter("@ProductId", productId));
        }
        public DataTable LoadProductCode(string productId)
        {
            string query = @"SELECT * FROM tblProduct left join tblUnitPrice on tblProduct.ProductCode=tblUnitPrice.ProductCode where tblProduct.ProductCode=@ProductCode ";
            return SInventorySql.GetDataTable(query, SingleParameter("@ProductCode", productId.Trim()));
        }
        public void UpdateCurrentStockQuantity(string stockId,string Quantity)
        {
            string updateQuery = @"UPDATE tblCurrentStock SET Quantity=@Quantity WHERE ProductCode=@ProductCode";
            SInventorySql.Execute(updateQuery, new List<SqlParameter>
            {
                new SqlParameter("@Quantity", SInventorySql.DbValue(Quantity)),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(stockId.Trim()))
            });
        }

        private List<SqlParameter> DcStoreParameters(DCStore aReceive)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ReceiveId", SInventorySql.DbValue(aReceive.StockId)),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aReceive.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(aReceive.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(aReceive.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(aReceive.BatchNo)),
                new SqlParameter("@Quantity", SInventorySql.DbValue(aReceive.Quantity)),
                new SqlParameter("@ExpDate", SInventorySql.DbValue(aReceive.ExpDate)),
                new SqlParameter("@ReceiveDate", SInventorySql.DbValue(aReceive.ReceiveDate)),
                new SqlParameter("@ChalanNo", SInventorySql.DbValue(aReceive.ChalanNo)),
                new SqlParameter("@ChalanDate", SInventorySql.DbValue(aReceive.ChalanDate)),
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(aReceive.ComUnitId)),
                new SqlParameter("@StorageLocation", SInventorySql.DbValue(aReceive.StorageLocation))
            };
        }

        private List<SqlParameter> CurrentStockParameters(CurrentStock aReceive)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@StockId", SInventorySql.DbValue(aReceive.StockId)),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aReceive.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(aReceive.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(aReceive.PackSize)),
                new SqlParameter("@Quantity", SInventorySql.DbValue(aReceive.Quantity)),
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(aReceive.ComUnitId)),
                new SqlParameter("@ComUnitCode", SInventorySql.DbValue(aReceive.StorageLocation))
            };
        }

        private List<SqlParameter> SingleParameter(string name, object value)
        {
            return new List<SqlParameter>
            {
                new SqlParameter(name, SInventorySql.DbValue(value))
            };
        }
        
    }
}
