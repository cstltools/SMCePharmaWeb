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
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_RPTVIEW_SalesRejectionReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CompanySalesReportBLL aCompanySalesReportBll = new CompanySalesReportBLL();
    CmnCrystaltoView aDal = new CmnCrystaltoView();
    ReportDocument rptdoc = new ReportDocument();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        int NationalReport = Convert.ToInt32(Request.QueryString["NationalReport"]);
        string districtId = Request.QueryString["districtId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        string excel = Session["Excel"].ToString();
        string param = Session["param"].ToString();

        //if (NationalReport !=1)
        //{
        DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aDal.SalesRejecionReportDAl(param).Copy();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "salesRejectionDataTable";
            Ds.Tables.Add(mainDataTable);

            if (excel == "Y")
            {
                rptdoc.Load(ReportPath("rptSalesRejection.rpt"));
                rptdoc.SetDataSource(Ds);

                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "Sales_Rejection");
            }
            else
            {
                rptdoc.Load(ReportPath("crpSalesRejection.rpt"));
                rptdoc.SetDataSource(Ds);

                crvSalesRpt.ReportSource = rptdoc;
                crvSalesRpt.DataBind();
            }

           
            
        //}
        //else 
        //{
        //    DateTime FromDate = Convert.ToDateTime(fromDate);
        //    DateTime ToDate = Convert.ToDateTime(toDate);

         // DataTable mainDataTable = aCompanySalesReportBll.SalesRejecionReportDAl(FromDate, ToDate).Copy();

        //    DataSet Ds = new DataSet();

        //    mainDataTable.TableName = "salesRejectionDataTable";
        //    Ds.Tables.Add(mainDataTable);

        //    if (excel == "Y")
        //    {
        //        rptdoc.Load(ReportPath("rptSalesRejection.rpt"));
        //        rptdoc.SetDataSource(Ds);

        //        rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
        //            "Sales_Rejection");
        //    }
        //    else
        //    {
        //        rptdoc.Load(ReportPath("crpSalesRejection.rpt"));
        //        rptdoc.SetDataSource(Ds);

        //        crvSalesRpt.ReportSource = rptdoc;
        //        crvSalesRpt.DataBind();
        //    }

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
       
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
       
    //}
    protected void crvSalesRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
    protected void crvSalesRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
}