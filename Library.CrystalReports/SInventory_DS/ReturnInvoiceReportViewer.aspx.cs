using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_InvoiceReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
        string invColl = aInvoiceBll.InvoiceNoCollectionFormate(invNo);
        DataTable mainDataTable = aInvoiceBll.ReturnInvoiceMainDataForReportBLL(invColl).Copy();
        DataTable detailDataTable = aInvoiceBll.ReturnInvoiceDetailDataForReportBLL(invColl).Copy();


        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

        rptInvoiceForCustomer aRptInvoiceForCustomer = new rptInvoiceForCustomer();

        DataSet Ds = new DataSet();

        mainDataTable.TableName = "mainDataTable";
        detailDataTable.TableName = "detailDataTable";
        companyInfoDataTable.TableName = "companyInfoDataTable";
        Ds.Tables.Add(mainDataTable);
        Ds.Tables.Add(detailDataTable);
        Ds.Tables.Add(companyInfoDataTable);
        aRptInvoiceForCustomer.SetDataSource(Ds);
        crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;

    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
   
}