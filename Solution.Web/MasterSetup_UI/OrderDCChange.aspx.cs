using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_OrderDCChange : System.Web.UI.Page
{

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();

    private static OrderTrackingDAL _DAL = new OrderTrackingDAL();
    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect, ddlNSM, ddlDZSM, ddlAM, ddlMIO;
    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        ddlNSM = (DropDownList)IVMarketStructure.FindControl("ddlNSM") as DropDownList;
        ddlDZSM = (DropDownList)IVMarketStructure.FindControl("ddlDZSM") as DropDownList;
        ddlAM = (DropDownList)IVMarketStructure.FindControl("ddlAM") as DropDownList;
        ddlMIO = (DropDownList)IVMarketStructure.FindControl("ddlMIO") as DropDownList;


        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
        }
        catch (Exception ex)
        {
        }

        if (!IsPostBack)
        {


            frmDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            try
            {
                using (DataTable dt = _seedRepo.GetChemistTypeListALL())
                {
                    ddlChemisType.DataSource = dt;
                    ddlChemisType.DataValueField = "CustomerTypeId";
                    ddlChemisType.DataTextField = "CustomerType";
                    ddlChemisType.DataBind();
                    ddlChemisType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlChemisType.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _seedRepo.GetProgramTypeListAll())
                {
                    ddlProgramType.DataSource = dt;
                    ddlProgramType.DataValueField = "ProgramTypeId";
                    ddlProgramType.DataTextField = "ProgramTypeName";
                    ddlProgramType.DataBind();
                    ddlProgramType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlProgramType.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _seedRepo.GetApprovalStatusList())
                {
                    ApprovalStatusSelect.DataSource = dt;
                    ApprovalStatusSelect.DataValueField = "SoftwareUseId";
                    ApprovalStatusSelect.DataTextField = "WebShow";
                    ApprovalStatusSelect.DataBind();
                    ApprovalStatusSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ApprovalStatusSelect.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            try
            {
                using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
                {
                    ddlDistributionCenter.DataSource = dt;
                    ddlDistributionCenter.DataValueField = "ComUnitId";
                    ddlDistributionCenter.DataTextField = "ComUnitName";
                    ddlDistributionCenter.DataBind();
                    ddlDistributionCenter.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlDistributionCenter.SelectedIndex = 0;

                    //if (Session["RoleTypeName"].ToString() == "DIC")
                    //{
                    //    ddlDistributionCenter.SelectedValue = Session["DICCompanyUnitId"].ToString();
                    //    ddlDistributionCenter.Enabled = false;
                    //}
                }


            }
            catch (Exception ex) { }


            LoadData(Parm());


          //  btnSearch_Click(null, null);
        }
    }
    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {


        string empName = custNameTextBox.Text.Trim();
        if (empName != "")
        {
            if (empName.Contains(':'))
            {
                string[] emp = empName.Split('|');

                hfCustomerId.Value = emp[1].Trim();
                custNameTextBox.Text = emp[0].Trim();



            }
            else
            {

                custNameTextBox.Text = "";
                hfCustomerId.Value = "";
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Input Correct Data !" + "','Faild');", true);
            }
        }

    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData(Parm());
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

    private void LoadData(string parm)
    {
        DataTable aDataTable = _DAL.GetOrderTrackingList(parm);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();



        if (loadGridView.Rows.Count > 0)
        {
            try
            {

                lblOrderCount.Text = aDataTable.Rows.Count.ToString();
                //loadGridView.FooterRow.Cells[4].Text = "Total: ";
             
                //loadGridView.FooterRow.Cells[4].Font.Bold = true;
                //loadGridView.FooterRow.Cells[5].Font.Bold = true;
                //loadGridView.FooterRow.Cells[6].Font.Bold = true;
                //loadGridView.FooterRow.Cells[7].Font.Bold = true;
                //loadGridView.FooterRow.Cells[8].Font.Bold = true;
                //loadGridView.FooterRow.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                // orderGridView.FooterRow.Cells[2].Text = total.ToString();

                decimal GrossValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));


                decimal TotalVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalVat") == null ? 0 : row.Field<decimal>("TotalVat"));


                decimal TotalDiscount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalDiscount") == null ? 0 : row.Field<decimal>("TotalDiscount"));


                decimal TotalNetPayable = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

                lblOrderAmount.Text = GrossValue.ToString();
             lblVAT.Text = TotalVat.ToString();
                lblDiscount.Text = TotalDiscount.ToString();
           lblAllTotal.Text = TotalNetPayable.ToString();
            }
            catch (Exception)
            {

                //  throw;
            }
        }
      
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {


        if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Order_Tracking_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;

            this.LoadData(Parm());

            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;


            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in loadGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }

            loadGridView.RenderControl(htw);
            string headerTable = @"<span  style='text-align:center'><h3>  Order Tracking List  </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";



            HttpContext.Current.Response.Write(headerTable);

            string style = @"<style> .text { mso-number-format:\@; } </style> ";
            Response.Write(style);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }

         
    }
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
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
            
            //Response.Redirect("/SInventory_UI/OrderStatus.aspx?MID=" + unitPriceId);

            System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "openModal", "window.open('../SInventory_UI/OrderStatus.aspx?MID=" + unitPriceId + "' ,'_blank');", true);
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            string OrdId = "";
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                CheckBox check = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");

                if (check.Checked)
                {
                    HiddenField hfOrderId = (HiddenField)loadGridView.Rows[i].Cells[0].FindControl("hfOrderId");

                    OrdId += hfOrderId.Value + ",";




                }

            }

            ResultInfo Res = new ResultInfo();
            OrdId = OrdId.Trim(',');


            Res = _DAL.UpdateOrderDC(ddlDistributionCenter.SelectedValue, ddlRouteName.SelectedValue, OrdId, HttpContext.Current.Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','OrderDCChange.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }

        }
    }


    public bool Validation()
    {

            ddlDistributionCenter.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlRouteName.CssClass = "form-select form-select-sm mb-3 mySelect2 ";


        if (loadGridView.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

                if (chkBoxRows.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    break;
                }
            }

            if (count == 0)
            {
                showMessageBox("Please Select at least one row !!!");
                return false;
            }

           if (ddlDistributionCenter.SelectedValue == "")
        {
            ddlDistributionCenter.ToolTip = "please fill out this field";
            ddlDistributionCenter.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlDistributionCenter.Focus();
            return false;
        }

        if (ddlRouteName.SelectedValue == "")
        {
            ddlRouteName.ToolTip = "please fill out this field";
            ddlRouteName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlRouteName.Focus();
            return false;
        }
        return true;
    }

    private string Parm()
    {
        string param = "";



         
            param = param + " AND mas.ComUnitId is  null  ";
        

        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("OrderDCChange.aspx");
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
        }
    }

    protected void ddlDistributionCenter_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (ddlDistributionCenter.SelectedValue != "")
        {
            try
            {
                using (DataTable dt = _seedRepo.GetDistributionRouteListByDCID(ddlDistributionCenter.SelectedValue))
                {
                    ddlRouteName.DataSource = dt;
                    ddlRouteName.DataValueField = "RouteInformationMasterId";
                    ddlRouteName.DataTextField = "RouteName";
                    ddlRouteName.DataBind();
                    ddlRouteName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlRouteName.SelectedIndex = 0;

                    //if (Session["RoleTypeName"].ToString() == "DIC")
                    //{
                    //    ddlDistributionCenter.SelectedValue = Session["DICCompanyUnitId"].ToString();
                    //    ddlDistributionCenter.Enabled = false;
                    //}
                }


            }
            catch (Exception ex) { }
        }
        else
        {
            ddlRouteName.Items.Clear();
        }
    }
}