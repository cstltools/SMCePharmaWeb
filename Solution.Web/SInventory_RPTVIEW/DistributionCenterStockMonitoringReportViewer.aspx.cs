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

public partial class SInventory_RPTVIEW_DistributionCenterStockMonitoringReportViewer : System.Web.UI.Page
{
    
    ReportDocument rptdoc = new ReportDocument();
    DistributionCenterStockMonitoringBll aStockMonitoringBll = new DistributionCenterStockMonitoringBll();

    protected void Page_Init(object sender, EventArgs e)
    {
        string reportType = Request.QueryString["rptType"];

        DataTable monitoringInfo = aStockMonitoringBll.LoadDcStockMonitoringInfo().Copy();

        if (monitoringInfo.Rows.Count > 0)
        {
            var ds = new DataSet();

            monitoringInfo.TableName = "DCStockMonitoringDataTable";
            ds.Tables.Add(monitoringInfo);

            if (reportType == "excel")
            {
                rptdoc.Load(ReportPath("crpDCStockMonitoringExcelReport.rpt"));
                rptdoc.SetDataSource(ds);

                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "DCStockMonitoring_Report");
            }

            if (reportType == "CRP")
            {
                rptdoc.Load(ReportPath("crpDCStockMonitoringReport.rpt"));
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