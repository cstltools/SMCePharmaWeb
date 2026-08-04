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
    public class DepartmentDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDepartmentInfo(Department aDepartment)
        {
            string insertQuery = @"insert into tblDepartment (DeptId,DeptCode,DeptName) 
            values (@DeptId,@DeptCode,@DeptName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DeptId", aDepartment.DepartmentId),
                new SqlParameter("@DeptCode", SInventorySql.DbValue(aDepartment.DeaprtmentCode)),
                new SqlParameter("@DeptName", SInventorySql.DbValue(aDepartment.DepartmentName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasDeptName(Department aDepartment)
        {
            string query = "select top 1 DeptId from tblDepartment where DeptName = @DeptName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DeptName", SInventorySql.DbValue(aDepartment.DepartmentName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadDepartment()
        {
            string query = @"select * from tblDepartment";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public Department DepartmentEditLoad(string DeptId)
        {
            string query = "select * from tblDepartment where DeptId = @DeptId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DeptId", SInventorySql.DbValue(DeptId))
            };
            DataTable departmentTable = SInventorySql.GetDataTable(query, parameters);
            Department aDepartment = new Department();
            //EmpGeneralInfo aGeneralInfo=new EmpGeneralInfo();


            if (departmentTable.Rows.Count > 0)
            {
                DataRow row = departmentTable.Rows[0];
                aDepartment.DepartmentId = Int32.Parse(row["DeptId"].ToString());
                aDepartment.DepartmentName = row["DeptName"].ToString();
            }
            return aDepartment;
        }

        public bool UpdateDepartmentInfo(Department aDepartment)
        {
            string query = @"UPDATE tblDepartment SET DeptName=@DeptName WHERE DeptId=@DeptId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DeptName", SInventorySql.DbValue(aDepartment.DepartmentName)),
                new SqlParameter("@DeptId", aDepartment.DepartmentId)
            };
            return SInventorySql.Execute(query, parameters);
        }

    }
}
