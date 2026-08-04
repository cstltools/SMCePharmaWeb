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
using Library.DAL.SInventory_DAL;

public partial class SInventory_RPTVIEW_WHStockAdjustmentListReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
   
    private WHStockAdjDAL adl = new WHStockAdjDAL();

    protected void Page_Init(object sender, EventArgs e)
    {
        string idd = Request.QueryString["WHStockAdjId"];
        StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();

        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

        //if (mainDataTable.Rows.Count > 0)
        //{
            DataTable mainDataTable = new DataTable();
            companyInfoDataTable.TableName = "companyInfoDataTable";
            mainDataTable = adl.GetWhStockAdjustmentListReportInformation(idd).Copy(); 
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "WhStockAdjustmentListInfoDataTable";
            Ds.Tables.Add(mainDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            rptdoc.Load(ReportPath("crpWhStockAdjustmentListInfo.rpt"));
            rptdoc.SetDataSource(Ds);

            crvCustMasterRpt.ReportSource = rptdoc;
            crvCustMasterRpt.DataBind();
            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //       "WhStockAdjustmentListInfo_Report");

        //}
        //else
        //{
        //    MessageLabel.Text = "No Data Found!!";
        //}
    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }

    protected void crvCustMasterRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustMasterRpt.Dispose();
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustMasterRpt.Dispose();
    }
}