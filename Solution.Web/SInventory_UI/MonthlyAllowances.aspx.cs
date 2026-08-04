using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;

public partial class SInventory_UI_MonthlyAllowances : System.Web.UI.Page
{
    private const string RoleName = "Sales Assistant";
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadData();
            ResetForm();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        decimal allowanceAmount;
        string allowanceName = txtAllowanceName.Text.Trim();

        if (String.IsNullOrEmpty(allowanceName))
        {
            ShowFail("Please Enter Allowance Name!");
            return;
        }

        if ((!Decimal.TryParse(txtAllowanceAmount.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out allowanceAmount)
             && !Decimal.TryParse(txtAllowanceAmount.Text.Trim(), NumberStyles.Number, CultureInfo.CurrentCulture, out allowanceAmount))
            || allowanceAmount < 0)
        {
            ShowFail("Please Enter Valid Allowance Amount!");
            return;
        }

        int allowanceId;
        Int32.TryParse(hfAllowanceId.Value, out allowanceId);

        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@MonthlyAllowanceId", allowanceId));
        parameters.Add(new SqlParameter("@RoleName", RoleName));
        parameters.Add(new SqlParameter("@AllowanceName", allowanceName));
        parameters.Add(new SqlParameter("@AllowanceAmount", allowanceAmount));
        parameters.Add(new SqlParameter("@IsActive", chkIsActive.Checked));
        parameters.Add(new SqlParameter("@SessionUserId", GetSessionUserId()));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            accessManager.SaveDataReturnPrimaryKey("sp_Save_MonthlyAllowance", parameters);
            ShowSuccess(allowanceId > 0 ? "Updated Successfully!" : "Saved Successfully!");
        }
        catch (Exception ex)
        {
            accessManager.SqlConnectionClose(true);
            ShowFail(ex.Message.Replace("'", ""));
            return;
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }

        ResetForm();
        LoadData();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditRow")
        {
            int allowanceId;
            if (Int32.TryParse(e.CommandArgument.ToString(), out allowanceId))
            {
                LoadEditData(allowanceId);
            }
        }
    }

    protected void loadGridView_PreRender(object sender, EventArgs e)
    {
        GridView gridView = (GridView)sender;
        if ((gridView.ShowHeader && gridView.Rows.Count > 0) || gridView.ShowHeaderWhenEmpty)
        {
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    private void LoadData()
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@RoleName", RoleName));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            using (DataTable dt = accessManager.GetDataTable("sp_Get_MonthlyAllowanceList", parameters))
            {
                loadGridView.DataSource = dt;
                loadGridView.DataBind();
                lblCount.Text = "Total Record: " + dt.Rows.Count;
            }
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private void LoadEditData(int allowanceId)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@MonthlyAllowanceId", allowanceId));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            using (DataTable dt = accessManager.GetDataTable("sp_Get_MonthlyAllowanceById", parameters))
            {
                if (dt.Rows.Count == 0)
                {
                    ShowFail("Data Not Found!");
                    return;
                }

                DataRow row = dt.Rows[0];
                hfAllowanceId.Value = row["MonthlyAllowanceId"].ToString();
                txtAllowanceName.Text = row["AllowanceName"].ToString();
                txtAllowanceAmount.Text = Convert.ToDecimal(row["AllowanceAmount"]).ToString("0.00", CultureInfo.InvariantCulture);
                chkIsActive.Checked = Convert.ToBoolean(row["IsActive"]);
                btnSave.Text = "Update";
            }
        }
        finally
        {
            accessManager.SqlConnectionClose();
        }
    }

    private void ResetForm()
    {
        hfAllowanceId.Value = "0";
        txtRole.Text = RoleName;
        txtAllowanceName.Text = String.Empty;
        txtAllowanceAmount.Text = String.Empty;
        chkIsActive.Checked = true;
        btnSave.Text = "Save";
    }

    private object GetSessionUserId()
    {
        int userId;
        if (Session["UserId"] != null && Int32.TryParse(Session["UserId"].ToString(), out userId))
        {
            return userId;
        }

        return DBNull.Value;
    }

    private void ShowSuccess(string message)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "swal({icon:'success',title:'Congratulations!',text:'" + message + "',type:'success'});", true);
    }

    private void ShowFail(string message)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + message + "','Faild');", true);
    }
}
