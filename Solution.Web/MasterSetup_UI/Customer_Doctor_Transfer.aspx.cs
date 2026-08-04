using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_Customer_Doctor_Transfer : System.Web.UI.Page
{
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    private DropDownList T_GroupSelect, T_ZoneSelect, T_AreaSelect, T_TeritorySelect, T_SubTeritory, T_MarketSelect, ddlDistributionCenter, rootDropDownList;
    private static DoctorDAL _DoctorDAL = new DoctorDAL();

    private static CustomerInfoDAL _CustomerInfoDAL = new CustomerInfoDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;


        T_GroupSelect = (DropDownList)IVMarketStructureTo.FindControl("GroupSelect") as DropDownList;
        T_ZoneSelect = (DropDownList)IVMarketStructureTo.FindControl("ZoneSelect") as DropDownList;
        T_AreaSelect = (DropDownList)IVMarketStructureTo.FindControl("AreaSelect") as DropDownList;
        T_TeritorySelect = (DropDownList)IVMarketStructureTo.FindControl("TeritorySelect") as DropDownList;
        T_SubTeritory = (DropDownList)IVMarketStructureTo.FindControl("SubTeritory") as DropDownList;
        T_MarketSelect = (DropDownList)IVMarketStructureTo.FindControl("MarketSelect") as DropDownList;
        ddlDistributionCenter = (DropDownList)IVMarketStructureTo.FindControl("ddlDistributionCenter") as DropDownList;
        rootDropDownList = (DropDownList)IVMarketStructureTo.FindControl("rootDropDownList") as DropDownList;

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

    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        gv_Customer_List.DataSource = null;
        gv_Customer_List.DataBind();

        gv_Doctor_List.DataSource = null;
        gv_Doctor_List.DataBind();
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public bool Validation()
    {

        T_MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (rbType.Items[0].Selected)
        {

            if (gv_Customer_List.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_Customer_List.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_Customer_List.Rows[i].Cells[0].FindControl("chkSelect");

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
                showMessageBox("Please Select at least one employee !!!");
                return false;
            }

        }
        else
        {
            if (gv_Doctor_List.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_Doctor_List.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_Doctor_List.Rows[i].Cells[0].FindControl("chkDoctorSelect");

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
                showMessageBox("Please Select at least one employee !!!");
                return false;
            }

        }


        if (T_MarketSelect.SelectedValue == "")
        {
            T_MarketSelect.ToolTip = "please fill out this field";
            T_MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            T_MarketSelect.Focus();
            return false;
        }
        return true;
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_Customer_List.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < gv_Customer_List.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_Customer_List.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            CheckCustInOrder(i);

        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        string Type = "";
        if (Validation())
        {
            string EmpIdAA = "";

            if (rbType.Items[0].Selected)
            {
                Type = "Cust";
                for (int i = 0; i < gv_Customer_List.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_Customer_List.Rows[i].FindControl("chkSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_Customer_List.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }
            else
            {
                Type = "Doc";

                for (int i = 0; i < gv_Doctor_List.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_Doctor_List.Rows[i].FindControl("chkDoctorSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_Doctor_List.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }
            ResultInfo Res = new ResultInfo();
            EmpIdAA = EmpIdAA.Trim(',');


            Res  = _CustomerInfoDAL.UpdateCustomer_Doctor_Transfer(Type, EmpIdAA, T_MarketSelect.SelectedValue,HttpContext.Current.Session["UserId"].ToString(), ddlDistributionCenter.SelectedValue, rootDropDownList.SelectedValue);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','Customer_Doctor_Transfer.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }
        }


    }
    protected void ListImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../TransferUI/CustomerDocTransferApproval.aspx");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        gv_Customer_List.DataSource = null;
        gv_Customer_List.DataBind();

        gv_Doctor_List.DataSource = null;
        gv_Doctor_List.DataBind();
        if (F_MarketSelect.SelectedValue != "")
        {

            try
            {
                if (rbType.Items[0].Selected)
                {


                    DataTable aDataTable = _CustomerInfoDAL.GetCustomerList(" and mas.IsActive=1 and mas.MarketId=" + F_MarketSelect.SelectedValue);
                    gv_Customer_List.DataSource = aDataTable;
                    gv_Customer_List.DataBind();
                }
                else
                {
                    DataTable aDataTable = _DoctorDAL.GetDoctorList(" and DM.ApprovalStatus='2' and  DM.MarketId=" + F_MarketSelect.SelectedValue);
                    gv_Doctor_List.DataSource = aDataTable;
                    gv_Doctor_List.DataBind();
                }


            }
            catch (Exception ex) { }

        }
        else
        {
            showMessageBox("Please Select Market!");
            F_MarketSelect.Focus();
        }
    }

    protected void chkDoctorSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_Doctor_List.HeaderRow.FindControl("chkDoctorSelectAll");

        for (int i = 0; i < gv_Doctor_List.Rows.Count; i++)
        {

            
             var chkBoxRows = (CheckBox)gv_Doctor_List.Rows[i].Cells[0].FindControl("chkDoctorSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;

        }
    }

    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {

        int rowIndex = ((GridViewRow)(((CheckBox)sender).Parent.Parent)).RowIndex;
        try
        {
            CheckCustInOrder(rowIndex);

        }
        catch (Exception ex)
        {

        }
    }

    private void CheckCustInOrder(int rowIndex)
    {

        try
        {

            CheckBox chkSelect = (CheckBox)gv_Customer_List.Rows[rowIndex].Cells[1].FindControl("chkSelect");
            HiddenField hfCustomerMasterId = (HiddenField)gv_Customer_List.Rows[rowIndex].Cells[1].FindControl("hfCustomerMasterId");

            if (chkSelect.Checked)
            {
                DataTable dt = _dataLoad.GetValidationCheck(hfCustomerMasterId.Value, "CustomerTransfer");

                if (dt.Rows.Count == 0)
                {

                }
                else
                {
                    chkSelect.Checked = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Order Pending!" + "','Faild');", true);

                }
            }




        }
        catch (Exception ex)
        {

        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("Customer_Doctor_Transfer.aspx");
    }
}