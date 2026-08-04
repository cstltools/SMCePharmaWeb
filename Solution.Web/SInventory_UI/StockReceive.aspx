<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="StockReceive.aspx.cs" Inherits="SInventory_UI_StockReceive" %>
<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <link type="text/css" href="../css/Date/jquery.datepick.css" rel="stylesheet">
    <script type="text/javascript" src="../css/Date/jquery.datepick.js"></script>
   <script type="text/javascript">
       $(function () {
           $('.datepick').datepick();
       });
       var prm = Sys.WebForms.PageRequestManager.getInstance();
       if (prm != null) {
           prm.add_endRequest(function (sender, e) {
               if (sender._postBackSettings.panelsToUpdate != null) {

                   $('.datepick').datepick();
               }
           });
       }; 
 </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Receive Entry
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp; View List</td>
                        <td width="20%" class="TDRight">
                            <asp:ImageButton ID="stockReceiveImageButton" runat="server" 
                                ImageUrl="~/images/viewList.png" onclick="stockReceiveImageButton_Click" />
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
                        </td>
                        <td width="13%" class="TDLeft">
                            Report</td>
                        <td width="20%" class="TDRight">
                            <asp:ImageButton ID="ImageButton1" runat="server" 
                                ImageUrl="~/images/viewList.png" onclick="ImageButton1_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Internal Note No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="internalNoteNoTextBox" runat="server" AutoPostBack="True" 
                                CssClass="TextBox" ontextchanged="productCodeTextBox_TextChanged"></asp:TextBox>
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
                            Product Code</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="productCodeTextBox" runat="server" CssClass="TextBox" 
                                AutoPostBack="True" ontextchanged="productCodeTextBox_TextChanged"></asp:TextBox>
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
                            Product Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="productNameTextBox" runat="server" CssClass="TextBox" 
                                AutoPostBack="True" 
                                ontextchanged="productNameTextBox_TextChanged"></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender ID="productNameTextBox_AutoCompleteExtender" runat="server"
                                         DelimiterCharacters="" EnableCaching="true"
                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                        ServiceMethod="GetProduct" ServicePath="SInventoryWebService.asmx"  TargetControlID="productNameTextBox" 
                                        UseContextKey="True"
                                        CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                    </ajaxToolkit:AutoCompleteExtender></td>

                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            Pack Size</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="packSizeTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Unit Price</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="unitPriceTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                            
                            <ajaxToolkit:FilteredTextBoxExtender ID="funitPrice" runat="server"
                                TargetControlID="unitPriceTextBox"         
                                FilterType="Custom, Numbers"
                                ValidChars="." />
                            
                            

                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            Batch Number</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="BatchNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                            <%--<asp:RequiredFieldValidator runat="server" id="rBatchNoTextBox" controltovalidate="BatchNoTextBox" errormessage="Please enter Batch No!"/>--%>

                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            Quantity</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="quantityTextBox" runat="server" CssClass="TextBox"></asp:TextBox>

                            <ajaxToolkit:FilteredTextBoxExtender ID="fquantityTextBox" runat="server"
                                TargetControlID="quantityTextBox"         
                                FilterType="Custom, Numbers"
                                ValidChars="." /> </td>

                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            </td>
                        <td class="TDRight" width="20%">
                            </td>
                        <td class="TDLeft" width="13%">
                            ExpDate</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="expDateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            </td>
                        <td class="TDRight" width="20%">
                            </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            ReceiveDate</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="receiveDateTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
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
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
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
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

