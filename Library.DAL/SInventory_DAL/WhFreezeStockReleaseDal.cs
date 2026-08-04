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
    public class WhFreezeStockReleaseDal
    {
        private  ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetWhFreezeStockData()
        {
            string query = @"SELECT WSF.WhStoreFreezeId, WSF.ReceiveId,P.ProductCode,WSF.ProductName,WSF.BatchNo,WSF.ExpDate,WSF.StockQty,(U.UnitPrice*WSF.StockQty) AS Amount,WSF.StockCondition,WSF.Remarks From dbo.tblWhStoreFreeze AS WSF
                            INNER JOIN dbo.tblUnitPrice U ON WSF.ProductId = U.ProductId
                            INNER JOIN dbo.tblProduct P ON WSF.ProductId = P.ProductId WHERE WSF.StockQty > 0";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetStockReleaseData(int id)
        {
            string query = @"SELECT WSF.WhStoreFreezeId,P.ProductCode,WSF.ProductName,WSF.BatchNo,WSF.ExpDate,WSF.StockQty,(U.UnitPrice*WSF.StockQty) AS Amount,WSF.StockCondition,WSF.Remarks From dbo.tblWhStoreFreeze AS WSF
                            INNER JOIN dbo.tblUnitPrice U ON WSF.ProductId = U.ProductId
                            INNER JOIN dbo.tblProduct P ON WSF.ProductId = P.ProductId WHERE WSF.WhStoreFreezeId = @WhStoreFreezeId";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@WhStoreFreezeId", id)
            });
        }

        public bool UpdateWhStoreFreezeStockQuantity(WhStoreFreezeDao aConditionFreezeDao)
        {
            string query = @"UPDATE tblWhStoreFreeze SET StockQty = @StockQty WHERE WhStoreFreezeId = @WhStoreFreezeId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", aConditionFreezeDao.StockQty),
                new SqlParameter("@WhStoreFreezeId", aConditionFreezeDao.WhStoreFreezeId)
            });
        }

        public DataTable GetCentralStoreDataByReceiveId(int receiveId)
        {
            string query = @"SELECT * FROM dbo.tblCentralStore WHERE ReceiveId = @ReceiveId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ReceiveId", receiveId)
            });
        }

        public bool UpdateCentalStoreQuantity(decimal quantity, int receiveId)
        {
            string query = @"UPDATE tblCentralStore SET Quantity = @Quantity WHERE ReceiveId = @ReceiveId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@Quantity", quantity),
                new SqlParameter("@ReceiveId", receiveId)
            });
        }

        public void GetWhInfoOnDropDownList(DropDownList ddl)
        {
            string query = @"SELECT WearhouseId, WearhouseCode + ':' + WearhouseName AS WearhouseName  FROM tblWearhouse";
            aCommonInternalDal.LoadDropDownValue(ddl, "WearhouseName", "WearhouseId", query, "SSIDB");
        }
    }
}
