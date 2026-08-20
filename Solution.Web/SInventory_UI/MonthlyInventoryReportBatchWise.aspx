<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="MonthlyInventoryReportBatchWise.aspx.cs" Inherits="SInventory_UI_MonthlyInventoryReportBatchWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        /* #MainGradeDiv is the scroll container (height:600px), so the header row can just stick to it.
           table-bordered's borders scroll out from under a sticky cell - redraw them as insets. */
        #MainGradeDiv th {
            position: sticky;
            top: 0;
            z-index: 2;
            background-color: #E5EEF1;
            box-shadow: inset 0 1px 0 #dee2e6, inset 0 -1px 0 #dee2e6;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Monthly Inventory Report (Batch Wise)</div>

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
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
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
                                                allowClear: Boolean($(this).data('allow-clear')),
                                            });
                                            $('.datepicker').pickadate({
                                                selectMonths: true,
                                                selectYears: true,
                                                min: new Date(2026, 6, 31)
                                            })
                                            // re-run after every UpdatePanel postback - the grid header is rebuilt each time
                                            $('[data-bs-toggle="popover"]').each(function () { bootstrap.Popover.getOrCreateInstance(this); });
                                        }
                                    </script>
                                    <div class="row">

                                        <div class="col-4">
                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Sales Center: <span style="color:red">*</span></label>
                                                <div class="col-sm-7">
                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Product Code:</label>
                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="productCodeTextBox" runat="server" class="form-control form-control-sm mb-3" autocomplete="off" placeholder="Product / SAP Code (optional)"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-4">

                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select From Date"></asp:TextBox>
                                                </div>
                                            </div>

                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> To Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="toDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                                                    <asp:LinkButton OnClick="viewRptButton_Click" runat="server" id="LinkButton1" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                                    </asp:LinkButton>

                                                    <asp:LinkButton runat="server" OnClick="Unnamed_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                        </div>
                                        <div class="col-3">

                                            <div class="form-group row  pull-right">

                                                <asp:LinkButton OnClick="btnExportToExcel_Click" runat="server" id="LinkButton2" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                                </asp:LinkButton>
                                            </div>
                                        </div>

                                    </div>
                                    <hr />

                                    <div class="table-responsive" id="MainGradeDiv" style="height:600px">

                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-striped table-bordered" ShowFooter="False">
                                            <Columns>
                                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                <asp:BoundField DataField="SAP_Code" HeaderText="SAP Code" />
                                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                                <asp:BoundField DataField="Opening_Qty" HeaderText="Opening Qty" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="Cwh_Receive" HeaderText="CWH Receive" />
                                                <asp:BoundField DataField="B2B_Rcv" HeaderText="B2B Receive" />
                                                <asp:BoundField DataField="Sales_Qty" HeaderText="Sales Qty" />
                                                <asp:BoundField DataField="Return_Qty" HeaderText="Return Qty" />
                                                <asp:BoundField DataField="B2B_Transfer" HeaderText="B2B Transfer" />
                                                <asp:TemplateField HeaderText="Closing Qty">
                                                    <HeaderTemplate>
                                                        Closing Qty
                                                        <button type="button" class="btn btn-link btn-sm p-0 align-baseline" data-bs-toggle="popover" data-bs-trigger="focus"
                                                            data-bs-placement="left" title="Closing Qty formula"
                                                            data-bs-content="(Opening Qty + CWH Receive + B2B Receive + Return Qty) - (Sales Qty + B2B Transfer)">
                                                            <i class="bx bx-info-circle"></i>
                                                        </button>
                                                    </HeaderTemplate>
                                                    <ItemTemplate><%# Eval("Closing_Qty") %></ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>

                                    </div>

                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="LinkButton2" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
