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

public partial class SInventory_UI_WhStockConditionFreeze : System.Web.UI.Page
{
    readonly WhStockConditionFreezeBll _aConditionFreezeBll = new WhStockConditionFreezeBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdownList();
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

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


    private void LoadDropdownList()
    {
        _aConditionFreezeBll.LoadWhInfoOnDropDownList(whDropDownList);
    }


    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
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
                var returnQuantityTextBox = (TextBox) loadGridView.Rows[i].Cells[11].FindControl("returnQtyTextBox");
                var conditionDropDownist = (DropDownList) loadGridView.Rows[i].Cells[5].FindControl("StockConditionDropDownList");

                if (checkBox.Checked)
                {
                    if (conditionDropDownist.SelectedValue == "")
                    {
                        ShowMessageBox("Please Select Stock Condition!!!");
                        return false;
                    }

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

    private void LoadCentrelStoreData()
    {
        DataTable aTable = _aConditionFreezeBll.LoadWhStockInformation();

        loadGridView.DataSource = aTable;
        loadGridView.DataBind();

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            _aConditionFreezeBll.LoadStockConditionBll(
                (DropDownList)loadGridView.Rows[i].Cells[5].FindControl("StockConditionDropDownList"), Session["UserId"].ToString());
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

    protected void submitButton0_OnClick(object sender, EventArgs e)
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

                    if (dataKey != null)
                    {
                        datakeyValue = Convert.ToInt32(dataKey[0].ToString());
                    }

                    var returnQuantityTextBox = (TextBox)loadGridView.Rows[i].Cells[11].FindControl("returnQtyTextBox");
                    var conditionDropDownist = (DropDownList)loadGridView.Rows[i].Cells[5].FindControl("StockConditionDropDownList");
                    var remarksTextBox = (TextBox)loadGridView.Rows[i].Cells[5].FindControl("remarksTextBox");

                    DataTable dt = _aConditionFreezeBll.LoadWHData(datakeyValue);


                    // WhStockConditionFreezeDao information

                    var aConditionFreezeDao = new WhStockConditionFreezeDao()
                    {
                        ReceiveId = Convert.ToInt32(datakeyValue),
                        FreezeQty = Convert.ToDecimal(returnQuantityTextBox.Text),
                        EntryBy = Session["LoginName"].ToString(),
                        EntryDate = DateTime.Now
                    };

                    int stockConditionFreezeId = 0;
                    stockConditionFreezeId = _aConditionFreezeBll.SaveforWh(aConditionFreezeDao);

                    // WhStoreFreezeDao information

                    if (stockConditionFreezeId > 0)
                    {
                        var aDcStoreFreezeDao = new WhStoreFreezeDao
                        {
                            ProductId = Convert.ToInt32((dt.Rows[0]["ProductId"].ToString().Trim())),
                            ProductName = (dt.Rows[0]["ProductName"].ToString().Trim()),
                            PackSize = (dt.Rows[0]["PackSize"].ToString().Trim()),
                            BatchNo = (dt.Rows[0]["BatchNo"].ToString().Trim()),
                            ExpDate = Convert.ToDateTime((dt.Rows[0]["ExpDate"].ToString().Trim())),
                            ReceiveDate = Convert.ToDateTime((dt.Rows[0]["ReceiveDate"].ToString().Trim())),
                            StockQty = Convert.ToDecimal(returnQuantityTextBox.Text),
                            TotalQuantity = Convert.ToDecimal(returnQuantityTextBox.Text),

                            DamageQty = 0,
                            StockRcvDate = DateTime.Now,

                            StockCondition = conditionDropDownist.SelectedItem.Text,
                            Remarks = remarksTextBox.Text,

                            ReceiveId = Convert.ToInt32(dt.Rows[0]["ReceiveId"].ToString().Trim()),
                            WhStockConditionFreezeID = stockConditionFreezeId
                        };

                        int freezeID = _aConditionFreezeBll.SaveWhStoreFreeze(aDcStoreFreezeDao);

                        if (freezeID > 0)
                        {
                            decimal dtstock = Convert.ToDecimal(dt.Rows[0]["Quantity"].ToString());

                            string a = returnQuantityTextBox.Text;
                            decimal stockQty = dtstock - Convert.ToDecimal(a.Trim());
                            _aConditionFreezeBll.UpdateCentralStore(stockQty, datakeyValue);           
                        }
                    }
                }

            }

            LoadCentrelStoreData();
            ShowMessageBox("Stock Freeze Successfully!!!");
        }
          
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


    protected void returnQtyTextBox_OnTextChanged(object sender, EventArgs e)
    {

        int rowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;
        int currentStock = Convert.ToInt32(loadGridView.Rows[rowIndex].Cells[7].Text);

        if (((TextBox)loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text != "")
        {
            if (IsInteger(((TextBox)loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text))
            {

                int returnQty = Convert.ToInt32(((TextBox) loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text);

                if (returnQty != 0)
                {
                    if (returnQty > currentStock)
                    {
                        ShowMessageBox("Return quantity must be equal or less than current stock quantity!!");
                        ((TextBox) loadGridView.Rows[rowIndex].Cells[5].FindControl("returnQtyTextBox")).Text =
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
            LoadCentrelStoreData();
        }
        else
        {
            ShowMessageBox("Please select an Warehouse!!!");
        }
    }
}