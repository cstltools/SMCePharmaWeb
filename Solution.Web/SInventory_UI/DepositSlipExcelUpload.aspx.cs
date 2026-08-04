using Library.BLL.SInventory_BLL;
using Library.DAL.SAP_IntegrationDAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;
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

public partial class SInventory_UI_CustomerExcelUpload : System.Web.UI.Page
{
    ExcelUpForMIGOBLL aExcelUpForMIGOBLL = new ExcelUpForMIGOBLL();
    CompanywisebranchDal aDal = new CompanywisebranchDal();
    private static SAP_IntrigationPointDAL _DAL = new SAP_IntrigationPointDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();

            DataTable dtTable = _DAL.GetDepositCodeByDIC("");
            if (dtTable.Rows.Count > 0)
            {
                txtDepositCode.Text = dtTable.Rows[0]["DepositCode"].ToString();
            }
        }
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public void LoadDropDown()
    {
        aExcelUpForMIGOBLL.LoadmanufacturerName(manufacturerDropDownList);
    }
    private void Clear()
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();

        lbl_up_status.Text = "";
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

    }
    private bool XLDataGridToDbByRow(int MigoMasterID)
    {
        string Migo = "";
        try
        {
            foreach (GridViewRow row in loadGridView.Rows)
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
            loadGridView.DataSource = null;
            loadGridView.DataBind();
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

        if (loadGridView.Rows.Count > 0)
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                if (loadGridView.Rows[i].Cells[1].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[2].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[3].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[4].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[5].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[6].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[7].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[8].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[9].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[10].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[11].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[12].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[13].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[14].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[15].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[16].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[17].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[18].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[19].Text.Trim() == "&nbsp;" ||
                    loadGridView.Rows[i].Cells[20].Text.Trim() == "&nbsp;")
                {
                    ShowMessageBox(" Field Cannot be Blank !!");

                    return false;

                }
            }
        }

        if (loadGridView.Rows.Count > 0)
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                if (loadGridView.Rows[i].Cells[1].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[2].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[3].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[4].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[5].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[6].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[7].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[8].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[9].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[10].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[11].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[12].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[13].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[14].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[15].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[16].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[17].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[18].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[19].Text.Trim() == "" ||
                    loadGridView.Rows[i].Cells[20].Text.Trim() == "")
                {
                    ShowMessageBox(" Field Cannot be Blank !!");
                    return false;
                }
            }
        }

        if (loadGridView.Rows.Count > 0)
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                if (loadGridView.Rows[i].Cells[1].Text.Trim() == "&nbsp;&nbsp;" ||
                    loadGridView.Rows[i].Cells[2].Text.Trim() == "&nbsp;&nbsp;" ||
                    loadGridView.Rows[i].Cells[3].Text.Trim() == "&nbsp;&nbsp;" ||
                    loadGridView.Rows[i].Cells[4].Text.Trim() == "&nbsp;&nbsp;" ||
                    loadGridView.Rows[i].Cells[5].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[6].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[7].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[8].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[9].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[10].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[11].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[12].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[13].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[14].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[15].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[16].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[17].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[18].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[19].Text.Trim() == "&nbsp&nbsp;" ||
                    loadGridView.Rows[i].Cells[20].Text.Trim() == "&nbsp&nbsp;")
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
        if (loadGridView.Rows.Count == 0)
        {
            ShowMessageBox(" Upload File !!");
            return false;
        }

        return true;
    }

    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validattion())
        {
            CompanyWiseDepositDao aDepositDao;

            int id = 0;

            if (loadGridView.Rows.Count > 0)
            {
                for (int i = 0; i < loadGridView.Rows.Count; i++)
                {
                    aDepositDao = new CompanyWiseDepositDao();


                    Label lblTerritoryCode = ((Label)loadGridView.Rows[i].Cells[1].FindControl("lblTerritoryCode"));
                    Label lblSapTerritoryCode = ((Label)loadGridView.Rows[i].Cells[1].FindControl("lblSapTerritoryCode"));

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

                    //string cell0 = loadGridView.Rows[i].Cells[0].Text;
                    string cell1 = loadGridView.Rows[i].Cells[3].Text;
                    string cell2 = loadGridView.Rows[i].Cells[4].Text;
                    string cell3 = loadGridView.Rows[i].Cells[5].Text;
                    string cell4 = loadGridView.Rows[i].Cells[6].Text;
                    string cell5 = loadGridView.Rows[i].Cells[7].Text;
                    string cell6 = loadGridView.Rows[i].Cells[8].Text;
                    string cell7 = loadGridView.Rows[i].Cells[9].Text;

                    aDepositDao.CompanyId = Convert.ToInt32(Session["ComUnitId"].ToString());
                    aDepositDao.DepositType = cell2;

                    aDepositDao.MIOId = MIOId;
                    aDepositDao.Amount = Convert.ToDecimal(cell6.Trim());
                    aDepositDao.EntryBy = Session["LoginName"].ToString();
                    aDepositDao.EntryDate = DateTime.Now;
                    DateTime? parsedDate = ParseDateFlexible(cell5);

                    if (parsedDate.HasValue)
                    {
                        aDepositDao.DepositDate = parsedDate.Value;
                    }
                    else
                    {
                        Console.WriteLine("Invalid date: " + cell5);
                    }
                    aDepositDao.IsDelete = false;
                    aDepositDao.IsExcelUpload = true;
                    aDepositDao.Remarks = cell7;
                    int BankId = 0;
                    try
                    {
                        using (DataTable dt = _seedRepo.GetBAnkInfoByIdAcc(cell4.Trim(), aDepositDao.CompanyId.ToString()))
                        {
                            BankId = Convert.ToInt32(dt.Rows[0]["BankId"].ToString());
 
                        }
                    }
                    catch { }

                    aDepositDao.BankId = Convert.ToInt32(BankId);
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
    public static DateTime? ParseDateFlexible(object cellValue)
    {
        if (cellValue == null)
            return null;

        // Excel Date type হলে
        if (cellValue is DateTime)
            return (DateTime)cellValue;

        string str = cellValue.ToString();

        if (str == null)
            return null;

        str = str.Trim();

        if (str == "")
            return null;

        string[] formats = new string[]
        {
        "dd/MM/yyyy",
        "d/M/yyyy",
        "MM/dd/yyyy",
        "M/d/yyyy",
        "yyyy-MM-dd",
        "dd-MM-yyyy",
        "d-M-yyyy"
        };

        DateTime result;

        // TryParseExact
        if (DateTime.TryParseExact(
                str,
                formats,
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out result))
        {
            return result;
        }

        // fallback
        if (DateTime.TryParse(str, out result))
        {
            return result;
        }

        return null;
    }
    private bool Validattion()
    {
        //if (manufacturerDropDownList.SelectedValue == "")
        //{
        //    ShowMessageBox("You should select sales center !!");
        //    return false;
        //}


        if (loadGridView.Rows.Count == 0)
        {
            ShowMessageBox("Please add deposit slip info !!");
            return false;
        }

        if (loadGridView.Rows.Count > 0)
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {

                Label lblTerritoryCode = ((Label)loadGridView.Rows[i].Cells[1].FindControl("lblTerritoryCode"));
                Label lblSapTerritoryCode = ((Label)loadGridView.Rows[i].Cells[1].FindControl("lblSapTerritoryCode"));
                HiddenField hfBankId = ((HiddenField)loadGridView.Rows[i].Cells[1].FindControl("hfBankId"));

                string cell1 = loadGridView.Rows[i].Cells[3].Text;
                string cell2 = loadGridView.Rows[i].Cells[4].Text;
                string cell3 = loadGridView.Rows[i].Cells[5].Text;
                string cell4 = loadGridView.Rows[i].Cells[6].Text;
                string cell5 = loadGridView.Rows[i].Cells[7].Text;
                string cell6 = loadGridView.Rows[i].Cells[8].Text;
                string cell7 = loadGridView.Rows[i].Cells[9].Text;

                if (cell1 == "" || cell2 == "" || cell3 == "" || cell4 == "" || cell5 == "" || cell6 == "" || cell7 == "")
                {

                    ShowMessageBox("Please fill up all required data !!");
                    loadGridView.Rows[i].BackColor = System.Drawing.Color.Red;
                    return false;
                }

                int bankId = 0;
                try
                {
                    bankId = Convert.ToInt32(hfBankId.Value);
                }
                catch (Exception ex)
                {
                    bankId = 0;
                }

                if (bankId == 0)
                {
                    ShowMessageBox("Bank Name Not Found!");
                    loadGridView.Rows[i].BackColor = System.Drawing.Color.Red;
                    return false;
                }

                if (cell4 != "")
                {
                    DataTable dtTable = _DAL.GetBankSAPMappingAccounTNo(cell4.Trim());

                    if (dtTable.Rows.Count > 0)
                    {

                    }
                    else
                    {
                        loadGridView.Rows[i].BackColor = System.Drawing.Color.Red;
                        ShowMessageBox("Account Not mapped!!");
                        return false;
                    }
                }


                if (cell4 != "")
                {
                    DataTable dtTable = _DAL.GetBankAccounTNo(cell4.Trim(), Session["ComUnitId"].ToString());

                    if (dtTable.Rows.Count > 0)
                    {

                    }
                    else
                    {

                        loadGridView.Rows[i].BackColor = System.Drawing.Color.Red;
                        ShowMessageBox("Account Not mapped!!");
                        return false;

                    }
                }
            }
        }

        txtTotalAmount.CssClass = "form-control form-control-sm";

        if (txtTotalAmount.Text == "")
        {
            txtTotalAmount.ToolTip = "please fill out this field";
            txtTotalAmount.CssClass = "form-control form-control-sm is-invalid";
            txtTotalAmount.Focus();
            return false;
        }

        decimal _TotalAmount = 0;
        try
        {
            _TotalAmount = Convert.ToDecimal(txtTotalAmount.Text);

        }
        catch (Exception ex)
        {

        }


        decimal _hfAmount = 0;
        try
        {
            _hfAmount = Convert.ToDecimal(lblCount.Text);

        }
        catch (Exception ex)
        {

        }
        if (_TotalAmount != _hfAmount)
        {
            ShowMessageBox("Please add deposit slip info !!");
            txtTotalAmount.ToolTip = "please fill out this field";
            txtTotalAmount.CssClass = "form-control form-control-sm is-invalid";
            txtTotalAmount.Focus();
            return false;
        }


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
            if (id_fu == null || id_fu.PostedFile == null || string.IsNullOrWhiteSpace(id_fu.PostedFile.FileName))
            {
                ShowMessageBox("Please select an Excel file !!");
                return;
            }


            lbl_up_status.CssClass = "";
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
            string fileName = Path.GetFileName(FilePath); //txtSheetName.Text = fileName;
            loadGridView.Caption = fileName;
            loadGridView.DataSource = destinationTable;
            loadGridView.DataBind();

            decimal _tAmount = 0;
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                //Label lblTerritoryCode = ((Label)loadGridView.Rows[i].Cells[1].FindControl("lblTerritoryCode"));
                //Label lblSapTerritoryCode = ((Label)loadGridView.Rows[i].Cells[1].FindControl("lblSapTerritoryCode"));
                HiddenField hfBankId = ((HiddenField)loadGridView.Rows[i].Cells[1].FindControl("hfBankId"));

                string cell6 = loadGridView.Rows[i].Cells[8].Text;

                _tAmount = _tAmount + Convert.ToDecimal(cell6.Trim());
                //if (lblTerritoryCode.Text != "")
                //{
                //    DataTable dtTable = _DAL.GetSAP_EmpSApCodebyTerritory(lblTerritoryCode.Text);

                //    if (dtTable.Rows.Count > 0)
                //    {
                //        lblSapTerritoryCode.Text = dtTable.Rows[0]["SAP_MIOCode"].ToString();
                //    }
                //    else
                //    {
                //        lblSapTerritoryCode.Text = "";
                //    }


                //}

                string cell4 = loadGridView.Rows[i].Cells[6].Text;

                if (cell4 != "")
                {
                    DataTable dtTable = _DAL.GetBankSAPMappingAccounTNo(cell4.Trim());

                    if (dtTable.Rows.Count > 0)
                    {
                       
                    }
                    else
                    {

                        loadGridView.Rows[i].BackColor = System.Drawing.Color.Red;

                    }
                } 
                
                
                if (cell4 != "")
                {
                    DataTable dtTable = _DAL.GetBankAccounTNo(cell4.Trim(), Session["ComUnitId"].ToString());

                    if (dtTable.Rows.Count > 0)
                    {
                        hfBankId.Value = dtTable.Rows[0]["BankId"].ToString();
                    }
                    else
                    {

                        loadGridView.Rows[i].BackColor = System.Drawing.Color.Red;

                    }
                }

            }
            lbl_up_status.Text = loadGridView.Rows.Count.ToString() + " record Found!";
            IsFileUploaded.Value = "true";



            lblCount.Text = _tAmount.ToString();
        }
        catch (InvalidOperationException ex)
        {
            ShowMessageBox(ex.Message);
        }
        catch(Exception ex)
        {
            ShowMessageBox("Please fill up all required data !!");
        }
    }

    private OleDbConnection CreateExcelConnection(string path, string extension)
    {
        string extendedProperties = extension == ".xls"
            ? "Excel 8.0;HDR=Yes;IMEX=2"
            : "Excel 12.0 Xml;HDR=Yes;IMEX=1";

        string[] providers = { "Microsoft.ACE.OLEDB.16.0", "Microsoft.ACE.OLEDB.12.0" };
        Exception lastException = null;

        foreach (string provider in providers)
        {
            string connectionString = string.Format(
                "Provider={0};Data Source={1};Extended Properties=\"{2}\";",
                provider,
                path,
                extendedProperties);

            OleDbConnection connection = new OleDbConnection(connectionString);
            try
            {
                connection.Open();
                return connection;
            }
            catch (Exception ex)
            {
                connection.Dispose();
                lastException = ex;
            }
        }

        throw new InvalidOperationException(
            "No compatible ACE OLEDB provider found. Please install Microsoft Access Database Engine (x64/x86 to match IIS app pool).",
            lastException);
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
        loadGridView.DataSource = null;
        loadGridView.DataBind();
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
