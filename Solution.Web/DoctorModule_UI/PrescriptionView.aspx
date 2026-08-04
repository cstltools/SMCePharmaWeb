<%@ Page Title="Prescription List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PrescriptionView.aspx.cs" Inherits="DoctorModule_UI_PrescriptionView" %>

<%@ Register Src="~/DoctorVisit_UI/IVMasterStructureForDCR.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <%-- <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>--%>

     <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Prescription List</div>
                
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
                                       <div class="row">
                                                         
                            <div class="col-4">
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-5 col-form-label">From Date:  </label>

                                    <div class="col-sm-7">
                                         <asp:TextBox  runat="server"  id="FromDate" type="text" class="form-control form-control-sm  datepicker" autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                        
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
                                    </div>

                                </div>


                                 <div class="form-group row">
                                    <label for="ToDate" class="col-sm-5 col-form-label">To Date:  </label>

                                    <div class="col-sm-7">
                                         <asp:TextBox  runat="server"  id="ToDate" type="text" class="form-control form-control-sm   datepicker"   autocomplete="off" placeholder="Select Date"></asp:TextBox>

                                    </div>

                                </div>


                               
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-5 col-form-label">Approval Status:  </label>

                                    <div class="col-sm-7">


                                              <asp:DropDownList  runat="server"   id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm   mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                       
                            </div>
                            <div class="col-4">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-5 col-form-label">Employee:  </label>

                                    <div class="col-sm-7">


                                        <asp:DropDownList  runat="server"   id="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm   mySelect2"></asp:DropDownList>

                                    </div>

                                </div>
                                         <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-5 col-form-label">User Role:  </label>

                                    <div class="col-sm-7">


                                        <asp:DropDownList  runat="server"   id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm   mySelect2"></asp:DropDownList>
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
                            </div>

                                                  <div class="col-md-4">
                                                        <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                                  </div>
                        </div>

 
<br />        
                    
                        <div class="row">
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-4" style="align-content:center">

                                   <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                
                            </div>
                        </div>
                        <div style="padding-top:10px;"></div>
                      

                                            <div class="table-responsive" id="MainGradeDiv">
 


                                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                                    DataKeyNames="PrescriptionId"
                                                    OnRowCommand="loadGridView_RowCommand" CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                                    <Columns>

                                                        <asp:TemplateField HeaderText="SL">
                                                            <ItemTemplate>
                                                                <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="PrescriptionDate" HeaderText="Prescription Date" />

                                                        <asp:BoundField DataField="PrescriptionType" HeaderText="Prescription Type" />
                                                        <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                                                        <asp:BoundField DataField="SMCType_RX" HeaderText="Pharma Platform" />

                                                        <asp:BoundField DataField="RoleName" HeaderText="User Role" />
                                                        <asp:BoundField DataField="createBy" HeaderText="Create By" />

                                                        <asp:TemplateField HeaderText="Image">
                                                            <ItemTemplate>
                                                                <a href='<%#Eval("ImageString")%>'
                                                                    id="hpImg"
                                                                    runat="server" class="fancybox ">

                                                                    <asp:Image ID="imgShow" runat="server" CssClass="imgCSS" ImageUrl='<%#Eval("ImageString")%>' Width="45" Height="45" />
                                                                </a>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />

                                                        <asp:TemplateField HeaderText="Action">
                                                            <ItemTemplate>

                                                                <asp:LinkButton ID="LinkButton1" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                         
                     

                                          
                                                </div>
                                                </div>
                                               
                                                </div>
                                                </div>
                                                </div>
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
<%--    <script type="text/javascript">

        function ResetLink() {
            location.reload();
        }


        $(document).ready(function () {

            

                    $('.datepicker').pickadate({
                        selectMonths: true,
                        selectYears: true
                    })

        
            GetUserRoleInfo(0);
            LoadPrescriptionList();
            //FiscalYearInfo(0);
        //    //   GetUserList();
            GetUser(0);
            GetApprovalStatusList("");
            //  GetGroupInfo(0);
          //  GetPrescription();
        });

        function GetUserRoleInfo(id) {
            var urlpath = 'Setup.aspx/Get_UserRoleInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'UserRoleID', 'RoleName', id);
            $('#UserRoleSelect').select2();
        }


        function GetUser(setId) {
            var urlpath = 'Setup.aspx/Get_CapturedBy_For_ddl';
            SelectOption_DtTable_Async_True(urlpath, $('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', setId);
            $('#EmployeeIdSelect').select2();
        }

        function GetApprovalStatusList(id) {
            _getApprovalList_Active($('#ApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', id);
        }
        function LoadPrescriptionList() {


            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var formatted = d.getFullYear() + '/' +
                (('' + month).length < 2 ? '0' : '') + month + '/' +
                (('' + day).length < 2 ? '0' : '') + day;
            var param = "";


            if ($('#FiscalYearSelect').val() != "") {

                param = param + " AND  mas.YearValue='" + $('#FiscalYearSelect').val() + "'";

            }

            if ($('#MonthSelect').val() != "") {

                param = param + " AND  mas.MonthValue='" + $('#MonthSelect').val() + "'";

            }

            if ($('#FromDate').val() != "" && $('#ToDate').val() != "") {
                param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + $('#ToDate').val() + "' ";
            }
            if ($('#FromDate').val() != "" && $('#ToDate').val() == "") {
                param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
            }

            if ($('#ToDate').val() != "" && $('#FromDate').val() == "") {
                param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
            }
            if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                param = param + " AND PM.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";
            }

            if ($('#UserSelect').val() != "" && $('#UserSelect').val() != null && $('#UserSelect').val() != "0") {

                param = param + " AND tpdtl.CreatedBy='" + $('#UserSelect').val() + "'";

            }

            if ($('#UserRoleSelect').val() != "" && $('#UserRoleSelect').val() != null && $('#UserRoleSelect').val() != "0") {

                param = param + " AND us.UserRoleID='" + $('#UserRoleSelect').val() + "'";

            }

            if ($('#EmployeeIdSelect').val() != "" && $('#EmployeeIdSelect').val() != null && $('#EmployeeIdSelect').val() != "0") {

                param = param + " AND PM.EntryBy='" + $('#EmployeeIdSelect').val() + "'";

            }

            if ($('#GroupSelect').val() != "" && $('#GroupSelect').val() != null && $('#GroupSelect').val() != "0") {

                param = param + " AND gp.GroupId='" + $('#GroupSelect').val() + "'";

            }

            if ($('#ZoneSelect').val() != "" && $('#ZoneSelect').val() != null && $('#ZoneSelect').val() != "0") {

                param = param + " AND zn.ZoneId='" + $('#ZoneSelect').val() + "'";

            }
            if ($('#AreaSelect').val() != "" && $('#AreaSelect').val() != null && $('#AreaSelect').val() != "0") {

                param = param + " AND ar.AreaId='" + $('#AreaSelect').val() + "'";

            }

            if ($('#TeritorySelect').val() != "" && $('#TeritorySelect').val() != null && $('#TeritorySelect').val() != "0") {

                param = param + " AND tr.TerritoryId='" + $('#TeritorySelect').val() + "'";

            }


            if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != null && $('#MarketSelect').val() != "0") {

                param = param + " AND mr.MarketId='" + $('#MarketSelect').val() + "'";

            }

            $.ajax({

                url: "PrescriptionView.aspx/Get_PrescriptionList",
                dataType: 'json',
                data: JSON.stringify({
                    "param": param 
                }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (data) {

                    data = data.d;
                    var result = JSON.parse(data);
                    var row = "";
                    $('#dtTableBody').html("");

                    for (var i = 0; i < result.length; i++) {

                        row += "<tr >";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + result[i].PrescriptionDate + "</td>";
                        row += "<td>" + result[i].PrescriptionType + "</td>";
                        row += "<td>" + result[i].DoctorName + "</td>";
                        row += "<td>" + result[i].RoleName + "</td>";
                        row += "<td>" + result[i].createBy + "</td>";
                        row += "<td>" + result[i].ApprovalStatus + "</td>";
                        row += "<td><button type='button' class='btn-outline-warning  btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].PrescriptionId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

                    //if ($.fn.dataTable.isDataTable('#dtTb')) {
                    //    table = $('#dtTb').DataTable({
                    //        "ordering": false,
                    //        dom: 'lBfrtip',


                    //        buttons: ['copy', 'excel', 'pdf', 'print']
                    //    });
                    //}
                    //else {
                    //    table = $('#dtTb').DataTable({
                    //        "ordering": false,
                    //        dom: 'lBfrtip',


                    //        buttons: ['copy', 'excel', 'pdf', 'print']
                    //    });
                    //}
                }
            });
        }

        function editClick(id) {

            location.href = 'Prescription.aspx?id=' + id + '';
        }

    </script>--%>



</asp:Content>




