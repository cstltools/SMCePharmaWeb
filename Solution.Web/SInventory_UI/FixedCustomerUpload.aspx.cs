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
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_FixedCustomerUpload : System.Web.UI.Page
{
    FixedCustomerUploadDal aDal = new FixedCustomerUploadDal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }

    protected void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void loadGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        for (int i = 0; i < e.Row.Cells.Count; i++)
        {
            if (e.Row.Cells[i].Text == "&nbsp;")
                e.Row.Cells[i].BackColor = Color.Orange;
        } 
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        if (id_fu.PostedFile.FileName != "")
        {
            ExcelToGrid();
        }
        else
        {
            ShowMessageBox("Upload File !!");
        }
        
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

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            if (SaveCustomerData() > 0)
            {
                ShowMessageBox("Operation Successfully Done !!!");

                documentDateTextBox.Text = "";
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
        }
    }

    private int SaveCustomerData()
    {
        string date = documentDateTextBox.Text;
        string code;
        int id = 0;
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            code = "";
            code = loadGridView.Rows[i].Cells[1].Text.Trim();
            id = aDal.SaveFixedCustomer(date, code);

            if (id > 0)
            {
                aDal.UpdateFixedCustomer(code);
            }
        }

        return id;
    }

    private bool Validation()
    {
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            if (loadGridView.Rows[i].Cells[1].Text.Trim() == "")
            {
                ShowMessageBox("Field Cannot be Blank !!");
                return false;
            }
        }

        if (documentDateTextBox.Text == "")
        {
            ShowMessageBox("Select Document Upload Date !!");
            documentDateTextBox.Focus();
            return false;
        }
        
        if (loadGridView.Rows.Count == 0)
        {
            ShowMessageBox("Upload File !!");
            return false;
        }

        return true;
    }

    protected void cancelUploadListButton_Click(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
    }

    protected void refreshButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("FixedCustomerUpload.aspx");
    }


    protected void regularButton_Click(object sender, EventArgs e)
    {
        if (UpdateRegularCustomerData())
        {
            ShowMessageBox("Operation Successfully Done !!!");

            documentDateTextBox.Text = "";
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }

    private bool UpdateRegularCustomerData()
    {
        string code;
        bool status = false;
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {          
            code = loadGridView.Rows[i].Cells[1].Text.Trim();
            status = aDal.UpdateRegularCustomer(code);
           
        }

        return status;
    }
}