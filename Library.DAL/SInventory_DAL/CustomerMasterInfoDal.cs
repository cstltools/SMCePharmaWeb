using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class CustomerMasterInfoDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void LoadCompanyUnit(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName +':'+ ComUnitCode as ComUnitName FROM dbo.tblCompanyUnit  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitCode", queryStr);
        }

        public void GetDZSMname(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT RegionId,RegionCode,RegionName +':'+ RegionCode as RegionName FROM dbo.tblRegion  WHERE RegionId IN (SELECT RegionId FROM dbo.tblRegion)";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionCode", queryStr);
        }

        public void LoadCategoryName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT CategoryId,CategoryCode,CategoryName FROM dbo.tblCustCategory WHERE CategoryId IN (SELECT CategoryId FROM dbo.tblCustCategory) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CategoryName", "CategoryId", queryStr);
        }

        public void GetFEInfo(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT DistrictId,DistrictCode,DistrictName  +':'+ DistrictCode as DistrictName FROM dbo.tblDistrict WHERE DistrictId IN (SELECT DistrictId FROM dbo.tblDistrict) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistrictName", "DistrictCode", queryStr);
        }

        public void GetTerritoryInfo(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT AreaId,AreaCode,AreaName +':'+ AreaCode as AreaName FROM dbo.tblArea WHERE AreaId IN (SELECT AreaId FROM dbo.tblArea) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaCode", queryStr);
        }

        public void GetMiaInfo(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT MiaId,MiaCode,MiaName +':'+ MiaCode as MiaName FROM dbo.tblMIAInfo WHERE MiaId IN (SELECT MiaId FROM dbo.tblMIAInfo) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MiaName", "MiaCode", queryStr); ;
        }

        public void GetMaketInfo(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT MarketId,MarketCode,MarketName +':'+ MarketCode as MarketName FROM dbo.tblMarket WHERE MarketId IN (SELECT MarketId FROM dbo.tblMarket) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketCode", queryStr);
        }

        public DataTable GetDZSMnameById(string dzsmId)
        {
            string queryStr = "SELECT RegionId,RegionName FROM dbo.tblRegion WHERE RegionCode = @RegionCode";
            return SInventorySql.GetDataTable(queryStr, SingleParameter("@RegionCode", dzsmId));
        }

        public DataTable GetFEnameById(string feId)
        {
            string queryStr = "SELECT DistrictId,DistrictName FROM dbo.tblDistrict WHERE DistrictCode = @DistrictCode";
            return SInventorySql.GetDataTable(queryStr, SingleParameter("@DistrictCode", feId));
        }

        public DataTable GetTeritorynameById(string teritoryId)
        {
            string queryStr = "SELECT AreaId,AreaName FROM dbo.tblArea WHERE AreaCode = @AreaCode";
            return SInventorySql.GetDataTable(queryStr, SingleParameter("@AreaCode", teritoryId));
        }

        public DataTable GetMiaNameById(string miaId)
        {
            string queryStr = "SELECT MiaId,MiaName FROM dbo.tblMIAInfo WHERE MiaCode = @MiaCode";
            return SInventorySql.GetDataTable(queryStr, SingleParameter("@MiaCode", miaId));
        }

        public DataTable GetMarketNameById(string marketId)
        {
            string queryStr = "SELECT MarketId,MarketName FROM dbo.tblMarket WHERE MarketCode = @MarketCode";
            return SInventorySql.GetDataTable(queryStr, SingleParameter("@MarketCode", marketId));
        }

        public bool SaveCustometMasterInfo(CustomerMaster aCustomerMaster)
        {
            string insertQuery = @"INSERT INTO dbo.tblCustMaster
                        ( 
                          CustomerCode ,
                          CategoryId ,
                          CustomerName ,
                          Address ,
                          CellNo ,
                          Addrees2 ,
                          City ,
                          ConPerson ,
                          ShippingCond ,
                          MarketCode ,
                          MarketName ,
                          MIACode ,
                          MIAName ,
                          AreaCode ,
                          DisCode ,
                          FEName ,
                          ComUnitCode ,
                          ComUnitName ,
                          RegionCode ,
                          DZSMName ,
                          TermOfPayment ,
                          CustomerCodeOld,
                          FixedCustomer,
                          IsActive,
                          InActiveDate
                        )
                VALUES  (@CustomerCode,@CategoryId,@CustomerName,@Address,@CellNo,@Addrees2,@City,@ConPerson,@ShippingCond,
@MarketCode,@MarketName,@MIACode,@MiaName,@AreaCode,@DisCode,@FEName,@ComUnitCode,@ComUnitName,@RegionCode,@DZSMName,
@TermOfPayment,@CustomerCodeOld,@FixedCustomer,@IsActive,@InActiveDate)";
            return SInventorySql.Execute(insertQuery, CustomerMasterParameters(aCustomerMaster));
        }

        public CustomerMaster CustomerMasterEditLoad(string cusmasId)
        {
            string query = "select * from tblCustMaster where CustomerMasterId = @CustomerMasterId";
            DataTable dataTable = SInventorySql.GetDataTable(query, SingleParameter("@CustomerMasterId", cusmasId));
            CustomerMaster aCustomerMaster = new CustomerMaster();
            foreach (DataRow dataReader in dataTable.Rows)
            {
                aCustomerMaster.CustomerMasterId = Int32.Parse(dataReader["CustomerMasterId"].ToString());
                aCustomerMaster.CustomerName = dataReader["CustomerName"].ToString();
                aCustomerMaster.CustomerCode = dataReader["CustomerCode"].ToString();
                aCustomerMaster.Address = dataReader["Address"].ToString();
                aCustomerMaster.CellNo = dataReader["CellNo"].ToString();
                aCustomerMaster.CategoryId = Convert.ToInt32(dataReader["CategoryId"].ToString());
                aCustomerMaster.Addrees2 = dataReader["Addrees2"].ToString();
                aCustomerMaster.City = dataReader["City"].ToString();
                aCustomerMaster.ConPerson = dataReader["ConPerson"].ToString();
                aCustomerMaster.ShippingCond = dataReader["ShippingCond"].ToString();
                aCustomerMaster.MarketCode = dataReader["MarketCode"].ToString();
                aCustomerMaster.MarketName = dataReader["MarketName"].ToString();
                aCustomerMaster.MIACode = dataReader["MIACode"].ToString();
                aCustomerMaster.MiaName = dataReader["MIAName"].ToString();
                aCustomerMaster.AreaCode = dataReader["AreaCode"].ToString();
                aCustomerMaster.DisCode = dataReader["DisCode"].ToString();
                aCustomerMaster.FEName = dataReader["FEName"].ToString();
                aCustomerMaster.ComUnitCode = dataReader["ComUnitCode"].ToString();
                aCustomerMaster.ComUnitName = dataReader["ComUnitName"].ToString();
                aCustomerMaster.RegionCode = dataReader["RegionCode"].ToString();
                aCustomerMaster.DZSMName = dataReader["DZSMName"].ToString();
                aCustomerMaster.TermOfPayment = dataReader["TermOfPayment"].ToString();
                aCustomerMaster.CustomerCodeOld = dataReader["CustomerCodeOld"].ToString();
                aCustomerMaster.FixedCustomer = (bool) dataReader["FixedCustomer"];
                aCustomerMaster.IsActive = (bool)dataReader["IsActive"];
                aCustomerMaster.InActiveDate = dataReader["InActiveDate"].ToString();

                break;
            }
            return aCustomerMaster;
        }

        public bool HasCustomerMastername(CustomerMaster aMaster)
        {
            string query = "select * from tblCustMaster where CustomerCode = @CustomerCode";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(aMaster.CustomerCode))
            });
        }

        //View

        public DataTable LoadCustomerMasterView(string cust)
        {
            string query = @"SELECT * FROM dbo.View_CustomerMaster" + cust;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadCustomerMasterViewM(string cust)
        {
            string query = @"SELECT * FROM dbo.View_CustomerForModification" + cust;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadCustomerMasterViewM2(string cust)
        {
            string query = @"SELECT tblCustMaster.CustomerCode,tblCustMaster.CustomerName,tblCustMaster.Address,tblCustMaster.CustomerType,CustomerStation,tblCustMaster.Type,tblCustMaster.ComUnitName,tblCustMaster.AreaCode
                             FROM dbo.tblCustMaster   
							 INNER JOIN dbo.View_CustomerMaster ON View_CustomerMaster.CustomerMasterId = tblCustMaster.CustomerMasterId  " + cust;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadFixedCustomerMasterView(string cust)
        {
            string query = @"SELECT * FROM dbo.View_CustomerMaster" + cust;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        //Edit

        public DataTable Customer(string customerId)
        {
            string query = @"SELECT * FROM dbo.tblInvoice WHERE TpTotal>0 and DeliveryInvoiceStatus IS NULL AND CustomerMasterId=@CustomerMasterId";
            return SInventorySql.GetDataTable(query, SingleParameter("@CustomerMasterId", customerId));
        }

        public DataTable CustomerPayment(string customerId)
        {
            string query = @"SELECT * FROM dbo.tblInvoice WHERE (PaymentStatus  IS NULL OR PaymentStatus= 'Partial')  AND DeliveryTpTotal>0  AND CustomerMasterId=@CustomerMasterId";
            return SInventorySql.GetDataTable(query, SingleParameter("@CustomerMasterId", customerId));
        }

        public bool UpdateCustomerMasterInfo(CustomerMaster aCustomerMaster)
        {
            //string query = @"UPDATE tblCustMaster SET "+
            //            " CategoryId='"+aCustomerMaster.CategoryId+"' , "+
            //            "  CustomerName='" + aCustomerMaster.CustomerName + "'  , " +
            //            "  Address='" + aCustomerMaster.Address + "'  ," +
            //            "  CellNo='" + aCustomerMaster.CellNo + "'  ," +
            //            "  Addrees2='" + aCustomerMaster.Addrees2 + "'  ," +
            //            "  City='" + aCustomerMaster.City + "'  ," +
            //            "  ConPerson ='" + aCustomerMaster.ConPerson + "' ," +
            //            "  ShippingCond='" + aCustomerMaster.ShippingCond + "'  ," +
            //            "  MarketCode='" + aCustomerMaster.MarketCode + "'  ," +
            //            "  MarketName='" + aCustomerMaster.MarketName + "'  ," +
            //            "  MIACode='" + aCustomerMaster.MIACode + "'  ," +
            //            "  MIAName='" + aCustomerMaster.MiaName + "'  ," +
            //            "  AreaCode='" + aCustomerMaster.AreaCode + "'  ," +
            //            "  DisCode='" + aCustomerMaster.DisCode + "'  ," +
            //            "  FEName='" + aCustomerMaster.FEName + "'  ," +
            //            "  ComUnitCode='" + aCustomerMaster.ComUnitCode + "'  ," +
            //            "  ComUnitName='" + aCustomerMaster.ComUnitName + "'  ," +
            //            "  RegionCode='" + aCustomerMaster.RegionCode + "'  ," +
            //            "  DZSMName='" + aCustomerMaster.DZSMName + "'  ," +
            //            "  TermOfPayment='" + aCustomerMaster.TermOfPayment + "'  ," +
            //            "  CustomerCodeOld='" + aCustomerMaster.CustomerCodeOld + "'  WHERE CustomerMasterId=" + aCustomerMaster.CustomerMasterId + "";
            //return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@CategoryId", aCustomerMaster.CategoryId));
            aSqlParameterlist.Add(new SqlParameter("@ConPerson", aCustomerMaster.ConPerson));
            aSqlParameterlist.Add(new SqlParameter("@CustomerMasterId", aCustomerMaster.CustomerMasterId));
            aSqlParameterlist.Add(new SqlParameter("@CustomerCode", aCustomerMaster.CustomerCode));
            aSqlParameterlist.Add(new SqlParameter("@CustomerName", aCustomerMaster.CustomerName));
            aSqlParameterlist.Add(new SqlParameter("@Address", aCustomerMaster.Address));
            aSqlParameterlist.Add(new SqlParameter("@CellNo", aCustomerMaster.CellNo));
            aSqlParameterlist.Add(new SqlParameter("@Addrees2", aCustomerMaster.Addrees2));
            aSqlParameterlist.Add(new SqlParameter("@City", aCustomerMaster.City));
            aSqlParameterlist.Add(new SqlParameter("@ShippingCond", aCustomerMaster.ShippingCond));
            aSqlParameterlist.Add(new SqlParameter("@MarketCode", aCustomerMaster.MarketCode));
            aSqlParameterlist.Add(new SqlParameter("@MarketName", aCustomerMaster.MarketName));
            aSqlParameterlist.Add(new SqlParameter("@MIACode", aCustomerMaster.MIACode));
            aSqlParameterlist.Add(new SqlParameter("@MiaName", aCustomerMaster.MiaName));
            aSqlParameterlist.Add(new SqlParameter("@AreaCode", aCustomerMaster.AreaCode));
            aSqlParameterlist.Add(new SqlParameter("@DisCode", aCustomerMaster.DisCode));
            aSqlParameterlist.Add(new SqlParameter("@FEName", aCustomerMaster.FEName));
            aSqlParameterlist.Add(new SqlParameter("@ComUnitCode", aCustomerMaster.ComUnitCode));
            aSqlParameterlist.Add(new SqlParameter("@ComUnitName", aCustomerMaster.ComUnitName));
            aSqlParameterlist.Add(new SqlParameter("@RegionCode", aCustomerMaster.RegionCode));
            aSqlParameterlist.Add(new SqlParameter("@DZSMName", aCustomerMaster.DZSMName));
            aSqlParameterlist.Add(new SqlParameter("@TermOfPayment", aCustomerMaster.TermOfPayment));
            aSqlParameterlist.Add(new SqlParameter("@FixedCustomer", aCustomerMaster.FixedCustomer));
            aSqlParameterlist.Add(new SqlParameter("@LoginName", HttpContext.Current.Session["LoginName"].ToString()));

            aSqlParameterlist.Add(new SqlParameter("@IsActive", aCustomerMaster.IsActive));
            aSqlParameterlist.Add(new SqlParameter("@InActiveDate",aCustomerMaster.InActiveDate ));

            return aCommonInternalDal.UpdateAction("UD_CustomerMaster", aSqlParameterlist);
        }

        public DataTable GetCustomerMasterId()
        {
            string query = @"SELECT TOP 1 CustomerCode FROM dbo.tblCustMaster ORDER BY CustomerMasterId DESC";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        //API Customer
        public DataTable LoadNewCustomer()
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tbltempCustMaster WHERE AddtoMainCustomer = 'False' ";
            return aInternalDal.DataContainerDataTable(queryStr);
        }
        public DataTable GetFixedCustomerSalesReportInfo(string customerId)
        {

            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT SUM(tblInvoiceDetail.DeliveryTotalPrice) TPSales,CustomerCode,CustomerName,Address,tblInvoice.AreaCode as TerritoryCode,tblCustMaster.DisCode as FECode,
tblCustMaster.MIACode as MIOCode,tblCustMaster.MIAName as MIOnAme,cast(YEAR(tblInvoice.UpdateDate) as varchar(4)) + '-' + DATENAME(mm, tblInvoice.UpdateDate) AS SalesMonth ,cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar) AS Salesyear
,DATENAME(mm, tblInvoice.UpdateDate)  AS SaleMonth FROM dbo.tblInvoice WITH (NOLOCK)
INNER JOIN dbo.tblCustMaster ON tblInvoice.CustomerMasterId=tblCustMaster.CustomerMasterId

INNER JOIN tblInvoiceDetail ON tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId

 WHERE tblCustMaster.CustomerMasterId = @CustomerMasterId and tblInvoiceDetail.DeliveryDiscountAmount>0 GROUP BY DATENAME(mm, tblInvoice.UpdateDate)  AS SaleMonth,CustomerCode,CustomerName,Address,tblInvoice.AreaCode,tblCustMaster.DisCode,tblCustMaster.MIACode,tblCustMaster.MIAName, cast(YEAR(tblInvoice.UpdateDate) as varchar(4)) + '-' + DATENAME(mm, tblInvoice.UpdateDate),tblCustMaster.CustomerMasterId,cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar)";

            return SInventorySql.GetDataTable(queryStr, SingleParameter("@CustomerMasterId", customerId));
        }
        public DataTable GetFixedCustomerSalesReportInfo2(string Parameter, string Parameter2)
        {

            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT SUM(tblInvoiceDetail.DeliveryTotalPrice) TPSales,CustomerCode,CustomerName,Address,tblInvoice.AreaCode as TerritoryCode,tblCustMaster.DisCode as FECode,
tblCustMaster.MIACode as MIOCode,tblCustMaster.MIAName as MIOnAme,cast(YEAR(tblInvoice.UpdateDate) as varchar(4)) + '-' + DATENAME(mm, tblInvoice.UpdateDate) AS SalesMonth ,cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar) AS Salesyear
,DATENAME(mm, tblInvoice.UpdateDate)  AS SaleMonth
FROM dbo.tblInvoice WITH (NOLOCK)
INNER JOIN dbo.tblCustMaster ON tblInvoice.CustomerMasterId=tblCustMaster.CustomerMasterId

INNER JOIN tblInvoiceDetail ON tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId

  " + Parameter + " and tblInvoiceDetail.DeliveryDiscountAmount>0 GROUP BY DATENAME(mm, tblInvoice.UpdateDate)  ,CustomerCode,CustomerName,Address,tblInvoice.AreaCode,tblCustMaster.DisCode,tblCustMaster.MIACode,tblCustMaster.MIAName, cast(YEAR(tblInvoice.UpdateDate) as varchar(4)) + '-' + DATENAME(mm, tblInvoice.UpdateDate),tblCustMaster.CustomerMasterId,cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar)  union all  SELECT SUM(tblSubInvoiceDetail.DeliveryTotalPrice) TPSales,CustomerCode,CustomerName,Address,tblCustMaster.AreaCode as TerritoryCode,tblCustMaster.DisCode as FECode,tblCustMaster.MIACode as MIOCode,tblCustMaster.MIAName as MIOnAme,cast(YEAR(tblSubInvoiceMaster.UpdateDate) as varchar(4)) + '-' + DATENAME(mm, tblSubInvoiceMaster.UpdateDate) AS SalesMonth ,cast(datepart(yyyy,tblSubInvoiceMaster.UpdateDate) as varchar) AS Salesyear ,DATENAME(mm, tblSubInvoiceMaster.UpdateDate)  AS SaleMonth FROM dbo.tblSubInvoiceMaster WITH (NOLOCK) INNER JOIN dbo.tblCustMaster ON tblSubInvoiceMaster.CustomerMasterId=tblCustMaster.CustomerMasterId INNER JOIN tblSubInvoiceDetail ON tblSubInvoiceMaster.InvoiceId=tblSubInvoiceDetail.InvoiceId " + Parameter2 + " and tblSubInvoiceDetail.DeliveryDiscountAmount>0 GROUP BY DATENAME(mm, tblSubInvoiceMaster.UpdateDate)  ,CustomerCode,CustomerName,Address,tblCustMaster.AreaCode,tblCustMaster.DisCode,tblCustMaster.MIACode,tblCustMaster.MIAName, cast(YEAR(tblSubInvoiceMaster.UpdateDate) as varchar(4)) + '-' + DATENAME(mm, tblSubInvoiceMaster.UpdateDate),tblCustMaster.CustomerMasterId,cast(datepart(yyyy,tblSubInvoiceMaster.UpdateDate) as varchar)";

            return aInternalDal.DataContainerDataTable(queryStr, "SSIDB");
        }

        private List<SqlParameter> CustomerMasterParameters(CustomerMaster c)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(c.CustomerCode)),
                new SqlParameter("@CategoryId", c.CategoryId),
                new SqlParameter("@CustomerName", SInventorySql.DbValue(c.CustomerName)),
                new SqlParameter("@Address", SInventorySql.DbValue(c.Address)),
                new SqlParameter("@CellNo", SInventorySql.DbValue(c.CellNo)),
                new SqlParameter("@Addrees2", SInventorySql.DbValue(c.Addrees2)),
                new SqlParameter("@City", SInventorySql.DbValue(c.City)),
                new SqlParameter("@ConPerson", SInventorySql.DbValue(c.ConPerson)),
                new SqlParameter("@ShippingCond", SInventorySql.DbValue(c.ShippingCond)),
                new SqlParameter("@MarketCode", SInventorySql.DbValue(c.MarketCode)),
                new SqlParameter("@MarketName", SInventorySql.DbValue(c.MarketName)),
                new SqlParameter("@MIACode", SInventorySql.DbValue(c.MIACode)),
                new SqlParameter("@MiaName", SInventorySql.DbValue(c.MiaName)),
                new SqlParameter("@AreaCode", SInventorySql.DbValue(c.AreaCode)),
                new SqlParameter("@DisCode", SInventorySql.DbValue(c.DisCode)),
                new SqlParameter("@FEName", SInventorySql.DbValue(c.FEName)),
                new SqlParameter("@ComUnitCode", SInventorySql.DbValue(c.ComUnitCode)),
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(c.ComUnitName)),
                new SqlParameter("@RegionCode", SInventorySql.DbValue(c.RegionCode)),
                new SqlParameter("@DZSMName", SInventorySql.DbValue(c.DZSMName)),
                new SqlParameter("@TermOfPayment", SInventorySql.DbValue(c.TermOfPayment)),
                new SqlParameter("@CustomerCodeOld", SInventorySql.DbValue(c.CustomerCodeOld)),
                new SqlParameter("@FixedCustomer", c.FixedCustomer),
                new SqlParameter("@IsActive", c.IsActive),
                new SqlParameter("@InActiveDate", SInventorySql.DbValue(c.InActiveDate))
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
