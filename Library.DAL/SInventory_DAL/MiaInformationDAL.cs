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
    public class MiaInformationDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDataForMiaInfo(MiaInformation aMiaInformation)
        {
            string insertQuery = @"insert into tblMIAInfo (MiaId,AreaId,MiaCode,MiaName) 
            values (@MiaId,@AreaId,@MiaCode,@MiaName)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@MiaId", aMiaInformation.MiaId),
                new SqlParameter("@AreaId", SInventorySql.DbValue(aMiaInformation.AreaId)),
                new SqlParameter("@MiaCode", SInventorySql.DbValue(aMiaInformation.MiaCode)),
                new SqlParameter("@MiaName", SInventorySql.DbValue(aMiaInformation.MiaName))
            });
        }
        public bool HasMiaName(MiaInformation aMiaInformation)
        {
            string query = "select * from tblMIAInfo where MiaCode = @MiaCode";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaCode", SInventorySql.DbValue(aMiaInformation.MiaCode))
            });
        }

        public bool MioUpdate(string ter, string mio, string name)
        {

            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@ter", ter));
            aSqlParameterlist.Add(new SqlParameter("@mio", mio));
            aSqlParameterlist.Add(new SqlParameter("@name", name));

            return aCommonInternalDal.DeleteAction("sp_MioUpdateInCustomerInfo", aSqlParameterlist);

        }

        public DataTable LoadMiaInformationView()
        {
            string query = @"SELECT *  FROM tblMIAInfo
                            LEFT JOIN dbo.tblArea ON dbo.tblMIAInfo.AreaId = dbo.tblArea.AreaId
                            LEFT JOIN dbo.tblDistrict ON dbo.tblArea.DistrictId = dbo.tblDistrict.DistrictId
                            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDistrict.ComUnitId = dbo.tblCompanyUnit.ComUnitId
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId
                            LEFT JOIN dbo.tblManufacturer ON dbo.tblMIAInfo.ManufacId=dbo.tblManufacturer.ManufacId
                             ";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }
        
        public MiaInformation MiaInformationEditLoad(string MiaId)
        {
            string query = @"SELECT *  FROM tblMIAInfo
                       
                         where MiaId = @MiaId";
            DataTable miaTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaId", SInventorySql.DbValue(MiaId))
            });
            MiaInformation aMiaInformation = new MiaInformation();
            if (miaTable.Rows.Count > 0)
            {
                DataRow miaRow = miaTable.Rows[0];
                aMiaInformation.MiaId = Int32.Parse(miaRow["MiaId"].ToString());
                aMiaInformation.MiaName = miaRow["MiaName"].ToString();
                aMiaInformation.MiaCode = miaRow["MiaCode"].ToString();
                //aMiaInformation.AreaId = Convert.ToInt32(dataReader["AreaId"].ToString());
                //aMiaInformation.DistrictId = Convert.ToInt32(dataReader["DistrictId"].ToString());
                //aMiaInformation.ComUnitId = Convert.ToInt32(dataReader["ComUnitId"].ToString());
                //aMiaInformation.RegionId = Convert.ToInt32(dataReader["RegionId"].ToString());
                //aMiaInformation.CompanyId = Convert.ToInt32(dataReader["CompanyId"].ToString());
            }
            return aMiaInformation;
        }
        
        public bool UpdateaMiaInformation(MiaInformation aMiaInformation)
        {
            string query = @"UPDATE tblMIAInfo SET MiaName=@MiaName,MiaCode=@MiaCode WHERE MiaId=@MiaId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaName", SInventorySql.DbValue(aMiaInformation.MiaName)),
                new SqlParameter("@MiaCode", SInventorySql.DbValue(aMiaInformation.MiaCode)),
                new SqlParameter("@MiaId", aMiaInformation.MiaId)
            });
        }
        
        public void LoadRegionname(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblRegion";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionId", queryStr);
        }
        public void LoadManfac(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public DataTable LoadEmpInfo(string EmpInfoId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT * FROM tblEmpGeneralInfo where EmpMasterCode=@EmpMasterCode";
            aDataTableEmpInfo = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@EmpMasterCode", SInventorySql.DbValue(EmpInfoId.Trim()))
            });
            return aDataTableEmpInfo;
        }
        public DataTable LoadMiaInfoId(string MiaInfoId)
        {
            DataTable aDataTableMiaInfo = new DataTable();
            string query = @"SELECT * FROM tblMIAInfo where MiaCode=@MiaCode";
            aDataTableMiaInfo = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaCode", SInventorySql.DbValue(MiaInfoId.Trim()))
            });
            return aDataTableMiaInfo;
        }
        
    }
}
