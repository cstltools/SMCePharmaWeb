using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class DepartmentBLL
    {
        DepartmentDAL aDepartmentDal = new DepartmentDAL();
        public string SaveDataForDepartment(Department aDepartment)
        {
            try
            {
                if (!aDepartmentDal.HasDeptName(aDepartment))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aDepartment.DepartmentId = aClsPrimaryKeyFind.PrimaryKeyMax("DeptId", "tblDepartment");
                    aDepartment.DeaprtmentCode = DepartmentCodeGenerator(aDepartment.DepartmentId);
                    aDepartmentDal.SaveDepartmentInfo(aDepartment);
                    return "Data Save Successfully Department Code is :" + aDepartment.DeaprtmentCode + " And Department Name is : " + aDepartment.DepartmentName;
                }
                else
                {
                    return "Department Name already exist";
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public string DepartmentCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "0" + Id;
            }
            code = "DEPT-" + Id;
            return code;
        }

        public bool UpdateDataForDepartment(Department aDepartment)
        {
            return aDepartmentDal.UpdateDepartmentInfo(aDepartment);
        }

        public DataTable LoadDepartment()
        {
            return aDepartmentDal.LoadDepartment();
        }

        public Department DepartmentEditLoad(string userId)
        {
            return aDepartmentDal.DepartmentEditLoad(userId);
        }
    }
}
