using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class CompanywisebranchDal
    {
        private readonly ClsCommonInternalDAL aCommonInternalDAL = new ClsCommonInternalDAL();

        public void LoadCompany(DropDownList ddl, string userId)
        {
            const string queryStr = @"select ComUnitId, ComUnitName  from tblCompanyUnit WHERE ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";
            LoadDropDownValue(ddl, "ComUnitName", "ComUnitId", queryStr, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userId == null ? null : userId.Trim()))
            });
        }

        public void LoadBank(DropDownList ddl, string companyId)
        {
            const string query = @"SELECT BankId,BankName FROM tblBankInfoNew  where IsActive=1 and  ComUnitId=@ComUnitId";
            LoadDropDownValue(ddl, "BankName", "BankId", query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(companyId))
            });
        }

        public void LoadBranch(DropDownList ddl, string bankId)
        {
            const string query = @"SELECT BranchId,BranchName FROM tblBranchInfo WHERE BankId = @BankId";
            LoadDropDownValue(ddl, "BranchName", "BranchId", query, new List<SqlParameter>
            {
                new SqlParameter("@BankId", SInventorySql.DbValue(bankId))
            });
        }

        public Int32 SaveDepositInfo(CompanyWiseDepositDao aDepositDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@CompanyId", aDepositDao.CompanyId));
            aSqlParameterlist.Add(new SqlParameter("@Amount", aDepositDao.Amount));
            aSqlParameterlist.Add(new SqlParameter("@AIT", aDepositDao.AIT));
            aSqlParameterlist.Add(new SqlParameter("@EntryBy", aDepositDao.EntryBy));
            aSqlParameterlist.Add(new SqlParameter("@EntryDate", aDepositDao.EntryDate));
            aSqlParameterlist.Add(new SqlParameter("@DepositDate", aDepositDao.DepositDate));
            aSqlParameterlist.Add(new SqlParameter("@IsDelete", aDepositDao.IsDelete));
            aSqlParameterlist.Add(new SqlParameter("@IsExcelUpload", aDepositDao.IsExcelUpload));
            aSqlParameterlist.Add(new SqlParameter("@Remarks", aDepositDao.Remarks));
            aSqlParameterlist.Add(new SqlParameter("@DepositType", aDepositDao.DepositType));

            aSqlParameterlist.Add(new SqlParameter("@BankId", aDepositDao.BankId));
            aSqlParameterlist.Add(new SqlParameter("@CheckNumber", aDepositDao.CheckNumber ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@CheckDate", aDepositDao.CheckDate ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@BranchName", aDepositDao.BranchName ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@AccountName", aDepositDao.AccountName ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@MIOId", aDepositDao.MIOId ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@DepositCode", aDepositDao.DepositCode ?? (object)DBNull.Value));

            return aCommonInternalDAL.SaveAction("sp_I_Diposit_New", aSqlParameterlist, "@DepositId");
        }

        public Int32 SaveTargetValueInfo(TargetExcelUploadDao aDepositDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@EntryBy", aDepositDao.EntryBy));
            aSqlParameterlist.Add(new SqlParameter("@TerritoryCode", aDepositDao.TerritoryCode ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@Value", aDepositDao.Value ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@MonthName", aDepositDao.MonthName ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@YearValue", aDepositDao.YearValue ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@FinYearValue", aDepositDao.FinYearValue ?? (object)DBNull.Value));

            return aCommonInternalDAL.SaveAction("usp_InsertTerritoryData", aSqlParameterlist, "@SL");
        }

        public DataTable LoadDepositList(DateTime? fromDate, DateTime? toDate, string companyId)
        {
            string queryStr = @"SELECT  DP.EmpMasterCode, emp.EmpName,  DP.EntryDate, AIT,DP.DepositId,CI.ComUnitName,BNK.BankName,DP.BranchName,DP.DepositDate,DP.Amount,DP.DepositType,DP.AccountName,CheckNumber,CheckDate,Remarks FROM tblCompanyWiseDeposit AS DP
INNER JOIN tblCompanyUnit  AS CI ON DP.CompanyId = CI.ComUnitId
left  JOIN tblEmpGeneralInfo  AS emp ON DP.EmpMasterCode = emp.EmpMasterCode
LEFT JOIN tblBankInfo AS BNK ON DP.BankId = BNK.BankId WHERE ISNULL(DP.IsDelete,0) = 0 ";

            var parameters = new List<SqlParameter>();
            if (fromDate.HasValue && toDate.HasValue)
            {
                queryStr += " AND convert(date,DP.DepositDate) BETWEEN convert(date,@FromDate) AND convert(date,@ToDate)";
                parameters.Add(new SqlParameter("@FromDate", fromDate.Value));
                parameters.Add(new SqlParameter("@ToDate", toDate.Value));
            }

            if (!string.IsNullOrWhiteSpace(companyId))
            {
                queryStr += " AND CI.ComUnitId = @ComUnitId";
                parameters.Add(new SqlParameter("@ComUnitId", companyId.Trim()));
            }

            return SInventorySql.GetDataTable(queryStr, parameters);
        }

        public DataTable GetDepositInfoById(int depositId)
        {
            const string queryStr = @"SELECT * FROM tblCompanyWiseDeposit WHERE DepositId = @DepositId AND ISNULL(IsDelete,0) = 0";
            return SInventorySql.GetDataTable(queryStr, new List<SqlParameter> { new SqlParameter("@DepositId", depositId) });
        }

        public bool UpdateDepositInfo(CompanyWiseDepositDao aDepositDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@DepositId", aDepositDao.DepositId));
            aSqlParameterlist.Add(new SqlParameter("@IsDelete", aDepositDao.IsDelete));
            aSqlParameterlist.Add(new SqlParameter("@DeleteBy", aDepositDao.DeleteBy));
            aSqlParameterlist.Add(new SqlParameter("@DeleteDate", aDepositDao.DeleteDate));

            const string queryStr = @"UPDATE tblCompanyWiseDeposit
SET IsDelete = @IsDelete, DeleteBy = @DeleteBy, DeleteDate = @DeleteDate
WHERE DepositId = @DepositId
AND CONVERT(date, DepositDate) BETWEEN CONVERT(date, DATEADD(day, -60, GETDATE())) AND CONVERT(date, GETDATE())";
            return aCommonInternalDAL.UpdateDataByUpdateCommandNew(queryStr, aSqlParameterlist);
        }

        public bool UpdateFullDepositInfo(CompanyWiseDepositDao aDepositDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@DepositId", aDepositDao.DepositId));
            aSqlParameterlist.Add(new SqlParameter("@CompanyId", aDepositDao.CompanyId));
            aSqlParameterlist.Add(new SqlParameter("@Amount", aDepositDao.Amount));
            aSqlParameterlist.Add(new SqlParameter("@AIT", aDepositDao.AIT));
            aSqlParameterlist.Add(new SqlParameter("@DepositDate", aDepositDao.DepositDate));
            aSqlParameterlist.Add(new SqlParameter("@Remarks", aDepositDao.Remarks));
            aSqlParameterlist.Add(new SqlParameter("@DepositType", aDepositDao.DepositType));
            aSqlParameterlist.Add(new SqlParameter("@BankId", aDepositDao.BankId));
            aSqlParameterlist.Add(new SqlParameter("@CheckNumber", aDepositDao.CheckNumber ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@CheckDate", aDepositDao.CheckDate ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@BranchName", aDepositDao.BranchName ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@AccountName", aDepositDao.AccountName ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@MIOId", aDepositDao.MIOId ?? (object)DBNull.Value));

            const string queryStr = @"UPDATE tblCompanyWiseDeposit SET CompanyId = @CompanyId, Amount = @Amount, AIT = @AIT, DepositDate = @DepositDate, Remarks = @Remarks, DepositType = @DepositType, BankId = @BankId, CheckNumber = @CheckNumber, CheckDate = @CheckDate, BranchName = @BranchName, AccountName = @AccountName, MIOId = @MIOId WHERE DepositId = @DepositId";
            return aCommonInternalDAL.UpdateDataByUpdateCommandNew(queryStr, aSqlParameterlist);
        }

        private static void LoadDropDownValue(DropDownList ddl, string displayField, string valueField, string queryString, List<SqlParameter> parameters)
        {
            DataTable dt = SInventorySql.GetDataTable(queryString, parameters);

            ddl.DataTextField = displayField;
            ddl.DataValueField = valueField;
            ddl.DataSource = dt;
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("--------Select---------", string.Empty));
            ddl.SelectedIndex = 0;
        }
    }
}
