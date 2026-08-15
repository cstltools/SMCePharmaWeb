<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="TerritoryWiseSalesReport.aspx.cs" Inherits="SInventory_UI_TerritoryWiseSalesReport" %> 
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<%@ Register Src="~/Reports_UI/IVMarketStructureMarket.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
        <script src="../VerticalAsset/jquery.tabletoCSV.js"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  
    
    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Territory wise Sales Report</div>
                
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
         <%--   <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                        <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>--%>

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
                               });

                           }
                       </script>
                    <div class="row">

                                           <asp:HiddenField runat="server" ID="hfRegionId"/>
                                           <asp:HiddenField runat="server" ID="hfGroupID"/>

                                  <asp:HiddenField ID="hfMarket" runat="server" />
            <asp:HiddenField ID="hfSubTeritory" runat="server" />
            <asp:HiddenField ID="hfTeritory" runat="server" />
            <asp:HiddenField ID="hfArea" runat="server" />
            <asp:HiddenField ID="hfZone" runat="server" />
          

                        
                         </div>
                    
                    
                         
                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-2 col-form-label">From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-3">
                                                                    <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  From Date" ></asp:TextBox>

                                                 



                                                </div>
                                               
                                          
                                                <label for="mainName" class="col-sm-2 col-form-label"> To Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-3">
                                                                   
                  <asp:TextBox ID="toDateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                                 



                                                </div>
                                              
                                            </div>
                                     
                                          <div class="form-group row">
                                                 <div class="col-sm-3"></div>
                                               <div class="col-sm-4">
                                    <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                </div>
                                </div>

                        



                            
                    


                            <div class="row"> 
                                                 <div class="col-sm-4"></div>
                                               <div class="col-sm-4">

                                         <div class="input-group" style="color:gray!important">
                                           Last Update Date & Time: <asp:Label runat="server" ID="lblInfo"></asp:Label> 
                                               
                                                    </div>
                                                                                            <div class="input-group">
                                                                                                Next Update  Date & Time: <asp:Label runat="server" ID="lblNextDate"></asp:Label>
                                                                                                </div>
                                    </div>

                                 
                                       </div>

                           
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                           
                                                      <asp:LinkButton  OnClick="viewRptButton_Click"   runat="server" id="LinkButton1" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                        </asp:LinkButton>
                            

                                                    

                                        <asp:LinkButton  runat="server"  OnClick="OnClick"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>


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
                                   <button type="button"  class="btn btn-success pull-right"  style="background-color: #1A7343; color: #fff;" onclick="exporttocsv()"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>
                                                  <asp:LinkButton Visible="false" OnClick="excelButton1_Click"   runat="server" id="LinkButton2" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                        </asp:LinkButton>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

             <div class="table-responsive" id="export"  >

                 <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"   
                                CssClass="table table-striped table-bordered" ShowFooter="True">
                                <Columns>
                                    
                                       <asp:BoundField DataField="AreaCode" HeaderText="Territory" />
                                <asp:BoundField DataField="AreaName" HeaderText="Territory Name" />
                                <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of  Invoice" 
                                ItemStyle-Width="60" DataFormatString="{0:D}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                  <%--  <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" />--%>
                                    <asp:BoundField DataField="SumofNetProformaAmount" 
                                        HeaderText="Sum of Net Invoice Amount (TP)"  ItemStyle-Width="60" DataFormatString="{0:N2}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                      <asp:BoundField DataField="ProTpVat" HeaderText="Invoice Total Vat" />
                                  
                                    <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Number of Sales Confirmation Sold" DataFormatString="{0:D}"/>
                                  
                                    <asp:BoundField DataField="SumofNetSalesAmount" HeaderText="Sum of Net Sales Confirmation Amount(TP)" />
                                    <asp:BoundField DataField="DelTpVat" HeaderText="Sales Confirmation Total Vat" />
                                    <asp:BoundField DataField="NumberofReturnInvoice" HeaderText="Number of Returned Invoices" DataFormatString="{0:D}"/>


                                    <asp:BoundField DataField="SumofNetReturnAmount" HeaderText="Sum of Net Return Amount(TP)" />
                                    <asp:BoundField DataField="DelReTpVat" HeaderText="Return Total Vat" />
                                    <asp:BoundField DataField="CustomerCoverPer" HeaderText="Sales Confirmation Chemist Coverage" />
                                        
                                        
                                     <asp:BoundField DataField="SumofNetSalesAmountFixed" HeaderText="FCB Sales Confirmation(TP)" />
                                     <asp:BoundField DataField="SumofNetSalesAmountFixedNCOD" HeaderText="NCOD Sales Confirmation  (TP)" />
                                     <asp:BoundField DataField="SumofNetSalesAmountCamp" HeaderText="Campaign Sales Confirmation (TP)" />
                                     <asp:BoundField DataField="FinalSales" HeaderText="General Sales Confirmation  (TP)" />
                                      
                                       <asp:BoundField DataField="NCODProforma" HeaderText="NCOD Proforma (TP)" />
                                        <asp:BoundField DataField="SumofNetSalesAmountFixed2" HeaderText="FCB Proforma (TP)" />
                                        <asp:BoundField DataField="SumofNetSalesAmountCamp2" HeaderText="Campaign Proforma (TP)" />
                                        <asp:BoundField DataField="FinalSales2" HeaderText="General Sales (TP) (Invoice)" />
                                        <asp:BoundField DataField="CustomerCoverPerProforma" HeaderText="Collection Chemist Coverage" />
                                      <%--  <asp:BoundField DataField="NumberofUndelInvoice" HeaderText="Number of Undelivered Invoice " />
                                           <asp:BoundField DataField="SumofNetUnAmount" HeaderText="Sum of Net UndeliveredAmount(TP)" />
                                              <asp:BoundField DataField="UnTpVat" HeaderText="Undelivered Total Vat" />--%>
                                              
                                              
                                        <asp:BoundField DataField="BlueNetSell" HeaderText="BSP Net Invoice Amount (TP)" />
                                        <asp:BoundField DataField="GreenNetSell" HeaderText="GSP Net Invoice Amount (TP)" />
                                        <asp:BoundField DataField="DelBlueNetSell" HeaderText="BSP Net Sales Confirmation Amount (TP)" />
                                        <asp:BoundField DataField="DelGreenNetSell" HeaderText="GSP Net Sales Confirmation (TP)" />
                                        
                                        

                                        <asp:BoundField DataField="BlueCov" HeaderText="Sales confiramation BSP Coverage" />
                                        <asp:BoundField DataField="greenCov" HeaderText="Sales confiramation GSP Coverage" />
                                          <asp:BoundField DataField="DelBlueCov" HeaderText="Collection BSP Coverage " />
                                        <asp:BoundField DataField="DelgreenCov" HeaderText="Collection GSP Coverage " />


                                        <asp:BoundField DataField="ActualProforma" HeaderText="Net Sales (Total Sales - Return)" />

                                         <asp:BoundField DataField="CustCollectionGross" HeaderText="Gross Collection (TP+VAT)" />
                                       <asp:BoundField DataField="CollectionAmtTP" HeaderText="Collection TP" />
   <asp:BoundField DataField="CollectionVat" HeaderText="Collection VAT" />
                                        <asp:BoundField DataField="TotalOutStanding" HeaderText="Total OutStanding" />
                                   

                                     

  

                                   </Columns>
  

                            </asp:GridView>
                           
                 </div>
                   

                <%--    </ContentTemplate>
                 <Triggers>
                 
                 <asp:PostBackTrigger ControlID="LinkButton2"/>
             </Triggers>
                </asp:UpdatePanel>--%>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                </div>
         <script type="text/javascript">

             //<asp:ListItem Selected="True" Value="1">Doctor Wise</asp:ListItem>
             //                   <asp:ListItem Value="2">Product Brand Wise</asp:ListItem>
             //                   <asp:ListItem Value="3">Product Wise</asp:ListItem>
             //                       <asp:ListItem Value="4">User Wise</asp:ListItem>
             function exporttocsv() {

                  

                 //if (value == "5") {
                 //    txt = "Doctor Coverage Report ";
                 //}
                 $("#export").tableToCSV({
                     filename: 'Territory Wise Summary'
                 });
             }
         </script>

<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>
            <div runat="server" Visible="False">
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Business Summary
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
                    
                    <%--  <tr>
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
                    
                    
                      <tr id="divDzsm" runat="server" Visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            DZSM Name</td>
                        <td width="13%" class="TDLeft">
                            <asp:DropDownList ID="dzsmDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList>
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
                          DZSM Name
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
                        <asp:Button ID="excelButton1" runat="server" Text="Export to Excel" OnClick="excelButton1_Click" />
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
                   
                    <tr >
                        <td width="13%" class="TDLeft" colspan="6" >
                          
                            <br/>  <br/>  <br/>  <br/>  
                        </td>
                    </tr>
                    
                </table>
            </div>
  <%--      </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
