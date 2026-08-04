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
    public class MIAInformationBLL
    {
        MiaInformationDAL aMiaInfoDaL = new MiaInformationDAL();
        public string SaveMiaInfo(MiaInformation MiaInformation)
        {
            try
            {
                if (!aMiaInfoDaL.HasMiaName(MiaInformation))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    MiaInformation.MiaId = aClsPrimaryKeyFind.PrimaryKeyMax("MiaId", "tblMIAInfo");
                    aMiaInfoDaL.SaveDataForMiaInfo(MiaInformation);
                    return "Data Save Successfully" ;
                }
                else
                {
                    return "Employee Name already exist";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public void LoadManfac(DropDownList ddl)
        {
            aMiaInfoDaL.LoadManfac(ddl);
        }
        public bool UpdateMIOCUstomer(string te, string mia,string name)
        {
            return aMiaInfoDaL.MioUpdate(te, mia, name);

        }
        
        public bool UpdateDataForMiaInformation(MiaInformation aMiaInformation)
        {
            return aMiaInfoDaL.UpdateaMiaInformation(aMiaInformation);
        }

        public DataTable LoadMiaInformation()
        {
            return aMiaInfoDaL.LoadMiaInformationView();
        }

        public MiaInformation MiaInformationEditLoad(string MiaInformationId)
        {
            return aMiaInfoDaL.MiaInformationEditLoad(MiaInformationId);
        }

        public void LoadRegionName(DropDownList dropDownList)
        {
            aMiaInfoDaL.LoadRegionname(dropDownList);
        }
        
        public DataTable EmpInfo(string EmpInfoId)
        {
            return aMiaInfoDaL.LoadEmpInfo(EmpInfoId);
        }
        public DataTable MiaInfo(string MiaInfoId)
        {
            return aMiaInfoDaL.LoadMiaInfoId(MiaInfoId);
        }
    }
}
