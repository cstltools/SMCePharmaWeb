<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="B2BTransferView.aspx.cs" Inherits="SInventory_UI_B2BTransferView" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
              
         .margin-right
        {
            margin-right: 7px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    




       <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>

                     <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>

             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Transfer DC to DC  List </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        

                         

                               <asp:LinkButton ID="viewLinkButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="custCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>
                    </div>
                
                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

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

                   
                        
                       
<div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> From Date:</label>

                                    <div class="col-sm-5">
                                      
                           
                                     
                                     <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker "></asp:TextBox>
                         

                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                                
                                
                                    <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> To Date:</label>

                                    <div class="col-sm-5">
                                      
                           
                                     
                                     <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker "></asp:TextBox>
                           
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                                </div> 
                                </div> 
                        
                        
                        
                             <br />

                        
                            

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">


                                          <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="searchButton_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="cancelButton" onclick="cancelButton_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

  
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        
                        <br/>
                        
                        <div class="row">
      <div class="table-responsive" id="MainGradeDiv">
          
              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"   CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender" 
                                    DataKeyNames="ChalanId, ChalanNo">
                                    <Columns>
                                        <asp:TemplateField HeaderText="#SL">
                                            <ItemTemplate>
                                                <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ChalanNo" HeaderText="Chalan No" />
                                        <asp:BoundField DataField="ChalanDate" HeaderText="Chalan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <%-- <asp:BoundField DataField="WearhouseName" HeaderText="WearhouseName" />--%>
                                        <asp:BoundField DataField="FromComUnitName" HeaderText="From (DC)" />
                                        <asp:BoundField DataField="ToComUnitName" HeaderText="To (DC)" />
                                        <asp:BoundField DataField="TotalValue" HeaderText="Total Value" />
                                        <asp:BoundField DataField="TotalVat" HeaderText="Total Vat" />
                                        <asp:BoundField DataField="GrandTotal" HeaderText="Grand Total" />
                                        <asp:BoundField DataField="Status" HeaderText="Status" />


                                         <asp:TemplateField HeaderText="Report">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btPrint" runat="server" CommandArgument="<%# Container.DataItemIndex %>" class="btn-info  btn-sm mb-1 mb-md-0" 
                                                    CommandName="PrintData"  
                                                      OnClick="btPrint_Click" >   <i class="fa fa-print"></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                      <%--  <asp:TemplateField HeaderText="Delete">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editImageButton" runat="server" CommandArgument="<%# Container.DataItemIndex %>" class="btn-danger  btn-sm mb-1 mb-md-0" 
                                                    CommandName="EditData" OnClientClick="return sweetAlertConfirm_Delete(this);" 
                                                      OnClick="editImageButton_Click" >   <i class="fa fa-trash"></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>--%>
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
                     </ContentTemplate>
            </asp:UpdatePanel>
                
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="False">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            B2B Transfer view
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
                            &nbsp; Add New :
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:ImageButton ID="EmpCetegoryAddImageButton" runat="server" ImageUrl="~/images/Add.png"
                                OnClick="custCetegoryAddImageButton_Click" />
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <%-- <asp:ImageButton ID="EmpCetegoryReloadImageButton" runat="server" 
                                ImageUrl="~/images/refresh.png" 
                                onclick="custCetegoryReloadImageButton_Click" />--%>
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
                        <td width="20%" class="TDRight">
                            <%--<asp:ImageButton ID="cusMasterNewImageButton" runat="server" 
                                ImageUrl="~/images/Add.png" onclick="CustMasterNewImageButton_Click" />--%>
                        </td>
                        <td width="13%" class="TDLeft">
                            From Date
                        </td>
                        <td width="20%" class="TDRight">
                           
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
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
                            To Date
                        </td>
                        <td class="TDRight" width="20%">
                       
                            
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
                                &nbsp;
                            </td>
                            <td width="20%" class="TDRight">
                                &nbsp;
                            </td>
                            <td width="13%" class="TDLeft">
                                &nbsp;
                            </td>
                            <td width="20%" class="TDRight">
                                
                                <asp:Button ID="submitButton" runat="server" Text="Search" CssClass="margin-right"
                                OnClick="searchButton_Click" BackColor="#16A085" />

                                 <asp:Button ID="submitButton0" runat="server" BackColor="#F9A029" OnClick="submitButton_OnClick"  Text="Cancel" />                                
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
                        <td width="20%" class="TDRight" colspan="6">
                            <div id="gridContainer1" style="height: 400px; overflow: auto; width: 97%; margin: 0 auto;">
                            
                            </div>
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
