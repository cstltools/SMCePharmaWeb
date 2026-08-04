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
    RequisitionBLL aRequisitionBll= new RequisitionBLL();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    ComUnitSalesReportBLL aComUnitSalesReportBll = new ComUnitSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        string reqId = Request.QueryString["ReqId"];
        DataTable dcDataTable = aRequisitionBll.DCStoreReport(reqId).Copy();

        if (dcDataTable.Rows.Count > 0)
        {
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();
            dcDataTable.TableName = "dcstockDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(dcDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptChalanReceive rptDCStockRcv = new rptChalanReceive();

            rptDCStockRcv.SetDataSource(Ds);
            crvComUnitSalesRpt.ReportSource = rptDCStockRcv;
            
            //DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            //DataSet Ds = new DataSet();
            //dcDataTable.TableName = "dcstockDetailDataTable";
            //companyInfoDataTable.TableName = "companyInfoDataTable";

            //Ds.Tables.Add(dcDataTable);
            //Ds.Tables.Add(companyInfoDataTable);

            ////rptDCStockRcv rptDCStockRcv = new rptDCStockRcv();

            ////rptDCStockRcv.SetDataSource(Ds);
            ////crvComUnitSalesRpt.ReportSource = rptDCStockRcv;
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