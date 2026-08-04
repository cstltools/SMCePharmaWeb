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
    public class ZoneInfoBLL
    {
        ZoneInfoDAL aZoneInfoDAL = new ZoneInfoDAL();
        public string SaveZone(ZoneInfo ZoneInfo)
        {
            try
            {
                if (!aZoneInfoDAL.HasZoneName(ZoneInfo))
                {

                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    ZoneInfo.ZoneId = aClsPrimaryKeyFind.PrimaryKeyMax("ZoneId", "tblZone");
                    ZoneInfo.ZoneCode = ZoneCodeGenerator(ZoneInfo.ZoneId);
                    aZoneInfoDAL.SaveZoneInfo(ZoneInfo);
                    return "Data Save Successfully  ZoneInfo Code  is :  " + ZoneInfo.ZoneCode +
                           " And  ZoneInfo Name is :" + ZoneInfo.ZoneName;
                }
                else
                {
                    return "Zone Name is already exist";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
            
        }
        public string ZoneCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            
            if (Id.Length == 1)
            {
                Id = "0" + Id;
            }
            code = "ZONE-" + Id;
            return code;
        }


        public bool UpdateDataForZoneInfo(ZoneInfo aZoneInfo)
        {
            return aZoneInfoDAL.UpdateZoneInfo(aZoneInfo);
        }

        public DataTable LoadZoneInfo()
        {
            return aZoneInfoDAL.LoadZoneInfo();
        }

        public ZoneInfo ZoneInfoEditLoad(string ZoneInfoId)
        {
            return aZoneInfoDAL.ZoneEditLoad(ZoneInfoId);
        }

        public void CompanyUnitNameLoad(DropDownList dropDownList)
        {
            aZoneInfoDAL.LoadCompanyUnit(dropDownList);
        }
    }

    
}
