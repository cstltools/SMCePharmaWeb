using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.DoctorModule_DAL;

public partial class SInventory_UI_SalesAssistantDAAmountClaimConfig : System.Web.UI.Page
{
    private const string RoleName = "Sales Assistant";
    private readonly DataAccessManager_daaw accessManager = new DataAccessManager_daaw();
    private readonly SetupDAL_daaw _setupDAL = new SetupDAL_daaw();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadStationType();
            LoadData();
            ResetForm();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        decimal daAmount;
        int tourTypeId;

        if (!Int32.TryParse(StationSelect.SelectedValue, out tourTypeId) || tourTypeId <= 0)
        {
            ShowFail("Please Select Station Type!");
            return;
        }

        if ((!Decimal.TryParse(txtDAAmount.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out daAmount)
             && !Decimal.TryParse(txtDAAmount.Text.Trim(), NumberStyles.Number, CultureInfo.CurrentCulture, out daAmount))
            || daAmount < 0)
        {
            ShowFail("Please Enter Valid DA Amount!");
            return;
        }

        int configId;
        Int32.TryParse(hfConfigId.Value, out configId);

        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@SalesAssistantDAAmountClaimConfigId", configId));
        parameters.Add(new SqlParameter("@RoleName", RoleName));
        parameters.Add(new SqlParameter("@TourTypeId", tourTypeId));
        parameters.Add(new SqlParameter("@DAAmount", daAmount));
        parameters.Add(new SqlParameter("@IsActive", chkIsActive.Checked));
        parameters.Add(new SqlParameter("@SessionUserId", GetSessionUserId()));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            accessManager.SaveDataReturnPrimaryKey("sp_Save_SalesAssistantDAAmountClaimConfig", parameters);
            ShowSuccess(configId > 0 ? "Updated Successfully!" : "Saved Successfully!");
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
            int configId;
            if (Int32.TryParse(e.CommandArgument.ToString(), out configId))
            {
                LoadEditData(configId);
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

    private void LoadStationType()
    {
        try
        {
            using (DataTable dt = _setupDAL.Get_TourPlanTypeDDL())
            {
                StationSelect.DataSource = dt;
                StationSelect.DataValueField = "TourTypeId";
                StationSelect.DataTextField = "TourTypeName";
                StationSelect.DataBind();
                StationSelect.Items.Insert(0, new ListItem("Please Select From List", ""));
                StationSelect.SelectedIndex = 0;
            }
        }
        catch
        {
            StationSelect.Items.Clear();
            StationSelect.Items.Insert(0, new ListItem("Please Select From List", ""));
        }
    }

    private void LoadData()
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@RoleName", RoleName));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            using (DataTable dt = accessManager.GetDataTable("sp_Get_SalesAssistantDAAmountClaimConfigList", parameters))
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

    private void LoadEditData(int configId)
    {
        List<SqlParameter> parameters = new List<SqlParameter>();
        parameters.Add(new SqlParameter("@SalesAssistantDAAmountClaimConfigId", configId));

        try
        {
            accessManager.SqlConnectionOpen(DataBase.SalesDB);
            using (DataTable dt = accessManager.GetDataTable("sp_Get_SalesAssistantDAAmountClaimConfigById", parameters))
            {
                if (dt.Rows.Count == 0)
                {
                    ShowFail("Data Not Found!");
                    return;
                }

                DataRow row = dt.Rows[0];
                hfConfigId.Value = row["SalesAssistantDAAmountClaimConfigId"].ToString();
                StationSelect.SelectedValue = row["TourTypeId"].ToString();
                txtDAAmount.Text = Convert.ToDecimal(row["DAAmount"]).ToString("0.00", CultureInfo.InvariantCulture);
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
        hfConfigId.Value = "0";
        txtRole.Text = RoleName;
        txtDAAmount.Text = String.Empty;
        chkIsActive.Checked = true;
        if (StationSelect.Items.Count > 0)
        {
            StationSelect.SelectedIndex = 0;
        }
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
