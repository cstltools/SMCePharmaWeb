using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_TargetExcelUploadList : System.Web.UI.Page
{

    private static BonusCampaignNewDAL _BonusCampaignNewDAL = new BonusCampaignNewDAL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            try
            {
                using (DataTable dt = _seedRepo.GetFiscalYearList())
                {
                    ddlCampaignType.DataSource = dt;

                    ddlCampaignType.DataValueField = "FinancialYearId";
                    ddlCampaignType.DataTextField = "FinancialYearDesc";
                    ddlCampaignType.DataBind();
                    ddlCampaignType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlCampaignType.SelectedIndex = 1;
                }


            }
            catch (Exception ex) { }

            LoadData();
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
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("TargetExcelUpload.aspx");
    }


    private void LoadData()
    {
        DataTable aDataTable = _BonusCampaignNewDAL.GetTargetUploadList(parm());
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private string parm()
    {
        string param = "";

        if (ddlCampaignType.SelectedValue != "")
        {
            param = param + " AND A.FYId='" + ddlCampaignType.SelectedValue + "' ";
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
           
            Response.Redirect("TargetExcelUploadEdit.aspx?MID=" + unitPriceId);
        }


         if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

         bool del=   _BonusCampaignNewDAL.Delete_Target(Convert.ToInt32(unitPriceId));

            if (del)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                LoadData(); 

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }
        }

    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("CampaignView.aspx");
    }
}