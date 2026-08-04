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

public partial class SInventory_RPTVIEW_ProductWiseNationalSalesReportViewer : System.Web.UI.Page
{
    ProductWiseNationalSalesReportBll aNationalSalesReportBll = new ProductWiseNationalSalesReportBll();

    ReportDocument rptdoc = new ReportDocument();
    int status = 0;

    protected void Page_Init(object sender, EventArgs e)
    {
        string reportType = Request.QueryString["rptType"];
        DateTime fromDate = Convert.ToDateTime(Request.QueryString["fromDate"]);

        string rpt = Session["rpt"].ToString();

        if (reportType == "PWNSR")
        {
            DataTable salesReportInfo = aNationalSalesReportBll.LoadProductWiseNationalSalesInfo(fromDate).Copy();

            if (salesReportInfo.Rows.Count > 0)
            {
                var ds = new DataSet();

                salesReportInfo.TableName = "ProductWiseNationalSalesReportDataTable";
                ds.Tables.Add(salesReportInfo);

                if (rpt == "excel")
                {
                    rptdoc.Load(ReportPath("crpSalesTrendExcelReport.rpt"));
                    rptdoc.SetDataSource(ds);

                    rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                        "SalesTren_Report");
                }

                if (rpt == "CRP")
                {
                    rptdoc.Load(ReportPath("crpProductWiseNationalSalesReport.rpt"));
                    rptdoc.SetDataSource(ds);

                    crvSalesRpt.ReportSource = rptdoc;
                    crvSalesRpt.DataBind();
                }
            }
            else
            {
                status = 1;
            }
        }

        if (reportType == "PWNSRZ")
        {
            DataTable zoneSalesReportInfo = aNationalSalesReportBll.LoadProductWiseNationalSalesInfoZoneWise(fromDate).Copy();

            if (zoneSalesReportInfo.Rows.Count > 0)
            {
                var ds = new DataSet();

                zoneSalesReportInfo.TableName = "ProductWiseNationalSalesReportZoneWiseDataTable";
                ds.Tables.Add(zoneSalesReportInfo);

                if (rpt == "excel")
                {
                    rptdoc.Load(ReportPath("crpSalesTrendExcelReport.rpt"));
                    rptdoc.SetDataSource(ds);

                    rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                        "SalesTren_Report");
                }

                if (rpt == "CRP")
                {
                    rptdoc.Load(ReportPath("crpProductWiseNationalSalesReportZoneWise.rpt"));
                    rptdoc.SetDataSource(ds);

                    crvSalesRpt.ReportSource = rptdoc;
                    crvSalesRpt.DataBind();
                }
            }
            else
            {
                status = 1;
            }
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