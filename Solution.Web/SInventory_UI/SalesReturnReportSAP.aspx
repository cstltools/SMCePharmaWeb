<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="SalesReturnReportSAP.aspx.cs" Inherits="SInventory_UI_SalesReturnReportSAP" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return Report (SAP)</div>
                
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
                               $('.mySelect2').select2({
                                   theme: 'bootstrap4',
                                   width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                   placeholder: $(this).data('placeholder'),
                                   allowClear: Boolean($(this).data('allow-clear')),
                               });
                               $('.datepicker').pickadate({
                                   selectMonths: true,
                                   selectYears: true
                               })

                           }
                       </script>
                    <div class="row">

                                           

                         <div class="col-4">
                              

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="fromDateTextBox"  AutoPostBack="true" OnTextChanged="fromDateTextBox_TextChanged"  runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  From Date" ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> To Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                   
                  <asp:TextBox ID="toDateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                                 



                                                </div>
                                              
                                            </div>
                             </div>

                        
                         </div>

                              <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            
                                            
                                            <br />
                                             

                                       


                                                    </div>
                                                    </div>
                                      <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                           
                                                      <asp:LinkButton  OnClick="viewRptButton_Click"   runat="server" id="LinkButton1" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                        </asp:LinkButton>
                            

                                                    

                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>

                
                     <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-3" >

                          <div class="form-group row  pull-right">
                                                  <asp:LinkButton  OnClick="btnExportToExcel_Click"   runat="server" id="LinkButton2" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                        </asp:LinkButton>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

             <div class="table-responsive" id="MainGradeDiv"  style="height:600px">

                 <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"   
                                CssClass="table table-striped table-bordered" ShowFooter="True">
                                <Columns>
                                  <asp:BoundField DataField="IdocNo" HeaderText="Idoc No" />
                                     <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
        <asp:BoundField DataField="Zone" HeaderText="Zone" />
        <asp:BoundField DataField="Area" HeaderText="Area" />
        <asp:BoundField DataField="Territory" HeaderText="Territory" />
        <asp:BoundField DataField="ReturnDate" HeaderText="Return Date" DataFormatString="{0:dd/MM/yyyy}" />
        <asp:BoundField DataField="Plant" HeaderText="Plant" />
        <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
        <asp:BoundField DataField="Batch" HeaderText="Batch" />
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="UoM" HeaderText="UoM" />
        <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" />
        <asp:BoundField DataField="VAT" HeaderText="VAT"  />
        <asp:BoundField DataField="DiscountAmount" HeaderText="Discount Amount"  />
        <asp:BoundField DataField="FOCFlag" HeaderText="FOC Flag" />
                                </Columns>
   <%--<PagerStyle HorizontalAlign="Left" CssClass="GridPager" />--%>

                            </asp:GridView>
                           
                 </div>
                   

                    </ContentTemplate>
                 <Triggers>
                 
                 <asp:PostBackTrigger ControlID="LinkButton2"/>
             </Triggers>
                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                </div>

<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>
            <div runat="server" visible="false">
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Pharma Sales, Collection & Deposition Statement Report																
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
                    
                    
                    
                      <%--<tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            Report Type</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="rptTypeDropDownList" runat="server" runat="server"
                                CssClass="DropDown" 
                                onselectedindexchanged="rptTypeDropDownList_SelectedIndexChanged" >
                                <asp:ListItem Text="Branch Wise" Value="BranchWise"></asp:ListItem>
                                <asp:ListItem Text="DZSM Wise" Value="DZSMWise"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td width="20%" class="TDRight">
                            </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>--%>
                    
                    

                   
                     <tr id="divSalsesCenter"  runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Zone Name
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="zoneDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                           <tr id="Tr1"  runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                          </td>
                        <td width="13%" class="TDLeft">
                            Depot Name
                           
                        </td>
                        <td width="20%" class="TDRight">
                           <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" > </asp:DropDownList>  </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                      <tr id="Tr2"  runat="server" Visible="False">
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
                            <asp:Button ID="viewRptButton" runat="server" OnClick="viewRptButton_Click" Text="Search" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                            <asp:Button ID="excelButton1" runat="server" Text="Export to Excel" OnClick="btnExportToExcel_Click" />
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
                          <asp:UpdatePanel ID="UpdatePanel2"  runat="server">
                        <ContentTemplate>
                        <td width="13%" class="TDLeft" colspan="6">
                             <br/>  <br/>  <br/>  <br/>  
                        </td>
                            </ContentTemplate>
                    </asp:UpdatePanel>
                    </tr>
                </table>
            </div>
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
