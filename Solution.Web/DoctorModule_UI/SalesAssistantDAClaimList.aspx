<%@ Page Title="Sales Assistant DA Claim List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="SalesAssistantDAClaimList.aspx.cs" Inherits="DoctorModule_UI_SalesAssistantDAClaimList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Assistant DA Claim List</div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
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
                                                selectYears: true,
                                                editable: true
                                            });
                                        }
                                    </script>

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="salesCenterDropDownList" class="col-sm-3 col-form-label">Sales Center:</label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="fromDateTextBox" class="col-sm-3 col-form-label">From Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="datepicker form-control form-control-sm"></asp:TextBox>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="toDateTextBox" class="col-sm-3 col-form-label">To Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="toDateTextBox" runat="server" CssClass="datepicker form-control form-control-sm"></asp:TextBox>
                                                </div>
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
                                                    <asp:LinkButton OnClick="btnSearch_Click" runat="server" ID="btnSearch" CssClass="btn btnMyDesignSearch btn-sm">
                                                        <i class="fa fa-search"></i> Search
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="resetBtn" runat="server" OnClick="resetBtn_Click" CssClass="btn btnMyDesignReset btn-sm">
                                                        <i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <div style="padding-top: 10px;"></div>

                                    <div class="row">
                                        <div class="col-md-9">
                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info" Text="Total Record: 0"></asp:Label>
                                        </div>
                                        <div class="col-md-3">
                                            <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click">
                                                <span aria-hidden="true" class="fa fa-file-excel-o"></span> &nbsp;Export To Excel
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <br />

                                    <div class="table-responsive" id="MainGradeDiv">
                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            DataKeyNames="DICApprovedDAClaimAmountId"
                                            CssClass="table table-striped table-bordered"
                                            OnPreRender="gv_DocumentUpload_PreRender"
                                            AllowPaging="True"
                                            PageIndex="0"
                                            OnPageIndexChanging="loadGridView_PageIndexChanging">
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="DICApprovedDAClaimAmountId" HeaderText="Claim Amount ID" Visible="false" />
                                                <asp:BoundField DataField="DaId" HeaderText="DA ID" />
                                                <asp:BoundField DataField="DACode" HeaderText="DA Code" />
                                                <asp:BoundField DataField="daName" HeaderText="DA Name" />
                                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                                <asp:BoundField DataField="DAAmount" HeaderText="DA Amount" />
                                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                                                <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />
                                            </Columns>
                                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                        </asp:GridView>

                                        <div style="display: none">
                                            <asp:GridView ID="gv_Export" runat="server" AutoGenerateColumns="False"
                                                DataKeyNames="DICApprovedDAClaimAmountId"
                                                CssClass="table table-striped table-bordered">
                                                <Columns>
                                                    <asp:BoundField DataField="DaId" HeaderText="DA ID" />
                                                    <asp:BoundField DataField="DACode" HeaderText="DA Code" />
                                                    <asp:BoundField DataField="daName" HeaderText="DA Name" />
                                                    <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                    <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                                    <asp:BoundField DataField="DAAmount" HeaderText="DA Amount" />
                                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                                                    <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnExportToExcel" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
