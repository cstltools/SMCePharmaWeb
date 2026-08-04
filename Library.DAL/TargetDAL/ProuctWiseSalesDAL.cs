using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.InternalCls;
using Library.DAO.Target_DAO;

namespace Library.DAL.TargetDAL
{
    public class ProuctWiseSalesDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveProductWiseSales(ProductWiseTargetDAO aTargetDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblProductWiseSalesTarget
                                    (
                                        GroupId,
                                        RegionId,
                                        AreaId,
                                        TerritoryId,
                                        ProductId,
                                        Month,
                                        Year,
                                        Date,
Amount,
                                        EntryBy,
                                        EntryDate
                                        
                                    ) VALUES
                                (
                                 
                                 '" + aTargetDao.GroupId + "'," +
                                 "'" + aTargetDao.RegionId + "'," +
                                 "'" + aTargetDao.AreaId + "'," +
                                 "'" + aTargetDao.TerritoryId + "'," +
                                 "'" + aTargetDao.ProductId + "'," +
                                 "'" + aTargetDao.Month + "'," +
                                 "'" + aTargetDao.Year + "'," +
                                 "'" + aTargetDao.Date + "'," +
                                 "'" + aTargetDao.Amount + "'," +

                                 "'" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "'" + DateTime.Now + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool UpdateMonthlyTarget(ProductWiseTargetDAO aTargetDao)
        {
            string insertQuery = @"UPDATE dbo.tblProductWiseSalesTarget SET Year='" + aTargetDao.Year + "'," +
                                 "Month='" + aTargetDao.Month + "'," +
                                 "Date='" + aTargetDao.Date + "'," +
                                 "GroupId='" + aTargetDao.GroupId + "'," +
                                 "RegionId='" + aTargetDao.RegionId + "'," +
                                 "AreaId='" + aTargetDao.AreaId + "'," +
                                 "TerritoryId='" + aTargetDao.TerritoryId + "'," +
                                 "ProductId='" + aTargetDao.ProductId + "'," + "Amount='" + aTargetDao.Amount + "'," +
                                 "UpdateBy='" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "UpdateDate='" + DateTime.Now + "' WHERE ProductSalesTargetId='" + aTargetDao.ProductSalesTargetId + "'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }

        public DataTable LoadMonthlyTarget()
        {
            string query = @"SELECT ProductSalesTargetId,
           mas.GroupId,
           mas.RegionId,
           mas.AreaId,
           mas.TerritoryId,
           mas.ProductId,
           Month,
           Year,
           Date,
           mas.EntryBy,
           mas.EntryDate,
           mas.UpdateBy,
           mas.UpdateDate,
           
           GroupName,
           
           GroupCode,
           
           RegionCode,
           RegionName,
           
           
           AreaCode,
           AreaName,
           
           
           
           
           TerritoryName,
           TerritoryCode,
           TerShortName,
           
           
           ProductCode,
           ProductName,CASE WHEN mas.Month=1 THEN 'January' WHEN mas.Month=2 THEN 'February' WHEN mas.Month=3 THEN 'March' WHEN mas.Month=4 THEN 'April' WHEN mas.Month=5 THEN 'May' WHEN mas.Month=6 THEN 'June'  WHEN mas.Month=7 THEN 'July' WHEN mas.Month=8 THEN 'August' WHEN mas.Month=9 THEN 'September'  WHEN mas.Month=10 THEN 'October'  WHEN mas.Month=11 THEN 'November'  WHEN mas.Month=12 THEN 'December' ELSE '' END  [MonthName]    
            FROM dbo.tblProductWiseSalesTarget mas
	LEFT JOIN dbo.tbl_Group ON tbl_Group.GroupId = mas.GroupId
	LEFT JOIN dbo.tblRegion ON tblRegion.RegionId = mas.RegionId
	LEFT JOIN dbo.tblArea ON tblArea.AreaId = mas.AreaId
	LEFT JOIN dbo.tblTerritory ON tblTerritory.TerritoryId = mas.TerritoryId
	LEFT JOIN dbo.tblProduct ON dbo.tblProduct.ProductId= mas.ProductId";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadMonthlyTargetById(string id)
        {
            string query = @"SELECT * FROM dbo.tblProductWiseSalesTarget WHERE ProductSalesTargetId='" + id + "' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadProduct()
        {
            string query = @"SELECT * FROM dbo.tblProduct WHERE IsActive=1 ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
