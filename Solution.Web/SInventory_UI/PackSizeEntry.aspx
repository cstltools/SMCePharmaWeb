<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PackSizeEntry.aspx.cs" Inherits="SInventory_UI_PackSizeEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"> <i class="bx bx-customize"></i> Pack Size Entry</div>
                
                <div class="ms-auto">
                    <div class="btn-group">



                        <asp:LinkButton ID="detailsViewButton" CssClass="btn btn-sm btn-sm btn-outline-info" runat="server" OnClick="detailsViewButton_Click"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>


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
                                   <%-- <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>
                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait7" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Pulse45.gif" Width="150px" Height="150px" />
                                            </div>

                                        </ProgressTemplate>
                                    </asp:UpdateProgress>--%>
                                    <div class="p-4 border rounded">
                                        <div class="row g-3 needs-validation">

                                            <div class="row">&nbsp;</div>
                                            <div class="row">&nbsp;</div>
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-10">

                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Pack Size:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                                                            

                                                                   <asp:TextBox ID="packsizeNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3"  ></asp:TextBox>
                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                         <asp:HiddenField ID="packSizeIdHiddenField" runat="server" />
                                                            <br />
                                                          <div class="form-group">
                                                                <asp:LinkButton ID="submitButton" Visible="false" CssClass="btn btnMyDesignSearch   btn-sm" runat="server" OnClick="submitButton_Click"><i class="fa fa-check"></i>Submit</asp:LinkButton>

                                                                  <asp:LinkButton ID="updateButton" Visible="false" CssClass="btn btnMyDesignSearch   btn-sm" runat="server" OnClick="submitButton_Click"><i class="fa fa-check"></i>Update</asp:LinkButton>

                                                                <asp:LinkButton ID="ResetBtn"   CssClass="btn btnMyDesignReset   btn-sm" runat="server" OnClick="ResetBtn_Click"><i class="fa fa-retweet"></i> Reset</asp:LinkButton>


                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
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



