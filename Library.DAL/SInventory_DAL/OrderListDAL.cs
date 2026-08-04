using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class OrderListDAL
    {
        private static SqlParameter Param(string name, object value)
        {
            return new SqlParameter(name, SInventorySql.DbValue(value));
        }

        private static void BindDropDown(DropDownList ddl, DataTable dataTable, string textField, string valueField)
        {
            ddl.DataSource = dataTable;
            ddl.DataTextField = textField;
            ddl.DataValueField = valueField;
            ddl.DataBind();
        }

        public bool SaveOrderMaster(OrderInfoMaster aListMasterDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblOrder
                                     ( OrderCode ,
                                       TerritoryCode ,
                                       ComUnitId ,
                                       ComUnitCode ,
                                       ComUnitName ,
                                       MIOCode ,
                                       MIOName ,
                                       ManufacId ,
                                       CustomerCode ,
                                       CustomerName ,
                                       GrossValue ,
                                       SubmissionDate ,
                                       FixedCustomer ,
                                       IsManual ,
                                       IsInvoice
                                     )
                                     VALUES
                                     (
                                       @OrderCode,
                                       @TerritoryCode,
                                       @ComUnitId,
                                       @ComUnitCode,
                                       @ComUnitName,
                                       @MIOCode,
                                       @MIOName,
                                       @ManufacId,
                                       @CustomerCode,
                                       @CustomerName,
                                       @GrossValue,
                                       @SubmissionDate,
                                       @FixedCustomer,
                                       @IsManual,
                                       'False'
                                     )";

            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                Param("@OrderCode", aListMasterDao.OrderCode),
                Param("@TerritoryCode", aListMasterDao.teritory),
                Param("@ComUnitId", aListMasterDao.ComUnitId),
                Param("@ComUnitCode", aListMasterDao.ComUnitCode),
                Param("@ComUnitName", aListMasterDao.ComUnitName),
                Param("@MIOCode", aListMasterDao.MIOCode),
                Param("@MIOName", aListMasterDao.MIOName),
                Param("@ManufacId", aListMasterDao.ManufacId),
                Param("@CustomerCode", aListMasterDao.CustomerCode),
                Param("@CustomerName", aListMasterDao.CustomerName),
                Param("@GrossValue", aListMasterDao.GrossValue),
                Param("@SubmissionDate", aListMasterDao.SubmissionDate),
                Param("@FixedCustomer", aListMasterDao.FCB),
                Param("@IsManual", aListMasterDao.IsManual)
            });
        }

        public bool SaveOrderDetail(OrderInfoDetail aOrderListDetailDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblOrderDetail
                                ( ProductId ,
                                  ProductCode ,
                                  ProductName ,
                                  Quantity ,
                                  TradePrice ,
                                  TotalTradePrice ,
                                  ISGiftProduct ,
                                  IsCampaignProduct ,
                                  OrderId
                                )
                                VALUES
                                (
                                  @ProductId,
                                  @ProductCode,
                                  @ProductName,
                                  @Quantity,
                                  @TradePrice,
                                  @TotalTradePrice,
                                  @ISGiftProduct,
                                  @IsCampaignProduct,
                                  @OrderId
                                )";

            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                Param("@ProductId", aOrderListDetailDao.ProductId),
                Param("@ProductCode", aOrderListDetailDao.ProductCode),
                Param("@ProductName", aOrderListDetailDao.ProductName),
                Param("@Quantity", aOrderListDetailDao.Quantity),
                Param("@TradePrice", aOrderListDetailDao.TradePrice),
                Param("@TotalTradePrice", aOrderListDetailDao.TotalTradePrice),
                Param("@ISGiftProduct", aOrderListDetailDao.IsgiftProduct),
                Param("@IsCampaignProduct", aOrderListDetailDao.IsCampaignProduct),
                Param("@OrderId", aOrderListDetailDao.OrderId)
            });
        }

        public void LoadmanufacturerName(DropDownList ddl)
        {
            string queryStr = "select * from tblManufacturer";
            BindDropDown(ddl, SInventorySql.GetDataTable(queryStr, new List<SqlParameter>()), "ManufacName", "ManufacId");
        }

        public DataTable CustomerInfo(string custCode)
        {
            string query = @"SELECT * FROM dbo.View_CustomerMaster WHERE CustomerCode=@CustomerCode";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                Param("@CustomerCode", custCode)
            });
        }

        public int OrderManualId()
        {
            string query = @"SELECT (isnull(MAX(SUBSTRING(OrderCode,5,15)),0)+1) as PKMaxNo FROM dbo.tblOrder WHERE IsManual='True'";
            return Convert.ToInt32(SInventorySql.GetDataTable(query, new List<SqlParameter>()).Rows[0][0].ToString());
        }

        public void DCLoad(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            BindDropDown(aDownList, SInventorySql.GetDataTable(dc, new List<SqlParameter>()), "Com", "ComUnitId");
        }

        public bool UpdateCompanyInfo(OrderInfoMaster aOrderInfoMaster)
        {
            string query = @"UPDATE tblOrder SET ComUnitId=@ComUnitId,ComUnitCode=@ComUnitCode,ComUnitName=@ComUnitName WHERE OrderId=@OrderId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Param("@ComUnitId", aOrderInfoMaster.ComUnitId),
                Param("@ComUnitCode", aOrderInfoMaster.ComUnitCode),
                Param("@ComUnitName", aOrderInfoMaster.ComUnitName),
                Param("@OrderId", aOrderInfoMaster.OrderId)
            });
        }
    }
}
