using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class DCStockReportBLL
    {
        DCStockReportDAL aDcStockReportDal=new DCStockReportDAL();
        public void LoadCompanyUnit(DropDownList ddl)
        {
            aDcStockReportDal.LoadCompanyUnit(ddl);
        }

        public void LoadCompanyUnit(DropDownList ddl,string comUnitId)
        {
            aDcStockReportDal.LoadCompanyUnit(ddl,comUnitId);
        }

        public DataTable DCReportMainDataDAL(string comUnitId)
        {
            return aDcStockReportDal.DCReportMainDataDAL(comUnitId);
        }

        public DataTable DCReportDetailDataDAL(string comUnitId)
        {
            return aDcStockReportDal.DCReportDetailDataDAL(comUnitId);
        }
        public DataTable WHReportDetailDataDAL()
        {
            return aDcStockReportDal.WHReportDetailDataDAL();
        }
        public DataTable WHReportDetailDataDAL(string Pcode)
        {
            return aDcStockReportDal.WHReportDetailDataDAL(Pcode);
        }
        public DataTable DCWiseCountryReportDetailDataDAL()
        {
            return aDcStockReportDal.DCWiseCountryReportDetailDataDAL();
        }


        public DataTable SubDeportStockReportDetailDataDAL(string comUnitId)
        {
            return aDcStockReportDal.SubDeportStockReportDetailDataDAL(comUnitId);
        }
    }
}
