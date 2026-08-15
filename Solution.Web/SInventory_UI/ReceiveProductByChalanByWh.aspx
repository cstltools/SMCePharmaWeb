<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master"
    AutoEventWireup="true" CodeFile="ReceiveProductByChalanByWh.aspx.cs" Inherits="SInventory_UI_ReceiveProductByChalanByWh" %>

<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Stock Receive
                        </td>
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
                            <td class="TDLeft" width="13%">
                                Chalan No:
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="clnNoTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td class="TDLeft" width="13%">
                                Chalan Date :
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="clnDateTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td class="TDLeft" width="13%">
                                Receive Date :
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="rcvDateTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="TDLeft" width="13%">
                                Truck No
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="truckTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td class="TDLeft" width="13%">
                                Driver Name :
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:TextBox ID="driverNameTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                            </td>
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%">
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
                            <td class="TDLeft" width="13%" colspan="6">
                                <asp:GridView ID="rcvGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                    DataKeyNames="SChalanId,SChalanDetailsId,DCStoreFreezeId,DCStoreId,ProductId,StockConditionId">
                                    <Columns>
                                        <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                        <asp:BoundField DataField="ProductName" HeaderText="ProductName" />
                                        <asp:BoundField DataField="PackSize" HeaderText="PackSize" />
                                        <asp:BoundField DataField="BatchNo" HeaderText="BatchNo" />
                                        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                        <asp:BoundField DataField="MfgDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="Mfgdate" />
                                        <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" HeaderText="ReceiveDate" />
                                        <asp:TemplateField HeaderText="RcvQty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="rcvQtyTextBox" runat="server" Text='<%# Eval("Quantity")%>' ReadOnly="True"
                                                    AutoPostBack="True" OnTextChanged="rcvQtyTextBox_TextChanged"></asp:TextBox>
                                                <ajaxToolkit:FilteredTextBoxExtender ID="currentStockTextBox" runat="server" TargetControlID="rcvQtyTextBox"
                                                    FilterType="Custom, Numbers" ValidChars="." />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="UnRcvQty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="damageTextBox" runat="server" AutoPostBack="True" OnTextChanged="damageTextBox_TextChanged">0</asp:TextBox>
                                                <ajaxToolkit:FilteredTextBoxExtender ID="fcurrentStockTextBox" runat="server" TargetControlID="damageTextBox"
                                                    FilterType="Custom, Numbers" ValidChars="." />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="UnitPrice" HeaderText="UnitPrice" />
                                        <asp:BoundField DataField="VatPerUnit" HeaderText="VatPerUnit" />
                                        <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
                                        <%--<asp:BoundField DataField="TotalPrice" HeaderText="TotalPrice" />
                                        <asp:BoundField DataField="TotalVat" HeaderText="TotalVat" />
                                        <asp:BoundField DataField="TotalAmount" HeaderText="TotalAmount" />--%>
                                        
                                    </Columns>
                                </asp:GridView>
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
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%">
                                <asp:LinkButton ID="backLinkButton" runat="server" Font-Bold="True" OnClick="backLinkButton_Click">&lt;&lt;&lt;&lt;&lt;Back To List</asp:LinkButton>
                            </td>
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%">
                                <%-- <asp:Button ID="submitButton" runat="server" onclick="submitButton_Click" 
                                Text="Submit" />--%>
                                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="saveButton" runat="server" Text="Submit" OnClientClick="return confirm('Are you sure you want to Save ?');"
                                            OnClick="submitButton_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel3"
                                    DisplayAfter="0" DynamicLayout="true">
                                    <ProgressTemplate>
                                        <center>
                                            <asp:Image ID="Img2" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
                                        </center>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td class="TDLeft" width="13%">
                                &nbsp;
                            </td>
                            <td class="TDRight" width="20%">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="TDLeft" width="13%">
                                <asp:HiddenField ID="hdComUnitId" runat="server" />
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
                            <td class="TDLeft" width="13%">
                                <asp:HiddenField ID="hdReqId" runat="server" />
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
</asp:Content>
