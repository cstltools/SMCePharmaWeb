<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TopSheetGenerate.aspx.cs" Inherits="SInventory_UI_TopSheetGenerate" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <style type="text/css">
        .button-padding-right {
            margin-right: 5px;
        }       
    </style>
    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    
   <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>--%>

                <%--  <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>--%>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Invoice TopSheet Report</div>

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
             
    
                              <div id="Div1" runat="server" Visible="false">
                    
                      
                            
                        
                            <asp:DropDownList ID="DropDownList1" Visible="false" runat="server" AutoPostBack="True"
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
                                          <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" onselectedindexchanged="dcDropDownList1_SelectedIndexChanged"
                                >
                            </asp:DropDownList>
                                                    
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row" runat="server" visible="false">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Manufacturer :</label>

                                    <div class="col-sm-5">
                                                           
           <asp:DropDownList ID="manufacturerDropDownList" runat="server" AutoPostBack="True"
                                CssClass="form-select form-select-sm mb-3 mySelect2" 
                                onselectedindexchanged="manufacturerDropDownList_SelectedIndexChanged" >
                            </asp:DropDownList>
                                           

                        


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  
                 
                                   <div class="form-group row" runat="server" visible="false">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Market :</label>

                                    <div class="col-sm-5">
                                     
                               <asp:DropDownList ID="MarketDropDownList1" runat="server" AutoPostBack="True"
                                 CssClass="form-select form-select-sm mb-3 mySelect2" 
                                onselectedindexchanged="MarketDropDownList1_SelectedIndexChanged" >
                            </asp:DropDownList>
                                                  
                                             
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">   Invoice Date :</label>

                                    <div class="col-sm-5">
                                     
                                         <asp:TextBox AutoPostBack="True" 
                        ontextchanged="InvoiceDateTextBox_TextChanged" ID="InvoiceDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker"></asp:TextBox>
                            
                      <%--      <asp:CalendarExtender ID="Date"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="InvoiceDateTextBox"
                                TargetControlID="InvoiceDateTextBox">
                            </asp:CalendarExtender>--%>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 

                                   
                                
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Distribution Route :</label>

                                    <div class="col-sm-5">
                                    
                               <asp:DropDownList ID="ddlRoute" runat="server" 
                                 CssClass="form-select form-select-sm mb-3 mySelect2" 
                              >
                            </asp:DropDownList>
                                                  
                                             
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  
                          
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Delivery Man :</label>

                                    <div class="col-sm-5">
                                    
                                  <asp:TextBox   runat="server"   class="form-control form-control-sm "  id="txtDeliveryMan" placeholder="Delivery Man"></asp:TextBox>

                                                  
                                             
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  
                          
                                </div>  
                                </div>  




                           <br />
                        <div class="row">
                            <div class="col-1">&nbsp;</div>
                            <div class="col-11">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">


                                         
                                  <asp:LinkButton ID="SearchButton" CssClass="btn btn-sm btn-info mb-2" runat="server" OnClick="SearchButton_Click" >   <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                          
                                          <asp:LinkButton ID="reportButton" CssClass="btn btn-sm btn-success mb-2" runat="server" OnClick="viewRptButton_Click" >   <i class="fa fa-print"></i>&nbsp; View TopSheet  Report</asp:LinkButton>  

                           
                                              <asp:LinkButton ID="lblInvoice" CssClass="btn btnMyDesignSearch   btn-sm" runat="server" OnClick="lblInvoice_Click" >   <i class="fa fa-print"></i>&nbsp; Print Invoice  Report</asp:LinkButton>  
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        <asp:DropDownList ID="TERRITORYDropDownList1" runat="server" Visible="false" AutoPostBack="True"
                                CssClass="DropDown" 
                               >
                            </asp:DropDownList>
                       
                       <div id="hiddiv" runat="server" Visible="True">
                    
                    
                    </div>
                        <br/>
                     <div class="row">
           <div class="table-responsive" id="MainGradeDiv">

                   <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"  
                                    DataKeyNames="InvoiceId,InvoiceNo"   CssClass="table table-bordered  text-center thead-dark" >
                                    <Columns>
                                        <asp:TemplateField HeaderText="#SL">
                                            <ItemTemplate>
                                                <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                                                  <asp:HiddenField runat="server" ID="hfOrderId" Value='<%#Eval("OrderId")%>' />
                                                  <asp:HiddenField runat="server" ID="hfInvoiceNo" Value='<%#Eval("InvoiceNo")%>' />
                                                  <asp:HiddenField runat="server" ID="hfInvoiceId" Value='<%#Eval("InvoiceId")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        
                                                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"       runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                         <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                          <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                        <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                        <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                         <asp:BoundField DataField="areacode" HeaderText="Territory Code" />
                                        <asp:BoundField DataField="TpGrandTotal" HeaderText="Total Amount" />
                                           <asp:TemplateField HeaderText="Print Invoice">
                                        <ItemTemplate>
                                          <asp:LinkButton ID="gotoinvoiceButton" CssClass="btn btn-sm btn-success mb-2" runat="server" OnClick="gotoinvoiceButton_Click" >   <i class="fa fa-print"></i>&nbsp; View Report</asp:LinkButton>  

                                        
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
      <%--      </ContentTemplate>
        </asp:UpdatePanel>--%>
   
</asp:Content>

