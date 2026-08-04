<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="FixedCustomerInformation.aspx.cs" Inherits="SInventory_UI_FixedCustomerInformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            FCB Report</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                           </td>
                        <td width="20%" class="TDRight">
                          <%--  <asp:ImageButton ID="cusMasterNewImageButton" runat="server" 
                                ImageUrl="~/images/Add.png" onclick="CustMasterNewImageButton_Click" />--%>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                            &nbsp;</td>
                        <td width="13%" class="TDLeft">
                           <%-- Reload--%></td>
                        <td width="20%" class="TDRight">
                         <%--   <asp:ImageButton ID="custMasterReloadImageButton" runat="server" 
                                ImageUrl="~/images/refresh.png" 
                                onclick="CustMasterReloadImageButton_Click" />--%>
                        </td>
                    </tr>
                  
                   <%-- <tr id="Tr1" >
                       
                        <td class="TDLeft" style="text-align: right" width="13%">
                         
                        </td>
                        <td class="TDRight" width="20%">
                          
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%" >
                           
                        </td>
                    </tr>--%>
                    <tr runat="server" >
                       <td class="TDLeft" style="text-align: right" width="13%">
                            Customer Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="custcodenameTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            FE Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="districtNameDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            Territory Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%" >
                            <asp:DropDownList ID="areaNameDropDownList" runat="server" 
                                CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr runat="server" >
                        <td class="TDLeft" style="text-align: right" width="13%">
                            MIA Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="miaNameDropDownList" runat="server"
                                CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            Market Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:DropDownList ID="marketNameDropDownList" runat="server" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                            DZSM Code &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <%--<asp:DropDownList ID="regionNameDropDownList" runat="server"  CssClass="DropDown" ></asp:DropDownList>--%>
                            <asp:DropDownList ID="regionNameDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown"  Width="165px" >
                           </asp:DropDownList>
                        </td>
                    </tr>
                    
                    
                       <tr>
                       <td class="TDLeft" style="text-align: right" width="13%">
                           <%-- Customer Status &nbsp;--%>
                        </td>
                        <td width="20%" class="TDRight">
                         <%-- <asp:DropDownList ID="statusDropDownList" runat="server" AutoPostBack="True" CssClass="DropDown">
                                <asp:ListItem Value="0"> -- Select -- </asp:ListItem>
                                  <asp:ListItem Value="1"> All </asp:ListItem>
                                <asp:ListItem Value="2"> Fixed Customer </asp:ListItem>
                           
                            </asp:DropDownList>--%>
                        </td>
                        <td width="13%" style="text-align: right;" class="TDLeft">
                            Year &nbsp; &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="yearDropDownList" runat="server" AutoPostBack="True" CssClass="DropDown">
                                <asp:ListItem Value=""> -- Select -- </asp:ListItem>
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
                        </td>
                        <td width="13%" style="text-align: right;" class="TDLeft">
                            Month &nbsp; &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="monthDropDownList" runat="server"  AutoPostBack="True"  CssClass="DropDown">
                                  <asp:ListItem Value=""> -- Select -- </asp:ListItem>
                                <asp:ListItem Value="January">January</asp:ListItem>
                                <asp:ListItem Value="February ">February </asp:ListItem>
                                <asp:ListItem Value="March">March</asp:ListItem>
                                <asp:ListItem Value="April">April</asp:ListItem>
                                <asp:ListItem Value="May">May</asp:ListItem>
                                <asp:ListItem Value="June">June</asp:ListItem>
                                <asp:ListItem Value="July">July</asp:ListItem>
                                <asp:ListItem Value="August">August</asp:ListItem>
                                <asp:ListItem Value="September">September</asp:ListItem>
                                <asp:ListItem Value="October">October</asp:ListItem>
                                <asp:ListItem Value="November">November</asp:ListItem>
                                <asp:ListItem Value="December">December</asp:ListItem>
                            </asp:DropDownList>
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
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                   
                    
                 
                       <tr id="Tr2" >
                        <td class="TDLeft" style="text-align: right" width="13%">
                             &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                     
                        </td>
                        <td class="TDRight" width="20%">
                          
                        </td>
                        <td class="TDLeft" style="text-align: right" width="13%">
                             <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Search" />
                             <asp:Button ID="Button2" runat="server" Text="Excel" onclick="Button2_Click" />
                        </td>
                        <td class="TDRight" width="20%" >
                           
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" colspan="6">
                            <div id="gridContainer1" style="height: 500px; overflow: auto; width: auto">
                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                    DataKeyNames="CustomerMasterId" OnRowCommand="loadGridView_RowCommand">
                                    <Columns>
                                      <%--  <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center" />--%>
                                        <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                        <asp:BoundField DataField="Address" HeaderText="Address" />
                                        <asp:BoundField DataField="CellNo" HeaderText="Cell No" /> 
                                        <asp:BoundField DataField="MiaCode" HeaderText="Mio Code" />
                                        <asp:BoundField DataField="DistrictCode" HeaderText="FE Code" />
                                        <asp:BoundField DataField="AreaCode" HeaderText="Territory Code" />
                                        <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                        <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                        <asp:BoundField DataField="RegionCode" HeaderText="DZSM Code" />

                                        <asp:TemplateField HeaderText="Report">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="editImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="Report" ImageUrl="~/images/report-disk-icon.png" />
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

