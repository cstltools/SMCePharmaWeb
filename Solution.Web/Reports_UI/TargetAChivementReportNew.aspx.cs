using Library.BLL.SInventory_BLL;
using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Reports_UI_TargetAChivementReportNew : System.Web.UI.Page
{
    public static SetupDAL _setupDAL = new SetupDAL();
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    private static Setup2DAL _setupDALss = new Setup2DAL();
    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;

    static SetupDAL _setupDAL2 = new SetupDAL();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {

            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
            string pram = "", Role = "";


            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
          

            if (RoleTypeName == "DZSM")
            {

                rbReportTypeName.Items[1].Selected = true;

                ListItem item = rbReportTypeName.Items.FindByValue("1");
                //ListItem item2 = rbReportTypeName.Items.FindByValue("2");
                //ListItem item3 = rbReportTypeName.Items.FindByValue("3");
                //item3.Selected = true;

                rbReportTypeName_SelectedIndexChanged(null, null);
                // If the item is found, make it invisible
                if (item != null)
                {
                    item.Enabled = false;
                }
                //if (item2 != null)
                //{
                //    item2.Enabled = false;
                //}
            }

            if (RoleTypeName == "AM")
            {
                ListItem item = rbReportTypeName.Items.FindByValue("1");
                ListItem item2 = rbReportTypeName.Items.FindByValue("2");
                ListItem item3 = rbReportTypeName.Items.FindByValue("3");
                item3.Selected = true;

                rbReportTypeName_SelectedIndexChanged(null, null);
                // If the item is found, make it invisible
                if (item != null)
                {
                    item.Enabled = false;
                }
                if (item2 != null)
                {
                    item2.Enabled = false;
                }
            }

        }
    }
  
    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();

        gv_Area.DataSource = null;
        gv_Area.DataBind();

        gv_Territory.DataSource = null;
        gv_Territory.DataBind();
        //   ReportTypeWise();

        //gv_DistributionCenter.DataSource = null;
        //gv_DistributionCenter.DataBind();

        //gv_Zone.DataSource = null;
        //gv_Zone.DataBind();

        //gv_Area.DataSource = null;
        //gv_Area.DataBind();

        //gv_Territory.DataSource = null;
        //gv_Territory.DataBind();


        divMrk.Visible = false;

        F_TeritorySelect.Items.Clear();
        F_TeritorySelect.Enabled = false;

        try
        {
            CommonDataLoad _dataLoad = new CommonDataLoad();


            using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(Convert.ToInt32(F_AreaSelect.SelectedValue)))
            {
                F_TeritorySelect.DataSource = dt;
                F_TeritorySelect.DataValueField = "TerritoryId";
                F_TeritorySelect.DataTextField = "TerritoryName";
                F_TeritorySelect.DataBind();
                F_TeritorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                F_TeritorySelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


       

        if (rbReportTypeName.Items[1].Selected == true)
        {
            divMrk.Visible = true;
        }
        if (rbReportTypeName.Items[2].Selected == true)
        {


            F_TeritorySelect.Enabled = true;

            divMrk.Visible = true;
        }

        //ReportTypeWise();
    }

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(fromDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
         

    }


    private string param()
    {


        var param = "  ";

        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,mas.TadaDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + toDateTextBox.Text + "' ";
        }
        if (fromDateTextBox.Text != "" && toDateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,mas.TadaDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        }


        if (ApprovalStatusSelect.SelectedValue != "")
        {

            param = param + " AND mas.ApprovalStatus='" + ApprovalStatusSelect.SelectedValue + "'";


        }


        return param;
    }
    private void LoadData()
    {
         
            gv_Zone.DataSource = null;
            gv_Zone.DataBind();
        
            gv_Area.DataSource = null;
            gv_Area.DataBind();
        
            gv_Territory.DataSource = null;
            gv_Territory.DataBind();
        

        string _FromDate = "";
        string _ToDate = "";
        string Area = ""; string Terr = "";
        string Type = "";

        string ZoneId = "";

        if (fromDateTextBox.Text != "" )
        {
            _FromDate = fromDateTextBox.Text;
        }

        if (toDateTextBox.Text != "")
        {
            _ToDate = toDateTextBox.Text;
        }
      
 
          if (rbReportTypeName.Items[0].Selected)
        {
            Type = "Zone";

            if (RoleTypeName == "DZSM")
            {
                ZoneId = F_ZoneSelect.SelectedValue;
                rbReportTypeName.Items[0].Selected = true;
            }
        }

        else if (rbReportTypeName.Items[1].Selected)
        {
            Type = "Area";
            Area = F_AreaSelect.SelectedValue;

            if (ToRoleTypeId == "3")
            {
                ZoneId = F_ZoneSelect.SelectedValue;

                
            }
            else
            {
                ZoneId = "";

                
            }

        }

        else if (rbReportTypeName.Items[2].Selected)
        {
            
                 Type = "Territory";
            Terr = F_TeritorySelect.SelectedValue;
            Area = F_AreaSelect.SelectedValue;
            ZoneId = F_ZoneSelect.SelectedValue;
            
        }


        DataTable aDataTable = _setupDALss.Get_TargetAChivementReportNew( _FromDate, _ToDate, Type, ZoneId, Area, Terr);


         if (Type == "Zone")
        {
            gv_Zone.DataSource = aDataTable;
            gv_Zone.DataBind();


            try
            {

                gv_Zone.FooterRow.Cells[1].Text = "Total:";


 

                decimal TargetValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TargetValue") == null ? 0 : row.Field<decimal>("TargetValue"));
                gv_Zone.FooterRow.Cells[2].Text = Math.Round(TargetValue).ToString("#,##0");

                decimal OrderValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("OrderValue") == null ? 0 : row.Field<decimal>("OrderValue"));
                gv_Zone.FooterRow.Cells[3].Text = Math.Round(OrderValue).ToString("#,##0");

                decimal InvoiceValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceValue") == null ? 0 : row.Field<decimal>("InvoiceValue"));
                gv_Zone.FooterRow.Cells[5].Text = Math.Round(InvoiceValue).ToString("#,##0");
                

                decimal SalesValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesValue") == null ? 0 : row.Field<decimal>("SalesValue"));
                gv_Zone.FooterRow.Cells[7].Text = Math.Round(SalesValue).ToString("#,##0");



                gv_Zone.FooterRow.BackColor = System.Drawing.Color.Bisque;
                gv_Zone.FooterRow.Font.Bold = true;
                gv_Zone.FooterRow.HorizontalAlign = HorizontalAlign.Right;
            }

            catch { }
        }
          
           if (Type == "Area")
        {
            gv_Area.DataSource = aDataTable;
            gv_Area.DataBind();


            try
            {

                gv_Area.FooterRow.Cells[2].Text = "Total:";




                decimal TargetValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TargetValue") == null ? 0 : row.Field<decimal>("TargetValue"));
                gv_Area.FooterRow.Cells[3].Text = Math.Round(TargetValue).ToString("#,##0");

                decimal OrderValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("OrderValue") == null ? 0 : row.Field<decimal>("OrderValue"));
                gv_Area.FooterRow.Cells[4].Text = Math.Round(OrderValue).ToString("#,##0");

                decimal InvoiceValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceValue") == null ? 0 : row.Field<decimal>("InvoiceValue"));
                gv_Area.FooterRow.Cells[6].Text = Math.Round(InvoiceValue).ToString("#,##0");


                decimal SalesValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesValue") == null ? 0 : row.Field<decimal>("SalesValue"));
                gv_Area.FooterRow.Cells[8].Text = Math.Round(SalesValue).ToString("#,##0");



                gv_Area.FooterRow.BackColor = System.Drawing.Color.Bisque;
                gv_Area.FooterRow.Font.Bold = true;
                gv_Area.FooterRow.HorizontalAlign = HorizontalAlign.Right;
            }

            catch { }
        }
          
              if (Type == "Territory")
        {
            gv_Territory.DataSource = aDataTable;
            gv_Territory.DataBind();


            try
            {

                gv_Territory.FooterRow.Cells[3].Text = "Total:";




                decimal TargetValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TargetValue") == null ? 0 : row.Field<decimal>("TargetValue"));
                gv_Territory.FooterRow.Cells[4].Text = Math.Round(TargetValue).ToString("#,##0");

                decimal OrderValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("OrderValue") == null ? 0 : row.Field<decimal>("OrderValue"));
                gv_Territory.FooterRow.Cells[5].Text = Math.Round(OrderValue).ToString("#,##0");

                decimal InvoiceValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("InvoiceValue") == null ? 0 : row.Field<decimal>("InvoiceValue"));
                gv_Territory.FooterRow.Cells[7].Text = Math.Round(InvoiceValue).ToString("#,##0");


                decimal SalesValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesValue") == null ? 0 : row.Field<decimal>("SalesValue"));
                gv_Territory.FooterRow.Cells[9].Text = Math.Round(SalesValue).ToString("#,##0");



                gv_Territory.FooterRow.BackColor = System.Drawing.Color.Bisque;
                gv_Territory.FooterRow.Font.Bold = true;
                gv_Territory.FooterRow.HorizontalAlign = HorizontalAlign.Right;
            }

            catch { }
        }
          

       

        

    }





    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {

         
          if (rbReportTypeName.Items[0].Selected )
        {
            

            if (gv_Zone.Rows.Count > 0)
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Target Achievement Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
                Response.Charset = "";
                Response.ContentType = "text/csv";
                Response.ContentEncoding = Encoding.Default;
                //To Export all pages.
                gv_Zone.AllowPaging = false;
                LoadData();
                gv_Zone.AllowPaging = false;
                StringBuilder sb = new StringBuilder();
                foreach (TableCell cell in gv_Zone.HeaderRow.Cells)
                {
                    //Append data with separator.
                    sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
                }
                //Append new line character.
                sb.Append("\r\n");

                foreach (GridViewRow row in gv_Zone.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        //Append data with separator.
                        if (cell.Text.Contains(","))
                        {
                            sb.Append(String.Format("\"{0}\",", cell.Text));
                        }
                        else
                        { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                    }
                    //Append new line character.
                    sb.Append("\r\n");
                }

                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

            }
        }

        if (rbReportTypeName.Items[1].Selected)
        {
           


            if (gv_Area.Rows.Count > 0)
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Target Achievement Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
                Response.Charset = "";
                Response.ContentType = "text/csv";
                Response.ContentEncoding = Encoding.Default;
                //To Export all pages.
                gv_Area.AllowPaging = false;
                LoadData();
                gv_Area.AllowPaging = false;
                StringBuilder sb = new StringBuilder();
                foreach (TableCell cell in gv_Area.HeaderRow.Cells)
                {
                    //Append data with separator.
                    sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
                }
                //Append new line character.
                sb.Append("\r\n");

                foreach (GridViewRow row in gv_Area.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        //Append data with separator.
                        if (cell.Text.Contains(","))
                        {
                            sb.Append(String.Format("\"{0}\",", cell.Text));
                        }
                        else
                        { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                    }
                    //Append new line character.
                    sb.Append("\r\n");
                }

                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

            }
        }

        if (rbReportTypeName.Items[1].Selected)
        {



            if (gv_Territory.Rows.Count > 0)
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Target Achievement Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
                Response.Charset = "";
                Response.ContentType = "text/csv";
                Response.ContentEncoding = Encoding.Default;
                //To Export all pages.
                gv_Territory.AllowPaging = false;
                LoadData();
                gv_Territory.AllowPaging = false;
                StringBuilder sb = new StringBuilder();
                foreach (TableCell cell in gv_Territory.HeaderRow.Cells)
                {
                    //Append data with separator.
                    sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
                }
                //Append new line character.
                sb.Append("\r\n");

                foreach (GridViewRow row in gv_Territory.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        //Append data with separator.
                        if (cell.Text.Contains(","))
                        {
                            sb.Append(String.Format("\"{0}\",", cell.Text));
                        }
                        else
                        { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                    }
                    //Append new line character.
                    sb.Append("\r\n");
                }

                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

            }
        }


    }

 

    public void GetYearList(DropDownList ddl)
    {


        int i;

        for (i = 2015; i <= 2050; i++)
        {
            ddl.Items.Add(i.ToString());
            ddl.Items.FindByValue(System.DateTime.Now.Year.ToString());
        }
        string strYear = System.DateTime.Now.Year.ToString();

        ddl.SelectedValue = strYear;


    }
    public void GetMonthList(DropDownList ddl)
    {
        DateTime month = Convert.ToDateTime(DateTime.Now);
        for (int i = 0; i < 12; i++)
        {
            DateTime NextMont = month.AddMonths(i);
            ListItem list = new ListItem();
            list.Text = NextMont.ToString("MMMM");
            list.Value = NextMont.Month.ToString();
            ddl.Items.Add(list);
        }
        //ddl.Items.Insert(0, "Select Month");
        ddl.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }


    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("TADAClaimView.aspx");
    }

 
}