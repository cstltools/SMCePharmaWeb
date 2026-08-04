<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="InvoiceWiseDetailsSalesReport.aspx.cs" Inherits="SInventory_UI_InvoiceWiseDetailsSalesReport" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
     <style type="text/css">
        .button-padding-right {
            margin-right: 5px;
        }    
        
           .btnexcel {
               background-color: white;
               box-shadow: 0 0 3px 1px rgba(0,0,0,.35);
               border: none;
               color:#880e4f !important;
               padding: 8px 12px;
               text-align: center;
               text-decoration: none;
               display: inline-block;
               font-size: 12px;
               margin: 4px 2px;
               cursor: pointer;
               align-content: right;
           }

           .btnexcel:hover {
                 color:white!important;
    background-color: #880e4f !important;
   
}   
    </style>
    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Invoice Wise Details Sales Report
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
                    <tr runat="server" visible="false" id="Tr1">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            National Report :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:CheckBox ID="CheckBox1" runat="server"  AutoPostBack="True"
                                oncheckedchanged="CheckBox1_CheckedChanged" />
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    
                    <tr runat="server" visible="true" id="DIVDC">
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
                            Sales Center :
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="DropDown" 
                                AutoPostBack="True" onselectedindexchanged="dcDropDownList1_SelectedIndexChanged"
                                >
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                     <tr>
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Invoice From Date:
                </td>
                <td class="TDRight" width="20%">
                  <asp:TextBox ID="InvoiceDateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                   <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDatse"></asp:ImageButton>
                            <cc1:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="InvoiceDateTextBox"
                                PopupButtonID="imgDatse">
                            </cc1:CalendarExtender>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                </td>
            </tr>
             <tr>
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Invoice To Date:
                </td>
                <td class="TDRight" width="20%">
                  <asp:TextBox ID="todateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                   <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDatsea"></asp:ImageButton>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="todateTextBox"
                                PopupButtonID="imgDatsea">
                            </cc1:CalendarExtender>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                </td>
            </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" width="13%">
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                           <%-- <asp:Button ID="reportButton" CssClass="button-padding-right " runat="server" OnClick="viewRptButton_Click" 
                                Text="View Report" />  --%>
                               <asp:Button ID="viewRptButton" runat="server" onclick="SearchButton_Click" 
                                Text="View Report" /> 
                        </td>
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                          &nbsp;
                        </td>
                        <td width="20%" class="TDLeft">
                            &nbsp;
                        </td>
                        

                        <td width="13%" class="TDRight">
                             <asp:LinkButton ID="btnExportToExcel" runat="server"  CssClass="btnexcel" OnClick="btnExportToExcel_Click" > Export To Xls</asp:LinkButton>
                        </td>
                    </tr>
                     <tr>
                          <%--asp:UpdatePanel ID="UpdatePanel2"  runat="server">
                        <ContentTemplate>--%>
                         

                        <td width="13%" class="TDLeft" colspan="6">
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" OnRowDataBound="OnRowDataBound" 
                                CssClass="gridview" ShowFooter="True">
                                <Columns>
                                    
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name"  />
                                    
                                    
                                     <asp:BoundField DataField="OrderCode" HeaderText="Order Code" />
                                    <asp:BoundField DataField="SubmissionDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    
                                    
                                         <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code"  />

                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Proforma No" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Proforma Date"  DataFormatString="{0:dd-MMM-yyyy}" />
                                    
                                    
                                    <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Delivary Invoice No" />
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Delivary Invoice Date"   DataFormatString="{0:dd-MMM-yyyy}"/>

                                     <asp:BoundField DataField="salesTP" HeaderText="TP" />
                                    <asp:BoundField DataField="SalesVat" HeaderText="Vat"  />
                                    <asp:BoundField DataField="SalesTotal" HeaderText="Gross Total"  />
                                  

                                </Columns>
                            </asp:GridView>
                            <br/>  <br/>  <br/>  <br/>  
                        </td>
                           <%-- </ContentTemplate>
                    </asp:UpdatePanel>--%>
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
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        
                        <td width="20%" class="TDRight">
                       
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                          
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
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
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                             
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
       <%-- </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

