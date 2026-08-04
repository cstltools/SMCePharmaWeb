using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SubDepot_UI_SubDeportStockFreez : System.Web.UI.Page
{
    private DataTable aDataTable = new DataTable();
    private OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
        }
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
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

    public void LoadDropDown()
    {
        aOtherStockActionBLL.LoadmanufacturerName(manufacturerDropDownList);
        aOtherStockActionBLL.DCLoad(dcDropDownList, Session["UserId"].ToString());
        manufacturerDropDownList.SelectedIndex = 1;
    }
    private void Load()
    {
        aDataTable = aOtherStockActionBLL.SubDeportLoadData(Convert.ToInt32(subdeportDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue));
        if (aDataTable.Rows.Count>0)
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
       
    }
    private void Load2()
    {
        aDataTable = aOtherStockActionBLL.SubDeportLoadData(Convert.ToInt32(subdeportDropDownList1.SelectedValue), Convert.ToInt32(manufacturerDropDownList.SelectedValue));
        {
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();
        }

        labelGridView.DataSource = null;
        labelGridView.DataBind();
       

    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        Load();
    }
    protected void refreshButton_Click(object sender, EventArgs e)
    {

    }


    protected void addButton_Click(object sender, EventArgs e)
    {

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DCStoreFreezeId");
        aDataTable.Columns.Add("DCStoreId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("Amount");
        aDataTable.Columns.Add("StockCondition");
        aDataTable.Columns.Add("ReturnQty");
        aDataTable.Columns.Add("Remarks");

        DataRow dataRow = null;

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked && ((TextBox)loadGridView.Rows[i].Cells[8].FindControl("returnQtyTextBox")).Text.Trim() != "")
            {
                if (HasDCStoreId(Convert.ToInt32(loadGridView.DataKeys[i][0].ToString())))
                {
                    dataRow = aDataTable.NewRow();

                    dataRow["DCStoreFreezeId"] = loadGridView.DataKeys[i][0].ToString();
                    dataRow["DCStoreId"] = loadGridView.DataKeys[i][1].ToString();
                    dataRow["ProductCode"] = loadGridView.Rows[i].Cells[1].Text;
                    dataRow["ProductName"] = loadGridView.Rows[i].Cells[2].Text;
                    dataRow["BatchNo"] = loadGridView.Rows[i].Cells[3].Text;
                    dataRow["ExpDate"] = loadGridView.Rows[i].Cells[4].Text;
                    dataRow["StockQty"] = loadGridView.Rows[i].Cells[5].Text;
                    dataRow["Amount"] = loadGridView.Rows[i].Cells[6].Text;
                    dataRow["StockCondition"] = loadGridView.Rows[i].Cells[7].Text;
                    dataRow["ReturnQty"] = ((TextBox)loadGridView.Rows[i].Cells[8].FindControl("returnQtyTextBox")).Text.Trim();
                    dataRow["Remarks"] = loadGridView.Rows[i].Cells[9].Text;

                    aDataTable.Rows.Add(dataRow);
                }
            }
        }
        for (int i = 0; i < labelGridView.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();
            dataRow["DCStoreFreezeId"] = labelGridView.DataKeys[i][0].ToString();
            dataRow["DCStoreId"] = labelGridView.DataKeys[i][1].ToString();
            dataRow["ProductCode"] = labelGridView.Rows[i].Cells[1].Text;
            dataRow["ProductName"] = labelGridView.Rows[i].Cells[2].Text;
            dataRow["BatchNo"] = labelGridView.Rows[i].Cells[3].Text;
            dataRow["ExpDate"] = labelGridView.Rows[i].Cells[4].Text;
            dataRow["StockQty"] = labelGridView.Rows[i].Cells[5].Text;
            dataRow["Amount"] = labelGridView.Rows[i].Cells[6].Text;
            dataRow["StockCondition"] = labelGridView.Rows[i].Cells[7].Text;
            dataRow["ReturnQty"] = labelGridView.Rows[i].Cells[8].Text;
            dataRow["Remarks"] = labelGridView.Rows[i].Cells[9].Text;

            aDataTable.Rows.Add(dataRow);
        }

        labelGridView.DataSource = aDataTable;
        labelGridView.DataBind();
    }


    protected void DeleteImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DCStoreFreezeId");
        aDataTable.Columns.Add("DCStoreId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("StockQty");
        aDataTable.Columns.Add("Amount");
        aDataTable.Columns.Add("StockCondition");
        aDataTable.Columns.Add("ReturnQty");
        aDataTable.Columns.Add("Remarks");

        DataRow dataRow = null;
        for (int i = 0; i < labelGridView.Rows.Count; i++)
        {
            if (i != rowindex)
            {

                dataRow = aDataTable.NewRow();
                dataRow["DCStoreFreezeId"] = labelGridView.DataKeys[i][0].ToString();
                dataRow["DCStoreId"] = labelGridView.DataKeys[i][1].ToString();
                dataRow["ProductCode"] = labelGridView.Rows[i].Cells[1].Text;
                dataRow["ProductName"] = labelGridView.Rows[i].Cells[2].Text;
                dataRow["BatchNo"] = labelGridView.Rows[i].Cells[3].Text;
                dataRow["ExpDate"] = labelGridView.Rows[i].Cells[4].Text;
                dataRow["StockQty"] = labelGridView.Rows[i].Cells[5].Text;
                dataRow["Amount"] = labelGridView.Rows[i].Cells[6].Text;
                dataRow["StockCondition"] = labelGridView.Rows[i].Cells[7].Text;
                dataRow["ReturnQty"] = labelGridView.Rows[i].Cells[8].Text;
                dataRow["Remarks"] = labelGridView.Rows[i].Cells[9].Text;

                aDataTable.Rows.Add(dataRow);
            }

        }

        labelGridView.DataSource = aDataTable;
        labelGridView.DataBind();


        ReSetGridStatus();

    }

    public bool HasDCStoreId(int dcstoreId)
    {
        for (int i = 0; i < labelGridView.Rows.Count; i++)
        {
            if (Convert.ToInt32(labelGridView.DataKeys[i][0].ToString()) == dcstoreId)
            {
                return false;
                break;

            }
        }
        return true;
    }


    private void ReSetGridStatus()
    {

        for (int j = 0; j < loadGridView.Rows.Count; j++)
        {
            string lDCStoreFreezeId = loadGridView.DataKeys[j][0].ToString();
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[j].Cells[0].FindControl("chkSelect");

            TextBox qty = ((TextBox)loadGridView.Rows[j].Cells[8].FindControl("returnQtyTextBox"));

            int count = 0;

            for (int i = 0; i < labelGridView.Rows.Count; i++)
            {
                string DCStoreFreezeId = labelGridView.DataKeys[i][0].ToString();
                if (lDCStoreFreezeId == DCStoreFreezeId)
                {
                    count++;
                }
            }

            if (count > 0)
            {
                ChkBoxRows.Checked = true;
            }
            else
            {
                ChkBoxRows.Checked = false;
                qty.Text = "";
            }
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
        if (e.CommandName == "ViewData")
        {
            GridViewRow row = (GridViewRow)(((Control)e.CommandSource).NamingContainer);
            int rowindex = Convert.ToInt32(e.CommandArgument);
            int RowIndex2 = row.RowIndex;
            int bigStore = Convert.ToInt32(loadGridView.Rows[rowindex].Cells[5].Text);

            if (loadGridView.Rows[rowindex].Cells[7].Text != "Restricted" && Session["LoginName"].ToString() != "21900")
            {
            if ((((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text) != "" && (((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text) != "0")
            {
                if (bigStore < Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text))
                {
                    showMessageBox("Return Quantity must be Less then Stock Qty");
                }
                if (bigStore >= Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text))
                {
                    int DCStoreFreezeId = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());
                    int DCStoreId = Convert.ToInt32(loadGridView.DataKeys[rowindex][1].ToString());

                    //Store Freeze  Update
                    DataTable dt = new DataTable();
                    dt = aOtherStockActionBLL.LoadStockData(DCStoreFreezeId);
                    decimal dtstock = Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString());
                    string a = ((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text;

                    if (Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) == 0 ||
                        Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) > 0)
                    {
                        decimal StockQty = dtstock - Convert.ToDecimal(a.Trim());
                        aOtherStockActionBLL.UpdateDCStoreFreezeStock(StockQty, DCStoreFreezeId);

                        //DC Store Update
                        DataTable dt2 = new DataTable();
                        dt2 = aOtherStockActionBLL.LoadStockDCStockData(DCStoreId);
                        decimal dtdcstock = Convert.ToDecimal(dt2.Rows[0]["StockQty"].ToString());
                        string B =
                            ((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text;
                        decimal DCStockQty = dtdcstock + Convert.ToDecimal(B.Trim());
                        aOtherStockActionBLL.UpdateDCStock(DCStockQty, DCStoreId);
                        Load2();
                        showMessageBox("Stock Return Successfully !!");
                    }
                }
            }
            else
            {
                showMessageBox("Insert Return Quantity !!");
            }
            }
            if (Session["LoginName"].ToString() == "21900")
            {
                if ((((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text) != "" && (((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text) != "0")
                {
                    if (bigStore < Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text))
                    {
                        showMessageBox("Return Quantity must be Less then Stock Qty");
                    }
                    if (bigStore >= Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text))
                    {
                        int DCStoreFreezeId = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());
                        int DCStoreId = Convert.ToInt32(loadGridView.DataKeys[rowindex][1].ToString());

                        //Store Freeze  Update
                        DataTable dt = new DataTable();
                        dt = aOtherStockActionBLL.LoadStockData(DCStoreFreezeId);
                        decimal dtstock = Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString());
                        string a = ((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text;

                        if (Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) == 0 || Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) > 0)
                        {
                            decimal StockQty = dtstock - Convert.ToDecimal(a.Trim());
                            aOtherStockActionBLL.UpdateDCStoreFreezeStock(StockQty, DCStoreFreezeId);

                            //DC Store Update
                            DataTable dt2 = new DataTable();
                            dt2 = aOtherStockActionBLL.LoadStockDCStockData(DCStoreId);
                            decimal dtdcstock = Convert.ToDecimal(dt2.Rows[0]["StockQty"].ToString());
                            string B = ((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text;
                            decimal DCStockQty = dtdcstock + Convert.ToDecimal(B.Trim());
                            aOtherStockActionBLL.UpdateDCStock(DCStockQty, DCStoreId);
                            Load2();
                            showMessageBox("Stock Return Successfully !!");
                        }
                      
                    }
                }
                else
                {
                    showMessageBox("Insert Return Quantity !!");
                }
            }
        }
    }
    protected void dcDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        RequisitionBLL aRequisitionBll = new RequisitionBLL();
        aRequisitionBll.SubdeportLoad(subdeportDropDownList1, dcDropDownList.SelectedValue);

        loadGridView.DataSource = null;
        loadGridView.DataBind();

    }
    protected void manufacturerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }

    protected void submitButton0_OnClick(object sender, EventArgs e)
    {
        for (int i = 0; i < labelGridView.Rows.Count; i++)
        {
            
            int rowindex = Convert.ToInt32(i);
            int RowIndex2 = i;
            int bigStore = Convert.ToInt32(labelGridView.Rows[rowindex].Cells[5].Text);

            //CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            //if (ChkBoxRows.Checked)
            //{



                if (loadGridView.Rows[rowindex].Cells[7].Text != "Restricted" &&
                    Session["LoginName"].ToString() != "21900")
                {
                    if (labelGridView.Rows[i].Cells[8].Text != "" &&
                        (labelGridView.Rows[i].Cells[8].Text != "0"))
                    {
                        if (bigStore <
                            Convert.ToDecimal(labelGridView.Rows[i].Cells[8].Text))
                        {
                            showMessageBox("Return Quantity must be Less then Stock Qty");
                        }
                        if (bigStore >=
                            Convert.ToDecimal(
                                labelGridView.Rows[i].Cells[8].Text))
                        {
                            int DCStoreFreezeId = Convert.ToInt32(labelGridView.DataKeys[rowindex][0].ToString());
                            int DCStoreId = Convert.ToInt32(labelGridView.DataKeys[rowindex][1].ToString());

                            //Store Freeze  Update
                            DataTable dt = new DataTable();
                            dt = aOtherStockActionBLL.LoadSubdeportStockData(DCStoreFreezeId);
                            decimal dtstock = Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString());
                            string a = labelGridView.Rows[i].Cells[8].Text;


                            if (Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) == 0 ||
                                Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) > 0)
                            {
                                decimal StockQty = dtstock - Convert.ToDecimal(a.Trim());
                                aOtherStockActionBLL.SubdeportUpdateDCStoreFreezeStock(StockQty, DCStoreFreezeId);

                                //DC Store Update
                                DataTable dt2 = new DataTable();
                                dt2 = aOtherStockActionBLL.SubdeportLoadStockDCStockData(DCStoreId);
                                decimal dtdcstock = Convert.ToDecimal(dt2.Rows[0]["StockQty"].ToString());
                                string B = labelGridView.Rows[i].Cells[8].Text;
                                decimal DCStockQty = dtdcstock + Convert.ToDecimal(B.Trim());
                                aOtherStockActionBLL.SubdeportUpdateDCStock(DCStockQty, DCStoreId);

                                showMessageBox("Stock Return Successfully !!");
                            }
                        }
                    }
                    else
                    {
                        showMessageBox("Insert Return Quantity !!");
                    }
                }
                if (Session["LoginName"].ToString() == "21900")
                {
                    if (labelGridView.Rows[i].Cells[8].Text != "" &&
                        (labelGridView.Rows[i].Cells[8].Text != "0"))
                    {
                        if (bigStore <
                            Convert.ToDecimal(labelGridView.Rows[i].Cells[8].Text))
                        {
                            showMessageBox("Return Quantity must be Less then Stock Qty");
                        }
                        if (bigStore >=
                            Convert.ToDecimal(
                                labelGridView.Rows[i].Cells[8].Text))
                        {
                            int DCStoreFreezeId = Convert.ToInt32(labelGridView.DataKeys[rowindex][0].ToString());
                            int DCStoreId = Convert.ToInt32(labelGridView.DataKeys[rowindex][1].ToString());

                            //Store Freeze  Update
                            DataTable dt = new DataTable();
                            dt = aOtherStockActionBLL.LoadSubdeportStockData(DCStoreFreezeId);
                            decimal dtstock = Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString());
                            string a =
                                labelGridView.Rows[i].Cells[8].Text;

                            if (Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) == 0 ||
                                Convert.ToDecimal(dt.Rows[0]["StockQty"].ToString()) > 0)
                            {
                                decimal StockQty = dtstock - Convert.ToDecimal(a.Trim());
                                aOtherStockActionBLL.SubdeportUpdateDCStoreFreezeStock(StockQty, DCStoreFreezeId);

                                //DC Store Update
                                DataTable dt2 = new DataTable();
                                dt2 = aOtherStockActionBLL.SubdeportLoadStockDCStockData(DCStoreId);
                                decimal dtdcstock = Convert.ToDecimal(dt2.Rows[0]["StockQty"].ToString());
                                string B = labelGridView.Rows[i].Cells[8].Text;
                                decimal DCStockQty = dtdcstock + Convert.ToDecimal(B.Trim());
                                aOtherStockActionBLL.SubdeportUpdateDCStock(DCStockQty, DCStoreId);

                                showMessageBox("Stock Return Successfully !!");
                            }
                        }
                    }
                    else
                    {
                        showMessageBox("Insert Return Quantity !!");
                    }
                }
            //}
        }
        Load2();
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubDeportStockFreez.aspx");
    }
}