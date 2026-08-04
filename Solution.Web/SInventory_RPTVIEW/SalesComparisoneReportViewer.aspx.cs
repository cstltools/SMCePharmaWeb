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

public partial class SInventory_RPTVIEW_SalesComparisoneReportViewer : System.Web.UI.Page
{
   
    ReportDocument rptdoc = new ReportDocument();
    SalesComparisoneReportBll aBusinessReportBll = new SalesComparisoneReportBll();

    protected void Page_Init(object sender, EventArgs e)
    {
        string reportType = Request.QueryString["rptType"];

        DateTime fromDate = Convert.ToDateTime(Request.QueryString["fromDate"]);
       // DateTime toDate = Convert.ToDateTime(Request.QueryString["toDate"]);

        DataTable salesTrendInfo = aBusinessReportBll.LoadSalesComparisoneInfo(fromDate).Copy();

        if (salesTrendInfo.Rows.Count > 0)
        {
            var ds = new DataSet();

            salesTrendInfo.TableName = "SalesComparisionDataTable";
            ds.Tables.Add(salesTrendInfo);

            //if (reportType == "excel")
            //{
            //    rptdoc.Load(ReportPath("crpDayWiseBusinessExcelReport.rpt"));
            //    rptdoc.SetDataSource(ds);

            //    rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //        "SalesTren_Report");
            //}

            if (reportType == "CRP")
            {
                rptdoc.Load(ReportPath("rptSalesComparisionReport.rpt"));
                rptdoc.SetDataSource(ds);

                crvSalesRpt.ReportSource = rptdoc;
                crvSalesRpt.DataBind();
            }
        }
        else
        {
            MessageLabel.Text = "No Data Found !!!";
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