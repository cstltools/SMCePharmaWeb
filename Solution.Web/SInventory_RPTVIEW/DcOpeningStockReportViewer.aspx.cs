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

public partial class SInventory_RPTVIEW_DcOpeningStockReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    DcOpeningStockReportBll aOpeningStockReportBll = new DcOpeningStockReportBll();

    protected void Page_Init(object sender, EventArgs e)
    {
        string rptType = Request.QueryString["reportType"];
        string date = Request.QueryString["Date"];

        var openingStockNational = new DataTable();

        if (rptType != "")
        {
            if (rptType == "national")
            {
                openingStockNational = aOpeningStockReportBll.LoadAllDcOpeningStockReport(date).Copy();   
            }

            if (rptType == "other")
            {
                Int32 dcId = Convert.ToInt32(Session["dcId"]);
                openingStockNational = aOpeningStockReportBll.LoadDcOpeningStockReport(dcId,date).Copy();
            }

        }

        if (openingStockNational.Rows.Count > 0)
        {          
            var Ds = new DataSet();

            openingStockNational.TableName = "dcOpeningStockReportDataTable";

            Ds.Tables.Add(openingStockNational);

            rptdoc.Load(ReportPath("crpDcOpeningStockReport.rpt"));
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