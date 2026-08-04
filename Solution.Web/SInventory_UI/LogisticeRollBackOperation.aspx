<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="LogisticeRollBackOperation.aspx.cs" Inherits="SInventory_UI_LogisticeRollBackOperation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Logistics Rollback Operation </div>

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
 
                       
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                            <br />
                 

                               <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Steps :</label>

                                    <div class="col-sm-5">
                                       <script type="text/javascript">
                                              function pageLoad() {
                                                  $('.datepicker').pickadate({
                                                      selectMonths: true,
                                                      selectYears: true
                                                  })
                                                  $('.mySelect2').select2({
                                                      theme: 'bootstrap4',
                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                      placeholder: $(this).data('placeholder'),
                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                  });
                                              }
                                             </script>

                                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="
form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" onselectedindexchanged="DropDownList1_SelectedIndexChanged">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem Value="SG">STO Generate</asp:ListItem>
                                <asp:ListItem Value="PG">Picking Generate</asp:ListItem>
                                <asp:ListItem Value="CG">Challan Generate</asp:ListItem>
                            </asp:DropDownList>
                           
                           
                                    
                                    </div>
                                
                                </div>   
                                
                             
                                                 
                                </div>  
                                </div>  
                           <br />


                        <div class="row" id="sto" runat="server" Visible="False">
         <div class="table-responsive" id="MainGradeDiv">
       
       
               <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender"  DataKeyNames="ReqId" >
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req. No" />
                                    <asp:BoundField DataField="ReqDate" HeaderText="Req. Date" DataFormatString="{0:dd-MMM-yyyy}" />
                               
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
                                    <asp:BoundField DataField="Qty" HeaderText="Total Qty." />
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"    ImageUrl="~/images/lineDelete.png"  OnClick="ImageButton2_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
          </div>
          </div>
      
                        <div class="row" id="picking" runat="server" Visible="False">
         <div class="table-responsive" id="MainGradeDiv">
       
       
                <asp:GridView ID="viewReqGridView" runat="server" AutoGenerateColumns="False" 
                                   CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ReqId,ComUnitId">
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Requision No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Req Date" />
                                        
                                        
                                         <asp:BoundField DataField="PickingNo" HeaderText="Picking No" />
                                    <asp:BoundField DataField="PickingDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Picking Date" />
                                        
                                                                          
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
                                    
                                    
                                    <asp:BoundField DataField="ManufacName" HeaderText="Manufacturer" />
                                    

                                   <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"    ImageUrl="~/images/lineDelete.png"  OnClick="editImageButton_OnClick"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
          </div>
          </div>

                        <div class="row" id="challan" runat="server" Visible="False">
         <div class="table-responsive" id="MainGradeDiv">
       
               <asp:GridView ID="stockInTraGridView" runat="server" 
                                    AutoGenerateColumns="False"    CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="ReqId">
                                    <Columns>
                                        <asp:BoundField DataField="IssueChalanNo" HeaderText="ChalanNo" />
                                        <asp:BoundField DataField="IssuChalanDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                            HeaderText="ChalanDate" />
                                        <asp:BoundField DataField="TruckNo" HeaderText="TruckNo" />
                                        <asp:BoundField DataField="DriverName" HeaderText="DriverName" />
                                        <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"    ImageUrl="~/images/lineDelete.png"  OnClick="edit2ImageButton_OnClick"/>
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
 <%--   <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Logistics Rollback Operation</td>
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
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            Steps</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="DropDownList1" runat="server" CssClass="DropDown" 
                                AutoPostBack="True" onselectedindexchanged="DropDownList1_SelectedIndexChanged">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem Value="SG">STO Generate</asp:ListItem>
                                <asp:ListItem Value="PG">Picking Generate</asp:ListItem>
                                <asp:ListItem Value="CG">Challan Generate</asp:ListItem>
                            </asp:DropDownList>
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
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                     <tr id="sto" runat="server" Visible="False">
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
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"    ImageUrl="~/images/lineDelete.png"  OnClick="ImageButton2_Click"/>
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
                    <tr id="picking" runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%" colspan="4">
                            <asp:GridView ID="viewReqGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="ReqId,ComUnitId">
                                <Columns>
                                    <asp:BoundField DataField="ReqNo" HeaderText="Requision No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Req Date" />
                                        
                                        
                                         <asp:BoundField DataField="PickingNo" HeaderText="Picking No" />
                                    <asp:BoundField DataField="PickingDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="Picking Date" />
                                        
                                        
                                        

                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C. Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C. Name" />
                                    
                                    
                                    <asp:BoundField DataField="ManufacName" HeaderText="Manufacturer" />
                                    

                                   <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"    ImageUrl="~/images/lineDelete.png"  OnClick="editImageButton_OnClick"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
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
                    <tr id="challan" runat="server" Visible="False">
                       
                            <td class="TDLeft" width="13%">
                                &nbsp;</td>
                            <td class="TDRight" width="20%" colspan="4">
                                <asp:GridView ID="stockInTraGridView" runat="server" 
                                    AutoGenerateColumns="False" CssClass="gridview" DataKeyNames="ReqId">
                                    <Columns>
                                        <asp:BoundField DataField="IssueChalanNo" HeaderText="ChalanNo" />
                                        <asp:BoundField DataField="IssuChalanDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                            HeaderText="ChalanDate" />
                                        <asp:BoundField DataField="TruckNo" HeaderText="TruckNo" />
                                        <asp:BoundField DataField="DriverName" HeaderText="DriverName" />
                                        <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirm('Are you sure you want to Delete ?');"    ImageUrl="~/images/lineDelete.png"  OnClick="edit2ImageButton_OnClick"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
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
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>--%>


</asp:Content>

