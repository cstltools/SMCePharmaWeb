using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls; 

public partial class MasterSetup_UI_TerritoryWiseDepotSetup : System.Web.UI.Page
{

    private DropDownList GroupSelect, ZoneSelect, AreaSelect;
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    private static TerritoryWiseDepotSetupDAL _DAL = new TerritoryWiseDepotSetupDAL();
    private static DepotWiseAreaSetupDal _aRepo = new DepotWiseAreaSetupDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        if (!IsPostBack)
        {
            try
            {
                using (DataTable dt33 = _aRepo.GetDepotList(1))
                {
                    ddlDepotName.DataSource = dt33;
                    ddlDepotName.DataValueField = "ComUnitId";
                    ddlDepotName.DataTextField = "UnitName";
                    ddlDepotName.DataBind();
                    ddlDepotName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlDepotName.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
      
            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
              //  GetOneRecord(id_mastetID.Value);
            }
            else
            {
                btnSave.Visible = true;
            }
        }
        }

    protected void ddlDepotName_SelectedIndexChanged(object sender, EventArgs e)
    {
       

        ddlRouteName.Items.Clear();
        if (ddlDepotName.SelectedValue != "")
        {
            try
            {
                using (DataTable dt33 = _DAL.GetRouteListByDepot(ddlDepotName.SelectedValue))
                {
                    ddlRouteName.DataSource = dt33;
                    ddlRouteName.DataValueField = "RouteInformationMasterId";
                    ddlRouteName.DataTextField = "RouteName";
                    ddlRouteName.DataBind();
                    ddlRouteName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlRouteName.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
            
            MethodGetSetupDetailById("");
        }


    }

    private void MethodGetSetupDetailById(string routeId)
    {
        for (int i = 0; i < chkTerritoryList.Items.Count; i++)
        {
            chkTerritoryList.Items[i].Selected = false;
        }

        if (string.IsNullOrEmpty(routeId)) return;

        Library.DAL.MasterSetup_DAL.RouteInformationDAL routeDAL = new Library.DAL.MasterSetup_DAL.RouteInformationDAL();
        using (DataTable dtDetail = routeDAL.GetRouteInformationDetailMarketById(routeId))
        {

            if (dtDetail != null && dtDetail.Rows.Count > 0)
            {
                id_mastetID.Value = routeId; // using routeId for update tracking if needed

                for (int i = 0; i < chkTerritoryList.Items.Count; i++)
                {
                    for (int j = 0; j < dtDetail.Rows.Count; j++)
                    {
                        if (chkTerritoryList.Items[i].Value == dtDetail.Rows[j]["TerritoryId"].ToString())
                        {
                            chkTerritoryList.Items[i].Selected = true;
                            break;
                        }
                    }
                }
            }
        }
    }

    protected void bnSearch_Click(object sender, EventArgs e)
    {
        ddlDepotName.SelectedValue = "";
        ddlRouteName.SelectedValue = "";
        ddlRouteName.Items.Clear();
        chkTerritoryList.Items.Clear();
        AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        if (AreaSelect.SelectedValue != "")
        {


            try
            {

                using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_ActiveDepo(Convert.ToInt32(AreaSelect.SelectedValue)))
                {

                    chkTerritoryList.DataValueField = "TerritoryId";
                    chkTerritoryList.DataTextField = "TerritoryName";
                    chkTerritoryList.DataSource = dt;
                    chkTerritoryList.DataBind();
                    try
                    {

                        if (dt.Rows.Count > 0)
                        {
                           
                        }
                }


                    catch (Exception ex)
                    {

                    }

                }

               
        }
            catch (Exception ex)
            {

            }
        }
        else
        {
            AreaSelect.ToolTip = "please fill out this field";
            AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            AreaSelect.Focus();
        }
    }

    public bool Validation()
    {


        ddlDepotName.CssClass = "form-control form-control-sm mySelect2";
        AreaSelect.CssClass = "form-control form-control-sm mySelect2";
        ddlRouteName.CssClass = "form-control form-control-sm mySelect2";

        //ddlCampaignType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        //ddlProLine.CssClass = "form-select form-select-sm mb-3 mySelect2";
        //ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2";

        //txtProductQty.CssClass = "form-control form-control-sm";
        //txtAmount.CssClass = "form-control form-control-sm";
        //txtMaxAmount.CssClass = "form-control form-control-sm";



        if (AreaSelect.SelectedValue == "")
        {
            AreaSelect.ToolTip = "please fill out this field";
            AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            AreaSelect.Focus();
            return false;
        }


        if (ddlDepotName.SelectedValue == "")
        {
            ddlDepotName.ToolTip = "please fill out this field";
            ddlDepotName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlDepotName.Focus();
            return false;
        }


        if (ddlRouteName.SelectedValue == "")
        {
            ddlRouteName.ToolTip = "please fill out this field";
            ddlRouteName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlRouteName.Focus();
            return false;
        }
        if (chkTerritoryList.SelectedValue == "")
        {

            showMessageBox("Please select at least one Territory!");
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
    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {
            List<int> selectedTerritoryIds = new List<int>();

            for (int i = 0; i < chkTerritoryList.Items.Count; i++)
            {
                if (chkTerritoryList.Items[i].Selected)
                {
                    if (!string.IsNullOrEmpty(chkTerritoryList.Items[i].Value))
                    {
                        selectedTerritoryIds.Add(int.Parse(chkTerritoryList.Items[i].Value));
                    }
                }
            }

            int routeId = ddlRouteName.SelectedIndex > 0 ? int.Parse(ddlRouteName.SelectedValue) : 0;
            if (routeId == 0) return;

            ResultInfo Res = _DAL.SaveRouteMarketDetailByTerritory(routeId, selectedTerritoryIds, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TerritoryWiseDepotSetup.aspx');", true);
            }
            else
            {
                string errMsg = Res.ErrorMessage != null ? Res.ErrorMessage.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ") : "Unknown Error";
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Error: " + errMsg + "','Faild');", true);
            }
        }
    }

            protected void chkTerritoryAll_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chkTerritoryList.Items.Count; i++)
        {
            if (chkTerritoryAll.Checked)
            {
                chkTerritoryList.Items[i].Selected = true;
            }
            else
            {
                chkTerritoryList.Items[i].Selected = false
                    ;
            }
        }
    }

    protected void btnRest_Click(object sender, EventArgs e)
    {
        Response.Redirect("TerritoryWiseDepotSetup.aspx");
    }

    protected void ddlRouteName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlRouteName.SelectedValue != "")
        {
            MethodGetSetupDetailById(ddlRouteName.SelectedValue);
        }
    }

    protected void chkTerritoryList_SelectedIndexChanged(object sender, EventArgs e)
    {
        string eventTarget = Request.Form.Get("__EVENTTARGET");
        int index = Convert.ToInt32(eventTarget.Substring(eventTarget.Length - 1));
        bool isUnchecked = !chkTerritoryList.Items[index].Selected;
        if (isUnchecked)
        {
            string value = chkTerritoryList.Items[index].Value;

          DataTable dt = _dataLoad.GetValidationCheck(value, "TerritoryWiseDepotSetupUncheck");

            if (dt.Rows.Count == 0)
            {

            }
            else
            {
                chkTerritoryList.Items[index].Selected = true;
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Order Pending!" + "','Faild');", true);

            }
        }
    }
}