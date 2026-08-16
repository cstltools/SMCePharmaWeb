using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using CrystalDecisions.ReportAppServer.CommonObjectModel;
using Library.DAL.MarketUpload_DAL;
using Library.DAO.MarketUpload_DAO;
using DataTable = System.Data.DataTable;
using ResultInfo = SalesSolution.Web.Models.ResultInfo;


public partial class TransferUI_MarketInfoImport : System.Web.UI.Page
{
    MarketUploadDAL aMarketUploadDal = new MarketUploadDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitialGrid();
        }
    }



    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();

        aDataTable.Columns.Add("territorycode");
        aDataTable.Columns.Add("marketcode");
        aDataTable.Columns.Add("MarketName");

        aDataTable.Columns.Add("Division");
        aDataTable.Columns.Add("District");
        aDataTable.Columns.Add("Thana");
        aDataTable.Columns.Add("RegionalHeadStationType");
        aDataTable.Columns.Add("DZSMStationType");
        aDataTable.Columns.Add("AMStationType");
        aDataTable.Columns.Add("MIOStationType");
        aDataTable.Columns.Add("SalesAssistantStationType");

        DataRow dataRow;

        dataRow = aDataTable.NewRow();


        dataRow["territorycode"] = "";
        dataRow["marketcode"] = "";
        dataRow["MarketName"] = "";
        dataRow["Division"] = "";
        dataRow["District"] = "";
        dataRow["Thana"] = "";
        dataRow["DZSMStationType"] = "";
        dataRow["RegionalHeadStationType"] = "";
        dataRow["AMStationType"] = "";
        dataRow["MIOStationType"] = "";
        dataRow["SalesAssistantStationType"] = "";

        aDataTable.Rows.Add(dataRow);

        dataGridView.DataSource = null;
        dataGridView.DataBind();
        dataGridView.DataSource = aDataTable;
        dataGridView.DataBind();



    }
    public bool Validation()
    {


        if (dataGridView.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Tabel Can not be Empty!" + "','Faild');", true);

        }
        return true;
    }
    private void ExcelToGrid()
    {

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
        string fileName = Path.GetFileName(FilePath);
        //txtSheetName.Text = fileName;

        dataGridView.DataSource = destinationTable;
        dataGridView.DataBind();
        lbl_up_status.CssClass = "alert alert-info";

        lbl_up_status.Text = "File Name:" + fileName + " [ " + dataGridView.Rows.Count.ToString() + " records Found!]";
        IsFileUploaded.Value = "true";
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerImport.aspx");
    }
    protected void btnUpload_OnClick(object sender, EventArgs e)
    {
        try
        {
            if (id_fu.PostedFile.FileName != "")
            {
                ExcelToGrid();
            }

            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Excel file is not a correct format !" + "','Faild');", true);
            }
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Excel file is not a correct format !" + "','Faild');", true);
        }
    }

  
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void Button2_OnClick(object sender, EventArgs e)
    {
        MarketUpload aMarketUpload=new MarketUpload();
        aMarketUpload.MarketPropMasterId = Convert.ToInt32(mainid.Value);
        aMarketUpload.EntryBy = Session["UserId"].ToString();
        aMarketUpload.EntryDate=DateTime.Now;
        aMarketUploadDal.SaveMarketUploadTransfer(aMarketUpload);
        showMessageBox("Transferred");
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            List<MarketUploadDetail> DtlList = new List<MarketUploadDetail>();


            for (int i = 0; i < dataGridView.Rows.Count; i++)
            {
                Label lblterritorycode = (Label)dataGridView.Rows[i].FindControl("lblterritorycode");
                Label lblmarketcode = (Label)dataGridView.Rows[i].FindControl("lblmarketcode");
                Label lblMarketName = ((Label)dataGridView.Rows[i].FindControl("lblMarketName"));
                Label lblDivision = ((Label)dataGridView.Rows[i].FindControl("lblDivision"));
                Label lblDistrict = ((Label)dataGridView.Rows[i].FindControl("lblDistrict"));
                Label lblThana = ((Label)dataGridView.Rows[i].FindControl("lblThana"));
                Label lblDZSMStationType = ((Label)dataGridView.Rows[i].FindControl("lblDZSMStationType"));
                Label lblAMStationType = ((Label)dataGridView.Rows[i].FindControl("lblAMStationType"));
                Label lblMIOStationType = ((Label)dataGridView.Rows[i].FindControl("lblMIOStationType"));
                Label lblSalesAssistantStationType = ((Label)dataGridView.Rows[i].FindControl("lblSalesAssistantStationType"));
                Label lblRegionalHeadStationType = ((Label)dataGridView.Rows[i].FindControl("lblRegionalHeadStationType"));





                MarketUploadDetail _DAO = new MarketUploadDetail();

                _DAO.TerritoryCode = string.IsNullOrEmpty(lblterritorycode.Text.Trim()) ? null : lblterritorycode.Text.Trim();
                _DAO.MarketCode = string.IsNullOrEmpty(lblmarketcode.Text.Trim()) ? null : lblmarketcode.Text.Trim();
                _DAO.MarketName = string.IsNullOrEmpty(lblMarketName.Text.Trim()) ? null : lblMarketName.Text.Trim();

                _DAO.DivisionName = string.IsNullOrEmpty(lblDivision.Text.Trim()) ? null : lblDivision.Text.Trim();
                _DAO.DistrictName = string.IsNullOrEmpty(lblDistrict.Text.Trim()) ? null : lblDistrict.Text.Trim();
                _DAO.ThanaName = string.IsNullOrEmpty(lblThana.Text.Trim()) ? null : lblThana.Text.Trim();
                _DAO.DZSMStationType = string.IsNullOrEmpty(lblDZSMStationType.Text.Trim()) ? null : lblDZSMStationType.Text.Trim();
                _DAO.RegionalHeadStationType = string.IsNullOrEmpty(lblRegionalHeadStationType.Text.Trim()) ? null : lblRegionalHeadStationType.Text.Trim();
                _DAO.AMStationType = string.IsNullOrEmpty(lblAMStationType.Text.Trim()) ? null : lblAMStationType.Text.Trim();
                _DAO.MIOStationType = string.IsNullOrEmpty(lblMIOStationType.Text.Trim()) ? null : lblMIOStationType.Text.Trim();
                _DAO.SalesAssistantStationType = string.IsNullOrEmpty(lblSalesAssistantStationType.Text.Trim()) ? null : lblSalesAssistantStationType.Text.Trim();



                DtlList.Add(_DAO);

            }

            MarketUpload aMarketUpload = new MarketUpload();
            aMarketUpload.EntryBy = Session["UserId"].ToString();
            aMarketUpload.ConvertType = rbType.SelectedValue;


            ResultInfo Res = aMarketUploadDal.SaveMarketInfoForExcel(aMarketUpload, DtlList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {


                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','MarketInfoImport.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }
    }

    protected void viewLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("MarketInfoApprove.aspx");
    }
}
