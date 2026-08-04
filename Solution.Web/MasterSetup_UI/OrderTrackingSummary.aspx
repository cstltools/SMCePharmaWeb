<%@ Page Title="Order Summary Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"  EnableEventValidation="false"  AutoEventWireup="true" CodeFile="OrderTrackingSummary.aspx.cs" Inherits="MasterSetup_UI_OrderTrackingSummary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="~/Reports_UI/IVMarketStructureMarket.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
      <script src="../VerticalAsset/jquery.tabletoCSV.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      
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
<style type="text/css">

       .radioChoice2 label {
            padding-left: 5px;
            padding-right: 30px;
            font-size: 18px;
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Order Summary Report</div>
                
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

                                        <div class="row">

                                            <div class="col-3">

                                                        <div class="Label_Title  ">Report Type </div>
                                                            
                                                                <div class="form-group">
                                                        
                                                    <asp:RadioButtonList runat="server" ID="rbReportTypeName" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rbReportTypeName_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                                                    

                                                        <asp:ListItem Selected="True" Value="1">Order Summary By Chemist</asp:ListItem>
                                                        <asp:ListItem Value="2">Order Summary By Product</asp:ListItem>
                                                       
                                                    </asp:RadioButtonList>
                                                     </div>

                                              
                                            </div>
                                             

                                            <div class="col-5">

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
                                                <label for="mainName" class="col-sm-5 col-form-label">Pharma Platform: </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlPharmaPlatform"></asp:DropDownList>
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
                                                    <label for="mainName" class="col-sm-5 col-form-label"> Campaign: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                     <asp:DropDownList  runat="server"   id="ddlCampaign"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>
                                                   <div class="form-group row" runat="server" visible="false">
                                                    <label for="mainName" class="col-sm-5 col-form-label">   </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                
    <div class="form-check form-switch" style="padding-left: 35px !important;">
													<input class="form-check-input" runat="server" type="checkbox" id="chkIsActive"  >
													 <label  class="custom-control-label" for="chkIsActive">Details</label>
												</div>      
                                                       

                                              </div>
                                                    </div>
                                                  
                                                </div>
                                            </div>
                                              <div class="col-4">
                                                   <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                                  </div>
                                        </div>

                                               <div style="padding-top:10px;"></div>
                        <div class="row">
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
												 <p style="font-size:18px;">Order Amount: <asp:Label  CssClass="HeaderCls" ID="lblOrderCount" Text="0" runat="server"></asp:Label> <%--<span class="vl"></span> TP: <asp:Label  CssClass="HeaderCls" ID="lblOrderAmount" Text="0" runat="server"></asp:Label>   <span class="vl"></span> VAT: <asp:Label  CssClass="HeaderCls" ID="lblVAT" Text="0" runat="server"></asp:Label> <span class="vl"></span> Discount: <asp:Label  CssClass="HeaderCls" ID="lblDiscount" Text="0" runat="server"></asp:Label>  <span class="vl"></span> Net Payable: <asp:Label  CssClass="HeaderCls" ID="lblAllTotal" Text="0" runat="server"></asp:Label>--%></p>
												<div class="progress mb-3" style="height: 5px">
													<div class="progress-bar bg-primary" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
												</div>
												</div>
												</div>      
                                        
                                      

                                           <div class="row">
                                        <div class="col-2"><h3>Details List</h3></div>
                                        <div class="col-7">
                                            </div>
                     <div class="col-3" >

                          <div class="form-group row  pull-right">
                                            
                         <%-- <a  id="btngv"  style="background-color: #1A7343; color: #fff;" onclick="tableToExcel('testTable', 'W3C Example Table')" title="Export to Excel"   class="btn btn-sm   mb-2"  ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel</a>--%>
                         <button type="button"  class="btn btn-success pull-right"   onclick="exporttocsv()"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>
                                                   <asp:LinkButton ID="btnExport"  Visible="false"  class="btn btn-sm   mb-2" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExport_Click"
                                                ><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </asp:LinkButton>
                                              </div>
                                        </div>
                                        
                                        </div>
                    <hr />
                                    
           
                                            <div class="table-responsive" id="export"  style="height:600px">

                                          <%--onrowcommand="loadGridView_RowCommand"--%>      

                                                           <asp:GridView ID="gv_Sum_Product" runat="server" AutoGenerateColumns="False" 
                                 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" >
                                <Columns>
                                    
                   
                                   
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                  
                            
                                    <asp:BoundField DataField="ReceieveBy" HeaderText="Received By" />
                                    <asp:BoundField DataField="OrderCount" HeaderText="Order Count" />
                                    <asp:BoundField DataField="ProductCount" HeaderText="Product Qty" />
                                    <asp:BoundField DataField="OrderAmount" HeaderText="Order Amount" />
                                    <asp:BoundField DataField="CustCount" HeaderText="Customer Count" />
                                  
                                </Columns>
                                                         <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                            </asp:GridView>
                                                 <div runat="server" id="data"></div>
                                                          <asp:GridView ID="gv_Sum_Chemist" runat="server" AutoGenerateColumns="False" 
                                 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" >
                                <Columns>
                                    
                   
                                   
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                  
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="ReceieveBy" HeaderText="Received By" />
                                    <asp:BoundField DataField="OrderCount" HeaderText="Order Count" />
                                    <asp:BoundField DataField="OrderAmount" HeaderText="Order Amount" />
                                  
                                </Columns>
                                                         <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                            </asp:GridView>

                                


                                                     <div runat="server" visible="false">

                                                           <asp:GridView ID="gvOrderMaster" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="OrderCode"  onrowcommand="loadGridView_RowCommand" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" >
                                <Columns>
                                    
                                     
                                    <asp:BoundField DataField="OrderCode" HeaderText="Order NO" />
                                   
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


                                   
                                   
                                   
                                </Columns>
                                                         
                            </asp:GridView>


                                                    <asp:GridView ID="gv_OrderDetails" runat="server"  AutoGenerateColumns="False" 
                                DataKeyNames="OrderCode"  onrowcommand="loadGridView_RowCommand" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging" >
                                <Columns>
                                    
                                        <%--   <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                    
                                    
                                    <asp:BoundField DataField="OrderCode" HeaderText="Order NO" />
                                    <%--<asp:BoundField DataField="OrderCode" HeaderText="Order NO" />--%>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Distribution Center" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                 
                                    
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
                                       <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                          <asp:BoundField DataField="TradePrice" HeaderText="TP" />
                                    <asp:BoundField DataField="TotalTradePrice" HeaderText="Total TP" />
                                               <asp:BoundField DataField="UnitVatAmount" HeaderText="Unit Vat" />
                                    <asp:BoundField DataField="TotalVatAmount" HeaderText="Total Vat" />
                                       <asp:BoundField DataField="DiscountPercent" HeaderText="Dis. Percent" />
                                     <asp:BoundField DataField="DiscountAmount" HeaderText="Dis. Amount" />
                                       <asp:BoundField DataField="NetAmount" HeaderText="Net Amount" />
                                                <asp:BoundField DataField="CampaignName2" HeaderText="Campaign Name" />
                                        <asp:BoundField DataField="ISGiftProduct" HeaderText="Gift/Bonus Product" />

                                   
                                   
                                   
                                </Columns>
                                                         <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                            </asp:GridView>
                                            </div>


                                          
                                      
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

     <script type="text/javascript">

         //<asp:ListItem Selected="True" Value="1">Doctor Wise</asp:ListItem>
         //                   <asp:ListItem Value="2">Product Brand Wise</asp:ListItem>
         //                   <asp:ListItem Value="3">Product Wise</asp:ListItem>
         //                       <asp:ListItem Value="4">User Wise</asp:ListItem>
         function exporttocsv() {

             var checked_radio = $("[id*=rbReportTypeName] input:checked");
             var value = checked_radio.val();
             var txt = "";
             if (value == "1") {
                 txt = "Order Summary By Chemist ";
             }

             if (value == "2") {
                 txt = "Order Summary By Product ";
             }
             $("#export").tableToCSV({
                 filename: txt + 'RX Report'
             });
         }
     </script>

                                        <script>
                                            function exportToExcel() {

                                                var file = new Blob([$('#export').html()], { type: "application/vnd.ms-excel" });
                                                var url = URL.createObjectURL(file);
                                                var a = $("<a />", {
                                                    href: url,
                                                    download: "RX_Report.xls"
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

                                            function ExportToPdf() {


                                                //alert('PDF');

                                                //var doc = new jsPDF();

                                                var doc = new jsPDF('p', 'pt', 'letter');
                                                //pdf.addHTML($('#tableDetail')[0], function () {
                                                //    pdf.save('Test.pdf');
                                                //});

                                                //var HTMLElement = $("#tableDetail").html();
                                                var HTMLElement = document.querySelector("#html");

                                                doc.fromHTML(HTMLElement);
                                                ////doc.text("Hello world!", 10, 10);
                                                doc.save("a4.pdf");
                                                //var doc = new jsPDF('p', 'pt', 'letter');
                                                //var htmlstring = '';
                                                //var tempVarToCheckPageHeight = 0;
                                                //var pageHeight = 0;
                                                //pageHeight = doc.internal.pageSize.height;
                                                //specialElementHandlers = {

                                                //    '#bypassme': function (element, renderer) {

                                                //        return true;
                                                //    }
                                                //};
                                                //margins = {
                                                //    top: 150,
                                                //    bottom: 60,
                                                //    left: 40,
                                                //    right: 40,
                                                //    width: 600
                                                //};
                                                //var y = 20;
                                                //doc.setLineWidth(2);
                                                //doc.text(200, y = y + 30, "TOTAL MARKS OF STUDENTS");
                                                //doc.autoTable({
                                                //    html: '#tableDetail',
                                                //    startY: 70,
                                                //    theme: 'grid',
                                                //    columnStyles: {
                                                //        0: {
                                                //            cellWidth: 180,
                                                //        },
                                                //        1: {
                                                //            cellWidth: 180,
                                                //        },
                                                //        2: {
                                                //            cellWidth: 180,
                                                //        }
                                                //    },
                                                //    styles: {
                                                //        minCellHeight: 40
                                                //    }
                                                //})
                                                //doc.save('Marks_Of_Students.pdf');
                                            }
                                        </script>
</asp:Content>

