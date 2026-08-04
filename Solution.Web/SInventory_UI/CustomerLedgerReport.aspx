<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="CustomerLedgerReport.aspx.cs" Inherits="SInventory_UI_CustomerLedgerReport" %>

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
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server" ID="cancelButton"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
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

 
 