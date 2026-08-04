using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class CustomerMasterDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
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
                          CustomerCodeOld
                        )
                VALUES  (@CustomerCode,@CategoryId,@CustomerName,@Address,@CellNo,@Addrees2,@City,@ConPerson,@ShippingCond,
@MarketCode,@MarketName,@MIACode,@MiaName,@AreaCode,@DisCode,@FEName,@ComUnitCode,@ComUnitName,@RegionCode,@DZSMName,
@TermOfPayment,@CustomerCodeOld)";
            return SInventorySql.Execute(insertQuery, CustomerMasterParameters(aCustomerMaster, false));
        }

        public bool HasCustomerMastername(CustomerMaster aMaster)
        {
            string query = "select * from tblCustMaster where CustomerCode = @CustomerCode";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(aMaster.CustomerCode))
            });
        }
       
        //public bool DeleteRequisition(int OrdID)
        //{
        //    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //    aSqlParameterlist.Add(new SqlParameter("@OrdID", OrdID));

        //    return aCommonInternalDal.DeleteAction("sp_DeleteOrder", aSqlParameterlist);
        //}
        public DataTable LoadCustomerMasterView(string cust)
        {
            string query = @"SELECT * FROM dbo.View_CustomerMaster WHERE CustomerCode=@CustomerCode";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(cust))
            });
        }


        public DataTable FixedCustomerMasterReport(bool fixedBusiness)
        {
            string query = @"SELECT (DistrictCode+'-'+DistrictName)DistrictName,(RegionCode+'-'+RegionName)RegionName, (AreaCode+'-'+AreaName)AreaName,(MiaCode+'-'+MiaName)MiaName,(MarketCode+'-'+MarketName)MarketName,* FROM dbo.View_CustomerMaster WHERE FixedCustomer = 'true'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable RegularCustomerMasterReport(bool regularCustomer)
        {
            string query = @"SELECT (DistrictCode+'-'+DistrictName)DistrictName,(RegionCode+'-'+RegionName)RegionName, (AreaCode+'-'+AreaName)AreaName,(MiaCode+'-'+MiaName)MiaName,(MarketCode+'-'+MarketName)MarketName,* FROM dbo.View_CustomerMaster WHERE FixedCustomer = 'false'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadOrderView(string Order)
        {
            string query = @"select * from tblOrder where IsInvoice=0 and OrderCode=@OrderCode";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderCode", SInventorySql.DbValue(Order))
            });
        }

        public CustomerMaster CustomerMasterEditLoad(string cusmasId)
        {
            string query = "select * from tblCustMaster where CustomerMasterId = @CustomerMasterId";
            DataTable dataTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerMasterId", SInventorySql.DbValue(cusmasId))
            });
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

                break;
            }
            return aCustomerMaster;
        }

        public bool UpdateCustomerMasterInfo(CustomerMaster aCustomerMaster)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@CategoryId", aCustomerMaster.CategoryId));
            aSqlParameterlist.Add(new SqlParameter("@CustomerName", aCustomerMaster.CustomerName));
            aSqlParameterlist.Add(new SqlParameter("@CustomerCode", aCustomerMaster.CustomerCode));
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
            aSqlParameterlist.Add(new SqlParameter("@CustomerMasterId", aCustomerMaster.CustomerMasterId));
            aSqlParameterlist.Add(new SqlParameter("@LoginName", HttpContext.Current.Session["LoginName"].ToString()));

            return aCommonInternalDal.UpdateAction("UD_CustomerMaster2", aSqlParameterlist);
        }
        public void LoadMarketName(DropDownList ddl,string miaId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT MarketId,MarketCode,MarketName +':'+ MarketCode as MarketName FROM dbo.tblMarket  WHERE MarketId IN (SELECT MarketId FROM dbo.tblMarket) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketCode", queryStr);
        }
        public void LoadAreaName2(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT AreaId,AreaCode,AreaCode as AreaName FROM dbo.tblArea ORDER BY AreaCode ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaId", queryStr);
        }
        public void LoadAreaName(DropDownList ddl,string districtId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT AreaId,AreaCode,AreaName +':'+ AreaCode as AreaName FROM dbo.tblArea  WHERE AreaId IN (SELECT AreaId FROM dbo.tblArea) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaCode", queryStr);
        }
        public void LoadCompanyUnit(DropDownList ddl,string regionid)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName +':'+ ComUnitCode as ComUnitName FROM dbo.tblCompanyUnit  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitCode", queryStr);
        }
        public void LoadCompanyUnitbyID(DropDownList ddl, string regionid)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName +':'+ ComUnitCode as ComUnitName FROM dbo.tblCompanyUnit  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        
        public void LoadDistrictName(DropDownList ddl,string comUnitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT DistrictId,DistrictCode,DistrictName  +':'+ DistrictCode as DistrictName FROM dbo.tblDistrict  WHERE DistrictId IN (SELECT DistrictId FROM dbo.tblDistrict) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistrictName", "DistrictCode", queryStr);
        }
        public void LoadRegionname(DropDownList ddl, string id)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblRegion where CompanyId=@CompanyId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionId", queryStr, SingleParameter("@CompanyId", id));
        }
        public void LoadRegionname(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT RegionId,RegionCode,RegionName FROM dbo.tblRegion  WHERE RegionId IN (SELECT RegionId FROM dbo.tblRegion)";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionCode", queryStr);
        }
        public void LoadCategoryName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT CategoryId,CategoryCode,CategoryName FROM dbo.tblCustCategory  WHERE CategoryId IN (SELECT CategoryId FROM dbo.tblCustCategory) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CategoryName", "CategoryId", queryStr);
        }
        public void LoadMiaName(DropDownList ddl,string areaId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT MiaId,MiaCode,MiaName FROM dbo.tblMIAInfo  WHERE MiaId IN (SELECT MiaId FROM dbo.tblMIAInfo) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MiaName", "MiaCode", queryStr);
        }
        public void LoadDcDropDownList(DropDownList ddl,string custMasterId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit where ComUnitId=@ComUnitId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr, SingleParameter("@ComUnitId", custMasterId));
        }

        public void LoadDcDropDownList(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        /// <summary>
        /// ////////
        /// </summary>
        /// <param name="comUnitId"></param>
        /// <returns></returns>
        public void LoadMarketNameById(DropDownList ddl, string miaId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT MarketId,MarketCode,MarketName FROM dbo.View_CustomerMaster  WHERE MarketId IN (SELECT MarketId FROM dbo.tblMarket) AND dbo.View_CustomerMaster.MiaId=@MiaId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr, SingleParameter("@MiaId", miaId));
        }

        public void LoadAreaNameById(DropDownList ddl, string districtId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT AreaId,AreaCode,AreaName FROM dbo.View_CustomerMaster  WHERE AreaId IN (SELECT AreaId FROM dbo.tblArea) AND dbo.View_CustomerMaster.DistrictId=@DistrictId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaId", queryStr, SingleParameter("@DistrictId", districtId));
        }
        public void LoadCompanyUnitById(DropDownList ddl, string regionid)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName FROM dbo.View_CustomerMaster  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) AND dbo.View_CustomerMaster.RegionId=@RegionId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr, SingleParameter("@RegionId", regionid));
        }

        public void LoadDistrictNameById(DropDownList ddl, string comUnitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT DistrictId,DistrictCode,DistrictName FROM dbo.View_CustomerMaster  WHERE DistrictId IN (SELECT DistrictId FROM dbo.tblDistrict) AND dbo.View_CustomerMaster.ComUnitId=@ComUnitId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistrictName", "DistrictId", queryStr, SingleParameter("@ComUnitId", comUnitId));
        }
        public void LoadRegionnameById(DropDownList ddl, string id)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblRegion where CompanyId=@CompanyId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionId", queryStr, SingleParameter("@CompanyId", id));
        }
        public void LoadRegionnameById(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT RegionId,RegionCode,RegionName FROM dbo.View_CustomerMaster  WHERE RegionId IN (SELECT RegionId FROM dbo.tblRegion)";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionId", queryStr);
        }
        public void LoadCategoryNameById(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT CategoryId,CategoryCode,CategoryName FROM dbo.View_CustomerMaster  WHERE CategoryId IN (SELECT CategoryId FROM dbo.tblCustCategory) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CategoryName", "CategoryId", queryStr);
        }
        public void LoadMiaNameById(DropDownList ddl, string areaId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT DISTINCT MiaId,MiaCode,MiaName FROM dbo.View_CustomerMaster  WHERE MiaId IN (SELECT MiaId FROM dbo.tblMIAInfo) AND dbo.View_CustomerMaster.AreaId=@AreaId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MiaName", "MiaId", queryStr, SingleParameter("@AreaId", areaId));
        }
        public void LoadDcDropDownListById(DropDownList ddl, string custMasterId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit where ComUnitId=@ComUnitId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr, SingleParameter("@ComUnitId", custMasterId));
        }

        public void LoadDcDropDownListById(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }

        public DataTable CustomerMasterReport(string comUnitId)
        {
            string query = @"SELECT (DistrictCode+'-'+DistrictName)DistrictName,(RegionCode+'-'+RegionName)RegionName, (AreaCode+'-'+AreaName)AreaName,(MiaCode+'-'+MiaName)MiaName,(MarketCode+'-'+MarketName)MarketName,* FROM dbo.View_CustomerMaster WHERE ComUnitId=@ComUnitId";
            return SInventorySql.GetDataTable(query, SingleParameter("@ComUnitId", comUnitId == null ? null : comUnitId.Trim()));
        }
        public DataTable CustomerMasterReport()
        {
            string query = @"SELECT * FROM dbo.View_CustomerMaster
                                        LEFT JOIN dbo.tblCustMaster ON dbo.View_CustomerMaster.CustomerMasterId = dbo.tblCustMaster.CustomerMasterId";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
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
        public DataTable Customerorder(string customerCode)
        {
            string query = @"SELECT * FROM dbo.tblOrder WHERE IsInvoice = 0 AND CustomerCode=@CustomerCode";
            return SInventorySql.GetDataTable(query, SingleParameter("@CustomerCode", customerCode));
        }
        public bool DeleteRequisition(int OrdID)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@OrdID", OrdID));
            aSqlParameterlist.Add(new SqlParameter("@LoginName", HttpContext.Current.Session["UserId"].ToString()));

            return aCommonInternalDal.DeleteAction("sp_DeleteOrder", aSqlParameterlist);
        }
        public bool UpdateBacktoReturnPage(int OrdID)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@OrdID", OrdID));
            aSqlParameterlist.Add(new SqlParameter("@LoginName", HttpContext.Current.Session["UserId"].ToString()));

            return aCommonInternalDal.DeleteAction("sp_UpdateBacktoReturnPage", aSqlParameterlist);
        }

        private List<SqlParameter> CustomerMasterParameters(CustomerMaster c, bool includeId)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
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
                new SqlParameter("@CustomerCodeOld", SInventorySql.DbValue(c.CustomerCodeOld))
            };

            if (includeId)
                parameters.Add(new SqlParameter("@CustomerMasterId", c.CustomerMasterId));

            return parameters;
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
