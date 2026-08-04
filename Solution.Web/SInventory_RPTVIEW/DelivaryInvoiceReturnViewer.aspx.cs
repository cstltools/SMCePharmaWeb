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

public partial class SInventory_RPTVIEW_InvoiceReturnViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
        string invColl = aInvoiceBll.InvoiceNoCollectionFormate(invNo);

        DataTable mainDataTable = aInvoiceBll.DelivaryInvoiceMainDataForReport(invColl).Copy();
        DataTable detailDataTable = aInvoiceBll.DelivaryInvoiceDetailDataForReport(invColl).Copy();
        //DataTable mainDataTable1 = aInvoiceBll.InvoiceMainDataForReportBLL(invColl).Copy();
        //DataTable detailDataTable1 = aInvoiceBll.InvoiceDetailDataForReportBLL(invColl).Copy();
        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

      //  rptInvoiceForCustomerDelivary aRptInvoiceForCustomer = new rptInvoiceForCustomerDelivary();

        DataSet Ds = new DataSet();

        mainDataTable.TableName = "mainDataTable";
        detailDataTable.TableName = "detailDataTable";
        companyInfoDataTable.TableName = "companyInfoDataTable";
        Ds.Tables.Add(mainDataTable);
        Ds.Tables.Add(detailDataTable);
        Ds.Tables.Add(companyInfoDataTable);
      //  aRptInvoiceForCustomer.SetDataSource(Ds);
      //  crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;
        rptdoc.Load(ReportPath("rptInvoiceForCustomerDelivary.rpt"));
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