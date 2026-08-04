using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.PromoAllocDAL;
using Library.DAO.PromoAlloc_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class PromoAlloc_PromoMIOTag : System.Web.UI.Page
{
    public static PromoMITagDAL aTargetDal = new PromoMITagDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialInfo();
        }
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

    private void LoadInitialInfo()
    {



        try
        {
            using (DataTable dt = aTargetDal.LoadGroup())
            {
                groupname.DataSource = dt;
                groupname.DataValueField = "PromoGroupId";
                groupname.DataTextField = "PromoGroupName";
                groupname.DataBind();
                groupname.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                groupname.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

    }

    [WebMethod(EnableSession = true)]
    public static string LoadGroup()
    {
        DataTable ds = aTargetDal.LoadGroup();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

    [WebMethod(EnableSession = true)]
    public static string LoadProduct()
    {
        DataTable ds = aTargetDal.LoadProduct();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_List.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_List.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            CheckCustInOrder(i);

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

            CheckBox chkSelect = (CheckBox)gv_List.Rows[rowIndex].Cells[1].FindControl("chkSelect");
            HiddenField hfEmpInfoId = (HiddenField)gv_List.Rows[rowIndex].Cells[1].FindControl("hfEmpInfoId");

            if (chkSelect.Checked)
            {
                DataTable dt = _dataLoad.GetMIOTagValidationCheck(groupname.SelectedValue, hfEmpInfoId.Value);

                if (dt.Rows.Count == 0)
                {

                }
                else
                {
                    chkSelect.Checked = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Declared in Promo Group!" + "','Faild');", true);

                }
            }




        }
        catch (Exception ex)
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string LoadMIO(string id)
    {
        DataTable ds = aTargetDal.LoadMIO(id);
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }




    [WebMethod(EnableSession = true)]
    public static string SaveMIOTag(PromoMIOTagMaster aTargetDao)
    {

        int status = 0;


        DataTable dtdata = aTargetDal.LoadMIOTag(aTargetDao.PromoGroupId.ToString());
        if (dtdata.Rows.Count < 1)
        {
            status = aTargetDal.SaveMIOTagMaster(aTargetDao);
        }
        else
        {
            status = Convert.ToInt32(dtdata.Rows[0]["MIOTagId"].ToString());
        }

        bool delst = aTargetDal.DeleteData(aTargetDao.PromoGroupId.ToString());
        foreach (var promoMioTagDetail in aTargetDao.adetail)
        {
            promoMioTagDetail.MIOTagMasterId = status;
            aTargetDal.SaveMIOTagDetail(promoMioTagDetail);
        }


        return status.ToString();
    }

    protected void groupname_SelectedIndexChanged(object sender, EventArgs e)
    {
        gv_List.DataSource = null;
        gv_List.DataBind();
        if (groupname.SelectedValue != "")
        {
            DataTable ds = aTargetDal.LoadMIO(groupname.SelectedValue);
            id_mastetID.Value= ds.Rows[0]["MIOTagMasterId"].ToString();

            gv_List.DataSource = ds;
            gv_List.DataBind();
        }
    }

    public bool Validation()
    {

 
        groupname.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (groupname.SelectedValue == "")
        {
            groupname.ToolTip = "please fill out this field";
            groupname.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            groupname.Focus();
            return false;
        }

        if (gv_List.Rows.Count == 0)
        {
            showMessageBox("Table can not be Empty!");

            return false;
        }


        Int32 count = 0;

        for (int i = 0; i < gv_List.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_List.Rows[i].Cells[0].FindControl("chkSelect");

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

            List<PromoMIOTagDetail> MarketList = new List<PromoMIOTagDetail>();


            for (int i = 0; i < gv_List.Rows.Count; i++)
            {
                HiddenField hfMIOId = ((HiddenField)gv_List.Rows[i].Cells[1].FindControl("hfMIOId"));
                HiddenField hfEmpInfoId = ((HiddenField)gv_List.Rows[i].Cells[1].FindControl("hfEmpInfoId"));
                CheckBox chkSelect = ((CheckBox)gv_List.Rows[i].Cells[1].FindControl("chkSelect"));

                if (chkSelect.Checked)
                {
                    PromoMIOTagDetail _DAO = new PromoMIOTagDetail();

                    _DAO.MIOId = string.IsNullOrEmpty(hfMIOId.Value) ? (int?)null : int.Parse(hfMIOId.Value);

                    _DAO.EmpInfoId = string.IsNullOrEmpty(hfEmpInfoId.Value) ? (int?)null : int.Parse(hfEmpInfoId.Value);








                    MarketList.Add(_DAO);
                }

               

            }
            PromoMIOTagMaster aMaster = new PromoMIOTagMaster();

            aMaster.MIOTagId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);
 
            aMaster.PromoGroupId = groupname.SelectedIndex > 0 ? int.Parse(groupname.SelectedValue) : (int?)null;
             



            ResultInfo Res = aTargetDal.SaveBonusCampaign(aMaster, MarketList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','PromoMIOTag.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("PromoMIOTag.aspx");
    }
}
 