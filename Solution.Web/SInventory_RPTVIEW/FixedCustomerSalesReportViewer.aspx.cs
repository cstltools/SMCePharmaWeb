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

public partial class SInventory_RPTVIEW_FixedCustomerSalesReportViewer : System.Web.UI.Page
{

    ReportDocument rptdoc = new ReportDocument();
    CustomerMasterInfoBll aMasterInfoBll = new CustomerMasterInfoBll();


    protected void Page_Init(object sender, EventArgs e)
    {
        string customerId = Request.QueryString["customerId"];

        DataTable mainDataTable = aMasterInfoBll.FixedCustomerSalesReportInfo(customerId).Copy();

        DataSet Ds = new DataSet();

        mainDataTable.TableName = "FixedCustomerSalesReport";
        Ds.Tables.Add(mainDataTable);

        rptdoc.Load(ReportPath("rptFixedSales.rpt"));
        rptdoc.SetDataSource(Ds);


        //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true, "SalesReport");
        //rptdoc.Load(ReportPath("crpFixedCustomerSalesReport.rpt"));
        //rptdoc.SetDataSource(Ds);

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