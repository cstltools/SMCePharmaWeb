<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="AreaWiseMonthlyInventoryReport.aspx.cs" Inherits="SInventory_UI_AreaWiseMonthlyInventoryReport" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

      <style type="text/css">
        .button-padding-right {
            margin-right: 5px;
        }   
         .SelectchkChoice label {
            padding-left: 4px;
            font-weight: bold;
        }
    </style>
    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>                             DC Monthly Inventory Report
</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                      
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
                    
                           <script type="text/javascript">
                               function pageLoad() {
                                   $('.mySelect2').select2({
                                       theme: 'bootstrap4',
                                       width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                       placeholder: $(this).data('placeholder'),
                                       allowClear: Boolean($(this).data('allow-clear')),
                                   });
                                   $('.datepicker').pickadate({
                                       selectMonths: true,
                                       selectYears: true
                                   })

                               }
                           </script>

                     <div class="row">

                                           

                         <div class="col-4">

                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label">National </label>

                                                <div class="col-sm-7">
                                                        <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" 
                                oncheckedchanged="CheckBox1_CheckedChanged" />
                     
                                                      
                                                    </div>
                                                    </div>
                                         
                                             

                                       

                                              <div class="form-group row"  runat="server" id="branch">
                                                <label for="mainName" class="col-sm-5 col-form-label">Branch:</label>

                                                <div class="col-sm-7">

                                                     <asp:DropDownList ID="branchDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            </asp:DropDownList>
                                          

                                                     

                                                    </div>
                                                  
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:</label>

                                                <div class="col-sm-7">
                                                          
                                                 
                            <asp:TextBox ID="fromDateTextBox" runat="server"  AutoPostBack="true" OnTextChanged="fromDateTextBox_TextChanged"  CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>



                                                </div> 
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">To Date:</label>

                                                <div class="col-sm-7">
                                                    
                            <asp:TextBox ID="todateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>
                                                 



                                                </div>
                                                
                                            </div>

                                           
                             </div>
                         
                         <div class="col-8" runat="server" visible="false">
                                                <%--<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />--%>
                                            </div>
                         </div>
        
                                      <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                                                      <asp:LinkButton  OnClick="viewRptButton_Click"   runat="server" id="viewRptButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  
                                                       <asp:DropDownList ID="marketDropDownList" Visible="false" runat="server" CssClass="DropDown" 
                              >
                            </asp:DropDownList>

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>
      
                    </ContentTemplate>
                  <Triggers>
                  
             </Triggers>
                </asp:UpdatePanel>
                            </div>

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>   
     
</asp:Content>
