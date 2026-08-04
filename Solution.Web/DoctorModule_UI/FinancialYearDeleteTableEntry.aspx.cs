using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.Models;
using System;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_FinancialYearDeleteTableEntry : System.Web.UI.Page
{
    private static UserInfoDAL _userDal = new UserInfoDAL();
    private static FinancialYearDeleteTableDAL _deleteTableDal = new FinancialYearDeleteTableDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadArchiveFinancialYear();
            LoadArchiveDatabase(string.Empty);
            LoadDeleteTableList();
            
            // Initially disable both buttons until financial year is selected
            btnOpening.Enabled = false;
            btnDelete.Enabled = false;
            btnOpening.CssClass = "btn btn-secondary btn-sm me-2";
            btnOpening.Text = "Opening (Select FY)";
            btnDelete.CssClass = "btn btn-secondary btn-sm";
            btnDelete.Text = "Delete (Select FY)";
        }

        ApplyProcessModeSelection();
    }

    private void LoadArchiveFinancialYear()
    {
        try
        {
            using (DataTable dt = _userDal.GetArchiveFinancialYearList())
            {
                ddlArchiveFinancialYear.DataSource = dt;
                ddlArchiveFinancialYear.DataValueField = "FinancialYearId";
                ddlArchiveFinancialYear.DataTextField = "FinancialYearDesc";
                ddlArchiveFinancialYear.DataBind();
                ddlArchiveFinancialYear.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlArchiveFinancialYear.SelectedIndex = 0;
            }
        }
        catch (Exception ex) { }
    }

    private void LoadArchiveDatabase(string financialYearDesc)
    {
        ddlArchiveDatabase.Items.Clear();

        try
        {
            using (DataTable dt = _userDal.GetArchiveDatabaseList(financialYearDesc))
            {
                ddlArchiveDatabase.DataSource = dt;
                ddlArchiveDatabase.DataValueField = "DataBaseName";
                ddlArchiveDatabase.DataTextField = "DataBaseName";
                ddlArchiveDatabase.DataBind();
            }
        }
        catch (Exception ex) { }

        ddlArchiveDatabase.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        ddlArchiveDatabase.SelectedIndex = 0;
    }

    private void LoadDeleteTableList()
    {
        ddlDeleteTable.Items.Clear();
        ddlDeleteTable.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        ddlDeleteTable.Items.Add(new ListItem("Order", "Order"));
        ddlDeleteTable.Items.Add(new ListItem("Invoice", "Invoice"));
        ddlDeleteTable.Items.Add(new ListItem("RX", "RX"));
        ddlDeleteTable.Items.Add(new ListItem("DCR", "DCR"));
        ddlDeleteTable.Items.Add(new ListItem("TourPlan", "TourPlan"));
        ddlDeleteTable.Items.Add(new ListItem("Attendance", "Attendance"));
        ddlDeleteTable.Items.Add(new ListItem("EXPENSE", "EXPENSE")); 
        ddlDeleteTable.Items.Add(new ListItem("DA", "DA"));
        ddlDeleteTable.Items.Add(new ListItem("Leave", "Leave"));
        ddlDeleteTable.Items.Add(new ListItem("Mileage Claim", "Mileage Claim")); 

        ddlDeleteTable.SelectedIndex = 0;
    }

    protected void ddlArchiveFinancialYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadArchiveDatabase(ddlArchiveFinancialYear.SelectedIndex > 0 ? ddlArchiveFinancialYear.SelectedItem.Text : string.Empty);
        
        // Check if opening balance already exists for selected financial year
        if (ddlArchiveFinancialYear.SelectedIndex > 0)
        {
            try
            {
                bool openingBalanceExists = _userDal.IsOpeningBalanceExistsForFinancialYear(ddlArchiveFinancialYear.SelectedValue);
                
                // Control opening button: enabled only if no opening balance exists
                btnOpening.Enabled = !openingBalanceExists;
                if (openingBalanceExists)
                {
                    btnOpening.CssClass = "btn btn-secondary btn-sm me-2";
                    btnOpening.Text = "Opening (Already Done)";
                }
                else
                {
                    btnOpening.CssClass = "btn btn-primary btn-sm me-2";
                    btnOpening.Text = "Opening";
                }
                
                // Control delete button: enabled only if opening balance exists
                btnDelete.Enabled = openingBalanceExists;
                if (openingBalanceExists)
                {
                    btnDelete.CssClass = "btn btn-danger btn-sm";
                    btnDelete.Text = "Delete";
                }
                else
                {
                    btnDelete.CssClass = "btn btn-secondary btn-sm";
                    btnDelete.Text = "Delete (Please Process Opening)";
                    btnDelete.Enabled = false;
                   
                }
                
                if (openingBalanceExists)
                {
                    ShowFailAlert("Opening balance already exists for this financial year. Opening process is disabled, delete process is enabled.");
                }
            }
            catch (Exception ex)
            {
                btnOpening.Enabled = true; // Enable on error to allow retry
                btnDelete.Enabled = false; // Disable delete on error
                btnOpening.CssClass = "btn btn-primary btn-sm me-2";
                btnOpening.Text = "Opening";
                btnDelete.CssClass = "btn btn-secondary btn-sm";
                btnDelete.Text = "Delete (Error)";
            }
        }
        else
        {
            btnOpening.Enabled = false; // Disable when no financial year selected
            btnDelete.Enabled = false;   // Disable delete when no financial year selected
            btnOpening.CssClass = "btn btn-secondary btn-sm me-2";
            btnOpening.Text = "Opening (Select FY)";
            btnDelete.CssClass = "btn btn-secondary btn-sm";
            btnDelete.Text = "Delete (Select FY)";
        }
    }

    protected void btnOpening_Click(object sender, EventArgs e)
    {
        if (!IsOpeningProcessSelected())
        {
            ShowFailAlert("Please select Opening Process.");
            return;
        }

        if (ddlArchiveFinancialYear.SelectedValue == "")
        {
            ShowFailAlert("Please Select Financial Year!");
            return;
        }

        DateTime startDate;
        DateTime endDate;
        string validationMessage;

        if (!TryGetSelectedFinancialYearRange(out startDate, out endDate, out validationMessage))
        {
            ShowFailAlert(validationMessage);
            return;
        }

        try
        {
            var result = _userDal.CreateOpeningBalance(ddlArchiveFinancialYear.SelectedValue, startDate, endDate);

            if (result.isSuccess)
            {
                ShowSuccessAlert(string.Format(
                    "Opening balance created successfully for {0:dd-MMM-yyyy} to {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate), true); // Add reload parameter
                return;
            }

            ShowFailAlert(string.IsNullOrWhiteSpace(result.ErrorMessage) ? "Opening balance creation failed." : result.ErrorMessage);
        }
        catch (Exception ex)
        {
            ShowFailAlert(ex.Message);
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        if (IsOpeningProcessSelected())
        {
            ShowFailAlert("Please select Delete Table or Archive Table.");
            return;
        }

        bool isArchiveMode = IsArchiveProcessSelected();

        if (ddlArchiveFinancialYear.SelectedValue == "" || ddlDeleteTable.SelectedValue == "" || (isArchiveMode && ddlArchiveDatabase.SelectedValue == ""))
        {
            ShowFailAlert(isArchiveMode
                ? "Please Select Financial Year, Database Name and Delete Table!"
                : "Please Select Financial Year and Delete Table!");
            return;
        }

        try
        {
            DateTime startDate;
            DateTime endDate;
            string validationMessage;

            if (!TryGetSelectedFinancialYearRange(out startDate, out endDate, out validationMessage))
            {
                ShowFailAlert(validationMessage);
                return;
            }

            //if (!_userDal.IsArchiveDatabaseAvailable(ddlArchiveDatabase.SelectedValue))
            //{
            //    ShowFailAlert("Selected archive database is not available on server.");
            //    return;
            //}

            string selectedTable = ddlDeleteTable.SelectedValue.Trim();
            ResultInfo result;
            string message;

            if (!TryExecuteDeleteTableProcess(
                selectedTable,
                isArchiveMode,
                ddlArchiveDatabase.SelectedValue,
                startDate,
                endDate,
                out result,
                out message))
            {
                ShowFailAlert("Delete logic is configured only for Order, Invoice, RX, DCR, TourPlan, Attendance and Expense.");
                return;
            }

            if (result.isSuccess)
            {
                ShowSuccessAlert(message);
                return;
            }

            ShowFailAlert(string.IsNullOrWhiteSpace(result.ErrorMessage) ? "Operation failed." : result.ErrorMessage);
        }
        catch (Exception ex)
        {
            ShowFailAlert(ex.Message);
        }
    }

    private bool TryGetFinancialYearRange(int financialYearId, out DateTime startDate, out DateTime endDate)
    {
        startDate = DateTime.MinValue;
        endDate = DateTime.MinValue;

        using (DataTable dt = _userDal.GetArchiveFinancialYearById(financialYearId))
        {
            if (dt == null || dt.Rows.Count == 0)
            {
                return false;
            }

            DataRow row = dt.Rows[0];

            if (row["StartDate"] == DBNull.Value || row["EndDate"] == DBNull.Value)
            {
                return false;
            }

            startDate = Convert.ToDateTime(row["StartDate"]);
            endDate = Convert.ToDateTime(row["EndDate"]);
            return true;
        }
    }

    private bool TryGetSelectedFinancialYearRange(out DateTime startDate, out DateTime endDate, out string errorMessage)
    {
        startDate = DateTime.MinValue;
        endDate = DateTime.MinValue;
        errorMessage = string.Empty;

        int financialYearId;
        if (!int.TryParse(ddlArchiveFinancialYear.SelectedValue, out financialYearId))
        {
            errorMessage = "Invalid Financial Year selected.";
            return false;
        }

        if (!TryGetFinancialYearRange(financialYearId, out startDate, out endDate))
        {
            errorMessage = "Financial year date range not found.";
            return false;
        }

        if (endDate.Date < startDate.Date)
        {
            errorMessage = "Financial year date range is invalid.";
            return false;
        }

        return true;
    }

    private bool TryExecuteDeleteTableProcess(string selectedTable, bool isArchiveMode, string databaseName, DateTime startDate, DateTime endDate, out ResultInfo result, out string message)
    {
        result = new ResultInfo();
        message = string.Empty;

        if (string.Equals(selectedTable, "Order", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBOrderData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveOrderData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "Order data deleted from {0}.dbo.tblOrder/{0}.dbo.tblOrderDetail by SubmissionDate between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "Order data deleted between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        if (string.Equals(selectedTable, "Invoice", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBInvoiceData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveInvoiceData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "Invoice data deleted from {0}.dbo.tblInvoice/{0}.dbo.tblInvoiceDetail by InvoiceDate between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "Invoice data archived into tblInvoiceDeleteArchive/tblInvoiceDetailDeleteArchive and deleted by tblInvoice.InvoiceDate between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        if (string.Equals(selectedTable, "RX", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBRxData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveRxData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "RX data deleted from {0}.dbo.tbl_PrescriptionMaster/{0}.dbo.tbl_PrescriptionProductDetail/{0}.dbo.tblPrescriptionApprovalLog by PrescriptionDate between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "RX data archived into tbl_PrescriptionMasterDeleteArchive/tbl_PrescriptionProductDetailDeleteArchive/tblPrescriptionApprovalLogDeleteArchive and deleted by tbl_PrescriptionMaster.PrescriptionDate between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        if (string.Equals(selectedTable, "DCR", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBDCRData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveDCRData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "DCR data deleted from {0}.dbo.tbl_DCRInfo/{0}.dbo.tbl_DcrDetails/{0}.dbo.tbl_DcrBrandDetails/{0}.dbo.tbl_DcrVisitedWithDetails by DcrDate between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "DCR data archived into tblDCRDeleteArchive/tblDCRDetailDeleteArchive/tblDCRBrandDetailsDeleteArchive/tbl_DcrVisitedWithDetailsDeleteArchive and deleted by DCR date between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        if (string.Equals(selectedTable, "TourPlan", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBTourPlanData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveTourPlanData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "TourPlan data deleted from {0}.dbo.tbl_TourPlanMaster/{0}.dbo.tbl_TourPlanInfo between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "TourPlan data archived into tblTourPlanMasterDeleteArchive/tblTourPlanInfoDeleteArchive and deleted by TourPlan date between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        if (string.Equals(selectedTable, "Attendance", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBAttendanceData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveAttendanceData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "Attendance data deleted from {0}.dbo.tblMarketAttendance_Master_webapi by AttendanceDate between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "Attendance data archived into tblMarketAttendance_Master_webapiDeleteArchive and deleted by Attendance date between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        if (string.Equals(selectedTable, "EXPENSE", StringComparison.OrdinalIgnoreCase))
        {
            result = isArchiveMode
                ? _deleteTableDal.DeleteArchiveDBExpenseData(databaseName, startDate, endDate)
                : _deleteTableDal.DeleteArchiveExpenseData(databaseName, startDate, endDate);
            message = isArchiveMode
                ? string.Format(
                    "Expense data deleted from {0}.dbo.tbl_ExpenseClaim/{0}.dbo.tbl_ExpenseClaimDetails by EntryDate between {1:dd-MMM-yyyy} and {2:dd-MMM-yyyy}.",
                    databaseName,
                    startDate,
                    endDate)
                : string.Format(
                    "Expense data archived into tbl_ExpenseClaimDeleteArchive/tbl_ExpenseClaimDetailsDeleteArchive and deleted by tbl_ExpenseClaim.EntryDate between {0:dd-MMM-yyyy} and {1:dd-MMM-yyyy}.",
                    startDate,
                    endDate);
            return true;
        }

        return false;
    }

    private bool IsOpeningProcessSelected()
    {
        return !string.Equals(rblProcessType.SelectedValue, "Delete", StringComparison.OrdinalIgnoreCase) 
               && !string.Equals(rblProcessType.SelectedValue, "Archive", StringComparison.OrdinalIgnoreCase);
    }

    private bool IsArchiveProcessSelected()
    {
        return string.Equals(rblProcessType.SelectedValue, "Archive", StringComparison.OrdinalIgnoreCase);
    }

    private void ApplyProcessModeSelection()
    {
        bool isOpeningProcess = IsOpeningProcessSelected();
        bool isArchiveProcess = IsArchiveProcessSelected();

        if (isOpeningProcess)
        {
            pnlArchiveDatabaseRow.Style["display"] = "none";
            pnlDeleteTableRow.Style["display"] = "none";
            btnOpening.Style.Remove("display");
            btnDelete.Style["display"] = "none";
        }
        else if (isArchiveProcess)
        {
            pnlArchiveDatabaseRow.Style.Remove("display");
            pnlDeleteTableRow.Style.Remove("display");
            btnOpening.Style["display"] = "none";
            btnDelete.Style.Remove("display");
            btnDelete.Text = "Archive";
            btnDelete.CssClass = "btn btn-warning btn-sm";
        }
        else
        {
            pnlArchiveDatabaseRow.Style["display"] = "none";
            pnlDeleteTableRow.Style.Remove("display");
            btnOpening.Style["display"] = "none";
            btnDelete.Style.Remove("display");
            btnDelete.Text = "Delete";
            btnDelete.CssClass = "btn btn-danger btn-sm";
        }
    }

    private void ShowFailAlert(string message)
    {
        System.Web.UI.ScriptManager.RegisterStartupScript(
            this,
            GetType(),
            "Popup",
            "faildalert('" + HttpUtility.JavaScriptStringEncode(message) + "','Faild');",
            true);
    }

    private void ShowSuccessAlert(string message)
    {
        ShowSuccessAlert(message, false);
    }

    private void ShowSuccessAlert(string message, bool reloadPage)
    {
        string script = "ShowSuccesalert('" + HttpUtility.JavaScriptStringEncode(message) + "','success')";
        
        if (reloadPage)
        {
            script += "; setTimeout(function() { window.location.reload(); }, 2000);";
        }
        
        System.Web.UI.ScriptManager.RegisterStartupScript(
            this,
            GetType(),
            "Popup",
            script,
            true);
    }
}
