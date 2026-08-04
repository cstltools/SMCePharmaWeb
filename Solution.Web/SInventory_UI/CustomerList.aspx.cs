using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_CustomerList : System.Web.UI.Page
{
    private DataTable aDataTable = new DataTable();
    private ExcelUpForMIGOBLL aExcelUpForMIGOBLL = new ExcelUpForMIGOBLL();
    ReportDocument rptdoc = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }

    public void LoadDropDown()
    {
        aExcelUpForMIGOBLL.LoadmanufacturerName(manufacturerDropDownList);
    }
    private void LoadInitialGrid(GridView gridView)
    {
        gridView.DataSource = aExcelUpForMIGOBLL.LoadCustomer(Parameter());
        gridView.DataBind();
        PlaceVerfiyUnverify();
    }
    private void MigoLoad()
    {
        aDataTable = aExcelUpForMIGOBLL.LoadMigo();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }
    public void ExportToExcelVerified(string id)
    {
        string url = "../SInventory_RPTVIEW/CustVerUnverExcelViewer.aspx?status=" + 1 + "&id=" + id;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    public void ExportToExcelUnVerified(string id)
    {


        string url = "../SInventory_RPTVIEW/CustVerUnverExcelViewer.aspx?status=" + 2 + "&id=" + id;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);       
    }
    private void PopUp(string Id)
    {
        string url = "ProductEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url +
                         "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof (string), "OPEN_WINDOW", fullURL, true);
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            DataTable dt = new DataTable();
            dt = aExcelUpForMIGOBLL.LoadCustomer(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
            bool stockTansfer = Convert.ToBoolean(dt.Rows[0].Field<bool>("Transfer").ToString());
            if (stockTansfer == false)
            {
                aExcelUpForMIGOBLL.DeleteCustomerData(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
                aExcelUpForMIGOBLL.DeleteCustomerDetailData(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));
                LoadInitialGrid(loadGridView);
                ShowMessageBox(" Deleted successfully !!! ");
            }
            else
            {
                ShowMessageBox("Can't Delete !!! ");
            }

        }
        if (e.CommandName == "TransferData")
        {

        }
        if (e.CommandName == "VerifyData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string id= loadGridView.DataKeys[rowindex][0].ToString();
            aExcelUpForMIGOBLL.VerifyCustomerBLL(id);
            ShowMessageBox("Verified");
        }
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void refreshButton_Click(object sender, EventArgs e)
    {
        LoadInitialGrid(loadGridView);
        //Response.Redirect("../SInventory_UI/MIGOList.aspx");
    }

    public string Parameter()
    {
        string paramter = "";
        if (manufacturerDropDownList.SelectedValue != "" )
        {
            paramter = " tblCustomerMasterExcelFileMaster.ManufacId='" + manufacturerDropDownList.SelectedValue + "";
        }
        
        return paramter;
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (manufacturerDropDownList.SelectedValue != "")
        {
            LoadInitialGrid(loadGridView);
        }
        else
        {
            ShowMessageBox("Please Select Manufacturer !!");
        }
    }

    public void PlaceVerfiyUnverify()
    {
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            DataTable dtverified = aExcelUpForMIGOBLL.GetVerifyedData(loadGridView.DataKeys[i][0].ToString());
            DataTable dtunverified = aExcelUpForMIGOBLL.GetUnVerifyedData(loadGridView.DataKeys[i][0].ToString());
            ((LinkButton)loadGridView.Rows[i].Cells[8].FindControl("verifiedLinkButton")).Text = dtverified.Rows[0][0].ToString();
            ((LinkButton)loadGridView.Rows[i].Cells[9].FindControl("unverifiedLinkButton")).Text = dtunverified.Rows[0][0].ToString();
        }
    }
    protected void transferImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton imageButtonTra = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)imageButtonTra.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        ////Verify Again
        //string id = loadGridView.DataKeys[rowindex][0].ToString();
        //aExcelUpForMIGOBLL.VerifyCustomerBLL(id);
        ////

        DataTable dt = new DataTable();
        dt = aExcelUpForMIGOBLL.LoadCustomer(Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString()));

        bool VerifyedAll = Convert.ToBoolean(dt.Rows[0].Field<bool>("VerifyedAll").ToString());
        if (VerifyedAll == true)
        {
            int migoId = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());
            if (aExcelUpForMIGOBLL.TransfarCustomer_BLL(migoId) > 0)
            {
                ShowMessageBox("Transferred successfully!!!");
                LoadInitialGrid(loadGridView);
            }
        }
        else
        {
            ShowMessageBox("Please Verify all Customer!!!");
        }
      
    }
    protected void verifiedLinkButton_Click(object sender, EventArgs e)
    {
        LinkButton LinkButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)LinkButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        ExportToExcelVerified(loadGridView.DataKeys[rowindex][0].ToString());

    }

    protected void unverifiedLinkButton_OnClick(object sender, EventArgs e)
    {
        LinkButton LinkButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)LinkButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        ExportToExcelUnVerified(loadGridView.DataKeys[rowindex][0].ToString());
    }
}