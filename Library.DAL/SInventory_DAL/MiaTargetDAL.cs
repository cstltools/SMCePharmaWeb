using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class MiaTargetDAL
    {
        public bool SaveMiaTarget(MiaTarget aMiaTarget)
        {
            string insertQuery = @"insert into tblMIATarget (MiaTargetId,MiaCode,MiaName,MiaTargetAmount,Period,Year) 
            values (@MiaTargetId,@MiaCode,@MiaName,@MiaTargetAmount,@Period,@Year)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@MiaTargetId", aMiaTarget.MiaTargetId),
                new SqlParameter("@MiaCode", SInventorySql.DbValue(aMiaTarget.MiaCode)),
                new SqlParameter("@MiaName", SInventorySql.DbValue(aMiaTarget.MiaName)),
                new SqlParameter("@MiaTargetAmount", aMiaTarget.MiaTargetAmount),
                new SqlParameter("@Period", SInventorySql.DbValue(aMiaTarget.Period)),
                new SqlParameter("@Year", SInventorySql.DbValue(aMiaTarget.Year))
            });
        }

        public bool HasMiaName(MiaTarget aMiaTarget)
        {
            string query = "select * from tblMIATarget where MiaName = @MiaName";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaName", SInventorySql.DbValue(aMiaTarget.MiaName))
            });
        }

        public DataTable LoadMiaTargetView()
        {
            string query = @"SELECT * from tblMIATarget ";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }

        public MiaTarget MiaTargetEditLoad(string MiaTargetId)
        {
            string query = "select * from tblMIATarget where MiaTargetId = @MiaTargetId";
            DataTable miaTargetTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaTargetId", SInventorySql.DbValue(MiaTargetId))
            });
            MiaTarget aMiaTarget = new MiaTarget();
            if (miaTargetTable.Rows.Count > 0)
            {
                DataRow miaTargetRow = miaTargetTable.Rows[0];
                aMiaTarget.MiaTargetId = Int32.Parse(miaTargetRow["MiaTargetId"].ToString());
                aMiaTarget.MiaCode = miaTargetRow["MiaCode"].ToString();
                aMiaTarget.MiaName = miaTargetRow["MiaName"].ToString();
                aMiaTarget.MiaTargetAmount = Convert.ToDecimal(miaTargetRow["MiaTargetAmount"].ToString());
            }
            return aMiaTarget;
        }

        public bool UpdateMiaTarget(MiaTarget aMiaTarget)
        {
            string query = @"UPDATE tblMIATarget SET MiaName=@MiaName,MiaTargetAmount=@MiaTargetAmount,Period=@Period,Year=@Year WHERE MiaTargetId=@MiaTargetId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaName", SInventorySql.DbValue(aMiaTarget.MiaName)),
                new SqlParameter("@MiaTargetAmount", aMiaTarget.MiaTargetAmount),
                new SqlParameter("@Period", SInventorySql.DbValue(aMiaTarget.Period)),
                new SqlParameter("@Year", SInventorySql.DbValue(aMiaTarget.Year)),
                new SqlParameter("@MiaTargetId", aMiaTarget.MiaTargetId)
            });
        }

        public DataTable LoadMiaInfo(string miaInfoId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT * FROM tblMIAInfo where MiaCode=@MiaCode";
            aDataTableEmpInfo = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaCode", SInventorySql.DbValue(miaInfoId.Trim()))
            });
            return aDataTableEmpInfo;
        }
    }
}
