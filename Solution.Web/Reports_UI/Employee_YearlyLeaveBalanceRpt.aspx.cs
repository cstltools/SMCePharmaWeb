using Library.DAL.MasterSetup_DAL;
using Library.DAL.PromoAllocDAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Reports_UI_Employee_YearlyLeaveBalanceRpt : System.Web.UI.Page
{


    public static GroupWisePromoQtyDAL aTargetDal = new GroupWisePromoQtyDAL();
    public static PromoMITagDAL aTargetDal2 = new PromoMITagDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private static CmnCrystaltoView _RptDAL = new CmnCrystaltoView();

    private static CustomerInfoDAL _DAL = new CustomerInfoDAL(); 
    protected void Page_Load(object sender, EventArgs e)
    {
       if (!IsPostBack)
        {
            LoadInitialInfo();

          //  btnSearch_Click(null, null);
        }
    }

    private void LoadInitialInfo()
    {

        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_All())
            {
                ddlMIO.DataSource = dt;
                ddlMIO.DataValueField = "EmpInfoId";
                ddlMIO.DataTextField = "EmpName";
                ddlMIO.DataBind();
                ddlMIO.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlMIO.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }

       
        try
        {
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
        }

        catch (Exception ex) { }


        //for (int i = 2013; i <= 2020; i++)
        //{
        //    ddlYear.Items.Add(i.ToString());
        //}
        //ddlYear.Items.FindByValue(System.DateTime.Now.Year.ToString()).Selected = true;  //set current year as selected

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
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerEntry.aspx");
    }

    private void LoadData(string parm, string par2, string _year
        )
    {
        if ( ddlYear.SelectedValue != ""  && ddlMIO.SelectedValue!="")
        {
            DataTable aDataTable = _RptDAL.GetEmployee_YearlyLeaveBalanceRptList(parm, par2, _year);


            if (aDataTable.Rows.Count==0)
            {
                aDataTable = _RptDAL.GetEmployee_YearlyLeaveBalanceRptList(parm, Parm_Summ_NoDate(), _year);

                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
            else
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();
            }
            


            lblEmpId.Text = aDataTable.Rows[0]["EmpMasterCode"].ToString();
            lblEmpName.Text = aDataTable.Rows[0]["EmpName"].ToString();
            lbluR.Text = aDataTable.Rows[0]["RoleName"].ToString();
            ElliCasual.Text = aDataTable.Rows[0]["ElliCasual"].ToString();
            TKCasual.Text = aDataTable.Rows[0]["TKCasual"].ToString();
            abCasual.Text = aDataTable.Rows[0]["abCasual"].ToString();
            CasualBlnc.Text = aDataTable.Rows[0]["CasualBlnc"].ToString();


           

            ElliSick.Text = aDataTable.Rows[0]["ElliSick"].ToString();
            TKSick.Text = aDataTable.Rows[0]["TKSick"].ToString();
            abSick.Text = aDataTable.Rows[0]["abSick"].ToString();
            SickBlnc.Text = aDataTable.Rows[0]["SickBlnc"].ToString();



            ElliAnnual.Text = aDataTable.Rows[0]["ElliAnnual"].ToString();
            TKAnnual.Text = aDataTable.Rows[0]["TKAnnual"].ToString();
            abAnnual.Text = aDataTable.Rows[0]["abAnnual"].ToString();

            AnnualBlnc.Text = aDataTable.Rows[0]["AnnualBlnc"].ToString();
            PreviousAL.Text = aDataTable.Rows[0]["PreviousAL"].ToString();



        }
        else
        {
            showMessageBox("Please Select Year && Employee !!");
            loadGridView.DataSource = null;
            loadGridView.DataBind();

        }

    }


    private void LoadSummaryData(string parm, string par2, string Year)
    {
        if (ddlYear.SelectedValue != "")
        {
            DataTable aDataTable = _RptDAL.GetEmployee_YearlySummaryList(parm, par2, Year);
            gv_Summary.DataSource = aDataTable;
            gv_Summary.DataBind();

        }
        else
        {
            showMessageBox("Please Select Year !!");
            gv_Summary.DataSource = null;
            gv_Summary.DataBind();

        }

    }

    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();

        gv_Summary.DataSource = null;
        gv_Summary.DataBind();


        repotDiv.Visible = false;
        rptSum.Visible = false;
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

            //Response.Redirect("GroupWisePromoQtyEntry.aspx?MID=" + unitPriceId);
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();

        gv_Summary.DataSource = null;
        gv_Summary.DataBind();


        repotDiv.Visible = false;
        rptSum.Visible = false;
        if (rbReportTypeName.SelectedValue != "")
        {
            if (rbReportTypeName.SelectedValue == "2")
            {
                repotDiv.Visible = true;
                try
                {
                    LoadData(Parm2(), Parm_Summ(), ddlYear.SelectedValue);
                }
                catch(Exception ex)
                {
                    repotDiv.Visible = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);
                }
            }

            if (rbReportTypeName.SelectedValue == "1")
            {
                try
                {
                    rptSum.Visible = true;

                LoadSummaryData(Parm2(), Parm3(), ddlYear.SelectedValue);
                }
                catch (Exception ex)
                {
                    rptSum.Visible = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);
                }
            }
        }
            
    }

    private string Parm()
    {
        string param = "";

        if (ddlYear.SelectedValue != "")
        {
            param = param + " AND  FiscalYear='" + ddlYear.SelectedValue + "' ";
        }

      

       

        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND  EmployeeInfoId='" + ddlMIO.SelectedValue + "' ";
        }


        return param;
    }


    private string Parm2()
    {
        string param = "";

        if (ddlYear.SelectedValue != "")
        {
            param = param + " AND  FiscalYear='" + ddlYear.SelectedValue + "' ";
        }




 


        return param;
    }

    private string Parm3()
    {
        string param = "";

        



        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND  PM.EmpInfoId='" + ddlMIO.SelectedValue + "' ";
        }


        return param;
    }


    private string Parm_Summ()
    {
        string param = "";





        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND  A.EmployeeId='" + ddlMIO.SelectedValue + "' ";
        }


        if (ddlYear.SelectedValue != "")
        {
            param = param + " AND  " + ddlYear.SelectedValue + " between year(A.LeaveFromDate) and year(A.LeaveToDate) ";
        }


        return param;
    }



    private string Parm_Summ_NoDate()
    {
        string param = "";





        if (ddlMIO.SelectedValue != "")
        {
            param = param + " AND  A.EmployeeId='" + ddlMIO.SelectedValue + "' ";
        }


        


        return param;
    }
    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("Employee_YearlyLeaveBalanceRpt.aspx");
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {

        if (rbReportTypeName.SelectedValue != "")
        {
            if (rbReportTypeName.SelectedValue == "2")
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Yearly Leave Detail Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls");
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                repotDiv.RenderControl(htmlWrite);
                 

                string SubTi = @"<span   style='text-align:center'>
   <h3>Yearly Leave Detail Report (Year:"+ddlYear.SelectedValue+")	</h3> </span>";

                HttpContext.Current.Response.Write(SubTi);
                Response.Write(stringWrite.ToString());
                Response.End();
            }

            if (rbReportTypeName.SelectedValue == "1")
            {
                // Clear the response
                Response.Clear();

                // Set the content disposition for downloading the file
                Response.AddHeader("content-disposition", "attachment;filename=Yearly_Leave_Summary_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls");
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";

                // Create StringWriter and HtmlTextWriter to render the table
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);

                // Render the table
                rptSum.RenderControl(htmlWrite);

                // Define the table border styles
                string tableStyle = "border-collapse: collapse; border: 1px solid black;";
                string cellStyle = "border: 1px solid black; padding: 5px;";

                // Write the table title
                string title = "<h3 style='text-align: center;'>Yearly Leave Summary Report (Year: " + ddlYear.SelectedValue + ")</h3>";
                HttpContext.Current.Response.Write(title);

                // Apply the table border styles
                htmlWrite.AddStyleAttribute("style", tableStyle);
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Table);

                // Render the table content
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Tr);
                // Render table header row
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Th);
                htmlWrite.Write("Header 1");
                htmlWrite.RenderEndTag(); // </th>
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Th);
                htmlWrite.Write("Header 2");
                htmlWrite.RenderEndTag(); // </th>
                htmlWrite.RenderEndTag(); // </tr>

                // Render table data rows
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Tr);
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Td);
                htmlWrite.Write("Data 1");
                htmlWrite.RenderEndTag(); // </td>
                htmlWrite.RenderBeginTag(HtmlTextWriterTag.Td);
                htmlWrite.Write("Data 2");
                htmlWrite.RenderEndTag(); // </td>
                htmlWrite.RenderEndTag(); // </tr>

                // End the table
                htmlWrite.RenderEndTag(); // </table>

                // Get the rendered HTML
                string renderedHtml = stringWrite.ToString();

                // Write the HTML to the response
                Response.Write(renderedHtml);

                // End the response
                Response.End();

            }
        }
    
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
}