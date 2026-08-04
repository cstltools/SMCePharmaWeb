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

public partial class SInventory_RPTVIEW_WhOpeningStockReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    
    WhOpeningStockReportBll aOpeningStockReportBll = new WhOpeningStockReportBll();

    protected void Page_Init(object sender, EventArgs e)
    {
        string date = Request.QueryString["Date"];

        DataTable mainDataTable = new DataTable();
        mainDataTable = aOpeningStockReportBll.LoadAllWhOpeningStockReport(date).Copy();
        DataTable companyinfo = aOpeningStockReportBll.CompanyInfoBLL();

       
        if (mainDataTable.Rows.Count > 0)
        {          
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "whOpeningStockReportDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("WarehouseOpeningStockReport.rpt"));
            rptdoc.SetDataSource(Ds);

           rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,"CustomerMaster_Report");
            
        }
        else
        {
            MessageLabel.Text = "No Data Found!!";
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