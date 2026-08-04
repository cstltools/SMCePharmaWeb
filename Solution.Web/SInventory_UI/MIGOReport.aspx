<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MIGOReport.aspx.cs" Inherits="SInventory_UI_SpecialDiscountReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> STO and Order Report    </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        

                         

<%--                               <asp:LinkButton ID="viewLinkButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="custCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>--%>
                    </div>
                
                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                             <script type="text/javascript">
                                              function pageLoad() {
                                                  $('.datepicker').pickadate({
                                                      selectMonths: true,
                                                      selectYears: true
                                                  })
                                                  $('.mySelect2').select2({
                                                      theme: 'bootstrap4',
                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                      placeholder: $(this).data('placeholder'),
                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                  });
                                              }
                             </script>

                   
    <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Report Type:</label>

                                    <div class="col-sm-5">
                                      
                           
                                     
                                <asp:DropDownList ID="rptTypeDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="form-select form-select-sm mb-3 mySelect2" >
                                <asp:ListItem>--Select--</asp:ListItem>
                              <%--   <asp:ListItem Value="MIGO">Migo Report</asp:ListItem>--%>
                                <asp:ListItem Value="sto">STO Report</asp:ListItem>
                                <asp:ListItem Value="OD">Order Detail</asp:ListItem>
                            </asp:DropDownList>

                                    </div>
                                    
                                </div> 
                                
                                
                                    <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> From Date:</label>

                                    <div class="col-sm-5">
                                      
                            <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker"></asp:TextBox>
                                     
                                   
                                    </div>
                                
                                </div> 


                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> To Date:</label>

                                    <div class="col-sm-5">
                                       <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker"></asp:TextBox>
                          
                                     
                                   
                                    </div>
                                
                                </div>


                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Customer Code:</label>

                                    <div class="col-sm-5">
                                      
                             
                                     
                                     <asp:TextBox ID="custCodeTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                    </div>
                                
                                </div>


                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Order No:</label>

                                    <div class="col-sm-5">
                                      
                         
                                          <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                   
                                    </div>
                                
                                </div>

 
                                     
                                   
                                    </div>
                                
                                </div>


                             <div class="row">
                                        <div class="col-md-4">
                                        </div>
                                        <div class="col-md-4" style="align-content: center">
                                            <asp:LinkButton runat="server" ID="viewRptButton" class="btn btnMyDesignSearch   btn-sm " OnClick="viewRptButton_Click">  <i class="fa fa-print"></i>&nbsp; View Report</asp:LinkButton>


                                            <asp:LinkButton runat="server" class="btn btnMyDesignReset   btn-sm" ID="resetBtn" OnClick="resetBtn_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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


