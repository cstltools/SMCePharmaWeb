<%@ Page Title="Order Tracking List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"  EnableEventValidation="false"  AutoEventWireup="true" CodeFile="OrderTrackingListDBH.aspx.cs" Inherits="MasterSetup_UI_OrderTrackingListDBH" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructureInvoSearch.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <style>
          .radioChoice label {
            padding-left: 5px;
            padding-right: 3px;
                  font-size: 17px;
                  font-weight: bold;
        }

     
    </style>
<style type="text/css">
        /*AutoComplete flyout */
        .autocomplete_completionListElement {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto!important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 300px !important;

            overflow: auto!important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35)!important;
        }


         .autocomplete_completionListElement222 {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto!important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 600px !important;

            overflow: auto!important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35)!important;
        }
        /* AutoComplete highlighted item */

        .autocomplete_highlightedListItem {
            
            
              
    
            background-color: #17A2B8 !important;
            color: white !important;
            padding: 6px !important;
            font-weight: bold !important;
    
    
        }

        .HeaderCls{
            font-weight:bold;
        }
        .vl {
  border-left: 10px solid green;
 padding-right:10px;
 padding-right:10px;

}
        /* AutoComplete item */

        .autocomplete_listItem {
            padding: 6px !important;
            cursor: pointer !important;
            font-weight: bold !important;
            background-color: #fff !important;
            border-bottom: 1px solid #d4d4d4 !important; 
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset !important;
        }
    </style>
     
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Today's Order Report</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="EmpCetegoryAddImageButton" Visible="false" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>


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
                                         function MutExChkList(chk) {
                                             var chkList = chk.parentNode.parentNode.parentNode;
                                             var chks = chkList.getElementsByTagName("input");
                                             for (var i = 0; i < chks.length; i++) {
                                                 if (chks[i] != chk && chk.checked) {
                                                     chks[i].checked = false;
                                                 }
                                             }
                                         }

                                         function pageLoad() {
                                             $("#btngv").click(function (e) {
                                                 debugger;
                                                 var today = new Date();
                                                 var dd = String(today.getDate()).padStart(2, '0');
                                                 var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                                                 var yyyy = today.getFullYear();

                                                 today = mm + '_' + dd + '_' + yyyy;
                                                 $("#MainGradeDiv :hidden").remove();
                                                 let file = new Blob([$('#MainGradeDiv').html()], { type: "application/vnd.ms-excel" });
                                                 let url = URL.createObjectURL(file);

                                                 let a = $("<a />", {
                                                     href: url,
                                                     download: "Order_Tracking_List_" + today+".xlsx"
                                                 }).appendTo("body").get(0).click();
                                                 e.preventDefault();




                                             });

                                             $('.datepicker').pickadate({
                                                 selectMonths: true,
                                                 selectYears: true
                                             })
                                             $('.multiple-select').select2({
                                                 includeSelectAllOption: true,
                                                 theme: 'bootstrap4',
                                                 width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                 placeholder: $(this).data('placeholder'),
                                                 allowClear: Boolean($(this).data('allow-clear')),
                                             });
                                             $('.mySelect2').select2({
                                                 theme: 'bootstrap4',
                                                 width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                 placeholder: $(this).data('placeholder'),
                                                 allowClear: Boolean($(this).data('allow-clear')),
                                             });
                                         }
                                     </script>
                                 
                                  
                                              <div style="padding:2px!important"></div>

                                        <div class="row" style="display:none">

                                            <div class="col-8">

                                                  

                                                <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                            </div>
                                             

                                            <div class="col-4">

                                                      <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-5 col-form-label">  DC:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlDistributionCenter" ></asp:DropDownList>
                                        
  
                                                    </div>
                                    </div>
                                    </div>


                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> From Date: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                   <asp:TextBox  runat="server"  id="frmDate"  class="form-control form-control-sm mb-3 datepicker"    autocomplete="off" placeholder="Select Date" 
                                                       ></asp:TextBox>
                                                        <span id="v-frmDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

 

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> To Date: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:TextBox   runat="server"   id="toDate"  class="form-control form-control-sm mb-3 datepicker"    autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                                        <span id="v-toDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>



                                                  <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Provider Type: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                       <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlProgramType" ></asp:DropDownList>

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                  <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Customer Type: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                             <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlChemisType" ></asp:DropDownList>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                  <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Approval Status: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:DropDownList  runat="server"   id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>
                                              
                                                
                                              
                                                   <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Campaign: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:DropDownList  runat="server"   id="ddlCampaign"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                      <div class="form-group row " runat="server">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Customer: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " 
                                AutoPostBack="True" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>
 

<asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculation"
                                                            TargetControlID="custNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetCustomer_ALL"
                                                            ServicePath="SInventoryWebService.asmx"
                                                            MinimumPrefixLength="1"
                                                            CompletionInterval="10"
                                                            EnableCaching="false"
                                                            CompletionSetCount="1"
                                                            FirstRowSelected="false"  CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                                        </asp:AutoCompleteExtender>
                                      
                                       

                                              <asp:HiddenField ID="hfCustomerId" runat="server" />
                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                   <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Invoice:  </label>

                                                    <div class="col-sm-1">
</div>
                                                    <div class="col-sm-6">


                                                        <div class="row" style="padding-top:6px">
                                                             <div class="col-sm-4"> <div class="form-check form-switch" >
													<input class="form-check-input" runat="server" onclick="MutExChkList(this);" type="checkbox" id="chkYes"  >
													 <label  class="custom-control-label" for="chkYes">Yes</label>
												</div>  </div>
                                                             <div class="col-sm-4"> <div class="form-check form-switch" >
													<input class="form-check-input" onclick="MutExChkList(this);" runat="server" type="checkbox" id="chkNo"  >
													 <label  class="custom-control-label" for="chkNo">No</label>
												</div>  </div>

                                                        </div>
                                                        
                                                        
                                                          
                                                      
                                                    </div>
                                                  
                                                </div>
                                            </div>
                                        </div>

                                              <%-- <div style="padding-top:10px;"></div>--%>
                        <div class="row"  style="display:none">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">
                                <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                            </div>
                        </div>
                                      <div style="padding-top:10px;"></div>
                                     	<div class="card">
											<div class="card-body">
												<h5 class="d-flex align-items-center mb-3">Summary</h5>
												<p style="font-size:18px;">Order Count: <asp:Label  CssClass="HeaderCls" ID="lblOrderCount" Text="0" runat="server"></asp:Label> <span class="vl"></span> Gross Amount: <asp:Label  CssClass="HeaderCls" ID="lblOrderAmount" Text="0" runat="server"></asp:Label>   <span class="vl"></span>   </p>
												<div class="progress mb-3" style="height: 5px">
													<div class="progress-bar bg-primary" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
												</div>
												</div>
												</div>
                                             
                                        
                                       	<div class="card-body" runat="server" visible="false">
						<div class="col-md-12 btn btn-info " style="background-color:whitesmoke!important;padding-top:15px!important">
					Summary  <button type="button" class="btn btn-success position-relative me-lg-5">  Order Count <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"> <span class="visually-hidden">unread messages</span></span>
										</button>
                            <button type="button" class="btn btn-success position-relative me-lg-5"> TP <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark">  <span class="visually-hidden">unread messages</span></span>
										</button>

                            <button type="button" class="btn btn-success position-relative me-lg-5">  VAT <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark">  <span class="visually-hidden">unread messages</span></span>
										</button>
                            <button type="button" class="btn btn-success position-relative me-lg-5">  Discount <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark">  <span class="visually-hidden">unread messages</span></span>
										</button>


                             <button type="button" runat="server" visible="false" class="btn btn-success position-relative me-lg-5">  Chemist Count <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"><asp:Label ID="lblChemistCount" Text="0" runat="server"></asp:Label>  <span class="visually-hidden">unread messages</span></span>
										</button>
                            <button type="button" class="btn btn-success position-relative me-lg-5">  Net Payable <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark">   <span class="visually-hidden">unread messages</span></span>
										</button>
                            </div>
                            </div>

                                           <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-1" >
                             <div class="input-group " style="display:none">
                                                
    <div class="form-check form-switch" >
													<input class="form-check-input" runat="server" type="checkbox" id="chkIsActive"  >
													 <label  class="custom-control-label" for="chkIsActive">Details</label>
												</div>      
                                                       

                                              </div>
                                              </div>
                                                   <div class="col-2" >
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
                                 onrowcommand="loadGridView_RowCommand" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" >
                                <Columns>
                                    
                                  <%--   <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Order NO">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="fff" runat="server" Text='<%#Eval("OrderCode") %>'  
                                                                     CommandArgument='<%#Eval("OrderCode") %>'   CommandName="EditData"></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                   
                              <%--      <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center" />--%>
                                    <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                        <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" /><asp:BoundField DataField="GrossValue" HeaderText="Gross Amount" />
                                  <%--  
                                    <asp:BoundField DataField="TotalVat" HeaderText="VAT" />
                                    <asp:BoundField DataField="TotalDiscount" HeaderText="Discount" />--%>
                                    <%--<asp:BoundField DataField="TotalNetPayable" HeaderText="Net Payable" />--%>
                                    
                                  <%--  <asp:BoundField DataField="SubmissionDate" HeaderText="Create Date" />
                                    <asp:BoundField DataField="CreateBy" HeaderText="Create By" />--%>


                                <%--    <asp:BoundField DataField="DZSMEmpName" HeaderText="DZSM Name" />
                                    <asp:BoundField DataField="AMEmpName" HeaderText="AM Name" />

                                    <asp:BoundField DataField="MIOEmpName" HeaderText="MIO Name" />

                                    <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                    <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                    <asp:BoundField DataField="AreaName" HeaderText="Area" />--%>
                                    <%--<asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />--%>
                                
                               <%--     <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />
                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                    <asp:BoundField DataField="RouteName" HeaderText="Distribution Route" />
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />--%>
                                    <%--<asp:BoundField DataField="Invoice" HeaderText="Invoiced" />--%>
<%--  <asp:TemplateField HeaderText="Invoiced">
 
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" style="font-weight:bold" Text='<%# Bind("Invoice") %>' ForeColor='<%# Convert.ToString(Eval("Invoice")) == "Yes" ? System.Drawing.Color.Green: Convert.ToString(Eval("Invoice")) == "No" ? System.Drawing.Color.Red: System.Drawing.Color.Purple%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                                   
                                 <%--   <asp:TemplateField HeaderText="View">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="LinkButton1" runat="server" class="btn-success  btn-sm mb-1 mb-md-0"
                                                                     CommandArgument='<%#Eval("OrderCode") %>'   CommandName="EditData"><i class='fa fa-eye' aria-hidden='true'></i></asp:LinkButton>
                                             
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

    <script>

        //$(document).ready(function () {

        //    var table = $('#ContentPlaceHolder1_loadGridView').DataTable(
        //        {
        //            "bInfo": true,
        //            "bFilter": true,
        //            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
        //            pageLength: 10,
        //            dom: 'lBfrtip',


        //            buttons: ['copy', 'excel', 'pdf', 'print']
        //        }
        //    );

        //    var prm = Sys.WebForms.PageRequestManager.getInstance();
        //    if (prm != null) {
        //        prm.add_endRequest(function (sender, e) {
        //            if (sender._postBackSettings.panelsToUpdate != null) {
        //                table = $('#ContentPlaceHolder1_loadGridView').DataTable(
        //                    {
        //                        "bInfo": true,
        //                        "bFilter": true,
        //                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
        //                        pageLength: 10,
        //                        dom: 'lBfrtip',


        //                        buttons: ['copy', 'excel', 'pdf', 'print']


        //                    }
        //                );
        //            }
        //        });
        //    };


        //    table.columns().every(function () {
        //        var that = this;

               
        //    });
        //});


    </script>
</asp:Content>

