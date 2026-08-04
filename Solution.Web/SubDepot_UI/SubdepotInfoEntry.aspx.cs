using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;
using Library.DAO.SInventory_Entities;

public partial class SubDepot_UI_SubdepotInfoEntry : System.Web.UI.Page
{
    SubDepotBLL aCompanyUnitBll = new SubDepotBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            if (Session["SubDepot"]!=null)
            {
                subdepotIdHiddenField.Value = Session["SubDepot"].ToString();
                GetData(subdepotIdHiddenField.Value);
                Session["SubDepot"] = null;
            }
        }
    }

    public void GetData(string id)
    {
        DataTable dtdata = aCompanyUnitBll.LoadSubDepotById(id);
        if (dtdata.Rows.Count>0)
        {
            companyNameDropDownList.SelectedValue = dtdata.Rows[0]["ComUnitId"].ToString();
            comUnitCodeTextBox.Text = dtdata.Rows[0]["SubDepotCode"].ToString();
            salesCenternameTextBox.Text = dtdata.Rows[0]["SubDepotName"].ToString();
            addressTextBox.Text = dtdata.Rows[0]["Address"].ToString();
            phoneNoTextBox.Text = dtdata.Rows[0]["PhoneNo"].ToString();
            mobileNoTextBox.Text = dtdata.Rows[0]["MobileNo"].ToString();
            faxNoTextBox.Text = dtdata.Rows[0]["FaxNo"].ToString();
            companyNameDropDownList.Enabled = false;
            //regionDropDownList.SelectedValue= dtdata.Rows[0][""].ToString();
        }

    }
    public void LoadDropDown()
    {
        aCompanyUnitBll.CompanyNameLoad(companyNameDropDownList);
    }
    private void Clear()
    {
        subdepotIdHiddenField.Value = string.Empty;
        salesCenternameTextBox.Text = string.Empty;
        companyNameDropDownList.Enabled = true;
        regionDropDownList.SelectedValue = null;
        addressTextBox.Text = string.Empty;
        phoneNoTextBox.Text = string.Empty;
        mobileNoTextBox.Text = string.Empty;
        faxNoTextBox.Text = string.Empty;
        companyNameDropDownList.SelectedValue = null;
        comUnitCodeTextBox.Text = string.Empty;

    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (salesCenternameTextBox.Text == "")
        {
            showMessageBox("Please Input Sales Center Name!!");
            return false;
        }
        if (addressTextBox.Text == "")
        {
            showMessageBox("Please Input Address!!");
            return false;
        }
        if (comUnitCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Code!!");
            return false;
        }
        if (mobileNoTextBox.Text == "")
        {
            showMessageBox("Please Input Mobile No!!");
            return false;
        }
        if (companyNameDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution Center!!");
            return false;
        }

        return true;
    }

    public void Save()
    {
        int maxReqId;
        if (Validation() == true)
        {
            CompanyUnit aCompanyUnit = new CompanyUnit()
            {
                ComUnitCode = comUnitCodeTextBox.Text.ToUpper().Trim(),
                ComUnitName = salesCenternameTextBox.Text.Trim(),
                Address = addressTextBox.Text.Trim(),
                PhoneNo = phoneNoTextBox.Text.Trim(),
                MobileNo = mobileNoTextBox.Text.Trim(),
                FaxNo = faxNoTextBox.Text.Trim(),
                ComUnitId = Convert.ToInt32(companyNameDropDownList.SelectedValue),

            };

            //  CompanyUnitBLL aCompanyUnitBll = new CompanyUnitBLL();
            if (aCompanyUnitBll.SaveSalesCenter(aCompanyUnit))
            {
                showMessageBox("Data Save Successfully  Sub-Depot Code  is :  " + aCompanyUnit.ComUnitCode + " And  Sub-Depot Name is :" + aCompanyUnit.ComUnitName);
                Clear();
            }
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }

    public void Update()
    {
        int maxReqId;
        if (Validation() == true)
        {
            CompanyUnit aCompanyUnit = new CompanyUnit()
            {
                ComUnitCode = comUnitCodeTextBox.Text.ToUpper().Trim(),
                ComUnitName = salesCenternameTextBox.Text.Trim(),
                Address = addressTextBox.Text.Trim(),
                PhoneNo = phoneNoTextBox.Text.Trim(),
                MobileNo = mobileNoTextBox.Text.Trim(),
                FaxNo = faxNoTextBox.Text.Trim(),
                ComUnitId = Convert.ToInt32(companyNameDropDownList.SelectedValue),
                RegionId = Convert.ToInt32(subdepotIdHiddenField.Value),

            };

            //  CompanyUnitBLL aCompanyUnitBll = new CompanyUnitBLL();
            if (aCompanyUnitBll.UpdateDataForSalesCenter(aCompanyUnit))
            {
                showMessageBox("Data Save Update  !!" );
                Clear();
            }
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (subdepotIdHiddenField.Value==string.Empty)
        {
            Save();    
        }
        else
        {
            Update();
        }
        
    }
    
    protected void unitViewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("SubdepotView.aspx");
    }
    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        CustomerMasterBLL aMasterBll = new CustomerMasterBLL();
        aMasterBll.LoadRegionname(regionDropDownList,companyNameDropDownList.SelectedValue);
    }
    protected void companyNameDropDownList_SelectedIndexChanged1(object sender, EventArgs e)
    {
        if (companyNameDropDownList.SelectedValue == "1" )
        {
            //comUnitCodeTextBox.Text = "BAR-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("BAR");
        }
        if (companyNameDropDownList.SelectedValue == "2")
        {
            //comUnitCodeTextBox.Text = "BOG-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("BOG");
        }
        if (companyNameDropDownList.SelectedValue == "3")
        {
            //comUnitCodeTextBox.Text = "CHA-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("CHA");
        }
        if (companyNameDropDownList.SelectedValue == "4")
        {
            //comUnitCodeTextBox.Text = "CUM-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("CUM");
        }
        if (companyNameDropDownList.SelectedValue == "6")
        {
            //comUnitCodeTextBox.Text = "KUS-002";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("KUS");
        }
        if (companyNameDropDownList.SelectedValue == "7")
        {
            //comUnitCodeTextBox.Text = "KHU-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("KHU");
        }
        if (companyNameDropDownList.SelectedValue == "8")
        {
            //comUnitCodeTextBox.Text = "MYM-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("MYM");
        }
        if (companyNameDropDownList.SelectedValue == "9")
        {
            //comUnitCodeTextBox.Text = "RAJ-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("RAJ");
        }
        if (companyNameDropDownList.SelectedValue == "10")
        {
            //comUnitCodeTextBox.Text = "RAN-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("RAN");
        }
        if (companyNameDropDownList.SelectedValue == "11")
        {
            //comUnitCodeTextBox.Text = "SYL-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("SYL");
        }
        if (companyNameDropDownList.SelectedValue == "12")
        {
            //comUnitCodeTextBox.Text = "DHA-001";
            comUnitCodeTextBox.Text = aCompanyUnitBll.CodeGenerator("DHA");
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubdepotInfoEntry.aspx");
    }
}