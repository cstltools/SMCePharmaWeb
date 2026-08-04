using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.SAP_IntegrationDAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_CustomerPaymentExcelUpload : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    ExcelUpForMIGOBLL aExcelUpForMIGOBLL = new ExcelUpForMIGOBLL();
    CompanywisebranchDal aDal = new CompanywisebranchDal();
    private static SAP_IntrigationPointDAL _DAL = new SAP_IntrigationPointDAL();
    OrderInfoDAL aDalOrd = new OrderInfoDAL();
    private CustPaymentBLL aCustPaymentBll = new CustPaymentBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();

            DataTable dtTable = _DAL.GetDepositCodeByDIC("");
            if (dtTable.Rows.Count > 0)
            {
                txtDepositCode.Text = dtTable.Rows[0]["DepositCode"].ToString();
            }
        }
    }

    public void DropDownList()
    {
        try
        {
            aCustPaymentBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());


            salesCenterDropDownList.SelectedIndex = 1;

         
            salesCenterDropDownList_SelectedIndexChanged(null, null);

        }
        catch (Exception ex)
        {

        }

    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            ddlDAName.Items.Clear();
            try
            {
                using (DataTable dt = _seedRepo.GetRouteInfoforCustPayment(Convert.ToInt32(salesCenterDropDownList.SelectedValue)))
                {
                    rootDropDownList.DataSource = dt;

                    rootDropDownList.DataValueField = "DistributionRouteId";
                    rootDropDownList.DataTextField = "DistributionRouteName";
                    rootDropDownList.DataBind();
                    rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    rootDropDownList.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }

            // aOrderInfoBll.LoadDeliveryDisRouteforInvoice(rootDropDownList, Convert.ToInt32(salesCenterDropDownList.SelectedValue));
        }
        catch (Exception ex)
        {

        }
    }

    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlDAName.Items.Clear();
        try
        {
            RouteInformationDAL _DalRoute = new RouteInformationDAL();
            using (DataTable dt = _DalRoute.GeteRouteInformationDA_DDLId(rootDropDownList.SelectedValue))
            {
                ddlDAName.DataSource = dt;
                ddlDAName.DataValueField = "DANameId";
                ddlDAName.DataTextField = "DAName";
                ddlDAName.DataBind();
                ddlDAName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDAName.SelectedIndex = 0;
            }
        }
        catch (Exception ex) { }
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
  
    private void Clear()
    {
        orderGridView.DataSource = null;
        orderGridView.DataBind();

        lbl_up_status.Text = "";
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerPaymentExcelUpload.aspx");
    }
    private bool XLDataGridToDbByRow(int MigoMasterID)
    {
        string Migo = "";
        try
        {
            foreach (GridViewRow row in orderGridView.Rows)
            {
                // CheckBox ChkBoxRows = (CheckBox)row.FindControl("chkRow");
                // if (ChkBoxRows.Checked)
                {
                    String BRANCH = row.Cells[1].Text.Trim();
                    String BRANCHDES = row.Cells[2].Text.Trim();
                    String CustomerCode = (row.Cells[3].Text.Trim());
                    String CUSTOMERNAME = row.Cells[4].Text.Trim();
                    String ADDRESS1 = row.Cells[5].Text.Trim();
                    String ADDRESS2 = (row.Cells[6].Text.Trim());
                    String CITY = row.Cells[7].Text.Trim();
                    String CONTACTPERSON = (row.Cells[8].Text.Trim());
                    String CONTACTNUMBER = (row.Cells[9].Text.Trim());
                    String MIOCode = row.Cells[10].Text.Trim();
                    String MIOName = row.Cells[11].Text.Trim();
                    String TerritoryCode = (row.Cells[12].Text.Trim());
                    String FECode = (row.Cells[13].Text.Trim());
                    String FEName = (row.Cells[14].Text.Trim());
                    String DZSMCode = row.Cells[15].Text.Trim();
                    String DZSMName = row.Cells[16].Text.Trim();
                    String SHIPPINGCOND = row.Cells[17].Text.Trim();
                    String SHIPPINGPOINT = (row.Cells[18].Text.Trim());
                    String MarketName = row.Cells[19].Text.Trim();
                    String TERMOFPAYMENT = (row.Cells[20].Text.Trim());
                    Migo = MigoMasterID.ToString();

                    //if (aDuplicateMailCheckBll.CheckAgentMail(AgentMail.Trim()) == true)
                    {
                        aExcelUpForMIGOBLL.CustomerXLDataGridToDbByRow(BRANCH, BRANCHDES, CustomerCode, CUSTOMERNAME, ADDRESS1,
                            ADDRESS2, CITY, CONTACTPERSON, CONTACTNUMBER, MIOCode, MIOName, TerritoryCode, FECode, FEName, DZSMCode,
                            DZSMName, SHIPPINGCOND, SHIPPINGPOINT, MarketName, TERMOFPAYMENT, Migo);
                    }

                }
            }
            orderGridView.DataSource = null;
            orderGridView.DataBind();
            lbl_up_status.Text = "";
            return true;
        }
        catch (Exception ex)
        {
            ShowMessageBox(ex.ToString());
            return false;
        }
    }
    protected void loadGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        for (int i = 0; i < e.Row.Cells.Count; i++)
        {
            if (e.Row.Cells[i].Text == "&nbsp;")
                e.Row.Cells[i].BackColor = Color.Orange;
        }
    }
    private bool CheckValidation()
    {

        if (orderGridView.Rows.Count > 0)
        {
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                if (orderGridView.Rows[i].Cells[1].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[2].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[3].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[4].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[5].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[6].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[7].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[8].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[9].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[10].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[11].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[12].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[13].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[14].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[15].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[16].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[17].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[18].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[19].Text.Trim() == "&nbsp;" ||
                    orderGridView.Rows[i].Cells[20].Text.Trim() == "&nbsp;")
                {
                    ShowMessageBox(" Field Cannot be Blank !!");

                    return false;

                }
            }
        }

        if (orderGridView.Rows.Count > 0)
        {
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                if (orderGridView.Rows[i].Cells[1].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[2].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[3].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[4].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[5].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[6].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[7].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[8].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[9].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[10].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[11].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[12].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[13].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[14].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[15].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[16].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[17].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[18].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[19].Text.Trim() == "" ||
                    orderGridView.Rows[i].Cells[20].Text.Trim() == "")
                {
                    ShowMessageBox(" Field Cannot be Blank !!");
                    return false;
                }
            }
        }

        if (orderGridView.Rows.Count > 0)
        {
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                if (orderGridView.Rows[i].Cells[1].Text.Trim() == "&nbsp;&nbsp;" ||
                    orderGridView.Rows[i].Cells[2].Text.Trim() == "&nbsp;&nbsp;" ||
                    orderGridView.Rows[i].Cells[3].Text.Trim() == "&nbsp;&nbsp;" ||
                    orderGridView.Rows[i].Cells[4].Text.Trim() == "&nbsp;&nbsp;" ||
                    orderGridView.Rows[i].Cells[5].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[6].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[7].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[8].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[9].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[10].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[11].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[12].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[13].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[14].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[15].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[16].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[17].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[18].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[19].Text.Trim() == "&nbsp&nbsp;" ||
                    orderGridView.Rows[i].Cells[20].Text.Trim() == "&nbsp&nbsp;")
                {
                    ShowMessageBox(" Field Cannot be Blank !!");
                    return false;
                }
            }
        }
        if (documentDateTextBox.Text == "")
        {
            ShowMessageBox("Select DocumentDate!!");
            documentDateTextBox.Focus();
            return false;
        }
        if (!(manufacturerDropDownList.SelectedIndex > 0))
        {
            ShowMessageBox("Select Manufacturer !!");
            manufacturerDropDownList.Focus();
            return false;
        }
        if (orderGridView.Rows.Count == 0)
        {
            ShowMessageBox(" Upload File !!");
            return false;
        }

        return true;
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            CompanyWiseDepositDao aDepositDao;

            int id = 0;

            if (orderGridView.Rows.Count > 0)
            {
                for (int i = 0; i < orderGridView.Rows.Count; i++)
                {
                    aDepositDao = new CompanyWiseDepositDao();


                    Label lblTerritoryCode = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblTerritoryCode"));
                    Label lblSapTerritoryCode = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblSapTerritoryCode"));
                    Label lblCollectionBy = ((Label)orderGridView.Rows[i].Cells[1].FindControl("lblCollectionBy"));

                    DataTable dtTable = _DAL.GetSAP_EmpSApCodebyTerritory(lblTerritoryCode.Text);

                    int MIOId = 0;

                    if (dtTable.Rows.Count > 0)
                    {
                        MIOId = Convert.ToInt32(dtTable.Rows[0]["MIOId"].ToString());
                    }
                    else
                    {
                        MIOId = 0;
                    }

                    //string cell0 = orderGridView.Rows[i].Cells[0].Text;
                    string cell1 = orderGridView.Rows[i].Cells[3].Text;
                    string cell2 = orderGridView.Rows[i].Cells[4].Text;
                    string cell3 = orderGridView.Rows[i].Cells[5].Text;
                    string cell4 = orderGridView.Rows[i].Cells[6].Text;
                    string cell5 = orderGridView.Rows[i].Cells[7].Text;
                    string cell6 = orderGridView.Rows[i].Cells[8].Text;
                    string cell7 = orderGridView.Rows[i].Cells[9].Text;

                    aDepositDao.CompanyId = Convert.ToInt32(cell1);
                    aDepositDao.DepositType = cell2;

                    aDepositDao.MIOId = MIOId;
                    aDepositDao.Amount = Convert.ToDecimal(cell6.Trim());
                    aDepositDao.EntryBy = Session["LoginName"].ToString();
                    aDepositDao.EntryDate = DateTime.Now;
                    aDepositDao.DepositDate = Convert.ToDateTime(cell5.Trim());
                    aDepositDao.IsDelete = false;
                    aDepositDao.IsExcelUpload = true;
                    aDepositDao.Remarks = cell7;
                 

                    aDepositDao.BankId = Convert.ToInt32(cell3);
                    aDepositDao.AccountName = cell4;


                    DataTable dtTablec = _DAL.GetDepositCodeByDIC("");
                    if (dtTablec.Rows.Count > 0)
                    {
                        txtDepositCode.Text = dtTablec.Rows[0]["DepositCode"].ToString();
                    }
                    aDepositDao.DepositCode = txtDepositCode.Text;
                    id = aDal.SaveDepositInfo(aDepositDao);
                }
            }

            if (id > 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','DepositSlipExcelUpload.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

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
    public bool Validation()
    {


        if (ddlDAName.SelectedValue == "")
        {
            showMessageBox("Please Select DA Name!!");
            ddlDAName.Focus();
            return false;
        }
        int CK = 0;
        for (int j = 0; j < orderGridView.Rows.Count; j++)
        {
            CheckBox cbReject = (CheckBox)orderGridView.Rows[j].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                CK = CK + 1;
            }
        }
        if (CK == 0)
        {
            showMessageBox("Please Select Invoice from List!!");
            return false;
        }
        int count = 0;
        if (orderGridView.Rows.Count > 0)
        {
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {

                if (((CheckBox)orderGridView.Rows[i].Cells[1].FindControl("chkSelect")).Checked)
                {
                    if (((TextBox)orderGridView.Rows[i].FindControl("payAmountTextBox")).Text == "")
                    {
                        showMessageBox("Please fill out Pay Amount !!");
                        return false;
                    }

                    if (((TextBox)orderGridView.Rows[i].FindControl("payAmountTextBox")).Text == "0")
                    {
                        showMessageBox("Please fill out Pay Amount !!");
                        return false;
                    } 
                    
                    if (((Label)orderGridView.Rows[i].FindControl("lblCollectionBy")).Text == "")
                    {
                        showMessageBox("Please fill out Collection By MIO or DIC!!");
                        return false;
                    }

                    string selectedValue = ((Label)orderGridView.Rows[i].FindControl("lblCollectionBy")).Text.Trim();
                    if (selectedValue != "MIO" && selectedValue != "DIC")
                    {
                        showMessageBox("Please fill out Collection By MIO or DIC!!");
                        return false;
                    }
                    
                    count++;
                }
            }
        }



        //decimal totalamount = 0;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox cbReject = (CheckBox)orderGridView.Rows[i].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                TextBox payAmountTextBox = (TextBox)orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");
                Label lbl_PrvAmount = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblPaymentAmount");
                Label lblTotalDelivery = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblTotalDelivery");
                Label lblDue = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblDue");
                decimal mainamount = string.IsNullOrEmpty(payAmountTextBox.Text) ? 0 : Convert.ToDecimal(payAmountTextBox.Text);
                decimal delamount = 0;
                decimal Dueamount = 0;
                decimal prevamount = 0;

                prevamount = Convert.ToDecimal(lbl_PrvAmount.Text);
                delamount = Convert.ToDecimal(lblTotalDelivery.Text);
                Dueamount = Convert.ToDecimal(lblDue.Text);



                if ((mainamount + prevamount) > delamount)
                {

                    payAmountTextBox.Focus();
                    showMessageBox("Cannot Be Greater then Confirm Amount!!");
                    return false;
                }


                //if(mainamount!= delamount)
                //{
                //    payAmountTextBox.Focus();
                //    showMessageBox("Cannot Be Partial Payment!!");
                //    return false;
                //}
            }
        }
        //}
        //if (totalamount != Convert.ToDecimal((paymentAmountTextBox.Text)))
        //{
        //    showMessageBox("Total Invoice Payment Amount Must Be Equel To Payment Amount");
        //    return false;
        //}




        return true;
    }
    protected void areaImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("AreaView.aspx");
    }
    protected void btnUpload_Click(object sender, EventArgs e)
    {
        ExcelToGrid();
    }
    private void ExcelToGrid()
    {
        try
        {
            string FileName = Path.GetFileName(id_fu.PostedFile.FileName);
            string Extension = Path.GetExtension(id_fu.PostedFile.FileName);
            string FilePath = "~/ExcelFiles/" + id_fu.FileName;
            id_fu.SaveAs(MapPath(FilePath));

            string path = System.IO.Path.GetFullPath(Server.MapPath(FilePath));
            OleDbConnection oledbConn = null;

            if (Path.GetExtension(path) == ".xls")
            {
                oledbConn =
                    new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path +
                                        ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"");
            }
            else if (Path.GetExtension(path) == ".xlsx")
            {
                oledbConn =
                    new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path +
                                        ";Extended Properties='Excel 12.0;HDR=YES;IMEX=1;';");
            }

            OleDbCommand cmdExcel = new OleDbCommand();
            OleDbDataAdapter oda = new OleDbDataAdapter();
            DataTable dt = new DataTable();
            cmdExcel.Connection = oledbConn;

            oledbConn.Open();
            DataTable dtExcelSchema;
            dtExcelSchema = oledbConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
            string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
            oledbConn.Close();

            oledbConn.Open();
            cmdExcel.CommandText = "SELECT * From [" + SheetName + "]";
            oda.SelectCommand = cmdExcel;
            oda.Fill(dt);
            oledbConn.Close();

            DataTable destinationTable = new DataTable();
            destinationTable = dt.Clone();

            foreach (DataRow row in dt.Rows)
            {
                if (!string.IsNullOrEmpty(row[0].ToString()))
                {
                    destinationTable.ImportRow(row);
                }
            }
            string fileName = Path.GetFileName(FilePath);
            //txtSheetName.Text = fileName;
            orderGridView.Caption = fileName;
            DataTable MyGrid = new DataTable(); // Initialize MyGrid DataTable

            for (int i = 0; i < destinationTable.Rows.Count; i++)
            {
                // Accessing the value from the first column (index 0)
                string firstColumnValue = destinationTable.Rows[i][0].ToString().Trim();
                string lblCollectionBy = destinationTable.Rows[i][2].ToString().Trim();
                string stringValue = "";
                string valueAsString = destinationTable.Rows[i][1].ToString().Trim();
                decimal valueAsDecimal;

                CultureInfo culture = CultureInfo.InvariantCulture;

                if (decimal.TryParse(valueAsString, NumberStyles.Number, culture, out valueAsDecimal))
                {
                    // Convert the decimal value to a string with two decimal places
                    stringValue = valueAsDecimal.ToString("F2");
                }
                else
                {
                    // Conversion failed, handle the error or provide a default value
                    // For example:
                    // valueAsDecimal = 0; // Default value
                }

                // Now, stringValue contains the decimal value formatted as a string with two decimal places



                DataTable aTable = aDalOrd.LoadPaymentInvSPWithPaymentAmount(" and  InvoiceNo='" + firstColumnValue + "'", stringValue, lblCollectionBy );
                MyGrid.Merge(aTable);

            }


            orderGridView.DataSource = MyGrid;
            orderGridView.DataBind();


            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                PayAmountChange(i);
            }

            lbl_up_status.Text = orderGridView.Rows.Count.ToString() + " record Found!";
            IsFileUploaded.Value = "true";


            CalculateTotal();
            //lblCount.Text = _tAmount.ToString();
        }
        catch (Exception ex)
        {
            ShowMessageBox("Please fill up all required data !!"+ex.Message);
        }
    }
    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {

        CheckBox qtyTextBox = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)qtyTextBox.Parent.Parent;

        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        PayAmountChange(rowindex);
        CalculateTotal();
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)orderGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
                PayAmountChange(i);
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }

        CalculateTotal();
    }


    protected void saveButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            CustomerMaster aCustomerMaster;

            bool save = false;

            List<CustPaymentDetail> aCustPaymentDetails = new List<CustPaymentDetail>();

            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                CheckBox ChkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
                CheckBox chkAdjust = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkAdjust");
                TextBox payAmountTextBox = (TextBox)orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");
                HiddenField hfCustomerMasterId = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfCustomerMasterId");

                HiddenField hfMarketId = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfMarketId");
                HiddenField hfComUnitId = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfComUnitId");
                HiddenField hfTP_Pay = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfTP_Pay");
                HiddenField hfVat_Pay = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfVat_Pay");
                HiddenField hfDistributionRouteId = (HiddenField)orderGridView.Rows[i].Cells[7].FindControl("hfDistributionRouteId");
                Label lblCollectionBy = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblCollectionBy");
                decimal prevamount = 0;
                decimal TotalDelivery = 0;
                Label lbl_PrvAmount = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblPaymentAmount");
                Label lblTotalDelivery = (Label)orderGridView.Rows[i].Cells[7].FindControl("lblTotalDelivery");
                if (lbl_PrvAmount.Text != "")
                {
                    prevamount = Convert.ToDecimal(lbl_PrvAmount.Text);
                }


                if (lblTotalDelivery.Text != "")
                {
                    TotalDelivery = Convert.ToDecimal(lblTotalDelivery.Text);
                }

                if (ChkBoxRows.Checked)
                {



                    CustPayment aCustPayment = new CustPayment();

                    aCustPayment.CustomerMasterId = Convert.ToInt32(hfCustomerMasterId.Value);
                    aCustPayment.MarketId = Convert.ToInt32(hfMarketId.Value);
                    aCustPayment.DistributionRouteId = Convert.ToInt32(hfDistributionRouteId.Value);
                    aCustPayment.ComUnitId = Convert.ToInt32(hfComUnitId.Value);
                    aCustPayment.PaymentDate = Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy"));
                    aCustPayment.PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);
                    aCustPayment.PayType = "Cash";
                    aCustPayment.RefNo = "";


                    {
                        aCustPayment.RefDate = Convert.ToDateTime(DateTime.Now);
                    }


                    DataTable aTable = aDalOrd.CheckInvoiceCustpayment(aCustPayment.PaymentAmount, Convert.ToInt32(orderGridView.DataKeys[i][0].ToString()));

                    if (aTable.Rows.Count == 0)
                    {
                        string ptStatus = "";
                        aCustPayment.CreateBy = Session["LoginName"].ToString();
                        aCustPayment.CreateDate = DateTime.Now;
                        decimal _TP_Pay = 0;
                        decimal _Vat_Pay = 0;
                        _TP_Pay = Convert.ToDecimal(hfTP_Pay.Value);
                        _Vat_Pay = Convert.ToDecimal(hfVat_Pay.Value);
                        if ((Convert.ToDecimal(payAmountTextBox.Text) + prevamount) ==
                            TotalDelivery)
                        {
                            ptStatus = "Full";
                            decimal totalamount = 0;
                            totalamount = (Convert.ToDecimal(payAmountTextBox.Text) + prevamount);

                            decimal PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);

                            save = aCustPaymentBll.UpdateInvoiceFinalPayment(Convert.ToInt32(orderGridView.DataKeys[i][0].ToString()), PaymentAmount, ptStatus, Session["LoginName"].ToString());
                            //aCustPaymentBll.UpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                            //    orderGridView.DataKeys[i][0].ToString());
                        }
                        else
                        {
                            ptStatus = "Partial";
                            decimal totalamount = 0;
                            totalamount = (Convert.ToDecimal(payAmountTextBox.Text) + prevamount);
                            decimal PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);
                            save = aCustPaymentBll.UpdateInvoiceFinalPayment(Convert.ToInt32(orderGridView.DataKeys[i][0].ToString()), PaymentAmount, ptStatus, Session["LoginName"].ToString());
                        }
                        CustPaymentDetail aCustPaymentDetail = new CustPaymentDetail()
                        {
                            InvoiceId = Convert.ToInt32(orderGridView.DataKeys[i]["InvoiceId"].ToString()),
                            DANameId = Convert.ToInt32(ddlDAName.SelectedValue),
                            PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text),
                            TPAmount = _TP_Pay,
                            VATAmount = _Vat_Pay,
                            IsAdjust = chkAdjust.Checked ? Convert.ToBoolean(1) : Convert.ToBoolean(0),
                            CollectionBy = lblCollectionBy.Text.Trim()
                        };

                        aCustPaymentDetails.Add(aCustPaymentDetail);

                    }
                    else
                    {
                        save = false;
                    }

                    if (save)
                    {
                        if (aCustPaymentBll.SaveCustPayment(aCustPayment, aCustPaymentDetails))
                        {


                            //foreach (var aDetail in aCustPaymentDetails)
                            //{
                            //    if (aDetail.IsAdjust)
                            //    {
                            //        aCustPaymentBll.UpdateAdjustment(aDetail.InvoiceId);
                            //    }
                            //}

                        }

                    }
                }
            }

            if (save)
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','CustomerPaymentExcelUpload.aspx');", true);


            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);
            }


        }
    }


    protected void chkAdjust_OnCheckedChanged(object sender, EventArgs e)
    {
        CheckBox isAdjust = (CheckBox)sender;
        GridViewRow currentRow = (GridViewRow)isAdjust.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox payAmountTextBox = (TextBox)orderGridView.Rows[rowindex].Cells[7].FindControl("payAmountTextBox");

        if (isAdjust.Checked)
        {
            payAmountTextBox.Text = orderGridView.Rows[rowindex].Cells[10].Text.Trim();
        }
        else
        {
            payAmountTextBox.Text = "";
        }
    }
    protected void payAmountTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox qtyTextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)qtyTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        PayAmountChange(rowindex);

        CalculateTotal();

    }
    public void CalculateTotal()
    {
        decimal prevamount = 0;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox chkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            TextBox payAmountTextBox = (TextBox)orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");

            if (chkBoxRows.Checked)
            {
                if (payAmountTextBox.Text.Trim() != "")
                {
                    if (payAmountTextBox.Text != "0")
                    {
                        prevamount = prevamount + Convert.ToDecimal(payAmountTextBox.Text.Trim());
                    }
                }
            }
        }

        lblCount.Text = "Total Pay Amount : " + prevamount.ToString(CultureInfo.InvariantCulture);
    }

    private void PayAmountChange(int rowindex)
    {
        decimal prevamount = 0;
        TextBox payAmountTextBox = (TextBox)orderGridView.Rows[rowindex].Cells[7].FindControl("payAmountTextBox");
        Label lbl_PrvAmount = (Label)orderGridView.Rows[rowindex].Cells[7].FindControl("lblPaymentAmount");
        Label lblTotalDelivery = (Label)orderGridView.Rows[rowindex].Cells[7].FindControl("lblTotalDelivery");
        Label lblDue = (Label)orderGridView.Rows[rowindex].Cells[7].FindControl("lblDue");

        decimal mainamount = string.IsNullOrEmpty(payAmountTextBox.Text) ? 0 : Convert.ToDecimal(payAmountTextBox.Text);
        decimal delamount = 0;
        decimal Dueamount = 0;


        HiddenField hfInvoiceId = (HiddenField)orderGridView.Rows[rowindex].Cells[7].FindControl("hfInvoiceId");
        HiddenField hfTP_Pay = (HiddenField)orderGridView.Rows[rowindex].Cells[7].FindControl("hfTP_Pay");
        HiddenField hfVat_Pay = (HiddenField)orderGridView.Rows[rowindex].Cells[7].FindControl("hfVat_Pay");


        DataTable aTable = aDalOrd.LoadPaymentInvSPTPVATAmt(hfInvoiceId.Value, mainamount);

        if (aTable.Rows.Count > 0)
        {
            decimal _tpFinal = 0;
            decimal _VatFinal = 0;
            decimal _tpPay = Convert.ToDecimal(aTable.Rows[0]["TP_Pay"].ToString());
            decimal _vatPay = Convert.ToDecimal(aTable.Rows[0]["Vat_Pay"].ToString());

            if (_vatPay > 0)
            {
                _VatFinal = _vatPay - mainamount;

                if (_VatFinal > 0)
                {
                    _VatFinal = mainamount;
                    _tpFinal = 0;
                }
                else
                {
                    _VatFinal = _vatPay;
                    _tpFinal = mainamount - _vatPay;
                }

            }

            if (_vatPay == 0)
            {
                if (_tpPay > 0)
                {
                    _tpFinal = mainamount;
                    _VatFinal = 0;
                }
                else
                {
                    _VatFinal = 0;
                    _tpFinal = mainamount - _vatPay;
                }
            }

            hfTP_Pay.Value = _tpFinal.ToString();
            hfVat_Pay.Value = _VatFinal.ToString();
        }



        prevamount = Convert.ToDecimal(lbl_PrvAmount.Text);
        delamount = Convert.ToDecimal(lblTotalDelivery.Text);
        Dueamount = Convert.ToDecimal(lblDue.Text);



        if ((mainamount + prevamount) > delamount)
        {
            payAmountTextBox.Text = "0";
            payAmountTextBox.Focus();
            showMessageBox("Cannot Be Greater then Invoice Quantity ");

        }
    }
    public string GenerateParam(string InvoiceNo)
    {
        string paaram = "";




        paaram = " and  InvoiceNo='" + InvoiceNo + "'";


        return paaram;
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

    protected void cancelUploadListButton_Click(object sender, EventArgs e)
    {
        orderGridView.DataSource = null;
        orderGridView.DataBind();
    }
    protected void refreshButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../SInventory_UI/CustomerExcelUpload.aspx");
    }
    protected void HomeButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../CommonUI/HomePage.aspx");
    }
}