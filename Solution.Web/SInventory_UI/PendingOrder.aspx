<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="PendingOrder.aspx.cs" Inherits="SInventory_UI_PendingOrder" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
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
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Pending Orders
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
                     <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <%--<asp:ImageButton ID="cusMasterNewImageButton" runat="server" 
                                ImageUrl="~/images/Add.png" onclick="CustMasterNewImageButton_Click" />--%>
                        </td>
                        
                        
                        <td width="13%" class="TDLeft">
                         Salse Center
                        </td>
                        <td width="20%" class="TDRight">
                    <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True" 
                                >
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <%--<asp:ImageButton ID="cusMasterNewImageButton" runat="server" 
                                ImageUrl="~/images/Add.png" onclick="CustMasterNewImageButton_Click" />--%>
                        </td>
                        
                        
                        <td width="13%" class="TDLeft">
                          From Date
                        </td>
                        <td width="20%" class="TDRight">
                     <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="fromDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDateFrom"
                                TargetControlID="fromDateTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="imgDateFrom" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
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
                            To Date
                        </td>
                        <td class="TDRight" width="20%">
                               <asp:TextBox ID="toDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="toDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDateTo"
                                TargetControlID="toDateTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="imgDateTo" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                             <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                         <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                         <td class="TDRight" width="20%">
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
                          <asp:Button ID="viewRptButton" runat="server"  Text="Search" 
                                onclick="viewRptButton_Click" />
                        </td>
                          <td class="TDLeft" width="13%">
                         
                        </td>
                        <td class="TDRight" width="20%">
                              
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
                    <tr>
                        <td class="TDLeft" colspan="6">
                            <div id="gridContainer1" style="height: 500px; overflow: auto; width: auto">
                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                    DataKeyNames="OrderMasterID,OrderCode" OnRowCommand="loadGridView_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="SalesCentre" HeaderText="Sales Centre Code" />
                                        <asp:BoundField DataField="OrderCode" HeaderText="Order Code" />
                                        <asp:BoundField DataField="SubmissionDate" HeaderText="Submission Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="CustomerID" HeaderText="Customer Code" />
                                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                        <asp:TemplateField HeaderText="Process">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="editImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="executeOrder" ImageUrl="~/images/lineSelect.gif" />
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

