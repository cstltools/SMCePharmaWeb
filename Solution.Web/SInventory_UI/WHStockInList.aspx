<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="WHStockInList.aspx.cs" Inherits="SInventory_UI_WHStockInList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> WH StockIn List</div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                    <div class="card-body">
 
                       
                   


        <div class="row" >
         <div class="table-responsive" id="MainGradeDiv">   
               <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="WHStockInMasterID" 
                                onrowcommand="loadGridView_RowCommand" >
                                <Columns>
                                    <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                    <asp:BoundField DataField="ApproveDate" HeaderText="StockIn Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                    <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="TotalQuantity" HeaderText="TotalQty" />
                                    <asp:BoundField DataField="TotalVat" HeaderText="TotalVat" />
                                    <asp:BoundField DataField="TotalValue" HeaderText="TotalAmount" />
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="HyperLink1" runat="server"  OnClick="HyperLink1_OnClick" >Go&gt;&gt;&gt;&gt;&gt;</asp:LinkButton>
                                      
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
          </div>
          </div>
      
       
          
    
    
                                </div>  
                                </div>  
                                </div>  
                                </div>  
              
                                </div>  
                                </div>  
                 </div> 
     </ContentTemplate>
    </asp:UpdatePanel>
      <%--  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            WH StockIn List</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
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
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight" colspan="4">
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="WHStockInMasterID" 
                                onrowcommand="loadGridView_RowCommand" >
                                <Columns>
                                    <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                    <asp:BoundField DataField="ApproveDate" HeaderText="StockIn Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                    <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="TotalQuantity" HeaderText="TotalQty" />
                                    <asp:BoundField DataField="TotalVat" HeaderText="TotalVat" />
                                    <asp:BoundField DataField="TotalValue" HeaderText="TotalAmount" />
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="HyperLink1" runat="server"  OnClick="HyperLink1_OnClick" >Go&gt;&gt;&gt;&gt;&gt;</asp:LinkButton>
                                      
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
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
    </asp:UpdatePanel>--%>

</asp:Content>

