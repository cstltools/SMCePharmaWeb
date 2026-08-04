using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_TopSheetReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();

    protected void Page_Init(object sender, EventArgs e)
    {

        int rpt = Convert.ToInt32(Session["ProformaTopSheet"]); 

        string Code = Server.UrlDecode(Request.QueryString["Code"]);
        string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
        string invColl = aInvoiceBll.InvoiceNoCollectionFormate(invNo);
 

        string Dcid=  (Session["dcDropDownList1"].ToString());
        string Route =   (Session["Route"].ToString()) ;
        //int marketid =  Convert.ToInt32(Session["MarketDropDownList1"]) ;
        //string Ter = (Session["Terr"]).ToString();
        string invDate =   (Session["InvoiceDateTextBox"].ToString()) ;

        DataTable detailDataTable;
        DataTable mainDataTable = aInvoiceBll.InvoiceMainDataForReportBLL(invColl, Code).Copy();
        //if (Ter == "--------Select---------")
        //{
        //      detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLL( Dcid,  ManufId,  marketid,  invDate).Copy();
        //}
        //else
        //{
        //    detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLLNew(Dcid, ManufId, marketid, Ter, invDate).Copy();
        //}
        detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLLNew_(invNo, Route, invDate, Code).Copy();

        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

    DataTable    dtlTable = aInvoiceBll.MarketPickinReportNew_(invNo, Route, invDate).Copy();



        DataSet Ds = new DataSet();

        mainDataTable.TableName = "mainDataTable";
        detailDataTable.TableName = "detailDataTable";
        companyInfoDataTable.TableName = "companyInfoDataTable";
        Ds.Tables.Add(mainDataTable);
        Ds.Tables.Add(detailDataTable);
        Ds.Tables.Add(companyInfoDataTable);


        dtlTable.TableName = "marketwisepickingDataTable";
        // detailDataTable.TableName = "detailDataTable";
      
        Ds.Tables.Add(dtlTable);


        if (rpt == 0)
        {
            //aRptInvoiceForCustomer.SetDataSource(Ds);
            //crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;

            //aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
            //       "TopSheet-" + invNo);

            rptdoc.Load(ReportPath("rptTopSheet.rpt"));
            rptdoc.SetDataSource(Ds);

            crvInvoiceReport.ReportSource = rptdoc;
            crvInvoiceReport.DataBind();
        }

        //aRptInvoiceForCustomer.SetDataSource(Ds);
        //crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;

        //aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
        //       "TopSheet-" + invNo);

        if (rpt == 1)
        {
            rptdoc.Load(ReportPath("rptTopSheet.rpt"));
            rptdoc.SetDataSource(Ds);


            //aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
            //       "TopSheet-" + invNo);
            crvInvoiceReport.ReportSource = rptdoc;
            crvInvoiceReport.DataBind();
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