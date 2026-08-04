using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.Panal_BLL;

public partial class SettingPanel_UI_ArchiveDbConnect : System.Web.UI.Page
{
    private readonly ArchiveDbConnectRepository _repository = new ArchiveDbConnectRepository();
    private readonly PanalBLL _panalBll = new PanalBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        litJobName.Text = Server.HtmlEncode(_repository.JobName);

        if (!IsPostBack)
        {
            BindFinancialYearDropDown();
            BindGrid();
        }
    }

    protected void btnSave_OnClick(object sender, EventArgs e)
    {
        ArchiveDbConnectActionResult result;

        try
        {
            string fy = ddlFY.SelectedIndex > 0 ? ddlFY.SelectedItem.Text : string.Empty;
            result = _repository.SaveAndStartJob(fy, txtDatabaseName.Text);
        }
        catch (Exception exception)
        {
            ShowFailure(exception.Message);
            return;
        }

        if (result.IsSuccess)
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "Popup",
                "successalert('" + EscapeForJavaScript(result.Message) + "','Success','ArchiveDbConnect.aspx');",
                true);
            return;
        }

        BindGrid();
        ShowFailure(result.Message);
    }

    protected void btnReset_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("ArchiveDbConnect.aspx");
    }

    protected void gvArcDbConnect_PreRender(object sender, EventArgs e)
    {
        GridView gridView = (GridView)sender;

        if ((gridView.ShowHeader && gridView.Rows.Count > 0) || gridView.ShowHeaderWhenEmpty)
        {
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    private void BindGrid()
    {
        gvArcDbConnect.DataSource = _repository.GetRecentEntries();
        gvArcDbConnect.DataBind();
    }

    private void BindFinancialYearDropDown()
    {
        ddlFY.DataSource = _panalBll.FinancialYearList();
        ddlFY.DataTextField = "FinancialYearDesc";
        ddlFY.DataValueField = "FinancialYearId";
        ddlFY.DataBind();
        ddlFY.Items.Insert(0, new ListItem("Select Financial Year", string.Empty));
    }

    private void ShowFailure(string message)
    {
        ScriptManager.RegisterStartupScript(
            this,
            GetType(),
            "Popup",
            "faildalert('" + EscapeForJavaScript(message) + "','Faild');",
            true);
    }

    private static string EscapeForJavaScript(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return "Operation failed.";
        }

        return value
            .Replace("\\", "\\\\")
            .Replace("'", "\\'")
            .Replace("\r", " ")
            .Replace("\n", " ");
    }
}
