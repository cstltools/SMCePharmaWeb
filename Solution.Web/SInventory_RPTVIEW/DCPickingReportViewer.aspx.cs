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

public partial class SInventory_RPTVIEW_DCPickingReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string pickNo = Request.QueryString["pickNo"];


        DataTable mainDataTable = aInvoiceBll.DCPickingReportMainDataBLL(pickNo).Copy();
       


            DataTable detailDataTable = aInvoiceBll.DCPickingReportDetailDataBLL(pickNo).Copy();
            if (detailDataTable.Rows.Count > 0)
            {
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();


            rptDcPickingSlip aDcPickingSlip = new rptDcPickingSlip();
            DataSet Ds = new DataSet();






            mainDataTable.TableName = "mainDataTable";
            detailDataTable.TableName = "detailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";
            Ds.Tables.Add(mainDataTable);
            Ds.Tables.Add(detailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            aDcPickingSlip.SetDataSource(Ds);
            crvDCPicking.ReportSource = aDcPickingSlip;


        }
            else
            {
                
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
    //        crvDCPicking.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvDCPicking.Dispose();
    //    }
    //}
    protected void crvDCPicking_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDCPicking.Dispose();
    }
    protected void crvDCPicking_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvDCPicking.Dispose();
    }
}