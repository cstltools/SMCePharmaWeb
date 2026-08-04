<%@ Page Title="Order Place Permission" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="OrderPermission.aspx.cs" Inherits="Reports_UI_OrderPermission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    <script type="text/javascript">
        function pageLoad() {

            $('.multiple-select').select2({
                includeSelectAllOption: true,
                theme: 'bootstrap4',
                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                placeholder: $(this).data('placeholder'),
                allowClear: Boolean($(this).data('allow-clear')),
            });
            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            });
            $('.mySelect2').select2({
                theme: 'bootstrap4',
                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                placeholder: $(this).data('placeholder'),
                allowClear: Boolean($(this).data('allow-clear')),
            });

            $(".fancybox").fancybox({
                openEffect: "none",
                closeEffect: "none"
            });

            $(".zoom").hover(function () {

                $(this).addClass('transition');
            }, function () {

                $(this).removeClass('transition');
            });
        }

    </script>

    <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Order Place Permission</div>

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
                                        <div class="col-1">
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="ddlZone" class="col-sm-4 col-form-label">Zone:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ddlZone" AutoPostBack="true" OnSelectedIndexChanged="ddlZone_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                </div>

                                            </div>

                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="ddlArea" class="col-sm-4 col-form-label">Area:  </label>

                                                <div class="col-sm-8">


                                                    <asp:DropDownList runat="server" ID="ddlArea" name="ddlArea" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                </div>

                                            </div>

                                        </div>
                                    </div>
                                    <div class="row" style="display: none">
                                        <div class="col-1">
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="FromDate" class="col-sm-4 col-form-label">Month:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                </div>

                                            </div>

                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Employee:  </label>

                                                <div class="col-sm-8">


                                                    <asp:DropDownList runat="server" ID="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                </div>

                                            </div>

                                        </div>
                                    </div>


                                    <div class="row" style="display: none">
                                        <div class="col-1">
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                                <label for="ToDate" class="col-sm-4 col-form-label">Year:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>



                                                </div>

                                            </div>

                                        </div>
                                        <div class="col-5">

                                            <div class="form-group row">
                                                <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                                <div class="col-sm-8">


                                                    <asp:DropDownList runat="server" ID="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                </div>

                                            </div>

                                            <div class="form-group row">
                                                <label for="UserRoleSelect" class="col-sm-4 col-form-label">Employee Status:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ddlEmployeeStatus" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2">
                                                        <asp:ListItem Value="0">All</asp:ListItem>
                                                        <asp:ListItem Value="Active">Active</asp:ListItem>
                                                        <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>

                                            </div>

                                        </div>
                                    </div>


                                    <div class="row">

                                        <div class="col-1">
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                            </div>

                                        </div>
                                    </div>


                                    <br />

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
                                        <div class="col-md-2">
                                        </div>



                                        <div class="col-md-3">

                                            <asp:LinkButton ID="btnPrint" runat="server" CssClass="btn btn-info " OnClick="btnPrint_OnClick" Style="display: none"><span aria-hidden="true" class="fa fa-print" ></span> &nbsp;Print Report</asp:LinkButton>
                                            <asp:LinkButton Style="display: none" ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click"><span aria-hidden="true" class="fa fa-file" ></span> &nbsp;View Report</asp:LinkButton>



                                        </div>
                                    </div>

                                    <div style="padding-top: 10px;"></div>
                                    <div class="table-responsive" id="MainGradeDiv">

                                        <div style="margin-top: 40px!important"></div>

                                        <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            OnRowCommand="loadGridView_RowCommand" CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                            <Columns>

                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                        <asp:HiddenField runat="server" ID="hfEmpInfoId" Value='<%#Eval("EmpInfoId")%>' />
                                                        <asp:HiddenField runat="server" ID="hfTerritoryId" Value='<%#Eval("TerritoryId")%>' />


                                                        <asp:HiddenField runat="server" ID="hfPermittedEmpId" Value='<%#Eval("PermittedEmpId")%>' />

                                                    </ItemTemplate>
                                                </asp:TemplateField>


                                                <asp:TemplateField>
                                                    <HeaderTemplate>
                                                        <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkSelect" CssClass="form-control-sm" runat="server" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>




                                                <asp:TemplateField HeaderText="Area">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="AreaName" Text='<%#Eval("AreaName")%>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>



                                                <asp:TemplateField HeaderText="Territory">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="TerritoryName" Text='<%#Eval("TerritoryName")%>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID." />

                                                <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />

                                                <asp:TemplateField HeaderText="New Permitted User">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlPermittedEmpId" class="form-control form-control-sm mySelect2" runat="server"></asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="From Date">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtFrmDate" runat="server" class="form-control form-control-sm "  type="datetime-local" autocomplete="off"   Text='<%#Eval("FrmDate") %>'></asp:TextBox>

                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="To Date">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtToDate" runat="server" type="datetime-local" autocomplete="off" class="form-control form-control-sm "    Text='<%#Eval("ToDate") %>'></asp:TextBox>

                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                            </Columns>
                                        </asp:GridView>

                                    </div>

                                              <br />
  
         <div class="row">
<div class="col-2">&nbsp;</div>
<div class="col-8">

     <div class="form-group row">
        <label for="customSwitch1" class="col-sm-5 col-form-label">  </label>

        <div class="col-sm-7" style="padding-top:6px;">

      
            
                          <asp:LinkButton  OnClick="btnSave_Click"   OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                <i class="fa fa-check"></i>Submit
            </asp:LinkButton>

                                 

        </div>

    </div>

    </div>
    </div>



                                </ContentTemplate>
                                <%--    <Triggers>
                    <asp:PostBackTrigger ControlID="btnExportToExcel" /> 
                </Triggers>--%>
                            </asp:UpdatePanel>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>




    <%--    <script>
        function un(o) {
            return o != null ? o : '';
        }
      
                            $(function () {

                                $('.datepicker').pickadate({
                                    selectMonths: true,
                                    selectYears: true
                                })
                                GetUserRoleInfo(0);
                                GetEmpList(0);
                                GetApprovalStatusList("");
        GetAreaList();
                            });

                 function ResetClick() {
                     location.href = '../DoctorModule_UI/MileageClaim.aspx';

        }

        function GetEmpList(SetId) {
            _getEmployeeList_Active($('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', SetId);
        }

        function GetApprovalStatusList(id) {
            _getApprovalList_Active($('#ApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', id);
        }
        function GetAreaList() {


            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var formatted = d.getFullYear() + '/' +
                (('' + month).length < 2 ? '0' : '') + month + '/' +
                (('' + day).length < 2 ? '0' : '') + day;


            var param = " and  mas.MileageClaimId IS NOT NULL";

                                if ($('#FromDate').val() != "" && $('#ToDate').val() != "") {
                                    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + $('#ToDate').val() + "' ";
                                }
                                if ($('#FromDate').val() != "" && $('#ToDate').val() == "") {
                                    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
                                }

                                if ($('#ToDate').val() != "" && $('#FromDate').val() == "") {
                                    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
                                }
            if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                                    param = param + " AND mas.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";


                                }

            if ($('#UserRoleSelect').val() != "" && $('#UserRoleSelect').val() != null && $('#UserRoleSelect').val() != 0) {

                                    param = param + " AND us.UserRoleID='" + $('#UserRoleSelect').val() + "'";

                                }

            if ($('#EmployeeIdSelect').val() != "" && $('#EmployeeIdSelect').val() != null && $('#EmployeeIdSelect').val() != 0) {

                                    param = param + " AND mas.EmpInfoId='" + $('#EmployeeIdSelect').val() + "'";

                                }


            var urlpath = 'MileageClaimView.aspx/GetMileageClaimList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'param': param }),
                contentType: "application/json; charset=utf-8",
                type: "POST",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (data) {
                    //console.log(data);
                   
                    var result = JSON.parse(data.d);
                    console.log(result);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].EmpMasterCode) + "</td>";
                        row += "<td>" + un(result[i].EmpName) + "</td>";
                        row += "<td>" + un(result[i].MileageDate)  + "</td>";
                        row += "<td>" + un(result[i].TransportName)  + "</td>";
                        row += "<td>" + un(result[i].MileageInKM) + "</td>";
                        row += "<td>" + un(result[i].Expense)  + "</td>";
                     
                        row += "<td>" + un(result[i].MeterReading)  + "</td>";
                        row += "<td>" + un(result[i].ApprovalStatus) + "</td>";
                        var im2 = "";
                        var img1 =  result[i].ImagePreName ;

                        const getBase64FromUrl = async (url) => {
                            const data = await fetch(url);
                            const blob = await data.blob();
                            return new Promise((resolve) => {
                                const reader = new FileReader();
                                reader.readAsDataURL(blob);
                                reader.onloadend = () => {
                                    const base64data = reader.result;
                                    resolve(base64data);

                                    
                                }
                            });
                        }
                      
                        getBase64FromUrl(img1);

                        row += "<td>" + '<a href="' + getBase64FromUrl(img1) + '"><img src="' + getBase64FromUrl(img1) + '"/></a>' + "</td>";




                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0'  type='button'  onclick='editClick(" + result[i].MileageClaimId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button>   </td>";
                        row += "</tr>";

                    /*    <button class='btn-outline-danger    btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].MileageClaimId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/


                    }

                    $('#dtTableBody').html(row);
                },
                complete: function() {

                    $("#coverScreen").hide();

                }
            });
    }

                            function editClick(id) {
                                location.href = '../DoctorModule_UI/MileageClaim.aspx?id=' + id + '';

                            }


                               function GetUserRoleInfo(id) {
                                   var urlpath = 'ExpenseClaimView.aspx/Get_UserRoleInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'UserRoleID', 'RoleName', id);
             $('#UserRoleSelect').select2();
    }
    </script>--%>
</asp:Content>

