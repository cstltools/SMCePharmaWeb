<%@ Page Title="" Language="C#" EnableEventValidation="false" MasterPageFile="~/MasterPages/MainMasterPage.master" AutoEventWireup="true" CodeFile="ChallanReportView.aspx.cs" Inherits="SInventory_UI_ChallanReportView" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Challan View 
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
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    
                       </tr>
                      <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp; </td>
                        <td width="20%" class="TDRight">
                         
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                         <asp:HyperLink ID="HyperLink1" runat="server" ForeColor="green"
                                NavigateUrl="~/SInventory_UI/CreatePickingOnWareHouse.aspx">Back to List</asp:HyperLink>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                             	National Report :
                        </td>
                        <td width="20%" class="TDRight">
                       
                       
                            <asp:CheckBox ID="CheckBox1" runat="server" 
                                oncheckedchanged="CheckBox1_CheckedChanged" AutoPostBack="True" />

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
                        <td width="13%" class="TDLeft">
                            Sales Center
                        </td>
                        <td width="20%" class="TDRight">
                         <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" >
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                            
                        </td>
                        <td width="13%" class="TDLeft">
                           Challan From Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="dateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="dateTextBox"
                                PopupButtonID="imgDate">
                            </asp:CalendarExtender>
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
                           Challan to Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate2"></asp:ImageButton>
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="TextBox1"
                                PopupButtonID="imgDate2">
                            </asp:CalendarExtender>
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
                        <td width="13%" class="TDLeft">
                            
                      </td>
                        <td width="20%" class="TDRight" runat="server" >
                            <style>
                                .button2nnn {
  background-color: white!important; 
  color: black!important;  
  border: 2px solid #008CBA!important;
   background-color: #4CAF50!important; /* Green */
  
  color: white  !important;
  
  text-align: center!important;
  text-decoration: none!important;
  display: inline-block!important;
   
  transition-duration: 0.4s!important;
  cursor: pointer !important;
}

.button2nnn:hover {
  background-color: #008CBA!important; 
  color: white!important; 
}

                            </style>
                            <table>
                                <tr>
                                    <td > <asp:Button ID="searchButton" runat="server" Text="View List" 
                                onclick="searchButton_Click" /></td>
                                    <td style="padding-right: 10px;padding-left: 10px"><asp:Button CssClass="button2nnn" ID="btnReload" runat="server" Text="Reload" 
                                onclick="btnReload_Click" />	</td>
                                </tr>
                            </table>
                              <asp:Button ID="detailsButton" runat="server" Visible="false" Text="Details Report" 
                                       BackColor="#52be80"  onclick="detailsButton_Click" />
                              <asp:Button ID="summaryButton" runat="server" Visible="false" Text="Summary Report" 
                             BackColor="#0b5345"    onclick="summaryButton_Click" />&nbsp;
                           
<span style="margin-right: 10px;">&nbsp;  </span>
   &nbsp;                        
                        </td>
                        <td width="13%" class="TDLeft">
                             
                        </td>
                        <td width="20%" class="TDRight">
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
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft"  runat="server" Visible="false">
                             <asp:Button ID="excelButton1" runat="server" Text="Export to Excel" OnClick="btnExportToExcel_Click" />
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight" colspan="4">
                            <div id="divForGrid" width="auto" hight="100px" overflow="auto">
                            <asp:GridView ID="reportListGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" DataKeyNames="ReqId"   onrowcommand="loadGridView_RowCommand" >
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C.Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C.Name" />
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req.No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="Req.Date" />
                                    <asp:BoundField DataField="IssueChalanNo" HeaderText="DeliveryClnNo" />
                                    <asp:BoundField DataField="IssuChalanDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="DeliveryClnDate" />


 <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                ImageUrl="~/images/edit.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate >
                                            <asp:Button ID="printButton" runat="server" Font-Bold="False" CssClass="button2nnn"
                                                Font-Italic="False" Text="PRINT" onclick="printButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>




                                </Columns>
                            </asp:GridView>
                               <asp:GridView ID="summaryGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" >
                                <Columns>
                                      <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                      <asp:BoundField DataField="TotalQuantity" HeaderText="Total Quantity" />
                                    
                                      <asp:BoundField DataField="TotalPriceAmount" HeaderText="Total Price Amount" />
                                    
                                      <asp:BoundField DataField="TotalVATAmount" HeaderText="Total VAT Amount" />
                                    <asp:BoundField DataField="TotalPriceAmountwithVat" HeaderText="Total Amount with Vat" />
                                 
                                </Columns>
                            </asp:GridView>
                               <asp:GridView ID="detailsGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" >
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C.Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C.Name" />
                                    
                                    
                                      <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                      <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    
                                    
                                      <asp:BoundField DataField="TotalQuantity" HeaderText="Total Quantity" />
                                    <asp:BoundField DataField="UnitPrice" HeaderText="TP Price" />
                                    
                                    
                                    
                                      <asp:BoundField DataField="TotalPriceAmount" HeaderText="Total Price Amount" />
                                    <asp:BoundField DataField="VATAmountPerUnit" HeaderText="VAT Amount Per Unit" />
                                    

                                    
                                      <asp:BoundField DataField="TotalVATAmount" HeaderText="Total VAT Amount" />
                                    <asp:BoundField DataField="TotalPriceAmountwithVat" HeaderText="Total Amount with Vat" />
                                    
                                    
<%--
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req.No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="Req.Date" />--%>
                                    <asp:BoundField DataField="IssueChalanNo" HeaderText="DeliveryClnNo" />
                                    <asp:BoundField DataField="SubmitDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="DeliveryClnDate" />
                                 
                             <%--       <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate>
                                            <asp:Button ID="printButton" runat="server" Font-Bold="False" 
                                                Font-Italic="False" Text="PRINT" onclick="printButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>
                            </div>
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
         <Triggers>
              <asp:PostBackTrigger ControlID="excelButton1" />
                 
               </Triggers>
    </asp:UpdatePanel>
</asp:Content>
