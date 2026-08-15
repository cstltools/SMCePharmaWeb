<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="StockBatchUpdate.aspx.cs" Inherits="SInventory_UI_StockConditionFreeze" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <div class="page-wrapper">
			<div class="page-content">
				<!--breadcrumb-->
                
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Stock Batch Update</div>
                
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
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Manufacturer:</label>

                                                <div class="col-sm-5">

                                                       <asp:DropDownList ID="manufacturerDropDownList" runat="server" AutoPostBack="True"
                                CssClass="form-select form-select-sm mb-3 mySelect2">
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


                                             <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> 	Distribution Center:</label>

                                                <div class="col-sm-5">
                                                        <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                OnSelectedIndexChanged="dcDropDownList1_SelectedIndexChanged">
                            </asp:DropDownList>
                                                      
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
                                                    
                                                      <asp:LinkButton  OnClick="submitButton0_OnClick"   runat="server" id="submitButton0" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-check"></i> Submit
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>



                       <br />
                                            <div class="row">

                                                
                                                            <div class="table-responsive" id="MainGradeDiv">
                                                                
                                                                 <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" 
                                    DataKeyNames="DCStoreId">
                                    <Columns>
                                        <asp:TemplateField HeaderText="#SL">
                                            <ItemTemplate>
                                                <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                        <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                        <asp:TemplateField HeaderText="Batch No">
                                            <ItemTemplate>
                                                <asp:TextBox ID="batchTextBox" runat="server"  CssClass="form-control form-control-sm mb-3" Text='<%# Eval("BatchNo")%>'  CssClas="form-control form-control-sm mb-3"></asp:TextBox>
                                               
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                       <asp:TemplateField HeaderText="Mfg. Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="mfgDateTextBox"   runat="server" Text='<%# Eval("MfgDate")%>' CssClass="form-control form-control-sm mb-3 datepicker"
                                                      ></asp:TextBox>
                                          
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Exp. Date">
                                            <ItemTemplate>
                                                <asp:TextBox ID="expDateDateTextBox" runat="server" Text='<%# Eval("ExpDate")%>'
                                                   CssClass="form-control form-control-sm mb-3 datepicker"  ></asp:TextBox>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                         <asp:TemplateField HeaderText="C.Stock Qty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtStockQty" runat="server" Text='<%# Eval("StockQty")%>'
                                                   CssClass="form-control form-control-sm mb-3"  ></asp:TextBox>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                       <%-- <asp:BoundField DataField="StockQty" HeaderText="C.Stock Qty" />--%>

                                       <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                                                   
                                                            </div>
                                                       



                                                </div>
                                          

                           



                                                 <br />
                    </ContentTemplate>
                                      </asp:UpdatePanel>
                            </div>
                             </div>
                        </div>
                    </div>
                    </div>
                    </div>

                                             
</asp:Content>
