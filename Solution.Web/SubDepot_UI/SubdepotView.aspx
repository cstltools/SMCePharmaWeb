<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubdepotView.aspx.cs" Inherits="SubDepot_UI_SubdepotView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    

       <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>

                     <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>

             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sub-Depot Information  List </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        

                         

                               <asp:LinkButton ID="viewLinkButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="viewLinkButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>
                    </div>
                
                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                            
                        
                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
           <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-bordered  text-center thead-dark" DataKeyNames="SubDepotId" 
                                onrowcommand="loadGridView_RowCommand" >
                                <Columns>
                                    <asp:BoundField DataField="SubDepotCode" HeaderText="Code" />
                                    <asp:BoundField DataField="SubDepotName" HeaderText="Name" />
                                    <asp:BoundField DataField="Address" HeaderText="Adress" />
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"  CssClass="btn-warning  btn-sm mb-1 mb-md-0"
                                                ><i class="bx bxs-edit "></i></asp:LinkButton>
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

