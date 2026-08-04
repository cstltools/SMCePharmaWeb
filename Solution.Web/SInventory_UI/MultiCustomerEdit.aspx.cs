using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_MultiCustomerEdit : System.Web.UI.Page
{
    CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
    MultiCustomerEditBLL aMultiCustomerEditBll=new MultiCustomerEditBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }
    public void LoadDropDown()
    {
        //aMasterBll.LoadCategoryName(categoryNameDropDownList);
        aMasterBll.LoadRegionname(regionNameDropDownList);
        aMasterBll.LoadCompanyUnit(comUnitNameDropDownList, regionNameDropDownList.SelectedValue);
        aMasterBll.LoadMiaName(miaNameDropDownList, areaNameDropDownList.SelectedValue);
        aMasterBll.LoadDistrictName(districtNameDropDownList, comUnitNameDropDownList.SelectedValue);
        aMasterBll.LoadMarketName(marketNameDropDownList, miaNameDropDownList.SelectedValue);
        aMasterBll.LoadAreaName(areaNameDropDownList, districtNameDropDownList.SelectedValue);
        //aMasterBll.LoadCategoryName(categoryNameDropDownList0);
        aMasterBll.LoadRegionname(regionNameDropDownList0);
        aMasterBll.LoadCompanyUnit(comUnitNameDropDownList0, regionNameDropDownList0.SelectedValue);
        aMasterBll.LoadMiaName(miaNameDropDownList0, areaNameDropDownList0.SelectedValue);
        aMasterBll.LoadDistrictName(districtNameDropDownList0, comUnitNameDropDownList0.SelectedValue);
        aMasterBll.LoadMarketName(marketNameDropDownList0, miaNameDropDownList0.SelectedValue);
        aMasterBll.LoadAreaName(areaNameDropDownList0, districtNameDropDownList0.SelectedValue);
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[4].FindControl("chkSelect");
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

    public string Parameter()
    {
        string parameter = " WHERE  ";
        if (regionNameDropDownList.SelectedIndex !=0)
        {
            parameter = parameter + " RegionCode='"+regionNameDropDownList.SelectedValue+"'  AND";    
        }
        if (comUnitNameDropDownList.SelectedIndex != 0)
        {
            parameter = parameter + " ComUnitCode='" + comUnitNameDropDownList.SelectedValue + "'  AND";
        }
        if (districtNameDropDownList.SelectedIndex != 0)
        {
            parameter = parameter + " DistrictCode='" + districtNameDropDownList.SelectedValue + "'  AND";
        }
        if (areaNameDropDownList.SelectedIndex != 0)
        {
            parameter = parameter + " AreaCode='" + areaNameDropDownList.SelectedValue + "'  AND";
        }
        if (miaNameDropDownList.SelectedIndex != 0)
        {
            parameter = parameter + " MiaCode='" + miaNameDropDownList.SelectedValue + "'  AND";
        }
        if (marketNameDropDownList.SelectedIndex != 0)
        {
            parameter = parameter + " MarketCode='" + marketNameDropDownList.SelectedValue + "'  AND";
        }
        //if (categoryNameDropDownList.SelectedIndex != 0)
        //{
        //    parameter = parameter + " CategoryId='" + categoryNameDropDownList.SelectedValue + "'  AND";
        //}
        parameter = parameter.Substring(0, parameter.Length - 3);
        return parameter;
    }
    public string ParameterUpdate()
    {
        string parameter = "    ";
        string[] CUnit = comUnitNameDropDownList0.SelectedItem.Text.Split(':');
        string[] MarketName = marketNameDropDownList0.SelectedItem.Text.Split(':');
        if (regionNameDropDownList0.SelectedIndex != 0)
        {
            parameter = parameter + " RegionCode='" + regionNameDropDownList0.SelectedValue + "'  ,";
        }
        if (comUnitNameDropDownList0.SelectedIndex != 0)
        {
            parameter = parameter + " ComUnitCode='" + comUnitNameDropDownList0.SelectedValue + "'  ,ComUnitName='"+CUnit[0]+"',";
        }
        if (districtNameDropDownList0.SelectedIndex != 0)
        {
            parameter = parameter + " DisCode='" + districtNameDropDownList0.SelectedValue + "'  ,";
        }
        if (areaNameDropDownList0.SelectedIndex != 0)
        {
            parameter = parameter + " AreaCode='" + areaNameDropDownList0.SelectedValue + "'  ,";
        }
        if (miaNameDropDownList0.SelectedIndex != 0)
        {
            parameter = parameter + " MIACode='" + miaNameDropDownList0.SelectedValue + "'  ,";
        }
        if (marketNameDropDownList0.SelectedIndex != 0)
        {
            parameter = parameter + " MarketCode='" + marketNameDropDownList0.SelectedValue + "' ,MarketName='" + MarketName[0] + "'  ,";
        }
        //if (categoryNameDropDownList0.SelectedIndex != 0)
        //{
        //    parameter = parameter + " CategoryId='" + categoryNameDropDownList0.SelectedValue + "'  ,";
        //}
        parameter = parameter.Substring(0, parameter.Length - 1);
        return parameter;
    }
    protected void searchButton_Click(object sender, EventArgs e)
    {
        string param = "";
        param = Parameter();
        DataTable dtdata = aMultiCustomerEditBll.LoadCusteomer(param);
        if (dtdata.Rows.Count > 0)
        {
            loadGridView.DataSource = dtdata;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
            showMessageBox("No Data Found!!");
        }
    }
    
    private void Clear()
    {
        
        marketNameDropDownList0.SelectedValue = null;
        areaNameDropDownList0.SelectedValue = null;
        comUnitNameDropDownList0.SelectedValue = null;
        districtNameDropDownList0.SelectedValue = null;
        regionNameDropDownList0.SelectedValue = null;
        miaNameDropDownList0.SelectedValue = null;
        //categoryNameDropDownList0.SelectedValue = null;
        loadGridView.DataSource = null;
        loadGridView.DataBind();
        
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void replaceButton_Click1(object sender, EventArgs e)
    {
        string code = "";
        bool status = false;
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[4].FindControl("chkSelect");
            if (ChkBoxRows.Checked)
            {
                DataTable dt = aMultiCustomerEditBll.CHeckInvice(loadGridView.DataKeys[i][0].ToString());
                if (dt.Rows.Count < 1)
                {
                    aMultiCustomerEditBll.UpdateDataForCustomer(ParameterUpdate(),
                        loadGridView.DataKeys[i][0].ToString());
                }
                else
                {
                    code = code + loadGridView.Rows[i].Cells[1].Text + ",";
                    status = true;
                }
            }

        }
        code = code.TrimEnd(',');

        if (status == true)
        {
            Clear();
            showMessageBox("Data Updated,Customer Code " + code + " is not updated ");
            Label2.Text = code;
        }
        else
        {
            Clear();
            showMessageBox("All Data Updated ");
        }
        
    }
}