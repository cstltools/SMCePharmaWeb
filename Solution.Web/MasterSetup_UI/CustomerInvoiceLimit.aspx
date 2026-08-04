<%@ Page Title="Customer Invoice & Order Limit Setup" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CustomerInvoiceLimit.aspx.cs" Inherits="MasterSetup_UI_CustomerInvoiceLimit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
    <link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" />

    <style type="text/css">
        .ui-autocomplete-loading {
            background: white url('https://jqueryui.com/resources/demos/autocomplete/images/ui-anim_basic_16x16.gif') right center no-repeat;
        }
        .nav-tabs .nav-link.active {
            font-weight: bold;
            border-top: 3px solid #007bff;
        }
    </style>

    <div class="page-wrapper"><div class="page-content"><div class="container-fluid pt-3">
        <h3 class="mb-4">Customer Limit Setup</h3>

        <!-- Nav Tabs -->
        <ul class="nav nav-tabs mb-3" id="limitTabs" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="order-tab" data-toggle="tab" data-bs-toggle="tab" data-target="#orderLimitTab" data-bs-target="#orderLimitTab" href="#orderLimitTab" role="tab" aria-controls="orderLimitTab" aria-selected="true">
                    <i class="fa fa-shopping-cart"></i> Order Limit Setup
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="invoice-tab" data-toggle="tab" data-bs-toggle="tab" data-target="#invoiceLimitTab" data-bs-target="#invoiceLimitTab" href="#invoiceLimitTab" role="tab" aria-controls="invoiceLimitTab" aria-selected="false">
                    <i class="fa fa-file-invoice"></i> Invoice Limit Setup (Not Binding)
                </a>
            </li>
        </ul>

        <div class="tab-content" id="limitTabsContent">
            
            <!-- TAB 1: ORDER LIMIT SETUP -->
            <div class="tab-pane fade show active" id="orderLimitTab" role="tabpanel" aria-labelledby="order-tab">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">Order Limit Entry Form</div>
                    <div class="card-body">
                        <div id="frmInvoiceLimit">
                            <input type="hidden" id="hdnId" value="0" />
                            <input type="hidden" id="hdnCustomerId" value="0" />

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="txtCustomer" class="form-label">Customer <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="txtCustomer" placeholder="Search by Code, Name or Mobile" />
                                    <div class="invalid-feedback">Please select a customer.</div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="txtMaximumInvoiceValue" class="form-label">Maximum Order Value (BDT) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="txtMaximumInvoiceValue" value="50000" />
                                    <div class="invalid-feedback">Maximum Order Value must be greater than 0.</div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="txtRemarks" class="form-label">Remarks</label>
                                    <input type="text" class="form-control" id="txtRemarks" maxlength="250" />
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="ddlStatus" class="form-label">Status</label>
                                    <select id="ddlStatus" class="form-control">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <button type="button" id="btnSave" class="btn btn-success">Save</button>
                                    <button type="button" id="btnUpdate" class="btn btn-primary" disabled="disabled">Update</button>
                                    <button type="button" id="btnDelete" class="btn btn-danger" disabled="disabled">Delete</button>
                                    <button type="button" id="btnClear" class="btn btn-secondary">Clear</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header bg-info text-white">Order Limit List</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="tblList" class="table table-bordered table-striped" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Customer Code</th>
                                        <th>Customer Name</th>
                                        <th>Mobile</th>
                                        <th>Maximum Order Value</th>
                                        <th>Status</th>
                                        <th>Created By</th>
                                        <th>Created Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TAB 2: INVOICE LIMIT SETUP (tblInvoiceNotBinding) -->
            <div class="tab-pane fade" id="invoiceLimitTab" role="tabpanel" aria-labelledby="invoice-tab">
                <div class="card mb-4">
                    <div class="card-header bg-dark text-white">Invoice Limit Entry Form (Not Binding)</div>
                    <div class="card-body">
                        <div id="frmInvoiceNotBinding">
                            <input type="hidden" id="hdnInvoiceNotBindingId" value="0" />
                            <input type="hidden" id="hdnInvCustomerId" value="0" />
                            <input type="hidden" id="hdnInvCustomerCode" value="" />

                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label class="form-label d-block">Apply By <span class="text-danger">*</span></label>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="rdoInvApplyType" id="rdoInvApplyTypeCustomer" value="Customer" checked="checked" />
                                        <label class="form-check-label" for="rdoInvApplyTypeCustomer">Customer Wise</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="rdoInvApplyType" id="rdoInvApplyTypeCustomerType" value="CustomerType" />
                                        <label class="form-check-label" for="rdoInvApplyTypeCustomerType">Customer Type Wise</label>
                                    </div>
                                </div>

                                <div class="col-md-4 mb-3" id="divInvCustomerWise">
                                    <label for="txtInvCustomer" class="form-label">Customer <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="txtInvCustomer" placeholder="Search by Code, Name or Mobile" />
                                    <div class="invalid-feedback">Please select a customer.</div>
                                </div>

                                <div class="col-md-4 mb-3" id="divInvCustomerTypeWise" style="display:none;">
                                    <label for="ddlInvCustomerType" class="form-label">Customer Type <span class="text-danger">*</span></label>
                                    <select id="ddlInvCustomerType" class="form-control">
                                        <option value="0">-- Select Customer Type --</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a customer type.</div>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="txtActiveFromDate" class="form-label">Active From Date <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="txtActiveFromDate" />
                                    <div class="invalid-feedback">Please select active from date.</div>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="txtActiveToDate" class="form-label">Active To Date</label>
                                    <input type="date" class="form-control" id="txtActiveToDate" />
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="txtAllowedNoOfInvoice" class="form-label">Allowed No of Invoice <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="txtAllowedNoOfInvoice" value="4" />
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="txtAllowedCreditLimit" class="form-label">Allowed Credit Limit (BDT) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" class="form-control" id="txtAllowedCreditLimit" value="100000" />
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="txtNumberOfDaysInTransit" class="form-label">Number of Days In-Transit <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="txtNumberOfDaysInTransit" value="45" />
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="txtInvRemarks" class="form-label">Remarks</label>
                                    <input type="text" class="form-control" id="txtInvRemarks" maxlength="250" />
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="ddlInvStatus" class="form-label">Status</label>
                                    <select id="ddlInvStatus" class="form-control">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <button type="button" id="btnInvSave" class="btn btn-success">Save</button>
                                    <button type="button" id="btnInvUpdate" class="btn btn-primary" disabled="disabled">Update</button>
                                    <button type="button" id="btnInvDelete" class="btn btn-danger" disabled="disabled">Delete</button>
                                    <button type="button" id="btnInvClear" class="btn btn-secondary">Clear</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header bg-secondary text-white">Invoice Limit List</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="tblInvList" class="table table-bordered table-striped" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Apply Type</th>
                                        <th>Customer Code</th>
                                        <th>Customer Name</th>
                                        <th>Customer Type</th>
                                        <th>Mobile</th>
                                        <th>Active From</th>
                                        <th>Active To</th>
                                        <th>Allowed Invoices</th>
                                        <th>Allowed Credit Limit</th>
                                        <th>In-Transit Days</th>
                                        <th>Status</th>
                                        <th>Created By</th>
                                        <th>Created Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div></div></div>

    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <script type="text/javascript">
        var dataTable;
        var dataTableInv;

        $(document).ready(function () {
            initDataTable();
            initInvDataTable();

            loadList();
            loadInvList();
            loadCustomerTypeList();

            $('input[name="rdoInvApplyType"]').on('change', function () {
                if ($(this).val() === 'CustomerType') {
                    $("#divInvCustomerWise").hide();
                    $("#divInvCustomerTypeWise").show();
                    $("#txtInvCustomer").val("").removeClass("is-invalid");
                    $("#hdnInvCustomerId").val("0");
                    $("#hdnInvCustomerCode").val("");
                } else {
                    $("#divInvCustomerTypeWise").hide();
                    $("#divInvCustomerWise").show();
                    $("#ddlInvCustomerType").val("0").removeClass("is-invalid");
                }
            });

            // Adjust DataTables layout & toggle tab panes when switching tabs
            $('#limitTabs a').on('click', function (e) {
                e.preventDefault();
                $('#limitTabs a').removeClass('active').attr('aria-selected', 'false');
                $(this).addClass('active').attr('aria-selected', 'true');

                var target = $(this).attr('href') || $(this).attr('data-bs-target') || $(this).attr('data-target');
                $('.tab-pane').removeClass('show active');
                $(target).addClass('show active');

                if ($.fn.dataTable) {
                    $($.fn.dataTable.tables(true)).DataTable().columns.adjust();
                }
            });

            // Set default date for Active From Date to today
            var today = new Date().toISOString().split('T')[0];
            $("#txtActiveFromDate").val(today);

            // Tab 1 Customer Autocomplete
            $("#txtCustomer").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "CustomerInvoiceLimit.aspx/GetCustomerAutoComplete",
                        data: JSON.stringify({ keyword: request.term }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.CustomerCode + ' - ' + item.CustomerName + (item.MobileNo ? ' (' + item.MobileNo + ')' : ''),
                                    value: item.CustomerCode + ' - ' + item.CustomerName,
                                    customerId: item.CustomerId
                                }
                            }));
                        },
                        error: function () {
                            toastr.error("Error loading customers.");
                        }
                    });
                },
                select: function (e, i) {
                    $("#hdnCustomerId").val(i.item.customerId);
                },
                minLength: 2
            }).on("input", function() {
                $("#hdnCustomerId").val("0");
            });

            // Tab 2 Customer Autocomplete
            $("#txtInvCustomer").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "CustomerInvoiceLimit.aspx/GetCustomerAutoComplete",
                        data: JSON.stringify({ keyword: request.term }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.CustomerCode + ' - ' + item.CustomerName + (item.MobileNo ? ' (' + item.MobileNo + ')' : ''),
                                    value: item.CustomerCode + ' - ' + item.CustomerName,
                                    customerId: item.CustomerId,
                                    customerCode: item.CustomerCode
                                }
                            }));
                        },
                        error: function () {
                            toastr.error("Error loading customers.");
                        }
                    });
                },
                select: function (e, i) {
                    $("#hdnInvCustomerId").val(i.item.customerId);
                    $("#hdnInvCustomerCode").val(i.item.customerCode);
                },
                minLength: 2
            }).on("input", function() {
                $("#hdnInvCustomerId").val("0");
                $("#hdnInvCustomerCode").val("");
            });

            // Tab 1 Button Events
            $("#btnSave").click(function () {
                if (validateForm()) { saveData(); }
            });
            $("#btnUpdate").click(function () {
                if (validateForm()) { updateData(); }
            });
            $("#btnDelete").click(function () {
                if (confirm("Are you sure you want to delete this record?")) { deleteData(); }
            });
            $("#btnClear").click(function () { clearForm(); });

            // Tab 2 Button Events
            $("#btnInvSave").click(function () {
                if (validateInvForm()) { saveInvData(); }
            });
            $("#btnInvUpdate").click(function () {
                if (validateInvForm()) { updateInvData(); }
            });
            $("#btnInvDelete").click(function () {
                if (confirm("Are you sure you want to delete this invoice limit record?")) { deleteInvData(); }
            });
            $("#btnInvClear").click(function () { clearInvForm(); });
        });

        // --- TAB 1 FUNCTIONS ---
        function initDataTable() {
            dataTable = $('#tblList').DataTable({
                "columnDefs": [{ "orderable": false, "targets": [0, 8] }]
            });
        }

        function loadList() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/GetList",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    dataTable.clear();
                    var data = response.d;
                    for (var i = 0; i < data.length; i++) {
                        var sl = i + 1;
                        var btnAction = '<button type="button" class="btn btn-sm btn-primary" onclick="editRecord(' + data[i].Id + ')">Edit</button> ' +
                                        '<button type="button" class="btn btn-sm btn-danger" onclick="deleteRecord(' + data[i].Id + ')">Delete</button>';
                        
                        dataTable.row.add([
                            sl,
                            data[i].CustomerCode,
                            data[i].CustomerName,
                            data[i].MobileNo,
                            data[i].MaximumInvoiceValue.toFixed(2),
                            data[i].Status,
                            data[i].CreatedBy,
                            data[i].CreatedDate,
                            btnAction
                        ]);
                    }
                    dataTable.draw();
                },
                error: function () { toastr.error("Failed to load order limit list."); }
            });
        }

        function validateForm() {
            var isValid = true;
            var customerId = $("#hdnCustomerId").val();
            if (customerId == "0" || customerId == "") {
                $("#txtCustomer").addClass("is-invalid");
                isValid = false;
            } else {
                $("#txtCustomer").removeClass("is-invalid");
            }

            var maxValue = parseFloat($("#txtMaximumInvoiceValue").val());
            if (isNaN(maxValue) || maxValue < 1) {
                $("#txtMaximumInvoiceValue").addClass("is-invalid");
                isValid = false;
            } else {
                $("#txtMaximumInvoiceValue").removeClass("is-invalid");
            }
            return isValid;
        }

        function getFormData() {
            return {
                model: {
                    Id: parseInt($("#hdnId").val()) || 0,
                    CustomerId: parseInt($("#hdnCustomerId").val()) || 0,
                    MaximumInvoiceValue: parseFloat($("#txtMaximumInvoiceValue").val()),
                    Remarks: $("#txtRemarks").val(),
                    IsActive: $("#ddlStatus").val() == "1"
                }
            };
        }

        function saveData() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/Save",
                data: JSON.stringify(getFormData()),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "Success") {
                        toastr.success("Record saved successfully.");
                        clearForm();
                        loadList();
                    } else { toastr.error(response.d); }
                },
                error: function () { toastr.error("Error saving data."); }
            });
        }

        function updateData() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/Update",
                data: JSON.stringify(getFormData()),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "Success") {
                        toastr.success("Record updated successfully.");
                        clearForm();
                        loadList();
                    } else { toastr.error(response.d); }
                },
                error: function () { toastr.error("Error updating data."); }
            });
        }

        function deleteData() {
            deleteRecord(parseInt($("#hdnId").val()) || 0);
        }

        function deleteRecord(id) {
            if (id > 0) {
                $.ajax({
                    type: "POST",
                    url: "CustomerInvoiceLimit.aspx/Delete",
                    data: JSON.stringify({ id: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "Success") {
                            toastr.success("Record deleted successfully.");
                            clearForm();
                            loadList();
                        } else { toastr.error(response.d); }
                    },
                    error: function () { toastr.error("Error deleting data."); }
                });
            }
        }

        function editRecord(id) {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/GetById",
                data: JSON.stringify({ id: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response.d;
                    if (data != null) {
                        $("#hdnId").val(data.Id);
                        $("#hdnCustomerId").val(data.CustomerId);
                        $("#txtCustomer").val(data.CustomerCode + ' - ' + data.CustomerName);
                        $("#txtMaximumInvoiceValue").val(data.MaximumInvoiceValue);
                        $("#txtRemarks").val(data.Remarks);
                        $("#ddlStatus").val(data.IsActive ? "1" : "0");

                        $("#btnSave").prop("disabled", true);
                        $("#btnUpdate").prop("disabled", false);
                        $("#btnDelete").prop("disabled", false);
                        $("#txtCustomer").prop("disabled", true);
                    }
                },
                error: function () { toastr.error("Error loading record details."); }
            });
        }

        function clearForm() {
            $("#hdnId").val("0");
            $("#hdnCustomerId").val("0");
            $("#txtCustomer").val("").prop("disabled", false).removeClass("is-invalid");
            $("#txtMaximumInvoiceValue").val("50000").removeClass("is-invalid");
            $("#txtRemarks").val("");
            $("#ddlStatus").val("1");

            $("#btnSave").prop("disabled", false);
            $("#btnUpdate").prop("disabled", true);
            $("#btnDelete").prop("disabled", true);
        }

        // --- TAB 2 INVOICE NOT BINDING FUNCTIONS ---
        function initInvDataTable() {
            dataTableInv = $('#tblInvList').DataTable({
                "columnDefs": [{ "orderable": false, "targets": [0, 14] }]
            });
        }

        function loadCustomerTypeList() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/GetCustomerTypeListActive",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response.d;
                    var $ddl = $("#ddlInvCustomerType");
                    $ddl.find("option:not(:first)").remove();
                    for (var i = 0; i < data.length; i++) {
                        $ddl.append($('<option>', { value: data[i].CustomerTypeId, text: data[i].CustomerType }));
                    }
                },
                error: function () { toastr.error("Error loading customer types."); }
            });
        }

        function loadInvList() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/GetInvoiceNotBindingList",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    dataTableInv.clear();
                    var data = response.d;
                    for (var i = 0; i < data.length; i++) {
                        var sl = i + 1;
                        var btnAction = '<button type="button" class="btn btn-sm btn-primary" onclick="editInvRecord(' + data[i].InvoiceNotBindingId + ')">Edit</button> ' +
                                        '<button type="button" class="btn btn-sm btn-danger" onclick="deleteInvRecord(' + data[i].InvoiceNotBindingId + ')">Delete</button>';

                        var creditLimit = (data[i].AllowedCreditLimit !== null && data[i].AllowedCreditLimit !== undefined)
                            ? parseFloat(data[i].AllowedCreditLimit).toFixed(2)
                            : '0.00';

                        var isCustomerType = data[i].ApplyType === 'CustomerType';
                        var applyByLabel = isCustomerType ? 'Customer Type' : 'Customer';

                        dataTableInv.row.add([
                            sl,
                            applyByLabel,
                            isCustomerType ? '-' : (data[i].CustomerCode || ''),
                            isCustomerType ? '-' : (data[i].CustomerName || ''),
                            isCustomerType ? (data[i].CustomerTypeName || '') : '-',
                            isCustomerType ? '-' : (data[i].MobileNo || ''),
                            data[i].ActiveFromDate || '',
                            data[i].ActiveToDate || '-',
                            data[i].AllowedNoOfInvoice || 0,
                            creditLimit,
                            data[i].NumberOfDaysInTransit || 0,
                            data[i].Status || '',
                            data[i].CreatedBy || '',
                            data[i].CreatedDate || '',
                            btnAction
                        ]);
                    }
                    dataTableInv.draw();
                },
                error: function () { toastr.error("Failed to load invoice limit list."); }
            });
        }

        function getInvApplyType() {
            return $('input[name="rdoInvApplyType"]:checked').val() || 'Customer';
        }

        function validateInvForm() {
            var isValid = true;
            var applyType = getInvApplyType();

            if (applyType === 'CustomerType') {
                var customerTypeId = $("#ddlInvCustomerType").val();
                if (!customerTypeId || customerTypeId == "0") {
                    $("#ddlInvCustomerType").addClass("is-invalid");
                    isValid = false;
                } else {
                    $("#ddlInvCustomerType").removeClass("is-invalid");
                }
            } else {
                var customerId = $("#hdnInvCustomerId").val();
                if (customerId == "0" || customerId == "") {
                    $("#txtInvCustomer").addClass("is-invalid");
                    isValid = false;
                } else {
                    $("#txtInvCustomer").removeClass("is-invalid");
                }
            }

            var activeFrom = $("#txtActiveFromDate").val();
            if (!activeFrom) {
                $("#txtActiveFromDate").addClass("is-invalid");
                isValid = false;
            } else {
                $("#txtActiveFromDate").removeClass("is-invalid");
            }

            return isValid;
        }

        function getInvFormData() {
            var applyType = getInvApplyType();
            return {
                model: {
                    InvoiceNotBindingId: parseInt($("#hdnInvoiceNotBindingId").val()) || 0,
                    ApplyType: applyType,
                    CustomerId: applyType === 'CustomerType' ? 0 : (parseInt($("#hdnInvCustomerId").val()) || 0),
                    CustomerCode: applyType === 'CustomerType' ? '' : $("#hdnInvCustomerCode").val(),
                    CustomerTypeId: applyType === 'CustomerType' ? (parseInt($("#ddlInvCustomerType").val()) || 0) : 0,
                    ActiveFromDate: $("#txtActiveFromDate").val(),
                    ActiveToDate: $("#txtActiveToDate").val() ? $("#txtActiveToDate").val() : null,
                    AllowedNoOfInvoice: parseInt($("#txtAllowedNoOfInvoice").val()) || 4,
                    AllowedCreditLimit: parseFloat($("#txtAllowedCreditLimit").val()) || 100000,
                    NumberOfDaysInTransit: parseInt($("#txtNumberOfDaysInTransit").val()) || 45,
                    Remarks: $("#txtInvRemarks").val(),
                    IsActive: $("#ddlInvStatus").val() == "1"
                }
            };
        }

        function saveInvData() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/SaveInvoiceNotBinding",
                data: JSON.stringify(getInvFormData()),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "Success") {
                        toastr.success("Invoice limit record saved successfully.");
                        clearInvForm();
                        loadInvList();
                    } else { toastr.error(response.d); }
                },
                error: function () { toastr.error("Error saving invoice limit data."); }
            });
        }

        function updateInvData() {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/UpdateInvoiceNotBinding",
                data: JSON.stringify(getInvFormData()),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "Success") {
                        toastr.success("Invoice limit record updated successfully.");
                        clearInvForm();
                        loadInvList();
                    } else { toastr.error(response.d); }
                },
                error: function () { toastr.error("Error updating invoice limit data."); }
            });
        }

        function deleteInvData() {
            deleteInvRecord(parseInt($("#hdnInvoiceNotBindingId").val()) || 0);
        }

        function deleteInvRecord(id) {
            if (id > 0) {
                $.ajax({
                    type: "POST",
                    url: "CustomerInvoiceLimit.aspx/DeleteInvoiceNotBinding",
                    data: JSON.stringify({ id: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "Success") {
                            toastr.success("Invoice limit record deleted successfully.");
                            clearInvForm();
                            loadInvList();
                        } else { toastr.error(response.d); }
                    },
                    error: function () { toastr.error("Error deleting data."); }
                });
            }
        }

        function editInvRecord(id) {
            $.ajax({
                type: "POST",
                url: "CustomerInvoiceLimit.aspx/GetInvoiceNotBindingById",
                data: JSON.stringify({ id: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response.d;
                    if (data != null) {
                        $("#hdnInvoiceNotBindingId").val(data.InvoiceNotBindingId);

                        var isCustomerType = data.ApplyType === 'CustomerType';
                        if (isCustomerType) {
                            $("#rdoInvApplyTypeCustomerType").prop("checked", true);
                            $("#divInvCustomerWise").hide();
                            $("#divInvCustomerTypeWise").show();
                            $("#ddlInvCustomerType").val(data.CustomerTypeId).prop("disabled", true);
                        } else {
                            $("#rdoInvApplyTypeCustomer").prop("checked", true);
                            $("#divInvCustomerTypeWise").hide();
                            $("#divInvCustomerWise").show();
                            $("#hdnInvCustomerId").val(data.CustomerId);
                            $("#hdnInvCustomerCode").val(data.CustomerCode);
                            $("#txtInvCustomer").val(data.CustomerCode + ' - ' + data.CustomerName);
                        }
                        $('input[name="rdoInvApplyType"]').prop("disabled", true);

                        $("#txtActiveFromDate").val(data.ActiveFromDate);
                        $("#txtActiveToDate").val(data.ActiveToDate);
                        $("#txtAllowedNoOfInvoice").val(data.AllowedNoOfInvoice);
                        $("#txtAllowedCreditLimit").val(data.AllowedCreditLimit);
                        $("#txtNumberOfDaysInTransit").val(data.NumberOfDaysInTransit);
                        $("#txtInvRemarks").val(data.Remarks);
                        $("#ddlInvStatus").val(data.IsActive ? "1" : "0");

                        $("#btnInvSave").prop("disabled", true);
                        $("#btnInvUpdate").prop("disabled", false);
                        $("#btnInvDelete").prop("disabled", false);
                        $("#txtInvCustomer").prop("disabled", true);
                    }
                },
                error: function () { toastr.error("Error loading invoice limit record details."); }
            });
        }

        function clearInvForm() {
            $("#hdnInvoiceNotBindingId").val("0");
            $("#hdnInvCustomerId").val("0");
            $("#hdnInvCustomerCode").val("");
            $("#txtInvCustomer").val("").prop("disabled", false).removeClass("is-invalid");

            $('input[name="rdoInvApplyType"]').prop("disabled", false);
            $("#rdoInvApplyTypeCustomer").prop("checked", true);
            $("#divInvCustomerTypeWise").hide();
            $("#divInvCustomerWise").show();
            $("#ddlInvCustomerType").val("0").prop("disabled", false).removeClass("is-invalid");

            var today = new Date().toISOString().split('T')[0];
            $("#txtActiveFromDate").val(today).removeClass("is-invalid");
            $("#txtActiveToDate").val("");
            $("#txtAllowedNoOfInvoice").val("4");
            $("#txtAllowedCreditLimit").val("100000");
            $("#txtNumberOfDaysInTransit").val("45");
            $("#txtInvRemarks").val("");
            $("#ddlInvStatus").val("1");

            $("#btnInvSave").prop("disabled", false);
            $("#btnInvUpdate").prop("disabled", true);
            $("#btnInvDelete").prop("disabled", true);
        }
    </script>
</asp:Content>
