<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PendingSalesConfirmationReport.aspx.cs" Inherits="SInventory_UI_PendingSalesConfirmationReport" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style type="text/css">
        .excel-button {
            margin-left: 5px;
        }
    </style>

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
                <div class="breadcrumb-title pe-3">
                    <i class="bx bx-customize"></i>Pending Sales Confirmation Report

                </div>

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

                                        




                                            <div class="form-group row" visible="True" id="DIVDC">
                                                <label for="mainName" class="col-sm-5 col-form-label">Sales Center :</label>

                                                <div class="col-sm-7">



                                                    <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                                        AutoPostBack="True" OnSelectedIndexChanged="dcDropDownList1_SelectedIndexChanged">
                                                    </asp:DropDownList>


                                                </div>

                                            </div>

                                            <div class="form-group row" runat="server" >
                                                <label for="mainName" class="col-sm-5 col-form-label">From Date:</label>

                                                <div class="col-sm-7">
                                                    <asp:TextBox ID="InvoiceDateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>



                                                </div>
                                            </div>

                                            <div class="form-group row" runat="server"  >
                                                <label for="mainName" class="col-sm-5 col-form-label">To Date:</label>

                                                <div class="col-sm-7">

                                                    <asp:TextBox ID="todateTextBox" runat="server" CssClass="form-control form-control-sm mb-3 datepicker"></asp:TextBox>




                                                </div>

                                            </div>


                                        </div>

                                        <div class="col-8" runat="server" visible="false">
                                            <%--<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />--%>
                                        </div>
                                    </div>

                                    <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                                                    <asp:LinkButton OnClick="SearchButton_Click" runat="server" ID="SearchButton" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-search" aria-hidden="true"></i>&nbsp; Search
                                                    </asp:LinkButton>
                                                    <asp:LinkButton OnClick="excelButton_OnClick" Visible="False" runat="server" ID="excelButton" class="btn btnMyDesignSearch   btn-sm">
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; Export to Excel
                                                    </asp:LinkButton>

                                                    <asp:LinkButton runat="server" OnClick="Unnamed_Click" class="btn btnMyDesignReset   btn-sm"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>




                                                    <asp:DropDownList ID="marketDropDownList" Visible="false" runat="server" CssClass="DropDown">
                                                    </asp:DropDownList>

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

                                                <%-- <a  id="btngv"  style="background-color: #1A7343; color: #fff;" onclick="tableToExcel('testTable', 'W3C Example Table')" title="Export to Excel"   class="btn btn-sm   mb-2"  ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel</a>--%>

                                                <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2" Style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>


                                                <%--         <button type="button"  class="btn btn-sm   mb-2"  style="background-color: #1A7343; color: #fff;" onclick="exportToExcel()"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>
                                            </div>
                                        </div>

                                    </div>
                                    <hr />


                                    <div class="table-responsive" id="MainGradeDiv" style="height: 600px;">

                                        <div>
                                            <p>Pending Sales Confirmation Report</p>
                                        </div>

                                        <%--onrowcommand="loadGridView_RowCommand"--%>

                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging"
                                            CssClass="table table-striped table-bordered" ShowFooter="true">
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
                                                <asp:BoundField DataField="OrderNo" HeaderText="Order NO" />
                                                <asp:BoundField DataField="OrderDate" HeaderText="Order Date"  DataFormatString="{0:dd-MMM-yyyy}"/>
                                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice NO" />
                                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date"  DataFormatString="{0:dd-MMM-yyyy}"/>
                                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                              
                                                    <%--<asp:TemplateField HeaderText="Amount">
                                                        <ItemTemplate>
                                                            <asp:Label   runat="server" ID="lblTpGrandTotal" Text='<%#Eval("TpGrandTotal")%>' />

                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>

                                                  <asp:BoundField
      DataField="GrossValue" HeaderText="TP" />
  <asp:BoundField DataField="TotalVat" HeaderText="VAT" />

  <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />

  <%--    <asp:BoundField DataField="" HeaderText="Special Discount" />--%>



  <asp:BoundField DataField="AdjustmentAmount" HeaderText="Exp. Adjustment" />

  <asp:BoundField DataField="TotalNetPayable" HeaderText=" Net Amount" />



                                                
                                                <asp:BoundField DataField="Territory" HeaderText="Territory " />
                                                <asp:BoundField DataField="AMCode" HeaderText="AM Emp Code" />
                                                <asp:BoundField DataField="DZSMCode" HeaderText="DZSM Emp Code" />
                                                <asp:BoundField DataField="MainMIOCODE" HeaderText="MIO Emp Code" />
                                                <asp:BoundField DataField="MainMIONAME" HeaderText="MIO Emp Name" />





                                            </Columns>
                                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                        </asp:GridView>
                                    </div>

                                </ContentTemplate>
                                <Triggers>

                                    <asp:PostBackTrigger ControlID="btnExport" />
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
                download: "Receivable Report Report.xls"
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

