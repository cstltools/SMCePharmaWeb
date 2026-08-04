<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DynamicSalesReport.aspx.cs" Inherits="SInventory_UI_DynamicSalesReport" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<%@ Register Src="~/SInventory_UI/IVMarketStructureInvoSearchReport.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Dynamic Sales Summary Report</div>

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
                           <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>

                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                            </div>
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>--%>

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


                                    <style>
                                        .filter-panel {
                                            border: 1px solid #ccc;
                                            padding-left: 10px;
                                            padding-right: 10px;
                                            padding-bottom: 10px;
                                            padding-top: 15px;
                                            background: white;
                                            border-radius: 5px;
                                            position: relative;
                                        }

                                        .filter-header {
                                            font-weight: bold;
                                            padding: 5px 10px;
                                            display: inline-block;
                                            background: white;
                                            position: absolute;
                                            top: -12px;
                                            left: 10px;
                                            border: 2px solid #ccc;
                                        }

                                        .filter-body {
                                            padding-top: 10px;
                                        }

                                        .radioChoice label {
                                            padding-left: 5px;
                                            font-size: 17px;
                                            font-weight: bold;
                                        }

                                        .radioChoicedate label {
                                            padding-left: 5px;
                                            padding-right: 10px;
                                            font-size: 17px;
                                            font-weight: bold;
                                        }

                                        .chkChoiceHeader label {
                                            padding-left: 4px;
                                            padding-right: 20px;
                                            font-size: 13px;
                                        }

                                        .chkChoiceHead label {
                                            padding-left: 4px;
                                            font-size: 14px;
                                            font-weight: bold;
                                        }
                                    </style>
                                    <div class="row">

                                        <div class="col-md-2" style="display: none">

                                            <asp:Panel runat="server" CssClass="filter-panel">
                                                <div class="filter-header">
                                                    <span>Report Type</span>
                                                </div>

                                                <div class="filter-body">
                                                    <asp:RadioButtonList runat="server" ID="rbReportType" CssClass="radioChoice"
                                                        RepeatDirection="Vertical" RepeatLayout="Flow">
                                                        <asp:ListItem Selected="True" Value="Summary"><b>Summary</b></asp:ListItem>
                                                        <asp:ListItem Value="Details">Details</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </asp:Panel>



                                        </div>

                                        <div class="col-8">
                                            <asp:Panel runat="server" CssClass="filter-panel">
                                                <div class="filter-header">
                                                    <span>Filter By</span>
                                                </div>

                                                <div class="filter-body">
                                                    <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                                </div>
                                            </asp:Panel>
                                        </div>


                                        <div class="col-md-2">
                                            <asp:Panel runat="server" CssClass="filter-panel">
                                                <div class="filter-header">
                                                    <span>Filter Type</span>
                                                </div>

                                                <div class="filter-body">
                                                    <asp:RadioButtonList Enabled="false" runat="server" ID="rbType" CssClass="radioChoice" RepeatDirection="Vertical" RepeatLayout="Flow">
                                                        <asp:ListItem Selected="True" Value="TerritoryWise">Territory Wise</asp:ListItem>
                                                        <asp:ListItem Value="UserWise">User Wise</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </asp:Panel>
                                        </div>

                                        <div class="col-md-2">
                                            <asp:Panel runat="server" CssClass="filter-panel">
                                                <div class="filter-header">
                                                    <span>Calculation Type</span>
                                                </div>

                                                <div class="filter-body">
                                                    <asp:RadioButtonList runat="server" ID="rbCalculationType" CssClass="radioChoice"
                                                        RepeatDirection="Vertical" Enabled="false" RepeatLayout="Flow">
                                                        <asp:ListItem Selected="True" Value="NetTP"><b>Net TP</b></asp:ListItem>
                                                        <asp:ListItem Selected="True" Value="NetTPVAT">Net TP+VAT</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </asp:Panel>
                                        </div>




                                    </div>

                                    <div class="row" style="margin-top: 20px;">

                                        <div class="col-5">
                                        </div>
                                        <div class="col-7">
                                            <asp:Panel runat="server" CssClass="filter-panel">
                                                <div class="filter-header">
                                                    <span>Filter Type</span>
                                                </div>

                                                <div class="filter-body">
                                                    <asp:RadioButtonList Enabled="false" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rbDTWise_SelectedIndexChanged" ID="rbDTWise" CssClass="radioChoicedate"
                                                        RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                        <asp:ListItem Selected="True" Value="Date Range Wise"><b>Date Range Wise</b></asp:ListItem>
                                                        <asp:ListItem Value="Month Wise">Month Wise</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </asp:Panel>
                                        </div>


                                        <div class="row" style="margin-top: 20px;">

                                            <div class="col-4">




                                                <div class="form-group row" runat="server" visible="false">
                                                    <label for="mainName" class="col-sm-5 col-form-label">Brand Name: </label>

                                                    <div class="col-sm-7">
                                                        <asp:DropDownList ID="dcDropDownList1" Visible="false" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                        </asp:DropDownList>

                                                        <asp:DropDownList ID="ddlBrandName" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                                                        </asp:DropDownList>


                                                    </div>

                                                </div>


                                            </div>

                                            <div class="col-md-4" runat="server" visible="false" id="divmonth">

                                                <div class="form-group row" runat="server">
                                                    <label for="ddlYear" class="col-sm-5 col-form-label">Year: <span style="color: red">*</span></label>
                                                    <div class="col-sm-7">
                                                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="form-group row" runat="server">
                                                    <label for="ddlMonth" class="col-sm-5 col-form-label">Month: <span style="color: red">*</span></label>
                                                    <div class="col-sm-7">
                                                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control form-control-sm">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>

                                                <!-- Year Selection Dropdown -->

                                            </div>
                                            <div class="col-md-4" runat="server" visible="false" id="divdtRange">
                                                <div class="form-group row" runat="server">
                                                    <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color: red">*</span></label>

                                                    <div class="col-sm-7">
                                                        <asp:TextBox ID="InvoiceDateTextBox" AutoPostBack="true" OnTextChanged="fromDateTextBox_TextChanged" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice From Date"></asp:TextBox>





                                                    </div>

                                                </div>


                                                <div class="form-group row" runat="server">
                                                    <label for="mainName" class="col-sm-5 col-form-label">To Date:  <span style="color: red">*</span></label>

                                                    <div class="col-sm-7">

                                                        <asp:TextBox ID="todateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Invoice To Date"></asp:TextBox>




                                                    </div>

                                                </div>
                                            </div>



                                        </div>
                                        <div class="row">


                                            <div class="col-md-12">
                                                <asp:Panel runat="server" CssClass="filter-panel">
                                                    <div class="filter-header">
                                                        <asp:CheckBox Text="Report Header" CssClass="chkChoiceHead" runat="server" ID="chkRpt" AutoPostBack="True" OnCheckedChanged="chkRpt_OnCheckedChanged" />
                                                    </div>

                                                    <div class="filter-body">
                                                        <asp:CheckBoxList ID="cblHeader" RepeatDirection="Vertical" RepeatColumns="5" CssClass="chkChoiceHeader" runat="server">
                                                            <asp:ListItem>Invoice</asp:ListItem>
                                                            <asp:ListItem>Partial Collection</asp:ListItem>
                                                            <asp:ListItem>Full Collection</asp:ListItem>
                                                            <asp:ListItem>FCB Invoice</asp:ListItem>
                                                            <asp:ListItem>FCB Collection</asp:ListItem>
                                                           <%-- <asp:ListItem>Campaigns Invoice</asp:ListItem>
                                                            <asp:ListItem>Campaigns Collection</asp:ListItem>--%>
                                                            <asp:ListItem>General Invoice</asp:ListItem>
                                                            <asp:ListItem>General Collection</asp:ListItem>
                                                            <asp:ListItem>Institution Invoice</asp:ListItem>
                                                            <asp:ListItem>Institution Collection</asp:ListItem>
                                                            <%--  <asp:ListItem>HQ_Invoice</asp:ListItem>
    <asp:ListItem>HQ_Collection</asp:ListItem>
    <asp:ListItem>Ex. HQ_Invoice</asp:ListItem>
    <asp:ListItem>Ex. HQ_Collection</asp:ListItem>
    <asp:ListItem>OS_Invoice</asp:ListItem>
    <asp:ListItem>OS_Collection</asp:ListItem>
    <asp:ListItem>Return (TP+VAT)</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Invoice</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Collection</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Invoice-BSP</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Collection-BSP</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Invoice-GSP</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Collection-GSP</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Invoice-PSP</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Collection-PSP</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Invoice-FCB</asp:ListItem>
    <asp:ListItem>#Chemist-Coverage-Collection-FCB</asp:ListItem>
    <asp:ListItem>#Total-InvoiceCov-Collection</asp:ListItem>
    <asp:ListItem>#InvoiceCov-Collection-BSP</asp:ListItem>
    <asp:ListItem>#InvoiceCov-Collection-GSP</asp:ListItem>
    <asp:ListItem>#InvoiceCov-Collection-PSP</asp:ListItem>
    <asp:ListItem>Blue Star Invoice</asp:ListItem>
    <asp:ListItem>Blue Star Collection</asp:ListItem>
    <asp:ListItem>Green Star Invoice</asp:ListItem>
    <asp:ListItem>Green Star Collection</asp:ListItem>
    <asp:ListItem>Pink Star Invoice</asp:ListItem>
    <asp:ListItem>Pink Star Collection</asp:ListItem>
    <asp:ListItem>Total Customer</asp:ListItem>
    <asp:ListItem>No of Blue Star Customer</asp:ListItem>
    <asp:ListItem>No of Green Star Customer</asp:ListItem>
    <asp:ListItem>No of Pink Star Customer</asp:ListItem>
    <asp:ListItem>No of FCB Customer</asp:ListItem>
    <asp:ListItem>Sales Campaign Invoice</asp:ListItem>
    <asp:ListItem>Sales Campaign Collection</asp:ListItem>
    <asp:ListItem>Bonus Campaign Invoice</asp:ListItem>
    <asp:ListItem>Bonus Campaign Collection</asp:ListItem>
    <asp:ListItem>Total SMC Bondhon Customer</asp:ListItem>
    <asp:ListItem>SMC Bondhon Customer Sales-Invoice</asp:ListItem>
    <asp:ListItem>SMC Bondhon Customer Sales-Collection</asp:ListItem>
    <asp:ListItem>Cov. SMC Bondhon Customer-Collection</asp:ListItem>--%>
                                                            <asp:ListItem>Total Doctor</asp:ListItem>
                                                            <asp:ListItem>No of BSP</asp:ListItem>
                                                            <asp:ListItem>No of GSP</asp:ListItem>
                                                            <asp:ListItem>No of PSP</asp:ListItem>
                                                            <asp:ListItem>No of GMP</asp:ListItem>
                                                          <%--  <asp:ListItem>No of HQ Doctor</asp:ListItem>
                                                            <asp:ListItem>No of Ex. HQ Doctor</asp:ListItem>
                                                            <asp:ListItem>No of OS Doctor</asp:ListItem>--%>
                                                            <asp:ListItem>Sum of DCR-Total</asp:ListItem>
                                                            <asp:ListItem>Sum of DCR-BSP</asp:ListItem>
                                                            <asp:ListItem>Sum of DCR-GSP</asp:ListItem>
                                                            <asp:ListItem>Sum of DCR-PSP</asp:ListItem>
                                                            <asp:ListItem>Sum of GMP-DCR</asp:ListItem>
                                                           <%-- <asp:ListItem>GMP-Doctor Coverage monthly</asp:ListItem>
                                                            <asp:ListItem>Doctor Coverage monthly</asp:ListItem>
                                                            <asp:ListItem>Sum of Rx Covered</asp:ListItem>--%>
                                                          <%--  <asp:ListItem>Sum of Rx Covered-BSP</asp:ListItem>
                                                            <asp:ListItem>Sum of Rx Covered-GSP</asp:ListItem>
                                                            <asp:ListItem>Sum of Rx Covered-PSP</asp:ListItem>
                                                            <asp:ListItem>Sum of Rx Covered-GMP</asp:ListItem>
                                                            <asp:ListItem>No of Dr Rx Prescriber</asp:ListItem>
                                                            <asp:ListItem>GMP Dr.-Rx Prescriber</asp:ListItem>--%>
                                                            <%--    <asp:ListItem>No of SFD</asp:ListItem>
    <asp:ListItem>No of DCR-SFD</asp:ListItem>
    <asp:ListItem>No of Rx-SFD</asp:ListItem>
    <asp:ListItem>SFD Visit Coverage</asp:ListItem>
    <asp:ListItem>SFD Rx Coverage</asp:ListItem>
    <asp:ListItem>Productivity Invoice-Return</asp:ListItem>
    <asp:ListItem>Productivity Collection</asp:ListItem>--%>
                                                        </asp:CheckBoxList>

                                                    </div>
                                                </asp:Panel>
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

                                                        <asp:LinkButton OnClick="btnShowGrid_Click" runat="server" ID="submitButton" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                                        </asp:LinkButton>
                                                        <asp:LinkButton runat="server" OnClick="cancelButton_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>



                                                    </div>
                                                </div>

                                            </div>
                                            <div class="col-2">
                                            </div>
                                        </div>



                                        <div class="row">
                                            <div class="col-4">
                                                <h3>Details List</h3>
                                            </div>
                                            <div class="col-6">
                                                <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right" Text="Total Net Amount : 0"></asp:Label>
                                            </div>
                                            <div class="col-2">

                                                <div class="form-group row  pull-right">


                                                    <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>

                                                    <%--   <button type="button" class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" onclick="exportToExcel()"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>
                                                </div>
                                            </div>

                                        </div>
                                        <hr />
                                        <asp:HiddenField ID="_hfTerritoryId" runat="server"></asp:HiddenField>
                                        <div class="table-responsive" id="MainGradeDiv" style="height: 600px">
                                            <%--    <asp:GridView ID="gvSelectedItems" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered">
   
</asp:GridView>--%>

                                            <asp:GridView ID="gvSelectedItems" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered">
                                                <Columns>
                                                    <asp:BoundField DataField="Region" HeaderText="Region" />
                                                    <asp:BoundField DataField="Zone" HeaderText="Zone" />
                                                    <asp:BoundField DataField="Area" HeaderText="Area" />
                                                    <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                                    <asp:BoundField DataField="Territory" HeaderText="Territory" />

                                                    <asp:TemplateField HeaderText="Invoice">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lbInvoice_Click" ID="lbInvoice" Text='<%#Eval("Invoice") %>'></asp:LinkButton>
                                                            <asp:HiddenField ID="hfTerritoryId" runat="server" Value='<%# Eval("TerritoryId") %>'></asp:HiddenField>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Partial Collection">
                                                        <ItemTemplate>


                                                            <asp:LinkButton runat="server" OnClick="lblPartialCollection_Click" ID="lblPartialCollection" Text='<%#Eval("Partial Collection") %>'></asp:LinkButton>

                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Full Collection">
                                                        <ItemTemplate>


                                                            <asp:LinkButton runat="server" OnClick="lblFullCollection_Click" ID="lblFullCollection" Text='<%#Eval("Full Collection") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="FCB Invoice">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblFCBInvoice_Click" ID="lblFCBInvoice" Text='<%#Eval("FCB Invoice") %>'></asp:LinkButton>

                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="FCB Collection">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lblFCBCollection_Click" ID="lblFCBCollection" Text='<%# Eval("FCB Collection") %>'></asp:LinkButton>

                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                  <%--  <asp:TemplateField HeaderText="Campaigns Invoice">
                                                        <ItemTemplate>


                                                            <asp:LinkButton runat="server" OnClick="lblCampaignsInvoice_Click" ID="lblCampaignsInvoice" Text='<%# Eval("Campaigns Invoice") %>'></asp:LinkButton>

                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Campaigns Collection">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lblCampaignsCollection_Click" ID="lblCampaignsCollection" Text='<%# Eval("Campaigns Collection") %>'></asp:LinkButton>


                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>

                                                    <asp:TemplateField HeaderText="General Invoice">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lblGeneralInvoice_Click" ID="lblGeneralInvoice" Text='<%# Eval("General Invoice") %>'></asp:LinkButton>


                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="General Collection">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lblGeneralCollection_Click" ID="lblGeneralCollection" Text='<%# Eval("General Collection") %>'></asp:LinkButton>


                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Institution Invoice">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lblInstitutionInvoice_Click" ID="lblInstitutionInvoice" Text='<%# Eval("Institution Invoice") %>'></asp:LinkButton>

                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Institution Collection">
                                                        <ItemTemplate>

                                                            <asp:LinkButton runat="server" OnClick="lblInstitutionCollection_Click" ID="lblInstitutionCollection" Text='<%# Eval("Institution Collection") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Total Doctor">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblTotalDoctor_Ckick" ID="lblTotalDoctor" Text='<%# Eval("Total Doctor") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of BSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoofBSP_Ckick" ID="lnkNoOfBSP" Text='<%# Eval("No of BSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of GSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoofGSP_Ckick" ID="lnkNoOfGSP" Text='<%# Eval("No of GSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of PSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoofPSP_Ckick" ID="lnkNoOfPSP" Text='<%# Eval("No of PSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of GMP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoofGMP_Ckick" ID="lnkNoOfGMP" Text='<%# Eval("No of GMP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                  <%--  <asp:TemplateField HeaderText="No of HQ Doctor">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoOfHQDoctor_Ckick" ID="lnkNoOfHQDoctor" Text='<%# Eval("No of HQ Doctor") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of Ex. HQ Doctor">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoOfExHQDoctor_Ckick" ID="lnkNoOfExHQDoctor" Text='<%# Eval("No of Ex HQ Doctor") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of OS Doctor">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblNoOfOsDoctor_Ckick" ID="lnkNoOfOSDoctor" Text='<%# Eval("No of OS Doctor") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>

                                                    <asp:TemplateField HeaderText="Sum of DCR-Total">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblDcr_Ckick" ID="lnkSumOfDCRTotal" Text='<%# Eval("Sum of DCR-Total") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of DCR-BSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblDcrBsp_Ckick" ID="lnkSumOfDCRBSP" Text='<%# Eval("Sum of DCR-BSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of DCR-GSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblDcrGsp_Ckick" ID="lnkSumOfDCRGSP" Text='<%# Eval("Sum of DCR-GSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of DCR-PSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblDcrPsp_Ckick" ID="lnkSumOfDCRPSP" Text='<%# Eval("Sum of DCR-PSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of GMP-DCR">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblDcrGmp_Ckick" ID="lnkSumOfGMPDCR" Text='<%# Eval("Sum of GMP-DCR") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                 <%--   <asp:TemplateField HeaderText="GMP-Doctor Coverage monthly">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblGmpDocotorCoverageMonthly_Ckick" ID="lnkGMPDoctorCoverageMonthly" Text='<%# Eval("GMP-Doctor Coverage monthly") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Doctor Coverage monthly">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblDocotorCoverageMonthly_Ckick" ID="lnkDoctorCoverageMonthly" Text='<%# Eval("Doctor Coverage monthly") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of Rx Covered">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxCovered_Ckick" ID="lnkSumOfRxCovered" Text='<%# Eval("Sum of Rx Covered") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>

                                                  <%--  <asp:TemplateField HeaderText="Sum of Rx Covered-BSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxCoveredBSP_Ckick" ID="lnkSumOfRxCoveredBSP" Text='<%# Eval("Sum of Rx Covered-BSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of Rx Covered-GSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxCoveredGSP_Ckick" ID="lnkSumOfRxCoveredGSP" Text='<%# Eval("Sum of Rx Covered-GSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of Rx Covered-PSP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxCoveredPSP_Ckick" ID="lnkSumOfRxCoveredPSP" Text='<%# Eval("Sum of Rx Covered-PSP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Sum of Rx Covered-GMP">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxCoveredGMP_Ckick" ID="lnkSumOfRxCoveredGMP" Text='<%# Eval("Sum of Rx Covered-GMP") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="No of Dr Rx Prescriber">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxPrescriber_Ckick" ID="lnkNoOfDrRxPrescriber" Text='<%# Eval("No of Dr Rx Prescriber") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="GMP Dr.-Rx Prescriber">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" OnClick="lblRxPrescriberGMP_Ckick" ID="lnkGMPDrRxPrescriber" Text='<%# Eval("GMP Dr-Rx Prescriber") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>

                                                    <%--
        <asp:TemplateField HeaderText="HQ Invoice">
            <ItemTemplate>
                <asp:Label ID="lblHQInvoice" runat="server" Text='<%# Eval("HQ_Invoice") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="HQ Collection">
            <ItemTemplate>
                <asp:Label ID="lblHQCollection" runat="server" Text='<%# Eval("HQ_Collection") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="OS Invoice">
            <ItemTemplate>
                <asp:Label ID="lblOSInvoice" runat="server" Text='<%# Eval("OS_Invoice") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="OS Collection">
            <ItemTemplate>
                <asp:Label ID="lblOSCollection" runat="server" Text='<%# Eval("OS_Collection") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Return (TP+VAT)">
            <ItemTemplate>
                <asp:Label ID="lblReturnVAT" runat="server" Text='<%# Eval("ReturnTP_VAT") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="#Chemist-Coverage-Invoice">
            <ItemTemplate>
                <asp:Label ID="lblChemistInvoice" runat="server" Text='<%# Eval("#Chemist-Coverage-Invoice") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="#Chemist-Coverage-Collection">
            <ItemTemplate>
                <asp:Label ID="lblChemistCollection" runat="server" Text='<%# Eval("#Chemist-Coverage-Collection") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Blue Star Invoice">
            <ItemTemplate>
                <asp:Label ID="lblBlueStarInvoice" runat="server" Text='<%# Eval("Blue Star Invoice") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Green Star Invoice">
            <ItemTemplate>
                <asp:Label ID="lblGreenStarInvoice" runat="server" Text='<%# Eval("Green Star Invoice") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Sales Campaign Invoice">
            <ItemTemplate>
                <asp:Label ID="lblSalesCampaignInvoice" runat="server" Text='<%# Eval("Sales Campaign Invoice") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="No of Dr Rx Prescriber">
            <ItemTemplate>
                <asp:Label ID="lblRxPrescriber" runat="server" Text='<%# Eval("No of Dr Rx Prescriber") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="SFD Rx Coverage">
            <ItemTemplate>
                <asp:Label ID="lblSFDRxCoverage" runat="server" Text='<%# Eval("SFD Rx Coverage") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Productivity Invoice-Return">
            <ItemTemplate>
                <asp:Label ID="lblProductivityInvoiceReturn" runat="server" Text='<%# Eval("Productivity Invoice-Return") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Productivity Collection">
            <ItemTemplate>
                <asp:Label ID="lblProductivityCollection" runat="server" Text='<%# Eval("Productivity Collection") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>--%>
                                                </Columns>
                                            </asp:GridView>



                                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                                <Columns>
                                                    <%-- <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                                    <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                                    <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />

                                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                    <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                                    <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />

                                                    <asp:BoundField DataField="IntransitDay" HeaderText=" Customer Type" />

                                                    <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                                    <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                                    <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                                    <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                                    <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                                    <asp:BoundField DataField="Quantity" HeaderText="Order Qty" />

                                                    <asp:BoundField
                                                        DataField="GrossValue" HeaderText="TP" />
                                                    <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                                    <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                                    <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                                    <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                                    <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Amount" />


                                                    <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                                    <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                                    <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                                    <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  EMP Code" />
                                                    <asp:BoundField DataField="MIOEmpName" HeaderText="MIO EMP Name" />

                                                    <asp:BoundField DataField="AMEmpCode" HeaderText="Area Code" />

                                                    <asp:BoundField DataField="AMEmpName" HeaderText="Area Name" />

                                                    <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />




                                                    <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                                    <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />

                                                    <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />

                                                    <%--    <asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />
                                    <asp:BoundField DataField="AMEmpName" HeaderText="AM Name" />

                                    <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Name" />


                                     <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                     
                                       <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                    <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />

                                      <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                    <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                    <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                   
                                  
                                 
                                  

                            
                                    <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Type" />--%>
                                                </Columns>
                                                <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                            </asp:GridView>
                                        </div>
                               <%-- </ContentTemplate>
                                <Triggers>

                                    <asp:PostBackTrigger ControlID="btnExport" />
                                </Triggers>
                            </asp:UpdatePanel>--%>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopup" Style="display: none; width: 400px; background-color: #fff; padding: 20px; border-radius: 5px;">
        <h3>Invoice Details</h3>

        <br />
        <br />
        <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-danger" OnClick="btnClose_Click" />
    </asp:Panel>

    <asp:Button ID="btnShowPopup" runat="server" Style="display: none;" />

    <cc1:ModalPopupExtender ID="mpePopup" runat="server" TargetControlID="btnShowPopup" PopupControlID="pnlPopup"
        BackgroundCssClass="modalBackground" />


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

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Invoice Details  </h3>
                        <asp:Label ID="lblInvoiceCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportInvoice" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportInvoice_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModal_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_Invoice" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />

                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />

                                <asp:BoundField DataField="IntransitDay" HeaderText=" Customer Type" />

                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                <asp:BoundField DataField="Quantity" HeaderText="Order Qty" />

                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Amount" />


                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  EMP Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO EMP Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="Area Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="Area Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />




                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />

                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>


     <!-- Modal Popup For Total Doctor Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="TotalDoctorModalPopupExtender" runat="server" TargetControlID="hnd_Test2" PopupControlID="pnl_2"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test2" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_2" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="TotalDoctorUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Total Doctor List</h3>
                        <asp:Label ID="lblTotalDoctorList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportTotalDoctor" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportTotalDoctor_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal2" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalTotalDoctor_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_TotalDoctor" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportTotalDoctor" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For Total Doctor End-->

    <!-- Modal Popup For No of BSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofBSPPopupExtender" runat="server" TargetControlID="hnd_Test3" PopupControlID="pnl_3"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test3" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_3" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="NoOfBspUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">No Of BSP List</h3>
                        <asp:Label ID="lblNoOfBspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportNoOfBsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportNoOfBsp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal3" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalNoOfBsp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_NoofBSP" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportNoOfBsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of BSP End-->

    <!-- Modal Popup For No of GSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofGSPPopupExtender" runat="server" TargetControlID="hnd_Test4" PopupControlID="pnl_4"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test4" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_4" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="NoOfGspUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">No Of GSP List</h3>
                        <asp:Label ID="lblNoOfGspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportNoOfGsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportNoOfGsp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal4" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalNoOfGsp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_NoofGSP" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportNoOfGsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of GSP End-->

    <!-- Modal Popup For No of PSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofPSPPopupExtender" runat="server" TargetControlID="hnd_Test5" PopupControlID="pnl_5"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test5" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_5" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="NoOfPspUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">No Of PSP List</h3>
                        <asp:Label ID="lblNoOfPspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportNoOfPsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportNoOfPsp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal5" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalNoOfPsp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_NoofPSP" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportNoOfPsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of PSP End-->

    <!-- Modal Popup For No of GMP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofGMPPopupExtender" runat="server" TargetControlID="hnd_Test6" PopupControlID="pnl_6"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test6" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_6" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="NoOfGmpUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">No Of GMP List</h3>
                        <asp:Label ID="lblNoOfGmpList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportNoOfGmp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportNoOfGmp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal6" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalNoOfGmp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_NoofGMP" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportNoOfGmp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of GMP End-->

    <!-- Modal Popup For No of HQ Doctor Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofHQDOCTORPopupExtender" runat="server" TargetControlID="hnd_Test7" PopupControlID="pnl_7"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test7" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_7" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="HqDoctorUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">HQ Doctor List</h3>
                        <asp:Label ID="lblHqDoctorList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportHqDoctor" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportHqDoctor_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal7" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalHqDoctor_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_HqDoctor" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportHqDoctor" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of HQ Doctor End-->

    <!-- Modal Popup For No of Ex HQ Doctor Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofExHQDOCTORPopupExtender" runat="server" TargetControlID="hnd_Test8" PopupControlID="pnl_8"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test8" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_8" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="ExHqDoctorUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Ex HQ Doctor List</h3>
                        <asp:Label ID="lblExHqDoctorList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportExHqDoctor" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportExHqDoctor_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal8" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalExHqDoctor_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_ExHqDoctor" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportExHqDoctor" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of Ex HQ Doctor End-->

    <!-- Modal Popup For No of Os Doctor Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="NoofOsDOCTORPopupExtender" runat="server" TargetControlID="hnd_Test9" PopupControlID="pnl_9"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test9" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_9" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="OsDoctorUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Os Doctor List</h3>
                        <asp:Label ID="lblOsDoctorList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportOsDoctor" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportOsDoctor_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal9" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalOsDoctor_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_OsDoctor" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />

                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />
                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MarketCode" HeaderText=" Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />
                                <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportOsDoctor" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of Os Doctor End-->

    <!-- Modal Popup For No of DCR Total Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="DCRPopupExtender" runat="server" TargetControlID="hnd_Test10" PopupControlID="pnl_10"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test10" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_10" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="DCRUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">DCR List</h3>
                        <asp:Label ID="lblDcrList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportDCR" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportDCR_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal10" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalDCR_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_Dcr" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportDCR" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of DCR Total End-->

    <!-- Modal Popup For No of DCR BSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="DCRBspPopupExtender" runat="server" TargetControlID="hnd_Test11" PopupControlID="pnl_11"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test11" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_11" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="DCRBspUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">DCR BSP List</h3>
                        <asp:Label ID="lblDcrBspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportDCRBsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportDCRBsp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal11" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalDCRBsp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_DcrBsp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportDCRBsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of DCR BSP End-->

    <!-- Modal Popup For No of DCR GSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="DCRGspPopupExtender" runat="server" TargetControlID="hnd_Test12" PopupControlID="pnl_12"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test12" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_12" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="DCRGspUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">DCR GSP List</h3>
                        <asp:Label ID="lblDcrGspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportDCRGsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportDCRGsp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal12" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalDCRGsp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_DcrGsp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportDCRGsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of DCR GSP End-->

    <!-- Modal Popup For No of DCR PSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="DCRPspPopupExtender" runat="server" TargetControlID="hnd_Test13" PopupControlID="pnl_13"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test13" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_13" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="DCRPspUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">DCR PSP List</h3>
                        <asp:Label ID="lblDcrPspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportDCRPsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportDCRPsp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal13" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalDCRPsp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_DcrPsp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportDCRPsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of DCR PSP End-->

    <!-- Modal Popup For No of DCR GMP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="DCRGmpPopupExtender" runat="server" TargetControlID="hnd_Test14" PopupControlID="pnl_14"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test14" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_14" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="DCRGmpUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">DCR GMP List</h3>
                        <asp:Label ID="lblDcrGmpList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportDCRGmp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportDCRGmp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal14" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalDCRGmp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_DcrGmp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportDCRGmp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For No of DCR GMP End-->

    <!-- Modal Popup For GMP-Doctor Coverage monthly Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="GmpDocotorCoveragePopupExtender" runat="server" TargetControlID="hnd_Test15" PopupControlID="pnl_15"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test15" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_15" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="GmpDocotorCoverageUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Gmp Docotor Coverage Monthly List</h3>
                        <asp:Label ID="lblGmpDocotorCoverageList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportGmpDocotorCoverage" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportGmpDocotorCoverage_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal15" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalGmpDocotorCoverage_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_GmpDocotorCoverage" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportGmpDocotorCoverage" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For GMP-Doctor Coverage monthly End-->

    <!-- Modal Popup For Doctor Coverage monthly Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="DocotorCoverageMonthlyPopupExtender" runat="server" TargetControlID="hnd_Test16" PopupControlID="pnl_16"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test16" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_16" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="DocotorCoverageMonthlyUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Doctor Coverage Monthly List</h3>
                        <asp:Label ID="lblDocotorCoverageMonthlyList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportDocotorCoverageMonthly" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportDocotorCoverageMonthly_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal16" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalDocotorCoverageMonthly_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_DocotorCoverageMonthly" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                <asp:BoundField DataField="DoctorAddress" HeaderText="Doctor Address" />

                                <asp:BoundField DataField="DcrDate" HeaderText="DCR Date" />
                                <asp:BoundField DataField="TourTypeName" HeaderText="Visit Type" />
                                <asp:BoundField DataField="VisitedWith" HeaderText="Visited With" />
                                <asp:BoundField DataField="ChamberName" HeaderText="Chamber" />

                                <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>


                                        <a data-toggle='tooltip' title='Show in map' target='_blank' style='font-size: 20px' href='<%# "http://maps.google.com/?q=" +Eval("POutLoc")%>  ' class='bx bx-location-plus'></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="StreetAddress" HeaderText="Visited Location" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportDocotorCoverageMonthly" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For Doctor Coverage monthly End-->

    <!-- Modal Popup For  Rx Covered Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxCoveredPopupExtender" runat="server" TargetControlID="hnd_Test17" PopupControlID="pnl_17"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test17" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_17" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxCoveredUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Rx Covered List</h3>
                        <asp:Label ID="lblRxCoveredList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxCovered" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxCovered_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal17" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxCovered_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxCovered" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxCovered" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  Rx Covered End-->

    <!-- Modal Popup For  Rx Covered-BSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxCoveredBSPPopupExtender" runat="server" TargetControlID="hnd_Test18" PopupControlID="pnl_18"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test18" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_18" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxCoveredBSPUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Rx Covered BSP List</h3>
                        <asp:Label ID="lblRxCoveredBspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxCoveredBsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxCoveredBSP_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal18" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxCoveredBSP_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxCoveredBsp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxCoveredBsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  Rx Covered-BSP End-->

    <!-- Modal Popup For  Rx Covered-GSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxCoveredGSPPopupExtender" runat="server" TargetControlID="hnd_Test19" PopupControlID="pnl_19"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test19" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_19" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxCoveredGSPUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Rx Covered GSP List</h3>
                        <asp:Label ID="lblRxCoveredGspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxCoveredGsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxCoveredGSP_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal19" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxCoveredGSP_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxCoveredGsp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxCoveredGsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  Rx Covered-GSP End-->

    <!-- Modal Popup For  Rx Covered-PSP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxCoveredPSPPopupExtender" runat="server" TargetControlID="hnd_Test20" PopupControlID="pnl_20"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test20" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_20" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxCoveredPSPUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Rx Covered PSP List</h3>
                        <asp:Label ID="lblRxCoveredPspList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxCoveredPsp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxCoveredPSP_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal20" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxCoveredPSP_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxCoveredPsp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxCoveredPsp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  Rx Covered-PSP End-->

    <!-- Modal Popup For  Rx Covered-GMP Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxCoveredGMPPopupExtender" runat="server" TargetControlID="hnd_Test21" PopupControlID="pnl_21"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test21" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_21" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxCoveredGMPUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Rx Covered GMP List</h3>
                        <asp:Label ID="lblRxCoveredGmpList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxCoveredGmp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxCoveredGMP_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal21" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxCoveredGMP_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxCoveredGmp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>

                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxCoveredGmp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  Rx Covered-GMP End-->

    <!-- Modal Popup For  Dr Rx Prescriber Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxPrescriberPopupExtender" runat="server" TargetControlID="hnd_Test22" PopupControlID="pnl_22"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test22" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_22" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxPrescriberUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Doctor Rx Prescriber List</h3>
                        <asp:Label ID="lblRxPrescriberList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxPrescriber" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxPrescriber_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal22" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxPrescriber_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxPrescriber" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxPrescriber" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  Dr Rx Prescriber End-->

    <!-- Modal Popup For  GMP Dr.-Rx Prescriber Start-->
    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="RxPrescriberGmpPopupExtender" runat="server" TargetControlID="hnd_Test23" PopupControlID="pnl_23"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="hnd_Test23" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="pnl_23" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="RxPrescriberGmpUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">GMP Dr. Rx Prescriber List</h3>
                        <asp:Label ID="lblRxPrescriberGmpList" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportRxPrescriberGmp" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportRxprescriberGmp_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModal23" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalRxprescriberGmp_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_RxPrescriberGmp" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>

    <asp:TemplateField HeaderText="SL">
        <ItemTemplate>
            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

        </ItemTemplate>
    </asp:TemplateField>
    <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

    <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
    <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
    <asp:BoundField DataField="createBy" HeaderText="Create By" />

    <asp:TemplateField HeaderText="Image">
        <ItemTemplate>
            <a href='<%#Eval("ImageString")%>'
                id="hpImg"
                runat="server" class="fancybox ">

                <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
            </a>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

</Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportRxPrescriberGmp" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>
    <!-- Modal Popup For  GMP Dr.-Rx Prescriber End-->


    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="FCBInvoicempe_1" runat="server" TargetControlID="FCBInvoicehnd_Test" PopupControlID="FCBInvoicepnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="FCBInvoicehnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="FCBInvoicepnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="FCBInvoiceUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">FCB Invoice Details  </h3>
                        <asp:Label ID="lblFCBInvoiceCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportFCBInvoice" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportFCBInvoice_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModalFCBInvoice" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalFCBInvoice_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_FCBInvoice" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />

                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />

                                <asp:BoundField DataField="IntransitDay" HeaderText=" Customer Type" />

                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                <asp:BoundField DataField="Quantity" HeaderText="Order Qty" />

                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Amount" />


                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  EMP Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO EMP Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="Area Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="Area Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />




                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />

                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>



    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="GeneralInvoicempe_1" runat="server" TargetControlID="GeneralInvoichnd_Test" PopupControlID="GeneralInvoicpnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="GeneralInvoichnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="GeneralInvoicpnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="GeneralInvoicUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">General Invoice Details  </h3>
                        <asp:Label ID="lblGeneralInvoiceCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportGeneralInvoice" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportGeneralInvoice_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModalGeneralInvoice" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalGeneralInvoice_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_GeneralInvoice" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />

                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />

                                <asp:BoundField DataField="IntransitDay" HeaderText=" Customer Type" />

                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                <asp:BoundField DataField="Quantity" HeaderText="Order Qty" />

                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Amount" />


                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  EMP Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO EMP Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="Area Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="Area Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />




                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />

                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>




    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="InstitutionInvoicempe_1" runat="server" TargetControlID="InstitutionInvoicehnd_Test" PopupControlID="InstitutionInvoicepnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="InstitutionInvoicehnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="InstitutionInvoicepnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="InstitutionInvoiceUpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Institution Invoice Details  </h3>
                        <asp:Label ID="lblInstitutionInvoiceCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnExportInstitutionInvoice" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportInstitutionInvoice_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnCloseModalInstitutionInvoice" runat="server" Text="X" CssClass="btn-danger" OnClick="btnCloseModalInstitutionInvoice_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_InstitutionInvoice" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center" />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />

                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />

                                <asp:BoundField DataField="IntransitDay" HeaderText=" Customer Type" />

                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <%--<asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />--%>

                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" />
                                <asp:BoundField DataField="Quantity" HeaderText="Order Qty" />

                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Amount" />


                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  EMP Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO EMP Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="Area Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="Area Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />




                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />

                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />

                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>


    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="Partialmpe_1" runat="server" TargetControlID="Partialhnd_Test" PopupControlID="Partialpnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="Partialhnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="Partialpnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="UpdatePanel1Partial" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Partial Collection Details  </h3>
                        <asp:Label ID="lblPartialInvoiceCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="btnPartialExportInvoice" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportInvoice_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="btnPartialCloseModal" runat="server" Text="X" CssClass="btn-danger" OnClick="btnPartialCloseModal_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">
                        <asp:GridView ID="gv_PartialCollecion" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" ShowFooter="true" PageIndex="0">
                            <Columns>
                                <%-- <asp:TemplateField HeaderText="SL">
    <ItemTemplate>
        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
     
    </ItemTemplate>
</asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Distribution Center Code" />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center Name" />
                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />
                                <asp:BoundField DataField="CellNo" HeaderText="Customer Mobile No." />
                                <asp:BoundField DataField="SpecialAmount" HeaderText="Customer Type" />
                                <asp:BoundField DataField="OrderNo" HeaderText="Order NO" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order Date" />
                                <%--       <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />--%>
                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice NO" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />
                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                <asp:BoundField DataField="IntransitDay" HeaderText="Number of Days In-Transit" />
                                <asp:BoundField DataField="ReturnAmount" HeaderText="Net Amount" />
                                <asp:BoundField DataField="CustomerPaymentAmount" HeaderText="Paid Amount" />
                                <asp:BoundField DataField="ReceivableTotalAmnt" HeaderText="Receivable Amount" />


                                <asp:BoundField DataField="Territory" HeaderText="Territory " />
                                <asp:BoundField DataField="AMCode" HeaderText="AM Emp Code" />
                                <asp:BoundField DataField="DZSMCode" HeaderText="DZSM Emp Code" />
                                <asp:BoundField DataField="MainMIOCODE" HeaderText="MIO Emp Code" />
                                <asp:BoundField DataField="MainMIONAME" HeaderText="MIO Emp Name" />

                                <%--<asp:BoundField DataField="CustomerAddress" HeaderText="Customer Address" />--%>
                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />



                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>

    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="mpeFullCollection" runat="server" TargetControlID="FullCollectionhnd_Test" PopupControlID="FullCollectionpnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="FullCollectionhnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="FullCollectionpnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Full Collection Details  </h3>
                        <asp:Label ID="lblFullCollectionCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="lbFullCollectionExport" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="lbFullCollectionExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="FullCollectionClose" runat="server" Text="X" CssClass="btn-danger" OnClick="FullCollectionClose_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">

                        <asp:GridView ID="gv_FullColection" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" OnPreRender="gv_DocumentUpload_PreRender">
                            <Columns>

                                <%--  <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center " />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />


                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />


                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="NewType" HeaderText="Customer Type" />
                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />

                                <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Payment Number" />
                                <asp:BoundField DataField="UpdateDate" HeaderText="Payment Date" />

                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" DataFormatString="{0:n}" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                <asp:BoundField DataField="soldQty" HeaderText="Sold Qty" />



                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" HtmlEncodeFormatString="true" HtmlEncode="true" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Payment" />

                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  Emp Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Emp Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="AM Emp Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="AM Emp Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaName" HeaderText="Area Code" />
                                <%--<asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />--%>




                                <%--   <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                
                                 
                                  
                                     <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />--%>
                                <%--     <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />--%>


                                <%--<asp:BoundField DataField="MainMIOCODE" HeaderText="MIO CODE" />--%>

                                <asp:BoundField DataField="Brand" HeaderText="Brand" />

                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />
                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />
                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>




    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="mpeFCBCollection" runat="server" TargetControlID="FCBCollectionhnd_Test" PopupControlID="FCBCollectionpnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="FCBCollectionhnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="FCBCollectionpnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="FCBUpdatePanel3" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">FCB Collection Details  </h3>
                        <asp:Label ID="lblFCBCollectionCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="lbFCBCollectionExport" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="lbFCBCollectionExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="FCBCollectionClose" runat="server" Text="X" CssClass="btn-danger" OnClick="FCBCollectionClose_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">

                        <asp:GridView ID="gv_FCBColection" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" OnPreRender="gv_DocumentUpload_PreRender">
                            <Columns>

                                <%--  <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center " />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />


                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />


                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="NewType" HeaderText="Customer Type" />
                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />

                                <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Payment Number" />
                                <asp:BoundField DataField="UpdateDate" HeaderText="Payment Date" />

                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" DataFormatString="{0:n}" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                <asp:BoundField DataField="soldQty" HeaderText="Sold Qty" />



                                <asp:BoundField DataField="GrossValue" HeaderText="TP" HtmlEncodeFormatString="true" HtmlEncode="true" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Payment" />

                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  Emp Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Emp Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="AM Emp Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="AM Emp Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaName" HeaderText="Area Code" />
                                <%--<asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />--%>




                                <%--   <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                
                                 
                                  
                                     <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />--%>
                                <%--     <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />--%>


                                <%--<asp:BoundField DataField="MainMIOCODE" HeaderText="MIO CODE" />--%>

                                <asp:BoundField DataField="Brand" HeaderText="Brand" />

                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />
                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />
                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>




    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="mpeGeneralCollection" runat="server" TargetControlID="GeneralCollectionhnd_Test" PopupControlID="GeneralCollectionpnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="GeneralCollectionhnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="GeneralCollectionpnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="GeneralUpdatePanel3" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">General Collection Details  </h3>
                        <asp:Label ID="lblGeneralCollectionCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="lbGeneralCollectionExport" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="lbGeneralCollectionExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="GeneralCollectionClose" runat="server" Text="X" CssClass="btn-danger" OnClick="GeneralCollectionClose_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">

                        <asp:GridView ID="gv_GeneralColection" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" OnPreRender="gv_DocumentUpload_PreRender">
                            <Columns>

                                <%--  <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center " />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />


                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />


                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="NewType" HeaderText="Customer Type" />
                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />

                                <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Payment Number" />
                                <asp:BoundField DataField="UpdateDate" HeaderText="Payment Date" />

                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" DataFormatString="{0:n}" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                <asp:BoundField DataField="soldQty" HeaderText="Sold Qty" />



                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" HtmlEncodeFormatString="true" HtmlEncode="true" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Payment" />

                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  Emp Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Emp Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="AM Emp Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="AM Emp Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaName" HeaderText="Area Code" />
                                <%--<asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />--%>




                                <%--   <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                
                                 
                                  
                                     <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />--%>
                                <%--     <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />--%>


                                <%--<asp:BoundField DataField="MainMIOCODE" HeaderText="MIO CODE" />--%>

                                <asp:BoundField DataField="Brand" HeaderText="Brand" />

                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />
                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />
                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
    </div>




    <div>
        <!-- Modal Popup Extender -->
        <cc1:ModalPopupExtender ID="mpeInstitutionCollection" runat="server" TargetControlID="InstitutionCollectionhnd_Test" PopupControlID="InstitutionCollectionpnl_1"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:HiddenField ID="InstitutionCollectionhnd_Test" runat="server"></asp:HiddenField>

        <!-- Modal Panel -->
        <asp:Panel ID="InstitutionCollectionpnl_1" runat="server" Style="display: none; padding: 10px; border: 1px solid #ccc; background-color: white; border-radius: 10px;"
            Height="680px" Width="90%" CssClass="modalPopup">

            <asp:UpdatePanel ID="InstitutionsssUpdatePanel3" runat="server">
                <ContentTemplate>

                    <!-- Modal Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #007bff; color: white; border-radius: 5px 5px 0 0;">
                        <h3 style="margin: 0;">Institution Collection Details  </h3>
                        <asp:Label ID="lblInstitutionCollectionCount" runat="server" Text=""></asp:Label>
                        <asp:LinkButton ID="lbInstitutionCollectionExport" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="lbInstitutionCollectionExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                        <asp:Button ID="InstitutionCollectionClose" runat="server" Text="X" CssClass="btn-danger" OnClick="InstitutionCollectionClose_Click" />
                    </div>

                    <!-- Modal Body -->
                    <div class="table-responsive" style="height: 600px; margin-top: 20px">

                        <asp:GridView ID="gv_InstitutionColection" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" OnPreRender="gv_DocumentUpload_PreRender">
                            <Columns>

                                <%--  <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                <asp:BoundField DataField="ComUnitCode" HeaderText="Sales Center " />
                                <asp:BoundField DataField="ComUnitName" HeaderText="Sales Center Name" />


                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />


                                <asp:BoundField DataField="Type" HeaderText="Provider Type" />
                                <asp:BoundField DataField="SMCType_Ord" HeaderText="Pharma Platform" />
                                <asp:BoundField DataField="NewType" HeaderText="Customer Type" />
                                <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" />
                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Number" />
                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" />

                                <asp:BoundField DataField="DelivaryInvoiceNo" HeaderText="Payment Number" />
                                <asp:BoundField DataField="UpdateDate" HeaderText="Payment Date" />

                                <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                <asp:BoundField DataField="BatchNo" DataFormatString="{0:n}" HeaderText="Batch No" />
                                <asp:BoundField DataField="ExpDate" HeaderText="Exp Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                <asp:BoundField DataField="soldQty" HeaderText="Sold Qty" />



                                <asp:BoundField
                                    DataField="GrossValue" HeaderText="TP" HtmlEncodeFormatString="true" HtmlEncode="true" />
                                <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

                                <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

                                <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



                                <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

                                <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Payment" />

                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />

                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />

                                <asp:BoundField DataField="MIOEmpCode" HeaderText="MIO  Emp Code" />
                                <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Emp Name" />

                                <asp:BoundField DataField="AMEmpCode" HeaderText="AM Emp Code" />

                                <asp:BoundField DataField="AMEmpName" HeaderText="AM Emp Name" />

                                <asp:BoundField DataField="RegionName" HeaderText="Zone Code" />
                                <asp:BoundField DataField="AreaName" HeaderText="Area Code" />
                                <%--<asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />--%>




                                <%--   <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                
                                 
                                  
                                     <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />--%>
                                <%--     <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />--%>


                                <%--<asp:BoundField DataField="MainMIOCODE" HeaderText="MIO CODE" />--%>

                                <asp:BoundField DataField="Brand" HeaderText="Brand" />

                                <asp:BoundField DataField="ProductOffer" HeaderText="Campaign Name" />
                                <asp:BoundField DataField="CampaignCategory" HeaderText="Campaign Category" />
                                <asp:BoundField DataField="paymenttype" HeaderText="Payment Type" />
                            </Columns>
                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                        </asp:GridView>
                    </div>



                </ContentTemplate>
                <Triggers>

                    <asp:PostBackTrigger ControlID="btnExportInvoice" />
                </Triggers>
            </asp:UpdatePanel>

        </asp:Panel>
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

