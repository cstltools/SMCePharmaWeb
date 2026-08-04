<%@ Page Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CustomerPaymentDelete.aspx.cs" Inherits="SInventory_UI_CustomerPaymentDelete" %>

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
                        <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Customer Payment Delete </div>

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
                                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                                <ProgressTemplate>

                                                    <div class="divWaiting">
                                                        <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                                    </div>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>

                                            <div class="row">
                                                <div class="col-2"></div>
                                                <div class="col-6">
                                                    <div class="form-group row">

                                                        <label for="mainName2" class="col-sm-5 col-form-label">Depo Name:<span class="text-sm-left text-c-red">*</span></label>

                                                        <div class="col-sm-7">
                                                            <asp:DropDownList ID="DepoNameDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                                                AutoPostBack="True" OnSelectedIndexChanged="depoNameDropDownList_SelectedIndexChanged">
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
                                                    </div>
                                                </div>
                                                 
                                            </div>

                                      
                                             <div class="row">
         <div class="col-2"></div>
     <div class="col-6">
         <div class="form-group row" runat="server">
             <label for="mainName" class="col-sm-5 col-form-label">Route:  <span style="color: red">*</span></label>
             <div class="col-sm-7">
                  <asp:DropDownList ID="rootDropDownList" AutoPostBack="true" OnSelectedIndexChanged="rootDropDownList_SelectedIndexChanged" runat="server" CssClass="form-control form-control-sm mySelect2 "
        >
    </asp:DropDownList>

             </div>
         </div>
     </div>
  
 </div>
                                            
                                            <div class="row" style="display:none">
                                                <div class="col-4"></div>
                                                <div class="col-4">
                                                    <div class="form-group row" runat="server">
                                                        <label for="mainName" class="col-sm-5 col-form-label">From Date:  <span style="color: red">*</span></label>
                                                        <div class="col-sm-7">
                                                            <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" OnTextChanged="DateTextBox_TextChanged" AutoPostBack="True" autocomplete="off" placeholder="Select From Date"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-4"></div>
                                            </div>


                                            <div class="row" style="display:none">
                                                <div class="col-4"></div>
                                                <div class="col-4">
                                                    <div class="form-group row" runat="server">
                                                        <label for="mainName" class="col-sm-5 col-form-label">To Date:  <span style="color: red">*</span></label>
                                                        <div class="col-sm-7">
                                                            <asp:TextBox ID="toDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" AutoPostBack="True" OnTextChanged="DateTextBox_TextChanged" autocomplete="off" placeholder="Select To Date"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-4"></div>
                                            </div>


                                            <div class="row">
                                                     <div class="col-2"></div>
     <div class="col-6">
                                                    <div class="form-group row">

                                                        <label for="mainName" class="col-sm-5 col-form-label">Invoice No:<span class="text-sm-left text-c-red">*</span></label>

                                                        <div class="col-sm-7">
                                                            <asp:DropDownList ID="InvoiceNoDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                                                AutoPostBack="True" OnSelectedIndexChanged="invoiceNoDropDownList_SelectedIndexChanged">
                                                            </asp:DropDownList>
 
                                                        </div>
                                                    </div>
                                                </div>
                                              
                                            </div>


                                            <br />
                                            
                                            <div class="row">

                                                <div class="row mt-2">


                                                    <div class="col-4">
                                                        <h5><i class="fa fa-list" aria-hidden="true"></i>Payment List </h5>
                                                    </div>
                                                    <div class="col-5">
                                                    </div>
                                                    <div class="col-3">

                                                    </div>

                                                </div>


                                                <div class="row" style="margin-top: 10px;">
                                                    <div class="table-responsive" id="MainGradeDiv">
                                                        <asp:GridView ID="invoiceGridView" runat="server"
                                                            AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" OnRowDataBound="invoiceGridView_RowDataBound" OnRowCommand="invoiceGridView_RowCommand" DataKeyNames="CustPayDetailId">
                                                            <Columns>
                                                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                                                <asp:BoundField DataField="PaymentAmount" HeaderText="Payment Amount" />
                                                                <asp:BoundField DataField="custPaymentDate" HeaderText="Payment Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                                <asp:TemplateField HeaderText="Remarks">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="remarksText" runat="server"  AutoPostBack="True"
                                                                            CssClass="form-control form-control-sm"></asp:TextBox>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Delete">
                                                                    <ItemTemplate>
                                                                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-danger btn-sm"
                                                                            CommandName="DeleteRow" CommandArgument='<%# Eval("CustPayDetailId") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
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

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

