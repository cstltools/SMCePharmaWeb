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

public partial class MasterSetup_UI_TerritoryWiseDepotSetupRoute : System.Web.UI.Page
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
       

        ddlsubDepotName.Items.Clear();
        if (ddlDepotName.SelectedValue != "")
        {
            try
            {
                using (DataTable dt33 = _aRepo.GetSubDepotList(ddlDepotName.SelectedValue))
                {
                    ddlsubDepotName.DataSource = dt33;
                    ddlsubDepotName.DataValueField = "SubDepotId";
                    ddlsubDepotName.DataTextField = "SubDepotName";
                    ddlsubDepotName.DataBind();
                    ddlsubDepotName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlsubDepotName.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }

            MethodGetSetupDetailById(ddlDepotName.SelectedValue,"0");
        }


    }

    private void MethodGetSetupDetailById(string DCId, string SubDepotId)
    {

        for (int i = 0; i < chkTerritoryList.Items.Count; i++)
        {
            chkTerritoryList.Items[i].Selected = false;
        }
        using (DataTable dtDetail = _DAL.GetSetupDetailById(DCId, SubDepotId))
        {

            if(dtDetail.Rows.Count>0)
            {
                id_mastetID.Value = dtDetail.Rows[0]["DcWiseTerritoryMasterId"].ToString();

                for (int i = 0; i < chkTerritoryList.Items.Count; i++)
                {

                    for (int j = 0; j < dtDetail.Rows.Count; j++)
                    {
                        if (chkTerritoryList.Items[i].Value == dtDetail.Rows[j]["TerritoryId"].ToString())
                        {
                            chkTerritoryList.Items[i].Selected = true;
                        }
                        

                    }
                    //    if (chkTerritoryAll.Checked)
                    //{
                    //    chkTerritoryList.Items[i].Selected = true;
                    //}

                }

            }
            else
            {
                for (int i = 0; i < chkTerritoryList.Items.Count; i++)
                {
                    chkTerritoryList.Items[i].Selected = false;
                }
                }
        }
    }

    protected void bnSearch_Click(object sender, EventArgs e)
    {
        ddlDepotName.SelectedValue = "";
        ddlsubDepotName.SelectedValue = "";
        ddlsubDepotName.Items.Clear();
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
        ddlsubDepotName.CssClass = "form-control form-control-sm mySelect2";

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


        //if (ddlsubDepotName.SelectedValue == "")
        //{
        //    ddlsubDepotName.ToolTip = "please fill out this field";
        //    ddlsubDepotName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlsubDepotName.Focus();
        //    return false;
        //}
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
            List<DcWiseTerritoryDetailDAO> DtlCustList = new List<DcWiseTerritoryDetailDAO>();

            for (int i = 0; i < chkTerritoryList.Items.Count; i++)
            {
                if (chkTerritoryList.Items[i].Selected)
                {



                    DcWiseTerritoryDetailDAO _DAO = new DcWiseTerritoryDetailDAO();

                    _DAO.TerritoryId = string.IsNullOrEmpty(chkTerritoryList.Items[i].Value) ? (int?)null : int.Parse(chkTerritoryList.Items[i].Value);





                    DtlCustList.Add(_DAO);
                }
            }

            DcWiseTerritoryMasterDAO aMaster = new DcWiseTerritoryMasterDAO();

            aMaster.DcWiseTerritoryMasterId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);
             
            aMaster.DCId = ddlDepotName.SelectedIndex > 0 ? int.Parse(ddlDepotName.SelectedValue) : (int?)null;
            aMaster.SubDepotId = ddlsubDepotName.SelectedIndex > 0 ? int.Parse(ddlsubDepotName.SelectedValue) : (int?)null;
            aMaster.GroupId = GroupSelect.SelectedIndex > 0 ? int.Parse(GroupSelect.SelectedValue) : (int?)null;
            aMaster.RegionId = ZoneSelect.SelectedIndex > 0 ? int.Parse(ZoneSelect.SelectedValue) : (int?)null;
            aMaster.AreaId = AreaSelect.SelectedIndex > 0 ? int.Parse(AreaSelect.SelectedValue) : (int?)null;







            ResultInfo Res = _DAL.SaveBonusCampaign(aMaster,  DtlCustList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TerritoryWiseDepotSetup.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

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

    protected void ddlsubDepotName_SelectedIndexChanged(object sender, EventArgs e)
    {
        


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