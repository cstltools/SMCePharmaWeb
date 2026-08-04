<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="SubDeportStockFreez.aspx.cs" Inherits="SubDepot_UI_SubDeportStockFreez" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Freeze Stock Release </div>
                
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
                    

 
                                    
                                    
                                    
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label"> Distribution Centerr:</label>

                                                <div class="col-sm-5">
                                                    <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2 "  OnSelectedIndexChanged="dcDropDownList_SelectedIndexChanged"
                                AutoPostBack="True">
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
                                            
                                            <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Sub-Depot:</label>

                                                <div class="col-sm-5">

 

                                                     <asp:DropDownList ID="subdeportDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                                AutoPostBack="True">
                            </asp:DropDownList>
                                                </div>
                                                
                                            </div>

                                                     <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Manufacturer:</label>

                                                <div class="col-sm-5">

                                                    <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" OnSelectedIndexChanged="manufacturerDropDownList_SelectedIndexChanged">
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

                                                     
                          

                                                            <asp:LinkButton  OnClick="submitButton_Click"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-search"></i> Search
                                        </asp:LinkButton>

                                                       <asp:LinkButton  OnClick="submitButton0_OnClick"   runat="server" id="submitButton0" class="btn btn-success   btn-sm"   >
                                            <i class="fa fa-print"></i> Print Invoice
                                        </asp:LinkButton>

                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  

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

                                    
                                                            <asp:LinkButton  OnClick="addButton_Click"   runat="server" id="addButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-plus"></i> Add to List
                                        </asp:LinkButton>
 

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>
                     <div class="row">
                                        <div class="table-responsive" id="MainGrasdeDiv">
                                             <asp:GridView ID="labelGridView" runat="server" AutoGenerateColumns="False"  CssClass="table table-bordered  text-center thead-dark"
                                DataKeyNames="DCStoreFreezeId,DCStoreId" OnRowCommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="StockQty" HeaderText="StockQty" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                    <asp:BoundField DataField="StockCondition" HeaderText="StockCondition" />
                                    <asp:BoundField DataField="ReturnQty" HeaderText="Return Qty" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                     <asp:TemplateField HeaderText="Remove Item">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteImageButton" runat="server" 
                                                ImageUrl="~/images/lineDelete.png" onclick="DeleteImageButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                            </div>
                         </div>

                        <div class="row">
                                        <div class="table-responsive" id="MainGradeDiv">
                                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"  
                                DataKeyNames="SDStoreFreezeId,SubDCStoreId" OnRowCommand="loadGridView_RowCommand"  CssClass="table table-bordered  text-center thead-dark">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch" />
                                    <asp:BoundField DataField="ExpDate" HeaderText="ExpDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="StockQty" HeaderText="StockQty" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                    <asp:BoundField DataField="StockCondition" HeaderText="StockCondition" />
                                    <asp:TemplateField HeaderText="Return Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="returnQtyTextBox" runat="server" CssClass="TextBoxMini"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderconvRate" runat="server"
                                                Enabled="True" TargetControlID="returnQtyTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
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

     
</asp:Content>
