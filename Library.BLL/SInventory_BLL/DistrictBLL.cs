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
    public class DistrictInfoBLL
    {
        DistrictDAL aDistrictInfoDAL = new DistrictDAL();
        public string SaveDataForDistrictInfo(DistrictInfo aDistrictInfo)
        {
            try
            {
                if (!aDistrictInfoDAL.HasDistrictName(aDistrictInfo))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aDistrictInfo.DistrictId = aClsPrimaryKeyFind.PrimaryKeyMax("DistrictId", "tblDistrict");
                    //aDistrictInfo.DistrictCode = DistrictInfoCodeGenerator(aDistrictInfo.DistrictId);
                    aDistrictInfoDAL.SaveDistrictInfo(aDistrictInfo);
                    return "Data Save Successfully DistrictInfo Code is :" + aDistrictInfo.DistrictCode + " And DistrictInfo Name is : " + aDistrictInfo.DistrictName;
                }
                else
                {
                    return "DistrictInfo Name already exist";
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public string DistrictInfoCodeGenerator(int id)
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
            code = "DIST-" + Id;
            return code;
        }

        public bool UpdateDataForDistrictInfo(DistrictInfo aDistrictInfo)
        {
            return aDistrictInfoDAL.UpdateDistrictInfo(aDistrictInfo);
        }

        public DataTable LoadDistrictInfo()
        {
            return aDistrictInfoDAL.LoadDistrictView();
        }

        public DistrictInfo DistrictInfoEditLoad(string districtId)
        {
            return aDistrictInfoDAL.DistrictInfoEditLoad(districtId);
        }
        public void LoadCompanyUnit(DropDownList ddl)
        {
            aDistrictInfoDAL.LoadCompanyUnit(ddl);
        }

        public void LoadZoneByCompanyUnit(DropDownList ddl,string comUnitId)
        {
            aDistrictInfoDAL.LoadZoneByComUnit(ddl,comUnitId);
        }
    }
}
