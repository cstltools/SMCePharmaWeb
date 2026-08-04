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
using Library.DAL.SInventory_DAL;
using System.Text;

public partial class SInventory_RPTVIEW_InvoiceReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    InvoiceDAL aInvoiceDal = new InvoiceDAL();
    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            string invPram = "";
            try
            {
                  invPram = Session["paydetailId"].ToString();
            }
            catch (Exception ex)
            {

            }
            if (invPram != "")
            {
              

                DataTable mainDataTable = aInvoiceBll.InvoiceMainDataForReportBLL2(invPram).Copy();
                DataTable detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLL2(invPram).Copy();
                DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

                string CustomerMasterId = "0";
                StringBuilder customerIds = new StringBuilder();
                for (int i = 0; i < mainDataTable.Rows.Count; i++)
                {
                    CustomerMasterId = mainDataTable.Rows[i]["CustomerMasterId"].ToString();

                    // Append CustomerMasterId to the StringBuilder
                    customerIds.Append(CustomerMasterId);

                    // Add a comma after each CustomerMasterId except for the last one
                    if (i < mainDataTable.Rows.Count - 1)
                    {
                        customerIds.Append(", ");
                    }
                }

                // Get the final concatenated string
                string concatenatedCustomerIds = customerIds.ToString();

                DataTable dtReceiveable = aInvoiceDal.GetNewReceiveableforInvoiceDAl("  AND mas.[CustomerMasterId] in (" + concatenatedCustomerIds+")", null, null).Copy();

                //rptInvoiceForCustomer aRptInvoiceForCustomer = new rptInvoiceForCustomer();

                DataSet Ds = new DataSet();

                mainDataTable.TableName = "mainDataTable";
                detailDataTable.TableName = "detailDataTable";
                dtReceiveable.TableName = "dtReceiveable";
                companyInfoDataTable.TableName = "companyInfoDataTable";
                Ds.Tables.Add(mainDataTable);
                Ds.Tables.Add(detailDataTable);
                Ds.Tables.Add(dtReceiveable);
                Ds.Tables.Add(companyInfoDataTable);
                //aRptInvoiceForCustomer.SetDataSource(Ds);
                //crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;


                //aRptInvoiceForCustomer.SetDataSource(Ds);
                // aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
                // "ProformaInvoice-" + invNo);



                rptdoc.Load(ReportPath("rptInvoiceForCustomer.rpt"));
                rptdoc.SetDataSource(Ds);

                crvInvoiceReport.SeparatePages = false;
                crvInvoiceReport.ReportSource = rptdoc;
                crvInvoiceReport.DataBind();

                rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
                "ProformaInvoice-" );
            }

            string invNo = "";
            try
            {
                invNo = Server.UrlDecode(Request.QueryString["InvNo"]);
            }
            catch(Exception ex)
            {

            }
            if (invNo !=null)
            {
                DataTable mainDataTable = aInvoiceBll.InvoiceMainDatainvNo(invNo).Copy();
                DataTable detailDataTable = aInvoiceBll.InvoiceDetailDataInvoID(invNo).Copy();
                DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

                string CustomerMasterId = "0";
                StringBuilder customerIds = new StringBuilder();
                for (int i = 0; i < mainDataTable.Rows.Count; i++)
                {
                    CustomerMasterId = mainDataTable.Rows[i]["CustomerMasterId"].ToString();

                    // Append CustomerMasterId to the StringBuilder
                    customerIds.Append(CustomerMasterId);

                    // Add a comma after each CustomerMasterId except for the last one
                    if (i < mainDataTable.Rows.Count - 1)
                    {
                        customerIds.Append(", ");
                    }
                }

                // Get the final concatenated string
                string concatenatedCustomerIds = customerIds.ToString();

                DataTable dtReceiveable = aInvoiceDal.GetNewReceiveableforInvoiceDAl("  AND mas.[CustomerMasterId] in (" + concatenatedCustomerIds + ")", null, null).Copy();

                //rptInvoiceForCustomer aRptInvoiceForCustomer = new rptInvoiceForCustomer();

                DataSet Ds = new DataSet();

                mainDataTable.TableName = "mainDataTable";
                detailDataTable.TableName = "detailDataTable";
                dtReceiveable.TableName = "dtReceiveable";
                companyInfoDataTable.TableName = "companyInfoDataTable";
                Ds.Tables.Add(mainDataTable);
                Ds.Tables.Add(detailDataTable);
                Ds.Tables.Add(companyInfoDataTable);
                Ds.Tables.Add(dtReceiveable);
                //aRptInvoiceForCustomer.SetDataSource(Ds);
                //crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;


                //aRptInvoiceForCustomer.SetDataSource(Ds);
                // aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
                // "ProformaInvoice-" + invNo);



                rptdoc.Load(ReportPath("rptInvoiceForCustomer.rpt"));
                rptdoc.SetDataSource(Ds);

                crvInvoiceReport.SeparatePages = false;
                crvInvoiceReport.ReportSource = rptdoc;
                crvInvoiceReport.DataBind();

                rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
                    "ProformaInvoice-" );

            }
         
            //rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,"ProformaInvoice-");


            //crvInvoiceReport.ReportSource = rptdoc;
            //crvInvoiceReport.DataBind();
        }
        catch (Exception ex)
        {

             
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