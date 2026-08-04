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

public partial class SInventory_RPTVIEW_CompanySalesReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    ProductDiscountBLL aProductDiscountBLL = new ProductDiscountBLL();
    ReportDocument rptdoc = new ReportDocument();
    protected void Page_Init(object sender, EventArgs e)
    {
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable comDetailDataTable = aProductDiscountBLL.LoadProductDiscount(fromDate, toDate).Copy();

        if (comDetailDataTable.Rows.Count > 0)
        {
            
            
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();


            comDetailDataTable.TableName = "spDiscDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            
            Ds.Tables.Add(comDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptSpecialDiscount aRptCompanySales = new rptSpecialDiscount();

            aRptCompanySales.SetDataSource(Ds);
            crvComSalesRpt.ReportSource = aRptCompanySales;
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
   
    protected void crvComSalesRpt_Unload(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComSalesRpt.Dispose();
        }
    }
    protected void crvComSalesRpt_Disposed(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComSalesRpt.Dispose();
        }
    }
}