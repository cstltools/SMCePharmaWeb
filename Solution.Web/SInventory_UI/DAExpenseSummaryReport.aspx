<%@ Page Title="Sales Assistant Monthly Expense Summary" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="DAExpenseSummaryReport.aspx.cs" Inherits="SInventory_UI_DAExpenseSummaryReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                selectYears: true,
                format: 'dd mmmm, yyyy',
                formatSubmit: 'yyyy-mm-dd'
            });
        }
    </script>

    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Assistant Monthly Expense Summary</div>
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

                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="fromDateTextBox" class="col-sm-4 col-form-label">From Date:</label>
                                                <div class="col-sm-8">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" autocomplete="off"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="salesCenterDropDownList" class="col-sm-4 col-form-label">Sales Center:</label>
                                                <div class="col-sm-8">
                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server"
                                                        CssClass="form-select form-select-sm mb-3 mySelect2"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="toDateTextBox" class="col-sm-4 col-form-label">To Date:</label>
                                                <div class="col-sm-8">
                                                    <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" autocomplete="off"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="daDropDownList" class="col-sm-4 col-form-label">DA:</label>
                                                <div class="col-sm-8">
                                                    <asp:DropDownList runat="server" ID="daDropDownList" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <br />
                                    <div class="row">
                                        <div class="col-md-5"></div>
                                        <div class="col-md-4">
                                            <asp:LinkButton runat="server" ID="btnSearch" CssClass="btn btnMyDesignSearch btn-sm" OnClick="btnSearch_Click">
                                                <i class="fa fa-search-plus"></i>&nbsp; Search
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server" ID="resetBtn" CssClass="btn btnMyDesignReset btn-sm" OnClick="resetBtn_Click">
                                                <i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-9">
                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info" Text="Total Record: 0"></asp:Label>
                                        </div>
                                        <div class="col-md-3">
                                            <asp:LinkButton ID="btnPrint" runat="server" CssClass="btn btn-info" OnClick="btnPrint_OnClick">
                                                <span aria-hidden="true" class="fa fa-print"></span> &nbsp;Print Report
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnViewReport" runat="server" CssClass="btn btn-success pull-right" OnClick="btnViewReport_Click">
                                                <span aria-hidden="true" class="fa fa-file"></span> &nbsp;View Report
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <div style="padding-top: 10px;"></div>
                                    <div class="table-responsive" id="MainGradeDiv">
                                        <div style="margin-top: 40px!important"></div>
                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-striped table-bordered"
                                            OnPreRender="loadGridView_PreRender">
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                        <asp:HiddenField runat="server" ID="hfDAId" Value='<%# Eval("DAId") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <HeaderTemplate>
                                                        <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkSelect" CssClass="form-control-sm" runat="server" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="DACode" HeaderText="DA Code" />
                                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                <asp:BoundField DataField="DAName" HeaderText="DA Name" />
                                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                                <asp:BoundField DataField="DAAmount" HeaderText="DA" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="ExpenseAmount" HeaderText="Expense" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="AllowanceAmount" HeaderText="Allowance Amount" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="{0:N2}" />
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            var table = $('#ContentPlaceHolder1_loadGridView').DataTable({
                "bInfo": true,
                "bFilter": false,
                paging: false,
                "ordering": true,
                dom: 'lBfrtip',
                buttons: ['copy', 'excel', 'pdf', 'print']
            });

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        table = $('#ContentPlaceHolder1_loadGridView').DataTable({
                            "bInfo": true,
                            "bFilter": false,
                            paging: false,
                            "ordering": true,
                            dom: 'lBfrtip',
                            buttons: ['copy', 'excel', 'pdf', 'print']
                        });
                    }
                });
            }
        });
    </script>
</asp:Content>
