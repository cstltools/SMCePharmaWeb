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
    public class MIOTotalSummaryBLL
    {
        MIOTotalSummaryDAL aTotalSummaryDAL = new MIOTotalSummaryDAL();


        public DataTable LoadSummaryBLL(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryDAL(fromdate, todate);
        }
        public DataTable LoadSummary2BLL(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewise(fromdate, todate);
        }
        public DataTable LoadSummaryzonewiseBLL(DateTime fromdate, DateTime todate, string zone)
        {
            return aTotalSummaryDAL.LoadSummaryzonewiseDAL(fromdate, todate, zone);
        }
        public DataTable LoadSummaryzoneBranchwiseBLL(DateTime fromdate, DateTime todate, string zone, string Branch)
        {
            return aTotalSummaryDAL.LoadSummaryzoneBranchwiseBLL(fromdate, todate, zone, Branch);
        }

        public DataTable LoadSummaryzoneBranchTerritorywiseBLL(DateTime fromdate, DateTime todate, string zone, string Branch, string territory)
        {
            return aTotalSummaryDAL.LoadSummaryzoneBranchTerritorywiseBLL(fromdate, todate, zone, Branch, territory);
        }







        public DataTable LoadSummaryProductcodewiseGyash(string id,DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewiseGyash(id,fromdate, todate);
        }

        public DataTable BranchwiseLoadSummaryBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            return aTotalSummaryDAL.BranchwiseLoadSummaryBLL(fromdate, todate, Branch);
        }
        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            return aTotalSummaryDAL.DZSMwiseLoadSummaryBLL(fromdate, todate, Branch);
        }
        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.DZSMwiseLoadSummaryBLL(fromdate, todate);
        }
      
    }
}
