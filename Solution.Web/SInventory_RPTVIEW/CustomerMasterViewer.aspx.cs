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
    protected void Page_Init(object sender, EventArgs e)
    {
        string rptType = Request.QueryString["rptType"];
        DataTable customerMasterDetailDataTable =new DataTable();

        if (rptType != "")
        {
            if (rptType == "FBC")
            {
                bool fixedBusiness = true;
                customerMasterDetailDataTable = aCustomerMasterBll.FixedCustMasterReport(fixedBusiness).Copy();   
            }

            if (rptType == "RC")
            {
                bool regularCustomer = true;
                customerMasterDetailDataTable = aCustomerMasterBll.RegularCustMasterReport(regularCustomer).Copy();
            }

            if (rptType == "AC")
            {
                customerMasterDetailDataTable = aCustomerMasterBll.CustMasterReport().Copy();
            }
        }

        if (customerMasterDetailDataTable.Rows.Count > 0)
        {
           DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            customerMasterDetailDataTable.TableName = "custMasterDetailTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(customerMasterDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);
            
            //if (Session["AllCheck"].ToString() == "0")
            //{
                //rptCustMaster aRptCustomerMaster = new rptCustMaster();
                //aRptCustomerMaster.SetDataSource(Ds);
                //crvCustMasterRpt.ReportSource = aRptCustomerMaster;

            rptdoc.Load(ReportPath("crpCustomerMaster.rpt"));
            rptdoc.SetDataSource(Ds);

            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                   "CustomerMaster_Report");
            //}
            //else
            //{
            //    crpCustomerMaster aRptCustomerMaster = new crpCustomerMaster();
            //    aRptCustomerMaster.SetDataSource(Ds);
            //    crvCustMasterRpt.ReportSource = aRptCustomerMaster;
            //}
            
        }
        else
        {
            MessageLabel.Text = "No Data Found!!";
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
        crvCustMasterRpt.Dispose();
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCustMasterRpt.Dispose();
    }
}