using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class CompanyInfoDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDataForCompanyInfo(CompanyInformation aCompanyInfo)
        {
            string insertQuery = @"insert into tblCompanyInfo (CompanyId,CompanyCode,CompanyName,Address,ContactNo,FaxNo,Remarks) 
            values (@CompanyId,@CompanyCode,@CompanyName,@Address,@ContactNo,@FaxNo,@Remarks)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyId", aCompanyInfo.CompanyId),
                new SqlParameter("@CompanyCode", SInventorySql.DbValue(aCompanyInfo.CompanyCode)),
                new SqlParameter("@CompanyName", SInventorySql.DbValue(aCompanyInfo.CompanyName)),
                new SqlParameter("@Address", SInventorySql.DbValue(aCompanyInfo.Address)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aCompanyInfo.ContactNo)),
                new SqlParameter("@FaxNo", SInventorySql.DbValue(aCompanyInfo.FaxNo)),
                new SqlParameter("@Remarks", SInventorySql.DbValue(aCompanyInfo.Remarks))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasCompanyName(CompanyInformation aCompanyInfo)
        {
            string query = "select top 1 CompanyId from tblCompanyInfo where CompanyName = @CompanyName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyName", SInventorySql.DbValue(aCompanyInfo.CompanyName))
            };
            return SInventorySql.Exists(query, parameters);
        }


        public DataTable LoadCompanyInfo()
        {
            string query = @"SELECT tblCompanyInfo.CompanyId, tblCompanyInfo.CompanyName,tblCompanyInfo.Address,tblCompanyInfo.ContactNo,tblCompanyInfo.FaxNo,tblCompanyInfo.Remarks FROM tblCompanyInfo ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public CompanyInformation CompanyInfoEditLoad(string companyInfoId)
        {
            string query = "select * from tblCompanyInfo where CompanyId = @CompanyId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyId", SInventorySql.DbValue(companyInfoId))
            };
            DataTable companyTable = SInventorySql.GetDataTable(query, parameters);
            CompanyInformation aCompanyInfo = new CompanyInformation();
            if (companyTable.Rows.Count > 0)
            {
                DataRow row = companyTable.Rows[0];
                aCompanyInfo.CompanyId = Int32.Parse(row["CompanyId"].ToString());
                aCompanyInfo.CompanyCode = row["CompanyCode"].ToString();
                aCompanyInfo.CompanyName = row["CompanyName"].ToString();
                aCompanyInfo.ContactNo = row["ContactNo"].ToString();
                aCompanyInfo.Address = row["Address"].ToString();
                aCompanyInfo.FaxNo = row["FaxNo"].ToString();
                aCompanyInfo.Remarks = row["Remarks"].ToString();
            }
            return aCompanyInfo;
        }

        public bool UpdateCompanyInfo(CompanyInformation aCompanyInfo)
        {
            string query = @"UPDATE tblCompanyInfo SET CompanyName=@CompanyName,Address=@Address,ContactNo=@ContactNo,FaxNo=@FaxNo,Remarks=@Remarks WHERE CompanyId=@CompanyId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyName", SInventorySql.DbValue(aCompanyInfo.CompanyName)),
                new SqlParameter("@Address", SInventorySql.DbValue(aCompanyInfo.Address)),
                new SqlParameter("@ContactNo", SInventorySql.DbValue(aCompanyInfo.ContactNo)),
                new SqlParameter("@FaxNo", SInventorySql.DbValue(aCompanyInfo.FaxNo)),
                new SqlParameter("@Remarks", SInventorySql.DbValue(aCompanyInfo.Remarks)),
                new SqlParameter("@CompanyId", aCompanyInfo.CompanyId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
