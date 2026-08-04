using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SalesSolution.Web.Models;

public partial class MasterSetup_UI_CampaignView : System.Web.UI.Page
{

    private static BonusCampaignNewDAL _BonusCampaignNewDAL = new BonusCampaignNewDAL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    string EmpInfoId = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        
            try
        {
           
            EmpInfoId = Session["EmpInfoId"].ToString();
            if (!IsPostBack)
            {

              //  CheckSyncStatus();

                if (EmpInfoId== "496")
                {
                    EmpCetegoryAddImageButton.Visible = false;
                }
                try
                {
                    using (DataTable dt = _seedRepo.GetCampaignTypeList())
                    {
                        ddlCampaignType.DataSource = dt;

                        ddlCampaignType.DataValueField = "CampainTypeId";
                        ddlCampaignType.DataTextField = "TypeName";
                        ddlCampaignType.DataBind();
                        ddlCampaignType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        ddlCampaignType.SelectedIndex = 0;
                    }


                }
                catch (Exception ex) { }
                LoadData();
            }
        }
        catch (Exception ex) { }

    }


    private void CheckSyncStatus()
    {
        try
        {
            // Assuming _BonusCampaignNewDAL.GetMobileSyncStatus calls your SP and returns a DataTable
            using (DataTable dt = _BonusCampaignNewDAL.GetMobileSyncStatus(""))
            {
                if (dt.Rows.Count > 0)
                {
                    string result = dt.Rows[0]["Result"].ToString();

                    if (result.Equals("yes", StringComparison.OrdinalIgnoreCase))
                    {
                        // Show modal by registering a script to open the modal on page load
                        NoofGSPPopupExtender.Show();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Optional: log the error
        }
    }

    protected void btnSyncNow_Click(object sender, EventArgs e)
    {
        ResultInfo Res = new ResultInfo();
        Res = _BonusCampaignNewDAL.SYncBonusCampaign( Session["UserId"].ToString());

        if (Res.isSuccess) {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
        //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success'", true);

    }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Something went wrong!" + "','Faild');", true);

    }

    NoofGSPPopupExtender.Hide();
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
        Response.Redirect("CampaignSetup.aspx");
    }


    private void LoadData()
    {
        DataTable aDataTable = _BonusCampaignNewDAL.GetBonusCampaignList(parm());
        HashSet<string> campaignTypeCombination = new HashSet<string>();

        // Loop through the rows in the DataTable and remove duplicates
        for (int i = aDataTable.Rows.Count - 1; i >= 0; i--)
        {
            string campaignName = aDataTable.Rows[i]["CampaignName"].ToString();
            string typeName = aDataTable.Rows[i]["TypeName"].ToString();

            // Combine CampaignName and TypeName into a single string using concatenation
            string combination = campaignName + "|" + typeName;

            // Check if this (CampaignName, TypeName) combination has already been encountered
            if (campaignTypeCombination.Contains(combination))
            {
                // Remove the row if the combination is a duplicate
                aDataTable.Rows.RemoveAt(i);
            }
            else
            {
                // Add the combination to the HashSet
                campaignTypeCombination.Add(combination);
            }
        }


        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private string parm()
    {
        string param = "";

        if (ddlCampaignType.SelectedValue != "")
        {
            param = param + " AND A.CampainTypeId='" + ddlCampaignType.SelectedValue + "' ";
        }
        if (ddlActive.SelectedValue != "")
        {
            param = param + " AND A.IsActive='" + ddlActive.SelectedValue + "' ";
        }
        else
        {
            param = param + "  and CONVERT(date,getdate()) BETWEEN CONVERT(date, A.FromDate) and  CONVERT(date, A.Todate) ";
        }
         
        if (FromDate.Text != "" && ToDate.Text != "")
        {
            param = param + " AND CONVERT(date,A.FromDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        }
        if (FromDate.Text != "" && ToDate.Text == "")
        {
            param = param + " AND CONVERT(date,A.FromDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now + "' ";
        }

       

        return param;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }
        protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();
           
            Response.Redirect("CampaignSetup.aspx?MID=" + unitPriceId);
        }

    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("CampaignView.aspx");
    }
}