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

public partial class SInventory_RPTVIEW_DCStockReceiveReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    ChalanBLL aRequisitionBll = new ChalanBLL();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    ComUnitSalesReportBLL aComUnitSalesReportBll = new ComUnitSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string reqId = Request.QueryString["ChalanId"];
        DataTable dcDataTable = aRequisitionBll.DCStoreReport(reqId).Copy();

        if (dcDataTable.Rows.Count > 0)
        {
            
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();
            dcDataTable.TableName = "dcstockDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(dcDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptChalanReceive rptChalanReceive = new rptChalanReceive();

            rptChalanReceive.SetDataSource(Ds);
            crvComUnitSalesRpt.ReportSource = rptChalanReceive;
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
 
    protected void crvComUnitSalesRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvComUnitSalesRpt.Dispose();
    }
    protected void crvComUnitSalesRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvComUnitSalesRpt.Dispose();
    }
}