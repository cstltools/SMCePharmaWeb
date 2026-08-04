using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DeliveryExcelUpload : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitialGrid();
            Todate();
            ReqNo();
            DropDownLoad();

            if (!string.IsNullOrEmpty(Request.QueryString["MasID"]))
            {
                GetOneRecord(Convert.ToInt32(Request.QueryString["MasID"]));

            }
        }
    }

    private void GetOneRecord(Int32 id)
    {

        using (DataTable dt = aRequisitionBll.GetDataInfoByIdBll(id))
        {
            submitButton.Text = "Update";
            submitButton.BackColor = Color.DodgerBlue;
            Int32 rowIndex = 0;
            hiddenField.Value = dt.Rows[rowIndex].Field<Int32>("ReqId").ToString();
            manufacturerDropDownList.SelectedValue = dt.Rows[0]["ManufacId"].ToString();
            reqNoTextBox.Text = dt.Rows[0]["ReqNo"].ToString();
            reqDateTextBox.Text = //dt.Rows[0]["ReqDate"].ToString();
                Convert.ToDateTime(dt.Rows[0]["ReqDate"].ToString()).ToString("dd-MMM-yyyy");

            wareHouseDropDownList.SelectedValue = dt.Rows[0]["WarehouseId"].ToString();
            dcDropDownList.SelectedValue = dt.Rows[0]["ComUnitId"].ToString();
            using (DataTable dtSizeDetail = aRequisitionBll.GetDataInfoByIdBllDtls(id))
            {
                
                //Rebind the Grid with the current data to reflect changes   
                productGridView.DataSource = dtSizeDetail;
                productGridView.DataBind();


            }
        }
    }

    private
       void DropDownLoad()
    {
        aRequisitionBll.LoadmanufacturerName(manufacturerDropDownList);
        aRequisitionBll.WareHouseLoad(wareHouseDropDownList);
        aRequisitionBll.DCLoad(dcDropDownList);
        wareHouseDropDownList.SelectedIndex = 1;
        manufacturerDropDownList.SelectedIndex = 1;
    }
    private void ReqNo()
    {

        reqNoTextBox.Text = aRequisitionBll.ReqNo();
    }
    private void Todate()
    {
        reqDateTextBox.Text = Convert.ToDateTime(DateTime.Today.ToShortDateString()).ToString("dd-MMM-yyyy");
    }
    private void InitialGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("CStock");

        aDataTable.Columns.Add("ProformaInvoiceNo");
        aDataTable.Columns.Add("Amount");

        DataRow dataRow;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = "1";
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["PackSize"] = "";
        dataRow["Quantity"] = "";

        dataRow["ProformaInvoiceNo"] = "";
        dataRow["Amount"] = "";

        aDataTable.Rows.Add(dataRow);

        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();

        //foreach (GridViewRow row in productGridView.Rows)
        //{
        //    TextBox productTextBox = (TextBox)productGridView.Rows[row.RowIndex].Cells[3].FindControl("productNameTextBox");
        //    AjaxControlToolkit.AutoCompleteExtender modal = (AjaxControlToolkit.AutoCompleteExtender)productTextBox.FindControl("productNameTextBox_AutoCompleteExtender");
        //    modal.ContextKey = manufacturerDropDownList.SelectedValue;
        //}
       
    }

    private void AddRowInGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("CStock");

        DataRow dataRow;

        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                dataRow = aDataTable.NewRow();
                dataRow["SL"] = Convert.ToString(i + 1);
                TextBox productCodeTextBox = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                dataRow["ProductCode"] = productCodeTextBox.Text.Trim();
                TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                dataRow["ProductName"] = productNameTextBox.Text.Trim();
                TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                dataRow["PackSize"] = packSizeTextBox.Text;
                TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
                dataRow["Quantity"] = quantityTextBox.Text.Trim();
                TextBox cstockTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("cstockTextBox");
                dataRow["CStock"] = cstockTextBox.Text.Trim();
                aDataTable.Rows.Add(dataRow);
            }
        }
        int sl = aDataTable.Rows.Count;

        dataRow = aDataTable.NewRow();

        dataRow["SL"] = Convert.ToString(sl + 1);
        dataRow["ProductCode"] = "";
        dataRow["ProductName"] = "";
        dataRow["PackSize"] = "";
        dataRow["Quantity"] = "";
        aDataTable.Rows.Add(dataRow);


        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();
        //foreach (GridViewRow row in productGridView.Rows)
        //{
        //    TextBox productTextBox = (TextBox)productGridView.Rows[row.RowIndex].Cells[3].FindControl("productNameTextBox");
        //    AjaxControlToolkit.AutoCompleteExtender modal = (AjaxControlToolkit.AutoCompleteExtender)productTextBox.FindControl("productNameTextBox_AutoCompleteExtender");
        //    modal.ContextKey = manufacturerDropDownList.SelectedValue;
        //}
    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        AddRowInGrid();
    }
    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SL");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("CStock");
        DataRow dataRow;

        if (productGridView.Rows.Count > 0)
        {
            int sl1 = 1;
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (i != rowindex)
                {
                    dataRow = aDataTable.NewRow();

                    dataRow["SL"] = Convert.ToString(sl1);
                    TextBox productCodeTextBox2 = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                    dataRow["ProductCode"] = productCodeTextBox2.Text.Trim();
                    TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                    dataRow["ProductName"] = productNameTextBox.Text.Trim();
                    TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                    dataRow["PackSize"] = packSizeTextBox.Text;
                    TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
                    dataRow["Quantity"] = quantityTextBox.Text.Trim();
                    TextBox cstockTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("cstockTextBox");
                    dataRow["CStock"] = cstockTextBox.Text.Trim();
                    aDataTable.Rows.Add(dataRow);
                    sl1 += 1;
                }
            }
        }
        productGridView.DataSource = null;
        productGridView.DataBind();
        productGridView.DataSource = aDataTable;
        productGridView.DataBind();
        if (productGridView.Rows.Count < 1)
        {
            InitialGrid();
        }
        //foreach (GridViewRow row in productGridView.Rows)
        //{
        //    TextBox productTextBox = (TextBox)productGridView.Rows[row.RowIndex].Cells[3].FindControl("productNameTextBox");
        //    AjaxControlToolkit.AutoCompleteExtender modal = (AjaxControlToolkit.AutoCompleteExtender)productTextBox.FindControl("productNameTextBox_AutoCompleteExtender");
        //    modal.ContextKey = manufacturerDropDownList.SelectedValue;
        //}
    }
    private void GetProductInGrid(int rowindex, string productCode)
    {
        DCStoreBLL _aDcStockReceiveBll = new DCStoreBLL();
        DataTable aDataTable = new DataTable();
        if (!string.IsNullOrEmpty(productCode))
        {
            aDataTable = _aDcStockReceiveBll.ProductInfo(productCode,manufacturerDropDownList.SelectedValue);
            if (aDataTable.Rows.Count > 0)
            {
                TextBox productNameTextBox =
                    (TextBox)productGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");
                productNameTextBox.Text = aDataTable.Rows[0]["ProductName"].ToString();
                TextBox packSizeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("packSizeTextBox");
                packSizeTextBox.Text = aDataTable.Rows[0]["PackSize"].ToString();
                DataTable dtqtydata = _aDcStockReceiveBll.GetProductStock(aDataTable.Rows[0]["ProductId"].ToString());
                TextBox cstockTextBox = (TextBox)productGridView.Rows[rowindex].Cells[3].FindControl("cstockTextBox");
                if (dtqtydata.Rows.Count>0)
                {
                    cstockTextBox.Text = dtqtydata.Rows[0][0].ToString();
                }
            }
            else
            {
                showMessageBox("Input Correct Data!!");
                ((TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox")).Text = string.Empty;
            }
        }
    }
    protected void productCodeTextBox_TextChanged(object sender, EventArgs e)
    {



        //DCStoreBLL _aDcStockReceiveBll = new DCStoreBLL();

        //TextBox TextBox = (TextBox)sender;
        //GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        //int rowindex = 0;
        //rowindex = currentRow.RowIndex;
        //TextBox productCodeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");
        //string productName = productCodeTextBox.Text.Trim();
        //if (productName.Contains(':'))
        //{
        //    string[] productInfo = productName.Split(':');

        //    //TextBox productCodeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");

        //    productCodeTextBox.Text = productInfo[0];
        //    //productNameTextBox.Text = productInfo[1];
        //    string productCode = productCodeTextBox.Text.Trim();
        //    GetProductInGrid(rowindex, productCode);
        //}
        //else
        //{
        //    showMessageBox("Input Correct Data!!");
        //    ((TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox")).Text = string.Empty;
        //}
        

        //string productCode = productCodeTextBox.Text.Trim();
        //GetProductInGrid(rowindex, productCode);

    }


    private void SaveAllData()
    {
        string[] companyInfo = dcDropDownList.SelectedItem.Text.Split(':');
        int maxReqId;

        string msg = "";           

        if (hiddenField.Value=="")
        {
            Requesition aRequesition = new Requesition()
            {
                                           
                                           ReqNo = reqNoTextBox.Text.Trim(),
                                           ReqDate = Convert.ToDateTime(reqDateTextBox.Text.Trim()),
                                           WarehouseId = Convert.ToInt32(wareHouseDropDownList.SelectedValue),
                                           WearhouseName = wareHouseDropDownList.SelectedItem.Text.Trim(),
                                           ComUnitId = Convert.ToInt32(dcDropDownList.SelectedValue),
                                           ComUnitCode = companyInfo[0],
                                           ComUnitName = companyInfo[1],
                                           EntryBy = Session["LoginName"].ToString(),
                                           EntryDate = DateTime.Now,
                                           ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
                                       };
            bool requsitionSave = aRequisitionBll.SaveRequsition(aRequesition, out maxReqId);

            List<RequsitionChild> aRequsitionChildrenList = new List<RequsitionChild>();

            for (int i = 0; i < productGridView.Rows.Count; i++)
            {

                TextBox productCodeTextBox = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
                RequsitionChild aRequsitionChild = new RequsitionChild();
                aRequsitionChild.ProductCode = productCodeTextBox.Text.Trim().ToUpper();
                aRequsitionChild.ProductName = productNameTextBox.Text.Trim();
                aRequsitionChild.PackSize = packSizeTextBox.Text.Trim();
                aRequsitionChild.ReqQty = Convert.ToDecimal(quantityTextBox.Text.Trim());
                aRequsitionChild.ReqId = maxReqId;

                aRequsitionChildrenList.Add(aRequsitionChild);
            }

              msg = aRequisitionBll.SaveRequsitionChild(aRequsitionChildrenList);
        }
        else
        {
            Requesition aRequesition = new Requesition()
            {
                ReqId = Convert.ToInt32(hiddenField.Value),
                ReqNo = reqNoTextBox.Text.Trim(),
                ReqDate = Convert.ToDateTime(reqDateTextBox.Text.Trim()),
                WarehouseId = Convert.ToInt32(wareHouseDropDownList.SelectedValue),
                WearhouseName = wareHouseDropDownList.SelectedItem.Text.Trim(),
                ComUnitId = Convert.ToInt32(dcDropDownList.SelectedValue),
                ComUnitCode = companyInfo[0],
                ComUnitName = companyInfo[1],
                UpdateBy = Session["LoginName"].ToString(),
                UpdateDate = DateTime.Now,
                ManufacId = Convert.ToInt32(manufacturerDropDownList.SelectedValue),
            };
            if (aRequisitionBll.UpdateManufacturerInfo(aRequesition))
            {
                aRequisitionBll.DeleteRequisitionDtls(hiddenField.Value);


                List<RequsitionChild> aRequsitionChildrenList = new List<RequsitionChild>();

                for (int i = 0; i < productGridView.Rows.Count; i++)
                {

                    TextBox productCodeTextBox = (TextBox)productGridView.Rows[i].Cells[1].FindControl("productCodeTextBox");
                    TextBox productNameTextBox = (TextBox)productGridView.Rows[i].Cells[2].FindControl("productNameTextBox");
                    TextBox packSizeTextBox = (TextBox)productGridView.Rows[i].Cells[3].FindControl("packSizeTextBox");
                    TextBox quantityTextBox = (TextBox)productGridView.Rows[i].Cells[4].FindControl("reqQtyTextBox");
                    RequsitionChild aRequsitionChild = new RequsitionChild();
                    aRequsitionChild.ProductCode = productCodeTextBox.Text.Trim().ToUpper();
                    aRequsitionChild.ProductName = productNameTextBox.Text.Trim();
                    aRequsitionChild.PackSize = packSizeTextBox.Text.Trim();
                    aRequsitionChild.ReqQty = Convert.ToDecimal(quantityTextBox.Text.Trim());
                    aRequsitionChild.ReqId = Convert.ToInt32(hiddenField.Value);

                    aRequsitionChildrenList.Add(aRequsitionChild);
                }

                msg = aRequisitionBll.SaveRequsitionChild(aRequsitionChildrenList);
            }

        }

       
        Clear();
        showMessageBox(msg);
    }

    public bool Validation()
    {
        if (manufacturerDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select Manufacturer !!!");
            manufacturerDropDownList.Focus();
            manufacturerDropDownList.BackColor = Color.GhostWhite;
            return false;
        }
        if (wareHouseDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select WareHouse !!!");
            wareHouseDropDownList.Focus();
            wareHouseDropDownList.BackColor = Color.GhostWhite;
            return false;
        }
        if (dcDropDownList.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution Center  !!!");
            dcDropDownList.Focus();
            dcDropDownList.BackColor = Color.GhostWhite;
            return false;
        }
        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("reqQtyTextBox")).Focus();
                    showMessageBox("Please fill out Req.Qty!!");
                    return false;
                }
            }
        }
        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("productCodeTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("productCodeTextBox")).Focus();
                    showMessageBox("Please fill out productCode!!");
                    return false;
                }
            }
        }
        if (productGridView.Rows.Count > 0)
        {
            for (int i = 0; i < productGridView.Rows.Count; i++)
            {
                if (((TextBox)productGridView.Rows[i].FindControl("productNameTextBox")).Text == "")
                {
                    ((TextBox)productGridView.Rows[i].FindControl("productNameTextBox")).Focus();
                    showMessageBox("Please fill out productName!!");
                    return false;
                }
            }
        }
        return true;
    }
    private void SenMailForApprved(int forEmpID, string mSubject, string mBody)
    {

        var ForMailAddress = "";

        if (ForMailAddress != "")
        {
            System.Threading.Thread.Sleep(100);

            MailMessage mail = new MailMessage();




            SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");

            mail.From = new MailAddress(Session["EmailID"].ToString());
            try
            {
                mail.To.Add(ForMailAddress.Trim());
            }
            catch (Exception)
            {
                //throw;
            }
            mail.Subject = mSubject;
            mail.Body =
                "<div style='background-color: #DFF0D8; border-style: solid; border-color: #39B3D7; color: black; padding: 25px; border-radius: 15px 50px 30px 5px;'> <br/>" +
                WebUtility.HtmlDecode(mBody)
                +
                "</div>";

            //Attach file using FileUpload Control and put the file in memory stream

            mail.IsBodyHtml = true;
            mail.Priority = System.Net.Mail.MailPriority.High;

            SmtpServer.Port = 587;
            SmtpServer.Credentials = new System.Net.NetworkCredential(Session["EmailID"].ToString(),
                Session["AppPass"].ToString());
            SmtpServer.EnableSsl = true;


            try
            {
                SmtpServer.Send(mail);
            }
            catch (System.Net.Mail.SmtpException ex)
            {
                showMessageBox("Email has not Sent, Try Once More time");
            }
            catch (Exception exe)
            {
                showMessageBox("Email has not Sent, Try Once More time");
            }


            System.Threading.Thread.Sleep(100);
        }



    }

    public void email()

   {
        try
        {
            //  smtp.Send;
            MailMessage mail = new MailMessage();
            SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");

            mail.From = new MailAddress("no-reply@smc-bd.org");
            mail.To.Add("cwh@smc-bd.org");
            mail.Subject = "Challan Generation";
            mail.Body = "A Stock Transfer Order has been generated. Please complete Challan";

            SmtpServer.Port = 587;
            SmtpServer.Credentials = new System.Net.NetworkCredential("no-reply@smc-bd.org", "smc12345");
            SmtpServer.EnableSsl = true;

            SmtpServer.Send(mail);
         //     MessageBox.Show("mail Send");
        }
        catch (Exception)
        {
            
            //throw;
        }      
    }
    public void email2()
    {
        try
        {
            //  smtp.Send;
            MailMessage mail = new MailMessage();
            SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");

            mail.From = new MailAddress("no-reply@smc-bd.org");
            mail.To.Add("habibur.rahman@smc-bd.org");
            mail.Subject = "Challan Generation";
            mail.Body = "A Stock Transfer Order has been generated. Please complete Challan";

            SmtpServer.Port = 587;
            SmtpServer.Credentials = new System.Net.NetworkCredential("no-reply@smc-bd.org", "smc12345");
            SmtpServer.EnableSsl = true;

            SmtpServer.Send(mail);
            //     MessageBox.Show("mail Send");
        }
        catch (Exception)
        {

            //throw;
        }
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        InvoiceBLL aInvoiceBll = new InvoiceBLL();

        int status = 0;

        for (int i = 0; i < productGridView.Rows.Count; i++)
        {
             status = aInvoiceBll.SaveFullInvoice((((TextBox)productGridView.Rows[i].Cells[0].FindControl("productCodeTextBox")).Text).Trim(),
                Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
        }
        if (status == 1)
        {
            showMessageBox("Delivery Invoice Save Successfully");
            InitialGrid();
        }


    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void Clear()
    {
       // manufacturerDropDownList.SelectedValue = "";
        InitialGrid();
        Todate();
        ReqNo();
        DropDownLoad();
    }
    protected void productNameTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox TextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)TextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        TextBox productNameTextBox = (TextBox)productGridView.Rows[rowindex].Cells[2].FindControl("productNameTextBox");

        string productName = productNameTextBox.Text.Trim();
        if (productName.Contains(':'))
        {
            string[] productInfo = productName.Split(':');

            TextBox productCodeTextBox = (TextBox)productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox");

            productCodeTextBox.Text = productInfo[0];
            //productNameTextBox.Text = productInfo[1];
            string productCode = productCodeTextBox.Text.Trim();
            GetProductInGrid(rowindex, productCode);
        }
        else
        {
            showMessageBox("Input Correct Data!!");
            ((TextBox) productGridView.Rows[rowindex].Cells[1].FindControl("productCodeTextBox")).Text = string.Empty;
        }
    }
    protected void miaImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("OrderRequisitionView.aspx");
    }
    protected void manufacturerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        InitialGrid();
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
        productGridView.Caption = fileName;
        productGridView.DataSource = destinationTable;
        productGridView.DataBind();
        lbl_up_status.Text = productGridView.Rows.Count.ToString() + " record Found!";
        IsFileUploaded.Value = "true";
    }

    protected void viewLinkButton_Click(object sender, EventArgs e)
    {

    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("DeliveryExcelUpload.aspx");
    }
}