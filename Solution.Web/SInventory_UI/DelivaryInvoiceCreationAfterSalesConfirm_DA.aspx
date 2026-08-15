<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx.cs" Inherits="SInventory_UI_DelivaryInvoiceCreationAfterSalesConfirm_DA" %>

<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
            font-size: 14px !important;
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
            font-size: 14px !important;
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
        .badge-status {
            display: inline-block;
            padding: 5px 12px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 4px;
            text-align: center;
        }
        .badge-status-full {
            background-color: #198754 !important;
            color: #ffffff !important;
        }
        .badge-status-partial {
            background-color: #ffc107 !important;
            color: #212529 !important;
        }
        .badge-status-reject {
            background-color: #dc3545 !important;
            color: #ffffff !important;
        }
        .badge-status-default {
            background-color: #6c757d !important;
            color: #ffffff !important;
        }
    </style>



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->

            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Sales Return</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton Visible="false" ID="EmpCetegoryAddImageButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-pencil" aria-hidden="true"></i> Update Old Data </asp:LinkButton>
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


                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Sales Center:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                                        AutoPostBack="True" OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>

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


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                            <div id="Div1" class="form-group row" runat="server" visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label">Manufacture:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                                        OnSelectedIndexChanged="manufacDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>



                                            <div id="Div2" class="form-group row" runat="server" visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label">Market:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="marketDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" OnSelectedIndexChanged="marketDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                            <div id="Div3" class="form-group row" runat="server" visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label">Market:</label>

                                                <div class="col-sm-5">


                                                    <asp:TextBox ID="dd" runat="server" CssClass="datepicker form-control form-control-sm mb-3 "></asp:TextBox>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Route:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="rootDropDownList" runat="server" CssClass="form-control form-control-sm mySelect2 "
                                                       >
                                                    </asp:DropDownList>

                                                     <%--AutoPostBack="True" OnSelectedIndexChanged="rootDropDownList_SelectedIndexChanged"--%>
                                                </div>
                                            </div>


                                                                                                                                    <div class="form-group row" style="display:none">
    <label for="mainName" class="col-sm-3 col-form-label"> Territory Name:</label>

    <div class="col-sm-5">


         <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 " id="ddlTerritoryName" ></asp:DropDownList>


    </div>
    <span class="text-sm-left text-c-red">*</span>
</div>

                                            <div class="form-group row"  runat="server" visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label">Invoice No:</label>

                                                <div class="col-sm-5">

                                                    <asp:TextBox ID="invoicenoTextBox" runat="server" CssClass="form-control form-control-sm"
                                                        ToolTip="true"></asp:TextBox>
                                                    <ajaxToolkit:AutoCompleteExtender ID="invoicenoTextBox_AutoCompleteExtender" runat="server"
                                                        DelimiterCharacters="" EnableCaching="true"
                                                        Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                        ServiceMethod="GetAllInvoice" ServicePath="SInventoryWebService.asmx" TargetControlID="invoicenoTextBox"
                                                        UseContextKey="True"
                                                        CompletionListCssClass="autocomplete_completionListElement"
                                                        CompletionListItemCssClass="autocomplete_listItem"
                                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                                    </ajaxToolkit:AutoCompleteExtender>



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

                                                    <asp:LinkButton OnClick="Button1_Click" runat="server" ID="submitButton" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-search"></i> Search
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" OnClick="cancelButton_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                                                    <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info" Text="Total Net Amount : 0"></asp:Label>

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>


                                    <br />
                                    <div class="row">
                                        <div class="col-md-2" style="margin-top: 5px;">
                                        </div>
                                    </div>

                                    <br />
                                    <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv" style="max-height: 600px">


                                            <asp:GridView ID="orderGridView" runat="server" AutoGenerateColumns="False"
                                                DataKeyNames="ComUnitId,ManufacId,OrderId,InvoiceId,MarketId,CustomerMasterId,SalesReturnAppLogId" ShowFooter="true" CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender">
                                                <Columns>

                                                    <asp:TemplateField HeaderText="SL#">
                                                        <ItemTemplate>
                                                            <%#Container.DataItemIndex+1 %>
                                                            <asp:HiddenField runat="server" ID="hfIsAdjustInvoice" Value='<%#Eval("IsAdjustInvoice")%>' />
                                                            <asp:HiddenField runat="server" ID="hfInvoiceNo" Value='<%#Eval("InvoiceNo")%>' />
                                                            <asp:HiddenField runat="server" ID="hfSalesReturnAppLogId" Value='<%#Eval("SalesReturnAppLogId")%>' />
                                                             <asp:HiddenField runat="server" ID="hfchkStatus" Value='<%#Eval("chkStatus")%>' />

                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkSelect" CssClass="form-control-sm" AutoPostBack="true" OnCheckedChanged="chkSelect_CheckedChanged" runat="server" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />


                                                    <asp:BoundField DataField="SubmissionDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" />



                                                    <asp:TemplateField HeaderText="Net Amount">
                                                        <ItemTemplate>
                                                            <asp:Label   runat="server" ID="lblTpGrandTotal" Text='<%#Eval("TpGrandTotal")%>' />

                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Status">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDASalesReturnType" runat="server" CssClass='<%# GetStatusBadgeCss(Eval("DA_SalesReturnType")) %>' Text='<%#Eval("DA_SalesReturnType")%>'></asp:Label>
                                                            <asp:HiddenField ID="hfDASalesReturnType" runat="server" Value='<%#Eval("DA_SalesReturnType")%>' />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
      
                                                    <asp:TemplateField HeaderText="Submit" >
                                                        <ItemTemplate>
                                                            <contenttemplate>
                                                                <asp:DropDownList ID="reasonReturnDropDownList" Visible="False" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                                    <asp:ListItem Value="1">Cash Short</asp:ListItem>
                                                                    <asp:ListItem Value="2">No Order</asp:ListItem>
                                                                    <asp:ListItem Value="3">Wrong Order</asp:ListItem>
                                                                    <asp:ListItem Value="4">Damaged  Broken</asp:ListItem>
                                                                    <asp:ListItem Value="5">Quality Issue</asp:ListItem>
                                                                    <asp:ListItem Value="11">Shop Closed</asp:ListItem>
                                                                    <asp:ListItem Value="6">Order Cancelled</asp:ListItem>
                                                                    <asp:ListItem Value="7">Slow Moving</asp:ListItem>
                                                                    <asp:ListItem Value="8">Price Error</asp:ListItem>
                                                                    <asp:ListItem Value="9">Return Others</asp:ListItem>
                                                                    <asp:ListItem Value="10">Date Expired</asp:ListItem>


                                                                      <asp:ListItem Value="11">Partial return-cash short</asp:ListItem>
                                                                      <asp:ListItem Value="12">Partial return-Excess order</asp:ListItem>

                                                                      <asp:ListItem Value="13">Double order</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </contenttemplate>

                                                                <asp:LinkButton ID="gotoinvoiceButton"  runat="server" CssClass="btn btn-sm btn-info"   OnClick="gotoinvoiceButton_Click" Visible="true" OnClientClick="return sweetAlertConfirm_Submit(this);" 
                                                                    >
                                                                    Go to Approve <i class="fa fa-arrow-right" aria-hidden="true"></i></asp:LinkButton>
                                                                <asp:LinkButton ID="btnReturnSummaryNote" runat="server" CssClass="btn btn-sm btn-warning" OnClick="btnReturnSummaryNote_Click" CommandArgument='<%#Eval("InvoiceId")%>' ToolTip="Print Return Note">
                                                                    <i class="fa fa-print"></i> Note
                                                                </asp:LinkButton>
                                                            </contenttemplate>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>

<!-- Return Summary Note Modal -->
<div class="modal fade" id="returnSummaryModal" tabindex="-1" role="dialog" aria-labelledby="returnSummaryModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document" style="max-width: 220mm;">
        <div class="modal-content" style="background-color: #ffffff;">
            <div class="modal-header bg-light text-dark" style="background-color: #ffffff !important; border-bottom: 1px solid #dee2e6;">
                <h5 class="modal-title text-dark" id="returnSummaryModalLabel" style="color: #333 !important; font-weight: 600;">Return Summary Note</h5>
                <button type="button" class="close text-dark" data-dismiss="modal" aria-label="Close" onclick="$('#returnSummaryModal').modal('hide');" style="color: #000 !important; opacity: 0.8;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" style="background-color: #f8f9fa; display: flex; justify-content: center; padding: 20px;">
                <asp:UpdatePanel ID="upReturnSummary" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hfReturnInvoiceId" runat="server" />
                        <asp:HiddenField ID="hfReturnStatus" runat="server" />
                        <div id="returnSummaryPrintArea" style="background:#fff; width:210mm; max-width:100%; min-height:297mm; padding:15mm; box-sizing:border-box; box-shadow: 0 0 10px rgba(0,0,0,0.1); margin:0 auto;">
                            <!-- A4 Print Area -->
                            <div style="width:100%; font-family:'Arial',sans-serif; font-size:11pt; background:#fff; box-sizing:border-box;">
                                <div style="text-align:center; border-bottom:2px solid #333; padding-bottom:8px; margin-bottom:12px;">
                                    <h3 style="margin:0; font-size:15pt;">Return Summary Note</h3>
                                    <asp:Label ID="lblReturnNoteType" runat="server" style="font-size:11pt; font-weight:600; color:#c00;"></asp:Label>
                                </div>
                                <!-- Customer & Invoice Info -->
                                <table style="width:100%; margin-bottom:12px; border-collapse:collapse; font-size:10pt;">
                                    <tr>
                                        <td style="width:50%; vertical-align:top;">
                                            <strong>Customer:</strong> <asp:Label ID="lblRtnCustomerName" runat="server"></asp:Label><br />
                                            <strong>Customer Code:</strong> <asp:Label ID="lblRtnCustomerCode" runat="server"></asp:Label><br />
                                            <strong>Address:</strong> <asp:Label ID="lblRtnAddress" runat="server"></asp:Label><br />
                                            <strong>Market:</strong> <asp:Label ID="lblRtnMarket" runat="server"></asp:Label>
                                        </td>
                                        <td style="width:50%; vertical-align:top; text-align:right;">
                                            <strong>Invoice No:</strong> <asp:Label ID="lblRtnInvoiceNo" runat="server"></asp:Label><br />
                                            <strong>Invoice Date:</strong> <asp:Label ID="lblRtnInvoiceDate" runat="server"></asp:Label><br />
                                            <strong>DA Name:</strong> <asp:Label ID="lblRtnDaName" runat="server"></asp:Label><br />
                                            <strong>Confirm Date:</strong> <asp:Label ID="lblRtnConfirmDate" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                                <!-- Product Table -->
                                <asp:GridView ID="gvReturnSummary" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-bordered" Width="100%"
                                    style="font-size:9.5pt; border-collapse:collapse; table-layout:fixed; width:100%; word-break:break-word;">
                                    <Columns>
                                        <asp:TemplateField HeaderText="SL#">
                                            <HeaderStyle Width="6%" HorizontalAlign="Center" />
                                            <ItemStyle Width="6%" HorizontalAlign="Center" />
                                            <ItemTemplate><%# Container.DataItemIndex+1 %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ProductCode" HeaderText="Product Code">
                                            <HeaderStyle Width="14%" />
                                            <ItemStyle Width="14%" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ProductName" HeaderText="Product Name">
                                            <HeaderStyle Width="28%" />
                                            <ItemStyle Width="28%" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="TotalQty" HeaderText="Total Qty">
                                            <HeaderStyle Width="9%" HorizontalAlign="Center" />
                                            <ItemStyle Width="9%" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty">
                                            <HeaderStyle Width="9%" HorizontalAlign="Center" />
                                            <ItemStyle Width="9%" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price">
                                            <HeaderStyle Width="11%" HorizontalAlign="Right" />
                                            <ItemStyle Width="11%" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ReturnAmount" HeaderText="Return Amount">
                                            <HeaderStyle Width="11%" HorizontalAlign="Right" />
                                            <ItemStyle Width="11%" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Reason" HeaderText="Reason">
                                            <HeaderStyle Width="12%" />
                                            <ItemStyle Width="12%" />
                                        </asp:BoundField>
                                    </Columns>
                                    <HeaderStyle BackColor="#343a40" ForeColor="White" />
                                </asp:GridView>
                                <!-- Summary Footer -->
                                <table style="width:100%; margin-top:15px; font-size:10pt;">
                                    <tr>
                                        <td style="text-align:right; padding-right:10px;"><strong>Total Return Amount:</strong></td>
                                        <td style="width:130px; text-align:right;"><asp:Label ID="lblRtnTotalAmount" runat="server" style="font-weight:bold;"></asp:Label></td>
                                    </tr>
                                </table>
                                <!-- Signatures -->
                                <div style="margin-top:40px;">
                                    <table style="width:100%; font-size:10pt;">
                                        <tr>
                                            <td style="text-align:center; border-top:1px solid #333; width:33%; padding-top:5px;">DA Signature</td>
                                            <td style="text-align:center; border-top:1px solid #333; width:33%; padding-top:5px;">Prepared By</td>
                                            <td style="text-align:center; border-top:1px solid #333; width:33%; padding-top:5px;">Authorized By</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="printReturnSummary();"><i class="fa fa-print"></i> Print</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="$('#returnSummaryModal').modal('hide');">Close</button>
            </div>
        </div>
    </div>
</div>

<style>
    @media print {
        body * { visibility: hidden; }
        #returnSummaryPrintArea, #returnSummaryPrintArea * { visibility: visible; }
        #returnSummaryPrintArea {
            position: absolute; left: 0; top: 0;
            width: 210mm; min-height: 297mm;
        }
        @page { size: A4; margin: 0; }
    }
</style>

<script type="text/javascript">
    function printReturnSummary() {
        var printContent = document.getElementById('returnSummaryPrintArea').innerHTML;
        var printWindow = window.open('', '_blank', 'width=900,height=700');
        printWindow.document.open();
        printWindow.document.write(
            '<!DOCTYPE html>' +
            '<html><head>' +
            '<title>Return Summary Note</title>' +
            '<style>' +
            '  body { margin: 0; padding: 0; font-family: Arial, sans-serif; font-size: 11pt; }' +
            '  table { border-collapse: collapse; width: 100%; }' +
            '  th { background-color: #343a40 !important; color: #fff !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; padding: 6px 8px; border: 1px solid #dee2e6; font-size: 10pt; }' +
            '  td { padding: 5px 8px; border: 1px solid #dee2e6; font-size: 10pt; }' +
            '  .table-bordered th, .table-bordered td { border: 1px solid #dee2e6; }' +
            '  @page { size: A4; margin: 10mm; }' +
            '</style>' +
            '</head><body>' +
            printContent +
            '<script>window.onload = function(){ window.print(); window.close(); };<\/script>' +
            '</body></html>'
        );
        printWindow.document.close();
    }

    function showReturnSummaryModal() {
        $('#returnSummaryModal').modal('show');
    }
</script>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">




                                                    <asp:LinkButton OnClick="btnFinalSubmit_Click" runat="server" ID="btnFinalSubmit" class="btn btn-success" OnClientClick="return sweetAlertConfirm_Submit(this);" Visible="false" >
                                                        <i class="fa fa-check"></i> ALL Submit
                                                    </asp:LinkButton>
                                                    <asp:LinkButton OnClick="btnReject_Click" runat="server" ID="btnReject" class="btn btn-danger" style="margin-left: 10px;" OnClientClick="return confirm('Are you sure you want to reject the selected invoices?');" >
                                                        <i class="fa fa-times"></i> ALL Reject
                                                    </asp:LinkButton>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>


                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="False">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">Delivery Invoice Creation
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight">Sales Center
                        </td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight">Manufacture
                        </td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight">Market
                        </td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft">
                            <asp:Button ID="Button1" runat="server" Text="Search" OnClick="Button1_Click" />
                            <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0"
                                DynamicLayout="true">
                                <ProgressTemplate>
                                    <div class="divWaiting">
                                        <asp:Image ID="imgWait" runat="server" ImageAlign="Middle" ImageUrl="~/Images/loading-icon-big.gif"
                                            Height="100%" Width="100%" />
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td class="TDLeft" colspan="6"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight">&nbsp;
                        </td>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight">&nbsp;
                        </td>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight">&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight">&nbsp;
                        </td>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight">&nbsp;
                        </td>
                        <td width="13%" class="TDLeft">&nbsp;
                        </td>
                        <td width="20%" class="TDRight">&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
