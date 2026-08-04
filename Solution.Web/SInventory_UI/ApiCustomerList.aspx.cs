using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ApiCustomerList : System.Web.UI.Page
{
  
    ImportedApiCustomerBll apiCustomerBll = new ImportedApiCustomerBll();


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadData();
        }
    }

    private void LoadData()
    {
        DataTable dt = apiCustomerBll.LoadNewCustomer();
        if (dt.Rows.Count>0)
        {
            loadGridView.DataSource = dt;
            loadGridView.DataBind();
        }
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
  
  
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();
            PopUp(customermasterid);
        }


        if (e.CommandName == "AddData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string customermasterid = loadGridView.DataKeys[rowindex][0].ToString();

            CustomerMaster apiCustomer = new CustomerMaster();

            apiCustomer = apiCustomerBll.ApiCustomerInformation(customermasterid);

            CustomerMaster aCustomerMaster = new CustomerMaster();

                aCustomerMaster.CustomerCode = apiCustomer.CustomerCode;
                aCustomerMaster.CustomerName = apiCustomer.CustomerName;

                aCustomerMaster.Address = apiCustomer.Address;
                aCustomerMaster.Addrees2 = apiCustomer.Addrees2;

                aCustomerMaster.CellNo = apiCustomer.CellNo;
                aCustomerMaster.City = apiCustomer.City;

                aCustomerMaster.ConPerson = apiCustomer.ConPerson;
                aCustomerMaster.ShippingCond = "N/A";

                aCustomerMaster.MarketCode = apiCustomer.MarketCode;
                aCustomerMaster.MarketName = apiCustomer.MarketName;

                aCustomerMaster.MIACode = apiCustomer.MIACode;
                aCustomerMaster.MiaName = apiCustomer.MiaName;

                aCustomerMaster.AreaCode = apiCustomer.AreaCode;

                aCustomerMaster.DisCode = apiCustomer.DisCode;
                aCustomerMaster.FEName = apiCustomer.FEName;

                aCustomerMaster.ComUnitCode = apiCustomer.ComUnitCode;
                aCustomerMaster.ComUnitName = apiCustomer.ComUnitName;

                aCustomerMaster.RegionCode = apiCustomer.RegionCode;
                aCustomerMaster.DZSMName = apiCustomer.DZSMName;

                aCustomerMaster.TermOfPayment = apiCustomer.TermOfPayment;
                aCustomerMaster.FixedCustomer = apiCustomer.FixedCustomer;
                aCustomerMaster.CategoryId = 1;


            if (Validation(aCustomerMaster))
            {
                if (apiCustomerBll.SaveApiCustomerInfo(aCustomerMaster))
                {
                    if (apiCustomerBll.UpdateApiCustomer(apiCustomer.CustomerMasterId))
                    {
                        showMessageBox("Customer added successfully!!!");
                        LoadData();

                    }
                    else
                    {
                        showMessageBox("Sorry! Customer doesn't added!!!");
                        LoadData();
                    }
                }
                else
                {
                    showMessageBox("Sorry! Customer already exist!!!");
                    LoadData();
                }
            }
            else
            {
                showMessageBox("Please Edit customer data !!!");
                LoadData();
            }

        }
       
    }

    private bool Validation(CustomerMaster aCustomerMaster)
    {
        if (aCustomerMaster.CustomerCode == "")
        {
            return false;
        }

        if (aCustomerMaster.CustomerName == "")
        {
            return false;
        }

        if (aCustomerMaster.Address == "")
        {
            return false;
        }

        if (aCustomerMaster.Addrees2 == "")
        {
            return false;
        }

        if (aCustomerMaster.CellNo == "")
        {
            return false;
        }

        if (aCustomerMaster.City == "")
        {
            return false;
        }

        if (aCustomerMaster.ConPerson == "")
        {
            return false;
        }

        if (aCustomerMaster.MIACode == "")
        {
            return false;
        }

        if (aCustomerMaster.MiaName == "")
        {
            return false;
        }

        if (aCustomerMaster.AreaCode == "")
        {
            return false;
        }

        if (aCustomerMaster.DisCode == "")
        {
            return false;
        }

        if (aCustomerMaster.FEName == "")
        {
            return false;
        }

        if (aCustomerMaster.ComUnitCode == "")
        {
            return false;
        }

        if (aCustomerMaster.ComUnitName == "")
        {
            return false;
        }

        if (aCustomerMaster.RegionCode == "")
        {
            return false;
        }

        if (aCustomerMaster.DZSMName == "")
        {
            return false;
        }

        if (aCustomerMaster.TermOfPayment == "")
        {
            return false;
        }

        if (aCustomerMaster.FixedCustomer.ToString() == "")
        {
            return false;
        }

        return true;
    }

    private void PopUp(string Id)
    {
        string url = "ImportedApiCustomer.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }


    protected void CustMasterReloadImageButton_Click(object sender, ImageClickEventArgs e)
    {
        LoadData();
    }
}