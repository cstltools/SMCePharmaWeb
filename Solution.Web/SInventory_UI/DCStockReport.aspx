<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DCStockReport.aspx.cs" Inherits="SInventory_UI_DCStockReport" %>
 
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    
    <style type="text/css">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Stock Report</div>
                
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
                                                <label for="mainName" class="col-sm-3 col-form-label"> </label>

                                                <div class="col-sm-5">
                                                     <asp:CheckBox ID="nationalCheckBox" runat="server" AutoPostBack="True" oncheckedchanged="nationalCheckBox_CheckedChanged" CssClass="SelectchkChoice" Text=" National Stock Report "
                                 />
                                                    </div>
                                                    </div>
                                            <br />
                                            <div class="form-group row" runat="server" visible="False" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Central Warehouse : </label>

                                                <div class="col-sm-5">
                                                      <asp:CheckBox ID="centalWHCheckBox" runat="server" AutoPostBack="True" OnCheckedChanged="centalWHCheckBox_CheckedChanged"  Enabled="False"/>
                                                  
                                                    </div>
                                                    </div>


                                            <div class="form-group row" runat="server" visible="False" id="DIVCH">
                                                <label for="mainName" class="col-sm-3 col-form-label">Central Warehouse:</label>

                                                <div class="col-sm-5">
                                                     <asp:DropDownList ID="whDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                OnSelectedIndexChanged="whDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>

                                                 



                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                              <div class="form-group row"  runat="server" visible="True" id="DIVDC">
                                                <label for="mainName" class="col-sm-3 col-form-label">Distribution Center:</label>

                                                <div class="col-sm-5">
                                             <asp:DropDownList ID="dcDropDownList1" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                                OnSelectedIndexChanged="dcDropDownList1_SelectedIndexChanged">
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
                                      <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                                                      <asp:LinkButton  OnClick="reportButton_OnClick"   runat="server" id="submitButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                       
                                    </div>

                       <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-3" >

                          <div class="form-group row  pull-right">
                                                <asp:LinkButton ID="LinkButton1" class="btn btn-sm   mb-2" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="viewRptButton_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Download Summary Report </asp:LinkButton>

                            
                                              </div>
                                        </div>
                                        
                                        </div>


                     <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-3" >

                          <div class="form-group row  pull-right">
                                                   <asp:LinkButton ID="btnExport" class="btn btn-sm   mb-2" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />

                    <div class="row">
                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                    <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="AvailableQty" HeaderText="Available Qty" />
                                    
                                </Columns>
                            </asp:GridView>
                                            </div>


                       </ContentTemplate>

                 <Triggers>
                 
                 <asp:PostBackTrigger ControlID="btnExport"/>
             </Triggers>
                </asp:UpdatePanel>
                    </div>

                 
                            </div>

                            </div>
                            </div>
                            </div>
                            </div>
                            
</asp:Content>


