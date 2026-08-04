<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="WarehouseStockInView.aspx.cs" Inherits="SInventory_UI_WarehouseStockInView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
            
          
             
   <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Warehouse Stock In List </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        <asp:LinkButton ID="EmpCetegoryAddImageButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="addNewLinkButton_OnClick"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                        
                    
                                  <div class="table-responsive" id="MainGradeDiv">
          <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                    DataKeyNames="WHStockInMasterID" OnRowCommand="loadGridView_RowCommand" CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                    <Columns>
                                        <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                        <asp:BoundField DataField="WHStockInDate" HeaderText="StockIn Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                        <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="TotalQuantity" HeaderText="Total Qty" />
                                        <asp:BoundField DataField="TotalValue" HeaderText="Total Amt" />
                                         <asp:BoundField DataField="Status" HeaderText="Status" />
                                           <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                         
                                            <asp:ImageButton ID="printButton" runat="server" 
                                                  OnClick="printButton_Click"  ImageUrl="../images/image/if_paste-clipboard-copy_2931174.png"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="editImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="EditData" ImageUrl="~/images/edit.png" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Delete">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="deleteImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="DeleteData" OnClientClick="return confirm('Are you sure you want to Delete ?');" ImageUrl="~/images/lineDelete.png" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
          </div>
                       
    
          
    

                        </div>
                  </div>
</div>
</div>
</div>
</div>
</div>

            </ContentTemplate>
    </asp:UpdatePanel>   
        

        
</asp:Content>
