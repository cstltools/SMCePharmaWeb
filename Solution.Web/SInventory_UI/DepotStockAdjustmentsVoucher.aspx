<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DepotStockAdjustmentsVoucher.aspx.cs" Inherits="SInventory_UI_DerectStockOut" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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
     

      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Depot Stock Adjustments Voucher </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
 <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="ListImageButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>

                    
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

                

                    <div class="card-body">
                        



                                  <asp:HiddenField ID="HiddenField1" runat="server" />

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                                                                    
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   Distribution Center :</label>

                                    <div class="col-sm-5">

                                               <asp:DropDownList ID="DistributioncenterDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"  OnSelectedIndexChanged="DistributioncenterDropDownList1_OnSelectedIndexChanged">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">   Customer Code :</label>

                                    <div class="col-sm-5">
 <span style='color: gray;font-size: 10px;'> (Please input ‘N/A’ if no customer)</span>
                                               <asp:TextBox ID="customerTextBox" runat="server" CssClass="form-control form-control-sm"  >
                            </asp:TextBox>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                              
                                  <div class="form-group row" style="display:none">
                                    <label for="" class="col-sm-3 col-form-label">  :</label>

                                    <div class="col-sm-5">
                                     
                          <asp:TextBox ID="ComUnitCodeTextBox" runat="server"  
                                     CssClass="TextBox"></asp:TextBox>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                     
                                   
                                 <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Stock Out Date:</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="StockOutTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                           <%-- <asp:CalendarExtender ID="Date"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="StockOutTextBox"
                                TargetControlID="StockOutTextBox">
                            </asp:CalendarExtender>--%>
                           
                           
                                   
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 

                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Reason   :</label>

                                    <div class="col-sm-5">
                                                              

                                        <asp:TextBox ID="txtReason" runat="server"  CssClass="form-control form-control-sm"></asp:TextBox>

                                              


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  
                                
                                
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Invoice No :</label>

                                    <div class="col-sm-5">
                                     <span style='color: gray;font-size: 10px;'> (Please input ‘N/A’ if no Invoice No.)</span>
                              
                                                                   <asp:TextBox ReadOnly="true" ID="txtproformaInvoice" runat="server" CssClass="form-control form-control-sm"  AutoPostBack="True"  ToolTip="true" OnTextChanged="ProformaInvoice_TextChanged"></asp:TextBox>
                        <asp:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server"
                                                  DelimiterCharacters="" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                                  CompletionSetCount="10" ServiceMethod="GetProformaInvoiceNoNew" ServicePath="SInventoryWebService.asmx"
                                                  TargetControlID="txtproformaInvoice"  CompletionListCssClass="autocomplete_completionListElement"
                                                  CompletionListItemCssClass="autocomplete_listItem" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                  ShowOnlyCurrentWordInCompletionListItem="true">
                        </asp:AutoCompleteExtender>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  
                                <div style="padding:4px;"></div>

                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Product :</label>

                                    <div class="col-sm-5">
                                    
                                            

                                          <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                              CssClass="form-select form-select-sm mb-3 mySelect2"
                                              onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
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

                                 <asp:LinkButton  OnClick="Button1_Click"   runat="server" id="LinkButton2" class="btn btnMyDesignAddtoList  btn-sm"   >
                                            <i class="fa fa-search"></i> Search
                                        </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                       

                        <br/>
    <div class="row">
           <div class="table-responsive" id="MainGrasdeDiv">
       
                    
                <asp:GridView ID="DerectStoctOutGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="DCStoreId,PackSize" >
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                     <asp:TemplateField HeaderText="Product Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_PCode" runat="server"  Text='<%#Eval("PCode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>


                                        <asp:TemplateField HeaderText="Product Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_PName" runat="server"  Text='<%#Eval("PName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                        <asp:TemplateField HeaderText="Stock Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_StockQty" runat="server"  Text='<%#Eval("StockQty") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                         <asp:TemplateField HeaderText="Batch No">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_BatchNo" runat="server"  Text='<%#Eval("BatchNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                   <asp:TemplateField HeaderText="Exp. Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ExpDate" runat="server"  Text='<%#Eval("ExpDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                      <asp:TemplateField HeaderText="Receive Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ReceiveDate" runat="server"  Text='<%#Eval("ReceiveDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                <%--    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />--%>
                                   <%--     <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />--%>
                                    <asp:TemplateField HeaderText="Stoct Out Qty">
                                        <ItemTemplate>
                                               <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="form-control form-control-sm" 
                                                   ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
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

                                <asp:LinkButton ID="LinkButton5" CssClass="btn btn-sm btnMyDesignOne" runat="server" OnClick="addButton_Click"  >   <i class="fa fa-plus"></i>&nbsp; Add to List</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        <br />

                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
       
                    
       
                    <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="DCStoreId,PackSize">
                                <Columns>


                                      <asp:TemplateField HeaderText="Product Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ProductCode" runat="server"  Text='<%#Eval("ProductCode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>


                                        <asp:TemplateField HeaderText="Product Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ProductName" runat="server"  Text='<%#Eval("ProductName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                        <asp:TemplateField HeaderText="Stock Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_StackOutQty" runat="server"  Text='<%#Eval("StackOutQty") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                         <asp:TemplateField HeaderText="Batch No">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_BatchNo2" runat="server"  Text='<%#Eval("BatchNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                   <asp:TemplateField HeaderText="Exp. Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ExpDate2" runat="server"  Text='<%#Eval("ExpDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                      <asp:TemplateField HeaderText="Receive Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ReceiveDate2" runat="server"  Text='<%#Eval("ReceiveDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>  

                                 <%--   <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="StackOutQty" HeaderText="Stock Out Qty" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="ReceiveDate" />--%>

                                        <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />
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

 <asp:LinkButton ID="LinkButton3" CssClass="btn btn-sm   btnMyDesignSearch   btn-sm" runat="server" OnClick="submitButton_Click1" OnClientClick="return sweetAlertConfirm_Submit(this);"   >   <i class="fa fa-check"></i>&nbsp; Submit</asp:LinkButton>
                            

                                           <asp:LinkButton  runat="server" ID="lblcancel"   OnClick="lblcancel_OnClick"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                         
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

      <%--   <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Depot Stock Adjustments Voucher
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            <asp:HiddenField ID="HiddenField1" runat="server" />
                    
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">

                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            View List :
                        </td>
                        <td width="20%" class="TDRight">
                    
                            <asp:ImageButton ID="ImageButton3" runat="server" 
                                             ImageUrl="~/images/viewList.png" onclick="ListImageButton_Click" />
                            </td>
                        <td width="13%" class="TDLeft">
                       
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
             
                    
                       <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            </td>
                        <td width="13%" class="TDLeft">
                            Distribution Center
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="DistributioncenterDropDownList1" runat="server" CssClass="DropDown" AutoPostBack="True"  OnSelectedIndexChanged="DistributioncenterDropDownList1_OnSelectedIndexChanged">
                            </asp:DropDownList>
                            </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>

                
                <tr runat="server" visible="False">
                    <td width="13%" class="TDLeft">
                    </td>
                    <td width="20%" class="TDRight">
                        </td>
                    <td width="13%" class="TDLeft">
                        <asp:TextBox ID="ComUnitCodeTextBox" runat="server"  
                                     CssClass="TextBox"></asp:TextBox>
                       
                    </td>
                    <td width="20%" class="TDRight">
                    </td>
                    <td width="13%" class="TDLeft">
                           
                    </td>
                    <td width="20%" class="TDRight">
                    </td>
                </tr>

                <tr >
                    <td width="13%" class="TDLeft">
                        &nbsp;</td>
                    <td width="20%" class="TDRight">
                    </td>
                    <td width="13%" class="TDLeft">
                        Proforma Invoice No
                        &nbsp;
                    </td>
                    <td width="20%" class="TDRight">
                        <asp:TextBox ID="txtproformaInvoice" runat="server" CssClass="TextBox"  AutoPostBack="True"  ToolTip="true" OnTextChanged="ProformaInvoice_TextChanged"></asp:TextBox>
                        <asp:AutoCompleteExtender ID="txtproformaInvoice_AutoCompleteExtender" runat="server"
                                                  DelimiterCharacters="" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                                  CompletionSetCount="10" ServiceMethod="GetProformaInvoiceNo" ServicePath="SInventoryWebService.asmx"
                                                  TargetControlID="txtproformaInvoice"  CompletionListCssClass="autocomplete_completionListElement"
                                                  CompletionListItemCssClass="autocomplete_listItem" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                  ShowOnlyCurrentWordInCompletionListItem="true">
                        </asp:AutoCompleteExtender>
                      
                    </td>
                    <td width="13%" class="TDLeft">
                        &nbsp;</td>
                    <td width="20%" class="TDRight">
                        &nbsp;</td>
                </tr>

                <tr>
                    <td width="13%" class="TDLeft">
                    </td>
                    <td width="20%" class="TDRight">
                        </td>
                    <td width="13%" class="TDLeft">
                        Proforma Invoice No
                    </td>
                    <td width="20%" class="TDRight">
                        <asp:DropDownList ID="ProformaInvoiceNumDropDownList" runat="server" 
                                          CssClass="DropDown" >
                        </asp:DropDownList>
                       </td>
                    <td width="13%" class="TDLeft">
                    
                    </td>
                    <td width="20%" class="TDRight">
                    </td>
                </tr>
                
                

                <tr>
                    <td class="TDLeft" width="13%">
                    </td>
                    <td class="TDRight" width="20%">
                        </td>
                    <td class="TDLeft" width="13%">
                        Stock Out Date
                    </td>
                    <td class="TDRight" width="20%">
                        <asp:TextBox ID="StockOutTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                         TabIndex="4" ID="imgDate"></asp:ImageButton>
                        <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="StockOutTextBox"
                                              PopupButtonID="imgDate">
                        </asp:CalendarExtender>

                    </td>
                    <td class="TDLeft" width="13%">
                          
                    <td class="TDRight" width="20%">
                    </td>
                </tr>

       
                   
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                             </td>
                        <td class="TDLeft" width="13%">
                            Reason
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="txtReason" runat="server" CssClass="TextBox" 
                                         Height="21px"></asp:TextBox>
                           </td>
                        <td class="TDLeft" width="13%">
                            
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
           
               
                   
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            </td>
                        <td class="TDLeft" width="13%">
                            Product
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                              CssClass="DropDown" 
                                              onselectedindexchanged="salescenterDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                
                <tr>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                       
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                </tr>

                <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:Button ID="Button2" runat="server" Text="Search Product" onclick="Button1_Click" />
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                <tr>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                </tr>
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="DerectStoctOutGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="DCStoreId,PackSize" >
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="PName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="StockQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Stoct Out Qty">
                                        <ItemTemplate>
                                               <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="TextBox" 
                                                Height="21px"    ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                <tr>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                         <asp:Button ID="addButton" runat="server" Text="Add" 
                                onclick="addButton_Click" />
                    </td>
                    <td class="TDLeft" width="13%">
                        &nbsp;</td>
                    <td class="TDRight" width="20%">
                        &nbsp;</td>
                </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:Button ID="addButton" runat="server" Text="Add" 
                                onclick="addButton_Click" />
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                   
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" colspan="6">
                            <asp:GridView ID="chalanGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="DCStoreId,PackSize">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="StackOutQty" HeaderText="Stock Out Qty" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="ReceiveDate" />

                                        <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp; </td>
                        <td class="TDRight" width="20%" colspan="2">
                        
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" >
                            &nbsp;</td>
                            <td width="20%" class="TDRight">
                                <asp:Button ID="submitButton" runat="server" onclick="submitButton_Click1" 
                                            Text="Submit" />
                                &nbsp;
                            </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                         
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            </td>
                        <td class="TDRight" width="20%">
                           
                        </td>                            

                        <td class="TDLeft" width="13%">
                            <asp:Button ID="Button2" runat="server" BackColor="#660033" 
                                onclick="Button2_Click" Text="Print" />
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

