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

public partial class SInventory_RPTVIEW_AllProductCountryStockReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CountryReportBLL aCountryReportBll = new CountryReportBLL();
    ReportDocument rptdoc = new ReportDocument();
    protected void Page_Init(object sender, EventArgs e)
    {

        string productCode = Request.QueryString["productCode"];
        
        DataTable countryDetailDataTable = aCountryReportBll.CountryReportDetailWithoutProductCodeDataBLL().Copy();

        if (countryDetailDataTable.Rows.Count > 0)
        {
            DataTable countryMainDataTable =
                aCountryReportBll.CountryReportMainDataBLL(productCode).Copy();


            DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

            DataSet Ds = new DataSet();

            countryMainDataTable.TableName = "countryMainDataTable";
            countryDetailDataTable.TableName = "countryDetailDataTable";
            companyInfoDataTable.TableName = "companyInfoDataTable";

            Ds.Tables.Add(countryMainDataTable);
            Ds.Tables.Add(countryDetailDataTable);
            Ds.Tables.Add(companyInfoDataTable);

            rptAllProductCountryStock aWithoutProductCodeCountrySales = new rptAllProductCountryStock();

            aWithoutProductCodeCountrySales.SetDataSource(Ds);
            crvCountryStockRpt.ReportSource = aWithoutProductCodeCountrySales;
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
    protected void crvCountryStockRpt_Unload(object sender, EventArgs e)
    {
       
            rptdoc.Close();
            rptdoc.Dispose();
            crvCountryStockRpt.Dispose();
     
    }
    protected void crvCountryStockRpt_Disposed(object sender, EventArgs e)
    {
        rptdoc.Close();
        rptdoc.Dispose();
        crvCountryStockRpt.Dispose();
    }
   
}