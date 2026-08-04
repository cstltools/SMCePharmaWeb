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

public partial class SInventory_UI_MIGO_Upload : System.Web.UI.Page
{
    ExcelUpForMIGOBLL aExcelUpForMIGOBLL = new ExcelUpForMIGOBLL();
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
        try
        {
            foreach (GridViewRow row in loadGridView.Rows)
            {
               // CheckBox ChkBoxRows = (CheckBox)row.FindControl("chkRow");
               // if (ChkBoxRows.Checked)
                {
                    String ShipToParty = row.Cells[1].Text.Trim();
                    String PONo = row.Cells[2].Text.Trim();
                    DateTime PODate = Convert.ToDateTime(row.Cells[3].Text.Trim());
                    String ItemNo = row.Cells[4].Text.Trim();
                    String OrderDocNo = row.Cells[5].Text.Trim();
                    DateTime OrderDocDate = Convert.ToDateTime(row.Cells[6].Text.Trim());
                    String DeliveryDocNo = row.Cells[7].Text.Trim();
                    DateTime DeliveryDocDate = Convert.ToDateTime(row.Cells[8].Text.Trim());
                    String LMID = (row.Cells[9].Text.Trim());
                    String LMIDDescription = row.Cells[10].Text.Trim();
                    String Batch = row.Cells[11].Text.Trim();
                    DateTime ExpDate = Convert.ToDateTime(row.Cells[12].Text.Trim());
                    DateTime MfgDate = Convert.ToDateTime(row.Cells[13].Text.Trim());
                    decimal Qty = Convert.ToDecimal(row.Cells[14].Text.Trim());
                    String VATChallan = row.Cells[15].Text.Trim();
                    String BilltoParty = row.Cells[16].Text.Trim();
                    String InvoiceNo = row.Cells[17].Text.Trim();
                    DateTime InvoiceDate = Convert.ToDateTime(row.Cells[18].Text.Trim());
                    String CaseNoofShipper = row.Cells[19].Text.Trim();
                    decimal VAT = Convert.ToDecimal(row.Cells[20].Text.Trim());
                    decimal Amount = Convert.ToDecimal(row.Cells[21].Text.Trim());
                    decimal Total = Convert.ToDecimal(row.Cells[22].Text.Trim());
                    String TransportNo = row.Cells[23].Text.Trim();
                    //if (aDuplicateMailCheckBll.CheckAgentMail(AgentMail.Trim()) == true)
                    {
                        aExcelUpForMIGOBLL.XLDataGridToDbByRow(ShipToParty, PONo, PODate, ItemNo, OrderDocNo,
                                                          OrderDocDate, DeliveryDocNo, DeliveryDocDate, LMID, LMIDDescription, Batch, ExpDate, MfgDate, Qty, VATChallan,
                                                          BilltoParty, InvoiceNo, InvoiceDate, CaseNoofShipper, VAT, Amount, Total, TransportNo, MigoMasterID);
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
                MigoMasterID = aExcelUpForMIGOBLL.SaveMigo(aMigoMasterDAO);
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
        Response.Redirect("../SInventory_UI/MIGO_Upload.aspx");
    }
    protected void HomeButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../CommonUI/HomePage.aspx");
    }
}