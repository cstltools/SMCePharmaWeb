<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="OrderMonitor.aspx.cs" Inherits="SInventory_UI_OrderMonitor" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>

      <div id="popDiv">

</div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Order Monitoring Report</div>

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

                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>


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

                                                                  var dateNow = new Date();
                                                                  $('.datepickess').datepicker("setDate", dateNow);
                                                                  minDate: new Date() // to disable privious dates 
                                         </script>
 
                                    
                                    
                                    
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                           

                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-3 col-form-label">From Date:  <span style="color: red">*</span></label>

                                                <div class="col-sm-5">
                                                    <asp:TextBox ID="fromDateTextBox"   runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select   From Date"></asp:TextBox>





                                                </div>

                                            </div>

                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-3 col-form-label">To Date:  <span style="color: red">*</span></label>

                                                <div class="col-sm-5">

                                                    <asp:TextBox ID="toDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  To Date"></asp:TextBox>




                                                </div>

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

                                                    <asp:LinkButton  ID="viewRptButton" runat="server" OnClick="viewRptButton_Click"  class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" OnClick="Unnamed_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                            <%--  <asp:Button ID="excelButton1" runat="server" class="btn btnMyDesignSearch   btn-sm" Text="Export to Excel" OnClick="btnExportToExcel_Click" />--%>
                                        </div>
                                    </div>


                                         <div class="row">
                                        <div class="col-3"><h3>Details List</h3></div>

                            <div class="col-4"> </div>
                                        <div class="col-3">
                                               
                                            </div>
                     <div class="col-2" >
                    
                          <div class="form-group row  pull-right">
                                                      <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>

                               <%--   <button type="button" class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" onclick="exportToExcel()"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

                                            
                             <div class="table-responsive" id="MainGradeDiv"  style="height:600px">
                                   <asp:GridView ID="loadGridView" runat="server"           CssClass="table table-striped table-bordered"  AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="loadGridView_OnRowCreated"
                             ShowFooter="True">
                                <Columns>
                                
                            
                                        <asp:BoundField DataField="SalesCentreName" HeaderText="Depot Name"  />
                                        <asp:BoundField DataField="Ordertotal" HeaderText="Number of order received"  />
                                        <asp:BoundField DataField="VALUE" HeaderText="Order Value"  />
                              
                                        <asp:BoundField DataField="TotalInvoice" HeaderText="Number of Proforma/Invoice"  />
                                        <asp:BoundField DataField="InvoiceValue" HeaderText="Proforma/Invoice Value"  />
                              
                                        <asp:BoundField DataField="Rejectvalue" HeaderText="Rejection Vaue"  />   
                              
                                        <asp:BoundField DataField="deleteorder" HeaderText="Number of Deleted order"  />
                                        <asp:BoundField DataField="deletevalue" HeaderText="Order Deleted Value"  />

                                        <asp:BoundField DataField="PendinOrder" HeaderText="Number of pending Order"  />
                                        <asp:BoundField DataField="PendinOrderValue" HeaderText="Pending Value"  />
                              
                              
                                </Columns>
                            </asp:GridView>
                                       <div>
                                       <div>
                <table width="100%" class="TableWorkArea">
                  
                    <tr>
                         
                        <td width="13%" class="TDLeft" colspan="6">
                          
                            <br/>  <br/>  <br/>  <br/>  
                        </td>
                         
                    </tr>
                </table>


                                           <table style="display:none">
                                                 <tr>
                        <td colspan="6" class="TableHeading">
                           Order Monitoring Report
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
                    
                     <tr id="divSalsesCenter"  runat="server" Visible="false">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Zone Name
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="zoneDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True"
                                onselectedindexchanged="zoneDropDownList_SelectedIndexChanged" >
                            </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                           <tr id="Tr1"  runat="server" Visible="false">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Depot Name
                           
                        </td>
                        <td width="20%" class="TDRight">
                           <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" AutoPostBack="True"
                                onselectedindexchanged="salesCenterDropDownList_SelectedIndexChanged" > </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                      <tr id="Tr2"  runat="server" Visible="false">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                             Territory Name
                        </td>
                        <td width="20%" class="TDRight">
                             <asp:DropDownList ID="territoryDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList> </td>
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
                            From Date
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
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            To Date
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
                                   <Triggers>

                                    <asp:PostBackTrigger ControlID="btnExport" />
                                </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>
 </div>
 </div>
 </div>
 </div>

         
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
