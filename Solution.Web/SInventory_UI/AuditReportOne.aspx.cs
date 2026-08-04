using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_UI_AuditReportOne : System.Web.UI.Page
{
    AuditReportOneBll aOrderReportBll = new AuditReportOneBll();
    private static OrderTrackingDAL _DAL = new OrderTrackingDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdownlist();
        }
    }

    private void LoadDropdownlist()
    {
        aOrderReportBll.LoadSalesCenter(comUnitNameDropDownList);
        //aOrderReportBll.LoadCustomer(customerDropDownList);
    }

    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    private void Popup()
    {
            
        string rptType = "0";

        if (nationalCheckBox.Checked == false)
        {
            rptType = "1";
        }

        Session["Excel"] = "";
        Session["Excel"] = "N";

        Session["parameter"] = "";
        Session["parameter"] = GenerateParameter();

        string url = "../SInventory_RPTVIEW/AuditReportOneReportViewer.aspx?rptType=" + rptType;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true); ;


    }

    private string GenerateParameter()
    {

        string parameter = " WHERE ";

        if (comUnitNameDropDownList.Text != "")
        {
            if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
            {
                parameter = parameter + "OD.ComUnitCode = '" + comUnitNameDropDownList.Text.Trim() +
                            "' AND OD.DelDate BETWEEN '" + fromDateTextBox.Text.Trim() + "' AND '" +
                            toDateTextBox.Text.Trim() + "' AND '";
            }

            else
            {
                parameter = parameter + "OD.ComUnitCode = '" + comUnitNameDropDownList.Text.Trim() + "' AND '";
            }

        }

        if (comUnitNameDropDownList.Text == "")
        {
            if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
            {
                parameter = parameter + " OD.DelDate BETWEEN '" + fromDateTextBox.Text.Trim() + "' AND'" +
                            toDateTextBox.Text.Trim() +"' AND '";
            }
            else
            {
                parameter = "";
            }           
        }

        string finalParameter = "";

        if (parameter != "")
        {
            finalParameter = parameter.Remove(parameter.Length - 5);
        }

        return finalParameter;
    }

    protected void cancelButton_OnClick(object sender, EventArgs e)
    {
        Clear();
    }

    private void Clear()
    {
      //  MessageLabel.Text = "";
    }

    private void DateValidationCheck(TextBox dateTextBox)
    {
        DateTime temp;
        if (!DateTime.TryParse(dateTextBox.Text, out temp))
        {
            ShowMessageBox("Please select valid date!!!");
            dateTextBox.Text = "";
        }
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (comUnitNameDropDownList.SelectedValue != "" || nationalCheckBox.Checked)
        {
            if (Validation())
            {
                Popup();
                Clear();
            }
        }
        else
        {
             ShowMessageBox("Please select national report or a sales center!!!");
        }
    }

    private bool Validation()
    {
        if (fromDateTextBox.Text != "")
        {
            if (toDateTextBox.Text == "")
            {
                ShowMessageBox("Please select to date");
                return false;
            }
        }
        else if (toDateTextBox.Text != "")
        {
            if (fromDateTextBox.Text == "")
            {
                ShowMessageBox("Please select from date");
                return false;
            }
        }

        return true;
    }

    protected void nationalCheckBox_OnCheckedChanged(object sender, EventArgs e)
    {
        if (nationalCheckBox.Checked)
        {
            comUnitNameDropDownList.SelectedValue = "";
            comUnitNameDropDownList.Enabled = false;
        }
        else
        {
            comUnitNameDropDownList.Enabled = true;
        }
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (Validation())
        {
            ExcelPopUp();
        }
        
    }

    private void ExcelPopUp()
    {
        string rptType = "0";

        if (nationalCheckBox.Checked == false)
        {
            rptType = "1";
        }

        Session["Excel"] = "";
        Session["Excel"] = "Y";

        Session["parameter"] = "";
        Session["parameter"] = GenerateParameter();

        string url = "../SInventory_RPTVIEW/DeleteOrderReportViewer.aspx?rptType=" + rptType;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true); ;
    }

    protected void fromDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateValidationCheck(fromDateTextBox);
    }


    protected void toDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateValidationCheck(toDateTextBox);
    }



    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("AuditReportOne.aspx");
    }
    private string Parm()
    {
        string param = "";



        if (comUnitNameDropDownList.SelectedValue != "")
        {
            param = param + " AND mas.ComUnitId='" + comUnitNameDropDownList.SelectedValue + "' ";
        }

      
        if (fromDateTextBox.Text != "" && toDateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + toDateTextBox.Text + "' ";
        }
        if (fromDateTextBox.Text != "" && toDateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (fromDateTextBox.Text != "" && toDateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,mas.SubmissionDate)  BETWEEN '" + fromDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


 


        return param;
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData(Parm());
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {


        if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Order_Delete_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;

            this.LoadData(Parm());

            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;


            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in loadGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }

            loadGridView.RenderControl(htw);
            string headerTable = @"<span  style='text-align:center'><h3>  Order Delete List  </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";



            HttpContext.Current.Response.Write(headerTable);

            string style = @"<style> .text { mso-number-format:\@; } </style> ";
            Response.Write(style);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }


    }
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void LoadData(string parm)
    {
        DataTable aDataTable = _DAL.GetOrderDelTrackingList(parm);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();



        if (loadGridView.Rows.Count > 0)
        {
            try
            {

                lblOrderCount.Text = aDataTable.Rows.Count.ToString();
                //loadGridView.FooterRow.Cells[4].Text = "Total: ";

                //loadGridView.FooterRow.Cells[4].Font.Bold = true;
                //loadGridView.FooterRow.Cells[5].Font.Bold = true;
                //loadGridView.FooterRow.Cells[6].Font.Bold = true;
                //loadGridView.FooterRow.Cells[7].Font.Bold = true;
                //loadGridView.FooterRow.Cells[8].Font.Bold = true;
                //loadGridView.FooterRow.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                // orderGridView.FooterRow.Cells[2].Text = total.ToString();

                decimal GrossValue = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));


                decimal TotalVat = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalVat") == null ? 0 : row.Field<decimal>("TotalVat"));


                decimal TotalDiscount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalDiscount") == null ? 0 : row.Field<decimal>("TotalDiscount"));


                decimal TotalNetPayable = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

                lblOrderAmount.Text = GrossValue.ToString();
                lblVAT.Text = TotalVat.ToString();
                lblDiscount.Text = TotalDiscount.ToString();
                lblAllTotal.Text = TotalNetPayable.ToString();
            }
            catch (Exception)
            {

                //  throw;
            }
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData(Parm());
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
}