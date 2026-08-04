using System;
using System.Data;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;

public partial class SInventory_RPTVIEW_AuditReportOneReportViewer : System.Web.UI.Page
{

    AuditReportOneBll aOrderReportBll = new AuditReportOneBll();
    ReportDocument rptdoc = new ReportDocument();

    protected void Page_Init(object sender, EventArgs e)
    {
        string rptType = (Request.QueryString["rptType"]);
        string excel = Session["Excel"].ToString();
        string parameter = Session["parameter"].ToString();

        DataSet Ds = new DataSet();

        if (rptType == "1")
        {
            
            DataTable mainDataTable = aOrderReportBll.LoadDeleteOrderReport(parameter).Copy();

            mainDataTable.TableName = "AuditReportOneDataTable";
            Ds.Tables.Add(mainDataTable);
        }

        else
        {
            DataTable mainDataTable = aOrderReportBll.LoadDeleteOrderNationalReport(parameter).Copy();

            mainDataTable.TableName = "AuditReportOneDataTable";
            Ds.Tables.Add(mainDataTable);
        }

       
        

        if (excel == "N")
        {
            rptdoc.Load(ReportPath("crpAuditReportOne.rpt"));
            rptdoc.SetDataSource(Ds);

            crvSalesRpt.ReportSource = rptdoc;
            crvSalesRpt.DataBind();
        }
        else
        {
            rptdoc.Load(ReportPath("crpDelOrder.rpt"));
            rptdoc.SetDataSource(Ds);
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true, "DeleteOrderReport");
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
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
}