using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_SubDeportInvoiceReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    Sub_InvoiceBLL aInvoiceBll = new Sub_InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            string invPram = Session["paydetailId"].ToString();
            DataTable mainDataTable = aInvoiceBll.InvoiceMainDataForReportBLL2SubDepot(invPram).Copy();

            //  string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
            //string invColl = aInvoiceBll.InvoiceNoCollectionFormate(invNo);

            // DataTable mainDataTable = aInvoiceBll.InvoiceMainDataForReportBLL(invColl).Copy();
            DataTable detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLL2(invPram).Copy();
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            //rptInvoiceForCustomer aRptInvoiceForCustomer = new rptInvoiceForCustomer();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "mainDataTable";
            detailDataTable.TableName = "detailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";
            Ds.Tables.Add(mainDataTable);
            Ds.Tables.Add(detailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            //aRptInvoiceForCustomer.SetDataSource(Ds);
            //crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;


            //aRptInvoiceForCustomer.SetDataSource(Ds);
           // aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
               // "ProformaInvoice-" + invNo);



            rptdoc.Load(ReportPath("rptInvoiceForCustomer_Past.rpt"));
            rptdoc.SetDataSource(Ds);

            rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
                "ProformaInvoice-" + "sdf");


            //crvInvoiceReport.ReportSource = rptdoc;
            //crvInvoiceReport.DataBind();
        }
        catch (Exception ex)
        {

            throw ex;
        }
       
    }
    private void ShowReport(DataSet dsDataSet, string reportName)
    {
        if (dsDataSet.Tables[0].Rows.Count > 0)
        {
            rptdoc.Load(ReportPath(reportName));
            rptdoc.SetDataSource(dsDataSet);
            crvInvoiceReport.ReportSource = rptdoc;
            crvInvoiceReport.DataBind();

        }
        else
        {
            //lblMsg.Text = "No Data Found!!!!";
        }
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
    protected void crvInvoiceReport_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
       
    }
    protected void crvInvoiceReport_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
    }
}