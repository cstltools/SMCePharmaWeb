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
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_RPTVIEW_LoadingReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();

    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    protected void Page_Init(object sender, EventArgs e)
    {



        string rpt = "";
        
              string fromDate = Request.QueryString["fromDate"];
        try
        {
            rpt=(Session["prmReport"].ToString());
        }
        catch
        {

        }

        if (rpt != "" )
        {
            
            DataTable mainDataTable = _DAL.GetLoadingReportDAL(rpt, fromDate).Copy();
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "LoadingReportdt";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("rptLoadingReport.rpt"));
            rptdoc.SetDataSource(Ds);

             

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