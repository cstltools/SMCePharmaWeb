<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="RollbackDAPartialSalesReturn.aspx.cs" Inherits="SInventory_UI_RollbackDAPartialSalesReturn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return Rollback (DA Partial)</div>
            </div>
            <!--end breadcrumb-->

            <div class="row">
                <div class="col">
                    <div class="card border-top border-0 border-4 border-danger">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>

                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label class="form-label">Invoice No</label>
                                            <asp:TextBox ID="invoiceNoTextBox" runat="server" CssClass="form-control form-control-sm"
                                                placeholder="InvoiceNo / DEL-… / RTN-…"></asp:TextBox>
                                        </div>
                                        <div class="col-md-4 align-self-end">
                                            <asp:LinkButton ID="btnPreview" runat="server" CssClass="btn btn-sm btn-info" OnClick="btnPreview_Click">
                                                <i class="fa fa-search"></i> Check
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnRollback" runat="server" CssClass="btn btn-sm btn-danger" Visible="false"
                                                OnClick="btnRollback_Click"
                                                OnClientClick="return confirm('Rollback this invoice\'s sales return? Stock and invoice payment data will be reverted.');">
                                                <i class="fa fa-undo"></i> Rollback
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3"></asp:Label>
                                    <asp:HiddenField ID="hfInvoiceId" runat="server" />

                                    <asp:Panel ID="pnlResult" runat="server" Visible="false">

                                        <!-- Return summary: what came back, from which batch, when, and where that stock stands now -->
                                        <div class="card border-top border-0 border-4 border-warning mb-3">
                                            <div class="card-body">
                                                <h6 class="mb-3"><i class="bx bx-undo"></i> Return Summary</h6>
                                                <div class="row mb-2">
                                                    <div class="col-md-3"><small class="text-muted d-block">Invoice No</small><asp:Label ID="lblInvoiceNo" runat="server" CssClass="fw-bold"></asp:Label></div>
                                                    <div class="col-md-3"><small class="text-muted d-block">Customer</small><asp:Label ID="lblCustomer" runat="server" CssClass="fw-bold"></asp:Label></div>
                                                    <div class="col-md-2"><small class="text-muted d-block">Return Type</small><asp:Label ID="lblReturnType" runat="server" CssClass="fw-bold"></asp:Label></div>
                                                    <div class="col-md-2"><small class="text-muted d-block">Returned On (DA)</small><asp:Label ID="lblReturnedOn" runat="server" CssClass="fw-bold"></asp:Label></div>
                                                    <div class="col-md-2"><small class="text-muted d-block">DIC Approval</small><asp:Label ID="lblApproval" runat="server" CssClass="fw-bold"></asp:Label></div>
                                                </div>
                                                <div class="table-responsive">
                                                    <asp:GridView ID="gvSummary" runat="server" AutoGenerateColumns="False"
                                                        CssClass="table table-bordered text-center thead-dark"
                                                        EmptyDataText="No returned line found for this invoice.">
                                                        <Columns>
                                                            <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                                            <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                                            <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                            <asp:BoundField DataField="InvoiceQty" HeaderText="Invoice Qty" />
                                                            <asp:BoundField DataField="ReturnedQty" HeaderText="Returned Qty" />
                                                            <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                                            <asp:BoundField DataField="ReturnValue" HeaderText="Return Value" DataFormatString="{0:n2}" />
                                                            <asp:BoundField DataField="ReturnedOn" HeaderText="Returned On" DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />
                                                            <asp:BoundField DataField="CurrentStockQty" HeaderText="Current DC Stock" />
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                                <div class="text-end">
                                                    <asp:Label ID="lblTotals" runat="server" CssClass="fw-bold"></asp:Label>
                                                </div>
                                            </div>
                                        </div>

                                        <h6 class="mt-2">DC stock to be deducted on rollback</h6>
                                        <div class="table-responsive">
                                            <asp:GridView ID="gvStock" runat="server" AutoGenerateColumns="False"
                                                CssClass="table table-bordered text-center thead-dark"
                                                EmptyDataText="Nothing to deduct.">
                                                <Columns>
                                                    <asp:BoundField DataField="DCStoreId" HeaderText="DCStoreId" />
                                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                                    <asp:BoundField DataField="NeedToDeduct" HeaderText="Need To Deduct" />
                                                    <asp:BoundField DataField="AvailableStockQty" HeaderText="Available Stock" />
                                                    <asp:BoundField DataField="StockStatus" HeaderText="Status" />
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
