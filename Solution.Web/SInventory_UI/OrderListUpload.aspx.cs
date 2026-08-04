using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_OrderListUpload : System.Web.UI.Page
{
    ExcelUpForOrderListBLL aExcelUpForMIGOBLL = new ExcelUpForOrderListBLL();
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


    private bool XLDataGridToDbByRow(int MasterID)
    {
        try
        {
            foreach (GridViewRow row in loadGridView.Rows)
            {
                // CheckBox ChkBoxRows = (CheckBox)row.FindControl("chkRow");
                // if (ChkBoxRows.Checked)
                {
                    String SalesCentre = row.Cells[1].Text.Trim();
                    String SalesCentreName = row.Cells[2].Text.Trim();
                    String MIOName = (row.Cells[3].Text.Trim());
                    String TerritoryCode = row.Cells[4].Text.Trim();
                    String FECode = row.Cells[5].Text.Trim();
                    String DZSMCode = (row.Cells[6].Text.Trim());
                    String CustomerID = row.Cells[7].Text.Trim();
                    String CustomerName = (row.Cells[8].Text.Trim());
                    String ProductCode = (row.Cells[9].Text.Trim());
                    String ProductName = row.Cells[10].Text.Trim();
                    decimal OrderQty = Convert.ToDecimal(row.Cells[11].Text.Trim());
                    decimal GrossValue = Convert.ToDecimal((row.Cells[12].Text.Trim()));
                    String OrderCode = (row.Cells[13].Text.Trim());
                    DateTime SubmissionDate = Convert.ToDateTime((row.Cells[14].Text.Trim()));
                    String MIOCode = ((row.Cells[15].Text.Trim()));
                    
                    //if (aDuplicateMailCheckBll.CheckAgentMail(AgentMail.Trim()) == true)
                    {
                        aExcelUpForMIGOBLL.XLDataGridToDbByRow(SalesCentre, SalesCentreName, MIOName, TerritoryCode, FECode,
                                                          DZSMCode, CustomerID, CustomerName, ProductCode, ProductName, OrderQty, GrossValue, OrderCode, SubmissionDate,MIOCode,
                                                           MasterID);
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
    private bool CheckValidation()
    {
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
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (CheckValidation() == true)
        {
            if (manufacturerDropDownList.SelectedValue != "" && documentDateTextBox.Text != "")
            {
                OrderListMasterDAO aMigoMasterDAO = new OrderListMasterDAO()
                {
                    ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                    DocumentDate = Convert.ToDateTime(documentDateTextBox.Text.Trim()),
                    GenerateOrder = false,
                    EntryBy = Session["LoginName"].ToString(),
                    EntryDate = DateTime.Now

                };
                int MigoMasterID = 0;
                MigoMasterID = aExcelUpForMIGOBLL.SaveOrder(aMigoMasterDAO);
                if (MigoMasterID > 0)
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
        Response.Redirect("../SInventory_UI/OrderListUpload.aspx");
    }
    protected void HomeButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../CommonUI/HomePage.aspx");
    }
}