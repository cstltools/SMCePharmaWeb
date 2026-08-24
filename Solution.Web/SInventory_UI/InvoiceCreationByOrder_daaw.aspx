<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="InvoiceCreationByOrder_daaw.aspx.cs" Inherits="SInventory_UI_InvoiceCreationByOrder_daaw" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style>
        #flex-container {
  display: flex !important;
  flex-direction: row  !important;
  width: 100% !important;
}

#flex-container > .flex-item {
  flex: auto  !important;
}

#flex-container > .raw-item {
  width: 8rem  !important;
}
.btn[disabled] {
    color: #6c757d !important;
    pointer-events: none;
    cursor: default;
    text-decoration: none;
    background-color: transparent;
    border: none;
}
.due-nodue {
    color: green !important;
    font-size: 16px;
    text-decoration: underline;
    cursor: pointer;
    border: none;
    background: none;
}

.due-active {
    color: red !important;
    font-size: 18px;
    text-decoration: underline;
}

.invoice-mode-list {
    display: flex;
    gap: 10px;
    align-items: center;
}

.invoice-mode-list input {
    margin-right: 6px;
}

.invoice-mode-list label {
    border: 1px solid #ced4da;
    border-radius: 4px;
    padding: 6px 14px;
    margin-right: 8px;
    background: #fff;
    font-size: 13px;
    cursor: pointer;
}


    </style>


    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Invoice Creation</div>
                
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
                                                  $('.datepicker').pickadate({
                                                      selectMonths: true,
                                                      selectYears: true,
                                                      format: 'd mmmm, yyyy'
                                                  })
                                                  $('.mySelect2').select2({
                                                      theme: 'bootstrap4',
                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                      placeholder: $(this).data('placeholder'),
                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                  });
                                                                  }

                                                                  var dateNow = new Date();
                                                                  $('.datepickess').datepicker("setDate", dateNow);
                                                                  minDate: new Date() // to disable privious dates 
                      </script>
 
                                    
                                    
                                    
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Sales Center:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="salesCenterDropDownList" runat="server"
                                                        CssClass="form-control form-control-sm mySelect2" AutoPostBack="True"
                                                        OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>

                                                    
                                                </div>
                                                 <span class="text-sm-left text-c-red">*</span>
                                             </div>
                                             

                                             <div id="invoiceCreationModeRow" runat="server" class="form-group row">
                                                 <label for="mainName" class="col-sm-3 col-form-label"> </label>
                                                 <div class="col-sm-5">
                                                     <asp:RadioButtonList ID="invoiceCreationModeRadioButtonList" runat="server"
                                                         AutoPostBack="True"
                                                         CssClass="invoice-mode-list"
                                                         RepeatDirection="Horizontal"
                                                         RepeatLayout="Flow"
                                                         OnSelectedIndexChanged="invoiceCreationModeRadioButtonList_SelectedIndexChanged">
                                                         <asp:ListItem Value="RouteWise" Selected="True">Route Wise</asp:ListItem>
                                                         <asp:ListItem Value="TerritoryWise">Territory Wise</asp:ListItem>
                                                     </asp:RadioButtonList>
                                                 </div>
                                             </div>

                                             <div id="routeDateRow" class="form-group row" runat="server" Visible="False">
                                                 <label for="mainName" class="col-sm-3 col-form-label">Route Date:</label>
                                                 <div class="col-sm-5">
                                                     <asp:TextBox ID="routeDateTextBox" runat="server"
                                                         CssClass="form-control form-control-sm mb-3 datepicker"
                                                         AutoPostBack="True"
                                                         OnTextChanged="routeDateTextBox_TextChanged"
                                                         autocomplete="off"
                                                         placeholder="Select Route Date"></asp:TextBox>
                                                 </div>
                                                 <span class="text-sm-left text-c-red">*</span>
                                             </div>

                                             <div id="salesAssistantRow" class="form-group row" runat="server" Visible="False">
                                                 <label for="mainName" class="col-sm-3 col-form-label">Sales Assistant Name:</label>
                                                 <div class="col-sm-5">
                                                     <asp:DropDownList runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" ID="ddlSalesAssistantName"></asp:DropDownList>
                                                 </div>
                                                 <span class="text-sm-left text-c-red">*</span>
                                             </div>

                                             <div id="routeRow" class="form-group row" runat="server">
                                                 <label for="mainName" class="col-sm-3 col-form-label">Route:</label>

                                                 <div class="col-sm-5">


                                                    <asp:DropDownList ID="rootDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2   "
                                                                      AutoPostBack="True"
                                                                      OnSelectedIndexChanged="rootDropDownList_OnSelectedIndexChanged">
                                                    </asp:DropDownList>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                             
                                                <div id="territoryRow" class="form-group row" runat="server">
       <label for="mainName" class="col-sm-3 col-form-label"> Territory Name:</label>

       <div class="col-sm-5">


            <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 " id="ddlTerritoryName" ></asp:DropDownList>


       </div>
       <span class="text-sm-left text-c-red">*</span>
    </div>
             

                                               <div id="daNameRow" class="form-group row" runat="server">
       <label for="mainName" class="col-sm-3 col-form-label"> DA Name:</label>

       <div class="col-sm-5">


            <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 " id="ddlDAName" ></asp:DropDownList>


       </div>
       <span class="text-sm-left text-c-red">*</span>
   </div>
            

                                            <div id="Div1" class="form-group row" runat="server" Visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label">Manufacture:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2 "
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="manufacDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                            <div id="Div2" class="form-group row" runat="server" Visible="False">
                                                <label for="mainName" class="col-sm-3 col-form-label">Market:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="marketDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2  "
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="marketDropDownList_SelectedIndexChanged">
                                                    </asp:DropDownList>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
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

                                                            <asp:LinkButton  OnClick="Button1_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search"></i> Search
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                                    <br />
                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-1">&nbsp;</div>
                                        <div class="col-2">&nbsp;</div>

                                           <div class="col-5">
                                                     <asp:LinkButton ID="reportButton" class="btn btn-sm   mb-2  pull-right" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="viewRptButton_Click"
                                                ><i class="fa fa-print" aria-hidden="true"></i>&nbsp; Print Report </asp:LinkButton>

                                                     <asp:LinkButton ID="btnTopsheetAndPickingslip" class="btn btn-sm   mb-2  pull-right mr-2" style="background-color: #1A7343; color: #fff; margin-right: 5px;" runat="server" OnClick="btnTopsheetAndPickingslip_Click"
                                                ><i class="fa fa-print" aria-hidden="true"></i>&nbsp; Topsheet & Store Picking </asp:LinkButton>
                                              </div>
                                        <div id="replacementSalesAssistantRow" runat="server" class="col-2" visible="false">
                                                <div class="form-group row">
                                                    <label class="col-form-label">Replacement SA (Sick/Leave):</label>
                                                    <asp:DropDownList runat="server" ID="ddlReplacementSalesAssistant"
                                                        CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                </div>
                                        </div>

                                        <div class="col-2">

                                                <div class="form-group row">

                                                             <asp:TextBox runat="server" ID="batchno" placeholder=" Batch NO" CssClass="form-control form-control-sm mb-3"></asp:TextBox>

                                                    </div>
                                              <div class="form-group row">

                                                  </div>


                                        </div>
                                          
                                      
                                       
                                    </div>
                                    <div class="row">
                                        <div id="flex-container">
                                            <div class="flex-item" id="flex">&nbsp;</div>
                                            <div class="raw-item" id="raw">
                                              
                                             
                                            </div>
                                        </div>
                                    </div>
                                     <div class="row">
                                         <!-- Selected Items Grid (Shown only when rows are checked) -->
                                         <div id="selectedGridContainer" runat="server" visible="false" class="mb-4">
                                             <h6>Selected Items (Selected to Approve)</h6>
                                             <div class="table-responsive" style="max-height: 400px">
                                                 <asp:GridView ID="selectedGridView" runat="server" AutoGenerateColumns="False"
                                                     DataKeyNames="ComUnitId,ManufacId,OrderId" CssClass="table table-bordered text-center thead-dark loading-summary-grid"
                                                     ShowFooter="True" OnRowDataBound="selectedGridView_RowDataBound">
                                                     <Columns>
                                                         <asp:TemplateField HeaderText="Sl. #">
                                                             <ItemTemplate>
                                                                 <%# Container.DataItemIndex + 1 %>
                                                             </ItemTemplate>
                                                         </asp:TemplateField>
                                                         <asp:TemplateField HeaderText="Due">
                                                             <ItemTemplate>
                                                                 <asp:LinkButton ID="lbDueSelected" runat="server"
                                                                     OnClick="lbDue_Click"
                                                                     CssClass='<%# Convert.ToDecimal(Eval("DueAmount")) > 0 ? "due-active" : "due-nodue" %>'
                                                                     Text='<%# Convert.ToDecimal(Eval("DueAmount")) > 0 ? Eval("DueAmount").ToString() : "No Due" %>'>
                                                                 </asp:LinkButton>
                                                                 <asp:HiddenField ID="hfCustomerMasterId" runat="server" Value='<%# Eval("CustomerMasterId") %>'></asp:HiddenField>
                                                                 <asp:HiddenField ID="hfTerritoryId" runat="server" Value='<%# GetEvalString(Container.DataItem, "TerritoryId") %>'></asp:HiddenField>
                                                                 <asp:PlaceHolder runat="server" Visible='<%# Eval("DueAlert") != DBNull.Value && Convert.ToInt32(Eval("DueAlert")) > 0 %>'>
                                                                     <span style="color: red; font-weight: bold; display: block;">30 days due!</span>
                                                                 </asp:PlaceHolder>
                                                             </ItemTemplate>
                                                         </asp:TemplateField>
                                                         <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                                         <asp:BoundField DataField="SubmissionDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                         <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                         <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                         <asp:BoundField DataField="TerritoryName" HeaderText="Territory Name" />
                                                         <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                                         <asp:BoundField DataField="DistributionRoute_Ord" HeaderText="Route Name" />
                                                         <asp:TemplateField HeaderText="Gross Value (TP)">
                                                             <ItemTemplate>
                                                                 <%# Eval("GrossValue") %>
                                                             </ItemTemplate>
                                                             <FooterTemplate>
                                                                 <asp:Label ID="lblSelectedGrossTotal" runat="server" Font-Bold="true" />
                                                             </FooterTemplate>
                                                         </asp:TemplateField>
                                                         <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />
                                                         <asp:BoundField DataField="DeliveryDate" HeaderText="Delivery Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                         <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                                         <asp:BoundField DataField="PaymentType" HeaderText="Payment Type" />
                                                         <asp:TemplateField HeaderText="Action">
                                                             <ItemTemplate>
                                                                 <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn btn-sm btn-danger" Text="Remove" OnClick="btnRemove_Click" CommandArgument='<%# Eval("OrderId") %>'>
                                                                     <i class="fa fa-trash"></i> Remove
                                                                 </asp:LinkButton>
                                                             </ItemTemplate>
                                                         </asp:TemplateField>
                                                     </Columns>
                                                 </asp:GridView>
                                             </div>
                                             <div class="row mt-2 mb-3">
                                                 <div class="col-12 text-end">
                                                      <asp:LinkButton ID="invoiceButton" runat="server" OnClientClick="return sweetAlertConfirm_Submit(this);" onclick="invoiceButton_Click" CssClass="btn btn-sm btn-success mb-2 pull-right"><i class="fa fa-file-text" aria-hidden="true"></i>&nbsp;Generate Invoice</asp:LinkButton>
                                                 </div>
                                             </div>
                                         </div>
                                     </div>
                                     
                                     <div class="row">
                                         <div class="table-responsive" id="MainGradeDiv">

                                            <asp:GridView ID="orderGridView" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                              CssClass="table table-bordered  text-center thead-dark"  OnPreRender="gv_DocumentUpload_PreRender" OnRowDataBound="orderGridView_RowDataBound" DataKeyNames="ComUnitId,ManufacId,OrderId">
                                                <Columns>


                                       <asp:TemplateField HeaderText="Sl. #">
    <ItemTemplate>
        <%# Container.DataItemIndex + 1 %>
    </ItemTemplate>
</asp:TemplateField>
                                                     <asp:TemplateField>
                                                         <HeaderTemplate>
                                                             <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True"
                                                                 OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                         </HeaderTemplate>
                                                         <ItemTemplate>
                                                              <asp:CheckBox ID="chkSelect" OnCheckedChanged="chkSelect_CheckedChanged" AutoPostBack="True" runat="server" />
                                                         </ItemTemplate>
                                                     </asp:TemplateField>

                                                       <asp:TemplateField HeaderText="Due">
       <ItemTemplate>

         <asp:LinkButton ID="lbDue" runat="server" 
            OnClick="lbDue_Click"
          
            CssClass='<%# Convert.ToDecimal(Eval("DueAmount")) > 0 ? "due-active" : "due-nodue" %>'
            Text='<%# Convert.ToDecimal(Eval("DueAmount")) > 0 ? Eval("DueAmount").ToString() : "No Due" %>'>
        </asp:LinkButton>
           <asp:HiddenField ID="hfCustomerMasterId" runat="server" Value='<%# Eval("CustomerMasterId") %>'></asp:HiddenField>
           <asp:HiddenField ID="hfTerritoryId" runat="server" Value='<%# GetEvalString(Container.DataItem, "TerritoryId") %>'></asp:HiddenField>

               <asp:PlaceHolder runat="server" Visible='<%# Eval("DueAlert") != DBNull.Value && Convert.ToInt32(Eval("DueAlert")) > 0 %>'>
            <span style="color: red; font-weight: bold; display: block;">
                30 days due!
            </span>
        </asp:PlaceHolder>
       </ItemTemplate>
   </asp:TemplateField>

                                                    <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                                    <asp:BoundField DataField="SubmissionDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                  <asp:TemplateField>
    <HeaderTemplate>
        Customer<br />Code
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("CustomerCode") %>
    </ItemTemplate>
</asp:TemplateField>

                                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />

                                                                                                                                                          <asp:TemplateField>
    <HeaderTemplate>
       Territory<br />Name
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("TerritoryName") %>
    </ItemTemplate>
</asp:TemplateField>
                                                     
                                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                                    <asp:BoundField DataField="DistributionRoute_Ord" HeaderText="Route Name" />
                                                    <asp:BoundField DataField="DistributionRouteId" HeaderText="Route ID" />
                                                    <%--<asp:BoundField DataField="SalesCenterCode" HeaderText="Sales Center Code" />
                                    <asp:BoundField DataField="SalesCenterName" HeaderText="Sales Center Name" />--%>
                                                  <%--  <asp:BoundField DataField="MiaCode" HeaderText="MIO Code" />--%>
                                                <%--    <asp:BoundField DataField="MiaName" HeaderText="MIO Name" />--%>

                                                                                                      <asp:TemplateField>
    <HeaderTemplate>
        Gross Value<br />(TP)
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("GrossValue") %>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblOrderGrossTotal" runat="server" Font-Bold="true" />
    </FooterTemplate>
</asp:TemplateField>

                                                    
                                                    <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />
                                                       <asp:BoundField DataField="DeliveryDate" HeaderText="Delivery Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                                    <asp:BoundField DataField="PaymentType" HeaderText="Payment Type" />
                                                    <asp:TemplateField HeaderText="Go To Invoice"  >
                                                        <ItemTemplate>
                                                             <asp:Button ID="gotoinvoiceButton" runat="server" Text="Go To Invoice >>" CssClass="btn btn-sm  btn-info"   OnClientClick="return sweetAlertConfirm_Submit(this);"
                                                                 OnClick="gotoinvoiceButton_Click" />
                                                               <%-- Opens the payment commitment modal; the modal is the confirmation step,
                                                                    so no sweetAlert confirm in front of it. --%>
                                                               <asp:Button ID="btnGoForApproval" runat="server" Text="Go for Approval" Visible="false" CssClass="btn btn-sm btn-warning"
                                                                 OnClick="btnGoForApproval_Click" CausesValidation="false" />
                                                               <asp:Label ID="lblApprovalStatus" runat="server" Visible="false" CssClass="badge bg-secondary" style="display:block; white-space:normal; max-width:180px; margin-top:5px;"></asp:Label>
                                                               <asp:Label ID="lblWarning" runat="server" ForeColor="Red" Font-Size="Smaller" style="display:block; white-space:normal; max-width:180px; word-wrap:break-word; margin-top:5px; line-height:1.2;"></asp:Label>
                                                               <asp:HiddenField runat="server" ID="hfCustomerCode" Value='<%#Eval("CustomerCode")%>' />
                                                               <asp:HiddenField runat="server" ID="hfDistributionRouteId" Value='<%# GetEvalString(Container.DataItem, "DistributionRouteId") %>' />
                                                               <%-- Header values for the payment commitment modal. Display only: the
                                                                    instalment total is re-validated against fnOrderCreditValidation
                                                                    inside sp_Post_OrderPaymentApp, so a stale figure here can only
                                                                    produce a clean error, never a wrong approval. --%>
                                                               <asp:HiddenField runat="server" ID="hfOrderCodeApp" Value='<%# GetEvalString(Container.DataItem, "OrderCode") %>' />
                                                               <asp:HiddenField runat="server" ID="hfCustomerNameApp" Value='<%# GetEvalString(Container.DataItem, "CustomerName") %>' />
                                                               <asp:HiddenField runat="server" ID="hfDueAmountApp" Value='<%# GetEvalString(Container.DataItem, "DueAmount") %>' />
                                                         </ItemTemplate>
                                                     </asp:TemplateField>



                                                    <%--  <asp:TemplateField HeaderText="Generate Invoice">
                                        <ItemTemplate>
                                            <asp:Button ID="GenerateinvoiceButton" runat="server" Text="Generate"  CssClass="button"
                                                onclick="GeneratetoinvoiceButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                               


                           
                </ContentTemplate>
            </asp:UpdatePanel>

       </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    
                        <style type="text/css">
        .modalBackground {
            background-color: #262626 !important;
            filter: alpha(opacity=50) !important;
            opacity: 0.5 !important;
        }

        .modalPopup {
            background-color: #FFFFFF !important;
            width: 300px;
            border-left: 3px solid #4D97C2 !important;
            border-radius: 12px;
            -webkit-box-shadow: 1px 1px 4px 1px rgba(0,0,0,0.41) !important;
            -moz-box-shadow: 1px 1px 4px 1px rgba(0,0,0,0.41) !important;
            box-shadow: 1px 1px 4px 1px rgba(0,0,0,0.41) !important;
        }
    </style>

    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="mpe_1" runat="server" TargetControlID="hnd_Test" PopupControlID="pnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Customer Previous Dues Status  </h3>
                        <asp:Label ID="lblInvoiceCount" runat="server" Text=""></asp:Label>
                        <div style="display: flex; gap: 10px;">
                            <asp:Button ID="btnExportToExcel" runat="server" Text="Export to Excel" CssClass="btn-success" OnClick="btnExportToExcel_Click" />
                            <asp:Button ID="btnCloseModal" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModal_Click" />
                        </div>
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="max-height: 300px; overflow-y: auto; margin-top: 20px">
                        <asp:GridView ID="gv_Invoice" runat="server" AutoGenerateColumns="False" ShowFooter="true"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" >
                            <Columns>
                               
 <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No." />
        <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd/MM/yyyy}" />
        <asp:TemplateField HeaderText="Customer Code">
            <ItemTemplate><%# GetEvalString(Container.DataItem, "CustomerCode") %></ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Customer Name">
            <ItemTemplate><%# GetEvalString(Container.DataItem, "CustomerName") %></ItemTemplate>
        </asp:TemplateField>

                                       <asp:TemplateField HeaderText="In transit Day">
    <ItemTemplate>
        <%# Eval("IntransitDay") %>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblTotalbb" Text="Total" runat="server" Font-Bold="true" />
    </FooterTemplate>
</asp:TemplateField>

       <asp:TemplateField HeaderText="Invoice Value">
    <ItemTemplate>
        <%# Eval("ReturnAmount", "{0:N2}") %>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblTotalInvoice" runat="server" Font-Bold="true" />
    </FooterTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Paid Amount">
    <ItemTemplate>
        <%# Eval("CustomerPaymentAmount", "{0:N2}") %>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblTotalPaid" runat="server" Font-Bold="true" />
    </FooterTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Due Amount">
    <ItemTemplate>
        <%# Eval("ReceivableTotalAmnt", "{0:N2}") %>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblTotalDue" runat="server" Font-Bold="true" />
    </FooterTemplate>
</asp:TemplateField>

    </Columns>
</asp:GridView>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #28a745; color: white; margin-top: 20px;">
                        <h5 style="margin: 0;">Territory & Customer Type Wise Status</h5>
                    </div>
                    <div class="table-responsive" style="max-height: 300px; margin-top: 10px">
                        <asp:GridView ID="gv_CustomerTypeWise" runat="server" AutoGenerateColumns="False" ShowFooter="true"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                            <Columns>
                                <asp:TemplateField HeaderText="Territory Name">
                                    <ItemTemplate><%# GetEvalString(Container.DataItem, "TerritoryName") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Customer Type">
                                    <ItemTemplate><%# GetEvalString(Container.DataItem, "CustomerType") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Customer Code">
                                    <ItemTemplate><%# GetEvalString(Container.DataItem, "CustomerCode") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Customer Name">
                                    <ItemTemplate><%# GetEvalString(Container.DataItem, "CustomerName") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No." />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:TemplateField HeaderText="In transit Day">
                                    <ItemTemplate><%# Eval("IntransitDay") %></ItemTemplate>
                                    <FooterTemplate><asp:Label ID="lblTotalText_CT" Text="Total" runat="server" Font-Bold="true" /></FooterTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Invoice Value">
                                    <ItemTemplate>
                                        <%# Eval("ReturnAmount", "{0:N2}") %>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalInvoice_CT" runat="server" Font-Bold="true" />
                                    </FooterTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Paid Amount">
                                    <ItemTemplate>
                                        <%# Eval("CustomerPaymentAmount", "{0:N2}") %>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalPaid_CT" runat="server" Font-Bold="true" />
                                    </FooterTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Due Amount">
                                    <ItemTemplate>
                                        <%# Eval("ReceivableTotalAmnt", "{0:N2}") %>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalDue_CT" runat="server" Font-Bold="true" />
                                    </FooterTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExportToExcel" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>

    <%-- ==================================================================================
         Order Payment Approval - payment commitment modal.

         The instalment plan belongs to the REQUEST, not to the approval: the person
         talking to the customer records what the customer committed to, and the managers
         approve it or reject it. The approval page stays one-click, exactly like every
         other page in the approval framework - see deploy_order_payment_approval.sql.

         Same ModalPopupExtender idiom already used on this page for pnl_1.
         ================================================================================== --%>
    <div>
        <cc1:ModalPopupExtender ID="mpeSchedule" runat="server" TargetControlID="hfScheduleTarget"
            PopupControlID="pnlSchedule" BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hfScheduleTarget" runat="server" />
        <asp:HiddenField ID="hfScheduleOrderId" runat="server" />

        <asp:Panel ID="pnlSchedule" runat="server" CssClass="modalPopup"
            Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Width="720px">

            <asp:UpdatePanel ID="upSchedule" runat="server">
                <ContentTemplate>

                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #ffc107; color: #212529; border-radius: 5px 5px 0 0;">
                        <h5 style="margin: 0;">Payment Commitment &mdash; Go for Approval</h5>
                        <asp:Button ID="btnScheduleClose" runat="server" Text="X" CssClass="btn-danger"
                            OnClick="btnScheduleClose_Click" CausesValidation="false" />
                    </div>

                    <div class="row mt-3 mb-2">
                        <div class="col-md-4"><small class="text-muted d-block">Order</small><asp:Label ID="lblScheduleOrder" runat="server" Font-Bold="true" /></div>
                        <div class="col-md-4"><small class="text-muted d-block">Customer</small><asp:Label ID="lblScheduleCustomer" runat="server" /></div>
                        <div class="col-md-4"><small class="text-muted d-block">Total Due</small><asp:Label ID="lblScheduleDue" runat="server" Font-Bold="true" /></div>
                    </div>

                    <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
                        <asp:GridView ID="gvSchedule" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-bordered table-sm"
                            OnRowCommand="gvSchedule_RowCommand" OnRowDataBound="gvSchedule_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="#">
                                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Payment Date">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPaymentDate" runat="server" CssClass="form-control form-control-sm schedulepicker"
                                            autocomplete="off" placeholder="dd-MMM-yyyy" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Amount">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPaymentAmount" runat="server" CssClass="form-control form-control-sm text-end"
                                            autocomplete="off" placeholder="0.00" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnRemoveRow" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                            CommandName="RemoveRow" CommandArgument='<%# Container.DataItemIndex %>'
                                            CausesValidation="false" Text="Remove" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-2">
                        <asp:LinkButton ID="btnAddScheduleRow" runat="server" CssClass="btn btn-sm btn-outline-secondary"
                            OnClick="btnAddScheduleRow_Click" CausesValidation="false">
                            <i class="fa fa-plus" aria-hidden="true"></i>&nbsp;Add Instalment
                        </asp:LinkButton>
                        <asp:Label ID="lblScheduleTotal" runat="server" CssClass="badge bg-secondary" />
                    </div>

                    <div class="mt-2">
                        <asp:Label ID="lblScheduleError" runat="server" ForeColor="Red" Font-Size="Smaller" />
                    </div>

                    <div class="mt-3">
                        <small class="text-muted">
                            Instalment dates must be today or later and unique. The instalment total must
                            equal the Total Due.
                        </small>
                    </div>

                    <div class="mt-3 text-end">
                        <asp:Button ID="btnScheduleSubmit" runat="server" Text="Send for Approval"
                            CssClass="btn btn-sm btn-warning" OnClick="btnScheduleSubmit_Click" />
                        <asp:Button ID="btnScheduleCancel" runat="server" Text="Cancel"
                            CssClass="btn btn-sm btn-outline-secondary" OnClick="btnScheduleClose_Click"
                            CausesValidation="false" />
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
    </div>

    <script type="text/javascript">
        // Re-wire the date picker after every partial postback, so rows added with
        // "Add Instalment" get one too.
        function pageLoad() {
            if (window.jQuery && jQuery.fn.pickadate) {
                $('.schedulepicker').pickadate({ selectMonths: true, selectYears: true, format: 'dd-mmm-yyyy' });
            }
        }
    </script>


    <asp:UpdatePanel ID="UpdatePanel1" runat="server" Visible="False">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">Proforma Invoice Creation
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
                        <td width="20%" class="TDRight">Sales Center</td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight">Manufacture</td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight"></td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft"></td>
                        <td width="20%" class="TDRight">Market</td>
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

