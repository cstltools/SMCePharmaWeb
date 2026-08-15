<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="WHStockAdjustmentView.aspx.cs" Inherits="SInventory_UI_WHStockAdjustmentView" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Stock Adjustment List </div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                         <a href="WHStockAdjustmentEntry.aspx" class="btn btn-sm btn-outline-info "><i class="fa fa-plus" aria-hidden="true"></i>New Entry</a>
                      
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
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
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
                          <div class="col-2">
                              </div>
                        <div class="col-6">
                                            
                                             
                            

                                              <div class="form-group row"  runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Transaction From Date :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                          <asp:TextBox ID="fromDateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice To Date"></asp:TextBox>
                                                 
                                                    
                                                         

                                                    </div>
                                                  
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> 	Transaction To Date :<span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="toDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice From Date" ></asp:TextBox>

                                                 



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

                                                      <asp:LinkButton  OnClick="viewRptButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
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
                                               
                                  <button type="button" class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" onclick="exportToExcel()"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>

                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

                                 <div class="table-responsive" id="MainGradeDiv" style="height:600px">

                                  <div >
                                                    <p> Stock Adjustment  Report List</p>
                                                </div>
                                      <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                             DataKeyNames="WHStockAdjId" 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                    
                                          <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TransactionNo" HeaderText="Transaction No" />
                                    <asp:BoundField DataField="TransactionDate" HeaderText="Transaction Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="AdjustmentType1" HeaderText="Adjustment Type" />
                                   <%-- <asp:BoundField DataField="StockEffect" HeaderText="StockEffect" />--%>
                                    <asp:BoundField DataField="WearhouseName" HeaderText="From Store" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    <asp:TemplateField HeaderText="Remove">
                                        <ItemTemplate>
                                          
                                             <asp:LinkButton ID="LinkButton1" runat="server" class="btn-danger  btn-sm mb-1 mb-md-0"
                                                                 CommandArgument="<%# Container.DataItemIndex %>"  CommandName="EditData"><i class='bx bxs-trash' aria-hidden='true'></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>

                                                 <asp:LinkButton ID="LinkButton12" runat="server" class="btn-success  btn-sm mb-1 mb-md-0"
                                                                 CommandArgument="<%# Container.DataItemIndex %>"  CommandName="reportData"><i class='bx bxs-report' aria-hidden='true'></i></asp:LinkButton>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView> 
                                            </div>

                    </ContentTemplate>
                     <Triggers>
                 
                  
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
                 download: "Stock Adjustment List.xls"
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

