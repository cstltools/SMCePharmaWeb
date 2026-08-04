using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;

public partial class SInventory_RPTVIEW_SubdeportAreaWiseMonthlySalesReportViewer : System.Web.UI.Page
{
    AreaWiseMonthlyInventoryReportBll aReportBll = new AreaWiseMonthlyInventoryReportBll();
    ReportDocument rptdoc = new ReportDocument();

    protected void Page_Init(object sender, EventArgs e)
    {
        string branchId = Request.QueryString["branchId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];
        bool national = Convert.ToBoolean(Request.QueryString["national"]);
        DataTable mainDataTable=new DataTable();
       // if (national==false)
       // {
       //     mainDataTable = aReportBll.LoadAreaWiseMonthlyInventoryReport(fromDate, toDate, branchId).Copy();
       // }
       // else
        {
            mainDataTable = aReportBll.SubdeportGetAreaWiseMonthlyInventoryNationalReport(fromDate, toDate).Copy();
        } 

        var ds = new DataSet();

        mainDataTable.TableName = "AreaWiseMonthlyInventoryReportDataTable";
        ds.Tables.Add(mainDataTable);

        rptdoc.Load(ReportPath("SubdeportAreaWiseMonthlyInventoryReport.rpt"));
        rptdoc.SetDataSource(ds);

        crvSalesRpt.ReportSource = rptdoc;
        crvSalesRpt.DataBind();

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