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
using Library.CrystalReports.SInventory_RPT;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_RPTVIEW_InvoiceReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    InvoiceDAL aInvoiceDal = new InvoiceDAL();
    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
            string invColl = aInvoiceBll.InvoiceNoCollectionFormate(invNo);

            DataTable mainDataTable = aInvoiceBll.InvoiceMainDataForReportBLL(invColl, "").Copy();
            DataTable detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLL(invColl).Copy();
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
            string CustomerMasterId = "0";
            if (mainDataTable.Rows.Count > 0)
            {
                 CustomerMasterId= mainDataTable.Rows[0]["CustomerMasterId"].ToString();
            }

            DataTable dtReceiveable = aInvoiceDal.GetNewReceiveableDAl("  AND mas.[CustomerMasterId]=" + CustomerMasterId, null, null).Copy();
            //rptInvoiceForCustomer aRptInvoiceForCustomer = new rptInvoiceForCustomer();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "mainDataTable";
            dtReceiveable.TableName = "dtReceiveable";
            detailDataTable.TableName = "detailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";
            Ds.Tables.Add(mainDataTable);
            Ds.Tables.Add(dtReceiveable);
            Ds.Tables.Add(detailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            //aRptInvoiceForCustomer.SetDataSource(Ds);
            //crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;


            //aRptInvoiceForCustomer.SetDataSource(Ds);
           // aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
               // "ProformaInvoice-" + invNo);



            rptdoc.Load(ReportPath("rptInvoiceForCustomer.rpt"));
            rptdoc.SetDataSource(Ds);

            rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
                "ProformaInvoice-" + invNo);


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