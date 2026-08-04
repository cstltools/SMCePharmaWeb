<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="DAExpenseClaimApprovalList.aspx.cs" Inherits="SInventory_UI_DAExpenseClaimApprovalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        #MainGradeDiv .remarks-cell {
            min-width: 220px;
            max-width: 360px;
            white-space: normal !important;
            overflow-wrap: anywhere;
            text-align: left;
        }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> DA Expense Claim Approval List</div>
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
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle"
                                                    ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
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
                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server"
                                                        CssClass="form-select form-select-sm mb-3 mySelect2"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                            <div class="form-group row">
                                                <label for="rootDropDownList" class="col-sm-3 col-form-label">Route:</label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="rootDropDownList" runat="server"
                                                        CssClass="form-control form-control-sm mySelect2"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="rootDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="daDropDownList" class="col-sm-3 col-form-label">DA:</label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="daDropDownList" runat="server"
                                                        CssClass="form-control form-control-sm mySelect2">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="fromDateTextBox" class="col-sm-3 col-form-label">From Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server"
                                                        CssClass="form-control form-control-sm datepicker"
                                                        autocomplete="off"></asp:TextBox>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="toDateTextBox" class="col-sm-3 col-form-label">To Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="toDateTextBox" runat="server"
                                                        CssClass="form-control form-control-sm datepicker"
                                                        autocomplete="off"></asp:TextBox>
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
                                                    <asp:LinkButton OnClick="submitButton_Click" runat="server" ID="submitButton"
                                                        CssClass="btn btnMyDesignSearch btn-sm">
                                                        <i class="fa fa-search"></i> Search
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cancelButton" runat="server" OnClick="cancelButton_Click"
                                                        CssClass="btn btnMyDesignReset btn-sm">
                                                        <i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">
                                                    <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info"
                                                        Text="Total Record: 0"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">
                                            <asp:GridView ID="expenseClaimGridView" runat="server" AutoGenerateColumns="False"
                                                DataKeyNames="ExpenseClaimID"
                                                CssClass="table table-bordered text-center thead-dark"
                                                OnPreRender="expenseClaimGridView_PreRender"
                                                OnRowCommand="expenseClaimGridView_RowCommand">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="SL#">
                                                        <ItemTemplate>
                                                            <%# Container.DataItemIndex + 1 %>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="ExpenseClaimID" HeaderText="Claim ID" />
                                                    <asp:BoundField DataField="ExpenseTypeName" HeaderText="Expense Type" />
                                                    <asp:BoundField DataField="ExpDate" HeaderText="Expense Date" />
                                                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}" />
                                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks">
                                                        <HeaderStyle CssClass="remarks-cell" />
                                                        <ItemStyle CssClass="remarks-cell" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                                                    <asp:CheckBoxField DataField="IsFromApp" HeaderText="From App" />
                                                    <asp:TemplateField HeaderText="Image">
                                                        <ItemTemplate>
                                                            <asp:HyperLink ID="imageLink" runat="server" Target="_blank"
                                                                CssClass="btn btn-sm btn-outline-info"
                                                                NavigateUrl='<%# GetImageUrl(Eval("ImagePath"), Eval("ImageName")) %>'
                                                                Visible='<%# HasImage(Eval("ImagePath"), Eval("ImageName")) %>'>
                                                                <i class="fa fa-image"></i> View
                                                            </asp:HyperLink>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EntryBy" HeaderText="Entry By" />
                                                    <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="approveButton" runat="server"
                                                                CssClass="btn btn-sm btn-outline-success"
                                                                CommandName="ApproveClaim"
                                                                CommandArgument="<%# Container.DataItemIndex %>"
                                                                OnClientClick="return confirm('Are you sure you want to approve this DA expense claim?');">
                                                                <i class="fa fa-check"></i> Approve
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="disApproveButton" runat="server"
                                                                CssClass="btn btn-sm btn-outline-danger"
                                                                CommandName="DisApproveClaim"
                                                                CommandArgument="<%# Container.DataItemIndex %>"
                                                                OnClientClick="return confirm('Are you sure you want to disapprove this DA expense claim?');">
                                                                <i class="fa fa-times"></i> DisApprove
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
