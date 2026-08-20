<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="OrderPaymentApprovalList.aspx.cs" Inherits="Approval_UI_OrderPaymentApprovalList" %>

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
                                        // every partial postback so dynamically added schedule rows get it too.
                                        function pageLoad() {
                                            $('.datepicker').pickadate({
                                                selectMonths: true,
                                                selectYears: true
                                            });
                                        }
                                    </script>

                                    <div class="row mb-3">
                                        <div class="col-md-3">
                                            <label class="form-label">Status</label>
                                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm">
                                                <asp:ListItem Text="All" Value="-1" />
                                                <asp:ListItem Text="Pending AM Approval" Value="0" />
                                                <asp:ListItem Text="Pending DZSM Approval" Value="2" />
                                                <asp:ListItem Text="Pending NSM Approval" Value="4" />
                                                <asp:ListItem Text="Fully Approved" Value="5" />
                                                <asp:ListItem Text="Rejected" Value="6" />
                                                <asp:ListItem Text="Cancelled" Value="7" />
                                            </asp:DropDownList>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Requested From</label>
                                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select Date" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Requested To</label>
                                            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Select Date" />
                                        </div>
                                        <div class="col-md-3 d-flex align-items-end">
                                            <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btnMyDesignSearch btn-sm" OnClick="btnSearch_Click">
                                                <i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <div class="table-responsive">
                                        <asp:GridView ID="gvApprovalList" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-bordered text-center thead-dark"
                                            DataKeyNames="OrderPaymentApprovalId"
                                            OnRowCommand="gvApprovalList_RowCommand"
                                            EmptyDataText="No approval request found.">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sl. #">
                                                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                                <asp:BoundField DataField="OrderGrossValue" HeaderText="Order Value" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="TotalDueAmount" HeaderText="Total Due" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="ScheduledAmount" HeaderText="Scheduled" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="RemainingAmount" HeaderText="Remaining" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="ApprovalStatusName" HeaderText="Status" />
                                                <asp:BoundField DataField="RequestedByName" HeaderText="Requested By" />
                                                <asp:BoundField DataField="RequestedDate" HeaderText="Requested On" DataFormatString="{0:dd-MMM-yyyy}" />
                                                <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnOpen" runat="server" CssClass="btn btn-sm btn-outline-info"
                                                            CommandName="OpenDetail" CommandArgument='<%# Eval("OrderPaymentApprovalId") %>'
                                                            Text='<%# Convert.ToBoolean(Eval("CanAct")) ? "Review" : "View" %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>

                                    <%-- ---------------------------------------------------------------- --%>
                                    <%--  Detail / action panel                                           --%>
                                    <%-- ---------------------------------------------------------------- --%>
                                    <asp:Panel ID="pnlDetail" runat="server" Visible="false" CssClass="mt-4">
                                        <div class="card border-top border-0 border-4 border-primary">
                                            <div class="card-body">
                                                <h6 class="mb-3">
                                                    Request Detail &mdash;
                                                    <asp:Label ID="lblOrderCode" runat="server" Font-Bold="true" />
                                                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="badge bg-secondary ms-2" />
                                                </h6>

                                                <div class="row mb-3">
                                                    <div class="col-md-3"><small class="text-muted d-block">Customer</small><asp:Label ID="lblCustomer" runat="server" /></div>
                                                    <div class="col-md-2"><small class="text-muted d-block">Order Value</small><asp:Label ID="lblOrderValue" runat="server" /></div>
                                                    <div class="col-md-2"><small class="text-muted d-block">Total Due</small><asp:Label ID="lblTotalDue" runat="server" Font-Bold="true" /></div>
                                                    <div class="col-md-2"><small class="text-muted d-block">Scheduled</small><asp:Label ID="lblScheduled" runat="server" /></div>
                                                    <div class="col-md-3"><small class="text-muted d-block">Block Reason</small><asp:Label ID="lblBlockReason" runat="server" ForeColor="Red" /></div>
                                                </div>

                                                <%-- Payment schedule: editable on the AM step only, read-only afterwards --%>
                                                <h6 class="mt-4">Payment Schedule</h6>

                                                <asp:Panel ID="pnlScheduleEditor" runat="server" Visible="false">
                                                    <div class="table-responsive">
                                                        <asp:GridView ID="gvScheduleEdit" runat="server" AutoGenerateColumns="False"
                                                            CssClass="table table-bordered table-sm" ShowFooter="false"
                                                            OnRowCommand="gvScheduleEdit_RowCommand" OnRowDataBound="gvScheduleEdit_RowDataBound">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Payment No">
                                                                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Payment Date">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="txtPaymentDate" runat="server" CssClass="form-control form-control-sm datepicker" autocomplete="off" placeholder="Payment Date" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Payment Amount">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="txtPaymentAmount" runat="server" CssClass="form-control form-control-sm text-end" autocomplete="off" placeholder="0.00" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="btnRemoveRow" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                                                            CommandName="RemoveRow" CommandArgument='<%# Container.DataItemIndex %>' Text="Remove" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </div>
                                                    <asp:LinkButton ID="btnAddRow" runat="server" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnAddRow_Click">
                                                        <i class="fa fa-plus" aria-hidden="true"></i>&nbsp;Add Instalment
                                                    </asp:LinkButton>
                                                    <small class="text-muted ms-3">
                                                        Total scheduled amount must equal Total Due. Dates must be today or later, unique, and in ascending order.
                                                    </small>
                                                </asp:Panel>

                                                <asp:Panel ID="pnlScheduleView" runat="server" Visible="false">
                                                    <div class="table-responsive">
                                                        <asp:GridView ID="gvScheduleView" runat="server" AutoGenerateColumns="False"
                                                            CssClass="table table-bordered table-sm" EmptyDataText="No payment schedule recorded yet.">
                                                            <Columns>
                                                                <asp:BoundField DataField="PaymentNo" HeaderText="Payment No" />
                                                                <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                                <asp:BoundField DataField="PaymentAmount" HeaderText="Payment Amount" DataFormatString="{0:N2}" />
                                                                <asp:BoundField DataField="PaymentPlanVersion" HeaderText="Plan Version" />
                                                            </Columns>
                                                        </asp:GridView>
                                                    </div>
                                                </asp:Panel>

                                                <%-- Approval history --%>
                                                <h6 class="mt-4">Approval History</h6>
                                                <div class="table-responsive">
                                                    <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False"
                                                        CssClass="table table-bordered table-sm" EmptyDataText="No history.">
                                                        <Columns>
                                                            <asp:BoundField DataField="ActionDate" HeaderText="Date/Time" DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />
                                                            <asp:BoundField DataField="ActionByName" HeaderText="User" />
                                                            <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                                            <asp:BoundField DataField="ActionName" HeaderText="Action" />
                                                            <asp:BoundField DataField="FromStatus" HeaderText="From" />
                                                            <asp:BoundField DataField="ToStatus" HeaderText="To" />
                                                            <asp:BoundField DataField="PaymentPlanVersion" HeaderText="Plan Ver." />
                                                            <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                                            <asp:BoundField DataField="NewValue" HeaderText="Detail" />
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>

                                                <%-- Actions --%>
                                                <asp:Panel ID="pnlActions" runat="server" Visible="false" CssClass="mt-3">
                                                    <div class="row">
                                                        <div class="col-md-8">
                                                            <label class="form-label">Remarks <small class="text-muted">(required when rejecting)</small></label>
                                                            <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="2" MaxLength="500" CssClass="form-control form-control-sm" />
                                                        </div>
                                                        <div class="col-md-4 d-flex align-items-end">
                                                            <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn btn-sm btn-success me-2"
                                                                OnClientClick="return sweetAlertConfirm_Submit(this);" OnClick="btnApprove_Click" />
                                                            <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn btn-sm btn-danger"
                                                                OnClientClick="return sweetAlertConfirm_Submit(this);" OnClick="btnReject_Click" />
                                                        </div>
                                                    </div>
                                                </asp:Panel>

                                                <div class="mt-3">
                                                    <asp:LinkButton ID="btnCloseDetail" runat="server" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnCloseDetail_Click" Text="Close" />
                                                </div>
                                            </div>
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
