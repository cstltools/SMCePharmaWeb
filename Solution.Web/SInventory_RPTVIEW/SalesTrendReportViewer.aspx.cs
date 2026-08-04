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
using Library.DAL.SInventory_DAL;

public partial class SInventory_RPTVIEW_SalesTrendReportViewer : System.Web.UI.Page
{
    SalesTrendReportBll aTrendReportBll = new SalesTrendReportBll();

    ReportDocument rptdoc = new ReportDocument();

    protected void Page_Init(object sender, EventArgs e)
    {
        string reportType = Request.QueryString["rptType"];

        DateTime fromDate = Convert.ToDateTime(Request.QueryString["fromDate"]);
        DateTime toDate = Convert.ToDateTime(Request.QueryString["toDate"]);

        try
        {
            DataTable salesTrendInfo = aTrendReportBll.LoadSalesTrendInfo(fromDate, toDate).Copy();

            if (salesTrendInfo.Rows.Count > 0)
            {
                var ds = new DataSet();

                salesTrendInfo.TableName = "SalesTrendDataTable";
                ds.Tables.Add(salesTrendInfo);

                if (reportType == "excel")
                {
                    rptdoc.Load(ReportPath("crpSalesTrendExcelReport.rpt"));
                    rptdoc.SetDataSource(ds);

                    rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                        "SalesTren_Report");
                }

                if (reportType == "CRP")
                {
                    rptdoc.Load(ReportPath("crpSalesTrendReport.rpt"));
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
        catch (Exception)
        {
            
           // throw;
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