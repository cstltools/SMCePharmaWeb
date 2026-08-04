using Library.DAO.DoctorModule_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_SubTerritorySetup : System.Web.UI.Page
{

    private Setup2DAL _setupDAL = new Setup2DAL();

    private HiddenField hfGroupId, hfZone, hfArea, hfTeritory, hfSubTeritory, hfMarket;
    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    protected void Page_Load(object sender, EventArgs e)
    {
        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;

        hfGroupId = (HiddenField)IVMarketStructure.FindControl("hfGroupId") as HiddenField;
        hfZone = (HiddenField)IVMarketStructure.FindControl("hfZone") as HiddenField;
        hfArea = (HiddenField)IVMarketStructure.FindControl("hfArea") as HiddenField;
        hfTeritory = (HiddenField)IVMarketStructure.FindControl("hfTeritory") as HiddenField;
        hfSubTeritory = (HiddenField)IVMarketStructure.FindControl("hfSubTeritory") as HiddenField;
        hfMarket = (HiddenField)IVMarketStructure.FindControl("hfMarket") as HiddenField;

        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                btnUpdate.Visible = true;
                divShowHide.Visible = true;
                id_mastetID.Value = Request.QueryString["id"];
                GetOneRecord(id_mastetID.Value);
                //F_GroupSelect.Enabled = false;
                //F_ZoneSelect.Enabled = false;
                //F_AreaSelect.Enabled = false;
                //F_TeritorySelect.Enabled = false;
                //F_SubTeritory.Enabled = false;
            }
            else
            {
                btnSave.Visible = true;
            }
        }
        }

    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _setupDAL.GetEditData_SubTerritoryOne(Convert.ToInt32(Id)))
            {
                mainName.Text = dt.Rows[0]["SubTerritoryName"].ToString();
                acDate.Text = dt.Rows[0]["AcOrInAcDate"].ToString();

                hfGroupId.Value = dt.Rows[0]["GroupId"].ToString();


                hfZone.Value = dt.Rows[0]["RegionId"].ToString();

                try
                {

                    if (Convert.ToBoolean( dt.Rows[0]["IsActive"].ToString()))
                    {
                        chkIsActive.Checked = true;
                    }
                    else
                    {
                        chkIsActive.Checked = false;
                    }
                }
                catch (Exception ex)
                {
                    chkIsActive.Checked = false;
                }


                hfArea.Value = dt.Rows[0]["AreaId"].ToString();


                hfTeritory.Value = dt.Rows[0]["TerritoryId"].ToString();

                
              

            }



        }
        catch (Exception ex) { }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {
            SubTerritoryDAO aMaster = new SubTerritoryDAO();

            aMaster.SubTerritoryId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);


            aMaster.SubTerritoryName = string.IsNullOrEmpty(mainName.Text) ? null : mainName.Text;
            aMaster.TerritoryId = F_TeritorySelect.SelectedIndex > 0 ? int.Parse(F_TeritorySelect.SelectedValue) : (int?)null;
            

            aMaster.AcOrInAcDate = string.IsNullOrEmpty(acDate.Text) ? (DateTime?)null : DateTime.Parse(acDate.Text);

            aMaster.IsActive = chkIsActive.Checked;


             
            ResultInfo Res = _setupDAL.SaveSubTerritory(aMaster, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString()));
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','SubTerritoryRecords.aspx');", true);

            }

            else if (Res.isDuplicateCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


            }

            else if (Res.isValiCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Data cannot be deactivated!" + "','Faild');", true);


            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }
        }

    }
    protected void restbtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubTerritorySetup.aspx");
    }
    public bool Validation()
    {


        F_TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        F_AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
 


        mainName.CssClass = "form-control form-control-sm";
        acDate.CssClass = "form-control form-control-sm datepicker";





        if (F_AreaSelect.SelectedValue == "")
        {
            F_AreaSelect.ToolTip = "please fill out this field";
            F_AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            F_AreaSelect.Focus();
            return false;
        }



        if (F_TeritorySelect.SelectedValue == "")
        {
            F_TeritorySelect.ToolTip = "please fill out this field";
            F_TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            F_TeritorySelect.Focus();
            return false;
        }

        if (mainName.Text == "")
        {
            mainName.ToolTip = "please fill out this field";
            mainName.CssClass = "form-control form-control-sm is-invalid";
            mainName.Focus();
            return false;
        }


 
        if (acDate.Text == "")
        {
            acDate.ToolTip = "please fill out this field";
            acDate.CssClass = "form-control form-control-sm is-invalid datepicker";
            acDate.Focus();
            return false;
        }

     

        return true;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}