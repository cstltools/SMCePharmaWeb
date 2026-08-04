using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_RPTVIEW_TourPlanReportViwer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    private static EmployeeInformationDaL _EmployeeInformationDaL = new EmployeeInformationDaL();
    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            //string invNo = Server.UrlDecode(Request.QueryString["InvNo"]);


            //if (invNo != "")
            //{
            //    param = param + " AND INV.InvoiceId ='" + invNo.Trim() + "' ";
            //}

            string employeeId = Request.QueryString["EmployeeId"];
            string month = Request.QueryString["Month"];
            string year = Request.QueryString["Year"];

            // Check if query string parameters are present
            if (!string.IsNullOrEmpty(employeeId) && !string.IsNullOrEmpty(month) && !string.IsNullOrEmpty(year))
            {
                // Fetch data using the retrieved query string parameters
                DataTable dtTPDetail = _EmployeeInformationDaL.GetTourPlanReport__(employeeId, month, year);
                DataTable dtBal = _EmployeeInformationDaL.GetTourPlanReportBal(employeeId, month, year);

                DataSet Ds = new DataSet();

                // Clone and import rows for dtTPDetail
                DataTable dtTPDetailClone = dtTPDetail.Clone();
                foreach (DataRow row in dtTPDetail.Rows)
                {
                    dtTPDetailClone.ImportRow(row);
                }
                dtTPDetailClone.TableName = "dtTPDetail";
                Ds.Tables.Add(dtTPDetailClone);

                // Clone and import rows for dtBal
                DataTable dtBalClone = dtBal.Clone();
                foreach (DataRow row in dtBal.Rows)
                {
                    dtBalClone.ImportRow(row);
                }
                dtBalClone.TableName = "dtBal";
                Ds.Tables.Add(dtBalClone);


                rptdoc.Load(ReportPath("rptTourPlan.rpt"));
                rptdoc.SetDataSource(Ds);

                rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, "Tourplant-");
                crvInvoiceReport.ReportSource = rptdoc;
                crvInvoiceReport.DataBind();

            }
        }
        catch (Exception ex)
        {

            throw ex;
        }
       
    }
    private void ShowReport(DataSet dsDataSet, string reportName)
    {
        if (dsDataSet.Tables[0].Rows.Count > 0)
        {
            rptdoc.Load(ReportPath(reportName));
            rptdoc.SetDataSource(dsDataSet);
            crvInvoiceReport.ReportSource = rptdoc;
            crvInvoiceReport.DataBind();

        }
        else
        {
            //lblMsg.Text = "No Data Found!!!!";
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
    //        crvInvoiceReport.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvInvoiceReport.Dispose();
    //    }
    //}
    protected void crvInvoiceReport_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
       
    }
    protected void crvInvoiceReport_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
    }
}