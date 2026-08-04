<%@ Page Title="Change  Customer Provider Type" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CustomerChangeProgramType.aspx.cs" Inherits="MasterSetup_UI_CustomerChangeProgramType" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketFS.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

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
            overflow: auto !important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 300px !important;
            overflow: auto !important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35) !important;
        }


        .autocomplete_completionListElement222 {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto !important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 600px !important;
            overflow: auto !important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35) !important;
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Change  Customer Provider Type </div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <%--  <asp:LinkButton ID="EmpCetegoryAddImageButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>--%>
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


                                    <div style="padding: 2px!important"></div>

                                    <div class="row" runat="server" visible="false">

                                        <div class="col-6">

                                            <div class="form-group row" runat="server" visible="false">
                                                <label for="GroupSelect" class="col-sm-3 col-form-label">Distribution Center:  </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlDistributionCenter"></asp:DropDownList>


                                                    </div>
                                                </div>
                                            </div>

                                        </div>


                                        <div class="col-6">

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Provider Type: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " AutoPostBack="true" OnSelectedIndexChanged="ddlStationType_SelectedIndexChanged" runat="server" ID="ddlStationType"></asp:DropDownList>

                                                        </span>
 

                                                    </div>
                                                </div>

                                            </div>



                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Approval Status: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                       
                                                        </span>
 

                                                    </div>
                                                </div>

                                            </div>


                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Create From Date: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="frmDate" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date"></asp:TextBox>
                                                        <span id="v-frmDate" class="invalid-tooltip fade hide" data-delay="2000"></span>



                                                    </div>
                                                </div>

                                            </div>
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Create To Date: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="toDate" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date"></asp:TextBox>
                                                        <span id="v-toDate" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">

                                        <div class="col-md-4">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label">Provider Type: </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">

                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlProgramType"></asp:DropDownList>


                                                    </div>
                                                </div>

                                            </div>


                                               <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label">Pharma Platform: </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">

                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlPharmaPlatform"></asp:DropDownList>


                                                    </div>
                                                </div>

                                            </div>


                                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label">Approval Status: </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">

                                                 <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlApprovalStatus"></asp:DropDownList>

                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-5 col-form-label">Customer: </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">

                                                        <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "
                                                            AutoPostBack="True" OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>


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

                                            
                                            <div class="form-group row">


                                                   <label for="mainName" class="col-sm-5 col-form-label">Select Status: </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">

                                                          <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlStatus">
                                                            <asp:ListItem Value="">Select Status</asp:ListItem>
                                                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                                            <asp:ListItem Value="0">Inactive</asp:ListItem>
                                                        </asp:DropDownList>

                                                    </div>
                                                </div>
                                           
                                                        </span>
                                                 </div>

                                           
                                              
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group row">
                                                <label for="DivisionSelect" class="col-sm-3 col-form-label">Division:  </label>

                                                <div class="col-sm-8">
                                                    <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="DivisionSelect_SelectedIndexChanged" ID="DivisionSelect" name="DivisionSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>



                                                </div>
                                            </div>

                                            <div class="form-group row">
                                                <label for="DistrictSelect" class="col-sm-3 col-form-label">District:  </label>

                                                <div class="col-sm-8">
                                                    <asp:DropDownList runat="server" OnSelectedIndexChanged="DistrictSelect_SelectedIndexChanged" AutoPostBack="true" ID="DistrictSelect" name="DistrictSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>



                                                </div>
                                            </div>


                                            <div class="form-group row">
                                                <label for="ThanaSelect" class="col-sm-3 col-form-label">Thana:  </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ThanaSelect" name="ThanaSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>


                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                                 <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-2"></div>
                                        <div class="col-md-6">
                                        </div>
                                    </div>

                                    <div style="padding-top: 16px;"></div>
                                    <div class="row">
                                        <div class="col-md-5">
                                        </div>
                                        <div class="col-md-4" style="align-content: center">
                                            <asp:LinkButton runat="server" ID="btnSearch" class="btn btnMyDesignSearch   btn-sm " OnClick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>


                                            <asp:LinkButton runat="server" class="btn btnMyDesignReset   btn-sm" ID="resetBtn" OnClick="resetBtn_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <label></label>
                                        </div>


                                        <div class="col-md-2">
                                        </div>
                                        <div class="col-md-2">
                                        </div>
                                        <div class="col-md-2">
                                        </div>
                                        <div class="col-md-1">
                                        </div>

                                        <div class="col-md-2" style="margin-top: 5px;">
                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right" Text="Total : 0"></asp:Label>


                                        </div>


                                        <div class="col-md-3">
                                            <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click"><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton>




                                        </div>
                                    </div>
                                    <br />
                                    <div class="table-responsive" id="MainGradeDiv">

                                        <%--onrowcommand="loadGridView_RowCommand"--%>


                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            DataKeyNames="CustomerMasterId"  
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" PageSize="10" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                            <Columns>
                                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                <%--<asp:BoundField DataField="MarketName" HeaderText="Market" />--%>

                                                <%--<asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />--%>
                                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                                   <asp:BoundField DataField="OwnerName" HeaderText="Owner Name" />
                                                <asp:BoundField DataField="CellNo" HeaderText="Mobile NO" />
                                                <asp:BoundField DataField="Address" HeaderText="Address" />

                                                <%--<asp:BoundField DataField="DistributionRouteName" HeaderText="Distribution RouteName" />--%>
                                                <%--<asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />--%>

                                                <asp:TemplateField HeaderText="Code">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtProgramTypeCode" runat="server" ReadOnly="true" Text='<%#Eval("ProgramTypeCode") %>' CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                                          <asp:HiddenField ID="hfCustomerMasterId" runat="server" Value='<%#Eval("CustomerMasterId") %>'  ></asp:HiddenField>
                                                         
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Provider Type">
                                                    <ItemTemplate>
                                                        <asp:DropDownList Enabled="false" CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlProgramType_G"></asp:DropDownList>

                                                        <asp:LinkButton ID="lbtUpDate" runat="server" Visible="false" CssClass="btn-warning  btn-sm mb-1 mb-md-0"
                                                        CommandArgument='<%#Eval("CustomerMasterId") %>'  OnClick="lbtUpDate_Click"><i class='bx bxs-edit' aria-hidden='true'></i> Update</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Edit">
                                                    <ItemTemplate>


                                                        <asp:LinkButton ID="lblEditMode" runat="server" CssClass="btn-warning  btn-sm mb-1 mb-md-0"
                                                               CommandArgument='<%#Eval("CustomerMasterId") %>' OnClick="lblEditMode_Click"   ><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>

                                                    </ItemTemplate>
                                                </asp:TemplateField>


                                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                                <asp:BoundField DataField="DivisionName" HeaderText="Division" />
                                                <asp:BoundField DataField="DistrictName" HeaderText="District" />
                                                <asp:BoundField DataField="ThanaName" HeaderText="Thana" />
                                            </Columns>
                                            <PagerStyle HorizontalAlign="Center" CssClass="GridPager" />
                                        </asp:GridView>


                                        <asp:GridView ID="gv_Export" runat="server" AutoGenerateColumns="False"
                                            DataKeyNames="CustomerMasterId" OnRowCommand="loadGridView_RowCommand"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                            <Columns>
                                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                                  <asp:BoundField DataField="ProgramTypeCode" HeaderText="Provider Type Code" />
                                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />
                                                     <asp:BoundField DataField="OwnerName" HeaderText="Owner Name" />
                                                <asp:BoundField DataField="CellNo" HeaderText="Mobile NO" />
                                                <asp:BoundField DataField="Address" HeaderText="Address" />






                                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />

                                                <asp:BoundField DataField="DivisionName" HeaderText="Division" />
                                                <asp:BoundField DataField="DistrictName" HeaderText="District" />
                                                <asp:BoundField DataField="ThanaName" HeaderText="Thana" />
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

    <%--    <script>

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


    </script>--%>
</asp:Content>

