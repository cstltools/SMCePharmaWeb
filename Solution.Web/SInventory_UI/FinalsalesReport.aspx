<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="FinalsalesReport.aspx.cs" Inherits="SInventory_UI_FinalsalesReport" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Final Sales Report </div>
                
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
                         <div class="col-3"> 
                                         <label for="mainName" class="col-sm-5 col-form-label"> 	   </label>
                                        </div>   
                                           

                         <div class="col-4">
                             

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select From Date" ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">To Date:  <span style="color:red">*</span></label>

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

                                                      <asp:LinkButton  OnClick="viewRptButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; Search
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>

                    <br />
                              <div class="row">

                                        <div class="col-3"> 
                                         <label for="mainName" class="col-sm-5 col-form-label"> 	   </label>
                                        </div>   

                         <div class="col-4">
                             

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	BSP Customer:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="BSPCustomerTextBox" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>


                                <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	BSP Invoice:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="BSPInvoiceTextBox1" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>
                             <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	 Green customer:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="GreencustomerTextBox2" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>


                                     <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	  Green Invoice:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="GreenInvoiceTextBox3" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                  <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	  Other customer:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="OthercustomerTextBox4" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	   Other Invoice:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="OtherInvoiceTextBox5" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>
                                            
                             </div>

                         
                         </div>

                     <br />
                              <div class="row">

                                    <div class="col-3"> 
                                         <label for="mainName" class="col-sm-5 col-form-label"> 	Prescription  </label>
                                        </div>
                         <div class="col-4">
                             

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Blue Star:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtBlueStar_P" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>


                                <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Green Star:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtGreenStar_P" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>
                             <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	 Pink Star:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtPinkStar_P" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>


                                     <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	  Other:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtOther_P" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                   

                         
                                            
                             </div>

                         
                         </div>
                   

                              <br />
                              <div class="row">

                                    <div class="col-3"> 
                                         <label for="mainName" class="col-sm-5 col-form-label"> 	DCR  </label>
                                        </div>
                         <div class="col-4">
                             

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Blue Star:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtBlueStar_DCR" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>


                                <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Green Star:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtGreenStar_DCR" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>
                             <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	 Pink Star:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtPinkStar_DCR" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>


                                     <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	  Other:  </label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="txtOtherStar_DCR" runat="server" class="form-control form-control-sm mb-3 "  ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                   

                         
                                            
                             </div>

                         
                         </div>
                       <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-3" >

                          <div class="form-group row  pull-right">
                                                      <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2"   style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportToExcel_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>

                               <%--   <button type="button" class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" onclick="exportToExcel()"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

             <div class="table-responsive" id="MainGradeDiv"  style="height:600px">
                  <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="loadGridView_OnRowCreated"
                                               CssClass="table table-striped table-bordered"  ShowFooter="True">
                                <Columns>
                                    <%--<asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                       <asp:BoundField DataField="ProductSQName" HeaderText="Brand" />
                                    <asp:BoundField DataField="BSP2019" HeaderText="BSP" />
                                    <asp:BoundField DataField="Green2019" HeaderText="Green"  />
                                     <asp:BoundField DataField="OTHER2019" HeaderText="Other"  />


                            <%--    <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="No of Invoice" 
                                ItemStyle-Width="60" DataFormatString="{0:D}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NumberofProformaInvoice" HeaderText="Number of Proforma Invoice" visible="false" />
                                 
                                    <asp:BoundField DataField="SumofNetProformaAmount" 
                                        HeaderText="Amount (TP)"  ItemStyle-Width="60" DataFormatString="{0:F0}"
                                  ItemStyle-HorizontalAlign="Right" >
                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>
                                      <asp:BoundField DataField="ProTpVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="NetInvoiceAmt" HeaderText="Gross Invoice Amt" DataFormatString="{0:F0}" />


                                       <asp:BoundField DataField="NumberofReturnInvoice" HeaderText="Number of Returned Invoices" DataFormatString="{0:D}" visible="false"/>
                                    <asp:BoundField DataField="SumofNetReturnAmount" HeaderText="Amount (TP)" DataFormatString="{0:F0}" />
                                     <asp:BoundField DataField="DelReTpVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="NetReturnAmt" HeaderText="Gross Return Amt" DataFormatString="{0:F0}"/>

                                         <asp:BoundField DataField="salesTP" HeaderText="Amount (TP)" DataFormatString="{0:F0}"/>
                                     <asp:BoundField DataField="SalesVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="SalesTotal" HeaderText="Gross Sales Amt" DataFormatString="{0:F0}"/>

                                    <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Number of Invoices Sold" DataFormatString="{0:D}" visible="false"/>
                                    <asp:BoundField DataField="SumofNetSalesAmount" HeaderText="Amount (TP)" DataFormatString="{0:F0}"/>
                                     <asp:BoundField DataField="DelTpVat" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="NetSalesAmt" HeaderText="Gross Collection" DataFormatString="{0:F0}"/>

                                          <asp:BoundField DataField="NumberofInvoiceSold" HeaderText="Number of Invoices Sold" DataFormatString="{0:D}" visible="false"/>
                                    <asp:BoundField DataField="Outstanding1" HeaderText="Amount (TP)" DataFormatString="{0:F0}"/>
                                     <asp:BoundField DataField="Outstanding2" HeaderText="VAT" DataFormatString="{0:F0}"/>
                                       <asp:BoundField DataField="Outstanding3" HeaderText="Gross Outstanding Amt." DataFormatString="{0:F0}"/>--%>

                                </Columns>
                                          <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />

                            </asp:GridView>
                      
                                  
                                            </div>

                    </ContentTemplate>
                     <Triggers>
                 
                 <asp:PostBackTrigger ControlID="btnExport"/>
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
                            Final Sales Report
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
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            BSP Customer</td>
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
                            BSP Invoice</td>
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
                           Green customer</td>
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
                           Green Invoice</td>
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
                           Other customer</td>
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
                           Other Invoice</td>
                        <td width="20%" class="TDRight">
                          
                        </td>
                        <td width="13%" class="TDLeft">
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
