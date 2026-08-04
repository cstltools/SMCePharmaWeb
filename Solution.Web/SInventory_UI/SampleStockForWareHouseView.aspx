<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="SampleStockForWareHouseView.aspx.cs" Inherits="SInventory_UI_SampleStockForWareHouseView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Warehouse Sample Stock Conversion List </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                  
                            </td>
                        <td width="20%" class="TDRight">
                            Add
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:ImageButton ID="ImageButton2" runat="server" 
                                             ImageUrl="~/images/Add.png" 
                                             onclick="DcStockOutAddImageButton_Click" /> 
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
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
                        <td class="TDLeft" colspan="6">
                            <div id ="gridContainer1" style ="height:500px;overflow:auto;width:auto ">
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="SampleStockForWHMasterId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="WearhouseName" HeaderText="Wearhouse Name" />
                                    <asp:BoundField DataField="Date" HeaderText="Sample Stock Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="Action" HeaderText="Action" />
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData" ImageUrl="~/images/delete.png"
                                                             OnClientClick="return GetConfirmation();"/>
                                            <script type="text/javascript">
                                                function GetConfirmation() {
                                                    var reply = confirm("Ary you sure you want to delete this?");
                                                    if (reply) {
                                                        return true;
                                                    }
                                                    else {
                                                        return false;
                                                    }
                                                }
                                            </script>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                               <%--     <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="reportImageButton" runat="server" 
                                                             CommandArgument="<%# Container.DataItemIndex %>" CommandName="ReportView" ImageUrl="~/images/report-disk-icon.png"
                                                           />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>
                                
                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Visible="False"
                                CssClass="gridview">
                                <Columns>
                                    <asp:BoundField DataField="ReceiveId" />
                                    <asp:BoundField DataField="SampleStock" />
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
                        <td width="13%" class="TDLeft" >
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

