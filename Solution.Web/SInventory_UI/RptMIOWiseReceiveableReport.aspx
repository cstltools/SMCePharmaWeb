<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="RptMIOWiseReceiveableReport.aspx.cs" Inherits="SInventory_UI_RptMIOWiseReceiveableReport" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<%--<%@ Register Src="~/SInventory_UI/IVMarketStructureInvoSearchReport.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> --%>
<%@ Register Src="~/SInventory_UI/IVMarketSTForZone.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
            font-size: 20px;
            font-weight: bold;
        }

        .radioChoice2 label {
            padding-left: 5px;
            padding-right: 30px;
            font-size: 16px;
            font-weight: bold;
        }



        .Label_Title {
            background-color: #C7C7C7;
            width: 100%;
            text-align: center;
            margin: 0px;
            padding: 3px;
            text-align: center;
            color: #000;
            margin-right: 5%;
            font-weight: bold;
            font-size: 13px;
        }
    </style>




    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>MIO Wise Receivable Report</div>

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
                                            });

                                        }
                                    </script>
                                    <div class="row">


                                        <div class="col-sm-2" style="display:none">

                                            <div class="Label_Title  ">Report Type </div>

                                            <div class="form-group">

                                                <asp:RadioButtonList runat="server" ID="rbReportTypeName" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rbReportTypeName_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                                                    <%--   <asp:ListItem Value="1">User Wise</asp:ListItem>--%>

                                                    <asp:ListItem Selected="True" Value="1">Distribution Center</asp:ListItem>
                                                    <asp:ListItem Value="2">Zone</asp:ListItem>
                                                    <asp:ListItem Value="3">Area</asp:ListItem>
                                                    <asp:ListItem Value="4">Territory</asp:ListItem>

                                                </asp:RadioButtonList>
                                            </div>



                                        </div>

                                        <div class="col-3" id="divMrk" runat="server" visible="false">
                                            <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                        </div>

                                        <div class="col-3">


                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color: red">*</span></label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="fromDateTextBox" runat="server" AutoPostBack="true" OnTextChanged="fromDateTextBox_TextChanged" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  From Date"></asp:TextBox>





                                                </div>

                                            </div>

                                            <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">To Date:  <span style="color: red">*</span></label>

                                                <div class="col-sm-7">

                                                    <asp:TextBox ID="toDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select To Date"></asp:TextBox>




                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-3" style="display: none">


                                            <div class="form-group row" runat="server">
                                                <asp:RadioButtonList runat="server" ID="rbAmount" CssClass="radioChoice2" RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">

                                                    <asp:ListItem Selected="True" Value="1">Transactional</asp:ListItem>
                                                    <asp:ListItem Value="2">Non-transactional</asp:ListItem>

                                                </asp:RadioButtonList>


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


                                                    <asp:LinkButton OnClick="viewRptButton_Click" runat="server" ID="viewRptButton" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-search-plus" aria-hidden="true"></i>&nbsp; Search
                                                    </asp:LinkButton>




                                                    <asp:LinkButton runat="server" OnClick="Unnamed_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-2">
                                            <h3>Details List</h3>
                                        </div>
                                        <div class="col-7">
                                        </div>
                                        <div class="col-3">

                                            <div class="form-group row  pull-right">
                                                <asp:LinkButton OnClick="btnExportToExcel_Click" runat="server" ID="excelButton1" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel
                                                </asp:LinkButton>


                                            </div>
                                        </div>

                                    </div>
                                    <hr />

                                    <div class="table-responsive" id="MainGradeDiv" style="height: 600px">
                                        <asp:GridView ID="gv_DistributionCenter" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="loadGridView_OnRowCreated"
                                            ShowFooter="True">
                                            <Columns>


                                                <asp:BoundField DataField="ComUnitShortName" HeaderText="MIO" />



                                                <asp:BoundField DataField="NumberofInvoice" HeaderText="No of Invoice"
                                                    ItemStyle-Width="60" DataFormatString="{0:D}"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>




                                                <asp:BoundField DataField="InvoieAmountTP"
                                                    HeaderText="Amount (TP)" ItemStyle-Width="60"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>


                                                <%--<asp:BoundField DataField="InvoiceVatTp" HeaderText="VAT" />--%>

                                                <asp:BoundField DataField="InvoiceGrossAmt" HeaderText="Gross Amount" />


                                                 <asp:BoundField DataField="RejectAmtTP" HeaderText="Invoice Rejection (TP)" />
<%-- <asp:BoundField DataField="RejectionTpVat" HeaderText="VAT" />--%>
 <asp:BoundField DataField="RejectGrossAmt" HeaderText="Invoice Rejection Gross" />

                                               <%-- Sales Confirmation--%>
                                               <asp:BoundField DataField="SalesAmtTP" HeaderText="Amount (TP) " />
<%--  <asp:BoundField DataField="SalesVat" HeaderText="VAT" />--%>
  <asp:BoundField DataField="SalesGrossAmt" HeaderText="Gross Amount" />




                                                <asp:BoundField DataField="ReturnAmountTP" HeaderText="Amount (TP)" />

<%--                                                <asp:BoundField DataField="ReturnAmountVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="ReturnGrossAmt" HeaderText="Gross Amount" />


                                                <%--net Sales--%>

                                                <asp:BoundField DataField="JustSalesAmtTP" HeaderText="Amount (TP)" />
                                            <%--    <asp:BoundField DataField="JustSalesVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="JustSalesGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="CollectionAmtTP" HeaderText="Amount (TP)" />
                                                <%--<asp:BoundField DataField="CollectionVat" HeaderText="Collection VAT" />--%>
                                                <asp:BoundField DataField="CollectionGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="ReceivableTP" HeaderText="Amount (TP)" />
                                                <asp:BoundField DataField="ReceivableGrossAmount" HeaderText="Gross Amount" />


                                               

                                            </Columns>
                                        </asp:GridView>


                                        <asp:GridView ID="gv_Zone" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="gv_Zone_OnRowCreated"
                                            ShowFooter="True">
                                            <Columns>


                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />


                                               
                                                <asp:BoundField DataField="NumberofInvoice" HeaderText="No of Invoice"
                                                    ItemStyle-Width="60" DataFormatString="{0:D}"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>




                                                <asp:BoundField DataField="InvoieAmountTP"
                                                    HeaderText="Amount (TP)" ItemStyle-Width="60"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>


                                                <%--<asp:BoundField DataField="InvoiceVatTp" HeaderText="VAT" />--%>

                                                <asp:BoundField DataField="InvoiceGrossAmt" HeaderText="Gross Amount" />


                                                 <asp:BoundField DataField="RejectAmtTP" HeaderText="Invoice Rejection (TP)" />
<%-- <asp:BoundField DataField="RejectionTpVat" HeaderText="VAT" />--%>
 <asp:BoundField DataField="RejectGrossAmt" HeaderText="Invoice Rejection Gross" />

                                               <%-- Sales Confirmation--%>
                                               <asp:BoundField DataField="SalesAmtTP" HeaderText="Amount (TP)" />
<%--  <asp:BoundField DataField="SalesVat" HeaderText="VAT" />--%>
  <asp:BoundField DataField="SalesGrossAmt" HeaderText="Gross Amount" />




                                                <asp:BoundField DataField="ReturnAmountTP" HeaderText="Amount (TP)" />

<%--                                                <asp:BoundField DataField="ReturnAmountVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="ReturnGrossAmt" HeaderText="Gross Amount" />


                                                <%--Sales--%>

                                                <asp:BoundField DataField="JustSalesAmtTP" HeaderText="Amount (TP)" />
                                            <%--    <asp:BoundField DataField="JustSalesVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="JustSalesGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="CollectionAmtTP" HeaderText="Amount (TP)" />
                                                <%--<asp:BoundField DataField="CollectionVat" HeaderText="Collection VAT" />--%>
                                                <asp:BoundField DataField="CollectionGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="ReceivableTP" HeaderText="Amount (TP)" />
                                                <asp:BoundField DataField="ReceivableGrossAmount" HeaderText="Gross Amount" />



                                            </Columns>
                                        </asp:GridView>

                                        <asp:GridView ID="gv_Area" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="gv_Area_OnRowCreated"
                                            ShowFooter="True">
                                            <Columns>



                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />


                                           
                                                <asp:BoundField DataField="NumberofInvoice" HeaderText="No of Invoice"
                                                    ItemStyle-Width="60" DataFormatString="{0:D}"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>




                                                <asp:BoundField DataField="InvoieAmountTP"
                                                    HeaderText="Amount (TP)" ItemStyle-Width="60"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>


                                                <%--<asp:BoundField DataField="InvoiceVatTp" HeaderText="VAT" />--%>

                                                <asp:BoundField DataField="InvoiceGrossAmt" HeaderText="Gross Amount" />


                                                 <asp:BoundField DataField="RejectAmtTP" HeaderText="Invoice Rejection (TP)" />
<%-- <asp:BoundField DataField="RejectionTpVat" HeaderText="VAT" />--%>
 <asp:BoundField DataField="RejectGrossAmt" HeaderText="Invoice Rejection Gross" />

                                               <%-- Sales Confirmation--%>
                                               <asp:BoundField DataField="SalesAmtTP" HeaderText="Amount (TP)" />
<%--  <asp:BoundField DataField="SalesVat" HeaderText="VAT" />--%>
  <asp:BoundField DataField="SalesGrossAmt" HeaderText="Gross Amount" />




                                                <asp:BoundField DataField="ReturnAmountTP" HeaderText="Amount (TP)" />

<%--                                                <asp:BoundField DataField="ReturnAmountVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="ReturnGrossAmt" HeaderText="Gross Amount" />


                                                <%--Sales--%>

                                                <asp:BoundField DataField="JustSalesAmtTP" HeaderText="Amount (TP)" />
                                            <%--    <asp:BoundField DataField="JustSalesVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="JustSalesGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="CollectionAmtTP" HeaderText="Amount (TP)" />
                                                <%--<asp:BoundField DataField="CollectionVat" HeaderText="Collection VAT" />--%>
                                                <asp:BoundField DataField="CollectionGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="ReceivableTP" HeaderText="Amount (TP)" />
                                                <asp:BoundField DataField="ReceivableGrossAmount" HeaderText="Gross Amount" />



                                            </Columns>
                                        </asp:GridView>

                                        <asp:GridView ID="gv_Territory" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="gv_Territory_OnRowCreated"
                                            ShowFooter="True">
                                            <Columns>
                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                                <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />


                                              
                                                                                              <asp:BoundField DataField="NumberofInvoice" HeaderText="No of Invoice"
                                                    ItemStyle-Width="60" DataFormatString="{0:D}"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>




                                                <asp:BoundField DataField="InvoieAmountTP"
                                                    HeaderText="Amount (TP)" ItemStyle-Width="60"
                                                    ItemStyle-HorizontalAlign="Right">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                </asp:BoundField>


                                                <%--<asp:BoundField DataField="InvoiceVatTp" HeaderText="VAT" />--%>

                                                <asp:BoundField DataField="InvoiceGrossAmt" HeaderText="Gross Amount" />


                                                 <asp:BoundField DataField="RejectAmtTP" HeaderText="Invoice Rejection (TP)" />
<%-- <asp:BoundField DataField="RejectionTpVat" HeaderText="VAT" />--%>
 <asp:BoundField DataField="RejectGrossAmt" HeaderText="Invoice Rejection Gross" />

                                               <%-- Sales Confirmation--%>
                                               <asp:BoundField DataField="SalesAmtTP" HeaderText="Amount (TP)" />
<%--  <asp:BoundField DataField="SalesVat" HeaderText="VAT" />--%>
  <asp:BoundField DataField="SalesGrossAmt" HeaderText="Gross Amount" />




                                                <asp:BoundField DataField="ReturnAmountTP" HeaderText="Amount (TP)" />

<%--                                                <asp:BoundField DataField="ReturnAmountVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="ReturnGrossAmt" HeaderText="Gross Amount" />


                                                <%--Sales--%>

                                                <asp:BoundField DataField="JustSalesAmtTP" HeaderText="Amount (TP)" />
                                            <%--    <asp:BoundField DataField="JustSalesVat" HeaderText="VAT" />--%>
                                                <asp:BoundField DataField="JustSalesGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="CollectionAmtTP" HeaderText="Amount (TP)" />
                                                <%--<asp:BoundField DataField="CollectionVat" HeaderText="Collection VAT" />--%>
                                                <asp:BoundField DataField="CollectionGrossAmt" HeaderText="Gross Amount" />


                                                <asp:BoundField DataField="ReceivableTP" HeaderText="Amount (TP)" />
                                                <asp:BoundField DataField="ReceivableGrossAmount" HeaderText="Gross Amount" />


                                            </Columns>
                                        </asp:GridView>


                                    </div>


                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="excelButton1" />
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
                <td colspan="6" class="TableHeading">Business Summary
                </td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">&nbsp;
                </td>
                <td class="TDRight" width="20%">&nbsp;
                </td>
                <td class="TDLeft" width="13%">&nbsp;
                </td>
                <td class="TDRight" width="20%">&nbsp;
                </td>
                <td class="TDLeft" width="13%">&nbsp;
                </td>
                <td class="TDRight" width="20%">&nbsp;
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




            <tr id="divSalsesCenter" runat="server" visible="False">
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
                <td width="13%" class="TDLeft">Zone Name
                </td>
                <td width="20%" class="TDRight">
                    <asp:DropDownList ID="zoneDropDownList" runat="server"
                        CssClass="DropDown">
                    </asp:DropDownList>
                </td>
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
            </tr>

            <tr id="Tr1" runat="server" visible="False">
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
                <td width="13%" class="TDLeft">Depot Name
                           
                </td>
                <td width="20%" class="TDRight">
                    <asp:DropDownList ID="salesCenterDropDownList" runat="server"
                        CssClass="DropDown">
                    </asp:DropDownList>
                </td>
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
            </tr>

            <tr id="Tr2" runat="server" visible="False">
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
                <td width="13%" class="TDLeft">Territory Name
                </td>
                <td width="20%" class="TDRight">
                    <asp:DropDownList ID="territoryDropDownList" runat="server"
                        CssClass="DropDown">
                    </asp:DropDownList>
                </td>
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
            </tr>


            <tr>
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight"></td>
                <td width="13%" class="TDLeft">From Date
                </td>
                <td width="20%" class="TDRight"></td>
                <td width="13%" class="TDLeft">&nbsp;
                </td>
                <td width="20%" class="TDRight"></td>
            </tr>
            <tr>
                <td width="13%" class="TDLeft"></td>
                <td width="20%" class="TDRight">&nbsp;
                </td>
                <td width="13%" class="TDLeft">To Date
                </td>
                <td width="20%" class="TDRight"></td>
                <td width="13%" class="TDLeft">&nbsp;
                </td>
                <td width="20%" class="TDRight"></td>
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
            <tr>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <td width="13%" class="TDLeft" colspan="6">

                            <br />
                            <br />
                            <br />
                            <br />
                        </td>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </tr>
        </table>
    </div>
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
