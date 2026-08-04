using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_WhFreezeStockRelease : System.Web.UI.Page
{
    WhFreezeStockReleaseBll aFreezeStockReleaseBll = new WhFreezeStockReleaseBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdownList();
        }
    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("WhFreezeStockRelease.aspx");
    }
    private void LoadDropdownList()
    {
        aFreezeStockReleaseBll.LoadWhInfoOnDropDownList(whDropDownList);
    }

    private void LoadWhFreezeStockInfo()
    {
        DataTable aDataTable = aFreezeStockReleaseBll.LoadWhFreezeStockData();
        
        if (aDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
            ShowMessageBox("No Data Found!!");
        }
    }
    private void LoadWhFreezeStockInfo2()
    {
        DataTable aDataTable = aFreezeStockReleaseBll.LoadWhFreezeStockData();

        if (aDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

            if (chkBoxHeader.Checked)
            {
                chkBoxRows.Checked = true;
            }
            else
            {
                chkBoxRows.Checked = false;
            }
        }
    }

    private bool CheckRowIsSelectedOrNot(int i)
    {
        var checkBox = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

        if (checkBox.Checked)
        {
            return true;
        }

        return false;
    }


    private bool Validation()
    {
        int rowCount = 0;

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var checkBox = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

            if (checkBox.Checked)
            {
                rowCount = rowCount + 1;
            }

            if (rowCount > 0)
            {
                break;
            }
        }

        if (rowCount > 0)
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                var checkBox = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
                var returnQuantityTextBox = (TextBox)loadGridView.Rows[i].Cells[8].FindControl("returnQtyTextBox");
                
                if (checkBox.Checked)
                {
                    if (returnQuantityTextBox.Text == "")
                    {
                        ShowMessageBox("Please select a return quantity!!!");
                        return false;
                    }
                }
            }
        }
        else
        {
            ShowMessageBox("You must check at least one row!!!");
            return false;
        }


        return true;
    }


    protected void submitButton_OnClick(object sender, EventArgs e)
    {
        if (Validation())
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                if (CheckRowIsSelectedOrNot(i))
                {
                    int rowindex = Convert.ToInt32(i);
                    var dataKey = loadGridView.DataKeys[rowindex];

                    int datakeyValue = 0;
                    int receveId = 0;

                    if (dataKey != null)
                    {
                        datakeyValue = Convert.ToInt32(dataKey[0].ToString());
                        receveId = Convert.ToInt32(dataKey[1].ToString());
                    }

                    var returnQuantityTextBox = (TextBox)loadGridView.Rows[i].Cells[8].FindControl("returnQtyTextBox");
                    DataTable dt = aFreezeStockReleaseBll.LoadStockReleaseData(datakeyValue);

                    // WhStoreFreezeDao information

                    decimal dtstock = Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString());

                    var aConditionFreezeDao = new WhStoreFreezeDao()
                    {
                        WhStoreFreezeId = datakeyValue,
                        StockQty = dtstock - Convert.ToDecimal(returnQuantityTextBox.Text)

                    };
  
                    bool updateStatus = aFreezeStockReleaseBll.UpdateWhStoreFreezeInfo(aConditionFreezeDao);

                    // Central Store information update

                    if (updateStatus)
                    {
                        DataTable centralStoreDataTable = aFreezeStockReleaseBll.LoadCentralStoreData(receveId);

                        if (centralStoreDataTable.Rows.Count > 0)
                        {
                            decimal quantity = Convert.ToDecimal(centralStoreDataTable.Rows[0]["Quantity"].ToString()) + Convert.ToDecimal(returnQuantityTextBox.Text);
                            bool status = aFreezeStockReleaseBll.UpdateCentalStoreInfo(quantity, receveId);

                        }
                    }
                }

            }

            LoadWhFreezeStockInfo2();
            ShowMessageBox("Freeze Stock Release Successfully!!!");
        }
    }


    protected void returnQtyTextBox_OnTextChanged(object sender, EventArgs e)
    {

        int rowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;
        int currentStock = Convert.ToInt32(loadGridView.Rows[rowIndex].Cells[5].Text);

        if (((TextBox)loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text != "")
        {
            if (IsInteger(((TextBox)loadGridView.Rows[rowIndex].Cells[8].FindControl("returnQtyTextBox")).Text))
            {

                int returnQty = Convert.ToInt32(((TextBox)loadGridView.Rows[rowIndex].Cells[8].FindControl("returnQtyTextBox")).Text);

                if (returnQty != 0)
                {
                    if (returnQty > currentStock)
                    {
                        ShowMessageBox("Return quantity must be equal or less than current stock quantity!!");
                        ((TextBox)loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text =
                            string.Empty;
                    }
                }
                else
                {
                    ShowMessageBox("Return quantity must be greater than zero(0) !!");
                    ((TextBox)loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text =
                        string.Empty;
                }

            }

            else
            {
                ShowMessageBox("Please select a valid value for return quantity!!");
                ((TextBox)loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text = string.Empty;
            }
        }
    }

    readonly Regex _regex = new Regex(@"[0-9]");

    private bool IsInteger(string str)
    {
        try
        {
            if (String.IsNullOrWhiteSpace(str))
            {
                return false;
            }
            if (!_regex.IsMatch(str))
            {
                return false;
            }

            return true;

        }
        catch (Exception ex)
        {
            ShowMessageBox(ex.Message);
        }

        return false;
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        if (whDropDownList.SelectedValue != "")
        {
            LoadWhFreezeStockInfo();
        }
        else
        {
            ShowMessageBox("Please select an Warehouse!!!");
        }
    }
}