<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="OrderRequisitionView.aspx.cs" Inherits="SInventory_UI_OrderRequisitionView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Transfer Order List </div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="LinkButton1" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                   
                                    <div class="p-4 border rounded">
                                        <div class="row g-3 needs-validation">
                                                        
                  

           <div class="table-responsive" id="MainGradeDiv">                      
                        
          


                          <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-striped table-bordered  " OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ReqId" >
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req. No" />
                                    <asp:BoundField DataField="ReqDate" HeaderText="Req. Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                   <%-- <asp:BoundField DataField="WearhouseName" HeaderText="WearhouseName" />--%>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
                                    <asp:BoundField DataField="Qty" HeaderText="Total Qty." />
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Edit ?');"   ImageUrl="~/images/edit.png"   OnClick="EditData_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                          <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton2" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"     ImageUrl="~/images/lineDelete.png"  OnClick="ImageButton2_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

           
          </div>
   
                    
                     
                                </div>  
                                </div>  
                                               </ContentTemplate>
      
    </asp:UpdatePanel>
                                </div>  
                                </div>  
              
                                </div>  
                                </div>  
                     </div>  
               
            </div>
  <%--  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                           Stock Transfer Order List</td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp; Add New :</td>
                        <td width="20%" class="TDRight">
                            <asp:ImageButton ID="EmpCetegoryAddImageButton" runat="server" 
                                ImageUrl="~/images/Add.png" onclick="custCetegoryAddImageButton_Click" />
                            <br/>
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
              
                        <td width="43%" class="TDLeft" colspan="4">
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="ReqId" >
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req. No" />
                                    <asp:BoundField DataField="ReqDate" HeaderText="Req. Date" DataFormatString="{0:dd-MMM-yyyy}" />
                             
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
                                    <asp:BoundField DataField="Qty" HeaderText="Total Qty." />
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Edit ?');"   ImageUrl="~/images/edit.png"   OnClick="EditData_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                          <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton2" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"     ImageUrl="~/images/lineDelete.png"  OnClick="ImageButton2_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
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

