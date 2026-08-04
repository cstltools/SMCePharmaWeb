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

public partial class SInventory_RPTVIEW_ProductTradePriceViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    UnitPriceBLL aUnitPriceBll = new UnitPriceBLL();
    
    protected void Page_Init(object sender, EventArgs e)
    {

        string rptType = Request.QueryString["reportType"];

        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

        var unitPriceDetailDataTable = new DataTable();

        if (rptType != "")
        {
            if (rptType == "PR")
            {
                unitPriceDetailDataTable = aUnitPriceBll.LoadProductUnitPrice().Copy();
            }

            if (unitPriceDetailDataTable.Rows.Count > 0)
            {

                var Ds = new DataSet();

                unitPriceDetailDataTable.TableName = "unitPriceDetailDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";

                Ds.Tables.Add(unitPriceDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);

                rptdoc.Load(ReportPath("rptProductTradePrice.rpt"));
                rptdoc.SetDataSource(Ds);

                crvSalesRpt.ReportSource = rptdoc;
                crvSalesRpt.DataBind();

                //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                //   "Product_Report");

            }
            else
            {
                MessageLabel.Text = "No Data Found!!";
            }
        }

        if (rptType == "PPR")
        {
            DataTable activeUnitPriceDetailDataTable = aUnitPriceBll.LoadProductPriceReportInfo().Copy();


            if (activeUnitPriceDetailDataTable.Rows.Count > 0)
            {            

                var Ds = new DataSet();

                activeUnitPriceDetailDataTable.TableName = "ActiveUnitPriceDetailDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";

                Ds.Tables.Add(activeUnitPriceDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);

                rptdoc.Load(ReportPath("rptProductPriceReport.rpt"));
                rptdoc.SetDataSource(Ds);

                crvSalesRpt.ReportSource = rptdoc;
                crvSalesRpt.DataBind();

                //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                //   "Product_Report");
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