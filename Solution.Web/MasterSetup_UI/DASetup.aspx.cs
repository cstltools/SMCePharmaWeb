using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;

public partial class MasterSetup_UI_DASetup : System.Web.UI.Page
{
    DAInfoDal aDal = new DAInfoDal();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            LoadDepotList();
            if (Session["DAEdit"] != null)
            {
                btnUpdate.Visible = true;

                GetOneRecord(Convert.ToInt32(Session["DAEdit"].ToString()));
                Session["DAEdit"] = null;
            }
            else
            {
                btnSave.Visible = true;
                SetDefaultDates();
            }
        }

    }

    private void LoadDepotList()
    {
        try
        {
            OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
            aOtherStockActionBLL.DCLoad(ddlDepotName);
        }
        catch
        {
        }
    }

    private void SetDefaultDates()
    {
        string defaultDate = DateTime.Now.ToString("dd-MMMM-yyyy");
        txtJoiningDate.Text = defaultDate;
        txtActiveDate.Text = defaultDate;
        chkIsActive.Checked = true;
        pacinTxt.InnerText = "Active Date:";
    }

    private void ResetDepotSelection()
    {
        if (ddlDepotName.Items.Count == 0)
        {
            return;
        }

        ddlDepotName.ClearSelection();
        ListItem emptyItem = ddlDepotName.Items.FindByValue("");
        if (emptyItem != null)
        {
            emptyItem.Selected = true;
        }
        else
        {
            ddlDepotName.SelectedIndex = 0;
        }
    }

    private void GetOneRecord(int daId)
    {
        DataTable aTable = new DataTable();

        aTable = aDal.GetDAInfoById(daId);

        if (aTable.Rows.Count > 0)
        {
            txtNID.Text = aTable.Rows[0]["NID"].ToString();
            txtName.Text = aTable.Rows[0]["Name"].ToString();
            txtPhone.Text = aTable.Rows[0]["PhoneNo"].ToString();
            txtAddress.Text = aTable.Rows[0]["Address"].ToString();
            txtEmergencyContactNo.Text = aTable.Rows[0]["EmergencyContactNo"].ToString();
            txtReferenceName.Text = aTable.Rows[0]["ReferenceName"].ToString();
            txtReferencePhone.Text = aTable.Rows[0]["ReferencePhone"].ToString();
            txtRemarks.Text = aTable.Rows[0]["Remarks"].ToString();
            hiddenField.Value = aTable.Rows[0]["DAId"].ToString();

            string depotId = "";
            if (aTable.Columns.Contains("ComUnitId"))
            {
                depotId = aTable.Rows[0]["ComUnitId"].ToString();
            }
            else if (aTable.Columns.Contains("DepotId"))
            {
                depotId = aTable.Rows[0]["DepotId"].ToString();
            }

            if (!string.IsNullOrEmpty(depotId) && ddlDepotName.Items.FindByValue(depotId) != null)
            {
                ddlDepotName.SelectedValue = depotId;
            }

            if (aTable.Columns.Contains("JoiningDate") && aTable.Rows[0]["JoiningDate"] != DBNull.Value)
            {
                txtJoiningDate.Text = Convert.ToDateTime(aTable.Rows[0]["JoiningDate"]).ToString("dd-MMMM-yyyy");
            }

            if (aTable.Columns.Contains("IsActive") && aTable.Rows[0]["IsActive"] != DBNull.Value)
            {
                chkIsActive.Checked = Convert.ToBoolean(aTable.Rows[0]["IsActive"]);
            }

            if (chkIsActive.Checked)
            {
                pacinTxt.InnerText = "Active Date:";
                if (aTable.Columns.Contains("ActiveDate") && aTable.Rows[0]["ActiveDate"] != DBNull.Value)
                {
                    txtActiveDate.Text = Convert.ToDateTime(aTable.Rows[0]["ActiveDate"]).ToString("dd-MMMM-yyyy");
                }
            }
            else
            {
                pacinTxt.InnerText = "Inactive Date:";
                if (aTable.Columns.Contains("InactiveDate") && aTable.Rows[0]["InactiveDate"] != DBNull.Value)
                {
                    txtActiveDate.Text = Convert.ToDateTime(aTable.Rows[0]["InactiveDate"]).ToString("dd-MMMM-yyyy");
                }
            }

            if (string.IsNullOrEmpty(txtActiveDate.Text) && aTable.Columns.Contains("ActiveInActiveDate") && aTable.Rows[0]["ActiveInActiveDate"] != DBNull.Value)
            {
                txtActiveDate.Text = Convert.ToDateTime(aTable.Rows[0]["ActiveInActiveDate"]).ToString("dd-MMMM-yyyy");
            }
        }
        else
        {
            txtNID.Text = "";
            txtName.Text = "";
            txtPhone.Text = "";
            txtAddress.Text = "";
            txtEmergencyContactNo.Text = "";
            txtReferenceName.Text = "";
            txtReferencePhone.Text = "";
            txtRemarks.Text = "";
            ResetDepotSelection();
            txtJoiningDate.Text = "";
            txtActiveDate.Text = "";
            chkIsActive.Checked = true;
            pacinTxt.InnerText = "Active Date:";
        }
    }


    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        
        txtNID.CssClass = "form-control form-control-sm";
        txtName.CssClass = "form-control form-control-sm";
        txtPhone.CssClass = "form-control form-control-sm";
        txtEmergencyContactNo.CssClass = "form-control form-control-sm";
        txtReferenceName.CssClass = "form-control form-control-sm";
        txtReferencePhone.CssClass = "form-control form-control-sm";
        ddlDepotName.CssClass = "form-select form-select-sm mb-3 mySelect2";
        txtJoiningDate.CssClass = "form-control form-control-sm datepicker";
        txtActiveDate.CssClass = "form-control form-control-sm datepicker";
       
        if (txtName.Text == "")
        {

            txtName.ToolTip = "please fill out this field";
            txtName.CssClass = "form-control form-control-sm is-invalid";
            txtName.Focus();
           
            return false;
        }

        if (ddlDepotName.SelectedValue == "")
        {
            ddlDepotName.ToolTip = "please fill out this field";
            ddlDepotName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlDepotName.Focus();
            return false;
        }


        if (txtNID.Text != "")
        {
            if (txtNID.Text.Length != 17)
            {

                string text6 = "Delivery Man NID must be 17 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtNID.CssClass = "form-control form-control-sm is-invalid";
                txtNID.Focus();

                return false;
            }
        }

        if (txtPhone.Text == "")
        {


            txtPhone.ToolTip = "please fill out this field";
            txtPhone.CssClass = "form-control form-control-sm is-invalid";
            txtPhone.Focus();

           
            return false;
        }

        if (txtPhone.Text != "")
        {
            if(txtPhone.Text.Length != 11)
            {
               
                string text6 = "Phone No must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success" , "<script>showpop6('" + text6 + "')</script>", false);
                txtPhone.CssClass = "form-control form-control-sm is-invalid";
                txtPhone.Focus();

                return false;
            }
        }

            if (txtEmergencyContactNo.Text == "")
        {
            txtEmergencyContactNo.ToolTip = "please fill out this field";
            txtEmergencyContactNo.CssClass = "form-control form-control-sm is-invalid";
            txtEmergencyContactNo.Focus();
            return false;
        }

        if (txtEmergencyContactNo.Text != "")
        {
            if (txtEmergencyContactNo.Text.Length != 11)
            {

                string text6 = "Emergency Contact No must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtEmergencyContactNo.CssClass = "form-control form-control-sm is-invalid";
                txtEmergencyContactNo.Focus();

                return false;
            }
        }


        if (txtReferencePhone.Text != "")
        {
            if (txtReferencePhone.Text.Length != 11)
            {

                string text6 = "Reference Phone must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtEmergencyContactNo.Focus();
                txtReferencePhone.CssClass = "form-control form-control-sm is-invalid";

                return false;
            }
        }

        if (txtActiveDate.Text == "")
        {
            txtActiveDate.ToolTip = "please fill out this field";
            txtActiveDate.CssClass = "form-control form-control-sm datepicker is-invalid";
            txtActiveDate.Focus();
            return false;
        }

        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validation())
        {

            if (hiddenField.Value == null)
            {
                var aDao = new DAInfoDao();

                aDao.NID = txtNID.Text.Trim();
                aDao.Name = txtName.Text;
                aDao.PhoneNo = txtPhone.Text;
                aDao.Address = txtAddress.Text;
                aDao.EmergencyContactNo = txtEmergencyContactNo.Text;
                aDao.ReferenceName = txtReferenceName.Text;
                aDao.ReferencePhone = txtReferencePhone.Text;
                aDao.Remarks = txtRemarks.Text;
                aDao.ComUnitId = ddlDepotName.SelectedValue == "" ? (int?)null : Convert.ToInt32(ddlDepotName.SelectedValue);
                aDao.JoiningDate = string.IsNullOrEmpty(txtJoiningDate.Text) ? (DateTime?)null : DateTime.Parse(txtJoiningDate.Text).Date;
                aDao.IsActive = chkIsActive.Checked;
                DateTime? activeInactiveDate = string.IsNullOrEmpty(txtActiveDate.Text) ? (DateTime?)null : DateTime.Parse(txtActiveDate.Text).Date;
                if (chkIsActive.Checked)
                {
                    aDao.ActiveDate = activeInactiveDate;
                    aDao.InactiveDate = null;
                }
                else
                {
                    aDao.ActiveDate = null;
                    aDao.InactiveDate = activeInactiveDate;
                }
                aDao.EntryBy = Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString());
                aDao.EntryDate = DateTime.Now;

                if (aDal.SaveDAInfo(aDao) > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','CampaignView.aspx');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
            }
            else
            {
                var aDao = new DAInfoDao();
                aDao.DAId = hiddenField.Value == "" ? 0 : Convert.ToInt32(hiddenField.Value);
            
                aDao.NID = txtNID.Text.Trim();
                aDao.Name = txtName.Text;
                aDao.PhoneNo = txtPhone.Text;
                aDao.Address = txtAddress.Text;
                aDao.EmergencyContactNo = txtEmergencyContactNo.Text;
                aDao.ReferenceName = txtReferenceName.Text;
                aDao.ReferencePhone = txtReferencePhone.Text;
                aDao.Remarks = txtRemarks.Text;
                aDao.ComUnitId = ddlDepotName.SelectedValue == "" ? (int?)null : Convert.ToInt32(ddlDepotName.SelectedValue);
                aDao.JoiningDate = string.IsNullOrEmpty(txtJoiningDate.Text) ? (DateTime?)null : DateTime.Parse(txtJoiningDate.Text).Date;
                aDao.IsActive = chkIsActive.Checked;
                DateTime? activeInactiveDate = string.IsNullOrEmpty(txtActiveDate.Text) ? (DateTime?)null : DateTime.Parse(txtActiveDate.Text).Date;
                if (chkIsActive.Checked)
                {
                    aDao.ActiveDate = activeInactiveDate;
                    aDao.InactiveDate = null;
                }
                else
                {
                    aDao.ActiveDate = null;
                    aDao.InactiveDate = activeInactiveDate;
                }
                aDao.EntryBy = Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString());
                aDao.EntryDate = DateTime.Now;

                if (aDal.SaveDAInfo(aDao) > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','DAList.aspx');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
            }
            
        }
    }

    private void Clear()
    {
        txtNID.Text = "";
        txtName.Text = "";
        txtPhone.Text = "";
        txtAddress.Text = "";
        txtEmergencyContactNo.Text = "";
        txtReferenceName.Text = "";
        txtReferencePhone.Text = "";
        txtRemarks.Text = "";
        ResetDepotSelection();
        txtJoiningDate.Text = "";
        txtActiveDate.Text = "";
        chkIsActive.Checked = true;
        pacinTxt.InnerText = "Active Date:";

        btnSave.Text = "Save";
    }

     

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("DASetup.aspx");
    }
}
