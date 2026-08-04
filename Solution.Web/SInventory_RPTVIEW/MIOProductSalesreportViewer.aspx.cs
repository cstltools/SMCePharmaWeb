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

public partial class SInventory_RPTVIEW_AllSalesreportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CompanySalesReportBLL aCompanySalesReportBll = new CompanySalesReportBLL();
    ReportDocument rptdoc = new ReportDocument();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        int NationalReport = Convert.ToInt32(Request.QueryString["NationalReport"]);
        string districtId = Request.QueryString["districtId"];
        string areaId = Request.QueryString["areaId"];
        string product = Request.QueryString["product"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];
        string rpttype = Request.QueryString["rpttype"];
        string parameter = Session["RptParam"].ToString();
        
                //if (rpttype == "TW")
        //{
            DateTime FmDate = Convert.ToDateTime(fromDate);
            DateTime TDate = Convert.ToDateTime(toDate);

            DataTable mnDataTable = aCompanySalesReportBll.SalesReportDAlParameter(FmDate, TDate,parameter).Copy();

            DataSet Ds = new DataSet();

            mnDataTable.TableName = "AllsalesDataTable";
            Ds.Tables.Add(mnDataTable);
            rptdoc.Load(ReportPath("crpAllSalesReport.rpt"));
            rptdoc.SetDataSource(Ds);

            //crvSalesRpt.ReportSource = rptdoc;
            //crvSalesRpt.DataBind();
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "Sales_Report");
        //}
        //if (rpttype == "PW")
        //{
        //    DateTime FromDate = Convert.ToDateTime(fromDate);
        //    DateTime ToDate = Convert.ToDateTime(toDate);

        //    DataTable mainDataTable = aCompanySalesReportBll.SalesReportDAlParameter(FromDate, ToDate, parameter).Copy();

        //    DataSet Ds = new DataSet();

        //    mainDataTable.TableName = "AllsalesDataTable";
        //    Ds.Tables.Add(mainDataTable);
        //    rptdoc.Load(ReportPath("crpAllSalesReport.rpt"));
        //    rptdoc.SetDataSource(Ds);

        //    //crvSalesRpt.ReportSource = rptdoc;
        //    //crvSalesRpt.DataBind();
        //    rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
        //       "Sales_Report");
        //}
    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    
    protected void crvSalesRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
    protected void crvSalesRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
}