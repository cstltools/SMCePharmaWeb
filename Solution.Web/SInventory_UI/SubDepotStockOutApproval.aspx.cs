using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;
using Library.DAO.SInventory_Entities;
using Library.DAO.SubDepot_DAO;

public partial class SInventory_UI_DcStockOutApproval : System.Web.UI.Page
{




    SubDepotStockAdjustmentsVoucherBll aStockOutBll = new SubDepotStockAdjustmentsVoucherBll();


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            

            if (DataTrue())
            {
                DcStockOutViewForApproval();
               
            }

        }
    }


    private void DcStockOutViewForApproval()
    {

        DataTable dt = aStockOutBll.SubDcStockOutApprovalViewBll();
        loadGridView.DataSource = dt;
        loadGridView.DataBind();

    }


    public bool DataTrue()
    {
        string filepath = Path.GetDirectoryName(Request.Path);
        filepath = filepath.TrimStart('\\');
        string exten = Path.GetExtension(Request.Path);
        if (exten == string.Empty)
        {
            //filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path) + ".aspx";
            filepath = Path.GetFileName(Request.Path) + ".aspx";
        }
        else
        {
            //filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);
            filepath = Path.GetFileName(Request.Path);
        }
        DataTable dtmenu = aStockOutBll.GetMenuIdByMenuName(filepath);
        if (dtmenu.Rows.Count > 0)
        {
            DataTable dataapp = aStockOutBll.GetAssignedAppUser(dtmenu.Rows[0]["SL"].ToString(),
                Session["UserId"].ToString());
            if (dataapp.Rows.Count > 0)
            {
                return true;
            }
        }
        return false;
    }
    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
     

        if (e.CommandName == "View")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string Id = loadGridView.DataKeys[rowindex][0].ToString();
            Session["SubDcStockOutMasterId"] = Id;
            string url = "../SInventory_RPTVIEW/SubDepotStockOutReportViewer.aspx?SubDcStockOutMasterId=" + Id;
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }

    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubDepotStockOutApproval.aspx");
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


    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[6].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }
    }

    protected void btnSubmit0_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            SubmitApproval();
        }
        else
        {
            ShowMessageBox("Please select at least one row!!!");
        }

        DcStockOutViewForApproval();
    }

    private bool Validation()
    {
        bool status = false;
        int count = 0;

    
        if (statusRadioButtonList.SelectedValue == "")
        {
            ShowMessageBox("Please select an operation!!");
        }

        else
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                CheckBox cb = (CheckBox)loadGridView.Rows[i].Cells[6].FindControl("chkSelect");

             

                if (cb.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    status = true;
                    break;
                }

            }
        }

       

        return status;
    }

    private void SubmitApproval()
    {

        if (statusRadioButtonList.SelectedItem.Text != "Reject")
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {

                CheckBox cb = (CheckBox)loadGridView.Rows[i].Cells[6].FindControl("chkSelect");

                    if (cb.Checked)
                    {

                            SubdepotStockOutMasterDao aMasterDao = new SubdepotStockOutMasterDao();
                            aMasterDao.SubDcStockOutMasterId = Convert.ToInt32(loadGridView.DataKeys[i][0].ToString());
                            aMasterDao.Status = "Approved";
                            aMasterDao.ApprovedBy = Session["LoginName"].ToString();
                            aMasterDao.ApprovedDate = DateTime.Today;
                            aStockOutBll.UpdateStockOutMasterDataForApprovalBll(aMasterDao);
                    }
                    
            
            }

            ShowMessageBox("Sub Depot Stock Out Approved Successfully!!");
        }

        else
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {

                CheckBox cb = (CheckBox)loadGridView.Rows[i].Cells[6].FindControl("chkSelect");

                if (cb.Checked)
                {
                    DcStockOutMasterDao aMasterDao = new DcStockOutMasterDao();

                    aMasterDao.DcStockOutMasterId = Convert.ToInt32(loadGridView.DataKeys[i][0].ToString());

                    aMasterDao.Status = statusRadioButtonList.SelectedItem.Text;
                    aMasterDao.ApprovedBy = Session["LoginName"].ToString();
                    aMasterDao.ApprovedDate = DateTime.Today;

                    aStockOutBll.ApprovalUpdateBLL(aMasterDao);

                }
            }

            ShowMessageBox("Sub depot Stock Out Reject Successfully!!");
        }

    }

  
}