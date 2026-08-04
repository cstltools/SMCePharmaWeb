using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;
using CrystalDecisions.CrystalReports.Engine;

public partial class SInventory_RPTVIEW_SubDeportStockReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    DCStockReportBLL aDcStockReportBll = new DCStockReportBLL();
    ReportDocument rptdoc = new ReportDocument();
    protected void Page_Init(object sender, EventArgs e)
    {
        int i = Convert.ToInt32(Session["DC"]);
        int rpt = Convert.ToInt32(Session["ReportView"]);


       string SCID= Session["SalescenterID"].ToString();
       string DcID = Session["SubdeportID"].ToString();



     //   if (i == 1 && rpt == 0)
        {
            string ComUnitId = Request.QueryString["comUnitId"];
            DataTable comUnitDetailDataTable = new DataTable();
            comUnitDetailDataTable = aDcStockReportBll.SubDeportStockReportDetailDataDAL((DcID)).Copy();
            //if (ComUnitId != "")
            //{
            //    comUnitDetailDataTable = aDcStockReportBll.DCReportDetailDataDAL((ComUnitId)).Copy();
            //}
            //if (ComUnitId == "")
            //{
            //    comUnitDetailDataTable = aDcStockReportBll.DCReportDetailDataDAL("").Copy();
            //}
            if (comUnitDetailDataTable.Rows.Count > 0)
            {
                DataTable comUnitMainDataTable =
                    aDcStockReportBll.DCReportMainDataDAL(ComUnitId).Copy();

                DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

                DataSet Ds = new DataSet();

                comUnitMainDataTable.TableName = "comUnitMainDataTable";
                comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";

                Ds.Tables.Add(comUnitMainDataTable);
                Ds.Tables.Add(comUnitDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);

                //rptDCStock aRptDcStock = new rptDCStock();

                //aRptDcStock.SetDataSource(Ds);
               // crvDCStockRpt.ReportSource = aRptDcStock;

                rptdoc.Load(ReportPath("rptDCStock.rpt"));
                rptdoc.SetDataSource(Ds);


                //crvDCStockRpt.ReportSource = rptdoc;
                //crvDCStockRpt.DataBind();
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                "SubDeport_Stock_Report");
            }
            else
            {
                MessageLabel.Text = "No Data Found!!";
            }
        }

        //if (i == 0 && rpt == 0)
        //{
        //    DataTable comUnitDetailDataTable = new DataTable();
        //    {
        //        comUnitDetailDataTable = aDcStockReportBll.WHReportDetailDataDAL().Copy();
        //    }
        //    if (comUnitDetailDataTable.Rows.Count > 0)
        //    {

        //        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

        //        DataSet Ds = new DataSet();

        //        comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
        //        companyInfoDataTable.TableName = "companyInfoDataTable";

        //        Ds.Tables.Add(comUnitDetailDataTable);
        //        Ds.Tables.Add(companyInfoDataTable);
        //        //rptDCStock aRptDcStock = new rptDCStock();

        //        //aRptDcStock.SetDataSource(Ds);
        //        //crvDCStockRpt.ReportSource = aRptDcStock;


        //        rptdoc.Load(ReportPath("rptWHDCStock.rpt"));
        //        rptdoc.SetDataSource(Ds);


        //        //crvDCStockRpt.ReportSource = rptdoc;
        //        //crvDCStockRpt.DataBind();
        //        rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
        //       "WHStock_Report");

        //    }
        //    else
        //    {
        //        MessageLabel.Text = "No Data Found!!";
        //    }
        //}

        //// View Report

        //if (i == 1 && rpt == 1)
        //{
        //    string ComUnitId = Request.QueryString["comUnitId"];
        //    DataTable comUnitDetailDataTable = new DataTable();
        //    if (ComUnitId != "")
        //    {
        //        comUnitDetailDataTable = aDcStockReportBll.DCReportDetailDataDAL((ComUnitId)).Copy();
        //    }
        //    if (ComUnitId == "")
        //    {
        //        comUnitDetailDataTable = aDcStockReportBll.DCReportDetailDataDAL("").Copy();
        //    }
        //    if (comUnitDetailDataTable.Rows.Count > 0)
        //    {
        //        DataTable comUnitMainDataTable =
        //            aDcStockReportBll.DCReportMainDataDAL(ComUnitId).Copy();

        //        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

        //        DataSet Ds = new DataSet();

        //        comUnitMainDataTable.TableName = "comUnitMainDataTable";
        //        comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
        //        companyInfoDataTable.TableName = "companyInfoDataTable";

        //        Ds.Tables.Add(comUnitMainDataTable);
        //        Ds.Tables.Add(comUnitDetailDataTable);
        //        Ds.Tables.Add(companyInfoDataTable);

        //        //rptDCStock aRptDcStock = new rptDCStock();

        //        //aRptDcStock.SetDataSource(Ds);
        //        // crvDCStockRpt.ReportSource = aRptDcStock;

        //        rptdoc.Load(ReportPath("rptDCStock.rpt"));
        //        rptdoc.SetDataSource(Ds);


        //        crvDCStockRpt.ReportSource = rptdoc;
        //        crvDCStockRpt.DataBind();

        //      //  rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
        //      //"Stock_Report");
        //    }
        //    else
        //    {
        //        MessageLabel.Text = "No Data Found!!";
        //    }
        //}


        //if (i == 0 && rpt == 1)
        //{
        //    DataTable comUnitDetailDataTable = new DataTable();
        //    {
        //        comUnitDetailDataTable = aDcStockReportBll.WHReportDetailDataDAL().Copy();
        //    }

        //    if (comUnitDetailDataTable.Rows.Count > 0)
        //    {

        //        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

        //        DataSet Ds = new DataSet();

        //        comUnitDetailDataTable.TableName = "comUnitDetailDataTable";
        //        companyInfoDataTable.TableName = "companyInfoDataTable";

        //        Ds.Tables.Add(comUnitDetailDataTable);
        //        Ds.Tables.Add(companyInfoDataTable);

        //        //rptDCStock aRptDcStock = new rptDCStock();

        //        //aRptDcStock.SetDataSource(Ds);
        //        //crvDCStockRpt.ReportSource = aRptDcStock;


        //        rptdoc.Load(ReportPath("rptWHDCStock.rpt"));
        //        rptdoc.SetDataSource(Ds);


        //        crvDCStockRpt.ReportSource = rptdoc;
        //        crvDCStockRpt.DataBind();
        //       // rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
        //       //"WHStock_Report");

        //    }
        //    else
        //    {
        //        MessageLabel.Text = "No Data Found!!";
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
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvDCStockRpt.Dispose();
    //    }
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
    //    if (this.rptdoc != null)
    //    {
    //        rptdoc.Close();
    //        rptdoc.Dispose();
    //        crvDCStockRpt.Dispose();
    //    }
    //}
    protected void crvDCStockRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvDCStockRpt.Dispose();

        }
    
    }
    protected void crvDCStockRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvDCStockRpt.Dispose();

        }
    }
}