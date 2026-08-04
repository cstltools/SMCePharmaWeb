<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorView.aspx.cs" EnableEventValidation="false" Inherits="MasterSetup_UI_DoctorView" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStforAll.ascx" TagPrefix="uc1" TagName="IVMarketStforAll" %> 
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

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
            font-size: 12px !important;
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
            font-size: 12px !important;
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

        .ssss {
            font-size: 13px;
            font-weight: bold;
        }
    </style>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Doctor  List</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <asp:LinkButton ID="EmpCetegoryAddImageButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>


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

                                    <div class="row">

                                        <div class="col-6">
                                            <uc1:IVMarketStforAll runat="server" ID="IVMarketStructure" />

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Status: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlStatus">
                                                            <asp:ListItem Value="">Select Status</asp:ListItem>
                                                            <asp:ListItem  Selected="True"  Value="1">Active</asp:ListItem>
                                                            <asp:ListItem Value="0">Inactive</asp:ListItem>
                                                        </asp:DropDownList>
                                                        </span>
 

                                                    </div>
                                                </div>

                                            </div>
                                        </div>


                                        <div class="col-6">

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Provider Type: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlProgramType"></asp:DropDownList>
                                                        </span>
 

                                                    </div>
                                                </div>

                                            </div>


                                              <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Pharma Platform: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlPharmaPlatform"></asp:DropDownList>
                                                       
 

                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Doctor Type: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="DoctorTypeSelect" name="DoctorTypeSelect" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>



                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Degree: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="degreeSelect" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>



                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Approval Status: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:DropDownList class="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlApprovalStatus"></asp:DropDownList>
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

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Doctor: </label>

                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 "
                                                            AutoPostBack="True" OnTextChanged="custNameTextBox_TextChanged"></asp:TextBox>
                                                        <asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculation"
                                                            TargetControlID="custNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetDoctor_ALL"
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
                                        <div class="col-md-1">
                                        </div>

                                        <div class="col-md-2" style="margin-top: 5px;">
                                            <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right" Text="Total : 0"></asp:Label>


                                        </div>


                                        <div class="col-md-2 ">
                                            <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click"><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton>




                                        </div>
                                    </div>

                                    <br />



                                    <div class="table-responsive" id="MainGradeDiv">



                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            DataKeyNames="DoctorId" OnRowCommand="loadGridView_RowCommand"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                            <Columns>

                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="DoctorCode" HeaderText="Doctor Code" />
                                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" />
                                                <asp:BoundField DataField="ContactName" HeaderText="Mobile NO" />

                                                <asp:BoundField DataField="RegionCode" HeaderText="Zone Code" />
                                                <asp:BoundField DataField="AreaCode" HeaderText="Area Code" />
                                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                                <asp:BoundField DataField="MarketCode" HeaderText="Market Code" />
                                                <asp:BoundField DataField="MarketName" HeaderText="Market Name" />
                                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />

                                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider Type" />

                                                  <asp:BoundField DataField="SMCType" HeaderText="Pharma Platform" />
                                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Doctor Speciality" />
                                                <asp:BoundField DataField="ApprovalStatusWeb" HeaderText="Approval Status" />

                                                  <asp:BoundField DataField="StationTypeName" HeaderText="MIO Tour Type" />
                                                  <asp:BoundField DataField="Dept" HeaderText="Dept Tagging" />



                                                <asp:TemplateField HeaderText="Edit">
                                                    <ItemTemplate>

                                                        <asp:LinkButton ID="LinkButton1" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                            CommandArgument='<%#Eval("DoctorId") %>' CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <PagerStyle HorizontalAlign="left" CssClass="GridPager" />
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

