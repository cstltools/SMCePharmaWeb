using Library.DAL.MasterSetup_DAL;
using Library.DAO.Transer_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TransferUI_Area_Transfer : System.Web.UI.Page
{
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    private DropDownList T_GroupSelect, T_ZoneSelect, T_AreaSelect, T_TeritorySelect, T_SubTeritory, T_MarketSelect, ddlDistributionCenter, rootDropDownList;
    private static DoctorDAL _DoctorDAL = new DoctorDAL();

    private static MarketStructureTransferDAL _CustomerInfoDAL = new MarketStructureTransferDAL();

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

        T_AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";


     
        Int32 count = 0;
        for (int i = 0; i < chkListMarket.Items.Count; i++)
        {
            if (chkListMarket.Items[i].Selected)
            {
                count++;
            }
        }
        


     

          
            if (count == 0)
            {
                showMessageBox("Please Select at least one Territory !!!");
                return false;
            }

        


        if (T_ZoneSelect.SelectedValue == "")
        {
            T_ZoneSelect.ToolTip = "please fill out this field";
            T_ZoneSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            T_ZoneSelect.Focus();
            return false;
        }
        return true;
    }

    
    protected void btnSave_Click(object sender, EventArgs e)
    {

        string Type = "";
        if (Validation())
        {
            string EmpIdAA = "";

             
                Type = "Area";


            string param = "";
            string grade = "";

            for (int i = 0; i < chkListMarket.Items.Count; i++)
            {
                if (chkListMarket.Items[i].Selected)
                {
                    grade = grade+ chkListMarket.Items[i].Value + "," ;
                }
            }
            if (grade != string.Empty)
            {
                param = param   +  grade.TrimEnd(',');
            }
            else
            {
                param = "";
            }

            //for (int i = 0; i < gv_Doctor_List.Rows.Count; i++)
            //{
            //    CheckBox check = (CheckBox)gv_Doctor_List.Rows[i].FindControl("chkDoctorSelect");

            //    if (check.Checked)
            //    {
            //        int EmpId = Convert.ToInt32(gv_Doctor_List.DataKeys[i][0]);

            //        EmpIdAA += EmpId + ",";




            //    }

            //}

            MarketStructureTranferDAO aMaster = new MarketStructureTranferDAO();


            aMaster.FGroupId = F_GroupSelect.SelectedIndex > 0 ? int.Parse(F_GroupSelect.SelectedValue) : (int?)null;
            aMaster.FRegionId = F_ZoneSelect.SelectedIndex > 0 ? int.Parse(F_ZoneSelect.SelectedValue) : (int?)null;
            aMaster.FAreaId = F_AreaSelect.SelectedIndex > 0 ? int.Parse(F_AreaSelect.SelectedValue) : (int?)null;
            aMaster.FTerritoryId = F_TeritorySelect.SelectedIndex > 0 ? int.Parse(F_TeritorySelect.SelectedValue) : (int?)null;
            aMaster.FSubTerritoryId = F_SubTeritory.SelectedIndex > 0 ? int.Parse(F_SubTeritory.SelectedValue) : (int?)null;


            aMaster.TGroupId = T_GroupSelect.SelectedIndex > 0 ? int.Parse(T_GroupSelect.SelectedValue) : (int?)null;
            aMaster.TRegionId =T_ZoneSelect.SelectedIndex > 0 ? int.Parse(T_ZoneSelect.SelectedValue) : (int?)null;
            aMaster.TAreaId = T_AreaSelect.SelectedIndex > 0 ? int.Parse(T_AreaSelect.SelectedValue) : (int?)null;
            aMaster.TTerritoryId =T_TeritorySelect.SelectedIndex > 0 ? int.Parse(T_TeritorySelect.SelectedValue) : (int?)null;
            aMaster.TSubTerritoryId = T_SubTeritory.SelectedIndex > 0 ? int.Parse(T_SubTeritory.SelectedValue) : (int?)null;


            ResultInfo Res = new ResultInfo();
           


            Res  = _CustomerInfoDAL.UpdateArea_Transfer(aMaster,Type, param,HttpContext.Current.Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','Area_Transfer.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }
        }


    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        chkListMarket.DataSource = null;
        chkListMarket.DataBind();
        if (F_ZoneSelect.SelectedValue != "")
        {

            try
            {
                DataTable dt = _dataLoad.GetArea_ByZoneId_Active(Convert.ToInt32(F_ZoneSelect.SelectedValue));
                  
              
        chkListMarket.DataValueField = "AreaId";
        chkListMarket.DataTextField = "AreaName";
        chkListMarket.DataSource = dt;
        chkListMarket.DataBind();
            }
            catch (Exception ex) { }

        }
        else
        {
            showMessageBox("Please Select Area!");
            F_AreaSelect.Focus();
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

            //CheckBox chkSelect = (CheckBox)gv_Customer_List.Rows[rowIndex].Cells[1].FindControl("chkSelect");
            //HiddenField hfCustomerMasterId = (HiddenField)gv_Customer_List.Rows[rowIndex].Cells[1].FindControl("hfCustomerMasterId");

            //if (chkSelect.Checked)
            //{
            //    DataTable dt = _dataLoad.GetValidationCheck(hfCustomerMasterId.Value, "CustomerTransfer");

            //    if (dt.Rows.Count == 0)
            //    {

            //    }
            //    else
            //    {
            //        chkSelect.Checked = false;
            //        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Order Pending!" + "','Faild');", true);

            //    }
            //}




        }
        catch (Exception ex)
        {

        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("Market_Transfer.aspx");
    }

    protected void chkMarket_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chkListMarket.Items.Count; i++)
        {
            if (chkMarket.Checked)
            {
                chkListMarket.Items[i].Selected = true;
            }
            else
            {
                chkListMarket.Items[i].Selected = false
                    ;
            }
        }

    }
}