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
    public class CompanyUnitDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDataForSalesCenter(CompanyUnit aCompanyUnit)
        {
            string insertQuery = @"insert into tblCompanyUnit (ComUnitId,ComUnitCode,ComUnitName,Address,PhoneNo,MobileNo,FaxNo) 
            values (@ComUnitId,@ComUnitCode,@ComUnitName,@Address,@PhoneNo,@MobileNo,@FaxNo)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", aCompanyUnit.ComUnitId),
                new SqlParameter("@ComUnitCode", SInventorySql.DbValue(aCompanyUnit.ComUnitCode)),
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(aCompanyUnit.ComUnitName)),
                new SqlParameter("@Address", SInventorySql.DbValue(aCompanyUnit.Address)),
                new SqlParameter("@PhoneNo", SInventorySql.DbValue(aCompanyUnit.PhoneNo)),
                new SqlParameter("@MobileNo", SInventorySql.DbValue(aCompanyUnit.MobileNo)),
                new SqlParameter("@FaxNo", SInventorySql.DbValue(aCompanyUnit.FaxNo))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasComUnitName(CompanyUnit aCompanyUnit)
        {
            string query = "select top 1 ComUnitId from tblCompanyUnit where ComUnitName = @ComUnitName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(aCompanyUnit.ComUnitName))
            };
            return SInventorySql.Exists(query, parameters);
        }
        
        public DataTable LoadSalesCenter()
        {
            string query = @"select * from tblCompanyUnit
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public CompanyUnit SalesCenterEditLoad(string ComUnitId)
        {
            string query = @"select * from tblCompanyUnit
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId where tblCompanyUnit.ComUnitId = @ComUnitId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId))
            };
            DataTable companyUnitTable = SInventorySql.GetDataTable(query, parameters);
            CompanyUnit aCompanyUnit = new CompanyUnit();
            if (companyUnitTable.Rows.Count > 0)
            {
                DataRow row = companyUnitTable.Rows[0];
                aCompanyUnit.ComUnitId = Int32.Parse(row["ComUnitId"].ToString());
                aCompanyUnit.ComUnitCode = row["ComUnitCode"].ToString();
                aCompanyUnit.ComUnitName = row["ComUnitName"].ToString();
                aCompanyUnit.PhoneNo = row["PhoneNo"].ToString();
                aCompanyUnit.Address = row["Address"].ToString();
                aCompanyUnit.MobileNo = row["MobileNo"].ToString();
                aCompanyUnit.FaxNo = row["FaxNo"].ToString();
            }
            return aCompanyUnit;
        }

        public bool UpdateSalesCenter(CompanyUnit aCompanyUnit)
        {
            string query = @"UPDATE tblCompanyUnit SET ComUnitName=@ComUnitName,ComUnitCode=@ComUnitCode,Address=@Address,PhoneNo=@PhoneNo WHERE ComUnitId=@ComUnitId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(aCompanyUnit.ComUnitName)),
                new SqlParameter("@ComUnitCode", SInventorySql.DbValue(aCompanyUnit.ComUnitCode)),
                new SqlParameter("@Address", SInventorySql.DbValue(aCompanyUnit.Address)),
                new SqlParameter("@PhoneNo", SInventorySql.DbValue(aCompanyUnit.PhoneNo)),
                new SqlParameter("@ComUnitId", aCompanyUnit.ComUnitId)
            };
            return SInventorySql.Execute(query, parameters);
        }
        
        public void LoadCompanyName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyInfo";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CompanyName", "CompanyId", queryStr);
        }

        public void LoadRegionName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblRegion";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionId", queryStr);
        }

    }
}
