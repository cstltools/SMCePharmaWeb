using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_RegionSalesReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    RegionSalesReportBLL aRegionSalesReportBll = new RegionSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string RegionId = Request.QueryString["RegionId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable regionDetailDataTable = aRegionSalesReportBll.RegionSalesReportDetailDataBLL(RegionId, FromDate, ToDate).Copy();

        if (regionDetailDataTable.Rows.Count > 0)
        {
            DataTable regionMainDataTable =aRegionSalesReportBll.RegionSalesReportMainDataBLL(RegionId, FromDate, ToDate).Copy();
            
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            regionMainDataTable.TableName = "regionMainDataTable";
            regionDetailDataTable.TableName = "regionDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(regionMainDataTable);
            Ds.Tables.Add(regionDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptRegionSales aRegionSales=new rptRegionSales();

            aRegionSales.SetDataSource(Ds);
            crvRegionSalesRpt.ReportSource = aRegionSales;
        }
        else
        {
            MessageLabel.Text = "No Data Found!!";
        }
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
 
    protected void crvRegionSalesRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvRegionSalesRpt.Dispose();
    }
    protected void crvRegionSalesRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvRegionSalesRpt.Dispose();
    }
}