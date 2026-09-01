<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="RptBussinessSummary_DCWise.aspx.cs" Inherits="SInventory_UI_RptBussinessSummary_DCWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>DC Wise Net Sales Report</div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                            <div class="row align-items-end">
                                <div class="col-sm-3 col-md-2">
                                    <label for="ddlYear" class="col-form-label">Year: <span style="color: red">*</span></label>
                                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>
                                </div>

                                <div class="col-sm-3 col-md-2">
                                    <label for="ddlMonth" class="col-form-label">Month: <span style="color: red">*</span></label>
                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>
                                </div>

                                <div class="col-md-5 mt-2 mt-md-0">
                                    <label class="col-form-label d-none d-md-block">&nbsp;</label>
                                    <asp:LinkButton OnClick="viewRptButton_Click" runat="server" ID="viewRptButton" class="btn btnMyDesignSearch btn-sm">
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" OnClick="Reset_Click" class="btn btnMyDesignReset btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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
                                <asp:GridView ID="gv_DCWise" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False"
                                    OnRowDataBound="gv_DCWise_OnRowDataBound" ShowFooter="True">
                                    <Columns>
                                        <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center">
                                            <ItemStyle HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="JustSalesAmtTP" HeaderText="Amount (TP)" DataFormatString="{0:N2}" Visible="false">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="JustSalesGrossAmt" HeaderText="Gross Amount" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SAPsendAmount" HeaderText="SAP Send Amount" DataFormatString="{0:N2}">
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <EmptyDataTemplate>No data found.</EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
