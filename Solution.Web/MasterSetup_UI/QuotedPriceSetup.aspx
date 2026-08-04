<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="QuotedPriceSetup.aspx.cs" Inherits="MasterSetup_UI_QuotedPriceSetup" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
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
            font-size: 12px !important;
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
            font-size: 12px !important;
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
      <div id="popDiv">

</div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Quoted Price Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../MasterSetup_UI/QuotedPriceView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
 <asp:HiddenField runat="server" ID="id_mastetID"/>


                                     <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-3 col-form-label"> Description:</label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <asp:TextBox  class="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="2"  runat="server" id="txtDescription" placeholder=" Description"></asp:TextBox>

                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                                    
                                     <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-3 col-form-label"> Policy Info:</label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <asp:TextBox  class="form-control form-control-sm mb-3 "  TextMode="MultiLine" Rows="2"  runat="server" id="txtPolicy" placeholder=" Policy"></asp:TextBox>

                                          <script type="text/javascript">
                                              function pageLoad() {

                                                  function ValidationTooltip(id, message) {


                                                      $(id).empty();

                                                      if ($(id).empty()) {
                                                          $(id).append(message);
                                                      }
                                                      $(id).toast('show');
                                                      $(id).css("display", "block");



                                                  }
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

                                                  $(function () {
                                                      $(".clsDecimal").keypress(function (event) {

                                                          $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                                                          if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                                                              /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                                                              /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                                                           
                                                              return false;
                                                          }
                                                      });
                                                  });

                                              
                                              }
                                             

                                          </script>
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                                        <div class="row" runat="server" visible="false">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-3 col-form-label"> &nbsp;</label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                         <asp:RadioButtonList  class="chkRadioChoice" AutoPostBack="true" OnSelectedIndexChanged="rbType_SelectedIndexChanged" runat="server" ID="rbType" RepeatDirection="Horizontal">
                                             <asp:ListItem Selected="True" Value="1">Customer Wise</asp:ListItem>
                                             <asp:ListItem Value="0">Market Wise</asp:ListItem>
                                              </asp:RadioButtonList>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                    
                                    <div id="divMarket" runat="server" visible="false">
                                        
<uc1:IVMarketStructure  runat="server" ID="IVMarketStructure" />
                                    </div>


                                          <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-3 col-form-label"> Active From Date:</label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <asp:TextBox  class="form-control form-control-sm mb-3 datepicker"  runat="server" id="txtFromDate" placeholder=" Select Date"></asp:TextBox>

                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>


                                     <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-3 col-form-label"> Active To Date:</label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <asp:TextBox  class="form-control form-control-sm mb-3 datepicker"  runat="server" id="txtToDate" placeholder=" Select Date"></asp:TextBox>

                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                                             <div class="row" id="divCus" runat="server">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Customer: </label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                       <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " 
                                AutoPostBack="True" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>

                                              <%--  <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetCustomer" ServicePath="~/SInventoryWebService.asmx"  TargetControlID="custNameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true"
                                        >
                                    </asp:AutoCompleteExtender>--%>

<asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculation"
                                                            TargetControlID="custNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetCustomer_ALL_Active"
                                                            ServicePath="SInventoryWebService.asmx"
                                                            MinimumPrefixLength="1"
                                                            CompletionInterval="10"
                                                            EnableCaching="false"
                                                            CompletionSetCount="1"
                                                            FirstRowSelected="false" CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                                        </asp:AutoCompleteExtender>
                                      
                                        <%--      <asp:AutoCompleteExtender ID="custNameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetCustomer" ServicePath="SInventoryWebService.asmx"  TargetControlID="custNameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true"
                                        >
                                    </asp:AutoCompleteExtender>--%>

                                              <asp:HiddenField ID="hfCustomerId" runat="server" />
                                         
    <span class="input-group-text text-c-red">*</span>




                                              
                                              </div>

                                    </div> 
                                       <div class="col-3">
                                          <div class="input-group">
                                               <asp:LinkButton ID="btnAdd" runat="server" class="btn btnMyDesignAddtoList   btn-sm"  OnClick="btnAdd_Click" ><i class="fa fa-plus-circle"></i> Add to List</asp:LinkButton>
                                               </div>
                                      </div>
                                </div>
                                </div>
                                 
                                </div>
                                       <div class="row">
                                            <div class="col-2">
                                                </div>
                                            <div class="col-8">
                                      <div class="table-responsive" id="MainGradeDiv2">

                                                  <asp:GridView ID="gv_CustomerList" runat="server" AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark"  >
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("CustomerMasterId")%>' />

                                               
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                      
                                                <asp:TemplateField HeaderText="Customer">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_Customer" runat="server" Text='<%#Eval("Customer") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                
                                                                        <asp:TemplateField HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="rmv_Customer" runat="server" OnClick="rmv_Customer_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                    </Columns>
                                                                </asp:GridView>
                                  

                                </div>
                                </div>

                                           <div class="col-2">
                                                </div>
                                </div>

            <br />
                                      <div class="row">
                            <div class="col-7">&nbsp;</div>
                                       <div class="col-4">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">Discount  Percent (%):</label>

                                    <div class="col-sm-4">
                                          <div class="input-group">
                                        <asp:TextBox  class="form-control form-control-sm mb-3 clsDecimal" AutoPostBack="true" OnTextChanged="txtCmnPercent_TextChanged" runat="server" id="txtCmnPercent" placeholder="Percent (%)"></asp:TextBox>

                                          

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>
                              <div class="row">
                           
                                       <div class="col-12">

                                            <div class="table-responsive" id="MainGradeDiv">

                                                  <asp:GridView ID="gv_ProductList" runat="server" AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark" >



                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfProductId" Value='<%#Eval("ProductId")%>' />
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


                                                                          <asp:TemplateField HeaderText="Product Code">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_ProductCode" runat="server" Text='<%#Eval("ProductCode") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                                <asp:TemplateField HeaderText="Product Name">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_ProductName" runat="server" Text='<%#Eval("ProductName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                                  <asp:TemplateField HeaderText="Description">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_Description" runat="server" Text='<%#Eval("Description") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                            


                                                                            <asp:TemplateField HeaderText="TP">
                                                    <ItemTemplate>
                                                        <asp:Label ID="txtUnitPrice" runat="server" Text='<%#Eval("UnitPrice") %>' CssClass="form-control form-control-sm mb-3 clsDecimal"></asp:Label>
                                                           
                                                    </ItemTemplate>
                                                </asp:TemplateField>


                                                                               <asp:TemplateField HeaderText="Discount Percent (%)">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtVat" runat="server"   AutoPostBack="true" OnTextChanged="txtUnitPrice_TextChanged"   Text='<%#Eval("Vat") %>' CssClass="form-control form-control-sm mb-3 clsDecimal"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                                <asp:TemplateField HeaderText="Discount Amount">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtDiscountPercent" runat="server" AutoPostBack="true" OnTextChanged="lblDiscountPercent_TextChanged" Text='<%#Eval("DiscountPercent") %>' CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                            <asp:TemplateField HeaderText="Final Amount">
                                                    <ItemTemplate>
                                                        <asp:Label ID="txtDiscountShow" runat="server" Text='<%#Eval("DiscountShow") %>' CssClass="form-control form-control-sm mb-3 clsDecimal"></asp:Label>
                                                           
                                                    </ItemTemplate>
                                                </asp:TemplateField>


                                                                       


                                                                     
                                                                         

                                                                        

                                                                    </Columns>
                                                                </asp:GridView>
                                  

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
                                


                                        
                                                      <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnUpdate_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" id="restbtn" OnClick="restbtn_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
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

