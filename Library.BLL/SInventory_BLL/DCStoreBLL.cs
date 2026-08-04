using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class DCStoreBLL
    {
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
        DCStoreDAL aReceiveDal = new DCStoreDAL();
        public bool SaveDhakaStock(List<CurrentStock> aCurrentStockList,List<DCStore> aDhakaStockList  )
        {
            bool status = true;
            foreach (var aCurrentStock in aCurrentStockList)
            {
                if (!aReceiveDal.HasProductcode(aCurrentStock))
                {
                    aCurrentStock.StockId = aClsPrimaryKeyFind.PrimaryKeyMax("StockId", "tblCurrentStock");
                    status = aReceiveDal.SaveDataForCurrentStock(aCurrentStock);
                    if (status==true)
                    {

                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    DataTable dataTableStockQty = new DataTable();
                    dataTableStockQty = aReceiveDal.CurrentStockQty(aCurrentStock);
                    decimal currentQty = Convert.ToDecimal(dataTableStockQty.Rows[0]["Quantity"].ToString());
                    decimal newQty = Convert.ToDecimal(aCurrentStock.Quantity);
                   aReceiveDal.UpdateCurrentStockQuantity(aCurrentStock.ProductCode,
                                                           Convert.ToString(currentQty + newQty));
                    foreach (var aStockRecieve in aDhakaStockList)
                    {
                        aStockRecieve.StockId = aClsPrimaryKeyFind.PrimaryKeyMax("ReceiveId", "tblDCStore");
                        aStockRecieve.StockId = aCurrentStock.StockId;
                        if (!aReceiveDal.SaveDataForDhakaStock(aStockRecieve))
                        {
                            return true;
                        }
                    }
                }
            }
            
            if (status==true)
            {
                foreach (var aStockRecieve in aDhakaStockList)
                {
                    aStockRecieve.StockId = aClsPrimaryKeyFind.PrimaryKeyMax("ReceiveId", "tblDCStore");
                    if (!aReceiveDal.SaveDataForDhakaStock(aStockRecieve))
                    {
                        return true;
                    }
                }
            }

            return false;
        }
       
        public bool UpdateDataForDCStockReceive(DCStore aDcStockReceive)
        {
            return aReceiveDal.UpdateDhakaStock(aDcStockReceive);
        }

        public DataTable LoadCountryStock()
        {
            return aReceiveDal.LoadCountryStockView();
        }

        public DCStore StockRecieveEditLoad(string ReceiveId)
        {
            return aReceiveDal.DhakaStockEditLoad(ReceiveId);
        }
        public DCStore CurrentStockEditLoad(string StockId)
        {
            return aReceiveDal.DhakaStockEditLoad(StockId);
        }

        public DataTable ProductInfo(string productId,string ManuID)
        {
            return aReceiveDal.LoadProductCode(productId, ManuID);
        }
        public DataTable ProductInfoNew(string productId)
        {
            return aReceiveDal.LoadProductCodeNew(productId);
        }
        public DataTable GetProductStock(string productId)
        {
            return aReceiveDal.GetProductStock(productId);
        }

        public DataTable ProductInfo(string productId)
        {
            return aReceiveDal.LoadProductCode(productId);
        }
    }
}
