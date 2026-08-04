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
    public class RegionInfoBLL
    {
        RegionDAL aRegionDAL = new RegionDAL();
        public string SaveRegion(RegionInfo RegionInfo)
        {
            try
            {
                if (!aRegionDAL.HasRegionName(RegionInfo))
                {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                RegionInfo.RegionId = aClsPrimaryKeyFind.PrimaryKeyMax("RegionId", "tblRegion");
                //RegionInfo.RegionCode = RegionCodeGenerator(RegionInfo.RegionId);
                aRegionDAL.SaveRegionInfo(RegionInfo);
                return "Data Save Successfully  RegionInfo Code  is :  " + RegionInfo.RegionCode + " And  RegionInfo Name is :" + RegionInfo.RegionName;
                }
                else
                {
                    return "Region Name already exist";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string RegionCodeGenerator(int id)
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
            code = "REG-" + Id;
            return code;
        }


        public bool UpdateDataForRegionInfo(RegionInfo aRegionInfo)
        {
            return aRegionDAL.UpdateRegionInfo(aRegionInfo);
        }

        public DataTable LoadRegionInfo()
        {
            return aRegionDAL.LoadRegionInfo();
        }

        public RegionInfo RegionInfoEditLoad(string RegionInfoId)
        {
            return aRegionDAL.RegionInfoEditLoad(RegionInfoId);
        }

        public void CompanyNameLoad(DropDownList dropDownList)
        {
            aRegionDAL.LoadCompanyName(dropDownList);
        }
    }
}
