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
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_CustomerMasterViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    private ExcelUpForMIGOBLL aExcelUpForMIGOBLL = new ExcelUpForMIGOBLL();
    private ExcelUpForCustTagChangeBLL aExcelUpForMIGOBLLTag = new ExcelUpForCustTagChangeBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string status = Request.QueryString["status"];
        string id = Request.QueryString["id"];
        if (status=="1")
        {
            StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
            DataTable customerMasterDetailDataTable = new DataTable();
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
            customerMasterDetailDataTable = aExcelUpForMIGOBLL.ReportVerifyedData(id).Copy();
            DataSet Ds = new DataSet();

            customerMasterDetailDataTable.TableName = "custMasterDetailTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(customerMasterDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            rptdoc.Load(ReportPath("crpCustomerMaster.rpt"));
            rptdoc.SetDataSource(Ds);
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "CustomerMaster_Report");
        }
        if (status=="2")
        {
            StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
            DataTable customerMasterDetailDataTable = new DataTable();
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
            customerMasterDetailDataTable = aExcelUpForMIGOBLL.ReportUnVerifyedData(id).Copy();
            DataSet Ds = new DataSet();

            customerMasterDetailDataTable.TableName = "custMasterDetailTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(customerMasterDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            rptdoc.Load(ReportPath("crpCustomerMaster.rpt"));
            rptdoc.SetDataSource(Ds);
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "CustomerMaster_Report");
        }
        if (status == "3")
        {
            StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
            DataTable customerMasterDetailDataTable = new DataTable();
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
            customerMasterDetailDataTable = aExcelUpForMIGOBLLTag.ReportVerifyedData(id).Copy();
            DataSet Ds = new DataSet();

            customerMasterDetailDataTable.TableName = "custMasterDetailTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(customerMasterDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            rptdoc.Load(ReportPath("crpCustomerMaster.rpt"));
            rptdoc.SetDataSource(Ds);
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "CustomerMaster_Report");
        }
        if (status == "4")
        {
            StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
            DataTable customerMasterDetailDataTable = new DataTable();
            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
            customerMasterDetailDataTable = aExcelUpForMIGOBLLTag.ReportUnVerifyedData(id).Copy();
            DataSet Ds = new DataSet();

            customerMasterDetailDataTable.TableName = "custMasterDetailTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(customerMasterDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            rptdoc.Load(ReportPath("crpCustomerMaster.rpt"));
            rptdoc.SetDataSource(Ds);
            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "CustomerMaster_Report");
        }
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
    //        crvCustMasterRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvCustMasterRpt.Dispose();
    //    }
    //}
    protected void crvCustMasterRpt_Unload(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        //crvCustMasterRpt.Dispose();
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        //crvCustMasterRpt.Dispose();
    }
}