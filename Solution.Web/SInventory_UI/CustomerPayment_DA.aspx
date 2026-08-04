<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CustomerPayment_DA.aspx.cs" Inherits="SInventory_UI_CustomerPayment_DA" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <div id="popDiv">
            </div>

            <div class="page-wrapper">
                <div class="page-content">
                    <!--breadcrumb-->
                    <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                        <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Payment Collection </div>

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
                                                                    });

                                                                    $(document).off('input', '.ref-no-input').on('input', '.ref-no-input', function () {
                                                                        var appLogId = $(this).attr('data-app-log-id');
                                                                        var val = $(this).val();
                                                                        $('.ref-no-input[data-app-log-id="' + appLogId + '"]').not(this).val(val);
                                                                    });
                                                                }
                                                            </script>


                                                        </div>
                                                        <span class="text-sm-left text-c-red">*</span>
                                                    </div>



                                                    <asp:HiddenField runat="server" ID="hfCustPayId" />



                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Route:</label>

                                                        <div class="col-sm-5">


                                                            <asp:DropDownList ID="rootDropDownList" AutoPostBack="true" OnSelectedIndexChanged="rootDropDownList_SelectedIndexChanged" runat="server" CssClass="form-control form-control-sm mySelect2 ">
                                                            </asp:DropDownList>


                                                        </div>
                                                        <span class="text-sm-left text-c-red"></span>
                                                    </div>


                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Territory Name:</label>

                                                        <div class="col-sm-5">


                                                            <asp:DropDownList runat="server" class="form-select form-select-sm mb-3 mySelect2 " ID="ddlTerritoryName"></asp:DropDownList>


                                                        </div>
                                                        <span class="text-sm-left text-c-red"></span>
                                                    </div>



                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Sales Asistance:</label>

                                                        <div class="col-sm-5">


                                                            <asp:DropDownList runat="server" class="form-select form-select-sm mb-3 mySelect2 " ID="ddlDAName" AutoPostBack="true" OnSelectedIndexChanged="ddlDAName_SelectedIndexChanged"></asp:DropDownList>


                                                        </div>
                                                        <span class="text-sm-left text-c-red"></span>
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

                                                            <asp:LinkButton OnClick="submitButton_Click" runat="server" ID="submitButton" class="btn btnMyDesignSearch   btn-sm">
                 <i class="fa fa-search"></i> Search
                                                            </asp:LinkButton>
                                                            <asp:LinkButton runat="server" OnClick="cancelButton_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>


                                            <div class="row">

                                                <div class="form-group row" style="display: none">
                                                    <div class="col-4">
                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-4 col-form-label">Sales Center:</label>

                                                            <div class="col-sm-7">
                                                            </div>
                                                            <span class="text-sm-left text-c-red">*</span>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-4 col-form-label">Payment Type:</label>

                                                            <div class="col-sm-7">

                                                                <asp:DropDownList ID="payTypeDDL" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>


                                                            </div>
                                                            <span class="text-sm-left text-c-red">*</span>
                                                        </div>
                                                    </div>
                                                    <div class="col-4">

                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-4 col-form-label">Payment Date:</label>

                                                            <div class="col-sm-7">
                                                            </div>
                                                            <span class="text-sm-left text-c-red">*</span>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-4 col-form-label">Customer:</label>

                                                            <div class="col-sm-7">
                                                            </div>
                                                            <span class="text-sm-left text-c-red">*</span>
                                                        </div>



                                                    </div>
                                                    <div class="col-4">

                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-4 col-form-label">Reference No:</label>

                                                            <div class="col-sm-7">

                                                                <div class="input-group">
                                                                    <asp:TextBox ID="refNameTextBox" runat="server" CssClass="form-control form-control-sm "></asp:TextBox>
                                                                    <asp:TextBox ID="refDtTextBox" Visible="False" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                                    <asp:CalendarExtender ID="paymentDtTextBox_CalendarExtender0" runat="server"
                                                                        Format="dd-MMM-yyyy" PopupButtonID="ImageButton0"
                                                                        TargetControlID="refDtTextBox">
                                                                    </asp:CalendarExtender>
                                                                    <asp:ImageButton Visible="False" ID="ImageButton0" runat="server"
                                                                        AlternateText="Click to show calendar"
                                                                        ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />

                                                                </div>


                                                            </div>
                                                            <span class="text-sm-left text-c-red">*</span>
                                                        </div>


                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-4 col-form-label">Payment Amount:</label>

                                                            <div class="col-sm-7">
                                                            </div>
                                                            <span class="text-sm-left text-c-red">*</span>
                                                        </div>

                                                    </div>
                                                </div>


                                                <div runat="server" visible="False">


                                                    <div class="col-2">&nbsp;</div>
                                                    <div class="col-8">



                                                        <div class="form-group row">
                                                            <label for="txtNID" class="col-sm-3 col-form-label">Sales Center:</label>

                                                            <div class="col-sm-7">
                                                                <div class="input-group">
                                                                </div>

                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-3 col-form-label">Market: </label>

                                                            <div class="col-sm-7">
                                                                <div class="input-group">
                                                                    <asp:DropDownList ID="marketDropDownList" runat="server" AutoPostBack="True"
                                                                        CssClass="form-control form-control-sm "
                                                                        OnSelectedIndexChanged="marketDropDownList_SelectedIndexChanged">
                                                                    </asp:DropDownList>

                                                                </div>

                                                            </div>
                                                        </div>




                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-3 col-form-label">Customer: </label>

                                                            <div class="col-sm-7">
                                                                <div class="input-group">

                                                                    <asp:DropDownList ID="customerDropDownList" Visible="False" runat="server" AutoPostBack="True" CssClass="DropDown" OnSelectedIndexChanged="customerDropDownList_SelectedIndexChanged"></asp:DropDownList>
                                                                </div>

                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-3 col-form-label">Payment Date: </label>

                                                            <div class="col-sm-7">
                                                                <div class="input-group">
                                                                </div>

                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-3 col-form-label">Payment Amount: </label>

                                                            <div class="col-sm-7">
                                                                <div class="input-group">
                                                                </div>

                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-3 col-form-label">Payment Type: </label>

                                                            <div class="col-sm-7">
                                                                <div class="input-group">
                                                                </div>

                                                            </div>
                                                        </div>


                                                        <div class="form-group row">
                                                            <label for="mainName" class="col-sm-3 col-form-label">Reference No: </label>

                                                            <div class="col-sm-7">
                                                            </div>
                                                        </div>




                                                        <br />



                                                    </div>

                                                </div>

                                                <br />

                                                <div class="row mt-2 mb-2">
                                                    <div class="col-4">
                                                        <h5><i class="fa fa-list" aria-hidden="true"></i>Due Invoice List </h5>
                                                    </div>
                                                    <div class="col-5 text-end">
                                                        <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success" OnClick="btnExportToExcel_Click"><i class="fa fa-file-excel-o"></i> Export to Excel</asp:LinkButton>
                                                    </div>
                                                    <div class="col-3">
                                                        <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info" Text="Total Pay Amount : 0"></asp:Label>
                                                    </div>
                                                </div>


                                            </div>

                                            <!-- Selected Items Grid (Shown only when rows are checked) -->
                                            <div id="selectedGridContainer" runat="server" visible="false" class="mb-4">
                                                <h6>Selected Items (Selected to Approve)</h6>
                                                <div class="table-responsive" style="max-height: 400px">
                                                    <asp:GridView ID="selectedGridView" runat="server" AutoGenerateColumns="False"
                                                        DataKeyNames="PaymentCollectionAppLogId" CssClass="table table-bordered text-center thead-dark loading-summary-grid">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="SL#">
                                                                <ItemTemplate>
                                                                    <%#Container.DataItemIndex+1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                                            <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                            <asp:BoundField DataField="TerritoryName_Ord" HeaderText="Territory Name" />
                                                            <asp:BoundField DataField="DistributionRoute_Ord" HeaderText="Route Name" />
                                                            <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                                            <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                            <asp:TemplateField HeaderText="Confirm Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblTotalDeliverySelected" Text='<%#Eval("TotalDelivery")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="PaymentCollectedBy" HeaderText="Payment Collected By" />
                                                            <asp:BoundField DataField="CollectedDate" HeaderText="Collected Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                            <asp:BoundField DataField="BankName" HeaderText="Bank Name" />
                                                            <asp:TemplateField HeaderText="Previous Pay">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblPaymentAmountSelected" Text='<%#Eval("PaymentAmount")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Due Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblDueSelected" Text='<%#Eval("Due")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Pay Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="payAmountLabelSelected" runat="server" Text='<%#Eval("PayableAmount_DA")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Reference No">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="referenceNoTextBoxSelected" runat="server" CssClass="form-control ref-no-input" data-app-log-id='<%#Eval("PaymentCollectionAppLogId")%>' Text='<%#Eval("ReferenceNo")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Action">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn btn-sm btn-danger" Text="Remove" OnClick="btnRemove_Click" CommandArgument='<%# Eval("PaymentCollectionAppLogId") %>'>
                                                                             <i class="fa fa-trash"></i> Remove
                                                                    </asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Attachment">
                                                                <ItemTemplate>
                                                                    <a href="#" onclick='<%# String.Format("showImagePreview(\"{0}\"); return false;", Eval("ImageLinkshow")) %>'>
                                                                        <img src='<%# Eval("ImageLinkshow") %>' style="height: 50px; width: 50px; object-fit: cover; border: 1px solid #ccc; border-radius: 4px;" alt="Attachment" />
                                                                    </a>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                                <div class="row mt-2 mb-3">
                                                    <div class="col-12 text-end">
                                                        <asp:LinkButton OnClick="saveButton_Click" runat="server" ID="masterButton" OnClientClick="return sweetAlertConfirm_Submit(this);" class="btn btn-success">  <i class="fa fa-check"></i> ALL Approve</asp:LinkButton>
                                                        <asp:LinkButton OnClick="rejectButton_Click" runat="server" ID="rejectButton" OnClientClick="return confirm('Are you sure you want to reject the selected invoices?');" class="btn btn-danger" style="margin-left: 10px;">  <i class="fa fa-times"></i> ALL Reject</asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row" style="margin-top: 10px;">
                                                <div class="table-responsive" id="MainGradeDiv">
                                                         <asp:GridView ID="orderGridView" runat="server"
                                                        AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" DataKeyNames="InvoiceId,DAId,PaymentCollectionAppLogId">
                                                        <Columns>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True"
                                                                        OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("CustomerMasterId")%>' />
                                                                    <asp:HiddenField runat="server" ID="hfMarketId" Value='<%#Eval("MarketId")%>' />
                                                                    <asp:HiddenField runat="server" ID="hfDistributionRouteId" Value='<%#Eval("DistributionRouteId")%>' />
                                                                    <asp:HiddenField runat="server" ID="hfInvoiceId" Value='<%#Eval("InvoiceId")%>' />
                                                                    <asp:HiddenField runat="server" ID="hfPaymentCollectionAppLogId" Value='<%#Eval("PaymentCollectionAppLogId")%>' />
                                                                    <asp:HiddenField runat="server" ID="hfBankId" Value='<%#Eval("BankId")%>' />


                                                                    <asp:HiddenField runat="server" ID="hfTP_Pay" Value='<%#Eval("TP_Pay")%>' />
                                                                    <asp:HiddenField runat="server" ID="hfVat_Pay" Value='<%#Eval("Vat_Pay")%>' />


                                                                    <asp:CheckBox OnCheckedChanged="chkSelect_CheckedChanged" ID="chkSelect" AutoPostBack="True" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                                            <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                            <asp:BoundField DataField="TerritoryName_Ord" HeaderText="Territory Name" />
                                                            <asp:BoundField DataField="DistributionRoute_Ord" HeaderText="Route Name" />


                                                            <%--       <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
   <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" DataFormatString="{0:dd-MMM-yyyy}" />--%>
                                                            <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                                            <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                            <%--    <asp:BoundField DataField="RtnInvoiceNo" HeaderText="Confirm Invoice No" />
                                                                <asp:BoundField DataField="RtnInvoiceDate" HeaderText="Confirm Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                            --%>


                                                            <asp:TemplateField HeaderText="Confirm  Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblTotalDelivery" Text='<%#Eval("TotalDelivery")%>' />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:BoundField DataField="PaymentCollectedBy" HeaderText="Payment Collected By" />
                                                            <asp:BoundField DataField="CollectedDate" HeaderText="Collected Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                            <asp:BoundField DataField="BankName" HeaderText="Bank Name" />
                                                            <asp:TemplateField HeaderText="Previous Pay">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblPaymentAmount" Text='<%#Eval("PaymentAmount")%>' />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>


                                                            <asp:TemplateField HeaderText="Due Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblDue" Text='<%#Eval("Due")%>' />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>



                                                            <asp:TemplateField HeaderText="Pay Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="payAmountLabel" runat="server" Text='<%#Eval("PayableAmount_DA")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Reference No">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="referenceNoTextBox" runat="server" CssClass="form-control ref-no-input" data-app-log-id='<%#Eval("PaymentCollectionAppLogId")%>' Text='<%#Eval("ReferenceNo")%>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Attachment">
                                                                <ItemTemplate>
                                                                    <a href="#" onclick='<%# String.Format("showImagePreview(\"{0}\"); return false;", Eval("ImageLinkshow")) %>'>
                                                                        <img src='<%# Eval("ImageLinkshow") %>' style="height: 50px; width: 50px; object-fit: cover; border: 1px solid #ccc; border-radius: 4px;" alt="Attachment" />
                                                                    </a>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Collection By" Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:DropDownList ID="ddlCollectionBy" runat="server">
                                                                        <asp:ListItem Selected="True" Text="MIO" Value="MIO"></asp:ListItem>
                                                                        <asp:ListItem Text="DIC" Value="DIC"></asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>


                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkAdjust" OnCheckedChanged="chkAdjust_OnCheckedChanged" AutoPostBack="True" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField Visible="false" DataField="AdjustableAmount" HeaderText="AdjustableAmount" />
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </div>

                                            <br />
                                            </div>

                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Bootstrap Modal -->



        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="modal fade" id="moneyModal" tabindex="-1" aria-labelledby="moneyModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="moneyModalLabel">Print Confirmation</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <h1>Payment saved successfully.</h1>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnMoneyReceiptPrint" runat="server" CssClass="btn btn-primary"
                                Text="Money Receipt Print" OnClientClick="$('#moneyModal').modal('hide'); $('.modal-backdrop').remove(); var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open('../SInventory_RPTVIEW/MoneyReceiptViewerForAfterPayment.aspx', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no,scrollbars=yes,menubar=no,location=no,top='+Mtop+', left='+Mleft);" OnClick="btnMoneyReceiptPrint_Click" />
                            <asp:Button ID="btnSavePayment" runat="server" CssClass="btn btn-secondary"
                                Text="Close" OnClientClick="$('#moneyModal').modal('hide'); $('.modal-backdrop').remove();" OnClick="btnSavePayment_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-labelledby="imagePreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="imagePreviewModalLabel">Attachment Preview</h5>
                    <button type="button" class="close" data-dismiss="modal" onclick="$('#imagePreviewModal').modal('hide');" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body text-center">
                    <img id="previewImage" src="" alt="Preview" class="img-fluid" style="width: 100%; height: auto;" />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="$('#imagePreviewModal').modal('hide');">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function showImagePreview(imageUrl) {
            document.getElementById('previewImage').src = imageUrl;
            $('#imagePreviewModal').modal('show');
        }
    </script>
</asp:Content>

