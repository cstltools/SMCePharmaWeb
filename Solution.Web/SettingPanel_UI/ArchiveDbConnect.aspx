<%@ Page Title="Archive DB Connect" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ArchiveDbConnect.aspx.cs" Inherits="SettingPanel_UI_ArchiveDbConnect" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-data"></i> Archive DB Connect Setup</div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="alert alert-info mb-4" style="display:none">
                                On submit, data will be saved into <strong>tblArcDBConnect</strong> and
                                <strong><asp:Literal ID="litJobName" runat="server" /></strong>
                                will be started. If the same FY and Database Name already exist, a new row will not be inserted and the job will still be triggered.
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label" for="<%= ddlFY.ClientID %>">FY</label>
                                    <asp:DropDownList ID="ddlFY" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="<%= txtDatabaseName.ClientID %>">Database Name</label>
                                    <asp:TextBox ID="txtDatabaseName" runat="server" CssClass="form-control form-control-sm" MaxLength="200" autocomplete="off" placeholder="e.g. SalesDisDB_SMC_NEWDB_Arch_25-26" />
                                </div>
                            </div>

                            <div class="mt-4">
                                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btnMyDesignSearch btn-sm" OnClick="btnSave_OnClick" OnClientClick="return sweetAlertConfirm_Submit(this);">
                                    <i class="fa fa-check"></i>&nbsp;Submit
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btnMyDesignReset btn-sm" OnClick="btnReset_OnClick">
                                    <i class="fa fa-retweet" aria-hidden="true"></i>&nbsp;Reset
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 mt-3">
                    <div class="card border-top border-0 border-4 border-primary">
                        <div class="card-body">
                            <h6 class="mb-3">Recent Archive DB Entries</h6>
                            <div class="table-responsive">
                                <asp:GridView ID="gvArcDbConnect" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered" EmptyDataText="No archive DB connect data found." OnPreRender="gvArcDbConnect_PreRender">
                                    <Columns>
                                        <asp:BoundField DataField="SL" HeaderText="SL" />
                                        <asp:BoundField DataField="FY" HeaderText="FY" />
                                        <asp:BoundField DataField="DataBaseName" HeaderText="Database Name" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
