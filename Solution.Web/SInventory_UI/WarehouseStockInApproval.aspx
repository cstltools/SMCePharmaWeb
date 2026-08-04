<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="WarehouseStockInApproval.aspx.cs" Inherits="SInventory_UI_WarehouseStockInApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .align-middle
        {
            margin-left: 37px;
        }
        
        .pd-left {
            padding-left: 5px;
        }
        
        .radioButtonList
        {
            list-style: none;
            margin: 0;
            padding: 0;    
        }
        .radioButtonList.horizontal li
        {
            display: inline;
        }
        
        .radioButtonList label
        {
            display: inline;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Warehouse Stock In Approval </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_OnClick" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                     

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">



 

                    <div class="card-body">
                    


                  
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">



                                 <div class="form-group row">

                                     <div class="col-sm-5"></div>
                                    <div class="col-sm-5">

                              
                                   <span style="font-size: 15px; font-weight: bold; text-align: left; padding-right: 10px; line-height: 35px;">Take Action:</span>
                                          

                                <asp:RadioButtonList ID="statusRadioButtonList" CssClass="radioButtonList" runat="server">
                                <asp:ListItem Value="1" Text="Approve"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Reject"></asp:ListItem>
                                </asp:RadioButtonList>
                                    
                             
                      </div>
                                </div>  


                  

                                </div>  
                                </div>  




                           <br />
                              <br />
                              <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                             <div class="col-md-4"> </div>
                                    <div class="col-sm-8">

 <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="btnSubmit0_Click" style="background-color: #00bcd4;color: #fff;"
                           >   <i class="fa fa-check-square"></i>&nbsp; Submit </asp:LinkButton>
                            <asp:LinkButton ID="cancelButton"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

     

             <br />

                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
       
                  
                  <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                DataKeyNames="WHStockInMasterID" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                    <asp:BoundField DataField="WHStockInDate" HeaderText="StockIn Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                    <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="TotalQuantity" HeaderText="Total Qty" />
                                    <asp:BoundField DataField="TotalValue" HeaderText="Total Amt" />
                                      <asp:BoundField DataField="Status" HeaderText="Status" />
                                       <asp:BoundField DataField="EntryBy" HeaderText="EntryBy" />
                                        <asp:BoundField DataField="EntryDate" HeaderText="EntryDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                         
                                            <asp:ImageButton ID="printButton" runat="server" 
                                                  OnClick="printButton_Click"  ImageUrl="../images/image/if_paste-clipboard-copy_2931174.png"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                ImageUrl="~/images/edit.png" />
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



<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Warehouse Stock In Approval
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
                            &nbsp;
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
                            <span style="font-size: 15px; font-weight: bold; text-align: left; padding-left: 5px; line-height: 35px;">Take Action:</span>
                            <asp:RadioButtonList ID="statusRadioButtonList" CssClass="radioButtonList" runat="server">
                                <asp:ListItem Value="1" Text="Approve"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Reject"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td width="13%" class="TDLeft">
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
                        <td class="TDRight" style="padding-left: 7px; padding-top: 7px;" width="20%">
                            <asp:Button ID="submitButton" runat="server" OnClick="btnSubmit0_Click" Text="Submit" />
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
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview"
                                DataKeyNames="WHStockInMasterID" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                    <asp:BoundField DataField="WHStockInDate" HeaderText="StockIn Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                    <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="TotalQuantity" HeaderText="Total Qty" />
                                    <asp:BoundField DataField="TotalValue" HeaderText="Total Amt" />
                                      <asp:BoundField DataField="Status" HeaderText="Status" />
                                       <asp:BoundField DataField="EntryBy" HeaderText="EntryBy" />
                                        <asp:BoundField DataField="EntryDate" HeaderText="EntryDate" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                         
                                            <asp:ImageButton ID="printButton" runat="server" 
                                                  OnClick="printButton_Click"  ImageUrl="../images/image/if_paste-clipboard-copy_2931174.png"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                ImageUrl="~/images/edit.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
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
                        <td width="20%" style="padding-left: 250px;" class="TDRight">
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
    </asp:UpdatePanel>--%>


</asp:Content>
