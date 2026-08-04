<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="ManualOrderCreation.aspx.cs" Inherits="SInventory_UI_ManualOrderCreation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
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

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Manual Order Creation</div>

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
                             <div class="row">

                                            <div class="col-6">
                                                <div class="form-group row">

                                                    <label for="mainName" class="col-sm-3 col-form-label">Customer Name: </label>

                                                    <div class="col-sm-7">
                                                        <div class="input-group">

                                                            
                                                                  <asp:TextBox ID="custCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " 
                                AutoPostBack="True" ontextchanged="custCodeTextBox_TextChanged"></asp:TextBox>
 

<asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculation"
                                                            TargetControlID="custCodeTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetCustomer_New"
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
                                      
                                       

                                              <asp:HiddenField ID="hfCustomerId" runat="server" />
                                                     

<span class="input-group-text text-c-red">*</span>

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

                                                                   var dateNow = new Date();
                                                                   $('.datepickess').datepicker("setDate", dateNow);
                                                                   minDate: new Date() // to disable privious dates 
                                                               </script>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                            </div>


                                           
                                        </div>


                                        <div style="padding:2px!important"></div>

                            
                                        <div class="row" runat="server" visible="false">




                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Order No: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                      <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="form-control form-control-sm  mb-3" ReadOnly="True"></asp:TextBox>
                                                              <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2 "
                                    AutoPostBack="True" OnSelectedIndexChanged="manufacturerDropDownList_SelectedIndexChanged">
                                </asp:DropDownList>
                                                        <span id="v-ddlCampaignType" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
<span class="input-group-text text-c-red">*</span>

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>

                                                 <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Order Date: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                       <asp:TextBox ID="orderDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker " autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                 

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
 
                                        </div>
                                          
                            
                                        <div class="row" runat="server" visible="false">




                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Distribution Center: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                    <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2 ">
                            </asp:DropDownList>
<span class="input-group-text text-c-red">*</span>

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>

                                                 <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	Customer Code: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                   



<span class="input-group-text text-c-red">*</span>

                                                              

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
 
                                        </div>



                            
                                        <div class="row"  runat="server" visible="false">




                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	MIO Code: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                   
 <asp:Label ID="mioCodeLabel"   runat="server"></asp:Label>
                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>

                                                 <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	Customer Name: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                   <asp:Label ID="custNameLabel"   runat="server"></asp:Label>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
 
                                        </div>
                                          

                                    <div class="row"  runat="server" visible="false">




                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	MIO Name: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:Label ID="mioNameLabel" runat="server"  ></asp:Label>
  
                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>

                                                 <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	 	Market Name: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                   <asp:Label ID="marketNameLabel"  runat="server"></asp:Label>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
 
                                        </div>
                                          


                             <div class="row" runat="server" visible="false">




                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	 	Territory Code: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:Label ID="teritory" runat="server"  ></asp:Label>
  
                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>

                                                 <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">  	 	FCB: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                   <asp:Label ID="FCBLabel3"   runat="server"></asp:Label>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
 
                                        </div>
                                          <div style="padding:12px!important"></div>


                            <div class="row">
                               <div class="table-responsive" id="MainGradeDivCustomer">
                                     <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False"   ShowHeaderWhenEmpty="true"    CssClass="table table-bordered  text-center thead-dark">
                                <Columns>
                                    <asp:BoundField DataField="SL" HeaderText="SL" />
                                    <asp:TemplateField HeaderText="Product Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3" AutoPostBack="True"
                                                ToolTip="true" OnTextChanged="productCodeTextBox_TextChanged" Text='<%# Eval("ProductCode")%>'></asp:TextBox>
                                            <asp:HiddenField ID="unitpriceHiddenField" Value='<%# Eval("UnitPrice")%>' runat="server" />
                                            <asp:HiddenField ID="productidHiddenField" Value='<%# Eval("ProductId")%>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" Text='<%# Eval("ProductName")%>'
                                                AutoPostBack="True" ToolTip="true" OnTextChanged="productNameTextBox_TextChanged"></asp:TextBox>

                                            

<asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculassstion"
                                                            TargetControlID="productNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetProductList"
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
                                    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:TextBox ID="packSizeTextBox" runat="server" CssClass="form-control form-control-sm mb-3" ReadOnly="True"
                                                Text='<%# Eval("PackSize")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Req. Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="reqQtyTextBox" runat="server" CssClass="form-control form-control-sm mb-3" Text='<%# Eval("Quantity")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="VAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" CssClass="form-control form-control-sm mb-3" Text='<%# Eval("VAT")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="tpTextBox" runat="server" CssClass="form-control form-control-sm mb-3" Text='<%# Eval("UnitPrice")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                     <asp:TemplateField HeaderText="T. TP">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotaltpTextBox" runat="server" CssClass="form-control form-control-sm mb-3" Text='<%# Eval("Totaltp")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    
                                     <asp:TemplateField HeaderText="T. TP Vat">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotaltpVatTextBox" runat="server" CssClass="form-control form-control-sm mb-3" Text='<%# Eval("TotaltpVat")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="IsGiftProduct" Visible="false">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="IsGiftProductDropDownList" runat="server" CssClass="form-control form-control-sm mb-3">
                                                  <asp:ListItem  Value="True">True</asp:ListItem>
                                                <asp:ListItem  Value="False">False</asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="IsCampaignProduct"  Visible="false">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="IsCampaignProductDropDownList" runat="server" CssClass="form-control form-control-sm mb-3">
                                                <asp:ListItem  Value="True">True</asp:ListItem>
                                                <asp:ListItem  Value="False">False</asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Add">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/lineAdd.png"
                                                OnClick="ImageButton1_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Remove">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/lineDelete.png"
                                                OnClick="ImageButton2_Click" />
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
                                                              <asp:LinkButton  OnClick="submitButton_Click"   OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                            
                                        <asp:LinkButton  runat="server" ID="resetbtn"  OnClick="resetbtn_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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
             </ContentTemplate>
                                </asp:UpdatePanel>


           
</asp:Content>
