using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_StockConditionFreeze : System.Web.UI.Page
{
    StockConditionFreezeBLL aStockConditionFreezeBll = new StockConditionFreezeBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
            if (Session["CentralWareHouse"] != null && Session["CentralWareHouse"].ToString() == "True")
            {
                centalWHCheckBox.Enabled = true;
            }
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

    }
    protected void myListDropDown_Change(object sender, EventArgs e)
    {
        //int rowIndex = ((GridViewRow)(((DropDownList)sender).Parent.Parent)).RowIndex;
        //if (Session["LoginName"].ToString() == "admin1")
        //{
            
        //}
        //else
        //{
        //    DropDownList ddlPercent = (DropDownList)loadGridView.Rows[rowIndex].Cells[1].FindControl("StockConditionDropDownList");
        //    string Percent = (ddlPercent.SelectedItem.Text);
        //    if (Percent == "Restricted")
        //    {
        //        ((DropDownList)loadGridView.Rows[rowIndex].Cells[0].FindControl("StockConditionDropDownList")).SelectedValue = string.Empty;
        //    }
        //}
    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.LoadmanufacturerName(manufacturerDropDownList);
        aOtherStockActionBLL.DCLoad(dcDropDownList1, Session["UserId"].ToString());
        manufacturerDropDownList.SelectedIndex = 1;
    }
    protected void centalWHCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        if (centalWHCheckBox.Checked == true)
        {
            DIVCH.Visible = true;
            DIVDC.Visible = false;
            //whDropDownList.SelectedValue = "";
            RequisitionBLL aRequisitionBll = new RequisitionBLL();
            aRequisitionBll.WareHouseLoad(whDropDownList);
            
        }
        if (centalWHCheckBox.Checked == false)
        {
            DIVCH.Visible = false;
            DIVDC.Visible = true;
            dcDropDownList1.SelectedValue = "";
        }
    }
    protected void whDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }

    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }
    protected void manufacturerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (manufacturerDropDownList.SelectedValue != "" && whDropDownList.SelectedValue != "" && centalWHCheckBox.Checked)
        {
            LoadWHData();
        }
        if (manufacturerDropDownList.SelectedValue != "" && dcDropDownList1.SelectedValue != "" && centalWHCheckBox.Checked==false)
        {
            LoadDCStoreData();
        }
    }

    private void LoadDCStoreData()
    {
        string User = Session["UserId"].ToString();
        DataTable dt2 = new DataTable();
        dt2 = aStockConditionFreezeBll.LoadStockDCData(Convert.ToInt32(dcDropDownList1.SelectedValue));
        loadGridView.DataSource = dt2;
        loadGridView.DataBind();
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            aStockConditionFreezeBll.LoadStockConditionBll(
                (DropDownList)loadGridView.Rows[i].Cells[5].FindControl("StockConditionDropDownList"), Session["UserId"].ToString());
        }
    }

    private void LoadWHData()
    {
        DataTable dt2 = new DataTable();
        dt2 = aStockConditionFreezeBll.LoadWHData();
        loadGridView.DataSource = dt2;
        loadGridView.DataBind();
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            aStockConditionFreezeBll.LoadStockConditionBll(
                ((DropDownList)loadGridView.Rows[i].Cells[5].FindControl("StockConditionDropDownList")), Session["UserId"].ToString());
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
            int bigStore = Convert.ToInt32(loadGridView.Rows[rowindex].Cells[7].Text);

            if ((((TextBox)loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text) != "" && (((TextBox)loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text) != "0" && ((DropDownList)loadGridView.Rows[RowIndex2].Cells[5].FindControl("StockConditionDropDownList")).SelectedIndex != 0)
            {
                if (bigStore < Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text))
                {
                    showMessageBox(" Quantity must be Less then Stock Qty");
                }
                if (bigStore >= Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[7].FindControl("returnQtyTextBox")).Text))
                {
                    int Datakey = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());

                    //C WH-----------------------------------------------------------------------
                    
                    if (manufacturerDropDownList.SelectedValue != "" && whDropDownList.SelectedValue != "" && centalWHCheckBox.Checked)
                    {
                        DataTable dt = new DataTable();
                        dt = aStockConditionFreezeBll.LoadWHData(Datakey);

                        //insert
                        StockConditionFreezeDAO aConditionFreezeDao = new StockConditionFreezeDAO()
                        {
                            ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                            ReceiveId = Convert.ToInt32(whDropDownList.SelectedValue),
                           //DCStoreId = Convert.ToInt32(dcDropDownList1.SelectedValue),
                            FreezeQty = Convert.ToDecimal((((TextBox)loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text)),
                            EntryBy = Session["LoginName"].ToString(),
                            EntryDate = DateTime.Now
                        };
                        int StockConditionFreezeID = 0;
                        StockConditionFreezeID = aStockConditionFreezeBll.SaveforWH(aConditionFreezeDao);
                        if (StockConditionFreezeID > 0)
                        {
                            DCStoreFreezeDAO aDcStoreFreezeDao = new DCStoreFreezeDAO();

                           // aDcStoreFreezeDao.DCStoreId = 0;
                           // aDcStoreFreezeDao.InvoiceDetailId = 0;
                            aDcStoreFreezeDao.StorageLocation = (dt.Rows[0]["StorageLocation"].ToString().Trim());
                            aDcStoreFreezeDao.ProductCode = (dt.Rows[0]["ProductCode"].ToString().Trim());
                            aDcStoreFreezeDao.ProductName = (dt.Rows[0]["ProductName"].ToString().Trim());
                            aDcStoreFreezeDao.PackSize = (dt.Rows[0]["PackSize"].ToString().Trim());
                            aDcStoreFreezeDao.BatchNo = (dt.Rows[0]["BatchNo"].ToString().Trim());
                            aDcStoreFreezeDao.ExpDate = Convert.ToDateTime((dt.Rows[0]["ExpDate"].ToString().Trim()));
                            aDcStoreFreezeDao.ReceiveDate = Convert.ToDateTime((dt.Rows[0]["ReceiveDate"].ToString().Trim()));
                            aDcStoreFreezeDao.ChalanNo = (dt.Rows[0]["ChalanNo"].ToString().Trim());
                            aDcStoreFreezeDao.ChalanDate = Convert.ToDateTime((dt.Rows[0]["ChalanDate"].ToString().Trim()));
                           // aDcStoreFreezeDao.ComUnitId =  0;
                            aDcStoreFreezeDao.StockQty = Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text);
                            aDcStoreFreezeDao.TotalQuantity = Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text);
                            aDcStoreFreezeDao.DamageQty =  0;
                            aDcStoreFreezeDao.StockRcvDate = DateTime.Now;
                           // aDcStoreFreezeDao.ReqId =  0;
                           // aDcStoreFreezeDao.ReqChildId = 0;
                            //aDcStoreFreezeDao.StockInTransfarId = 0;
                            aDcStoreFreezeDao.StockCondition = ((DropDownList)loadGridView.Rows[RowIndex2].Cells[5].FindControl("StockConditionDropDownList")).SelectedItem.Text;
                            aDcStoreFreezeDao.remarks = (((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("remarksTextBox")).Text);
                            
                            aDcStoreFreezeDao.ReceiveId = Convert.ToInt32(dt.Rows[0]["ReceiveId"].ToString().Trim());
                            aDcStoreFreezeDao.StockConditionFreezeID = StockConditionFreezeID;

                           int FreezeID = aStockConditionFreezeBll.SaveDCStoreFreeze(aDcStoreFreezeDao);
                           if (FreezeID>0)
                            {
                                decimal dtstock = Convert.ToDecimal(dt.Rows[0]["Quantity"].ToString());
                                string a =
                                    ((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text;
                                decimal StockQty = dtstock - Convert.ToDecimal(a.Trim());
                                aStockConditionFreezeBll.UpdateCentralStore(StockQty, Datakey);
                                
                            }
                        }
                    }

                    //DC Store --------------------------------------------------------------------------------------
                    if (manufacturerDropDownList.SelectedValue != "" && dcDropDownList1.SelectedValue != "" && centalWHCheckBox.Checked==false)
                    {
                        //insert
                        StockConditionFreezeDAO aConditionFreezeDao = new StockConditionFreezeDAO()
                        {
                            ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                           // ReceiveId = Convert.ToInt32(whDropDownList.SelectedValue),
                            DCStoreId = Convert.ToInt32(dcDropDownList1.SelectedValue),
                            FreezeQty = Convert.ToDecimal((((TextBox)loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text)),
                            EntryBy = Session["LoginName"].ToString(),
                            EntryDate = DateTime.Now

                        };
                        int StockConditionFreezeID = 0;
                        StockConditionFreezeID = aStockConditionFreezeBll.SaveforDC(aConditionFreezeDao);
                        if (StockConditionFreezeID > 0)
                        {
                            DataTable dt2 = new DataTable();
                            dt2 = aStockConditionFreezeBll.LoadStockStockQtyDCData(Datakey);
                            DCStoreFreezeDAO aDcStoreFreezeDao = new DCStoreFreezeDAO();
                            aDcStoreFreezeDao.DCStoreId = Convert.ToInt32((dt2.Rows[0]["DCStoreId"].ToString().Trim()));
                            // aDcStoreFreezeDao.InvoiceDetailId = 0;
                             aDcStoreFreezeDao.StorageLocation = (dt2.Rows[0]["StorageLocation"].ToString().Trim());
                             aDcStoreFreezeDao.ProductCode = (dt2.Rows[0]["ProductCode"].ToString().Trim());
                             aDcStoreFreezeDao.ProductName = (dt2.Rows[0]["ProductName"].ToString().Trim());
                             aDcStoreFreezeDao.PackSize = (dt2.Rows[0]["PackSize"].ToString().Trim());
                             aDcStoreFreezeDao.BatchNo = (dt2.Rows[0]["BatchNo"].ToString().Trim());
                             aDcStoreFreezeDao.TotalQuantity = Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text);
                             aDcStoreFreezeDao.ExpDate = Convert.ToDateTime((dt2.Rows[0]["ExpDate"].ToString().Trim()));
                             aDcStoreFreezeDao.ReceiveDate = Convert.ToDateTime((dt2.Rows[0]["ReceiveDate"].ToString().Trim()));
                             aDcStoreFreezeDao.ChalanNo = (dt2.Rows[0]["ChalanNo"].ToString().Trim());
                             aDcStoreFreezeDao.ChalanDate = Convert.ToDateTime((dt2.Rows[0]["ChalanDate"].ToString().Trim()));
                             aDcStoreFreezeDao.ComUnitId = Convert.ToInt32((dt2.Rows[0]["ComUnitId"].ToString().Trim()));
                            aDcStoreFreezeDao.StockQty = Convert.ToDecimal(((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox")).Text);
                            
                            aDcStoreFreezeDao.DamageQty = 0;
                            aDcStoreFreezeDao.StockRcvDate = DateTime.Now;
                            // aDcStoreFreezeDao.ReqId =  0;
                            // aDcStoreFreezeDao.ReqChildId = 0;
                            //aDcStoreFreezeDao.StockInTransfarId = 0;
                            aDcStoreFreezeDao.StockCondition = ((DropDownList)loadGridView.Rows[RowIndex2].Cells[5].FindControl("StockConditionDropDownList")).SelectedItem.Text;
                            aDcStoreFreezeDao.remarks = (((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("remarksTextBox")).Text);
                      
                            //  aDcStoreFreezeDao.ReceiveId = Convert.ToInt32(dt2.Rows[0]["Quantity"].ToString().Trim());
                            aDcStoreFreezeDao.StockConditionFreezeID = StockConditionFreezeID;

                            int DCID = aStockConditionFreezeBll.SaveDCStoreFreeze2(aDcStoreFreezeDao);

                            if (DCID > 0)
                            {

                                decimal dtdcstock = Convert.ToDecimal(dt2.Rows[0]["StockQty"].ToString());
                                string B =
                                    ((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                        .Text;
                                decimal DCStockQty = dtdcstock - Convert.ToDecimal(B.Trim());
                                aStockConditionFreezeBll.UpdateDCStore(DCStockQty, Datakey);
                                LoadDCStoreData();
                            }
                        }

                      
                    }
                }
            }
            else
            {
                showMessageBox("Insert  Quantity and Select Stock Condition!!");
            }

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
    protected void submitButton0_OnClick(object sender, EventArgs e)
    {
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            int rowindex = Convert.ToInt32(i);
            int RowIndex2 = i;
            int bigStore = Convert.ToInt32(loadGridView.Rows[rowindex].Cells[7].Text);
            CheckBox ChkBoxRows = (CheckBox) loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked)
            {


                if ((((TextBox) loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text) != "" &&
                    (((TextBox) loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text) != "0" &&
                    ((DropDownList) loadGridView.Rows[RowIndex2].Cells[5].FindControl("StockConditionDropDownList"))
                        .SelectedIndex != 0)
                {
                    if (bigStore <
                        Convert.ToDecimal(
                            ((TextBox) loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text))
                    {
                        showMessageBox(" Quantity must be Less then Stock Qty");
                    }
                    if (bigStore >=
                        Convert.ToDecimal(
                            ((TextBox) loadGridView.Rows[RowIndex2].Cells[7].FindControl("returnQtyTextBox")).Text))
                    {
                        int Datakey = Convert.ToInt32(loadGridView.DataKeys[rowindex][0].ToString());

                        //C WH-----------------------------------------------------------------------

                        if (manufacturerDropDownList.SelectedValue != "" && whDropDownList.SelectedValue != "" &&
                            centalWHCheckBox.Checked)
                        {
                            DataTable dt = new DataTable();
                            dt = aStockConditionFreezeBll.LoadWHData(Datakey);

                            //insert
                            StockConditionFreezeDAO aConditionFreezeDao = new StockConditionFreezeDAO()
                            {
                                ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                                ReceiveId = Convert.ToInt32(whDropDownList.SelectedValue),
                                //DCStoreId = Convert.ToInt32(dcDropDownList1.SelectedValue),
                                FreezeQty =
                                    Convert.ToDecimal(
                                        (((TextBox)
                                            loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text)),
                                EntryBy = Session["LoginName"].ToString(),
                                EntryDate = DateTime.Now
                            };
                            int StockConditionFreezeID = 0;
                            StockConditionFreezeID = aStockConditionFreezeBll.SaveforWH(aConditionFreezeDao);
                            if (StockConditionFreezeID > 0)
                            {
                                DCStoreFreezeDAO aDcStoreFreezeDao = new DCStoreFreezeDAO();

                                // aDcStoreFreezeDao.DCStoreId = 0;
                                // aDcStoreFreezeDao.InvoiceDetailId = 0;
                                aDcStoreFreezeDao.StorageLocation = (dt.Rows[0]["StorageLocation"].ToString().Trim());
                                aDcStoreFreezeDao.ProductCode = (dt.Rows[0]["ProductCode"].ToString().Trim());
                                aDcStoreFreezeDao.ProductName = (dt.Rows[0]["ProductName"].ToString().Trim());
                                aDcStoreFreezeDao.PackSize = (dt.Rows[0]["PackSize"].ToString().Trim());
                                aDcStoreFreezeDao.BatchNo = (dt.Rows[0]["BatchNo"].ToString().Trim());
                                aDcStoreFreezeDao.ExpDate = Convert.ToDateTime((dt.Rows[0]["ExpDate"].ToString().Trim()));
                                aDcStoreFreezeDao.ReceiveDate =
                                    Convert.ToDateTime((dt.Rows[0]["ReceiveDate"].ToString().Trim()));
                                aDcStoreFreezeDao.ChalanNo = (dt.Rows[0]["ChalanNo"].ToString().Trim());
                                aDcStoreFreezeDao.ChalanDate =
                                    Convert.ToDateTime((dt.Rows[0]["ChalanDate"].ToString().Trim()));
                                // aDcStoreFreezeDao.ComUnitId =  0;
                                aDcStoreFreezeDao.StockQty =
                                    Convert.ToDecimal(
                                        ((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                            .Text);
                                aDcStoreFreezeDao.TotalQuantity =
                                    Convert.ToDecimal(
                                        ((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                            .Text);
                                aDcStoreFreezeDao.DamageQty = 0;
                                aDcStoreFreezeDao.StockRcvDate = DateTime.Now;
                                // aDcStoreFreezeDao.ReqId =  0;
                                // aDcStoreFreezeDao.ReqChildId = 0;
                                //aDcStoreFreezeDao.StockInTransfarId = 0;
                                aDcStoreFreezeDao.StockCondition =
                                    ((DropDownList)
                                        loadGridView.Rows[RowIndex2].Cells[5].FindControl("StockConditionDropDownList"))
                                        .SelectedItem.Text;
                                aDcStoreFreezeDao.remarks =
                                    (((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("remarksTextBox"))
                                        .Text);

                                aDcStoreFreezeDao.ReceiveId = Convert.ToInt32(dt.Rows[0]["ReceiveId"].ToString().Trim());
                                aDcStoreFreezeDao.StockConditionFreezeID = StockConditionFreezeID;

                                int FreezeID = aStockConditionFreezeBll.SaveDCStoreFreeze(aDcStoreFreezeDao);
                                if (FreezeID > 0)
                                {
                                    decimal dtstock = Convert.ToDecimal(dt.Rows[0]["Quantity"].ToString());
                                    string a =
                                        ((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                            .Text;
                                    decimal StockQty = dtstock - Convert.ToDecimal(a.Trim());
                                    aStockConditionFreezeBll.UpdateCentralStore(StockQty, Datakey);
                                    
                                }
                            }
                        }

                        //DC Store --------------------------------------------------------------------------------------
                        if (manufacturerDropDownList.SelectedValue != "" && dcDropDownList1.SelectedValue != "" &&
                            centalWHCheckBox.Checked == false)
                        {
                            //insert
                            StockConditionFreezeDAO aConditionFreezeDao = new StockConditionFreezeDAO()
                            {
                                ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                                // ReceiveId = Convert.ToInt32(whDropDownList.SelectedValue),
                                DCStoreId = Convert.ToInt32(dcDropDownList1.SelectedValue),
                                FreezeQty =
                                    Convert.ToDecimal(
                                        (((TextBox)
                                            loadGridView.Rows[RowIndex2].Cells[11].FindControl("returnQtyTextBox")).Text)),
                                EntryBy = Session["LoginName"].ToString(),
                                EntryDate = DateTime.Now

                            };
                            int StockConditionFreezeID = 0;
                            StockConditionFreezeID = aStockConditionFreezeBll.SaveforDC(aConditionFreezeDao);
                            if (StockConditionFreezeID > 0)
                            {
                                DataTable dt2 = new DataTable();
                                dt2 = aStockConditionFreezeBll.LoadStockStockQtyDCData(Datakey);
                                DCStoreFreezeDAO aDcStoreFreezeDao = new DCStoreFreezeDAO();
                                aDcStoreFreezeDao.DCStoreId =
                                    Convert.ToInt32((dt2.Rows[0]["DCStoreId"].ToString().Trim()));
                                // aDcStoreFreezeDao.InvoiceDetailId = 0;
                                aDcStoreFreezeDao.StorageLocation = (dt2.Rows[0]["StorageLocation"].ToString().Trim());
                                aDcStoreFreezeDao.ProductCode = (dt2.Rows[0]["ProductCode"].ToString().Trim());
                                aDcStoreFreezeDao.ProductName = (dt2.Rows[0]["ProductName"].ToString().Trim());
                                aDcStoreFreezeDao.PackSize = (dt2.Rows[0]["PackSize"].ToString().Trim());
                                aDcStoreFreezeDao.BatchNo = (dt2.Rows[0]["BatchNo"].ToString().Trim());
                                aDcStoreFreezeDao.TotalQuantity =
                                    Convert.ToDecimal(
                                        ((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                            .Text);
                                aDcStoreFreezeDao.ExpDate =
                                    Convert.ToDateTime((dt2.Rows[0]["ExpDate"].ToString().Trim()));
                                aDcStoreFreezeDao.ReceiveDate =
                                    Convert.ToDateTime((dt2.Rows[0]["ReceiveDate"].ToString().Trim()));
                                aDcStoreFreezeDao.ChalanNo = (dt2.Rows[0]["ChalanNo"].ToString().Trim());
                                aDcStoreFreezeDao.ChalanDate =
                                    Convert.ToDateTime((dt2.Rows[0]["ChalanDate"].ToString().Trim()));
                                aDcStoreFreezeDao.ComUnitId =
                                    Convert.ToInt32((dt2.Rows[0]["ComUnitId"].ToString().Trim()));
                                aDcStoreFreezeDao.StockQty =
                                    Convert.ToDecimal(
                                        ((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                            .Text);

                                aDcStoreFreezeDao.DamageQty = 0;
                                aDcStoreFreezeDao.StockRcvDate = DateTime.Now;
                                // aDcStoreFreezeDao.ReqId =  0;
                                // aDcStoreFreezeDao.ReqChildId = 0;
                                //aDcStoreFreezeDao.StockInTransfarId = 0;
                                aDcStoreFreezeDao.StockCondition =
                                    ((DropDownList)
                                        loadGridView.Rows[RowIndex2].Cells[5].FindControl("StockConditionDropDownList"))
                                        .SelectedItem.Text;
                                aDcStoreFreezeDao.remarks =
                                    (((TextBox) loadGridView.Rows[RowIndex2].Cells[5].FindControl("remarksTextBox"))
                                        .Text);

                                //  aDcStoreFreezeDao.ReceiveId = Convert.ToInt32(dt2.Rows[0]["Quantity"].ToString().Trim());
                                aDcStoreFreezeDao.StockConditionFreezeID = StockConditionFreezeID;

                                int DCID = aStockConditionFreezeBll.SaveDCStoreFreeze2(aDcStoreFreezeDao);

                                if (DCID > 0)
                                {

                                    decimal dtdcstock = Convert.ToDecimal(dt2.Rows[0]["StockQty"].ToString());
                                    string B =
                                        ((TextBox)loadGridView.Rows[RowIndex2].Cells[5].FindControl("returnQtyTextBox"))
                                            .Text;
                                    decimal DCStockQty = dtdcstock - Convert.ToDecimal(B.Trim());
                                    aStockConditionFreezeBll.UpdateDCStore(DCStockQty, Datakey);
                                    
                                }
                            }
                        }
                    }
                }
                else
                {
                    showMessageBox("Insert  Quantity and Select Stock Condition!!");
                }
            }
        }
        LoadDCStoreData();
        showMessageBox("Stock Freeze Successfull");
    }
}