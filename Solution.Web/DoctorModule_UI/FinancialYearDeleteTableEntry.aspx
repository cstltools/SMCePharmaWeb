<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="FinancialYearDeleteTableEntry.aspx.cs" Inherits="DoctorModule_UI_FinancialYearDeleteTableEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Delete Table Data</div>

            </div>

            <div class="row">
                <div class="col">
                    <div class="card border-top border-0 border-4 border-danger">
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

                                     

                                    <div class="row mt-1">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-7">
                                            <div class="form-group row">
                                                <label for="ddlArchiveFinancialYear" class="col-sm-3 col-form-label">Financial Year</label>
                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlArchiveFinancialYear" AutoPostBack="true" OnSelectedIndexChanged="ddlArchiveFinancialYear_SelectedIndexChanged" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <asp:Panel ID="pnlArchiveDatabaseRow" runat="server" CssClass="row mt-1">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-7">
                                            <div class="form-group row">
                                                <label for="ddlArchiveDatabase" class="col-sm-3 col-form-label">Database Name</label>
                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlArchiveDatabase" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <div class="row mt-1">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-7">
                                            <div class="form-group row">
                                                <label for="rblProcessType" class="col-sm-3 col-form-label">Process Type</label>
                                                <div class="col-sm-7 pt-1">
                                                    <asp:RadioButtonList ID="rblProcessType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="process-mode-list">
                                                        <asp:ListItem Value="Opening" Selected="True">Opening Process</asp:ListItem>
                                                        <asp:ListItem Value="Delete">Production Table</asp:ListItem>
                                                        <asp:ListItem Value="Archive">Archive Table</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <asp:Panel ID="pnlDeleteTableRow" runat="server" CssClass="row mt-1">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-7">
                                            <div class="form-group row">
                                                <label for="ddlDeleteTable" class="col-sm-3 col-form-label">Delete Table</label>
                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlDeleteTable" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-7">
                                            <div class="form-group row">
                                                <label class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-7">
                                                    <asp:LinkButton ID="btnOpening" runat="server" OnClick="btnOpening_Click" CssClass="btn btn-primary btn-sm me-2">
                                                        <i class="fa fa-cogs" aria-hidden="true"></i> Opening
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click"   CssClass="btn btn-danger btn-sm">
                                                        <i class="fa fa-trash" aria-hidden="true"></i> Delete
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
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

    <script type="text/javascript">
        function toggleProcessModeControls() {
            var selectedMode = $('#<%= rblProcessType.ClientID %> input[type=radio]:checked').val() || 'Opening';
            var isOpeningProcess = selectedMode === 'Opening';
            var isArchiveProcess = selectedMode === 'Archive';

            $('#<%= pnlArchiveDatabaseRow.ClientID %>').toggle(isArchiveProcess);
            $('#<%= pnlDeleteTableRow.ClientID %>').toggle(!isOpeningProcess);
            $('#<%= btnOpening.ClientID %>').toggle(isOpeningProcess);
            $('#<%= btnDelete.ClientID %>').toggle(!isOpeningProcess);
        }

        function bindProcessModeEvents() {
            $('#<%= rblProcessType.ClientID %> input[type=radio]')
                .off('change.processMode')
                .on('change.processMode', function () {
                    toggleProcessModeControls();
                });
        }

        function pageLoad() {
            $('.mySelect2').each(function () {
                if ($(this).hasClass('select2-hidden-accessible')) {
                    $(this).select2('destroy');
                }

                $(this).select2({
                    theme: 'bootstrap4',
                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                    placeholder: $(this).data('placeholder'),
                    allowClear: Boolean($(this).data('allow-clear'))
                });
            });

            bindProcessModeEvents();
            toggleProcessModeControls();
        }
    </script>
</asp:Content>
