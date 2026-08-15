<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="RptBussinessSummary_DayWise.aspx.cs" Inherits="SInventory_UI_RptBussinessSummary_DayWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../VerticalAsset/plugins/highcharts/css/highcharts.css" rel="stylesheet" />
    <script src="../VerticalAsset/plugins/highcharts/js/highcharts.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Day Wise Net Sales Report</div>

                <div class="ms-auto">
                    <div class="btn-group">
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                            <script type="text/javascript">
                                function pageLoad() {
                                    $('.mySelect2').select2({
                                        theme: 'bootstrap4',
                                        width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                        placeholder: $(this).data('placeholder'),
                                        allowClear: Boolean($(this).data('allow-clear')),
                                    });
                                    $('.datepicker').pickadate({
                                        selectMonths: true,
                                        selectYears: true
                                    });
                                }
                            </script>

                            <div class="row align-items-end">
                                <div class="col-sm-6 col-md-3">
                                    <label for="dcDropDownList1" class="col-form-label">Distribution Center: <span style="color: red">*</span></label>
                                    <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mySelect2">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-sm-3 col-md-2">
                                    <label for="ddlYear" class="col-form-label">Year: <span style="color: red">*</span></label>
                                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>
                                </div>

                                <div class="col-sm-3 col-md-2">
                                    <label for="ddlMonth" class="col-form-label">Month: <span style="color: red">*</span></label>
                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control form-control-sm">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-5 mt-2 mt-md-0">
                                    <label class="col-form-label d-none d-md-block">&nbsp;</label>
                                    <asp:LinkButton OnClick="viewRptButton_Click" runat="server" ID="viewRptButton" class="btn btnMyDesignSearch btn-sm">
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" OnClick="Unnamed_Click" class="btn btnMyDesignReset btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                </div>
                            </div>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportToExcel_Click" runat="server" ID="excelButton1" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="MainGradeDiv">
                                <asp:GridView ID="gv_DayWise" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False" OnRowCreated="gv_DayWise_OnRowCreated"
                                    OnRowDataBound="gv_DayWise_OnRowDataBound" ShowFooter="True">
                                    <Columns>
                                        <asp:BoundField DataField="TheDate" HeaderText="Day / Date" DataFormatString="{0:dd-MMM-yyyy}">
                                            <ItemStyle HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="JustSalesAmtTP" HeaderText="Amount (TP)" DataFormatString="{0:N2}" Visible="false">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="JustSalesGrossAmt" HeaderText="Gross Amount" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SAPsendAmount" HeaderText="SAP Send Amount" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-8">
                                    <h4 class="mb-3">Negative Closing Stock</h4>

                                    <div class="row align-items-end">
                                        <div class="col-sm-6 col-md-4">
                                            <label for="dcDropDownList2" class="col-form-label">Distribution Center: <span style="color: red">*</span></label>
                                            <asp:DropDownList ID="dcDropDownList2" runat="server" CssClass="form-select form-select-sm mySelect2">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-sm-3 col-md-4">
                                            <label for="fromDateTextBox" class="col-form-label">From Date: <span style="color: red">*</span></label>
                                            <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select From Date"></asp:TextBox>
                                        </div>

                                        <div class="col-sm-3 col-md-4">
                                            <label class="col-form-label">To Date (always today)</label>
                                            <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="mt-2">
                                        <asp:LinkButton OnClick="viewClosingStockButton_Click" runat="server" ID="viewClosingStockButton" class="btn btnMyDesignSearch btn-sm">
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                        </asp:LinkButton>
                                        <asp:LinkButton runat="server" OnClick="ResetClosingStock_Click" class="btn btnMyDesignReset btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="fw-bold text-center small mb-2">Negative Closing - Distribution Center Wise<br />(31-Jul-2026 to today)</div>
                                    <div id="negClosingChart" style="height: 240px;"></div>
                                    <asp:Literal ID="negClosingChartScript" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportClosingStockToExcel_Click" runat="server" ID="excelButton2" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="ClosingStockGridDiv">
                                <asp:GridView ID="gv_NegativeClosingStock" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False"
                                    ShowFooter="False">
                                    <Columns>
                                        <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                        <asp:BoundField DataField="SAP_Code" HeaderText="SAP Code" />
                                        <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                        <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                        <asp:BoundField DataField="OpeningQty" HeaderText="Opening Qty" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="totalrcv" HeaderText="Total Receive" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SalesQty" HeaderText="Sales Qty" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="closing" HeaderText="Closing" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" ForeColor="Red" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-8">
                                    <h4 class="mb-3">Monthly Inventory Report (Batch Wise)</h4>

                                    <div class="row align-items-end">
                                        <div class="col-sm-6 col-md-4">
                                            <label for="salesCenterDropDownList3" class="col-form-label">Distribution Center: <span style="color: red">*</span></label>
                                            <asp:DropDownList ID="salesCenterDropDownList3" runat="server" CssClass="form-select form-select-sm mySelect2">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-sm-3 col-md-4">
                                            <label for="miFromDateTextBox" class="col-form-label">From Date: <span style="color: red">*</span></label>
                                            <asp:TextBox ID="miFromDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select From Date"></asp:TextBox>
                                        </div>

                                        <div class="col-sm-3 col-md-4">
                                            <label for="miToDateTextBox" class="col-form-label">To Date: <span style="color: red">*</span></label>
                                            <asp:TextBox ID="miToDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="mt-2">
                                        <asp:LinkButton OnClick="viewMonthlyInvButton_Click" runat="server" ID="viewMonthlyInvButton" class="btn btnMyDesignSearch btn-sm">
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                        </asp:LinkButton>
                                        <asp:LinkButton runat="server" OnClick="ResetMonthlyInv_Click" class="btn btnMyDesignReset btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="fw-bold text-center small mb-2">Negative Closing - Distribution Center Wise<br />(31-Jul-2026 to today)</div>
                                    <div id="miClosingChartLoading" class="text-center text-muted small">Loading (this proc is slow across all DCs, ~30-45s)&hellip;</div>
                                    <div id="miClosingChart" style="height: 240px;"></div>
                                </div>
                            </div>

                            <script type="text/javascript">
                                (function () {
                                    $.ajax({
                                        url: 'RptBussinessSummary_DayWise.aspx/GetMiClosingChartData',
                                        type: 'POST',
                                        contentType: 'application/json; charset=utf-8',
                                        dataType: 'json',
                                        success: function (response) {
                                            var payload = JSON.parse(response.d);
                                            document.getElementById('miClosingChartLoading').style.display = 'none';
                                            Highcharts.chart('miClosingChart', {
                                                chart: { type: 'column', styledMode: true },
                                                credits: { enabled: false },
                                                title: { text: '' },
                                                xAxis: { categories: payload.categories, crosshair: true },
                                                yAxis: { title: { text: 'Closing Qty' } },
                                                legend: { enabled: false },
                                                series: [{ name: 'Negative Closing', data: payload.data }]
                                            });
                                        },
                                        error: function () {
                                            document.getElementById('miClosingChartLoading').textContent = 'Could not load chart data.';
                                        }
                                    });
                                })();
                            </script>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportMonthlyInvToExcel_Click" runat="server" ID="excelButton3" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="MonthlyInvGridDiv">
                                <asp:GridView ID="loadGridView3" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                        <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                        <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                        <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center" />
                                        <asp:BoundField DataField="OpeningStock" HeaderText="Opening Stock" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ReceiveFromCentralWarehouse" HeaderText="Receive From Central Warehouse" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ReceiveFromAreaOfficeInterTransfer" HeaderText="Receive From Area Office (Inter Transfer)" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="TotalReceived" HeaderText="Total Received" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="IssuedToSales" HeaderText="Issued To Sales" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="IssuedToProductBonus" HeaderText="Issued To Product Bonus" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="IssuedToAreaOfficeInterTransfer" HeaderText="Issued To Area Office (Inter Transfer)" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Blocked" HeaderText="Blocked" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="StockOutQty" HeaderText="Stock Out Qty" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ClosingStock" HeaderText="Closing Stock" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-8">
                                    <h4 class="mb-3">Duplicate Order Number Check</h4>
                                    <p class="text-muted small mb-0">Order codes that appear more than once in tblOrder (should normally be empty).</p>
                                </div>

                                <div class="col-lg-4">
                                    <div class="fw-bold text-center small mb-2">Duplicate Order Codes</div>
                                    <div id="dupOrderChart" style="height: 240px;"></div>
                                    <asp:Literal ID="dupOrderChartScript" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportDupOrderToExcel_Click" runat="server" ID="excelButton4" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="DupOrderGridDiv">
                                <asp:GridView ID="gv_DupOrder" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="OrderCode" HeaderText="Order Code" />
                                        <asp:BoundField DataField="DuplicateCount" HeaderText="Duplicate Count">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <EmptyDataTemplate>No duplicate order codes found.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-8">
                                    <h4 class="mb-3">Duplicate Order No in Invoice</h4>
                                    <p class="text-muted small mb-0">Invoice OrderNo appearing more than once (invoices since 01-Jul-2026, should normally be empty).</p>
                                </div>

                                <div class="col-lg-4">
                                    <div class="fw-bold text-center small mb-2">Duplicate Order No</div>
                                    <div id="dupOrderNoInvChart" style="height: 240px;"></div>
                                    <asp:Literal ID="dupOrderNoInvChartScript" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportDupOrderNoInvToExcel_Click" runat="server" ID="excelButton5" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="DupOrderNoInvGridDiv">
                                <asp:GridView ID="gv_DupOrderNoInv" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="OrderNo" HeaderText="Order No" />
                                        <asp:BoundField DataField="DuplicateCount" HeaderText="Duplicate Count">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <EmptyDataTemplate>No duplicate order numbers found.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-8">
                                    <h4 class="mb-3">Duplicate Invoice No</h4>
                                    <p class="text-muted small mb-0">Invoice numbers that appear more than once in tblInvoice (should normally be empty).</p>
                                </div>

                                <div class="col-lg-4">
                                    <div class="fw-bold text-center small mb-2">Duplicate Invoice No</div>
                                    <div id="dupInvoiceNoChart" style="height: 240px;"></div>
                                    <asp:Literal ID="dupInvoiceNoChartScript" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportDupInvoiceNoToExcel_Click" runat="server" ID="excelButton6" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="DupInvoiceNoGridDiv">
                                <asp:GridView ID="gv_DupInvoiceNo" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                        <asp:BoundField DataField="DuplicateCount" HeaderText="Duplicate Count">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <EmptyDataTemplate>No duplicate invoice numbers found.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-8">
                                    <h4 class="mb-3">Duplicate Customer Code</h4>
                                    <p class="text-muted small mb-0">Customer codes that appear more than once in tblCustMaster (should normally be empty).</p>
                                </div>

                                <div class="col-lg-4">
                                    <div class="fw-bold text-center small mb-2">Duplicate Customer Code</div>
                                    <div id="dupCustomerCodeChart" style="height: 240px;"></div>
                                    <asp:Literal ID="dupCustomerCodeChartScript" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportDupCustomerCodeToExcel_Click" runat="server" ID="excelButton7" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="DupCustomerCodeGridDiv">
                                <asp:GridView ID="gv_DupCustomerCode" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                        <asp:BoundField DataField="DuplicateCount" HeaderText="Duplicate Count">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <EmptyDataTemplate>No duplicate customer codes found.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <h4 class="mb-3">Invoice Payment VAT/TP Mismatch</h4>
                            <p class="text-muted small mb-0">Invoices where the posted payment TP exceeds the invoice detail TP (payment VAT/TP posted incorrectly).</p>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <asp:LinkButton OnClick="btnExportVatTpMismatchToExcel_Click" runat="server" ID="excelButton8" class="btn btnMyDesignSearch btn-sm">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                </asp:LinkButton>
                            </div>

                            <div class="table-responsive" id="VatTpMismatchGridDiv">
                                <asp:GridView ID="gv_VatTpMismatch" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="InvoiceId" HeaderText="Invoice Id" />
                                        <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                        <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="tp" HeaderText="Invoice TP" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="vat" HeaderText="Invoice VAT" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="TPAmount" HeaderText="Payment TP" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="VATAmount" HeaderText="Payment VAT" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="TpDifference" HeaderText="TP Difference" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" ForeColor="Red" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="VatDifference" HeaderText="VAT Difference" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" ForeColor="Red" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SndReturnPaymentDate" HeaderText="2nd Return Payment Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    </Columns>
                                    <EmptyDataTemplate>No VAT/TP mismatches found.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                    <div class="card border-top border-0 border-4 border-success mt-3">
                        <div class="card-body">

                            <h4 class="mb-3">Tour Plan Missing Serial (Today)</h4>
                            <p class="text-muted small mb-0">Field staff with a tour plan for today but no row marked as Serial No 1 (starting point).</p>

                            <hr />

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h3 class="mb-0">Details List</h3>
                                <div>
                                    <asp:LinkButton OnClick="btnFixTourPlanSerial_Click" runat="server" ID="btnFixTourPlanSerial" class="btn btnMyDesignReset btn-sm" OnClientClick="return confirm('This will set Serial No = 1 for every listed employee\'s tour plan today. Continue?');">
                                        <i class="fa fa-wrench" aria-hidden="true"></i>&nbsp; Fix Missing Serial
                                    </asp:LinkButton>
                                    <asp:LinkButton OnClick="btnExportTourPlanToExcel_Click" runat="server" ID="excelButton9" class="btn btnMyDesignSearch btn-sm">
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                    </asp:LinkButton>
                                </div>
                            </div>

                            <div class="table-responsive" id="TourPlanMissingSerialGridDiv">
                                <asp:GridView ID="gv_TourPlanMissingSerial" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="EmpInfoId" HeaderText="Employee Id" />
                                        <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                                    </Columns>
                                    <EmptyDataTemplate>No missing tour plan serial found for today.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
