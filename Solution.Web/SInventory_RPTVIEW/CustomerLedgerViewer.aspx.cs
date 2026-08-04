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

public partial class SInventory_RPTVIEW_CustomerLedgerViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    CustomerLedgerBLL aCustomerMasterBll = new CustomerLedgerBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        string CustomerID =  (Request.QueryString["CustomerID"]);

        string toDate = Request.QueryString["toDate"];
        string fromDate = Request.QueryString["fromDate"];
        //DataTable comDetailDataTable = aCustomerMasterBll.CustomerLedgerBll(CustomerID).Copy();

       // if (comDetailDataTable.Rows.Count > 0)
        {
            DataTable mainDataTable = aCustomerMasterBll.CustomerLedgerBll(CustomerID, fromDate, toDate).Copy().Copy();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "DataTabledsCustomerLedger";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("crpCustomerLedger.rpt"));
            rptdoc.SetDataSource(Ds);
            crvCustMasterRpt.ReportSource = rptdoc;
            crvCustMasterRpt.DataBind();
            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //   "CustomerLedger_Report");
            //DataSet Ds = new DataSet();
            //comDetailDataTable.TableName = "DataTabledsCustomerLedger";
            //Ds.Tables.Add(comDetailDataTable);
            //crpCustomerLedger aRptCompanySales = new crpCustomerLedger();
            //aRptCompanySales.SetDataSource(Ds);
            //crvCustMasterRpt.ReportSource = aRptCompanySales;
        }
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