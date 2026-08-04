<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="IssueRequisitionProducts.aspx.cs" Inherits="SInventory_UI_IssueRequisitionProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Challan Generation 
                        </td>
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
                            Req No :</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="reqNoTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Req Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="reqDateTextBox" runat="server" CssClass="TextBoxCalander" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Truck No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="truckNoTextBox" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            Issue Challan No </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnNoTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Issue Challan Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnDateTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Driver Name</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="driverNameTextBox" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                            Picking No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="pikNoTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
                         </td>
                        <td class="TDLeft" width="13%">
                            Picking Date</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="pikDateTextBox" runat="server" CssClass="TextBox" 
                                ReadOnly="True"></asp:TextBox>
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
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                           
                            <asp:GridView ID="issueGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" DataKeyNames="ReqChildId,StockInTransfarId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Pro. Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No." />
                                    <asp:BoundField DataField="PickingQty" HeaderText="Pick. Qty." />
                                    <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" />
                                    
                                    <asp:TemplateField HeaderText="Issue Qty.">
                                        <ItemTemplate>
                                            <asp:TextBox ID="issueQtyTextBox" runat="server" Enabled="False" 
                                                AutoPostBack="True" CssClass="TextBoxCalander"  Text= <%# Eval("Quantity")%>
                                                ontextchanged="issueQtyTextBox_TextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="T. Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="priceTextBox" runat="server" CssClass="TextBoxCalander" 
                                                Text= <%# Eval("PriceAmount")%> ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="VAT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" CssClass="TextBoxCalander" 
                                                Text= <%# Eval("VATAmount")%> ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tk.Value">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalPriceTextBox" runat="server" CssClass="TextBoxCalander" 
                                                Text= <%# Eval("TotalPriceAmount")%> ReadOnly="True"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Issue">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="issueCheckBox" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="issueCheckBox_CheckedChanged" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
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
                            <asp:LinkButton ID="LinkButton1" runat="server" Font-Bold="True" 
                                onclick="LinkButton1_Click">&lt;&lt;&lt;&lt;&lt;Back To List </asp:LinkButton>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            Total TP Amount:</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="totalAllPriceTextBox" runat="server" ReadOnly="True"></asp:TextBox>
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
                            Total VAT Amount:</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="vatAllPriceTextBox" runat="server" ReadOnly="True"></asp:TextBox>
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
                            Grand Total:</td>
                        <td class="TDLeft" width="13%">
                            <asp:TextBox ID="grandTotalTextBox" runat="server" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            <asp:HiddenField ID="hdReqId" runat="server" />
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:Button ID="bmitButton" runat="server" onclick="bmitButton_Click" 
                                Text="Submit"  OnClientClick="return confirm('Are you sure you want Save ?');"/>
                        </td>
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

