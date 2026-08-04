using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics.Eventing.Reader;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_WHStockAdjustmentEntry : System.Web.UI.Page
{
    WHStockAdjDAL adjDal=new WHStockAdjDAL();
    private CommonDataLoad _CmnLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {

        PermissionForShowBtn();
        if (!IsPostBack)
        {
            DropDownList();
            fromstoreDropDownList.SelectedIndex = 1;
        }
    }
    public void PermissionForShowBtn()
    {
        try
        {
            string filepath = Path.GetDirectoryName(Request.Path);
            filepath = filepath.TrimStart('\\');
            string text = Path.GetExtension(Request.Path);
            filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);
            DataTable dtuserpermission = _CmnLoad.GetPermissionForShowBtn(filepath);
            if (dtuserpermission.Rows.Count > 0)
            {

                btnSave.Visible = false;



            }

        }
        catch (Exception ex)
        {

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
    protected void viewLinkButton_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("WHStockAdjustmentView.aspx");
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)productGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)productGridView.Rows[i].Cells[0].FindControl("chkSelect");
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

    public void DropDownList()
    {
        adjDal.LoadProduct(productDropDownList);
        adjDal.LoadAdjustmentType(adjustmentTypeDropDownList);
        adjDal.LoadTostore(tostoreDropDownList1);
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        DataTable dtdata = adjDal.LoadProductFromWH(productDropDownList.SelectedValue);
        productGridView.DataSource = dtdata;
        productGridView.DataBind();
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    public bool ProductGridValudation()
    {
        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)productGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked)
            {
                TextBox reqQtyTextBox = (TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox");
                if (!string.IsNullOrEmpty(reqQtyTextBox.Text))
                {
                    return true;
                }
            }
        }
        return false;
    }
    public bool Validation()
    {
        if (transactionDateTextBox.Text ==string.Empty)
        {
            showMessageBox("Give Transaction Date !!!");
            return false;
        }
        if (fromstoreDropDownList.SelectedValue ==string.Empty)
        {
            showMessageBox("Give Whearhouse");
            return false;
        }
        if (remarksTextBox.Text==string.Empty)
        {
            showMessageBox("Give Remarks");
            return false;
        }
        if (ProductGridValudation()==false)
        {
            showMessageBox("Check or Give quantity of at least One Product");
            return false;

        }
        return true;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            WHStockAdjDAO adjDao = new WHStockAdjDAO();
            {
            adjDao.TransactionDate = Convert.ToDateTime(transactionDateTextBox.Text);
            adjDao.ActionStatus = "Approved";
            adjDao.FromStore = Convert.ToInt32(fromstoreDropDownList.SelectedValue);
            if(tostoreDropDownList1.SelectedValue!="")
            {
                adjDao.toStore = Convert.ToInt32(tostoreDropDownList1.SelectedValue);
            }
            else
            {
                adjDao.toStore = Convert.ToInt32(0);

            }
                adjDao.AdjustmentType = Convert.ToInt32(adjustmentTypeDropDownList.SelectedValue);
                adjDao.Remarks = remarksTextBox.Text;
                adjDao.EntryBy = Session["LoginName"].ToString();
                adjDao.EntryDate = DateTime.Now;
                adjDao.StockEffect = stockeffectTextBox.Text;
            }
            DataTable dttransno = adjDal.GetTransNo(transactionDateTextBox.Text);
            adjDao.TransactionNo = dttransno.Rows[0][0].ToString();
            int mainId = adjDal.SaveWHStockAdjMaster(adjDao);
            if (mainId>0)
            {
                for (int i = 0; i < productGridView.Rows.Count; i++)
                {
                    CheckBox ChkBoxRows = (CheckBox)productGridView.Rows[i].Cells[0].FindControl("chkSelect");
                    if (ChkBoxRows.Checked)
                    {
                        WhStockAdjDetailDAO adjDetailDao = new WhStockAdjDetailDAO()
                        {
                            Quantity =
                                Convert.ToDecimal(((TextBox) productGridView.Rows[i].FindControl("reqQtyTextBox")).Text),
                            ReceiveId = Convert.ToInt32(productGridView.DataKeys[i][0].ToString()),
                            WHStockAdjId = mainId,
                        };
                        int detailId = adjDal.SaveWHStockAdjDetail(adjDetailDao);
                        if (detailId>0)
                        {
                            string sign = "";
                            //if (adjDao.AdjustmentType==1)
                            //{
                            //    sign = "+";
                            //}
                            //else
                            {
                                sign = "-";
                            }
                            bool updatestock =
                                adjDal.UpdateCentralStoreStock(
                                    ((HiddenField)productGridView.Rows[i].FindControl("productidHiddenField")).Value,
                                    Convert.ToDecimal(
                                        ((TextBox) productGridView.Rows[i].FindControl("reqQtyTextBox")).Text),
                                    productGridView.DataKeys[i][0].ToString(),sign);

                        }
                    }
                }

                showMessageBox("Data Saved Successfully");
                Clear();
            }
        }
    }

    public void Clear()
    {
        productGridView.DataSource = null;
        productGridView.DataBind();
        transactionDateTextBox.Text = string.Empty;
        remarksTextBox.Text = string.Empty;
        adjustmentTypeDropDownList.SelectedIndex = 0;
        stockeffectTextBox.Text = string.Empty;
        fromstoreDropDownList.SelectedIndex = 0;
        productDropDownList.SelectedIndex = 0;


    }

    protected void reqQtyTextBox_OnTextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        int i = rowindex;
        decimal cstock = 0;
        cstock = Convert.ToDecimal(((TextBox)productGridView.Rows[i].FindControl("cStockTextBox")).Text);
        decimal qty = 0;
        qty =string.IsNullOrEmpty(((TextBox) productGridView.Rows[i].FindControl("reqQtyTextBox")).Text)?0:Convert.ToDecimal(((TextBox) productGridView.Rows[i].FindControl("reqQtyTextBox")).Text);

        if (cstock<qty)
        {
            showMessageBox("Quantity must be greater then Current Stock !!!");
            ((TextBox) productGridView.Rows[i].FindControl("reqQtyTextBox")).Text = string.Empty;
        }

    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("WHStockAdjustmentEntry.aspx");
    }
}