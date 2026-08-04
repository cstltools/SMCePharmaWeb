<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="BatchWiseCollectionReport.aspx.cs" Inherits="Money_Receipt_UI_BatchWiseCollectionReport" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        /*AutoComplete flyout */
        .autocomplete_completionListElement
        {
            margin: 0px !important;
            background-color: White;
            color: windowtext;
            border: buttonshadow;
            border-width: 1px;
            border-style: solid;
            cursor: default;
            overflow: auto;
            font-family: Calibri;
            font-size: 12px;
            text-align: left;
            list-style-type: none;
            margin-left: 0px;
            padding-left: 0px;
            max-height: 350px;
            width: 50% !important;
        }
        
        /* AutoComplete highlighted item */
        
        .autocomplete_highlightedListItem
        {
            background-color: yellow;
            color: black;
            padding: 1px;
        }
        
        /* AutoComplete item */
        
        .autocomplete_listItem
        {
            background-color: white;
            color: blue;
            padding: 0px;
        }
        
        .currency
        {
            font-size: 18px;
            color: #800000;
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Batch Wise Money Receipt </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="LinkButton1"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="LinkButton1_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                             <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label">  Delivery Man:</label>

                                    <div class="col-sm-7" style="margin-top:6px;">
                                       <asp:DropDownList ID="delDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                OnSelectedIndexChanged="delDropDownList_OnTextChanged">
                            </asp:DropDownList>
                                        <script type="text/javascript">
                               function pageLoad() {
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
                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label"> Batch Creation Date:</label>

                                    <div class="col-sm-7" style="margin-top:6px;">
                                   <asp:TextBox ID="dateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker" ></asp:TextBox>

                                    </div>
                  
                                </div>  


                                </div>  


                               
                            </div>  


                            <div class="row">
                                   <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label"> Batch No:</label>

                                    <div class="col-sm-7" style="margin-top:6px;">
                                     <asp:DropDownList ID="batchDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            </asp:DropDownList>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>



                            <br />
                             <div class="row">

                                 <div class="col-md-2">

                                     </div>
                                   <div class="col-md-8">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label"> Customer Code:</label>

                                    <div class="col-sm-7" style="margin-top:6px;">
                                    <asp:TextBox ID="singleCustomerTextBox" Enabled="False" CssClass="TextBox" AutoPostBack="True"
                                OnTextChanged="singleCustomerTextBox_OnTextChanged" runat="server"></asp:TextBox>
                            <asp:AutoCompleteExtender ID="customerTextBox_AutoCompleteExtender" runat="server"
                                CompletionListCssClass="autocomplete_completionListElement" CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                CompletionListItemCssClass="autocomplete_listItem" CompletionSetCount="10" DelimiterCharacters=""
                                EnableCaching="true" Enabled="True" MinimumPrefixLength="1" ServiceMethod="GetCustomernew"
                                ServicePath="SInventoryWebService.asmx" ShowOnlyCurrentWordInCompletionListItem="true"
                                TargetControlID="singleCustomerTextBox">
                            </asp:AutoCompleteExtender>
                            <asp:HiddenField ID="hdCustomerId" runat="server" />

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>

                                                      <div style="padding-top:10px;"></div>
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">
                                <asp:LinkButton runat="server"  id="Button1" class="btn btnMyDesignSearch   btn-sm "  onclick="searchButton_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="clearButton" onclick="clearButton_OnClick" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                              
                            </div>
                        </div>
                             <div class="row">

                                 <div class="col-md-2">

                                     </div>
                                   <div class="col-md-8">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-5 col-form-label"> Total Receiveable:</label>

                                    <div class="col-sm-7" style="margin-top:6px;">
                                        <asp:Label ID="totalReceiveableLabel" CssClass="currency" runat="server"></asp:Label>
                                        </div>
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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="false">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Batch Wise Money Receipt
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                            Delivery Man:
                        </td>
                        <td width="20%" class="TDRight">
                            
                        </td>
                        <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                            Batch Creation Date:
                        </td>
                        <td width="20%" class="TDRight">
                           
                          <%--  <asp:ImageButton ID="imgDate" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDate"
                                TargetControlID="dateTextBox">
                            </asp:CalendarExtender>--%>
                        </td>
                        <td class="TDLeft" width="13%" style="text-align: right; padding-right: 10px;">
                            Batch No:
                        </td>
                        <td class="TDRight" width="20%">
                        
                        </td>
                    </tr>
                    <tr runat="server" visible="False">
                        
                        
                       
                        <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                            <%-- Payment Amount:--%>
                        </td>
                        <td width="20%" class="TDRight">
                            <%-- <asp:Label ID="paymentAmountTextBox" runat="server" CssClass="TextBox" ReadOnly="True"></asp:Label>--%>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            <asp:CheckBox ID="customerCheckBox" AutoPostBack="True" OnCheckedChanged="customerCheckBox_OnCheckedChanged"
                                CssClass="pading" runat="server" />
                        </td>
                        <td width="20%" class="TDRight">
                            Is Single Customer
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Customer Code:
                        </td>
                        <td width="20%" class="TDRight">
                           
                        </td>
                         <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                            Customer Name:
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="nameTextBox" runat="server" AutoPostBack="True" ReadOnly="True"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <%-- <asp:Button ID="submitButton" runat="server" Text="View Report" CssClass="button-margin-right"
                                OnClick="submitButton_OnClick" BackColor="#16A085" />--%>
                            
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="20%" class="TDRight" colspan="6">
                            <div id="gridContainer" style="height: auto; overflow: auto; width: 97%; margin: 0 auto;">
                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                    DataKeyNames="CustPayDetailId">
                                    <Columns>
                                        <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                        <asp:BoundField DataField="BatchCreationDate" HeaderText="Batch Creation Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                        <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="PaidAmount" HeaderText="Paid Amount" />
                                        <asp:TemplateField HeaderText="Action">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="invoiceButton" runat="server" Text="Report &gt; &gt; &gt;" ForeColor="#DE751F"
                                                    OnClick="invoiceButton_Click" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                       
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0"
        DynamicLayout="true">
        <ProgressTemplate>
            <div class="divWaiting">
                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle"
                    ImageUrl="~/images/progress-bar-opt.gif" Height="80" Width="80" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
