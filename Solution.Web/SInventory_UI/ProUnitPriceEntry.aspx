<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ProUnitPriceEntry.aspx.cs" Inherits="SInventory_UI_ProUnitPriceEntry" %>
<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
       
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">




    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"> <i class="bx bx-customize"></i> Unit Price Entry</div>
                
                <div class="ms-auto">
                    <div class="btn-group">



                        <asp:LinkButton ID="detailsViewButton" CssClass="btn btn-sm btn-sm btn-outline-info" runat="server" OnClick="detailsViewButton_Click"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>


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

   <asp:HiddenField ID="unitPriceIdHiddenField" runat="server" />
                                   <%-- <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>
                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait7" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Pulse45.gif" Width="150px" Height="150px" />
                                            </div>

                                        </ProgressTemplate>
                                    </asp:UpdateProgress>--%>
                                   
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-10">


<div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Product Name:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">

                                                                   <asp:DropDownList ID="ddlProductName" runat="server" 
                                 CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="true" OnSelectedIndexChanged="ddlProductName_SelectedIndexChanged">
                            </asp:DropDownList>

                                                                          <script type="text/javascript">
                                                                              function pageLoad() {
                                                                                  $('.multiple-select').select2({
                                                                                      includeSelectAllOption: true,
                                                                                      theme: 'bootstrap4',
                                                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                                      placeholder: $(this).data('placeholder'),
                                                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                                                  });

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
                                                        <asp:TextBox Visible="false" ID="productCodeTextBox" runat="server" AutoPostBack="True" 
                                CssClass="form-control form-control-sm mb-3" ontextchanged="productCodeTextBox_TextChanged"></asp:TextBox>

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>

                                                    <div class="form-group row" runat="server" visible="false">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Product Name:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                                                               
            <asp:TextBox ID="productNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                AutoPostBack="True" ontextchanged="productNameTextBox_TextChanged" ReadOnly="True"></asp:TextBox>
                                
                                <ajaxToolkit:AutoCompleteExtender ID="productNameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetProduct" ServicePath="SInventoryWebService.asmx"  TargetControlID="productNameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true"
                                        >
                                    </ajaxToolkit:AutoCompleteExtender>

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>


    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Pack Size:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                       <asp:TextBox ID="packSizeTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                ReadOnly="True"></asp:TextBox> 

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>




 
    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Cost Price:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                        <asp:TextBox ID="costPriceTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                >0</asp:TextBox>

                            <ajaxToolkit:FilteredTextBoxExtender ID="fcostPriceTextBox" runat="server"
                                TargetControlID="costPriceTextBox"         
                                FilterType="Custom, Numbers"
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>

 
 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">TP:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                       <asp:TextBox ID="unitPriceTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                            <ajaxToolkit:FilteredTextBoxExtender ID="FunitPriceTextBox" runat="server"
                                TargetControlID="unitPriceTextBox"         
                                FilterType="Custom, Numbers"
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 
 
                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">VAT Amount:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                     <asp:TextBox ID="vatAmountTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                            <ajaxToolkit:FilteredTextBoxExtender ID="vatAmountTextBox_FilteredTextBoxExtender" 
                                runat="server" FilterType="Custom, Numbers" TargetControlID="vatAmountTextBox" 
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
                                                    
 
 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">MRP:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                       <asp:TextBox ID="txtMRP" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server"
                                TargetControlID="txtMRP"         
                                FilterType="Custom, Numbers"
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>

 
 <div class="form-group row" runat="server" visible="false">
                                                        <label for="mainName" class="col-sm-3 col-form-label">VAT Percent (%):  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                       <asp:TextBox ID="vatperTextBox" Text="0" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                            <ajaxToolkit:FilteredTextBoxExtender ID="vatperTextBox_FilteredTextBoxExtender" 
                                runat="server" FilterType="Custom, Numbers" TargetControlID="vatperTextBox" 
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>



 
 


 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> 	Active Date:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                     <asp:TextBox ID="activeDtTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" 
                                AutoPostBack="True" ></asp:TextBox>
                      

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 
 

 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Status:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                      <asp:RadioButtonList ID="RadioButtonList1" runat="server" CssClass="form-control form-control-sm mb-3" AutoPostBack="True"
                                onselectedindexchanged="RadioButtonList1_SelectedIndexChanged" RepeatDirection="Horizontal">
                                <asp:ListItem>IsActive</asp:ListItem>
                                <asp:ListItem>Inactive</asp:ListItem>
                            </asp:RadioButtonList>

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 

<div  runat="server" id="new" Visible="False">

 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> New Cost Price:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                      <asp:TextBox ID="newCostPriceTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                >0</asp:TextBox>

                            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                TargetControlID="newCostPriceTextBox"         
                                FilterType="Custom, Numbers"
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 



 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> New Unit Price:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                     <asp:TextBox ID="newUnitPriceTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                TargetControlID="newUnitPriceTextBox"         
                                FilterType="Custom, Numbers"
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 


 <div class="form-group row" runat="server" visible="false">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> New Vat Percent(%):  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                      <asp:TextBox ID="newvatPerceTextBox" runat="server" Text="0" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" 
                                runat="server" FilterType="Custom, Numbers" TargetControlID="newvatPerceTextBox" 
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 


 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> New Vat Amount:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                        <asp:TextBox ID="newvatAmountTextBox" runat="server" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                            <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" 
                                runat="server" FilterType="Custom, Numbers" TargetControlID="newvatAmountTextBox" 
                                ValidChars="." />

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>
 

 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> Active Date:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                      <asp:TextBox ID="newactiveDtTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" 
                                 ></asp:TextBox>
                           
                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                      


                                                            </div>
                                                        </div>


 <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label"> Inactive Date:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                    <asp:TextBox ID="inactiveTextBox" runat="server" 
                                    CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>
                               

                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>
  </div>
                                                        </div>

</div>

 <div class="form-group row">
                                                   
                  <label for="mainName" class="col-sm-3 col-form-label">  </label>                                     
                                                        <div class="col-sm-5">
      <br />
                                                          <asp:HiddenField ID="productIdHiddenField" runat="server" />   <div class="form-group">
                                                                <asp:LinkButton ID="submitButton" CssClass="btn btnMyDesignSearch   btn-sm" runat="server"  OnClick="submitButton_Click1"><i class="fa fa-check"></i>Submit</asp:LinkButton>

                                                                <asp:LinkButton ID="ResetBtn" CssClass="btn btnMyDesignReset   btn-sm" runat="server" OnClick="ResetBtn_Click"><i class="fa fa-retweet"></i> Reset</asp:LinkButton>


                                                            </div>
                                                            </div>
                                                        </div>
 


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

