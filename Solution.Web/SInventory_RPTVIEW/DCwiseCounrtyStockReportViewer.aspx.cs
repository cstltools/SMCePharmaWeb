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


public partial class SInventory_RPTVIEW_DCwiseCountryStockReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    DCStockReportBLL aDcStockReportBll = new DCStockReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {

        
        DataTable comUnitDetailDataTable = aDcStockReportBll.DCWiseCountryReportDetailDataDAL().Copy();

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            
            comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

           
            Ds.Tables.Add(comUnitDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            rptDCwiseCountryStock aDCwiseCountryStock=new rptDCwiseCountryStock();

            aDCwiseCountryStock.SetDataSource(Ds);
            crvDCwiseCountryStockRpt.ReportSource = aDCwiseCountryStock;
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
    //        crvDCwiseCountryStockRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvDCwiseCountryStockRpt.Dispose();
    //    }
    //}
    protected void crvDCwiseCountryStockRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDCwiseCountryStockRpt.Dispose();
    }
    protected void crvDCwiseCountryStockRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDCwiseCountryStockRpt.Dispose();
    }
}