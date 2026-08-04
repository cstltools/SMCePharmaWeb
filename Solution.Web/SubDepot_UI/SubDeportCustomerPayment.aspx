<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubDeportCustomerPayment.aspx.cs" Inherits="SubDepot_UI_SubDeportCustomerPayment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    


    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

                  <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWytytyait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Market Wise Customer Payment </div>

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
                                    <label for="mainName" class="col-sm-3 col-form-label">  	Sales Center:</label>

                                    <div class="col-sm-5">
                                           <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                onselectedindexchanged="salesCenterDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   
                 
                                  

                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	 Market:</label>

                                    <div class="col-sm-5">
                                      <asp:DropDownList ID="subdeportDropDownList1" runat="server" 
                        CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                         ></asp:DropDownList>
 
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 


                                                <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	 Payment Date:</label>

                                    <div class="col-sm-5">
                                        
   
                           
                            <asp:TextBox ID="paymentDtTextBox" runat="server" AutoPostBack="True" ReadOnly="True"
                                CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                                   
                                     <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	 Payment Amount:</label>

                                    <div class="col-sm-5">
                                 <asp:TextBox ID="paymentAmountTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "></asp:TextBox>
                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="paymentAmountTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                  
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 


                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	 Payment Type:</label>

                                    <div class="col-sm-5">
                                   
 
                             <asp:DropDownList ID="payTypeDDL" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            </asp:DropDownList>
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 

                                 <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	  Ref No:</label>

                                    <div class="col-sm-5">
                                                                  <asp:TextBox ID="refNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "></asp:TextBox>

                            <asp:TextBox ID="customerTextBox" runat="server" Visible="false" CssClass="TextBox" 
                                AutoPostBack="True" ontextchanged="customerTextBox_TextChanged"></asp:TextBox>
                       
                                     <asp:DropDownList ID="marketDropDownList" runat="server" Visible="false" AutoPostBack="True" 
                                CssClass="DropDown" 
                                onselectedindexchanged="marketDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                        
                            <asp:TextBox ID="refDtTextBox" runat="server" Visible="false" AutoPostBack="True" 
                                CssClass="TextBoxCalander"></asp:TextBox>
                                        <asp:DropDownList Visible="false" ID="customerDropDownList" runat="server" AutoPostBack="True" 
                                CssClass="DropDown" 
                                onselectedindexchanged="customerDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                                   
                                </div>  
                                </div>  




                           <br />
                    
                       

                        <br/>
                     <div class="row">
           <div class="table-responsive" id="MainGradeDiv">
                            <asp:GridView ID="orderGridView" runat="server" AutoGenerateColumns="False" 
                                  DataKeyNames="InvoiceId,CustomerMasterId"  CssClass="table table-bordered  text-center thead-dark">
                                <Columns>
                                    <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" OnCheckedChanged="chkSelect_OnCheckedChanged" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Pro.Invoice No" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Pro.Invoice Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Del Invoice No" />
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Del Invoice Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="DeliveryTpGrandTotal" HeaderText="Del Inv Amount" HtmlEncodeFormatString="False"/>
                                     <asp:BoundField DataField="PaymentAmount" HeaderText="Previous Pay"  HtmlEncodeFormatString="False"/>
                                     <asp:BoundField DataField="Due" HeaderText="Due Amount" />
                                    <asp:TemplateField HeaderText="Pay Amount">
                                        <ItemTemplate>
                                            <asp:TextBox ID="payAmountTextBox" runat="server" AutoPostBack="True" Text= <%# Eval("Due")%> 
                                                ontextchanged="payAmountTextBox_TextChanged"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="payAmountTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>


</div>
                         </div>

                       <br />
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-8">

                                                    <div class="form-group row">
                                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                        <div class="col-sm-8">
                                                              <asp:LinkButton  OnClick="saveButton_Click" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="saveButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                               

                                                         
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>
                       </ContentTemplate>
        </asp:UpdatePanel>
    

     
</asp:Content>

