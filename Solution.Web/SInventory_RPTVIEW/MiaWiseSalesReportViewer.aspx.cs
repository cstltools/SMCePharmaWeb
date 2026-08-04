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

public partial class SInventory_RPTVIEW_MiaWiseSalesReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    MiaSalesReportBLL aMiaSalesReportBll = new MiaSalesReportBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        
        string miaId = Request.QueryString["miaId"];
        string comunitId = Request.QueryString["comunitId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        DataTable miaMainDataTable = aMiaSalesReportBll.MiaWiseReportMainDataBLL(miaId, FromDate, ToDate,comunitId).Copy();
        DataTable miaDetailDataTable = aMiaSalesReportBll.MiaWiseReportDetailDataBLL(miaId, FromDate, ToDate).Copy();
        if (miaDetailDataTable.Rows.Count > 0)
        {


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            miaMainDataTable.TableName = "miaMainDataTable";
            miaDetailDataTable.TableName = "miaDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(miaMainDataTable);
            Ds.Tables.Add(miaDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptMiaWiseSales aRptMiaWiseSales = new rptMiaWiseSales();

            aRptMiaWiseSales.SetDataSource(Ds);
            crvmiaSalesRpt.ReportSource = aRptMiaWiseSales;

        }
        else
        {
            MessageLabel.Text = "No data found !!";
        }
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
 
    protected void crvmiaSalesRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvmiaSalesRpt.Dispose();
    }
    protected void crvmiaSalesRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvmiaSalesRpt.Dispose();
    }
}