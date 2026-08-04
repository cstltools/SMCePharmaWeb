using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_ProductCostPriceViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    UnitPriceBLL aUnitPriceBll = new UnitPriceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        DataTable unitPriceDetailDataTable = aUnitPriceBll.LoadProductUnitPrice().Copy();

        if (unitPriceDetailDataTable.Rows.Count > 0)
        {
           DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            unitPriceDetailDataTable.TableName = "unitPriceDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(unitPriceDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptProductCostPrice aProductCostPrice=new rptProductCostPrice();
            aProductCostPrice.SetDataSource(Ds);
            crvProductCostPriceRpt.ReportSource = aProductCostPrice;
        }
        else
        {
            MessageLabel.Text = "No Data Found!!";
        }
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
    protected void crViewer_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvProductCostPriceRpt.Dispose();
        }
    }
    protected void crViewer_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvProductCostPriceRpt.Dispose();
        }
    }
}