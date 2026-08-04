using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_FixedCustomerInformation : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    CustomerMasterBLL aCustomerMasterBLL = new CustomerMasterBLL();
    CustomerMasterInfoBll aMasterInfoBll = new CustomerMasterInfoBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
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

    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void CustomerMasterLoad()
    {
        aDataTable = aMasterInfoBll.LoadCustomerMaster(GenerateParameter());
        if (aDataTable.Rows.Count>0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            ShowMessageBox("No Data Found");
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
       
    }

    private string GenerateParameter()
    {
        string parameter = " WHERE tblInvoice.FixedCustomer=1 AND ";

        if (custcodenameTextBox.Text != "")
        {
            parameter = parameter + "CustomerCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
        }

        if (districtNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "DistrictCode = '" + districtNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (areaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (miaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "MIACode = '" + miaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (marketNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "MarketCode = '" + marketNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (regionNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "RegionCode = '" + regionNameDropDownList.SelectedValue.Trim() + "' AND ";
        }
        //if (yearDropDownList.SelectedValue != "")
        //{
        //    parameter = parameter + "cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar)  = '" + yearDropDownList.SelectedValue.Trim() + "' AND ";
        //}
        //if (monthDropDownList.SelectedValue != "")
        //{
        //    parameter = parameter + "DATENAME(mm, tblInvoice.UpdateDate) = '" + monthDropDownList.SelectedValue.Trim() + "' AND ";
        //}
        
        parameter = parameter.Remove(parameter.Length - 4);
      

        return parameter;
    }
    private string GenerateParameter2()
    {
        string parameter = " WHERE tblInvoice.FixedCustomer=1 AND ";

        if (custcodenameTextBox.Text != "")
        {
            parameter = parameter + "tblCustMaster.CustomerCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
        }

        if (districtNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.DisCode = '" + districtNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (areaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (miaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.MIACode = '" + miaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (marketNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.MarketCode = '" + marketNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (regionNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.RegionCode = '" + regionNameDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (yearDropDownList.SelectedValue != "")
        {
            parameter = parameter + "cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar)  = '" + yearDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (monthDropDownList.SelectedValue != "")
        {
            parameter = parameter + "DATENAME(mm, tblInvoice.UpdateDate) = '" + monthDropDownList.SelectedValue.Trim() + "' AND ";
        }

        //if (custcodenameTextBox.Text == "" && regionNameDropDownList.SelectedValue == "" && marketNameDropDownList.SelectedValue == "" && miaNameDropDownList.SelectedValue == "" && areaNameDropDownList.SelectedValue == "" && districtNameDropDownList.SelectedValue == "" && custcodenameTextBox.Text == "")
        //{
        //    parameter = "";
        //}

      //  string finalParameter = "";

        //if (parameter != "")
       // {
        parameter = parameter.Remove(parameter.Length - 4);
       // }

        return parameter;
    }

    private string GenerateParameter3()
    {
        string parameter = " WHERE tblSubInvoiceMaster.FixedCustomer=1 AND ";

        if (custcodenameTextBox.Text != "")
        {
            parameter = parameter + "tblCustMaster.CustomerCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
        }

        if (districtNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.DisCode = '" + districtNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (areaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (miaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.MIACode = '" + miaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (marketNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.MarketCode = '" + marketNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (regionNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.RegionCode = '" + regionNameDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (yearDropDownList.SelectedValue != "")
        {
            parameter = parameter + "cast(datepart(yyyy,tblSubInvoiceMaster.UpdateDate) as varchar)  = '" + yearDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (monthDropDownList.SelectedValue != "")
        {
            parameter = parameter + "DATENAME(mm, tblSubInvoiceMaster.UpdateDate) = '" + monthDropDownList.SelectedValue.Trim() + "' AND ";
        }

        //if (custcodenameTextBox.Text == "" && regionNameDropDownList.SelectedValue == "" && marketNameDropDownList.SelectedValue == "" && miaNameDropDownList.SelectedValue == "" && areaNameDropDownList.SelectedValue == "" && districtNameDropDownList.SelectedValue == "" && custcodenameTextBox.Text == "")
        //{
        //    parameter = "";
        //}

        //  string finalParameter = "";

        //if (parameter != "")
        // {
        parameter = parameter.Remove(parameter.Length - 4);
        // }

        return parameter;
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(customermasterid);
        }

        if (e.CommandName == "Report")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUpFixedCustomerReport(customermasterid);
        }

        if (e.CommandName == "viewData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(customermasterid);
        }
    }

    private void PopUpFixedCustomerReport(string customermasterId)
    {
        string url = "../SInventory_RPTVIEW/FixedCustomerSalesReportViewer.aspx?customerId=" + customermasterId;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
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
    protected void Button2_Click(object sender, EventArgs e)
    {
        //if (statusDropDownList.SelectedValue== "0")
        //{
        //    ShowMessageBox("Please select Customer Status!!");
        //}
        //if (statusDropDownList.SelectedValue == "1")
        //{
            Session["Parameter"] = "";
            Session["Parameter"] = GenerateParameterAll();

            Session["Parameter2"] = "";
            Session["Parameter2"] = GenerateParameterAll2();

            string url = "../SInventory_RPTVIEW/ExcelSalesReportViewer.aspx";
            string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (statusDropDownList.SelectedValue == "2")
        //{
        //    Session["Parameter"] = "";
        //    Session["Parameter"] = GenerateParameter2();

        //    Session["Parameter2"] = "";
        //    Session["Parameter2"] = GenerateParameter3();


        //    string url = "../SInventory_RPTVIEW/ExcelSalesReportViewer.aspx";
        //    string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
       
    }
    private string GenerateParameterAll()
    {
        string parameter = " WHERE tblInvoice.FixedCustomer=1 AND ";

        if (custcodenameTextBox.Text != "")
        {
            parameter = parameter + "tblCustMaster.CustomerCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
        }

        if (districtNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.DisCode = '" + districtNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (areaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (miaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.MIACode = '" + miaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (marketNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.MarketCode = '" + marketNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (regionNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblInvoice.RegionCode = '" + regionNameDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (yearDropDownList.SelectedValue != "")
        {
            parameter = parameter + "cast(datepart(yyyy,tblInvoice.UpdateDate) as varchar)  = '" + yearDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (monthDropDownList.SelectedValue != "")
        {
            parameter = parameter + "DATENAME(mm, tblInvoice.UpdateDate) = '" + monthDropDownList.SelectedValue.Trim() + "' AND ";
        }

        //if (custcodenameTextBox.Text == "" && regionNameDropDownList.SelectedValue == "" && marketNameDropDownList.SelectedValue == "" && miaNameDropDownList.SelectedValue == "" && areaNameDropDownList.SelectedValue == "" && districtNameDropDownList.SelectedValue == "" && custcodenameTextBox.Text == "")
        //{
        //    parameter = "";
        //}

        //  string finalParameter = "";

        //if (parameter != "")
        // {
        parameter = parameter.Remove(parameter.Length - 4);
        // }

        return parameter;
    }

    private string GenerateParameterAll2()
    {
        string parameter = " WHERE tblSubInvoiceMaster.FixedCustomer=1 AND ";

        if (custcodenameTextBox.Text != "")
        {
            parameter = parameter + "tblCustMaster.CustomerCode = '" + custcodenameTextBox.Text.Trim() + "' AND ";
        }

        if (districtNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.DisCode = '" + districtNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (areaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.AreaCode = '" + areaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (miaNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.MIACode = '" + miaNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (marketNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.MarketCode = '" + marketNameDropDownList.SelectedValue.Trim() + "' AND ";
        }

        if (regionNameDropDownList.SelectedValue != "")
        {
            parameter = parameter + "tblSubInvoiceMaster.RegionCode = '" + regionNameDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (yearDropDownList.SelectedValue != "")
        {
            parameter = parameter + "cast(datepart(yyyy,tblSubInvoiceMaster.UpdateDate) as varchar)  = '" + yearDropDownList.SelectedValue.Trim() + "' AND ";
        }
        if (monthDropDownList.SelectedValue != "")
        {
            parameter = parameter + "DATENAME(mm, tblSubInvoiceMaster.UpdateDate) = '" + monthDropDownList.SelectedValue.Trim() + "' AND ";
        }

        //if (custcodenameTextBox.Text == "" && regionNameDropDownList.SelectedValue == "" && marketNameDropDownList.SelectedValue == "" && miaNameDropDownList.SelectedValue == "" && areaNameDropDownList.SelectedValue == "" && districtNameDropDownList.SelectedValue == "" && custcodenameTextBox.Text == "")
        //{
        //    parameter = "";
        //}

        //  string finalParameter = "";

        //if (parameter != "")
        // {
        parameter = parameter.Remove(parameter.Length - 4);
        // }

        return parameter;
    }
}