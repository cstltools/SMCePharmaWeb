<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DACustomerLedger.aspx.cs" Inherits="SInventory_UI_DACustomerLedger" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .da-ledger-modal .modal-dialog {
            max-width: 1180px;
        }

        .money-receipt-report {
            background: #fff;
            color: #000;
            font-family: "Times New Roman", Times, serif;
            padding: 28px 36px;
            min-width: 980px;
            font-size: 14px;
        }

        .money-receipt-report .report-header {
            display: flex;
            justify-content: space-between;
            gap: 24px;
            align-items: flex-start;
        }

        .money-receipt-report .company-block img {
            width: 70px;
            height: auto;
            display: block;
            margin-bottom: 4px;
        }

        .money-receipt-report .company-subtitle {
            color: #2b2a78;
            font-size: 11px;
            font-style: italic;
            margin-bottom: 4px;
        }

        .money-receipt-report .company-name {
            color: #2b2a78;
            font-size: 22px;
            font-weight: 700;
        }

        .money-receipt-report .dc-block {
            text-align: right;
            font-size: 18px;
            font-weight: 700;
            max-width: 470px;
        }

        .money-receipt-report .dc-address {
            display: block;
            font-size: 14px;
            font-weight: 400;
            font-style: italic;
            margin-top: 6px;
        }

        .money-receipt-report .receipt-title-row {
            position: relative;
            text-align: center;
            border-bottom: 2px solid #777;
            margin-top: 12px;
            padding-bottom: 5px;
        }

        .money-receipt-report .receipt-title {
            display: inline-block;
            border: 2px dotted #aaa;
            width: 400px;
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            font-style: italic;
            text-decoration: underline;
            padding: 4px 0;
        }

        .money-receipt-report .print-date {
            position: absolute;
            right: 0;
            bottom: 5px;
            font-weight: 700;
            font-style: italic;
            font-size: 14px;
        }

        .money-receipt-report .meta-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin: 16px 0px 24px;
            font-size: 14px;
        }
        
        .money-receipt-report .meta-row .mr-no-text {
            font-weight: bold;
            font-style: italic;
        }

        .money-receipt-report .mio-box {
            min-width: 380px;
            border: 1px solid #aaa;
            padding: 5px 12px;
        }

        .money-receipt-report table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .money-receipt-report th,
        .money-receipt-report td {
            border: 1px solid #777;
            padding: 6px 6px;
            vertical-align: middle;
        }

        .money-receipt-report th {
            text-align: center;
            font-weight: 700;
        }

        .money-receipt-report .text-right {
            text-align: right;
        }
        
        .money-receipt-report .text-center {
            text-align: center;
        }

        .money-receipt-report .total-row td {
            border: none;
            font-weight: 700;
            font-size: 14px;
        }

        .money-receipt-report .in-words {
            margin-top: 40px;
            font: 14px Arial, sans-serif;
        }

        .money-receipt-report .receipt-page {
            page-break-after: always;
            margin-bottom: 36px;
        }

        .money-receipt-report .receipt-page:last-child {
            page-break-after: auto;
            margin-bottom: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="page-wrapper">
                <div class="page-content">
                    <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                        <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>DA Customer Ledger</div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="card border-top border-0 border-4 border-success">
                                <div class="card-body">
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>
                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                            </div>
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label">Sales Center:</label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                                        AutoPostBack="True" OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label">Route:</label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="rootDropDownList" runat="server" CssClass="form-control form-control-sm mySelect2"></asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label">From Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label">To Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>
                                        </div>
                                    </div>

                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">
                                                    <asp:LinkButton OnClick="submitButton_Click" runat="server" ID="submitButton" class="btn btnMyDesignSearch btn-sm">
                                                        <i class="fa fa-search"></i> View
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="resetButton" OnClick="resetButton_Click" class="btn btnMyDesignReset btn-sm">
                                                        <i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade da-ledger-modal" id="daLedgerReportModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-xl" role="document">
                    <div class="modal-content">
                        <div class="modal-header align-items-center">
                            <h5 class="modal-title" style="flex-grow: 1;">DA Customer Ledger</h5>
                            <button type="button" class="btn btn-primary btn-sm" onclick="printReport()" style="margin-right: 15px;"><i class="fa fa-print"></i> Print</button>
                            <button type="button" class="close" data-dismiss="modal" data-bs-dismiss="modal" aria-label="Close" style="margin-left: 0;"><span aria-hidden="true">&times;</span></button>
                        </div>
                        <div class="modal-body" style="overflow:auto;" id="printArea">
                            <asp:Literal ID="reportLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                function pageLoad() {
                    $('.mySelect2').select2({
                        theme: 'bootstrap4',
                        width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                        placeholder: $(this).data('placeholder'),
                        allowClear: Boolean($(this).data('allow-clear'))
                    });
                }

                function showDaLedgerReportModal() {
                    $('#daLedgerReportModal').modal('show');
                }

                function printReport() {
                    var printContent = document.getElementById('printArea').innerHTML;
                    var printWindow = window.open('', '', 'height=800,width=1200');
                    printWindow.document.write('<html><head><title>DA Customer Ledger Report</title>');
                    
                    var styles = document.getElementsByTagName('style');
                    for (var i = 0; i < styles.length; i++) {
                        printWindow.document.write(styles[i].outerHTML);
                    }
                    
                    // Add A4 print specific styles
                    printWindow.document.write('<style>');
                    printWindow.document.write('@page { size: A4 portrait; margin: 10mm; }');
                    printWindow.document.write('@media print {');
                    printWindow.document.write('  body { -webkit-print-color-adjust: exact; margin: 0; padding: 0; }');
                    printWindow.document.write('  .money-receipt-report { min-width: auto !important; width: 100% !important; padding: 0 !important; }');
                    printWindow.document.write('  .money-receipt-report table { width: 100% !important; font-size: 14px !important; }');
                    printWindow.document.write('  .money-receipt-report .receipt-title { width: 100% !important; max-width: 400px; font-size: 20px !important; }');
                    printWindow.document.write('  .money-receipt-report .meta-row { margin: 8px 0 24px !important; font-size: 16px !important; }');
                    printWindow.document.write('  .money-receipt-report .in-words { margin-top: 30px !important; }');
                    printWindow.document.write('}');
                    printWindow.document.write('</style>');
                    
                    printWindow.document.write('</head><body>');
                    printWindow.document.write(printContent);
                    printWindow.document.write('</body></html>');
                    printWindow.document.close();
                    printWindow.focus();
                    
                    setTimeout(function() {
                        printWindow.print();
                        printWindow.close();
                    }, 500);
                }
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
