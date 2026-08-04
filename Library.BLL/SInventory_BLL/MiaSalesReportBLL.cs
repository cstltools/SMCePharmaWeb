using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class MiaSalesReportBLL
    {
        MiaSalesReportDAL aMiaSalesReportDal = new MiaSalesReportDAL();

        public void LoadCompanyUnit(DropDownList ddl)
        {
            aMiaSalesReportDal.LoadComUnit(ddl);
        }

        public void LoadCompanyUnit(DropDownList ddl, string comUnitId)
        {
            aMiaSalesReportDal.LoadComUnit(ddl, comUnitId);
        }
        public void LoadMiaByComUnitBLL(DropDownList dropDownList, string comUnitId)
        {
            aMiaSalesReportDal.LoadMiaByComUnit(dropDownList, comUnitId);
        }
        public DataTable MiaWiseReportMainDataBLL(string miaId,DateTime fromDate,DateTime toDate,string comuntiId)
        {
            return aMiaSalesReportDal.MiaWiseReportMainDataDAL(miaId, fromDate, toDate,comuntiId);
        }
        
        public DataTable MiaWiseReportDetailDataBLL(string miaId,DateTime fromDate,DateTime toDate)
        {
            return aMiaSalesReportDal.MiaWiseReportDetailDataDAL(miaId, fromDate, toDate);
        }
    }
}
