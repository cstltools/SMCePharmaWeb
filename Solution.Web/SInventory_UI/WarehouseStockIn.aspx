<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="WarehouseStockIn.aspx.cs" Inherits="SInventory_UI_WarehouseStockIn" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%--<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <style type="text/css">
        /*AutoComplete flyout */
        .autocomplete_completionListElement {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto!important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 300px !important;

            overflow: auto!important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35)!important;
        }


         .autocomplete_completionListElement222 {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto!important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 600px !important;

            overflow: auto!important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35)!important;
        }
        /* AutoComplete highlighted item */

        .autocomplete_highlightedListItem {
            
            
              
    
            background-color: #17A2B8 !important;
            color: white !important;
            padding: 6px !important;
            font-weight: bold !important;
    
    
        }

        /* AutoComplete item */

        .autocomplete_listItem {
            padding: 6px !important;
            cursor: pointer !important;
            font-weight: bold !important;
            background-color: #fff !important;
            border-bottom: 1px solid #d4d4d4 !important; 
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset !important;
        }
    </style>


    <style>
        .checkboxlist_nowrap {
            display: inline;
        }
    </style>
    
       
</asp:Content>
 
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Warehouse Stock In </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
 <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_OnClick" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

          
                    <div class="card-body">
                   
 <div class="row">&nbsp;</div>
                        <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Manufacturer:</label>
                                    <div class="col-sm-5">
                       <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 "  ID="manufacturerDropDownList"   runat="server">
                            </asp:DropDownList>
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

                            <asp:HiddenField ID="stockInIdHiddenField" runat="server" />
                                       
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Supplier:</label>

                                    <div class="col-sm-5">
                                         <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 "  ID="supplierDropDownList"   runat="server"
                                 >
                            </asp:DropDownList>
                            <%-- <script type="text/javascript">
                                 function pageLoad() {
                                     $('.js-example-basic-single').select2({ disable_search_threshold: 5, search_contains: true });
                                 }
                             </script>--%>
                                        


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 



 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Stock In Date:</label>

                                    <div class="col-sm-5">
                                        <asp:TextBox ID="stockInDateTextBox"    runat="server" CssClass="form-control form-control-sm  datepicker"
                                AutoPostBack="True" OnTextChanged="stockInDateTextBox_OnTextChanged"></asp:TextBox>
 
                             
                          <%--  <cc1:CalendarExtender    PopupPosition="TopRight"   ID="manufacturerDate1" CssClass="MyCalendar" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="stockInDateTextBox" PopupButtonID="stockInDateTextBox">
                            </cc1:CalendarExtender>--%>

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  




 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Challan No:</label>

                                    <div class="col-sm-5">
                                       <asp:TextBox ID="challanNoTextBox" runat="server"  CssClass="form-control form-control-sm "></asp:TextBox>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  


 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Challan Date:</label>

                                    <div class="col-sm-5">
                                        <asp:TextBox ID="challanDateTextBox"  runat="server" CssClass="form-control form-control-sm  datepicker "
                                AutoPostBack="True" OnTextChanged="challanDateTextBox_OnTextChanged"></asp:TextBox>
 
                       

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  



 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Reference No:</label>

                                    <div class="col-sm-5">
                                      
 <asp:TextBox ID="referenceNoTextBox"  CssClass="form-control form-control-sm " runat="server"></asp:TextBox>
                                    </div>
                                
                                </div> 



<div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Reference Date:</label>

                                    <div class="col-sm-5">
                                        <asp:TextBox ID="referenceDateTextBox"  runat="server" CssClass="form-control form-control-sm  datepicker "
                                ></asp:TextBox>
 
                             
                        <%--    <cc1:CalendarExtender ID="manufacturerDate1sd"  PopupPosition="TopRight"   CssClass="MyCalendar" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="referenceDateTextBox" PopupButtonID="referenceDateTextBox">
                            </cc1:CalendarExtender>--%>

                                    </div>
                                  
                                </div> 



<div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Remarks:</label>

                                    <div class="col-sm-5">
                                        <asp:TextBox ID="remarksTextBox" CssClass="form-control"   runat="server" ></asp:TextBox>
                                    </div>
                                    
                                </div> 

</div>
</div>
<br/>
<div class="row">
      <div class="table-responsive" id="MainGradeDiv">
   <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False"  CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                            <asp:HiddenField ID="productidHiddenField" Value='<%# Eval("ProductId")%>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="P.Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server" ReadOnly="true"   CssClass="form-control form-control-sm "  
                                                AutoPostBack="True" ToolTip="true" OnTextChanged="productCodeTextBox_TextChanged"
                                                Text='<%# Eval("ProductCode")%>'></asp:TextBox>
                                              <%--  <cc1:AutoCompleteExtender ID="productCodeTextBox_AutoCompleteExtender" runat="server"
                                                     DelimiterCharacters="" EnableCaching="true"
                                                    Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                    ServiceMethod="GetProductWithCode" ServicePath="SInventoryWebService.asmx"  TargetControlID="productCodeTextBox" 
                                                    UseContextKey="True"
                                                    CompletionListCssClass="autocomplete_completionListElement" 
                                                    CompletionListItemCssClass="autocomplete_listItem" 
                                                    CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                    ShowOnlyCurrentWordInCompletionListItem="true"
                                                    >
                                                </cc1:AutoCompleteExtender>--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server"   CssClass="form-control form-control-sm "  
                                                Text='<%# Eval("ProductName")%>' AutoPostBack="True"  ToolTip="true"
                                                OnTextChanged="productNameTextBox_TextChanged"></asp:TextBox>
                                               <%-- <cc1:AutoCompleteExtender ID="productNameTextBox_AutoCompleteExtender" runat="server"
                                                     DelimiterCharacters="" EnableCaching="true"
                                                    Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                    ServiceMethod="GetProductWithCode" ServicePath="SInventoryWebService.asmx"  TargetControlID="productNameTextBox" 
                                                    UseContextKey="True"
                                                    CompletionListCssClass="autocomplete_completionListElement" 
                                                    CompletionListItemCssClass="autocomplete_listItem" 
                                                    CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                    ShowOnlyCurrentWordInCompletionListItem="true"
                                                    >
                                                </cc1:AutoCompleteExtender>--%>

                                             <asp:AutoCompleteExtender
                                                            ID="productNameTextBox_AutoCompleteExtender"
                                                            TargetControlID="productNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetProductWithCode"
                                                            ServicePath="SInventoryWebService.asmx"
                                                            MinimumPrefixLength="1"
                                                            CompletionInterval="10"
                                                            EnableCaching="false"
                                                            CompletionSetCount="1"
                                                            FirstRowSelected="false"  CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                                        </asp:AutoCompleteExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UOM">
                                        <ItemTemplate>
                                            <asp:TextBox ID="uomTextBox" Enabled="False"  CssClass="form-control form-control-sm "  runat="server"   
                                                ReadOnly="True" Text='<%# Eval("UOM")%>'></asp:TextBox>
                                                
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:TextBox ID="packSizeTextBox"   CssClass="form-control form-control-sm "  runat="server" 
                                                ReadOnly="True" Text='<%# Eval("PackSize")%>'></asp:TextBox>
                                                
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchTextBox"   CssClass="form-control form-control-sm "  runat="server"  
                                                Text='<%# Eval("Batch")%>'></asp:TextBox>
                                               <%-- <cc1:AutoCompleteExtender ID="batchTextBox_AutoCompleteExtender" runat="server"
                                                     DelimiterCharacters="" EnableCaching="true"
                                                    Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                    ServiceMethod="GetPreBatch" ServicePath="SInventoryWebService.asmx"  TargetControlID="batchTextBox" 
                                                    UseContextKey="True"
                                                    CompletionListCssClass="autocomplete_completionListElement" 
                                                    CompletionListItemCssClass="autocomplete_listItem" 
                                                    CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                    ShowOnlyCurrentWordInCompletionListItem="true"
                                                    >
                                                </cc1:AutoCompleteExtender>--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Mfg.Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="mfgDateTextBox" runat="server"  Text='<%# Eval("MfgDate")%>' 
                                                 CssClass="form-control form-control-sm datepicker" AutoPostBack="True" OnTextChanged="mfgDateTextBox_OnTextChanged"></asp:TextBox>
                                               <%--   <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                                TabIndex="4" ID="ImageButton15"></asp:ImageButton>--%>
                                            
                                            
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exp.Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="expDateDateTextBox" runat="server"  Text='<%# Eval("ExpDate")%>'
                                                CssClass="form-control form-control-sm datepicker" AutoPostBack="True" OnTextChanged="expDateDateTextBox_OnTextChanged"></asp:TextBox>
                                            <%--<asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                                TabIndex="4" ID="ImageButton25"></asp:ImageButton>--%>
                                           
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="reqQtyTextBox" runat="server"    CssClass="form-control form-control-sm " 
                                                Text='<%# Eval("Quantity")%>' AutoPostBack="True" OnTextChanged="reqQtyTextBox_OnTextChanged"></asp:TextBox>
                                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="reqQtyTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="costPriceTextBox" runat="server"  ReadOnly="True" 
                                                Text='<%# Eval("Price")%>'  CssClass="form-control form-control-sm "  AutoPostBack="True"  OnTextChanged="costPriceTextBox_OnTextChanged"></asp:TextBox>
                                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExssstender2" runat="server"
                                                                                        Enabled="True" TargetControlID="costPriceTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vat">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server"   CssClass="form-control form-control-sm "  ReadOnly="True" 
                                                Text='<%# Eval("Vat")%>' AutoPostBack="True" OnTextChanged="vatTextBox_OnTextChanged"></asp:TextBox>
                                           <asp:FilteredTextBoxExtender ID="FilteredTextBssdaasoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="vatTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Amt">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalValueTextBox" runat="server"   CssClass="form-control form-control-sm " 
                                                Text='<%# Eval("TotalAmount")%>' ReadOnly="True" AutoPostBack="True" OnTextChanged="totalValueTextBox_OnTextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField >
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/lineAdd.png"
                                                OnClick="ImageButton1_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField >
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/lineDelete.png"
                                                OnClick="ImageButton2_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
</div>

</div>

 
                        <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-3">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Total Qty:</label>

                                    <div class="col-sm-2">
                                        <asp:TextBox ID="totalQtyTextBox"  CssClass="form-control form-control-sm "  runat="server" class="TextBox" ReadOnly="True"></asp:TextBox>
                           
                         
                                        


                                    </div>
                                    
                                </div> 

  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   Total Vat:</label>

                                    <div class="col-sm-2">
  <asp:TextBox ID="totalVatTextBox"  CssClass="form-control form-control-sm " ReadOnly="True"   runat="server"></asp:TextBox>
                                       
                         
                                        


                                    </div>
                                    
                                </div> 

  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   Grand Total:</label>

                                    <div class="col-sm-2">
                                        <asp:TextBox ID="grandTotalTextBox" Height="23px" runat="server"  CssClass="form-control form-control-sm "
                                ReadOnly="True"></asp:TextBox>
                         
                                        


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

 <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton_Click" style="background-color: #00bcd4;color: #fff;"
                             OnClientClick="return confirm('Are you sure you want to Save ?');"> <i class="fa fa-check-square"></i>&nbsp; Submit Information</asp:LinkButton>
                            <asp:LinkButton ID="cancelButton"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
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
