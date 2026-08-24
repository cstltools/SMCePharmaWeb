<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="OrderPaymentApprovalList.aspx.cs" Inherits="Approval_UI_OrderPaymentApprovalList" %>

<%@ Register Src="../SInventory_UI/IVMarketStructureInvoSearch.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>&nbsp;Order Payment Approval</div>
                <div class="ms-auto">
                    <asp:Label ID="lblMyRole" runat="server" CssClass="badge bg-info"></asp:Label>
                </div>
            </div>
            <!--end breadcrumb-->

            <div class="row">
                <div class="col">
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <script type="text/javascript">
                                        // Same picker wiring the other Approval_UI pages use, re-run after
                                        // every partial postback.
                                        function pageLoad() {
                                            $('.datepicker').pickadate({
                                                selectMonths: true,
                                                selectYears: true
                                            });
                                        }

                                        // Same helper the other Approval_UI pages define locally.
                                        function showLoading(element) {
                                            element.innerHTML = '<i class="fa fa-spinner fa-spin"></i>';
                                            element.style.pointerEvents = 'none';
                                        }
                                    </script>

                                    <%-- Market structure filter - the same control CustomerApproveList uses.
                                         These only NARROW what the list proc already scoped to this user. --%>
                                    <div class="row">
                                        <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-3">
                                            <label class="form-label">Status</label>
                                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm">
                                                <asp:ListItem Text="Waiting (Posted + Verified)" Value="" />
                                                <asp:ListItem Text="Posted" Value="Posted" />
                                                <asp:ListItem Text="Verified" Value="Verified" />
                                                <asp:ListItem Text="Accepted" Value="Accepted" />
                                                <asp:ListItem Text="Rejected" Value="Rejected" />
                                            </asp:DropDownList>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Last Action From</label>
                                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select Date" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Last Action To</label>
                                            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select Date" />
                                        </div>
                                        <div class="col-md-3 d-flex align-items-end">
                                            <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btnMyDesignSearch btn-sm me-2" OnClick="btnSearch_Click">
                                                <i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnReset_Click" Text="Reset" />
                                        </div>
                                    </div>

                                    <div class="table-responsive">
                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-bordered thead-dark"
                                            DataKeyNames="OrderId,Status,CanAct"
                                            OnRowCommand="loadGridView_RowCommand"
                                            OnRowDataBound="loadGridView_RowDataBound"
                                            OnPreRender="gv_PreRender"
                                            EmptyDataText="No order payment approval request found.">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sl. #">
                                                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                                <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                <asp:BoundField DataField="RegionCode" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaCode" HeaderText="Area" />
                                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory" />
                                                <asp:BoundField DataField="OrderValue" HeaderText="Order Value" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                                                <asp:BoundField DataField="DueAmount" HeaderText="Total Due" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />

                                                <%-- The whole commitment as one cell. The approver sees exactly what
                                                     they are approving without opening anything - the framework grid
                                                     stays one-click. --%>
                                                <asp:TemplateField HeaderText="Payment Schedule">
                                                    <ItemTemplate>
                                                        <span class="badge bg-secondary"><%# Eval("InstalmentCount") %> instalment(s)</span>
                                                        <div><small><%# Eval("ScheduleText") %></small></div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                                <asp:BoundField DataField="WaitingForRole" HeaderText="Waiting For" />
                                                <asp:BoundField DataField="LastActionBy" HeaderText="Last Action By" />
                                                <asp:BoundField DataField="LastActionDate" HeaderText="Last Action" DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />

                                                <asp:TemplateField HeaderText="Remarks">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control form-control-sm"
                                                            MaxLength="500" autocomplete="off" placeholder="Required to reject" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Actions">
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hfOrderId" runat="server" Value='<%# Eval("OrderId") %>' />

                                                        <asp:LinkButton ID="lbApprove" runat="server" CssClass="btn btn-sm btn-success mb-1"
                                                            OnClientClick="showLoading(this);"
                                                            CommandArgument="<%# Container.DataItemIndex %>" CommandName="ApproveData"
                                                            ToolTip="Approve"><i class='fa fa-check' aria-hidden='true'></i></asp:LinkButton>

                                                        <asp:LinkButton ID="lbReject" runat="server" CssClass="btn btn-sm btn-danger mb-1"
                                                            OnClientClick="showLoading(this);"
                                                            CommandArgument="<%# Container.DataItemIndex %>" CommandName="RejectData"
                                                            ToolTip="Reject"><i class='fadeIn animated bx bx-x' aria-hidden='true'></i></asp:LinkButton>

                                                        <asp:LinkButton ID="lbHistory" runat="server" CssClass="btn btn-sm btn-outline-info mb-1"
                                                            CommandArgument="<%# Container.DataItemIndex %>" CommandName="ShowHistory"
                                                            ToolTip="Approval history"><i class='bx bx-history' aria-hidden='true'></i></asp:LinkButton>

                                                        <asp:Label ID="lbMsg" runat="server" Text="" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>

                                    <%-- Audit trail for one order. Every row of tblOrderPaymentApprovalLog,
                                         oldest first, including earlier rejected rounds. --%>
                                    <asp:Panel ID="pnlHistory" runat="server" Visible="false" CssClass="mt-4">
                                        <h6>
                                            Approval History &mdash;
                                            <asp:Label ID="lblHistoryOrder" runat="server" Font-Bold="true" />
                                            <asp:LinkButton ID="btnCloseHistory" runat="server" CssClass="btn btn-sm btn-outline-secondary ms-3"
                                                OnClick="btnCloseHistory_Click" Text="Close" />
                                        </h6>
                                        <div class="table-responsive">
                                            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False"
                                                CssClass="table table-bordered table-sm" EmptyDataText="No history.">
                                                <Columns>
                                                    <asp:BoundField DataField="Round" HeaderText="Round" />
                                                    <asp:BoundField DataField="Step" HeaderText="Step" />
                                                    <asp:BoundField DataField="ActionRole" HeaderText="Action By Role" />
                                                    <asp:BoundField DataField="ActionBy" HeaderText="Action By" />
                                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                                    <asp:BoundField DataField="WaitingForRole" HeaderText="Then Waiting For" />
                                                    <asp:BoundField DataField="Comments" HeaderText="Remarks" />
                                                    <asp:BoundField DataField="EntryDate" HeaderText="Date/Time" DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </asp:Panel>

                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
