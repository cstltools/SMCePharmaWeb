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

public partial class SInventory_RPTVIEW_WareHousePickingReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string reqId = Request.QueryString["reqId"];
        DataTable mainDataTable = aOrderReportBll.StockTransportOrderReportMainDataBLL(reqId).Copy();
        DataTable detailDataTable = aOrderReportBll.StockTransportOrderReportDetailDataBLL(reqId).Copy();
        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
        rptPickingForWarehouse aOrderReport = new rptPickingForWarehouse();
        DataSet Ds = new DataSet();

        mainDataTable.TableName = "mainDataTable";
        detailDataTable.TableName = "detailDataTable";
        companyInfoDataTable.TableName = "companyInfoDataTable";
        Ds.Tables.Add(mainDataTable);
        Ds.Tables.Add(detailDataTable);
        Ds.Tables.Add(companyInfoDataTable);
     //   aOrderReport.SetDataSource(Ds);
      //  crvPickingReportWareHouse.ReportSource = aOrderReport;



        rptdoc.Load(ReportPath("rptPickingForWarehouse.rpt"));
        rptdoc.SetDataSource(Ds);
        crvPickingReportWareHouse.ReportSource = rptdoc;
        crvPickingReportWareHouse.DataBind();
    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
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
    //        crvPickingReportWareHouse.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvPickingReportWareHouse.Dispose();
    //    }
    //}
    protected void crvPickingReportWareHouse_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvPickingReportWareHouse.Dispose();
    }
    protected void crvPickingReportWareHouse_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvPickingReportWareHouse.Dispose();
    }
}