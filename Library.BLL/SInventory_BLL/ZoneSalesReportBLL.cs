using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class ZoneSalesReportBLL
    {
        ZoneSalesReportDAL aZoneSalesReportDAL = new ZoneSalesReportDAL();

        public void LoadComUnit(DropDownList dropDownList)
        {
            aZoneSalesReportDAL.LoadComUnit(dropDownList);
        }
        public void LoadComUnit(DropDownList dropDownList, string comUnitId)
        {
            aZoneSalesReportDAL.LoadComUnit(dropDownList,comUnitId);
        }

        public void LoadZone(DropDownList dropDownList, string zoneId)
        {
            aZoneSalesReportDAL.LoadZone(dropDownList, zoneId);
        }

        public DataTable ZoneSalesReportDetailDataBLL(string zobeId, DateTime fromDate, DateTime toDate)
        {
            return aZoneSalesReportDAL.ZoneReportDetailDataDAL(zobeId, fromDate, toDate);
        }
        public DataTable ZoneSalesReportMainDataBLL(string zobeId, DateTime fromDate, DateTime toDate)
        {
            return aZoneSalesReportDAL.ZoneReportMainDataDAL(zobeId, fromDate, toDate);
        }
    }
}
