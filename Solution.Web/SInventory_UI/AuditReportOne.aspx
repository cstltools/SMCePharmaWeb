<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="AuditReportOne.aspx.cs" Inherits="SInventory_UI_AuditReportOne" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <style type="text/css">
        
        .excel-button{
            margin-left: 5px;
        }
        
        .excel-button:hover {
            background-color: #00D2D3;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Order Delete Report</div>
                
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
                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label"> </label>

                                                <div class="col-sm-7">
                                                     <asp:CheckBox ID="nationalCheckBox"  CssClass="SelectchkChoice"    runat="server" AutoPostBack="True"
                                oncheckedchanged="nationalCheckBox_OnCheckedChanged" />
                                                    
                                                    </div>
                                                    </div>


                             
                                              <div class="form-group row"  runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label">Sales Center:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                        

                                                      <asp:DropDownList ID="comUnitNameDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2">
                            </asp:DropDownList>
                                                     

                                                    </div>
                                                   
                                                    </div>

                                               <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> From Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                    <asp:TextBox ID="fromDateTextBox" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select From Date" ></asp:TextBox>

                                                 



                                                </div>
                                               
                                            </div>

                                              <div class="form-group row" runat="server">
                                                <label for="mainName" class="col-sm-5 col-form-label"> To Date:  <span style="color:red">*</span></label>

                                                <div class="col-sm-7">
                                                                   
                  <asp:TextBox ID="toDateTextBox" runat="server"  class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select  To Date"></asp:TextBox>
                                                 



                                                </div>
                                              
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
        <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                
                                <asp:Button ID="excelButton" Visible="False" BackColor="#16A085"  CssClass="excel-button" runat="server" OnClick="excelButton_OnClick"
                                Text="Excel" /> 
                                                      <asp:LinkButton  OnClick="submitButton_Click1"   runat="server" id="viewRptButton" class="btn btnMyDesignSearch   btn-sm"   >
                                            <i class="fa fa-print" aria-hidden="true"></i>&nbsp; View Report
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                  


                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">
                                                
                                        </div>
                                    </div>
                         	<div class="card-body" >
						<div class="col-md-12 btn btn-info " style="background-color:whitesmoke!important;padding-top:15px!important">
					Summary  <button type="button" class="btn btn-success position-relative me-lg-5">  Order Count <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblOrderCount" Text="0" runat="server"></asp:Label> <span class="visually-hidden">unread messages</span></span>
										</button>
                            <button type="button" class="btn btn-success position-relative me-lg-5"> TP <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblOrderAmount" Text="0" runat="server"></asp:Label> <span class="visually-hidden">unread messages</span></span>
										</button>

                            <button type="button" class="btn btn-success position-relative me-lg-5">  VAT <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblVAT" Text="0" runat="server"></asp:Label> <span class="visually-hidden">unread messages</span></span>
										</button>
                            <button type="button" class="btn btn-success position-relative me-lg-5">  Discount <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblDiscount" Text="0" runat="server"></asp:Label> <span class="visually-hidden">unread messages</span></span>
										</button>


                             <button type="button" runat="server" visible="false" class="btn btn-success position-relative me-lg-5">  Chemist Count <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblChemistCount" Text="0" runat="server"></asp:Label>  <span class="visually-hidden">unread messages</span></span>
										</button>
                            <button type="button" class="btn btn-success position-relative me-lg-5">  Net Payable <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblAllTotal" Text="0" runat="server"></asp:Label>  <span class="visually-hidden">unread messages</span></span>
										</button>
                            </div>
                            </div>

                          <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-3" >

                          <div class="form-group row  pull-right">
                                            
                         <%-- <a  id="btngv"  style="background-color: #1A7343; color: #fff;" onclick="tableToExcel('testTable', 'W3C Example Table')" title="Export to Excel"   class="btn btn-sm   mb-2"  ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel</a>--%>
                       
                                                   <asp:LinkButton ID="btnExport"   class="btn btn-sm   mb-2" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />
                                    
           
                                            <div class="table-responsive" id="MainGradeDiv">

                                          <%--onrowcommand="loadGridView_RowCommand"--%>      

                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="OrderCode"   
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" >
                                <Columns>
                                    
                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Order NO">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="fff" runat="server" Text='<%#Eval("OrderCode") %>'  
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <%--<asp:BoundField DataField="OrderCode" HeaderText="Order NO" />--%>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="GrossValue" HeaderText="TP" />
                                    <asp:BoundField DataField="TotalVat" HeaderText="VAT" />
                                    <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />
                                    <asp:BoundField DataField="TotalNetPayable" HeaderText="Net Payable" />
                                    
                                    <asp:BoundField DataField="SubmissionDate" HeaderText="Create Date" />
                                    <asp:BoundField DataField="CreateBy" HeaderText="Create By" />


                                    <asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />
                                    <asp:BoundField DataField="AMEmpName" HeaderText="AM Name" />

                                    <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Name" />

                                    <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                    <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                    <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                    <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                    <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                    <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />
                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                    <asp:BoundField DataField="RouteName" HeaderText="Distribution Route" />
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                                    <asp:BoundField DataField="DELEmpName" HeaderText="Delete By" />
                                    <asp:BoundField DataField="DelDate" HeaderText="Delete Date" />



                                   
                                   
                                 <%--   <asp:TemplateField HeaderText="View">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="LinkButton1" runat="server" class="btn-success  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='fa fa-eye' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                                                         <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
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

