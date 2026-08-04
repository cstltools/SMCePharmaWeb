<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="AdjustmentTypeView.aspx.cs" Inherits="SInventory_UI_AdjustmentTypeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">





     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Adjustment Type List </div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="viewLinkButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="custCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>


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
                                   
                                   

                                       

                                            <div class="table-responsive" id="MainGradeDiv">
       
                                              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-bordered  text-center thead-dark"  OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="AdjustmentTypeId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="AdjustmentType" HeaderText="Adjustment Type" />
                                
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

