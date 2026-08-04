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

public partial class SInventory_RPTVIEW_WhStockMonitoringReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    WhStockMonitoringReportBll aMonitoringReportBll = new WhStockMonitoringReportBll();


    protected void Page_Init(object sender, EventArgs e)
    {
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

       

        //if (mainDataTable.Rows.Count > 0)
        //{
            DataTable mainDataTable = new DataTable();

            mainDataTable = aMonitoringReportBll.LoadWhStokMonitoringReportInformation(Convert.ToDateTime(fromDate),
                Convert.ToDateTime(toDate)).Copy(); 
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "WhStockMonitoringDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("crpWhStockMonitoring.rpt"));
            rptdoc.SetDataSource(Ds);

            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                   "WhStockMonitoring_Report");

        //}
        //else
        //{
        //    MessageLabel.Text = "No Data Found!!";
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

    protected void crvCustMasterRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustMasterRpt.Dispose();
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustMasterRpt.Dispose();
    }
}