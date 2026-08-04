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

public partial class SInventory_RPTVIEW_ComUnitSalesReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    ComUnitSalesReportBLL aComUnitSalesReportBll = new ComUnitSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string comUnitId = Request.QueryString["ComUnitId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable comUnitDetailDataTable = aComUnitSalesReportBll.ComUnitSalesReportDetailDataBLL(comUnitId, FromDate, ToDate).Copy();

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            DataTable comUnitMainDataTable =
                aComUnitSalesReportBll.ComUnitSalesReportMainDataBLL(comUnitId, FromDate, ToDate).Copy();


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            comUnitMainDataTable.TableName = "comUnitMainDataTable";
            comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(comUnitMainDataTable);
            Ds.Tables.Add(comUnitDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptComUnitSales aComUnitSales=new rptComUnitSales();

            aComUnitSales.SetDataSource(Ds);
            crvComUnitSalesRpt.ReportSource = aComUnitSales;
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
    //        crvComUnitSalesRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvComUnitSalesRpt.Dispose();
    //    }
    //}
    protected void crvComUnitSalesRpt_Unload(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComUnitSalesRpt.Dispose();
        }
    }
    protected void crvComUnitSalesRpt_Disposed(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComUnitSalesRpt.Dispose();
        }
    }
}