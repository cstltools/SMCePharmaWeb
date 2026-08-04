using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_SubDeportDelivaryTopSheetInvoiceReturnViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    Sub_InvoiceBLL aInvoiceBll = new Sub_InvoiceBLL();
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
        string invColl = aInvoiceBll.InvoiceNoCollectionFormate(invNo);
      //  string reportparameter = Session["DelInvoiceReportParameter"].ToString();

        string comunitId = Session["comunitId"].ToString();
        string manufId = Session["manufId"].ToString();
        string marketId = Session["marketId"].ToString();
        string invdate = Session["invdate"].ToString();

        DataTable mainDataTable = aOrderInfoBll.LoadInvoiceSubdeport(comunitId, manufId, marketId, Convert.ToDateTime(invdate)).Copy();
        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
        DataSet Ds = new DataSet();
        mainDataTable.TableName = "delInvoiceDataTable";
        companyInfoDataTable.TableName = "companyInfoDataTable";
        Ds.Tables.Add(mainDataTable);
        Ds.Tables.Add(companyInfoDataTable);
        rptdoc.Load(ReportPath("rptDelivaryTopSheet.rpt"));
        rptdoc.SetDataSource(Ds);

        crvInvoiceReport.ReportSource = rptdoc;
        crvInvoiceReport.DataBind();

    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
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
    //        crvInvoiceReport.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvInvoiceReport.Dispose();
    //    }
    //}
    protected void crvInvoiceReport_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
    }
    protected void crvInvoiceReport_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
    }
}