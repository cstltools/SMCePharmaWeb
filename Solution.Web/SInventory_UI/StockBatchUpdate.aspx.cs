using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockConditionFreeze : System.Web.UI.Page
{
    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
    StockBatchUpdateDal aDal = new StockBatchUpdateDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
           
        }
    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.LoadmanufacturerName(manufacturerDropDownList);
        aOtherStockActionBLL.DCLoad(dcDropDownList1, Session["UserId"].ToString());
        manufacturerDropDownList.SelectedIndex = 1;
    }

    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (dcDropDownList1.SelectedValue != "")
        {
            DataTable aTable = aDal.LoadStockByDcId(Convert.ToInt32(dcDropDownList1.SelectedValue));

            if (aTable.Rows.Count > 0)
            {
                loadGridView.DataSource = aTable;
                loadGridView.DataBind();
            }
            else
            {
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
        }
        
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void submitButton0_OnClick(object sender, EventArgs e)
    {
        if (Validation())
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {

                var checkBox = (CheckBox) loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

                if (checkBox.Checked)
                {
                    int datakey = Convert.ToInt32(loadGridView.DataKeys[i][0].ToString());
                    var batch = ((TextBox)loadGridView.Rows[i].Cells[3].FindControl("batchTextBox")).Text;
                    var mfgdate = ((TextBox)loadGridView.Rows[i].Cells[4].FindControl("mfgDateTextBox")).Text;
                    var expDate = ((TextBox)loadGridView.Rows[i].Cells[5].FindControl("expDateDateTextBox")).Text;

                    TextBox txtStockQty = ((TextBox)loadGridView.Rows[i].Cells[5].FindControl("txtStockQty"));
                    decimal sQ = 0;
                    try
                    {
                        sQ = Convert.ToDecimal(txtStockQty.Text);
                    }
                    catch
                    {

                    }

                    aDal.UpdateStockBatch(datakey, batch, mfgdate, expDate, Session["LoginName"].ToString(), sQ);
                }
            }

            dcDropDownList1_SelectedIndexChanged(null,null);
            ShowMessageBox("Stock Batch Updated Successfully!!!");
        }
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
                var batch = (TextBox)loadGridView.Rows[i].Cells[3].FindControl("batchTextBox");
                var mfgdate = (TextBox)loadGridView.Rows[i].Cells[4].FindControl("mfgDateTextBox");
                var expDate = (TextBox)loadGridView.Rows[i].Cells[5].FindControl("expDateDateTextBox");

                if (checkBox.Checked)
                {

                    if (batch.Text == "")
                    {
                        ShowMessageBox("Please Select batch no !!!");
                        return false;
                    }

                    if (mfgdate.Text == "")
                    {
                        ShowMessageBox("Please Select MFG Date !!!");
                        return false;
                    }

                    if (expDate.Text == "")
                    {
                        ShowMessageBox("Please select EXP Date !!!");
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

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("StockBatchUpdate.aspx");
    }
}