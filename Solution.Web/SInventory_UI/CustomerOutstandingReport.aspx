<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="CustomerOutstandingReport.aspx.cs" Inherits="SInventory_UI_CustomerOutstandingReport" %>
<%@ Register TagPrefix="uc1" TagName="IVMarketStructure" Src="~/MasterSetup_UI/IVMarketStructure.ascx" %>
<%--
<%@ Register Src="~/SInventory_UI/IVMarketStructureInvoSearch.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> --%>
 <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .button-padding-right {
            margin-right: 5px;
        }   
         .SelectchkChoice label {
            padding-left: 4px;
            font-weight: bold;
        }
    </style>
    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Payment Report</div>
                
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
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
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

                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label"> </label>

                                                <div class="col-sm-7">
                                                     
                                                    <asp:CheckBox ID="CheckBox1" runat="server"  CssClass="SelectchkChoice"   AutoPostBack="True"
                                oncheckedchanged="CheckBox1_CheckedChanged1" Text="National Report" />
                                                      
                                                    </div>
                                                    </div>
                                         
                                             

                                       

                                              <div class="form-group row"  runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Sales Center:</label>

                                                <div class="col-sm-7">
                                           <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" onselectedindexchanged="salesCenterDropDownList_SelectedIndexChanged"
                                >
                            </asp:DropDownList>

                                                     

                                                    </div>
                                                  
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:</label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice From Date" ></asp:TextBox>

                                                 



                                                </div> 
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">To Date:</label>

                                                <div class="col-sm-7">
                                                                   
                  <asp:TextBox ID="todateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice To Date"></asp:TextBox>
                                                 



                                                </div>
                                                
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Payment terms:</label>

                                                <div class="col-sm-7">
                                <asp:DropDownList
                              ID="paymentTermsDropdown" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                              <asp:ListItem Value="1">Paid</asp:ListItem>
                             <%-- <asp:ListItem Value="Partial">Partially paid</asp:ListItem>--%>
                              <asp:ListItem Value="0">Due</asp:ListItem>
                             <%-- <asp:ListItem Value="2">Detail (Paid and Due) </asp:ListItem>--%>
                          </asp:DropDownList>
                                                 



                                                </div> 
                                            </div>
                             </div>
                         
                         <div class="col-8" runat="server" visible="false">
                                                <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
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
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  
                                                       <asp:DropDownList ID="marketDropDownList" Visible="false" runat="server" CssClass="DropDown" 
                              >
                            </asp:DropDownList>

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
                                                   <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

                                 <div class="table-responsive" id="MainGradeDiv">
                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />
                                    
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />


                                    <asp:BoundField DataField="Type" HeaderText="Programe Type" />
                                    <asp:BoundField DataField="NewType" HeaderText="Customer Type" />
                                    <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                    <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />

                                              <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Delivery Invoice Number" />
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Delivery Invoice Date" />

                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                    <asp:BoundField DataField="DeliveryQuantity" HeaderText="Sold Qty" />
                                    <asp:BoundField DataField="DeliveryNetAmount" HeaderText=" Net Sales Amount" />
                                    <asp:BoundField DataField="DeliveryTotalPriceVatAmount" HeaderText="VAT Amount" />
                                    <asp:BoundField DataField="DeliveryDiscountAmount" HeaderText="Trade Discount " />

                                    <asp:BoundField DataField="DelivarySpecialAmount" HeaderText="Special Discount  " />
                                    <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />


                                    <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                    <asp:BoundField DataField="AreaCode" HeaderText="Territory Code" />
                                    <asp:BoundField DataField="DistrictCode" HeaderText="FE Code" />
                                    <asp:BoundField DataField="MiaCode" HeaderText="DZSM Code" />

                                    <%--<asp:BoundField DataField="MainMIOCODE" HeaderText="MIO CODE" />--%>
                                    <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Type" />
                           


                                    
                                </Columns>
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
</asp:Content>
