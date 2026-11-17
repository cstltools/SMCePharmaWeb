<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ExpiryReturnReport.aspx.cs" Inherits="SInventory_UI_ExpiryReturnReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .ssss {
            font-size: 13px;
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Expiry Return Report</div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>
                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                            </div>
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>

                                    <script type="text/javascript">
                                        function pageLoad() {
                                            $('.mySelect2').select2({
                                                theme: 'bootstrap4',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                placeholder: $(this).data('placeholder'),
                                                allowClear: Boolean($(this).data('allow-clear'))
                                            });
                                            $('.datepicker').pickadate({
                                                selectMonths: true,
                                                selectYears: true
                                            });
                                        }
                                    </script>

                                    <div class="row">
                                        <div class="col-4">
                                            <div class="form-group row">
                                                <label class="col-sm-5 col-form-label">Sales Center: </label>
                                                <div class="col-sm-7">
                                                    <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label class="col-sm-5 col-form-label">From Date: <span style="color: red">*</span></label>
                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select From Date"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label class="col-sm-5 col-form-label">To Date: <span style="color: red">*</span></label>
                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label class="col-sm-5 col-form-label">Approval Status: </label>
                                                <div class="col-sm-7">
                                                    <asp:DropDownList ID="ddlApprovalStatus" runat="server" CssClass="form-select form-select-sm mb-3">
                                                        <asp:ListItem Value="ALL" Selected="True">All</asp:ListItem>
                                                        <asp:ListItem Value="Approved">Approved</asp:ListItem>
                                                        <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                                        <asp:ListItem Value="Rejected">Rejected</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label class="col-sm-5 col-form-label">Report Type: </label>
                                                <div class="col-sm-7">
                                                    <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="mb-3"
                                                        AutoPostBack="true" OnSelectedIndexChanged="rblReportType_SelectedIndexChanged">
                                                        <asp:ListItem Value="Details" Selected="True">&nbsp;Details&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                                        <asp:ListItem Value="Summary">&nbsp;Summary</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-4">
                                            <div class="form-group row">
                                                <label class="col-sm-5 col-form-label"></label>
                                                <div class="col-sm-7">
                                                    <asp:LinkButton OnClick="SearchButton_Click" runat="server" ID="submitButton" CssClass="btn btnMyDesignSearch btn-sm">
                                                        <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" OnClick="cancelButton_Click" CssClass="btn btnMyDesignReset btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-4">
                                            <h3><asp:Label ID="lblListTitle" runat="server" Text="Details List"></asp:Label></h3>
                                        </div>
                                        <div class="col-6">
                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right" Text="Total Return Qty : 0"></asp:Label>
                                        </div>
                                        <div class="col-2">
                                            <div class="form-group row pull-right">
                                                <asp:LinkButton ID="btnExport" CssClass="btn btn-sm mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                    <hr />

                                    <div class="table-responsive" id="MainGradeDiv" style="height: 600px">
                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"
                                            AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                            <Columns>
                                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />
                                                <asp:BoundField DataField="DACode" HeaderText="DA Code" />
                                                <asp:BoundField DataField="DAName" HeaderText="DA Name" />
                                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                <asp:BoundField DataField="SubmitDate" HeaderText="Submit Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" />
                                                <asp:BoundField DataField="ReasonName" HeaderText="Reason" />
                                                <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                                <asp:BoundField DataField="AM_EmpCode" HeaderText="AM Emp Code" />
                                                <asp:BoundField DataField="AM_EmpName" HeaderText="AM Name" />
                                                <asp:BoundField DataField="AM_ApproveDate" HeaderText="AM Approve Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                <asp:BoundField DataField="DZSM_EmpCode" HeaderText="DZSM Emp Code" />
                                                <asp:BoundField DataField="DZSM_EmpName" HeaderText="DZSM Name" />
                                                <asp:BoundField DataField="DZSM_ApproveDate" HeaderText="DZSM Approve Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                <asp:BoundField DataField="DIC_EmpCode" HeaderText="DIC Emp Code" />
                                                <asp:BoundField DataField="DIC_EmpName" HeaderText="DIC Name" />
                                                <asp:BoundField DataField="DIC_ApproveDate" HeaderText="DIC Approve Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                            </Columns>
                                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                        </asp:GridView>
                                        <asp:GridView ID="summaryGridView" runat="server" AutoGenerateColumns="False" Visible="false"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"
                                            AllowPaging="True" PageIndex="0" OnPageIndexChanging="summaryGridView_PageIndexChanging"
                                            OnRowCommand="summaryGridView_RowCommand">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Action" ItemStyle-Width="60px">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" CommandName="ViewDetails" CssClass="btn btn-sm btn-info" ToolTip="View / Print Details"
                                                            CommandArgument='<%# Eval("ComUnitCode") + "|" + Eval("ProductCode") + "|" + Eval("PackSize") %>'>
                                                            <i class="fa fa-print" aria-hidden="true"></i>
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />
                                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                                <asp:BoundField DataField="RequestCount" HeaderText="No. of Requests" />
                                                <asp:BoundField DataField="ReturnQty" HeaderText="Total Return Qty" DataFormatString="{0:N2}" />
                                            </Columns>
                                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                        </asp:GridView>
                                    </div>

                                    <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Expiry Return - Product Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div id="printArea">
                                                        <h3 style="text-align: center; margin-bottom: 3px; font-weight: bold; font-size: 18px;">SMC Enterprise Ltd. (Pharma Division)</h3>
                                                        <h4 style="text-align: center; margin-top: 0; margin-bottom: 10px; font-size: 14px; font-weight: 600;">Expiry Return - Product Details</h4>
                                                        <table class="infoTbl" style="width: 100%; margin-bottom: 10px; font-size: 13px;">
                                                            <tr>
                                                                <td><b>Sales Center:</b> <asp:Label ID="lblModalSc" runat="server"></asp:Label></td>
                                                                <td><b>Period:</b> <asp:Label ID="lblModalPeriod" runat="server"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td><b>Product:</b> <asp:Label ID="lblModalProduct" runat="server"></asp:Label></td>
                                                                <td><b>Total Return Qty:</b> <asp:Label ID="lblModalTotal" runat="server"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                        <asp:Literal ID="litModalBody" runat="server"></asp:Literal>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-success btn-sm" onclick="printDetailModal()"><i class="fa fa-print"></i>&nbsp; Print</button>
                                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <script type="text/javascript">
                                        function showDetailModal() {
                                            bootstrap.Modal.getOrCreateInstance(document.getElementById('detailModal')).show();
                                        }
                                        function printDetailModal() {
                                            var w = window.open('', '_blank', 'width=1100,height=700');
                                            w.document.write('<html><head><title>Expiry Return - Product Details</title>' +
                                                '<style>body{font-family:Arial,sans-serif;font-size:12px;margin:15px}' +
                                                'table{border-collapse:collapse;width:100%}th,td{border:1px solid #444;padding:4px 6px;text-align:left}' +
                                                '.infoTbl td{border:none}.invBlock{border:1px solid #444;padding:8px;margin-bottom:14px;page-break-inside:avoid}</style></head><body>' +
                                                document.getElementById('printArea').innerHTML + '</body></html>');
                                            w.document.close();
                                            w.focus();
                                            w.print();
                                        }
                                    </script>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnExport" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
