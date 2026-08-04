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


public partial class SInventory_RPTVIEW_CustomerSalesReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CustomerSalesReportBLL aCustomerSalesReportBll = new CustomerSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string custId = Request.QueryString["custId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable custDetailDataTable = aCustomerSalesReportBll.CustomerReportDetailDataBLL(custId, FromDate, ToDate).Copy();

        if (custDetailDataTable.Rows.Count > 0)
        {
            DataTable custMainDataTable =
                aCustomerSalesReportBll.CustomerReportMainDataBLL(custId, FromDate, ToDate).Copy();


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            custMainDataTable.TableName = "custMainDataTable";
            custDetailDataTable.TableName = "custDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(custMainDataTable);
            Ds.Tables.Add(custDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptCustomerSales aRptCustomerSales = new rptCustomerSales();

            aRptCustomerSales.SetDataSource(Ds);
            crvCustSalesRpt.ReportSource = aRptCustomerSales;
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
    //protected void crViewer_Unload(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvCustSalesRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvCustSalesRpt.Dispose();
    //    }
    //}
    protected void crvCustSalesRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustSalesRpt.Dispose();
    }
    protected void crvCustSalesRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustSalesRpt.Dispose();
    }
}