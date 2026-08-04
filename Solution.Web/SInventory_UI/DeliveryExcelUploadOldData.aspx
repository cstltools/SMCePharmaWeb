<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DeliveryExcelUploadOldData.aspx.cs" Inherits="SInventory_UI_DeliveryExcelUploadOldData" %>
<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <style>
        .divWaiting
        {
            position: absolute;
            z-index: 2147483647 !important;
            opacity: 0.5;
            overflow: hidden;
            text-align: center;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            padding-top: 0px;
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

<%--
                     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Invoice Upload  </div>

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
                               <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>


                            
                                         <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Upload File:</label>

                                                <div class="col-sm-5">


                                                  <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="form-control form-control-sm mb-3 " />
                    <asp:Button ID="btnUpload" runat="server" class="btn btn-primary" Text="Upload" OnClick="btnUpload_Click" />
                    <asp:Label ID="lbl_up_status" runat="server"></asp:Label>
                    <asp:HiddenField ID="IsFileUploaded" runat="server" />
                            </div>
 </div>
                            </div>
                            </div>

                              <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                              <div style="padding-top:10px;"></div>
                                             <div class="table-responsive" id="MainGradeDiv">
                                               <asp:GridView ID="productGridView" CssClass="table table-bordered  text-center thead-dark"  runat="server" AutoGenerateColumns="False" 
                    >
                                           
                                <Columns>
                                <%--     <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Invoice No">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " 
                                                AutoPostBack="True" ToolTip="true" ontextchanged="productCodeTextBox_TextChanged" Text= <%# Eval("ProformaInvoiceNo")%>></asp:TextBox>

                                             <%--   <ajaxToolkit:AutoCompleteExtender ID="productCodeTextBox1_AutoCompleteExtender" runat="server"
                                                     DelimiterCharacters="" EnableCaching="true"
                                                    Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                    ServiceMethod="GetProductWithCode" ServicePath="SInventoryWebService.asmx"  TargetControlID="productCodeTextBox" 
                                                    UseContextKey="True"
                                                    CompletionListCssClass="autocomplete_completionListElement" 
                                                    CompletionListItemCssClass="autocomplete_listItem" 
                                                    CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                    ShowOnlyCurrentWordInCompletionListItem="true"
                                                    >
                                                </ajaxToolkit:AutoCompleteExtender>--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Amount">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server"  
                                               CssClass="form-control form-control-sm mb-3 " Text= <%# Eval("Amount")%> AutoPostBack="True" ToolTip="true"
                                                ontextchanged="productNameTextBox_TextChanged"></asp:TextBox>
                                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="productNameTextBox" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                              
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                <%--    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:TextBox ID="packSizeTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True" Text= <%# Eval("PackSize")%>></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="CStock">
                                        <ItemTemplate>
                                            <asp:TextBox ID="cstockTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True" Text= <%# Eval("CStock")%>></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="reqQtyTextBox" runat="server" CssClass="TextBoxCalander" Text= <%# Eval("Quantity")%>></asp:TextBox>
                                               <ajaxToolkit:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server"
                                                    TargetControlID="reqQtyTextBox"         
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Add">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton1" runat="server" 
                                                ImageUrl="~/images/lineAdd.png" onclick="ImageButton1_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Remove">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton2" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="ImageButton2_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
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
                                                              <asp:LinkButton  OnClick="submitButton_Click"   OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Confirm Delivery Invoices
                                        </asp:LinkButton>

                                                       
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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
                          
                          
   <asp:HiddenField runat="server" ID="hiddenField" />
               <div runat="server" visible="false">
                <table width="100%" class="TableWorkArea" >
                    <tr  >
                        <td colspan="6" class="TableHeading">
                          Invoice Upload
                        </td>
                         <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:Label ID="msgLabel" runat="server"></asp:Label>
                             </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    
                    
                    
        
                      <tr >
                        <td width="13%" class="TDLeft">
                            &nbsp; </td>
                        <td width="20%" class="TDRight">
                         
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                      <%--   <asp:HyperLink ID="HyperLink1" runat="server" ForeColor="green"
                                NavigateUrl="~/SInventory_UI/OrderRequisitionView.aspx">View List</asp:HyperLink>--%>
                                   <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                    </tr>
                    
                     <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <asp:Label ID="Label2" runat="server"></asp:Label>
                             </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                     
                     <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Manufacturer : </td>
                        <td class="TDLeft" width="13%">
                             <asp:DropDownList ID="manufacturerDropDownList" runat="server" 
                                 CssClass="DropDown"
                                 >
                    </asp:DropDownList></td>
                        <td class="TDRight" width="20%">
                            <asp:Label ID="Label1" runat="server"></asp:Label>
                             </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                      <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Requsition No :</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="reqNoTextBox" runat="server" ReadOnly="True" CssClass="TextBox" ></asp:TextBox>
                          </td>
                        <td class="TDRight" width="20%">
                            Requsition Date :</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="reqDateTextBox" runat="server" CssClass="TextBoxCalander" ReadOnly="True" ></asp:TextBox>
                             <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                             <ajaxToolkit:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="reqDateTextBox"
                                PopupButtonID="imgDate">
                            </ajaxToolkit:CalendarExtender>
                          </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                     
                     <%-- <tr>
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
                    </tr>--%>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Warehouse  :</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="wareHouseDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            Distribution Center :</td>
                        <td class="TDLeft" width="13%">
                            <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr runat="server" Visible="False">
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
                    <%--
                    </ContentTemplate>
    </asp:UpdatePanel>--%>
                      <tr runat="server" Visible="True" >
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Upload File:
                </td>
                <td class="TDRight" width="20%">
                    
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                </td>
            </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                             <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%" colspan="2">
                         
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
                </table>
                 </div>
        
</asp:Content>

