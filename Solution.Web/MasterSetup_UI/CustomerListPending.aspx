<%@ Page Title="Customer List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CustomerListPending.aspx.cs" Inherits="MasterSetup_UI_CustomerListPending" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructureSearch.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
            font-size: 12px !important;
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
            font-size: 12px !important;
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

        .ssss {
                                                                                                                     font-size: 13px;
                                                                                                                     font-weight: bold;
                                                                          
                                               
                                                                                                                 }
    </style>
     
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Customer Pending  List</div>
                
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

                                        <div class="row" runat="server" visible="false">

                                            <div class="col-6">

                                              

                                                <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />



                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Status: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                   <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlStatus" >
                                                       <asp:ListItem Value="">Select Status</asp:ListItem>
                                                       <asp:ListItem Value="1">Active</asp:ListItem>
                                                       <asp:ListItem Value="0">Inactive</asp:ListItem>
                                                             </asp:DropDownList>
                                                        </span>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>
                                            </div>


                                            <div class="col-6">

                                                   <div class="form-group row" runat="server" >
                                    <label for="GroupSelect" class="col-sm-3 col-form-label"> DC:  </label>

                                    <div class="col-sm-8">
                                           <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlDistributionCenter" ></asp:DropDownList>
                                        
  
                                                    </div>
                                    </div>
                                    </div>

                                                  <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Provider Type: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                   <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlProgramType" ></asp:DropDownList>
                                                        </span>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Customer  Type: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                      <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlChemisType" ></asp:DropDownList>
                                                        </span>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                   <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Approval Status: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                     <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlApprovalStatus"   ></asp:DropDownList>
                                                        </span>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>


                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Create From Date: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                   <asp:TextBox  runat="server"  id="frmDate"  class="form-control form-control-sm mb-3 datepicker"    autocomplete="off" placeholder="Select Date" 
                                                       ></asp:TextBox>
                                                        <span id="v-frmDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

 

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Create To Date: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                     <asp:TextBox   runat="server"   id="toDate"  class="form-control form-control-sm mb-3 datepicker"    autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                                        <span id="v-toDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
 

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                                 <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Customer: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                        <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " 
                                AutoPostBack="True" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>
                                                             <asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculation"
                                                            TargetControlID="custNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetCustomer_ALL_new"
                                                            ServicePath="SInventoryWebService.asmx"
                                                            MinimumPrefixLength="1"
                                                            CompletionInterval="10"
                                                            EnableCaching="false"
                                                            CompletionSetCount="1"
                                                            FirstRowSelected="false" CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                                        </asp:AutoCompleteExtender>
                                        <asp:HiddenField ID="hfCustomerId" runat="server" />
 

                                              </div>
                                                    </div>
                                                  
                                                </div>
                                            </div>
                                        </div>


                                        
                                               <div style="padding-top:16px;"></div>
                        <div class="row"  runat="server" visible="false">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">
                                <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                            </div>
                        </div>
                                          <div class="row" runat="server" visible="false">
                 <div class="col-md-12">
                                       <label>  </label>
                                       </div>
                                   
                                   
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                     <div class="col-md-1">
                                       
                                       
                                       </div>
                              
                                   <div class="col-md-2"   style="margin-top: 5px;">
                                         <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right"   Text="Total : 0" ></asp:Label>
                                       
                                       
                                       </div>
                                  
                                  
                                     <div class="col-md-3">
                                         <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click" ><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton> 
                                       
                                      
                                       
        
  </div>
                     </div>
                                            <br />
                                            <div class="table-responsive" id="MainGradeDiv">

                                          <%--onrowcommand="loadGridView_RowCommand"--%>      

                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="CustomerMasterId"  onrowcommand="loadGridView_RowCommand" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"    PageIndex="0"  >
                                <Columns>

                                      <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <%--<asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />--%>
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                   
                                    
                                    <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />
                                    <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                    <asp:BoundField DataField="CellNo" HeaderText="Mobile NO" />
                                    <asp:BoundField DataField="Address" HeaderText="Address" />
                                     <asp:BoundField DataField="GroupName" HeaderText="Group" />
                                     <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                     <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                     <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                     <asp:BoundField DataField="SubTerritoryName" HeaderText="Sub-Territory" />
                                     <asp:BoundField DataField="MarketName" HeaderText="Market" />

                                    <%--<asp:BoundField DataField="DistributionRouteName" HeaderText="Distribution RouteName" />--%>
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                              
 
                                   
                                    <asp:TemplateField HeaderText="Edit" Visible="false">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="LinkButton1" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                                          <PagerStyle HorizontalAlign="Center" CssClass="GridPager" />
                            </asp:GridView>
                                            </div>


                                          
                                      


                                </ContentTemplate>
                                              <Triggers>
                    <asp:PostBackTrigger ControlID="btnExportToExcel" /> 
                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>

        $(document).ready(function () {

            var table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                {
                    "bInfo": true,
                    "bFilter": true,
                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    pageLength: 10,
                    dom: 'lBfrtip',


                    buttons: ['copy', 'excel', 'pdf', 'print']
                }
            );

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                            {
                                "bInfo": true,
                                "bFilter": true,
                                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                pageLength: 10,
                                dom: 'lBfrtip',


                                buttons: ['copy', 'excel', 'pdf', 'print']


                            }
                        );
                    }
                });
            };


            table.columns().every(function () {
                var that = this;

               
            });
        });


    </script>
</asp:Content>

