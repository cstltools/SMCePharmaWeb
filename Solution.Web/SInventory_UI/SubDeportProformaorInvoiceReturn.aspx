<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubDeportProformaorInvoiceReturn.aspx.cs" Inherits="SInventory_UI_SubDeportProformaorInvoiceReturn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Sub-Depot Proforma/Invoice Return  </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_OnClick" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
             
    
                              <div id="hiddiv" runat="server" Visible="false">
                    
                      
                            
                        
                            <asp:DropDownList ID="TERRITORYDropDownList1" Visible="false" runat="server" AutoPostBack="True"
                                CssClass="DropDown" 
                               >
                            </asp:DropDownList>
                        
                    </div>

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

                   <div class="card-body">
                    
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                               
                                       <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Proforma :</label>

                                    <div class="col-sm-5">

                                                  <asp:CheckBox ID="ProformaCheckBox" runat="server" AutoPostBack="True" 
                                oncheckedchanged="ProformaCheckBox_CheckedChanged"  />
                                                                 
                                    </div>

                                   
                                </div>
                                

                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Invoice :</label>

                                    <div class="col-sm-5">

                                                 <asp:CheckBox ID="InvoiceCheckBox" runat="server" AutoPostBack="True" 
                                oncheckedchanged="InvoiceCheckBox_CheckedChanged"   />
                                                                 
                                    </div>

                                   
                                </div>  


                                     <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> No :</label>

                                    <div class="col-sm-5">

                                                <asp:TextBox ID="proformaInvoiceTextBox" runat="server" 
                                ontextchanged="proformaInvoiceTextBox_TextChanged" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"></asp:TextBox>
                                                                 
                                    </div>

                                   
                                </div> 


                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-5">

                                               
                                              <asp:LinkButton  OnClick="saveButton_Click"  OnClientClick="return sweetAlertConfirm_Delete(this);"   runat="server" id="saveButton" class="btn btn-danger   btn-sm"  >
                                            <i class="fa fa-trash"></i>Delete
                                        </asp:LinkButton>                   
                                    </div>

                                   
                                </div> 

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

