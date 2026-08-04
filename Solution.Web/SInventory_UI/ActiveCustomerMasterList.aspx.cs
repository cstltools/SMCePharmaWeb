using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ActiveCustomerMasterList : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
    CustomerMasterInfoBll aMasterInfoBll = new CustomerMasterInfoBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //CustomerMasterLoad();
            LoadDropDownList();
        }
    }

    private void LoadDropDownList()
    {
        aMasterInfoBll.LoadFEInfo(districtNameDropDownList);
        aMasterInfoBll.LoadTerritoryInfo(areaNameDropDownList);
        aMasterInfoBll.LoadMiaInfo(miaNameDropDownList);
        aMasterInfoBll.LoadMaketInfo(marketNameDropDownList);
        aMasterInfoBll.LoadDZSMInfo(regionNameDropDownList);
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void CustomerMasterLoad()
    {
        aDataTable = aMasterInfoBll.LoadCustomerMasterM2(GenerateParameter());
        if (aDataTable.Rows.Count>0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            showMessageBox("No Data Found");
        }
       
    }

    private string GenerateParameter()
    {
        string parameter = " WHERE ";

        if (custcodenameTextBox.Text != "")
        {
            parameter = parameter + "AreaCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
        }

        if (districtNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "DistrictCode = '" + districtNameDropDownList.SelectedItem.Text.Trim() + "' AND ";
        }

        if (areaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblCustMaster.AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (miaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "MIACode = '" + miaNameDropDownList.SelectedItem.Text.Trim() + "' AND ";
        }

        if (marketNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "MarketCode = '" + marketNameDropDownList.SelectedItem.Text.Trim() + "' AND ";
        }

        if (regionNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "RegionCode = '" + regionNameDropDownList.SelectedItem.Text.Trim() + "' AND ";
        }

        if (custcodenameTextBox.Text == "" && regionNameDropDownList.SelectedValue == "" && marketNameDropDownList.SelectedValue == "" && miaNameDropDownList.SelectedValue == "" && areaNameDropDownList.SelectedValue == "" && districtNameDropDownList.SelectedValue == "" && custcodenameTextBox.Text == "")
        {
            parameter = "";
        }

        string finalParameter = "";

        if (parameter != "")
        {
            finalParameter = parameter.Remove(parameter.Length - 4);
        }

        return finalParameter;
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(customermasterid);
        }
        if (e.CommandName == "viewData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(customermasterid);
        }
    }

    private void PopUp(string Id)
    {
        string url = "CustMasterEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void CustMasterNewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CustMasterEntry.aspx");
    }
    protected void CustMasterReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        CustomerMasterLoad();
    }

    protected void rptImageButton_Click(object sender, ImageClickEventArgs e)
    {
        string url = "../SInventory_RPTVIEW/CustomerMasterViewer.aspx";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        CustomerMasterLoad();
    }
}