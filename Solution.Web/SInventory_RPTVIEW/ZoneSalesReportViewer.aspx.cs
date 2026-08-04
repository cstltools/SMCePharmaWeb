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

public partial class SInventory_RPTVIEW_ZoneSalesReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    ZoneSalesReportBLL aZoneSalesReportBll = new ZoneSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string zoneId = Request.QueryString["zoneId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable zoneDetailDataTable = aZoneSalesReportBll.ZoneSalesReportDetailDataBLL(zoneId, FromDate, ToDate).Copy();

        if (zoneDetailDataTable.Rows.Count > 0)
        {
            DataTable zoneMainDataTable =
                aZoneSalesReportBll.ZoneSalesReportMainDataBLL(zoneId, FromDate, ToDate).Copy();


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            zoneMainDataTable.TableName = "zoneMainDataTable";
            zoneDetailDataTable.TableName = "zoneDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(zoneMainDataTable);
            Ds.Tables.Add(zoneDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptZoneSales aZoneSales=new rptZoneSales();

            aZoneSales.SetDataSource(Ds);
            crvZoneSalesRpt.ReportSource = aZoneSales;
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
    //protected void crViewer_Unload(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvZoneSalesRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvZoneSalesRpt.Dispose();
    //    }
    //}
    protected void crvZoneSalesRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvZoneSalesRpt.Dispose();
    }
    protected void crvZoneSalesRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvZoneSalesRpt.Dispose();
    }
}