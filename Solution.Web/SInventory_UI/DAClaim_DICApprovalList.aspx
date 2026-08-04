<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="DAClaim_DICApprovalList.aspx.cs" Inherits="SInventory_UI_DAClaim_DICApprovalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        #MainGradeDiv .market-names-cell {
            white-space: normal !important;
            overflow-wrap: anywhere;
            word-break: break-word;
            min-width: 220px;
            max-width: 360px;
            text-align: left;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Tour Plan Approval List</div>
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
                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                                        AutoPostBack="True" OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                            <div class="form-group row">
                                                <label for="rootDropDownList" class="col-sm-3 col-form-label">Route:</label>
                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="rootDropDownList" runat="server" CssClass="form-control form-control-sm mySelect2">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="entryDateTextBox" class="col-sm-3 col-form-label">Entry Date:</label>
                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="entryDateTextBox" runat="server" CssClass="datepicker form-control form-control-sm"></asp:TextBox>
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
                                                    <asp:LinkButton OnClick="Button1_Click" runat="server" ID="submitButton" CssClass="btn btnMyDesignSearch btn-sm">
                                                        <i class="fa fa-search"></i> Search
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cancelButton" runat="server" OnClick="cancelButton_Click" CssClass="btn btnMyDesignReset btn-sm">
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
                                                    <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info" Text="Total Record: 0"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">
                                            <asp:GridView ID="daClaimGridView" runat="server" AutoGenerateColumns="False"
                                                DataKeyNames="DAClaimId"
                                                CssClass="table table-bordered text-center thead-dark"
                                                OnPreRender="gv_DocumentUpload_PreRender"
                                                OnRowCommand="daClaimGridView_RowCommand">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="SL#">
                                                        <ItemTemplate>
                                                            <%# Container.DataItemIndex + 1 %>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="DAClaimId" HeaderText="Claim ID" Visible="false" />
                                                    <asp:BoundField DataField="ComUnitCode" HeaderText="SC Code" />
                                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center" />
                                                    <asp:BoundField DataField="DACode" HeaderText="DA Code" />
                                                    <asp:BoundField DataField="DAName" HeaderText="DA Name" />
                                                    <asp:BoundField DataField="MarketNames" HeaderText="Market Names">
                                                        <HeaderStyle CssClass="market-names-cell" Wrap="true" />
                                                        <ItemStyle CssClass="market-names-cell" Wrap="true" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="approveButton" runat="server"
                                                                CssClass="btn btn-sm btn-outline-success"
                                                                CommandName="ApproveClaim"
                                                                CommandArgument="<%# Container.DataItemIndex %>"
                                                                OnClientClick="return confirm('Are you sure you want to approve this DA claim?');">
                                                                <i class="fa fa-check"></i> Approve
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="disApproveButton" runat="server"
                                                                CssClass="btn btn-sm btn-outline-danger"
                                                                CommandName="DisApproveClaim"
                                                                CommandArgument="<%# Container.DataItemIndex %>"
                                                                OnClientClick="return confirm('Are you sure you want to disapprove this DA claim?');">
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
