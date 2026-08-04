using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using OfficeOpenXml;
using System.IO;
using ClosedXML.Excel;
using System.Text;
using Library.DAL.SInventory_DAL;
using SalesSolution.Web.Models;
using System.Security.Policy;
using Library.DAL.DoctorVisit_DAL;
using Library.DAL.DoctorModule_DAL;
using DocumentFormat.OpenXml.VariantTypes;

public partial class SInventory_UI_DynamicSalesReport : System.Web.UI.Page
{
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
    ProductBLL aProductBLL = new ProductBLL();
    InvoiceDAL aInvoiceDal = new InvoiceDAL();
    private static DoctorDAL _DoctorDAL = new DoctorDAL();
    public static SetupDAL _setupDAL = new SetupDAL();
    public static DoctorVisitDAL _DoctorVisit_DAL = new DoctorVisitDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            todateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            LoadDropDown();
            gvSelectedItems.Visible = false;
            PopulateMonthDropdown();
            PopulateYearDropdown();
            rbDTWise_SelectedIndexChanged(null, null);
        }
    }

    private int GetColumnIndexByHeaderText(string headerText)
    {
        // Find column index by header text
        for (int i = 0; i < gvSelectedItems.Columns.Count; i++)
        {
            if (gvSelectedItems.Columns[i].HeaderText == headerText)
            {
                return i;
            }
        }
        return -1; // Column not found
    }


    protected void OnLinkButtonClick(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string clickedText = btn.Text;
        // আপনার লজিক এখানেই লিখবেন, যেমন clickedText অনুযায়ী কাজ করা
    }
    protected void btnShowGrid_Click(object sender, EventArgs e)
    {

        string Area = ""; string Terr = "";
        string Type = "";
        string ZonId = "";
        string grpId = "";

        Terr = TeritorySelect.SelectedValue;
        Area = AreaSelect.SelectedValue;
        ZonId = ZoneSelect.SelectedValue;
        grpId = GroupSelect.SelectedValue;

        //GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        //ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        //AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        //TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        //SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        //MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;

        foreach (ListItem item in cblHeader.Items)
        {
            int columnIndex = GetColumnIndexByHeaderText(item.Text);

            if (columnIndex != -1)
            {
                // Show or hide the column based on selection
                gvSelectedItems.Columns[columnIndex].Visible = item.Selected;
            }
        }
        // Fetch data from the database
        DataTable  comUnitDetailDataTable = _DAL.GetDynamicSalesReportListDAL(Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()), Convert.ToDateTime(todateTextBox.Text.Trim()), Type, grpId, ZonId, Area, Terr);

        if (comUnitDetailDataTable == null || comUnitDetailDataTable.Rows.Count == 0)
        {
            gvSelectedItems.Visible = false;
            return;
        }

         
        // Bind data to GridView
        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gvSelectedItems.DataSource = comUnitDetailDataTable;
            gvSelectedItems.DataBind();
            gvSelectedItems.Visible = true;
        }
        else
        {
            gvSelectedItems.Visible = false;
        }
    }

    

    protected void btnClose_Click(object sender, EventArgs e)
    {
        mpePopup.Hide(); // Hide modal on close button click
    }

    private void PopulateMonthDropdown()
    {
        ddlMonth.Items.Clear();
        ddlMonth.Items.Add(new ListItem("Select Month", "")); // Placeholder

        string[] monthNames =
        {
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        };

        int currentMonth = DateTime.Now.Month;

        for (int i = 0; i < 12; i++)
        {
            ListItem item = new ListItem(monthNames[i], (i + 1).ToString());
            if ((i + 1) == currentMonth)
                item.Selected = true; // Select the current month

            ddlMonth.Items.Add(item);
        }
    }

    private void PopulateYearDropdown()
    {
        ddlYear.Items.Clear();
        ddlYear.Items.Add(new ListItem("Select Year", "")); // Placeholder

        int currentYear = DateTime.Now.Year;

        for (int i = currentYear - 10; i <= currentYear + 5; i++) // Range: Last 10 years to Next 5 years
        {
            ListItem item = new ListItem(i.ToString(), i.ToString());
            if (i == currentYear)
                item.Selected = true; // Select the current year

            ddlYear.Items.Add(item);
        }
    }
    protected void chkRpt_OnCheckedChanged(object sender, EventArgs e)
    {

        for (int i = 0; i < cblHeader.Items.Count; i++)
        {
            if (chkRpt.Checked)
            {
                cblHeader.Items[i].Selected = true;
            }
            else
            {
                cblHeader.Items[i].Selected = false
                    ;
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
    public void LoadDropDown()
    {
        try
        {
            OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
            aOtherStockActionBLL.DCLoad(dcDropDownList1);

            aProductBLL.LoadProductSQ(ddlBrandName);
        }
        catch { }
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProformaReport.aspx");
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        LoadData();

        //Session["ProformaReport"] = "";
        //Session["ProformaReport"] = 0;

        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        //{
        //    if (todateTextBox.Text == "")
        //    {
        //        InvoiceDateTextBox.Text = todateTextBox.Text;
        //    }

        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string districtId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
    }

    private void LoadData()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetProformaInvoListDAL(Parm());


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = comUnitDetailDataTable;
            loadGridView.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblCount.Text = "Total Net Amount : " +   total2.ToString("N2");

        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
            lblCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }
    private string InvoiceParm(string TerritoryId)
    {

        string param = "";

        //if (dcDropDownList1.SelectedValue != "")
        //{
        //    param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
        //}

        //param = param + " AND ct.CustomerCategoryId=2 ";


        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TerritoryId != "")
        {
            param = param + " AND mas.TerritoryId='" + TerritoryId + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        }


        return param;
    }


    private string TotalDoctorParm(string TerritoryId)
    {

        string param = "";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DM.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }

        if (TerritoryId != "")
        {
            param = param + " AND Tr.TerritoryId='" + TerritoryId + "' ";
        }

        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }


    private string TotalNoOfBspParm(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "2";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DM.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }

        if (TerritoryId != "")
        {
            param = param + " AND Tr.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND DM.ProgramTypeId='" + ProgramTypeId + "' ";

        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string TotalNoOfGspParm(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "1";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DM.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }

        if (TerritoryId != "")
        {
            param = param + " AND Tr.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND DM.ProgramTypeId='" + ProgramTypeId + "' ";

        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string TotalNoOfPspParm(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "3";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DM.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }

        if (TerritoryId != "")
        {
            param = param + " AND Tr.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND DM.ProgramTypeId='" + ProgramTypeId + "' ";

        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string TotalNoOfGmpParm(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "4";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}

        if (TerritoryId != "")
        {
            param = param + " AND Tr.TerritoryId='" + TerritoryId + "' ";
        }

        if (ProgramTypeId == "")
        {
            param = param + " AND DM.ProgramTypeId='" + ProgramTypeId + "' ";
        }
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string TotalNoOfHqDoctorParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "4";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}

        if (TerritoryId != "")
        {
            param = param + " AND Tr.TerritoryId='" + TerritoryId + "' ";
        }

        if (ProgramTypeId == "")
        {
            param = param + " AND DM.ProgramTypeId='" + ProgramTypeId + "' ";
        }
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string DCRParam(string TerritoryId)
    {

        string param = "";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND DCR.TerritoryId='" + TerritoryId + "' ";
        }
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string DCRBspParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "2";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND DCR.TerritoryId='" + TerritoryId + "' ";
        }
        param = param + " AND DCR.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string DCRGspParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "1";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND DCR.TerritoryId='" + TerritoryId + "' ";
        }
        param = param + " AND DCR.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string DCRPspParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "3";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND DCR.TerritoryId='" + TerritoryId + "' ";
        }
        param = param + " AND DCR.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string DCRGmpParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "4";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,DCR.EntryDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND DCR.TerritoryId='" + TerritoryId + "' ";
        }
        param = param + " AND DCR.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string RxParam(string TerritoryId)
    {

        string param = "";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND PM.TerritoryId='" + TerritoryId + "' ";
        }
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }
    private string RxBspParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "2";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND PM.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND PM.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }
    private string RxGspParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "1";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND PM.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND PM.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }
    private string RxPspParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "3";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND PM.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND PM.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }
    private string RxGmpParam(string TerritoryId)
    {

        string param = "";
        string ProgramTypeId = "4";
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        //}
        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        //{
        //    param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        //}


        //if (GroupSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        //}

        //if (ZoneSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        //}

        //if (AreaSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        //}
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (TerritoryId != "")
        {
            param = param + " AND PM.TerritoryId='" + TerritoryId + "' ";
        }

        param = param + " AND PM.DoctorProgramypeId='" + ProgramTypeId + "' ";
        //if (SubTeritory.SelectedValue != "")
        //{
        //    param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        //}

        //if (MarketSelect.SelectedValue != "")
        //{
        //    param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        //}


        return param;
    }

    private string RcvParm(string TerritoryId)
    {
        string param = "";


        if (dcDropDownList1.SelectedValue != "")
        {
            param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
        }



        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }
        param = param + " AND cc.TerritoryId='" + TerritoryId + "' ";
        


        return param;
    }
    private string Parm()
    {
        
        string param = "";
        
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }
      

       

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            param = param + " AND mas.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        }


        return param;
    }
    
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
         
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        string Area = ""; string Terr = "";
        string Type = "";
        string ZonId = "";
        string grpId = "";
        Terr = TeritorySelect.SelectedValue;
        Area = AreaSelect.SelectedValue;
        ZonId = ZoneSelect.SelectedValue;
        grpId = GroupSelect.SelectedValue;

        DataTable comUnitDetailDataTable = _DAL.GetDynamicSalesReportListDAL(Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()), Convert.ToDateTime(todateTextBox.Text.Trim()), Type, grpId, ZonId, Area, Terr);

        

        if (comUnitDetailDataTable == null || comUnitDetailDataTable.Rows.Count == 0)
        {

            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);
            return; // No data to export
        }

        DataTable dt = new DataTable();

        // Add selected CheckBoxList items as columns if they exist in the DataTable
        foreach (ListItem item in cblHeader.Items)
        {
            if (item.Selected && comUnitDetailDataTable.Columns.Contains(item.Text))
            {
                dt.Columns.Add(item.Text, typeof(string));
            }
        }

        // Populate rows based on selected columns
        foreach (DataRow row in comUnitDetailDataTable.Rows)
        {
            DataRow newRow = dt.NewRow();
            foreach (DataColumn col in dt.Columns)
            {
                newRow[col.ColumnName] = row[col.ColumnName]; // Assign data from original DataTable
            }
            dt.Rows.Add(newRow);
        }

        // Convert DataTable to CSV
        StringBuilder sb = new StringBuilder();

        // Add column headers
        string[] columnNames = dt.Columns.Cast<DataColumn>().Select(col => "\"" + col.ColumnName + "\"").ToArray();
        sb.AppendLine(string.Join(",", columnNames));

        // Add row data
        foreach (DataRow row in dt.Rows)
        {
            string[] fields = row.ItemArray.Select(field => "\"" + field.ToString().Replace("\"", "\"\"") + "\"").ToArray();
            sb.AppendLine(string.Join(",", fields));
        }

        // Export the CSV file
        string fileName = "DynamicSalesReport_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".csv";
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ContentType = "text/csv";
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
        HttpContext.Current.Response.Write(sb.ToString());
        HttpContext.Current.Response.End();
        

        //if (loadGridView.Rows.Count > 0)
        //{
        //    DataTable dt = new DataTable("GridView_Data");
        //    foreach (TableCell cell in loadGridView.HeaderRow.Cells)
        //    {
        //        dt.Columns.Add(cell.Text);
        //    }
        //    loadGridView.AllowPaging = false;
        //    this.LoadData();
        //    foreach (GridViewRow row in loadGridView.Rows)
        //    {
        //        dt.Rows.Add();
        //        for (int i = 0; i < row.Cells.Count; i++)
        //        {
        //            if (row.Cells[i].Controls.Count > 0)
        //            {
        //                dt.Rows[dt.Rows.Count - 1][i] = (row.Cells[i].Controls[1] as Label).Text;
        //            }
        //            else
        //            {
        //                dt.Rows[dt.Rows.Count - 1][i] = row.Cells[i].Text;
        //            }
        //        }
        //    }
        //    loadGridView.AllowPaging = false;
        //    using (XLWorkbook wb = new XLWorkbook())
        //    {
        //        wb.Worksheets.Add(dt);
        //        Response.Clear();
        //        Response.Buffer = true;
        //        Response.Charset = "";
        //        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        //        Response.AddHeader("content-disposition", "attachment;filename=Invoice_Report_List (Date Range= " + InvoiceDateTextBox.Text + "-" + todateTextBox.Text + ").xlsx");
        //        using (MemoryStream MyMemoryStream = new MemoryStream())
        //        {
        //            wb.SaveAs(MyMemoryStream);
        //            MyMemoryStream.WriteTo(Response.OutputStream);
        //            Response.Flush();
        //            Response.End();
        //        }
        //    }
        //}

        //if (loadGridView.Rows.Count > 0)
        //{


        //    Response.ClearContent();
        //    Response.Buffer = true;
        //    Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "Invoice_Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls"));
        //    Response.ContentType = "application/ms-excel";
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter htw = new HtmlTextWriter(sw);
        //    loadGridView.AllowPaging = false;

        //    this.LoadData();
        //    //Change the Header Row back to white color
        //    loadGridView.HeaderRow.Style.Add("background-color", "#FFFFFF");
        //    //Applying stlye to gridview header cells
        //    //for (int i = 0; i < loadGridView.HeaderRow.Cells.Count; i++)
        //    //{
        //    //    loadGridView.HeaderRow.Cells[i].Style.Add("background-color", "#8BA8E0");
        //    //}
        //    //int j = 1;
        //    ////This loop is used to apply stlye to cells based on particular row
        //    //foreach (GridViewRow gvrow in loadGridView.Rows)
        //    //{
        //    //    gvrow.BackColor = Color.White;
        //    //    if (j <= loadGridView.Rows.Count)
        //    //    {
        //    //        if (j % 2 != 0)
        //    //        {
        //    //            for (int k = 0; k < gvrow.Cells.Count; k++)
        //    //            {
        //    //                gvrow.Cells[k].Style.Add("background-color", "#EFF3FB");
        //    //            }
        //    //        }
        //    //    }
        //    //    j++;
        //    //}

        //    string headerTable = @"<span  style='text-align:center'><h3>  Invoice Report   (Date Range : " + InvoiceDateTextBox.Text + "- " + todateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

        //    HttpContext.Current.Response.Write(headerTable);

        //    loadGridView.RenderControl(htw);
        //    Response.Write(sw.ToString());
        //    Response.End();
        //}
        //else
        //{
        //    showMessageBox("No Data Found!!");
        //}
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

    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        Session["ProformaReport"] = "";
        Session["ProformaReport"] = 1;

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        {
            if (todateTextBox.Text == "")
            {
                InvoiceDateTextBox.Text = todateTextBox.Text;
            }

            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string districtId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
    }

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2021");
        DateTime inputDateTime = Convert.ToDateTime(InvoiceDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("01 April, 2021");
        }
    }



    protected void rbDTWise_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbDTWise.SelectedValue == "Month Wise")
        {
            divmonth.Visible = true;
            divdtRange.Visible = false;
        }
        else
        {
            divmonth.Visible = false;
            divdtRange.Visible = true;
        }
    }


    protected void lbInvoice_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        mpe_1.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadInvoiceList();

    }

    protected void lblTotalDoctor_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        TotalDoctorModalPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadTotalDoctor();

    }

    protected void lblNoofBSP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofBSPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfBsp();

    }

    protected void lblNoofGSP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofGSPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfGsp();

    }

    protected void lblNoofPSP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofPSPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfPsp();

    }

    protected void lblNoofGMP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofGMPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfGmp();

    }

    protected void lblNoOfHQDoctor_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofHQDOCTORPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfHqDoctor();

    }

    protected void lblNoOfExHQDoctor_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofExHQDOCTORPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfExHqDoctor();

    }

    protected void lblNoOfOsDoctor_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        NoofOsDOCTORPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadNoOfOsDoctor();

    }

    protected void lblDcr_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        DCRPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadDCR();

    }

    protected void lblDcrBsp_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        DCRBspPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadDCRBsp();

    }

    protected void lblDcrGsp_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        DCRGspPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadDCRGsp();

    }

    protected void lblDcrPsp_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        DCRPspPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadDCRPsp();

    }

    protected void lblDcrGmp_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        DCRGmpPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadDCRGmp();

    }

    protected void lblGmpDocotorCoverageMonthly_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        GmpDocotorCoveragePopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadGmpDocotorCoverageMonthly();

    }

    protected void lblDocotorCoverageMonthly_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        DocotorCoverageMonthlyPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadDocotorCoverageMonthly();

    }


    protected void lblRxCovered_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxCoveredPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxCovered();

    }

    protected void lblRxCoveredBSP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxCoveredBSPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxCoveredBSP();

    }

    protected void lblRxCoveredGSP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxCoveredGSPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxCoveredGSP();

    }

    protected void lblRxCoveredPSP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxCoveredPSPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxCoveredPSP();

    }

    protected void lblRxCoveredGMP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxCoveredGMPPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxCoveredGMP();

    }


    protected void lblRxPrescriber_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxPrescriberPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxPrescriber();

    }


    protected void lblRxPrescriberGMP_Ckick(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        RxPrescriberGmpPopupExtender.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadRxPrescriberGMP();

    }



    private string FullCollectionParm()
    {

        string param = "";

        if (dcDropDownList1.SelectedValue != "")
        {
            param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
        }




        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        return param;
    }
    private string FullCollectionNewParm()
    {

        string param = "";

        if (dcDropDownList1.SelectedValue != "")
        {
            param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
        }




        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,tblCustPay.custPaymentDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,tblCustPay.custPaymentDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        return param;
    }

    private string FullCollectionParm_2(string TerritoryId)
    {

        string param = "";



        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            param = param + " AND mas.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }
        param = param + " AND mas.TerritoryId='" + TerritoryId + "' ";
        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        }


      


        return param;
    }
    private void LoadFullCollectionData()
    {

        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetFullPaymentDAL(FullCollectionNewParm(), FullCollectionParm(), FullCollectionParm_2(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_FullColection.DataSource = comUnitDetailDataTable;
            gv_FullColection.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblFullCollectionCount.Text = "Total Net Amount : " + total2.ToString("N2");
        }
        else
        {
            gv_FullColection.DataSource = null;
            gv_FullColection.DataBind();
            lblFullCollectionCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }
    private void LoadFCBCollectionData()
    {

        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetFullPaymentDAL(" AND ct.CustomerCategoryId=2 " + FullCollectionNewParm(), FullCollectionParm(), FullCollectionParm_2(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_FCBColection.DataSource = comUnitDetailDataTable;
            gv_FCBColection.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblFCBCollectionCount.Text = "Total Net Amount : " + total2.ToString("N2");
        }
        else
        {
            gv_FCBColection.DataSource = null;
            gv_FCBColection.DataBind();
            lblFCBCollectionCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }
    private void LoadmpeGeneralCollectionData()
    {

        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetFullPaymentDAL(" AND ct.CustomerCategoryId=1 " + FullCollectionNewParm(), FullCollectionParm(), FullCollectionParm_2(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_GeneralColection.DataSource = comUnitDetailDataTable;
            gv_GeneralColection.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblGeneralCollectionCount.Text = "Total Net Amount : " + total2.ToString("N2");
        }
        else
        {
            gv_GeneralColection.DataSource = null;
            gv_FCBColection.DataBind();
            lblGeneralCollectionCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }
   
    private void LoadInstitutionCollectionData()
    {

        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetFullPaymentDAL(" AND ct.CustomerCategoryId=3 " + FullCollectionNewParm(), FullCollectionParm(), FullCollectionParm_2(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_InstitutionColection.DataSource = comUnitDetailDataTable;
            gv_InstitutionColection.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblGeneralCollectionCount.Text = "Total Net Amount : " + total2.ToString("N2");
        }
        else
        {
            gv_InstitutionColection.DataSource = null;
            gv_InstitutionColection.DataBind();
            lblGeneralCollectionCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }
    private void LoadPartialCollectionData()
    {
        DataTable aDataTable = new DataTable();

        aDataTable = aInvoiceDal.GetNewReceiveableDAl(RcvParm(_hfTerritoryId.Value), null, null);

        gv_PartialCollecion.DataSource = aDataTable;
        gv_PartialCollecion.DataBind();


        if (aDataTable.Rows.Count > 0)
        {
            decimal ReturnAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReturnAmount") == null ? 0 : row.Field<decimal>("ReturnAmount"));


            decimal CustomerPaymentAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("CustomerPaymentAmount") == null ? 0 : row.Field<decimal>("CustomerPaymentAmount"));



            decimal ReceivableTotalAmnt = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("ReceivableTotalAmnt") == null ? 0 : row.Field<decimal>("ReceivableTotalAmnt"));
            gv_PartialCollecion.FooterRow.Font.Bold = true;
            gv_PartialCollecion.FooterRow.Cells[12].Text = "Total: ";
            gv_PartialCollecion.FooterRow.Cells[13].Text = ReturnAmount.ToString();
            gv_PartialCollecion.FooterRow.Cells[14].Text = CustomerPaymentAmount.ToString();

            gv_PartialCollecion.FooterRow.Cells[15].Text = ReceivableTotalAmnt.ToString();

            lblPartialInvoiceCount.Text= ReceivableTotalAmnt.ToString();
        }

    }
    private void LoadInvoiceList()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetProformaInvoListDAL(InvoiceParm(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_Invoice.DataSource = comUnitDetailDataTable;
            gv_Invoice.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblInvoiceCount.Text = "Total Net Amount : " + total2.ToString("N2");

        }
        else
        {
            gv_Invoice.DataSource = null;
            gv_Invoice.DataBind();
            lblInvoiceCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }


    private void LoadTotalDoctor()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalDoctorParm(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_TotalDoctor.DataSource = comUnitDetailDataTable;
            gv_TotalDoctor.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblTotalDoctorList.Text = "Total Doctor : " + total2.ToString("N2");

        }
        else
        {
            gv_TotalDoctor.DataSource = null;
            gv_TotalDoctor.DataBind();
            lblTotalDoctorList.Text = "Total Doctor : " + 0.ToString("N2");

        }
    }

    private void LoadNoOfBsp()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfBspParm(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_NoofBSP.DataSource = comUnitDetailDataTable;
            gv_NoofBSP.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblNoOfBspList.Text = "Total No Of Bsp : " + total2.ToString("N2");

        }
        else
        {
            gv_NoofBSP.DataSource = null;
            gv_NoofBSP.DataBind();
            lblNoOfBspList.Text = "Total No Of Bsp: " + 0.ToString("N2");

        }
    }

    private void LoadNoOfGsp()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfGspParm(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_NoofGSP.DataSource = comUnitDetailDataTable;
            gv_NoofGSP.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblNoOfGspList.Text = "Total No Of Gsp: " + total2.ToString("N2");

        }
        else
        {
            gv_NoofGSP.DataSource = null;
            gv_NoofGSP.DataBind();
            lblNoOfGspList.Text = "Total No Of Gsp: " + 0.ToString("N2");

        }
    }

    private void LoadNoOfPsp()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfPspParm(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_NoofPSP.DataSource = comUnitDetailDataTable;
            gv_NoofPSP.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblNoOfPspList.Text = "Total No Of Psp: " + total2.ToString("N2");

        }
        else
        {
            gv_NoofPSP.DataSource = null;
            gv_NoofPSP.DataBind();
            lblNoOfPspList.Text = "Total No Of Psp: " + 0.ToString("N2");

        }
    }

    private void LoadNoOfGmp()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfGmpParm(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_NoofGMP.DataSource = comUnitDetailDataTable;
            gv_NoofGMP.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblNoOfGmpList.Text = "Total No Of Gmp : " + total2.ToString("N2");

        }
        else
        {
            gv_NoofGMP.DataSource = null;
            gv_NoofGMP.DataBind();
            lblNoOfGmpList.Text = "Total No Of Gmp : " + 0.ToString("N2");

        }
    }

    private void LoadNoOfHqDoctor()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfHqDoctorParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_HqDoctor.DataSource = comUnitDetailDataTable;
            gv_HqDoctor.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblHqDoctorList.Text = "Total Hq Doctor : " + total2.ToString("N2");

        }
        else
        {
            gv_HqDoctor.DataSource = null;
            gv_HqDoctor.DataBind();
            lblHqDoctorList.Text = "Total Hq Doctor : " + 0.ToString("N2");

        }
    }

    private void LoadNoOfExHqDoctor()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfHqDoctorParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_ExHqDoctor.DataSource = comUnitDetailDataTable;
            gv_ExHqDoctor.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblExHqDoctorList.Text = "Total Ex Hq Doctor : " + total2.ToString("N2");

        }
        else
        {
            gv_ExHqDoctor.DataSource = null;
            gv_ExHqDoctor.DataBind();
            lblExHqDoctorList.Text = "Total  Ex Hq Doctor : " + 0.ToString("N2");

        }
    }

    private void LoadNoOfOsDoctor()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DoctorDAL.GetDoctorList(TotalNoOfHqDoctorParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);

        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_OsDoctor.DataSource = comUnitDetailDataTable;
            gv_OsDoctor.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblOsDoctorList.Text = "Total Net : " + total2.ToString("N2");

        }
        else
        {
            gv_OsDoctor.DataSource = null;
            gv_OsDoctor.DataBind();
            lblOsDoctorList.Text = "Total Net : " + 0.ToString("N2");

        }
    }

    private void LoadDCR()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_Dcr.DataSource = comUnitDetailDataTable;
            gv_Dcr.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblDcrList.Text = "Total DCR : " + total2.ToString("N2");

        }
        else
        {
            gv_Dcr.DataSource = null;
            gv_Dcr.DataBind();
            lblDcrList.Text = "Total DCR : " + 0.ToString("N2");

        }
    }

    private void LoadDCRBsp()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRBspParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_DcrBsp.DataSource = comUnitDetailDataTable;
            gv_DcrBsp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblDcrBspList.Text = "Total DCR Bsp : " + total2.ToString("N2");

        }
        else
        {
            gv_DcrBsp.DataSource = null;
            gv_DcrBsp.DataBind();
            lblDcrBspList.Text = "Total DCR Bsp : " + 0.ToString("N2");

        }
    }

    private void LoadDCRGsp()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRGspParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_DcrGsp.DataSource = comUnitDetailDataTable;
            gv_DcrGsp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblDcrGspList.Text = "Total DCR Gsp : " + total2.ToString("N2");

        }
        else
        {
            gv_DcrGsp.DataSource = null;
            gv_DcrGsp.DataBind();
            lblDcrGspList.Text = "Total DCR Gsp : " + 0.ToString("N2");

        }
    }

    private void LoadDCRPsp()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRPspParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_DcrPsp.DataSource = comUnitDetailDataTable;
            gv_DcrPsp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblDcrPspList.Text = "Total DCR Psp : " + total2.ToString("N2");

        }
        else
        {
            gv_DcrPsp.DataSource = null;
            gv_DcrPsp.DataBind();
            lblDcrPspList.Text = "Total DCR Psp : " + 0.ToString("N2");

        }
    }

    private void LoadDCRGmp()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRGmpParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_DcrGmp.DataSource = comUnitDetailDataTable;
            gv_DcrGmp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblDcrGmpList.Text = "Total DCR Gmp : " + total2.ToString("N2");

        }
        else
        {
            gv_DcrGmp.DataSource = null;
            gv_DcrGmp.DataBind();
            lblDcrGmpList.Text = "Total DCR Gmp : " + 0.ToString("N2");

        }
    }

    private void LoadGmpDocotorCoverageMonthly()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_GmpDocotorCoverage.DataSource = comUnitDetailDataTable;
            gv_GmpDocotorCoverage.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblGmpDocotorCoverageList.Text = "Total Gmp Docotor Coverage Monthly : " + total2.ToString("N2");

        }
        else
        {
            gv_GmpDocotorCoverage.DataSource = null;
            gv_GmpDocotorCoverage.DataBind();
            lblGmpDocotorCoverageList.Text = "Total Gmp Docotor Coverage Monthly : " + 0.ToString("N2");

        }
    }

    private void LoadDocotorCoverageMonthly()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _DoctorVisit_DAL.GetDCRList(DCRParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_DocotorCoverageMonthly.DataSource = comUnitDetailDataTable;
            gv_DocotorCoverageMonthly.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblDocotorCoverageMonthlyList.Text = "Total Docotor Coverage Monthly : " + total2.ToString("N2");

        }
        else
        {
            gv_DocotorCoverageMonthly.DataSource = null;
            gv_DocotorCoverageMonthly.DataBind();
            lblDocotorCoverageMonthlyList.Text = "Total Docotor Coverage Monthly : " + 0.ToString("N2");

        }
    }

    private void LoadRxCovered()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxCovered.DataSource = comUnitDetailDataTable;
            gv_RxCovered.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxCoveredList.Text = "Total Rx Covered : " + total2.ToString("N2");

        }
        else
        {
            gv_RxCovered.DataSource = null;
            gv_RxCovered.DataBind();
            lblRxCoveredList.Text = "Total Rx Covered : " + 0.ToString("N2");

        }
    }

    private void LoadRxCoveredBSP()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxBspParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxCoveredBsp.DataSource = comUnitDetailDataTable;
            gv_RxCoveredBsp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxCoveredBspList.Text = "Total Rx Covered BSP : " + total2.ToString("N2");

        }
        else
        {
            gv_RxCoveredBsp.DataSource = null;
            gv_RxCoveredBsp.DataBind();
            lblRxCoveredBspList.Text = "Total Rx Covered BSP : " + 0.ToString("N2");

        }
    }

    private void LoadRxCoveredGSP()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxGspParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxCoveredGsp.DataSource = comUnitDetailDataTable;
            gv_RxCoveredGsp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxCoveredGspList.Text = "Total Rx Covered GSP : " + total2.ToString("N2");

        }
        else
        {
            gv_RxCoveredGsp.DataSource = null;
            gv_RxCoveredGsp.DataBind();
            lblRxCoveredGspList.Text = "Total Rx Covered GSP : " + 0.ToString("N2");

        }
    }

    private void LoadRxCoveredPSP()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxPspParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxCoveredPsp.DataSource = comUnitDetailDataTable;
            gv_RxCoveredPsp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxCoveredPspList.Text = "Total Rx Covered PSP : " + total2.ToString("N2");

        }
        else
        {
            gv_RxCoveredPsp.DataSource = null;
            gv_RxCoveredPsp.DataBind();
            lblRxCoveredPspList.Text = "Total Rx Covered PSP : " + 0.ToString("N2");

        }
    }

    private void LoadRxCoveredGMP()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxGmpParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxCoveredGmp.DataSource = comUnitDetailDataTable;
            gv_RxCoveredGmp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxCoveredGmpList.Text = "Total Rx Covered GMP : " + total2.ToString("N2");

        }
        else
        {
            gv_RxCoveredGmp.DataSource = null;
            gv_RxCoveredGmp.DataBind();
            lblRxCoveredGmpList.Text = "Total Rx Covered GMP : " + 0.ToString("N2");

        }
    }

    private void LoadRxPrescriber()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxPrescriber.DataSource = comUnitDetailDataTable;
            gv_RxPrescriber.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxPrescriberList.Text = "Total Rx Prescriber : " + total2.ToString("N2");

        }
        else
        {
            gv_RxPrescriber.DataSource = null;
            gv_RxPrescriber.DataBind();
            lblRxPrescriberList.Text = "Total Rx Prescriber : " + 0.ToString("N2");

        }
    }

    private void LoadRxPrescriberGMP()
    {
        DataTable comUnitDetailDataTable = new DataTable();

        comUnitDetailDataTable = _setupDAL.Get_PrescriptionList(RxParam(_hfTerritoryId.Value));
        //comUnitDetailDataTable = _DoctorDAL.GetDoctorList(_hfTerritoryId.Value);


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_RxPrescriberGmp.DataSource = comUnitDetailDataTable;
            gv_RxPrescriberGmp.DataBind();

            decimal total2 = comUnitDetailDataTable.Rows.Count;

            lblRxPrescriberGmpList.Text = "Total Rx Prescriber GMP : " + total2.ToString("N2");

        }
        else
        {
            gv_RxPrescriberGmp.DataSource = null;
            gv_RxPrescriberGmp.DataBind();
            lblRxPrescriberGmpList.Text = "Total Rx Prescriber GMP : " + 0.ToString("N2");

        }
    }

    private void LoadFCBInvoiceList()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetProformaInvoListDAL(" AND ct.CustomerCategoryId=2 " + InvoiceParm(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_FCBInvoice.DataSource = comUnitDetailDataTable;
            gv_FCBInvoice.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblFCBInvoiceCount.Text = "Total Net Amount : " + total2.ToString("N2");

        }
        else
        {
            gv_FCBInvoice.DataSource = null;
            gv_FCBInvoice.DataBind();
            lblFCBInvoiceCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }

    
    private void LoadGeneralInvoiceList()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetProformaInvoListDAL(" AND ct.CustomerCategoryId=1 " + InvoiceParm(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_GeneralInvoice.DataSource = comUnitDetailDataTable;
            gv_GeneralInvoice.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblGeneralInvoiceCount.Text = "Total Net Amount : " + total2.ToString("N2");

        }
        else
        {
            gv_GeneralInvoice.DataSource = null;
            gv_GeneralInvoice.DataBind();
            lblGeneralInvoiceCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }
    
    
    private void LoadInstitutionInvoiceList()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetProformaInvoListDAL(" AND ct.CustomerCategoryId=3 " + InvoiceParm(_hfTerritoryId.Value));


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            gv_InstitutionInvoice.DataSource = comUnitDetailDataTable;
            gv_InstitutionInvoice.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblInstitutionInvoiceCount.Text = "Total Net Amount : " + total2.ToString("N2");

        }
        else
        {
            gv_InstitutionInvoice.DataSource = null;
            gv_InstitutionInvoice.DataBind();
            lblInstitutionInvoiceCount.Text = "Total Net Amount : " + 0.ToString("N2");

        }
    }

    protected void btnCloseModal_Click(object sender, EventArgs e)
    {
        mpe_1.Hide();
    }

    protected void btnExportInvoice_Click(object sender, EventArgs e)
    {
        if (gvSelectedItems.Rows.Count > 0)
        {
            // Set the response type to indicate it's a CSV file
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/csv";
            Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
            Response.Charset = "";

            // Create a StringWriter and a CsvWriter
            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            // Render the GridView content
            gvSelectedItems.AllowPaging = false;
            gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
            gvSelectedItems.RenderControl(hw);

            // Write the CSV data to the response stream
            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        }
    }


    protected void btnExportTotalDoctor_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportNoOfBsp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportNoOfGsp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportNoOfPsp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportNoOfGmp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }
    protected void btnExportHqDoctor_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportExHqDoctor_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportDCR_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportDCRBsp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportDCRGsp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportDCRGmp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportGmpDocotorCoverage_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportDocotorCoverageMonthly_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportDCRPsp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportOsDoctor_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void btnExportRxCovered_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }


    protected void btnExportRxCoveredBSP_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }


    protected void btnExportRxCoveredGSP_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }


    protected void btnExportRxCoveredPSP_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }



    protected void btnExportRxCoveredGMP_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }


    protected void btnExportRxPrescriber_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }


    protected void btnExportRxprescriberGmp_Click(object sender, EventArgs e)
    {
        //if (gvSelectedItems.Rows.Count > 0)
        //{
        //    // Set the response type to indicate it's a CSV file
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.ContentType = "application/csv";
        //    Response.AddHeader("Content-Disposition", "attachment;filename=Export.csv");
        //    Response.Charset = "";

        //    // Create a StringWriter and a CsvWriter
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    // Render the GridView content
        //    gvSelectedItems.AllowPaging = false;
        //    gvSelectedItems.DataBind();  // Bind the GridView data to make sure it's ready to export
        //    gvSelectedItems.RenderControl(hw);

        //    // Write the CSV data to the response stream
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        //}
    }

    protected void lblPartialCollection_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        Partialmpe_1.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
       LoadPartialCollectionData();
    }

    protected void lblFullCollection_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        mpeFullCollection.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadFullCollectionData();
    }

    protected void lblFCBInvoice_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        FCBInvoicempe_1.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadFCBInvoiceList();
    }

    protected void lblFCBCollection_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        mpeFCBCollection.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadFCBCollectionData();
    }

    protected void lblCampaignsInvoice_Click(object sender, EventArgs e)
    {

    }

    protected void lblCampaignsCollection_Click(object sender, EventArgs e)
    {

    }

    protected void lblGeneralInvoice_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        GeneralInvoicempe_1.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadGeneralInvoiceList();
    }

    protected void lblGeneralCollection_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        mpeGeneralCollection.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadmpeGeneralCollectionData();
    }

    protected void lblInstitutionInvoice_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        InstitutionInvoicempe_1.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadInstitutionInvoiceList();
    }

    protected void lblInstitutionCollection_Click(object sender, EventArgs e)
    {
        LinkButton lb = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
        int rowID = gvRow.RowIndex;

        HiddenField hfTerritoryId = (HiddenField)gvSelectedItems.Rows[rowID].FindControl("hfTerritoryId");
        mpeInstitutionCollection.Show();
        _hfTerritoryId.Value = hfTerritoryId.Value;
        LoadInstitutionCollectionData();
    }

    protected void lbFullCollectionExport_Click(object sender, EventArgs e)
    {

    }

    protected void FullCollectionClose_Click(object sender, EventArgs e)
    {
        mpeFullCollection.Hide();
    }

    protected void btnPartialCloseModal_Click(object sender, EventArgs e)
    {
        Partialmpe_1.Hide();
    }

    protected void btnExportFCBInvoice_Click(object sender, EventArgs e)
    {

    }

    protected void btnCloseModalFCBInvoice_Click(object sender, EventArgs e)
    {
        FCBInvoicempe_1.Hide();
    }


    protected void btnCloseModalTotalDoctor_Click(object sender, EventArgs e)
    {
        TotalDoctorModalPopupExtender.Hide();
    }

    protected void lbFCBCollectionExport_Click(object sender, EventArgs e)
    {

    }

    protected void FCBCollectionClose_Click(object sender, EventArgs e)
    {
        mpeFCBCollection.Hide();
    }

    protected void btnExportGeneralInvoice_Click(object sender, EventArgs e)
    {

    }

    protected void btnCloseModalGeneralInvoice_Click(object sender, EventArgs e)
    {
        GeneralInvoicempe_1.Hide();
    }

    protected void lbGeneralCollectionExport_Click(object sender, EventArgs e)
    {

    }

    protected void GeneralCollectionClose_Click(object sender, EventArgs e)
    {
        mpeGeneralCollection.Hide();
    }

    protected void btnExportInstitutionInvoice_Click(object sender, EventArgs e)
    {

    }

    protected void btnCloseModalInstitutionInvoice_Click(object sender, EventArgs e)
    {
        InstitutionInvoicempe_1.Hide();
    }

    protected void btnCloseModalNoOfBsp_Click(object sender, EventArgs e)
    {
        NoofBSPPopupExtender.Hide();
    }

    protected void btnCloseModalNoOfGsp_Click(object sender, EventArgs e)
    {
        NoofGSPPopupExtender.Hide();
    }

    protected void btnCloseModalNoOfPsp_Click(object sender, EventArgs e)
    {
        NoofPSPPopupExtender.Hide();
    }

    protected void btnCloseModalNoOfGmp_Click(object sender, EventArgs e)
    {
        NoofGMPPopupExtender.Hide();
    }

    protected void btnCloseModalHqDoctor_Click(object sender, EventArgs e)
    {
        NoofHQDOCTORPopupExtender.Hide();
    }

    protected void btnCloseModalExHqDoctor_Click(object sender, EventArgs e)
    {
        NoofExHQDOCTORPopupExtender.Hide();
    }

    protected void btnCloseModalDCR_Click(object sender, EventArgs e)
    {
        DCRPopupExtender.Hide();
    }

    protected void btnCloseModalDCRBsp_Click(object sender, EventArgs e)
    {
        DCRBspPopupExtender.Hide();
    }

    protected void btnCloseModalDCRGsp_Click(object sender, EventArgs e)
    {
        DCRGspPopupExtender.Hide();
    }

    protected void btnCloseModalDCRGmp_Click(object sender, EventArgs e)
    {
        DCRGmpPopupExtender.Hide();
    }

    protected void btnCloseModalDocotorCoverageMonthly_Click(object sender, EventArgs e)
    {
        DocotorCoverageMonthlyPopupExtender.Hide();
    }

    protected void btnCloseModalGmpDocotorCoverage_Click(object sender, EventArgs e)
    {
        GmpDocotorCoveragePopupExtender.Hide();
    }

    protected void btnCloseModalOsDoctor_Click(object sender, EventArgs e)
    {
        NoofOsDOCTORPopupExtender.Hide();
    }

    protected void btnCloseModalDCRPsp_Click(object sender, EventArgs e)
    {
        DCRPspPopupExtender.Hide();
    }
    protected void btnCloseModalRxCovered_Click(object sender, EventArgs e)
    {
        RxCoveredPopupExtender.Hide();
    }

    protected void btnCloseModalRxCoveredBSP_Click(object sender, EventArgs e)
    {
        RxCoveredBSPPopupExtender.Hide();
    }

    protected void btnCloseModalRxCoveredGSP_Click(object sender, EventArgs e)
    {
        RxCoveredGSPPopupExtender.Hide();
    }

    protected void btnCloseModalRxCoveredPSP_Click(object sender, EventArgs e)
    {
        RxCoveredPSPPopupExtender.Hide();
    }

    protected void btnCloseModalRxCoveredGMP_Click(object sender, EventArgs e)
    {
        RxCoveredGMPPopupExtender.Hide();
    }

    protected void btnCloseModalRxPrescriber_Click(object sender, EventArgs e)
    {
        RxPrescriberPopupExtender.Hide();
    }

    protected void btnCloseModalRxprescriberGmp_Click(object sender, EventArgs e)
    {
        RxPrescriberGmpPopupExtender.Hide();
    }

    protected void lbInstitutionCollectionExport_Click(object sender, EventArgs e)
    {

    }

    protected void InstitutionCollectionClose_Click(object sender, EventArgs e)
    {
        mpeInstitutionCollection.Hide();
    }
}