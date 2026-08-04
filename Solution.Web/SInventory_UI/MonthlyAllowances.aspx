<%@ Page Title="Monthly Allowances" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="MonthlyAllowances.aspx.cs" Inherits="SInventory_UI_MonthlyAllowances" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Monthly Allowances</div>
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

                                    <asp:HiddenField ID="hfAllowanceId" runat="server" Value="0" />

                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="txtRole" class="col-sm-4 col-form-label">Role:</label>
                                                <div class="col-sm-8">
                                                    <asp:TextBox ID="txtRole" runat="server" CssClass="form-control form-control-sm mb-3" Text="Sales Assistant" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="txtAllowanceName" class="col-sm-4 col-form-label">Allowance Name:</label>
                                                <div class="col-sm-8">
                                                    <asp:TextBox ID="txtAllowanceName" runat="server" CssClass="form-control form-control-sm mb-3" MaxLength="200"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="txtAllowanceAmount" class="col-sm-4 col-form-label">Allowance Amount:</label>
                                                <div class="col-sm-8">
                                                    <asp:TextBox ID="txtAllowanceAmount" runat="server" CssClass="form-control form-control-sm mb-3" placeholder="0.00"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label class="col-sm-4 col-form-label">&nbsp;</label>
                                                <div class="col-sm-8">
                                                    <div class="form-check form-switch" style="padding-left: 35px !important;">
                                                        <input class="form-check-input" runat="server" type="checkbox" id="chkIsActive" checked>
                                                        <label class="custom-control-label" for="chkIsActive">Active</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-5"></div>
                                        <div class="col-md-4">
                                            <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btnMyDesignSearch btn-sm" OnClick="btnSave_Click">
                                                <i class="fa fa-save"></i>&nbsp; Save
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btnMyDesignReset btn-sm" OnClick="btnReset_Click">
                                                <i class="fa fa-retweet"></i>&nbsp; Reset
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-md-9">
                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info" Text="Total Record: 0"></asp:Label>
                                        </div>
                                    </div>

                                    <div style="padding-top: 10px;"></div>
                                    <div class="table-responsive">
                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-striped table-bordered"
                                            OnRowCommand="loadGridView_RowCommand"
                                            OnPreRender="loadGridView_PreRender">
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                                <asp:BoundField DataField="AllowanceName" HeaderText="Allowance Name" />
                                                <asp:BoundField DataField="AllowanceAmount" HeaderText="Allowance Amount" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="ActiveStatus" HeaderText="Status" />
                                                <asp:BoundField DataField="EntryDateText" HeaderText="Entry Date" />
                                                <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkEdit" runat="server" CssClass="btn btn-sm btn-info"
                                                            CommandName="EditRow" CommandArgument='<%# Eval("MonthlyAllowanceId") %>'>
                                                            <i class="fa fa-edit"></i>&nbsp; Edit
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
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
</asp:Content>
