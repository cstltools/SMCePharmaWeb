using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_CustomerTagChangeExcelUpload : System.Web.UI.Page
{
    ExcelUpForCustTagChangeBLL aExcelUpForMIGOBLL = new ExcelUpForCustTagChangeBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDown();
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
        documentDateTextBox.Text = string.Empty;
        manufacturerDropDownList.SelectedValue = "";
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
                if (loadGridView.Rows[i].Cells[1].Text.Trim() == "&nbsp;&nbsp" ||
                    loadGridView.Rows[i].Cells[2].Text.Trim() == "&nbsp;&nbsp" ||
                    loadGridView.Rows[i].Cells[3].Text.Trim() == "&nbsp;&nbsp" ||
                    loadGridView.Rows[i].Cells[4].Text.Trim() == "&nbsp;&nbsp" ||
                    loadGridView.Rows[i].Cells[5].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[6].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[7].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[8].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[9].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[10].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[11].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[12].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[13].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[14].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[15].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[16].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[17].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[18].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[19].Text.Trim() == "&nbsp&nbsp" ||
                    loadGridView.Rows[i].Cells[20].Text.Trim() == "&nbsp&nbsp")
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
        if (loadGridView.Rows.Count == 0 )
        {
            ShowMessageBox(" Upload File !!");
            return false;
        }

        return true;
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (CheckValidation() == true)
        {
            if (manufacturerDropDownList.SelectedValue != "" && documentDateTextBox.Text != "")
            {
                MigoMasterDAO aMigoMasterDAO = new MigoMasterDAO()
                {
                    ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                    MogoDocumentDate = Convert.ToDateTime(documentDateTextBox.Text.Trim()),
                    StockUpload = false,
                    EntryBy = Session["LoginName"].ToString(),
                    EntryDate =  DateTime.Now

                };
                int MigoMasterID = 0;
                MigoMasterID = aExcelUpForMIGOBLL.SaveCustomerUploadMasterDAL(aMigoMasterDAO);
                if (MigoMasterID>0)
                {
                    if (XLDataGridToDbByRow(MigoMasterID))
                    {
                        ShowMessageBox("Upload Successful...");
                        Clear();
                    }
                    else
                    {
                        ShowMessageBox("Error Uploading....");
                    }
                }
            }
            else
            {
                ShowMessageBox("Please Select mandatory Field!!");
            }
        }
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
        loadGridView.Caption = fileName;
        loadGridView.DataSource = destinationTable;
        loadGridView.DataBind();
        lbl_up_status.Text = loadGridView.Rows.Count.ToString() + " record Found!";
        IsFileUploaded.Value = "true";
    }

    protected void cancelUploadListButton_Click(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }
    protected void refreshButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../SInventory_UI/CustomerTagChangeExcelUpload.aspx");
    }
    protected void HomeButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../CommonUI/HomePage.aspx");
    }
}