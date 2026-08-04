<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="OrderListUpload.aspx.cs" Inherits="SInventory_UI_OrderListUpload" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div>
        <table width="100%" class="TableWorkArea">
            <tr>
                <td colspan="6" class="TableHeading">
                    Order List Upload
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
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                     Document Date:
                </td>
                <td class="TDRight" width="20%">
                  <asp:TextBox ID="documentDateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                   <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="documentDateTextBox"
                                PopupButtonID="imgDate">
                            </asp:CalendarExtender>
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
                    Manufacturer:
                </td>
                <td class="TDRight" width="20%">
                    <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="radioButtonList">
                    </asp:DropDownList>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
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
                </td>
                <td width="20%" class="TDRight">
                </td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Select File:
                </td>
                <td class="TDRight" width="20%">
                    <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="btn" />
                    <asp:Button ID="btnUpload" runat="server" class="btn btn-primary" Text="Upload" OnClick="btnUpload_Click" />
                    <asp:Label ID="lbl_up_status" runat="server"></asp:Label>
                    <asp:HiddenField ID="IsFileUploaded" runat="server" />
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
                </td>
                <td width="100%" class="TDRight" colspan="4">
                     <div id ="gridContainer1" style ="height:400px;overflow:auto;width:960px ">
                    <asp:GridView ID="loadGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="SalesCentre" HeaderText="Sales Centre" />
                            <asp:BoundField DataField="SalesCentreName" HeaderText="Name" />
                            <asp:BoundField DataField="MIOName" HeaderText="MIO" />
                            <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                            <asp:BoundField DataField="FECode" HeaderText="FE Code" />
                            <asp:BoundField DataField="DZSMCode" HeaderText="DZSM Code" />
                            <asp:BoundField DataField="CustomerID" HeaderText="CustomerID" />
                            <asp:BoundField DataField="CustomerName" HeaderText="CustomerName" />
                            <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                            <asp:BoundField DataField="ProductName" HeaderText="ProductName" />
                            <asp:BoundField DataField="OrderQty" HeaderText="OrderQty" />
                            <asp:BoundField DataField="GrossValue" HeaderText="GrossValue" />
                             <asp:BoundField DataField="OrderCode" HeaderText="Order Code" />
                            <asp:BoundField DataField="SubmissionDate" HeaderText="SubmissionDate " DataFormatString="{0:dd-MMM-yyyy}"/>
                             <asp:BoundField DataField="MIOCode" HeaderText="MIOCode" />
                        </Columns>
                    </asp:GridView>
                    </div>
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
                    <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click" Text="Submit"  OnClientClick="return confirm('Are you sure you want to Save ?');" />
                     <asp:Button ID="cancelUploadListButton" runat="server"  OnClick="cancelUploadListButton_Click" Text="Cancel Upload" OnClientClick="return confirm('Are you sure you want to Re-Upload ?');"  />
                      <asp:Button ID="refreshButton" runat="server" OnClick="refreshButton_Click" Text="Refresh" />
                       <asp:Button ID="HomeButton" runat="server" OnClick="HomeButton_Click" Text="Home"  />
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
        </table>
    </div>
</asp:Content>

