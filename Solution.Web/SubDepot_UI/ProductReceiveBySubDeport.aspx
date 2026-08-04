<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ProductReceiveBySubDeport.aspx.cs" Inherits="SubDepot_UI_ProductReceiveBySubDeport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                             Product Receive Information
                        </td>
            <tr>
                        <td class="TDLeft" width="13%">
                            Chalan No:</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnNoTextBox" runat="server"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Chalan Date :</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="clnDateTextBox" runat="server"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Receive Date :</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="rcvDateTextBox" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            Truck No</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="truckTextBox" runat="server"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            Driver Name :</td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="driverNameTextBox" runat="server"></asp:TextBox>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%" colspan="6">
                            <asp:GridView ID="rcvGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="SChalanId,SChalanDetailsId,DCStoreId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="ProductName" />
                                    <asp:BoundField DataField="PackSize" HeaderText="PackSize" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="BatchNo" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="RcvQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="rcvQtyTextBox" runat="server"  Text= <%# Eval("Quantity")%> 
                                                AutoPostBack="True" ontextchanged="rcvQtyTextBox_TextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UnRcvQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="damageTextBox" runat="server" AutoPostBack="True" 
                                                ontextchanged="damageTextBox_TextChanged">0</asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="AccessQty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="accessQtyTextBox" runat="server" AutoPostBack="True" >0</asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="mfgdate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Mfgdate"/>
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
                            <asp:LinkButton ID="backLinkButton" runat="server" Font-Bold="True" 
                                onclick="backLinkButton_Click">&lt;&lt;&lt;&lt;&lt;Back To List</asp:LinkButton>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            <%--<asp:Button ID="submitButton" runat="server" onclick="submitButton_Click" 
                                Text="Submit" />--%>
                                
                                  <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <ContentTemplate>
                            <asp:Button ID="submitButton" runat="server" Text="Submit"  OnClientClick="return confirm('Are you sure you want to Save ?');"
                                onclick="submitButton_Click" />
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
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            <asp:HiddenField ID="hdComUnitId" runat="server" />
                        </td>
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
                            <asp:HiddenField ID="hdReqId" runat="server" />
                        </td>
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

