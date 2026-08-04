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
    public class ImportedApiCustomerDal
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        //API Customer
        public DataTable LoadNewCustomer()
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tbltempCustMaster WHERE AddtoMainCustomer = 'False' ";
            return aInternalDal.DataContainerDataTable(queryStr);
        }


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



        public CustomerMaster CustomerMasterEditLoad(string customerId)
        {
            string query = "SELECT * FROM [dbo].[tbltempCustMaster] WHERE [tempCustomerMasterId] = @TempCustomerMasterId";
            DataTable customerTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@TempCustomerMasterId", SInventorySql.DbValue(customerId))
            });
            CustomerMaster aCustomerMaster = new CustomerMaster();
            if (customerTable.Rows.Count > 0)
            {
                DataRow row = customerTable.Rows[0];
                aCustomerMaster.CustomerMasterId = Int32.Parse(row["tempCustomerMasterId"].ToString());
                aCustomerMaster.CustomerName = row["CustomerName"].ToString();
                aCustomerMaster.CustomerCode = row["CustomerCode"].ToString();
                aCustomerMaster.Address = row["Address"].ToString();
                aCustomerMaster.CellNo = row["CellNo"].ToString();
                //aCustomerMaster.CategoryId = Convert.ToInt32(row["CategoryId"].ToString());
                aCustomerMaster.Addrees2 = row["Addrees2"].ToString();
                aCustomerMaster.City = row["City"].ToString();
                aCustomerMaster.ConPerson = row["ConPerson"].ToString();
                //aCustomerMaster.ShippingCond = row["ShippingCond"].ToString();
                aCustomerMaster.MarketCode = row["MarketCode"].ToString();
                aCustomerMaster.MarketName = row["MarketName"].ToString();
                aCustomerMaster.MIACode = row["MIACode"].ToString();
                aCustomerMaster.MiaName = row["MIAName"].ToString();
                aCustomerMaster.AreaCode = row["AreaCode"].ToString();
                aCustomerMaster.DisCode = row["DisCode"].ToString();
                aCustomerMaster.FEName = row["FEName"].ToString();
                aCustomerMaster.ComUnitCode = row["ComUnitCode"].ToString();
                aCustomerMaster.ComUnitName = row["ComUnitName"].ToString();
                aCustomerMaster.RegionCode = row["RegionCode"].ToString();
                aCustomerMaster.DZSMName = row["DZSMName"].ToString();
                aCustomerMaster.TermOfPayment = row["TermOfPayment"].ToString();
                //aCustomerMaster.CustomerCodeOld = row["CustomerCodeOld"].ToString();
                aCustomerMaster.FixedCustomer = (bool)row["FixedCustomer"];
            }
            return aCustomerMaster;
        }


        public DataTable GetDZSMnameById(string dzsmId)
        {
            string queryStr = "SELECT RegionId,RegionName FROM dbo.tblRegion WHERE RegionCode = @RegionCode";
            return SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@RegionCode", SInventorySql.DbValue(dzsmId))
            });
        }

        public DataTable GetFEnameById(string feId)
        {
            string queryStr = "SELECT DistrictId,DistrictName FROM dbo.tblDistrict WHERE DistrictCode = @DistrictCode";
            return SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@DistrictCode", SInventorySql.DbValue(feId))
            });
        }

        public DataTable GetTeritorynameById(string teritoryId)
        {
            string queryStr = "SELECT AreaId,AreaName FROM dbo.tblArea WHERE AreaCode = @AreaCode";
            return SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@AreaCode", SInventorySql.DbValue(teritoryId))
            });
        }

        public DataTable GetMiaNameById(string miaId)
        {
            string queryStr = "SELECT MiaId,MiaName FROM dbo.tblMIAInfo WHERE MiaCode = @MiaCode";
            return SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@MiaCode", SInventorySql.DbValue(miaId))
            });
        }

        public DataTable GetMarketNameById(string marketId)
        {
            string queryStr = "SELECT MarketId,MarketName FROM dbo.tblMarket WHERE MarketCode = @MarketCode";
            return SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@MarketCode", SInventorySql.DbValue(marketId))
            });
        }

        public bool UpdateApiCustomerInformation(CustomerMaster aCustomerMaster)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            //aSqlParameterlist.Add(new SqlParameter("@CategoryId", aCustomerMaster.CategoryId));
            aSqlParameterlist.Add(new SqlParameter("@ApiCustomerId", aCustomerMaster.CustomerMasterId));
            //aSqlParameterlist.Add(new SqlParameter("@CustomerCode", aCustomerMaster.CustomerCode));
            aSqlParameterlist.Add(new SqlParameter("@CustomerName", aCustomerMaster.CustomerName));
            aSqlParameterlist.Add(new SqlParameter("@Address", aCustomerMaster.Address));
            aSqlParameterlist.Add(new SqlParameter("@CellNo", aCustomerMaster.CellNo));
            aSqlParameterlist.Add(new SqlParameter("@Addrees2", aCustomerMaster.Addrees2));
            aSqlParameterlist.Add(new SqlParameter("@City", aCustomerMaster.City));
            aSqlParameterlist.Add(new SqlParameter("@ConPerson", aCustomerMaster.ConPerson));
            //aSqlParameterlist.Add(new SqlParameter("@ShippingCond", aCustomerMaster.ShippingCond));
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
           // aSqlParameterlist.Add(new SqlParameter("@LoginName", HttpContext.Current.Session["LoginName"].ToString()));

            return aCommonInternalDal.UpdateAction("sp_UD_ApiCustomerMaster", aSqlParameterlist);
        }

        public CustomerMaster ApiCustomerInformation(string customermasterid)
        {
            string query = "SELECT * FROM [dbo].[tbltempCustMaster] WHERE [tempCustomerMasterId] = @TempCustomerMasterId";
            DataTable customerTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@TempCustomerMasterId", SInventorySql.DbValue(customermasterid))
            });
            CustomerMaster aCustomerMaster = new CustomerMaster();
            if (customerTable.Rows.Count > 0)
            {
                DataRow row = customerTable.Rows[0];
                aCustomerMaster.CustomerMasterId = Int32.Parse(row["tempCustomerMasterId"].ToString());
                aCustomerMaster.CustomerName = row["CustomerName"].ToString();
                aCustomerMaster.CustomerCode = row["CustomerCode"].ToString();
                aCustomerMaster.Address = row["Address"].ToString();
                aCustomerMaster.CellNo = row["CellNo"].ToString();
                aCustomerMaster.Addrees2 = row["Addrees2"].ToString();
                aCustomerMaster.City = row["City"].ToString();
                aCustomerMaster.ConPerson = row["ConPerson"].ToString();
                aCustomerMaster.MarketCode = row["MarketCode"].ToString();
                aCustomerMaster.MarketName = row["MarketName"].ToString();
                aCustomerMaster.MIACode = row["MIACode"].ToString();
                aCustomerMaster.MiaName = row["MIAName"].ToString();
                aCustomerMaster.AreaCode = row["AreaCode"].ToString();
                aCustomerMaster.DisCode = row["DisCode"].ToString();
                aCustomerMaster.FEName = row["FEName"].ToString();
                aCustomerMaster.ComUnitCode = row["ComUnitCode"].ToString();
                aCustomerMaster.ComUnitName = row["ComUnitName"].ToString();
                aCustomerMaster.RegionCode = row["RegionCode"].ToString();
                aCustomerMaster.DZSMName = row["DZSMName"].ToString();
                aCustomerMaster.TermOfPayment = row["TermOfPayment"].ToString();
                aCustomerMaster.FixedCustomer = (bool)row["FixedCustomer"];
            }
            return aCustomerMaster;
        }

        public bool HasCustomerMastername(CustomerMaster aMaster)
        {
            string query = "select top 1 CustomerMasterId from tblCustMaster where CustomerCode = @CustomerCode";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(aMaster.CustomerCode))
            });
        }


        public bool SaveApiCustomerInformation(CustomerMaster aCustomerMaster)
        {
            string insertQuery = @"INSERT INTO dbo.tblCustMaster
                        ( 
                          CustomerCode ,                          
                          CustomerName ,
                          CategoryId ,
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
                          FixedCustomer
                        )
                VALUES
                        (
                          @CustomerCode,
                          @CustomerName,
                          @CategoryId,
                          @Address,
                          @CellNo,
                          @Addrees2,
                          @City,
                          @ConPerson,
                          @ShippingCond,
                          @MarketCode,
                          @MarketName,
                          @MIACode,
                          @MIAName,
                          @AreaCode,
                          @DisCode,
                          @FEName,
                          @ComUnitCode,
                          @ComUnitName,
                          @RegionCode,
                          @DZSMName,
                          @TermOfPayment,
                          @CustomerCodeOld,
                          @FixedCustomer
                        )";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(aCustomerMaster.CustomerCode)),
                new SqlParameter("@CustomerName", SInventorySql.DbValue(aCustomerMaster.CustomerName)),
                new SqlParameter("@CategoryId", SInventorySql.DbValue(aCustomerMaster.CategoryId)),
                new SqlParameter("@Address", SInventorySql.DbValue(aCustomerMaster.Address)),
                new SqlParameter("@CellNo", SInventorySql.DbValue(aCustomerMaster.CellNo)),
                new SqlParameter("@Addrees2", SInventorySql.DbValue(aCustomerMaster.Addrees2)),
                new SqlParameter("@City", SInventorySql.DbValue(aCustomerMaster.City)),
                new SqlParameter("@ConPerson", SInventorySql.DbValue(aCustomerMaster.ConPerson)),
                new SqlParameter("@ShippingCond", SInventorySql.DbValue(aCustomerMaster.ShippingCond)),
                new SqlParameter("@MarketCode", SInventorySql.DbValue(aCustomerMaster.MarketCode)),
                new SqlParameter("@MarketName", SInventorySql.DbValue(aCustomerMaster.MarketName)),
                new SqlParameter("@MIACode", SInventorySql.DbValue(aCustomerMaster.MIACode)),
                new SqlParameter("@MIAName", SInventorySql.DbValue(aCustomerMaster.MiaName)),
                new SqlParameter("@AreaCode", SInventorySql.DbValue(aCustomerMaster.AreaCode)),
                new SqlParameter("@DisCode", SInventorySql.DbValue(aCustomerMaster.DisCode)),
                new SqlParameter("@FEName", SInventorySql.DbValue(aCustomerMaster.FEName)),
                new SqlParameter("@ComUnitCode", SInventorySql.DbValue(aCustomerMaster.ComUnitCode)),
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(aCustomerMaster.ComUnitName)),
                new SqlParameter("@RegionCode", SInventorySql.DbValue(aCustomerMaster.RegionCode)),
                new SqlParameter("@DZSMName", SInventorySql.DbValue(aCustomerMaster.DZSMName)),
                new SqlParameter("@TermOfPayment", SInventorySql.DbValue(aCustomerMaster.TermOfPayment)),
                new SqlParameter("@CustomerCodeOld", SInventorySql.DbValue(aCustomerMaster.CustomerCodeOld)),
                new SqlParameter("@FixedCustomer", SInventorySql.DbValue(aCustomerMaster.FixedCustomer))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool UpdateApiCustomerInfo(int customerMasterId)
        {
            string query = @"UPDATE [dbo].[tbltempCustMaster] SET [AddtoMainCustomer] = @AddtoMainCustomer WHERE [tempCustomerMasterId] = @TempCustomerMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@AddtoMainCustomer", true),
                new SqlParameter("@TempCustomerMasterId", customerMasterId)
            });
        }
    }
}
