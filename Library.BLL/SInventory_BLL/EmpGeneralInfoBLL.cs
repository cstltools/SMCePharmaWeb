using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class EmpGeneralInfoBLL
    {
        EmpGeneralInfoDAL aGeneralInfoDal = new EmpGeneralInfoDAL();
        public string SaveDataFoEmployeeInfo(EmpGeneralInfo aGeneralInfo)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                aGeneralInfo.EmpInfoId = aClsPrimaryKeyFind.PrimaryKeyMax("EmpInfoId", "tblEmpGeneralInfo");
                aGeneralInfo.EmpMasterCode = EmpMasterCodeGenerator(aGeneralInfo.EmpInfoId);
                aGeneralInfoDal.SaveEmployeeInfo(aGeneralInfo);
                return "Data Save Successfully and the Employee Master Code is    :" + aGeneralInfo.EmpMasterCode + " and the Employee Name is  :" + aGeneralInfo.EmpName;              
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public string EmpMasterCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "0" + Id;
            }
            code = "EMP-" + Id;
            return code;
        }
        public DataTable LoadEmpGeneralInformation()
        {
            return aGeneralInfoDal.LoadEmpGeneralInformation();
        }

        public void LoadDesignationToDropDownBLL(DropDownList aDropDownList)
        {
            aGeneralInfoDal.LoadDesignationName(aDropDownList);
        }
        public void LoadDepartmentToDropDownBLL(DropDownList aDropDownList)
        {
            aGeneralInfoDal.LoadDepartmentName(aDropDownList);
        }
      
        public bool UpdateDataForEmpGeneralInfo(EmpGeneralInfo aEmpGeneralInfo)
        {
            return aGeneralInfoDal.UpdateEmployeeInfo(aEmpGeneralInfo);
        }

        public DataTable LoadEmpGeneralInfo()
        {
            return aGeneralInfoDal.LoadEmployeeView();
        }

        public EmpGeneralInfo EmpGeneralInfoEditLoad(string EmpInfoId)
        {
            return aGeneralInfoDal.EmpInfoEditLoad(EmpInfoId);
        }

        public List<EmpGeneralInfo> GetEmployeeName(string EmpInfoId)
        {
            return aGeneralInfoDal.ViewEmpName(EmpInfoId);
        }       

    }
}
