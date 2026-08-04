using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public  class OtherStockActionDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public DataTable LoadData(int unitID, int ManuID)
        {
            string query = @"SELECT F.DCStoreFreezeId,F.DCStoreId,F.ProductCode,F.ProductName,F.BatchNo,F.ExpDate,F.StockQty,
                           (U.UnitPrice*F.StockQty) AS Amount,F.StockCondition,F.Remarks
                           FROM dbo.tblDCStoreFreeze F
                           INNER JOIN dbo.tblUnitPrice U ON F.ProductCode = U.ProductCode
                           INNER JOIN dbo.tblProduct P ON F.ProductCode = P.ProductCode
                           WHERE StockQty>0 AND F.ComUnitId = @ComUnitId AND P.ManufacId = @ManufacId ORDER BY F.ExpDate ";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", unitID),
                new SqlParameter("@ManufacId", ManuID)
            });
        }
        public void LoadmanufacturerName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }

        public void LoadTerritory(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblArea";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaCode", "AreaId", queryStr);
        }

        public DataTable LoadStockData(int DCStoreFreezeId)
        {
            string query = @"SELECT StockQty FROM dbo.tblDCStoreFreeze where DCStoreFreezeId=@DCStoreFreezeId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DCStoreFreezeId", DCStoreFreezeId)
            });
        }
        public DataTable LoadStockDCStockData(int DCStoreId)
        {
            string query = @"SELECT StockQty FROM dbo.tblDCStore where DCStoreId=@DCStoreId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DCStoreId", DCStoreId)
            });
        }
        public void LoadSC(DropDownList ddl, string userId)
        {
            string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                               " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId.Trim()))
            });
            ddl.DataTextField = "ComUnitName";
            ddl.DataValueField = "ComUnitId";
            ddl.DataBind();
        }
        public void LoadMIO(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT MiaCode+':'+MiaName AS MIO,MiaId FROM dbo.tblMIAInfo";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MIO", "MiaId", queryStr);
        }

        public void LoadMIOMIOreceivable(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT MiaCode+':'+MiaName AS MIO,MiaId,MiaCode FROM dbo.tblMIAInfo";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MIO", "MiaCode", queryStr);
        }


        public void DCLoad(DropDownList aDownList, string userId)
        {
            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit
                                            LEFT JOIN dbo.tblUserCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblUserCompanyUnit.CompanyUnitId
                                            WHERE UserId=@UserId";
            aDownList.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
            aDownList.DataTextField = "ComUnitName";
            aDownList.DataValueField = "ComUnitId";
            aDownList.DataBind();
        }
        public void DCLoad(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitId", dc, "SSIDB");
        }
        public void MarketLoad(DropDownList aDownList)
        {
            string dc = "select * from dbo.tblMarket";
            aCommonInternalDal.LoadDropDownValue(aDownList, "MarketName", "MarketId", dc, "SSIDB");
        }
        public bool UpdateDCStoreFreezeStock(decimal StockQty, int DCStoreFreezeId)
        {
            string query = @"UPDATE tblDCStoreFreeze SET StockQty=@StockQty WHERE DCStoreFreezeId=@DCStoreFreezeId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", StockQty),
                new SqlParameter("@DCStoreFreezeId", DCStoreFreezeId)
            });
        }
        public bool UpdateDCStock(decimal StockQty, int DCStoreId)
        {
            string query = @"UPDATE tblDCStore SET StockQty=@StockQty WHERE DCStoreId=@DCStoreId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", StockQty),
                new SqlParameter("@DCStoreId", DCStoreId)
            });
        }

        //Sub Deport

        public DataTable SubDeportLoadData(int unitID, int ManuID)
        {
            string query = @"SELECT F.SDStoreFreezeId,F.SubDCStoreId,F.ProductCode,F.ProductName,F.BatchNo,F.ExpDate,F.StockQty,
                           (U.UnitPrice*F.StockQty) AS Amount,F.StockCondition,F.Remarks
                           FROM dbo.tblSubDepotStoreFreeze F
                           INNER JOIN dbo.tblUnitPrice U ON F.ProductCode = U.ProductCode
                           INNER JOIN dbo.tblProduct P ON F.ProductCode = P.ProductCode
                           WHERE StockQty>0 AND F.SubDepotId = @SubDepotId AND P.ManufacId = @ManufacId ORDER BY F.ExpDate ";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SubDepotId", unitID),
                new SqlParameter("@ManufacId", ManuID)
            });
        }

        public DataTable LoadSubdeportStockData(int DCStoreFreezeId)
        {
            string query = @"SELECT StockQty FROM dbo.tblSubDepotStoreFreeze where SDStoreFreezeId=@SDStoreFreezeId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SDStoreFreezeId", DCStoreFreezeId)
            });
        }
        public bool SubdeportUpdateDCStoreFreezeStock(decimal StockQty, int DCStoreFreezeId)
        {
            string query = @"UPDATE tblSubDepotStoreFreeze SET StockQty=@StockQty WHERE SDStoreFreezeId=@SDStoreFreezeId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", StockQty),
                new SqlParameter("@SDStoreFreezeId", DCStoreFreezeId)
            });
        }
        public DataTable SubdeportLoadStockDCStockData(int DCStoreId)
        {
            string query = @"SELECT StockQty FROM dbo.tblSubDepotStore where SubDCStoreId=@SubDCStoreId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SubDCStoreId", DCStoreId)
            });
        }
        public bool SubdeportUpdateDCStock(decimal StockQty, int DCStoreId)
        {
            string query = @"UPDATE tblSubDepotStore SET StockQty=@StockQty WHERE SubDCStoreId=@SubDCStoreId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", StockQty),
                new SqlParameter("@SubDCStoreId", DCStoreId)
            });
        }
    }
}
