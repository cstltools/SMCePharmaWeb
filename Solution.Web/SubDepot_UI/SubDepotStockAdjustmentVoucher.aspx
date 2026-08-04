<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubDepotStockAdjustmentVoucher.aspx.cs" Inherits="SubDepot_UI_SubDepotStockAdjustmentVoucher" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Sub Depot Stock Adjustments Voucher </div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                          <a href="SubDepotStockAdjustmentVoucherView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                      
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
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Distribution Center:</label>

                                                <div class="col-sm-5">
                                                       <asp:DropDownList ID="DistributioncenterDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"  OnSelectedIndexChanged="DistributioncenterDropDownList1_OnSelectedIndexChanged">
                            </asp:DropDownList>
                                                  
                                                   </div>
                                                   </div>


                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Sub Invoice No:</label>

                                                <div class="col-sm-5">
                                                       <asp:TextBox ID="txtSubDepotInvoice" runat="server" CssClass="form-control form-control-sm mb-3" 
                                     AutoPostBack="True" ontextchanged="SubDepotInvoice_TextChanged"></asp:TextBox>
                        <asp:AutoCompleteExtender ID="SubDepotInvoice_AutoCompleteExtender" runat="server"
                                                  DelimiterCharacters="" EnableCaching="true"
                                                  Enabled="True" MinimumPrefixLength="1" CompletionSetCount="10"
                                                  ServiceMethod="GetSubDepotInvoiceNo" ServicePath="SInventoryWebService.asmx"  TargetControlID="txtSubDepotInvoice" 
                                                  UseContextKey="True"
                                                  CompletionListCssClass="autocomplete_completionListElement" 
                                                  CompletionListItemCssClass="autocomplete_listItem" 
                                                  CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                                  ShowOnlyCurrentWordInCompletionListItem="true"
                        >
                        </asp:AutoCompleteExtender>
                                                  
                                                   </div>
                                                   </div>



                                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Sub Invoice No:</label>

                                                <div class="col-sm-5">
                                                 
 
                                                       <asp:DropDownList ID="ProformaInvoiceNumDropDownList" runat="server" 
                                          CssClass="form-select form-select-sm mb-3 mySelect2" >
                        </asp:DropDownList>
                                                   </div>
                                                   </div>


                                                  <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> Stock Out Date:</label>

                                                <div class="col-sm-5">
                                                 
  <asp:TextBox ID="StockOutTextBox" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>
                                                   </div>
                                                   </div>

                                                       <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> Reason:</label>

                                                <div class="col-sm-5">
                                                 
    <asp:TextBox ID="txtReason" runat="server" CssClass="form-control form-control-sm mb-3" 
                                         ></asp:TextBox> 
                                                   </div>
                                                   </div>


                                                        

                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Product:</label>

                                                <div class="col-sm-5">
                                                  <asp:DropDownList ID="productDropDownList" runat="server" AutoPostBack="True" 
                                              CssClass="form-select form-select-sm mb-3 mySelect2" 
                                             >
                            </asp:DropDownList>
 
                                                   </div>
                                                   </div>
                                               <br />
                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  </label>

                                                <div class="col-sm-5">
                                               
                                                            <asp:LinkButton  OnClick="Button1_Click"   runat="server" id="Button2" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search"></i> Search Product
                                        </asp:LinkButton>
                                                   </div>
                                                   </div>
                                            <br />

                                               <div class="form-group row">
                                                   <div class="table-responsive" id="MainGradeDiv">
                                                     <asp:GridView ID="DerectStoctOutGridView" runat="server" AutoGenerateColumns="False" 
                                 CssClass="table table-bordered  text-center thead-dark" DataKeyNames="SubDCStoreId,PackSize" >
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                oncheckedchanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="PName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="StockQty" HeaderText="Stock Qty" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                        <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ReceiveDate" />
                                    <asp:TemplateField HeaderText="Stoct Out Qty">
                                        <ItemTemplate>
                                               <asp:TextBox ID="transferQtyTextBox" runat="server" CssClass="form-control form-control-sm mb-3" 
                                                Height="21px"    ontextchanged="dQtyTextBox_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                 <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                    Enabled="True" TargetControlID="transferQtyTextBox" FilterType="Custom" ValidChars="0123456789">
                                                </asp:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                                   </div>
                                                   </div>


                                                <br />
                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">  </label>

                                                <div class="col-sm-5">
                                               
                                                            <asp:LinkButton   onclick="addButton_Click"   runat="server" id="addButton" class="btn btnMyDesignAddtoList   btn-sm"   >
                                            <i class="fa fa-search"></i>Add to List
                                        </asp:LinkButton>
                                                   </div>
                                                   </div>
                                            <br />


                                             <div class="form-group row">
                                                   <div class="table-responsive" id="MssainGradeDiv">
                                                           <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" 
                                  DataKeyNames="SubDCStoreId,PackSize"              CssClass="table table-bordered  text-center thead-dark">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="StackOutQty" HeaderText="Stock Out Qty" />
                                    <asp:BoundField DataField="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                        HeaderText="ExpDate" />
                                    <asp:BoundField DataField="ReceiveDate" DataFormatString="{0:dd-MMM-yyyy}" 
                                                    HeaderText="ReceiveDate" />

                                        <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                          <%--  <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />--%>

                                              <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                </Columns>
                            </asp:GridView>
                                                   </div>
                                                   </div>
                                                   </div>
                                                   </div>
                      <asp:TextBox ID="ComUnitCodeTextBox" runat="server"   Visible="false" 
                                     CssClass="TextBox"></asp:TextBox>
                            <asp:HiddenField ID="HiddenField1" runat="server" />



                                     <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">
                                 <asp:HiddenField runat="server" ID="id_mastetID"/>

                                          
                                        
                                                         <asp:LinkButton runat="server"   OnClientClick="return sweetAlertConfirm_Submit(this);"     OnClick="submitButton_Click1" id="submitButton" class="btn btnMyDesignSearch   btn-sm" >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                       

                                        <asp:LinkButton ID="btnReset" runat="server"  OnClick="btnReset_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

        
</asp:Content>

