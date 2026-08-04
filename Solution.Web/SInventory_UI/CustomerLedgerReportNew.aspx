<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="CustomerLedgerReportNew.aspx.cs" Inherits="SInventory_UI_CustomerLedgerReportNew" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
 
 
    
<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    
     <style type="text/css">
        .button-padding-right {
            margin-right: 5px;
        }  
          .SelectchkChoice label {
            padding-left: 4px;
            font-weight: bold;
        }
    </style>
    
      <style type="text/css">
      /*AutoComplete flyout */
      .autocomplete_completionListElement {
          margin: 0px !important;
          background-color: White !important;
          color: windowtext !important;
          border: buttonshadow !important;
          border-width: 1px !important;
          border-style: solid !important;
          cursor: 'default' !important;
          overflow: auto !important;
          font-family: Calibri !important;
          font-size: 12px !important;
          text-align: left !important;
          list-style-type: none !important;
          margin-left: 0px !important;
          padding-left: 0px !important;
          max-height: 200px !important;
          width: 300px !important;
          overflow: auto !important;
          box-shadow: 0 0 3px 1px rgba(0,0,0,.35) !important;
      }


      .autocomplete_completionListElement222 {
          margin: 0px !important;
          background-color: White !important;
          color: windowtext !important;
          border: buttonshadow !important;
          border-width: 1px !important;
          border-style: solid !important;
          cursor: 'default' !important;
          overflow: auto !important;
          font-family: Calibri !important;
          font-size: 12px !important;
          text-align: left !important;
          list-style-type: none !important;
          margin-left: 0px !important;
          padding-left: 0px !important;
          max-height: 200px !important;
          width: 600px !important;
          overflow: auto !important;
          box-shadow: 0 0 3px 1px rgba(0,0,0,.35) !important;
      }
      /* AutoComplete highlighted item */

      .autocomplete_highlightedListItem {
          background-color: #17A2B8 !important;
          color: white !important;
          padding: 6px !important;
          font-weight: bold !important;
      }

      /* AutoComplete item */

      .autocomplete_listItem {
          padding: 6px !important;
          cursor: pointer !important;
          font-weight: bold !important;
          background-color: #fff !important;
          border-bottom: 1px solid #d4d4d4 !important;
          box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset !important;
      }

      .ssss {
          font-size: 13px;
          font-weight: bold;
      }
  </style>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Customer Ledger Report </div>
                
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

                                           

                         <div class="col-8">
                              
                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Customer Code:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                 
                                                 
   <asp:TextBox ID="cCodeTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "
       AutoPostBack="True" OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>
   <asp:AutoCompleteExtender
       ID="at_txt_JobCirculation"
       TargetControlID="cCodeTextBox"
       runat="server"
       ServiceMethod="GetCustomer_ALL_ForDIC"
       ServicePath="SInventoryWebService.asmx"
       MinimumPrefixLength="1"
       CompletionInterval="10"
       EnableCaching="false"
       CompletionSetCount="1"
       FirstRowSelected="false" CompletionListCssClass="autocomplete_completionListElement"
       CompletionListItemCssClass="autocomplete_listItem"
       CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
       ShowOnlyCurrentWordInCompletionListItem="true">
   </asp:AutoCompleteExtender>
   <asp:HiddenField ID="hfCustomerId" runat="server" />



                                                </div>
                                               
                                            </div>
                             
                                         

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Invoice From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice From Date" ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Invoice To Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                   
                  <asp:TextBox ID="toDateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice To Date"></asp:TextBox>
                                                 



                                                </div>
                                              
                                            </div>
                             </div>

                         <%--<div class="col-8" runat="server" visible="false">
                                                <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                            </div>--%>
                         </div>

                                
                                            <br />
                    <div style="text-align: right; margin-bottom: 10px;">
    <button type="button" class="btn btn-sm btn-outline-info" onclick="exportToExcel()">  📊  Export to Excel </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printTable()"> 🖨️ Print </button>

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
                                        <asp:LinkButton  runat="server" ID="cancelButton"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>

                      
                                            <br />
                    <div class="row">
                         <asp:Literal ID="ltReportHtml" runat="server"></asp:Literal>
                    </div>

                 <style>
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
        }
        th, td {
            border: 1px solid black;
            padding: 5px;
        }
        th {
            font-weight: bold;
        }
        .header-yellow { background-color: yellow; } 
        .header-green { background-color: #88E788; } 
        .header-lightblue { background-color: lightblue; }
        .header-skyblue { background-color: deepskyblue; }
        .company-info {
            text-align: center;
            margin-bottom: 10px;
            font-family: Arial;
        }
    </style>

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
        function printTable() {
            var printContents = document.getElementById("dtTb").outerHTML;
            var summaryBox = document.getElementById("ledgerSummaryBox");
            var summaryContents = summaryBox ? "<div style='width:100%; display:flex; justify-content:flex-end; margin-top:12px;'>" + summaryBox.outerHTML + "</div>" : "";

            var printWindow = window.open('', '', 'height=600,width=1000');
            printWindow.document.write('<html><head><title>Customer Ledger Report</title>');
            printWindow.document.write('<style>');
            printWindow.document.write('@media print { @page { size: landscape; } table { width: 100%; border-collapse: collapse; } th, td { border: 1px solid #000; padding: 4px; text-align: left; } }');
            printWindow.document.write('</style></head><body>');
            printWindow.document.write('<h3 style="text-align:center;">Customer Ledger Report</h3>');
            printWindow.document.write(printContents);
            printWindow.document.write(summaryContents);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        }
</script>


    <!-- SheetJS CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script>
    function exportToExcel() {
        var table = document.getElementById("dtTb");
        var workbook = XLSX.utils.table_to_book(table, { sheet: "Sheet1" });

        var now = new Date();
        var day = ("0" + now.getDate()).slice(-2);
        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var month = monthNames[now.getMonth()];
        var year = now.getFullYear();

        var hour = ("0" + now.getHours()).slice(-2);
        var minute = ("0" + now.getMinutes()).slice(-2);
        var second = ("0" + now.getSeconds()).slice(-2);

        var dateTime = day + "-" + month + "-" + year + " " + hour + "-" + minute + "-" + second;
        var fileName = 'Customer Ledger Report ' + dateTime + '.xlsx';

        XLSX.writeFile(workbook, fileName);
    }
</script>



<%--     <script>



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
     --%>
</asp:Content>
