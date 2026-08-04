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

public partial class SInventory_RPTVIEW_CustomerMasterViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string comUnitId = Request.QueryString["ComUnitId"];
        DataTable customerMasterDetailDataTable = aCustomerMasterBll.CustMasterReport(comUnitId).Copy();

        if (customerMasterDetailDataTable.Rows.Count > 0)
        {
           DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            customerMasterDetailDataTable.TableName = "custMasterDetailTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(customerMasterDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptCustMaster aRptCustomerMaster =new rptCustMaster();
            aRptCustomerMaster.SetDataSource(Ds);
            crvCustMasterRpt.ReportSource = aRptCustomerMaster;
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
            crvCustMasterRpt.Dispose();
       

    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {

       
            rptdoc.Close();
            rptdoc.Dispose();
            crvCustMasterRpt.Dispose();
       
        
    }
}