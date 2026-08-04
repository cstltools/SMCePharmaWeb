<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CreatePickingOnWareHouse.aspx.cs" Inherits="SInventory_UI_CreatePickingOnWareHouse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> S.T.O List </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
 <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="ListImageButton_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;View List</asp:LinkButton>

                       

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                

                    <div class="card-body">
                        <br />
          
                         <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>

                          <asp:HiddenField ID="HiddenField1" runat="server" />


                       
                 
   <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
       
                          
             <asp:GridView ID="viewReqGridView" runat="server" AutoGenerateColumns="False" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                 DataKeyNames="ReqId,ComUnitId">
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req. No." />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Req. Date" />
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
                                   <%--  <asp:BoundField DataField="ManufacName" HeaderText="Manufacturer" />--%>
                                    <asp:HyperLinkField DataNavigateUrlFields="ReqId" 
                                        DataNavigateUrlFormatString="CreatePickingDetailForWareHouse.aspx?ReqId={0}" 
                                        HeaderText="Issue" Text="Go For Issue&gt;&gt;&gt;&gt;&gt;" />
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

<%--      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            S.T.O List 
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
                                NavigateUrl="~/SInventory_UI/ChallanReportView.aspx">View List</asp:HyperLink>
                    </tr>
                                        <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%" colspan="4">
                            <asp:GridView ID="viewReqGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="ReqId,ComUnitId">
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req. No." />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Req. Date" />
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
  
                                    <asp:HyperLinkField DataNavigateUrlFields="ReqId" 
                                        DataNavigateUrlFormatString="CreatePickingDetailForWareHouse.aspx?ReqId={0}" 
                                        HeaderText="Issue" Text="Go For Issue&gt;&gt;&gt;&gt;&gt;" />
                                </Columns>
                            </asp:GridView>
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
    </asp:UpdatePanel>--%>
</asp:Content>

