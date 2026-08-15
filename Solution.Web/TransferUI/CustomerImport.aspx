<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CustomerImport.aspx.cs" Inherits="TransferUI_CustomerImport" %>

<%--<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>--%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>

        <style>
          .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
                  font-size: 20px;
                  font-weight: bold;
        }

     
    </style>
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
          .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
                  font-size: 20px;
                  font-weight: bold;
        }

     
    </style>

     <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>--%>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Customer Updation </div>

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


                        <div class="card-body">
 

                            <div class="row">
                                    <asp:Label ID="msgLabel" runat="server"></asp:Label>
                                    <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
                                    <asp:Label ID="Label2" runat="server"></asp:Label>
                            </div>

                     
                               <div class="row">

                                   
                                  <div class="col-md-12" style="text-align:center">
                  <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice"   RepeatDirection="Horizontal" RepeatLayout="Flow">
                      <asp:ListItem Selected="True" Value="Market Update">Market Update</asp:ListItem>
                      <asp:ListItem Value="Provider Type">Provider Type Update</asp:ListItem>
                      <asp:ListItem Value="Customer Type">Customer Type Update</asp:ListItem>
                      <asp:ListItem Value="Pharma Platform Type">Pharma Platform Update</asp:ListItem>
               
                  </asp:RadioButtonList>
                                   </div>
                                   </div>
                            <br />
                            <br />

                            <div class="row">
                               <div class="col-md-2"><a href="../ExcelFiles/CustomerFormat.xls"  class="btn  btn-secondary   btn-sm">Download Excel Format</a>  </div>
                                   <div class="col-md-10">
                                       <div class="form-group row">
                                        
                                        <label for="mainName" class="col-sm-2 col-form-label"> Upload File :</label>

                                        <div class="col-sm-7">

                                          <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="form-control form-control-sm" />
                                             
                                              <asp:HiddenField ID="IsFileUploaded" runat="server" />
                                         <br />
                                              <asp:Label ID="lbl_up_status" runat="server" CssClass=""></asp:Label>
                                        </div>

                                           <div class="col-sm-3">
                                                <asp:Button ID="btnUpload" runat="server" class="btn btnMyDesignAddtoList   btn-sm" Text="Upload" OnClick="btnUpload_Click" />
                                            
                             
                                    </div>
                                    </div>
                                    </div>            
                            </div>


                            <br />
                       


                           <div class="row">
                <div class="table-responsive" id="MainGradeDiv">

                     <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender">

                        <Columns>
                            <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                         
                            <asp:TemplateField HeaderText="Customer Code">
                                <ItemTemplate>
                                    <asp:Label ID="lblCustomerCode" runat="server"  CssClass="form-control form-control-sm" 
                                          Text='<%# Eval("CustomerCode")%>'  ></asp:Label>

                              

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Provider Type Code">
                                <ItemTemplate>
                                    <asp:Label ID="lblProviderTypeCode" runat="server" CssClass="form-control form-control-sm"   Text='<%# Eval("ProviderTypeCode")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Customer Type Code">
                                <ItemTemplate>
                                   <asp:Label ID="lblCustomerTypeCode" runat="server" CssClass="form-control form-control-sm"   Text='<%# Eval("CustomerTypeCode")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Market Code">
                                <ItemTemplate>
                                    <asp:Label ID="lblMarketCode" runat="server" CssClass="form-control form-control-sm"   Text='<%# Eval("MarketCode")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>


                             <asp:TemplateField HeaderText="Pharma Platform Code">
                                <ItemTemplate>
                                    <asp:Label ID="lblPharmaPlatformCode" runat="server" CssClass="form-control form-control-sm"   Text='<%# Eval("PharmaPlatformCode")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                          
                        </Columns>

                    </asp:GridView>

                                </div>
                            </div>

        



                             <br />
                            <div class="row">
                                <div class="col-md-2">&nbsp;</div>
                                <div class="col-md-8">

                                    <div class="form-group row">
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                        <div class="col-sm-8">
                                             <asp:LinkButton  OnClick="submitButton_Click"   OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>
                                            
                                              <asp:LinkButton  runat="server"   ID="LinkButton5" OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                       
       

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


    <asp:HiddenField runat="server" ID="hiddenField" />
<%--    <div>
        <table width="100%" class="TableWorkArea">
            <tr>
                <td colspan="6" class="TableHeading">Stock Transfer Order 
                </td>
                <tr>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">&nbsp;</td>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">
                        <asp:Label ID="msgLabel" runat="server"></asp:Label>
                    </td>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">&nbsp;</td>
                </tr>
                <tr>
                    <td width="13%" class="TDLeft">&nbsp; </td>
                    <td width="20%" class="TDRight"></td>
                    <td width="13%" class="TDLeft"></td>
                    <td width="20%" class="TDRight">
                        <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
                    </td>
                    <td width="13%" class="TDLeft"></td>
                    <td width="20%" class="TDRight">
                        <asp:HyperLink ID="HyperLink1" runat="server" ForeColor="green"
                            NavigateUrl="~/SInventory_UI/OrderRequisitionView.aspx">View List</asp:HyperLink>
                </tr>
                <tr>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">&nbsp;</td>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">
                        <asp:Label ID="Label2" runat="server"></asp:Label>
                    </td>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">&nbsp;</td>
                </tr>

                <tr>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">Manufacturer : </td>
                    <td class="TDLeft" width="13%">
                        <asp:DropDownList ID="manufacturerDropDownList" runat="server"
                            CssClass="DropDown">
                        </asp:DropDownList> </td>
                    <td class="TDRight" width="20%">
                        <asp:Label ID="Label1" runat="server"></asp:Label>
                    </td>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">&nbsp;</td>
                </tr>
                <tr>
                    <td class="TDLeft" width="13%">&nbsp;</td>
                    <td class="TDRight" width="20%">Requsition No :</td>
                    <td class="TDLeft" width="13%">
                        <asp:TextBox ID="reqNoTextBox" runat="server" ReadOnly="True" CssClass="TextBox"></asp:TextBox>
                    </td>
                    <td class="TDRight" width="20%">Requsition Date :</td>
                    <td class="TDLeft" width="13%">
                        <asp:TextBox ID="reqDateTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True"></asp:TextBox>
                        <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                            TabIndex="4" ID="imgDate"></asp:ImageButton>
                        <ajaxToolkit:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="reqDateTextBox"
                            PopupButtonID="imgDate">
                        </ajaxToolkit:CalendarExtender>
                    </td>
                    <td class="TDRight" width="20%">&nbsp;</td>
                </tr>


            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">Warehouse  :</td>
                <td class="TDLeft" width="13%">
                    <asp:DropDownList ID="wareHouseDropDownList" runat="server" CssClass="DropDown">
                    </asp:DropDownList>
                </td>
                <td class="TDRight" width="20%">Distribution Center :</td>
                <td class="TDLeft" width="13%">
                    <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="DropDown">
                    </asp:DropDownList>
                </td>
                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
            <tr runat="server" visible="True">
                <td class="TDLeft" width="13%"></td>
                <td class="TDRight" width="20%"></td>
                <td class="TDLeft" width="13%">Upload File:
                </td>
                <td class="TDRight" width="20%">
                    <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="btn" />
                    <asp:Button ID="btnUpload" runat="server" class="btn btn-primary" Text="Upload" OnClick="btnUpload_Click" />
                    <asp:Label ID="lbl_up_status" runat="server"></asp:Label>
                    <asp:HiddenField ID="IsFileUploaded" runat="server" />
                </td>
                <td class="TDLeft" width="13%">&nbsp;
                </td>
                <td class="TDRight" width="20%"></td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%" colspan="4">
                    <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False"
                        CssClass="gridview">

                        <Columns>
                            <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Product Code">
                                <ItemTemplate>
                                    <asp:TextBox ID="productCodeTextBox" runat="server" CssClass="TextBoxCalander"
                                        AutoPostBack="True" ToolTip="true" OnTextChanged="productCodeTextBox_TextChanged" Text='<%# Eval("ProductCode")%>'></asp:TextBox>
                                    <ajaxToolkit:AutoCompleteExtender ID="productCodeTextBox1_AutoCompleteExtender" runat="server"
                                        DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetProductWithCode" ServicePath="SInventoryWebService.asmx" TargetControlID="productCodeTextBox"
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement"
                                        CompletionListItemCssClass="autocomplete_listItem"
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                    </ajaxToolkit:AutoCompleteExtender>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Product Name">
                                <ItemTemplate>
                                    <asp:TextBox ID="productNameTextBox" runat="server"
                                        CssClass="TextBox" Text='<%# Eval("ProductName")%>' AutoPostBack="True" ToolTip="true"
                                        OnTextChanged="productNameTextBox_TextChanged"></asp:TextBox>
                                    <ajaxToolkit:AutoCompleteExtender ID="productNameTextBox_AutoCompleteExtender" runat="server"
                                        DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetProductWithCode" ServicePath="SInventoryWebService.asmx" TargetControlID="productNameTextBox"
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement"
                                        CompletionListItemCssClass="autocomplete_listItem"
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                    </ajaxToolkit:AutoCompleteExtender>

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PackSize">
                                <ItemTemplate>
                                    <asp:TextBox ID="packSizeTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True" Text='<%# Eval("PackSize")%>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CStock">
                                <ItemTemplate>
                                    <asp:TextBox ID="cstockTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True" Text='<%# Eval("CStock")%>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Qty">
                                <ItemTemplate>
                                    <asp:TextBox ID="reqQtyTextBox" runat="server" CssClass="TextBoxCalander" Text='<%# Eval("Quantity")%>'></asp:TextBox>
                                    <ajaxToolkit:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server"
                                        TargetControlID="reqQtyTextBox"
                                        FilterType="Custom, Numbers"
                                        ValidChars="." />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Add">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ImageButton1" runat="server"
                                        ImageUrl="~/images/lineAdd.png" OnClick="ImageButton1_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remove">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ImageButton2" runat="server"
                                        ImageUrl="~/images/lineDelete.png" OnClick="ImageButton2_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                    </asp:GridView>
                </td>

                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">
                    <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click"
                        OnClientClick="return confirm('Are you sure you want to Create Stock Transfer Order ?');" Text="Submit" />
                </td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
                <td class="TDLeft" width="13%">&nbsp;</td>
                <td class="TDRight" width="20%">&nbsp;</td>
            </tr>
        </table>
    </div>--%>
                    <%--   </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

