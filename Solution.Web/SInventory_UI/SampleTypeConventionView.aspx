<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SampleTypeConventionView.aspx.cs" Inherits="SInventory_UI_SampleTypeConventionView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Conversion List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                         
                             <a href="SampleTypeConvertion.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                       
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
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

                        <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">

                                                

                                              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"  DataKeyNames="SampleStockForDcMasterId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Convertion Name" />
                                    <asp:BoundField DataField="Date" HeaderText="Convertion Stock Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="Action" HeaderText="Action"/>
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData" ImageUrl="~/images/delete.png"
                                                             OnClientClick="return GetConfirmation();"/>
                                            <script type="text/javascript">
                                                function GetConfirmation() {
                                                    var reply = confirm("Ary you sure you want to delete this?");
                                                    if (reply) {
                                                        return true;
                                                    }
                                                    else {
                                                        return false;
                                                    }
                                                }
                                            </script>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                               <%--     <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="reportImageButton" runat="server" 
                                                             CommandArgument="<%# Container.DataItemIndex %>" CommandName="ReportView" ImageUrl="~/images/report-disk-icon.png"
                                                           />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>

                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"  Visible="False">
                                <Columns>
                                    <asp:BoundField DataField="DCStoreId" />
                                    <asp:BoundField DataField="SampleStock" />
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

