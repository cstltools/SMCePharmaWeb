<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SalesReturnReport.aspx.cs" Inherits="SInventory_UI_SalesReturnReport" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<%--<%@ Register Src="../SInventory_UI/IVMarketStructureInvoSearch.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
     <style type="text/css">

            .ssss {
            font-size: 13px;
            font-weight: bold;
        }
        .button-padding-right {
            margin-right: 5px;
        }  
          .SelectchkChoice label {
            padding-left: 4px;
            font-weight: bold;
        }
    </style>
    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return Report</div>
                
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
                        

                             
                                              <div class="form-group row"  runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Sales Center:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                           <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" onselectedindexchanged="dcDropDownList1_SelectedIndexChanged"
                                >
                            </asp:DropDownList>

                                                    
                                                     

                                                    </div>
                                                   
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Return From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox  AutoPostBack="true" OnTextChanged="fromDateTextBox_TextChanged"   ID="InvoiceDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice From Date" ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label   class="col-sm-5 col-form-label">Return To Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                   
                  <asp:TextBox ID="todateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice To Date"></asp:TextBox>
                                                 



                                                </div>
                                              
                                            </div>
                             </div>

                         <div class="col-8" runat="server" visible="false">
                                               <%-- <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />--%>
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

                                                      <asp:LinkButton  OnClick="SearchButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>



                       <div class="row">
                                        <div class="col-4"><h3>Details List</h3></div>
                                        <div class="col-6">

                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right" Text="Return Amount (TP+VAT) : 0"></asp:Label>
                                            </div>
                     <div class="col-2" >

                          <div class="form-group row  pull-right">
                                                      <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2"   style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>

                               <%--   <button type="button" class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" onclick="exportToExcel()"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

             <div class="table-responsive" id="MainGradeDiv"  style="height:600px">

                          
                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"   AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                <Columns>
                                      <%--  <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />
                                       <asp:BoundField DataField="SAPPlant" HeaderText="SAP-Plant" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />


                                    <asp:BoundField DataField="CustomerType" HeaderText=" Customer Type" />
                                    <asp:BoundField DataField="ProgramType" HeaderText="Programe Type" />
                                        <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />
                                    <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                    <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                    <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Delivary Invoice  Number" />

                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                       <asp:BoundField DataField="SAPProductCode" HeaderText="SAP Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                      <asp:BoundField DataField="UoM" HeaderText="SAP UOM" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                    <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" />
                                    <asp:BoundField DataField="ReturnAmountTP" HeaderText="Return Amount TP" />
                                    <asp:BoundField DataField="ReturnAmountDiscount" HeaderText="Return Amount Discount" />
                                    <asp:BoundField DataField="ReturnAmountVat" HeaderText="Return Amount VAT" />
                                    <asp:BoundField DataField="ReturnGrossAmt" HeaderText="Return Amount (TP+VAT)" />
                                  
                                
                                    
                                  

                                    
                                     <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

  <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

   <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
   <asp:BoundField DataField="SAPTerritoryCode_Ord" HeaderText="SAP Territory Code" />

   <asp:BoundField DataField="OrderSenderSAPCode" HeaderText="Order Sender SAP Code" />
   <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  Emp Code" />
   <asp:BoundField DataField="MIOSAPCode_Ord" HeaderText="SAP  MIO Code" />
     <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Emp Name" />

     <asp:BoundField DataField="AMEmpCode" HeaderText="AM Emp Code" />
     <asp:BoundField DataField="AMSAPCode_Ord" HeaderText="SAP AM Code" />

  <asp:BoundField DataField="AMEmpName" HeaderText="AM Emp Name" />
  <asp:BoundField DataField="DZSMSAPCode_Ord" HeaderText="SAP DZSM Name" />

     <asp:BoundField DataField="RegionName" HeaderText="Zone Code" /> 
     <asp:BoundField DataField="ZoneSAP_Code" HeaderText="Zone SAP Code" /> 
     <asp:BoundField DataField="AreaName" HeaderText="Area Code" /> 
     <asp:BoundField DataField="AreaSAP_Code" HeaderText="Area SAP Code" /> 
                                    <asp:BoundField DataField="ReturnDate" HeaderText="Return Date" />
                                    <asp:BoundField DataField="ReturnReason" HeaderText="Return Reason" />


                         
                           


                                    
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


     <script>

         function exportToExcel() {

             var file = new Blob([$('#MainGradeDiv').html()], { type: "application/vnd.ms-excel" });
             var url = URL.createObjectURL(file);
             var a = $("<a />", {
                 href: url,
                 download: "Invoice Report.xls"
             }).appendTo("body").get(0).click();
             e.preventDefault();

         }

         function exportTableToExcel(tableID, filename) {
             var downloadLink;
             var dataType = 'application/vnd.ms-excel';
             var tableSelect = document.getElementById(tableID);
             var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

             // Specify file name
             filename = filename ? filename + '.xls' : 'excel_data.xls';

             // Create download link element
             downloadLink = document.createElement("a");

             document.body.appendChild(downloadLink);

             if (navigator.msSaveOrOpenBlob) {
                 var blob = new Blob(['\ufeff', tableHTML], {
                     type: dataType
                 });
                 navigator.msSaveOrOpenBlob(blob, filename);
             } else {
                 // Create a link to the file
                 downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

                 // Setting the file name
                 downloadLink.download = filename;

                 //triggering the function
                 downloadLink.click();
             }
         }
     </script>
     
</asp:Content>

