<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="StockOutReport.aspx.cs" Inherits="SInventory_UI_StockOutReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Stock Out Report</div>

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

                            <div class="row">
                                <div class="col-12">
                                    <div class="btn-group" role="group" aria-label="Report Type">
                                        <asp:RadioButton ID="rbGift" runat="server" GroupName="ReportType" Checked="True" AutoPostBack="True"
                                            OnCheckedChanged="rbReportType_CheckedChanged" CssClass="btn-check" />
                                        <asp:Label ID="lblGift" runat="server" AssociatedControlID="rbGift" CssClass="btn btn-primary px-4">Gift</asp:Label>

                                        <asp:RadioButton ID="rbNCP" runat="server" GroupName="ReportType" AutoPostBack="True"
                                            OnCheckedChanged="rbReportType_CheckedChanged" CssClass="btn-check" />
                                        <asp:Label ID="lblNCP" runat="server" AssociatedControlID="rbNCP" CssClass="btn btn-outline-primary px-4">NCP</asp:Label>
                                    </div>
                                </div>
                            </div>

                            <div class="row align-items-end">
                                <div class="col-sm-6 col-md-3">
                                    <label for="depotDropDownList" class="col-form-label">Depot: </label>
                                    <asp:DropDownList ID="depotDropDownList" runat="server" CssClass="form-select form-select-sm mySelect2">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-sm-3 col-md-3">
                                    <label for="fromDateTextBox" class="col-form-label">From Date: <span style="color: red">*</span></label>
                                    <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select From Date"></asp:TextBox>
                                </div>

                                <div class="col-sm-3 col-md-3">
                                    <label for="toDateTextBox" class="col-form-label">To Date: <span style="color: red">*</span></label>
                                    <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                </div>

                                <div class="col-md-3 mt-2 mt-md-0">
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
                                <asp:GridView ID="gv_StockOut" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False"
                                    AllowPaging="True" PageSize="50" OnPageIndexChanging="gv_StockOut_PageIndexChanging" ShowFooter="false">
                                    <Columns>
                                        <asp:BoundField DataField="Depo" HeaderText="Depot" />
                                        <asp:BoundField DataField="Plant" HeaderText="Plant" />
                                        <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                        <asp:BoundField DataField="StockOutDate" HeaderText="Stock Out Date" DataFormatString="{0:dd-MMM-yyyy}">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                        <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                        <asp:BoundField DataField="SapCode" HeaderText="SAP Code" />
                                        <asp:BoundField DataField="StockOutQty" HeaderText="Stock Out Qty" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                    <EmptyDataTemplate>No Stock Out data found for the selected filter.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
