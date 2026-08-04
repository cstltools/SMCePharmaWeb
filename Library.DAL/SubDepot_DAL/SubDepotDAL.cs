using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SubDepot_DAL
{
    public class SubDepotDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDataForSalesCenter(CompanyUnit aCompanyUnit)
        {
            string insertQuery = @"insert into tblSubDepot (ComUnitId,SubDepotCode,SubDepotName,Address,PhoneNo,MobileNo,FaxNo) 
            values (" + aCompanyUnit.ComUnitId + ",'" + aCompanyUnit.ComUnitCode + "','" + aCompanyUnit.ComUnitName + "','" + aCompanyUnit.Address + "'," +
                                 "'" + aCompanyUnit.PhoneNo + "','" + aCompanyUnit.MobileNo + "','" + aCompanyUnit.FaxNo + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public DataTable LoadZoneInfo()
        {
            string query = @"SELECT * from tblSubDepot ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public bool HasComUnitName(CompanyUnit aCompanyUnit)
        {
            string query = "select * from tblCompanyUnit where ComUnitName = '" + aCompanyUnit.ComUnitName + "'";
            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    return true;
                }
            }
            return false;
        }
        
        public DataTable LoadSalesCenter()
        {
            string query = @"select * from tblCompanyUnit
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetId()
        {
            string query = @"SELECT (COUNT(*)+1)ID FROM dbo.tblSubDepot";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadSubDepotById(string id)
        {
            string query = @"SELECT * FROM dbo.tblSubDepot
            LEFT JOIN dbo.tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblSubDepot.ComUnitId
            WHERE SubDepotId='"+id+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public CompanyUnit SalesCenterEditLoad(string ComUnitId)
        {
            string query = @"select * from tblCompanyUnit
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId where tblCompanyUnit.ComUnitId = '" + ComUnitId + "'";
            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            CompanyUnit aCompanyUnit = new CompanyUnit();
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    aCompanyUnit.ComUnitId = Int32.Parse(dataReader["ComUnitId"].ToString());
                    aCompanyUnit.ComUnitCode = dataReader["ComUnitCode"].ToString();
                    aCompanyUnit.ComUnitName = dataReader["ComUnitName"].ToString();
                    aCompanyUnit.PhoneNo = dataReader["PhoneNo"].ToString();
                    aCompanyUnit.Address = dataReader["Address"].ToString();
                    //aCompanyUnit.RegionId = Convert.ToInt32(dataReader["RegionId"].ToString());
                    //aCompanyUnit.CompanyId = Convert.ToInt32(dataReader["CompanyId"].ToString());
                    aCompanyUnit.MobileNo = dataReader["MobileNo"].ToString();
                    aCompanyUnit.FaxNo = dataReader["FaxNo"].ToString();

                }
            }
            return aCompanyUnit;
        }

        public bool UpdateSalesCenter(CompanyUnit aCompanyUnit)
        {
            string query = @"UPDATE tblSubDepot SET SubDepotName='" + aCompanyUnit.ComUnitName + "',SubDepotCode='" + aCompanyUnit.ComUnitCode + "',Address='" + aCompanyUnit.Address + "',PhoneNo='" + aCompanyUnit.PhoneNo + "',ComUnitId='" + aCompanyUnit.ComUnitId + "' WHERE SubDepotId=" + aCompanyUnit.RegionId + "";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
        
        public void LoadCompanyName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }

        public void LoadRegionName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblRegion";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionId", queryStr);
        }

    }
}
