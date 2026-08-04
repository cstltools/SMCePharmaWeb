<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="SalesTrendReport.aspx.cs" Inherits="SInventory_UI_SalesTrendReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <style type="text/css"> 
        
        .excel-button{
            margin-left: 5px;
        }
        
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Sales Trend Report
                        </td>
                    </tr>
                      <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
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
                        </td>
                    </tr>
                    
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" style=" text-align: right; " class="TDLeft">
                            Year &nbsp; &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="yearDropDownList" runat="server" AutoPostBack="True" CssClass="DropDown">
                                  <asp:ListItem Value="0"> --- Select any one --- </asp:ListItem>
                                  <asp:ListItem Value="2018"> 2018 </asp:ListItem>
                                  <asp:ListItem Value="2019"> 2019 </asp:ListItem>
                                  <asp:ListItem Value="2020">2020 </asp:ListItem>
                                  <asp:ListItem Value="2021"> 2021 </asp:ListItem>
                                  <asp:ListItem Value="2022"> 2022 </asp:ListItem>
                                  <asp:ListItem Value="2023">2023 </asp:ListItem>
                                  <asp:ListItem Value="2024"> 2024 </asp:ListItem>
                                  <asp:ListItem Value="2025"> 2025 </asp:ListItem>     
                                 <asp:ListItem Value="2026"> 2026 </asp:ListItem>
 <asp:ListItem Value="2027"> 2027 </asp:ListItem>
 <asp:ListItem Value="2028"> 2028 </asp:ListItem>
 <asp:ListItem Value="2029"> 2029 </asp:ListItem>
 <asp:ListItem Value="2030"> 2030 </asp:ListItem>
                            </asp:DropDownList>
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
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
                            <asp:Button ID="viewRptButton" runat="server" OnClick="viewRptButton_Click" Text="View Report" />
                            <asp:Button ID="excelButton" BackColor="#16A085"  CssClass="excel-button" runat="server" OnClick="excelButton_OnClick"
                                Text="Excel" Visible="False" /> 
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

