<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MIOwiseInTransitReport.aspx.cs" Inherits="SInventory_UI_MIOwiseInTransitReport" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <style type="text/css"> 
        .excel-button{
            margin-left: 5px;
        }
        
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>                   Receivable Report
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

                                           
                          <div class="col-3">
                              </div>
                         <div class="col-4">

                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label"> National Report: </label>

                                                <div class="col-sm-7">
                                                  <asp:CheckBox ID="CheckBox1" runat="server"  AutoPostBack="True"
                                oncheckedchanged="CheckBox1_CheckedChanged" />
                     
                                                      
                                                    </div>
                                                    </div>
                                         
                                             

                                       

                                              <div class="form-group row"  >
                                                <label for="mainName" class="col-sm-5 col-form-label"> Sales Center :</label>

                                                <div class="col-sm-7">

                                                      <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" onselectedindexchanged="dcDropDownList1_SelectedIndexChanged"
                                >
                            </asp:DropDownList>
                                          
                                                    
                                                     

                                                    </div>
                                                  
                                                    </div>


                                <div class="form-group row"  >
                                                <label for="mainName" class="col-sm-5 col-form-label"> Territory :</label>

                                                <div class="col-sm-7">
                                                       <asp:DropDownList ID="marketDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" 
                             >
                            </asp:DropDownList>
                                                      
                                          
                                                    
                                                     

                                                    </div>
                                                  
                                                    </div>


                               <div class="form-group row"  >
                                                <label for="mainName" class="col-sm-5 col-form-label"> MIO :</label>

                                                <div class="col-sm-7">
                                                    <asp:DropDownList ID="mioDropDownList" runat="server"  
                                 CssClass="form-select form-select-sm mb-3 mySelect2">
                             </asp:DropDownList>
                                                      
                                          
                                                    
                                                     

                                                    </div>
                                                  
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:</label>

                                                <div class="col-sm-7">
                                                          <asp:TextBox ID="InvoiceDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>
                                                 
                      

                                                </div> 
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">To Date:</label>

                                                <div class="col-sm-7">
                                                    
                            <asp:TextBox ID="todateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>




                                                </div>
                                                
                                            </div>

                                           
                             </div>
                         
                      
                         </div>
        
                                      <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">
                                                  
                                                      <asp:LinkButton  OnClick="SearchButton_Click"   runat="server" id="SearchButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
    <asp:LinkButton  OnClick="excelButton_OnClick" Visible="False"  runat="server" id="LinkButton2" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; Export to Excel
                                        </asp:LinkButton>

                                        <asp:LinkButton  runat="server" ID="btnReset"   OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                                                  
                             
                                                  
                                                       <asp:DropDownList ID="DropDownList2" Visible="false" runat="server" CssClass="DropDown" 
                              >
                            </asp:DropDownList>

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
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

 
 

