<%@ Page Title=" Leave Application List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="LeaveApplications.aspx.cs" Inherits="LeaveProcess_UI_LeaveApplications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Leave Application List</div>

                <div class="ms-auto">
                    <div class="btn-group">

 
                         <a href="LeaveApplicationEntry.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>

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
                                                 })
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

       <div class="row">
                                                           <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="FromDate" class="col-sm-4 col-form-label">From Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="FromDate" type="text" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="Select Date" ></asp:TextBox>

                                    </div>

                                </div>

                                

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Employee:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"   id="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                    </div>

                                </div>

                                 

                            </div>
                        </div>

                      
                        <div class="row">
                             <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="ToDate" class="col-sm-4 col-form-label">To Date:  </label>

                                    <div class="col-sm-8">
                                         <asp:TextBox  runat="server"  id="ToDate" type="text" class="form-control form-control-sm mb-3 datepicker"   autocomplete="off" placeholder="Select Date"></asp:TextBox>

                                    </div>

                                </div>
                                 <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">Approval Status:  </label>

                                    <div class="col-sm-8">


                                              <asp:DropDownList  runat="server"   id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                               
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"   id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>
                                 <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">Leave Type:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"   id="ddlLeaveType" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

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
                                    <br />
                        <div class="table-responsive" id="MainGradeDiv">
                            
                               <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="LeaveApplicationId" 
                                  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                       <asp:TemplateField HeaderText="#SI">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <%--<asp:BoundField DataField="UserName" HeaderText="User Name " />--%>
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                                    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
                                    <asp:BoundField DataField="LeaveTypeName" HeaderText="Leave Type" />
                                    <asp:BoundField DataField="LeaveFromDate" HeaderText="Start Date" />
                                    <asp:BoundField DataField="LeaveToDate" HeaderText="End Date" />
                                    <asp:BoundField DataField="Days" HeaderText="Duration (Days)" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:BoundField DataField="DateOfReturnsToDuty" HeaderText="Date of Return's to Duty" />
                                    <asp:BoundField DataField="LeaveAddress" HeaderText="Leave Address" />
                                    <asp:BoundField DataField="EmergencyContactNo" HeaderText="Emergency Contact No" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Comments" />

                                     <asp:TemplateField HeaderText="Image">
                                        <ItemTemplate>
                                            <a href='<%#Eval("ImageString")%>'
             ID="hpImg"
             runat="server" class="fancybox "  >
                          
                                               <asp:Image ID="imgShow" runat="server" CssClass="imgCSS"   ImageUrl='<%#Eval("ImageString")%>'  Width="45" Height="45"  />
                                                </a>
                                            </ItemTemplate>
                                         </asp:TemplateField>

                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                                   
                            
 
 
 
                                </Columns>
                            </asp:GridView>

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


                    buttons: ['copy', 'excel', 'pdf', 'print', 'csv']
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


                                buttons: ['copy', 'excel', 'pdf', 'print', 'csv']


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
<%--      <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>--%>
 
<%--
    <script>

        function parseJsonDate(jsonDate) {

            var fullDate = new Date(parseInt(jsonDate.substr(6)));
            var twoDigitMonth = (fullDate.getMonth() + 1) + ""; if (twoDigitMonth.length == 1) twoDigitMonth = "0" + twoDigitMonth;

            var twoDigitDate = fullDate.getDate() + ""; if (twoDigitDate.length == 1) twoDigitDate = "0" + twoDigitDate;
            var currentDate = twoDigitMonth + "/" + twoDigitDate + "/" + fullDate.getFullYear();

            return currentDate;
        };
        $(function () {

            GetFinancialYear();
        });
       
        function GetFinancialYear() {

            var urlpath = 'LeaveApplicationCode.aspx/GetLeaveApplications';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (data) {
                    var result = JSON.parse(data.d);

                    $('#tabH').show();

                    var row = "";

                    //console.log(result);


                    $('#dtTableBody').html("");

                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td class='text-center'>" + (i + 1) + "</td>";
                        row += "<td>" + result[i].EmpName + "</td>";
                        row += "<td class='text-center'>" + result[i].LeaveTypeName + "</td>";
                        row += "<td class='text-center'>" + (result[i].LeaveFromDate) + "</td>";
                        row += "<td class='text-center'>" + (result[i].LeaveToDate) + "</td>";
                        row += "<td class='text-center'>" + result[i].Days + "</td>";
                        row += "<td class='text-center'>" + result[i].Reason + "</td>";
                        row += "<td class='text-center'>" + result[i].ApprovalStatus + "</td>";

                        //if (result[i].ApprovalStatus == 'Approved')
                        //{
                        //    row += "<td class='text-center'> <i class='fa fa-1x fa-check-circle text-success'> Approved </i></td>";

                        //}
                        //else if (result[i].ApprovalStatus == 'Pending')
                        //{
                        //    row += "<td class='text-center'> <i class='fa fa-1x fa-cog text-warning'> Pending </i></td>";

                        //}
                        //else {
                        //    row += "<td class='text-center'><i class='fa fa-1x fa-ban text-danger'> Rejected </i></td>";
                        //}


                        //if (result[i].ApprovalStatus == 'Pending')
                        //{
                        //    row += '<td class="text-left mb-2">  <a style="padding: .3em .5em .4em .5em !important;" data-toggle="tooltip" data-placement="top" title="Approve" class="btn btn-sm btn-success" href="javascript: void (0);" onclick="ApproveOrReject(' + result[i].LeaveApplicationId + ',' + "'Approved'" + ')"><i class="fa fa-check-circle-o" ></i></a> <a style="padding: .3em .5em .4em .5em !important;" data-toggle="tooltip" data-placement="top" title="Reject" class="btn btn-sm btn-danger" href="javascript: void (0);" onclick="ApproveOrReject(' + result[i].LeaveApplicationId + ',' + "'Rejected'" + ')"><i class="fa fa-ban"></i></a></td>';


                          /*  <a style="padding: .3em .5em .4em .5em !important;" data-toggle="tooltip" data-placement="top" title="View" class="btn btn-sm btn-info" href="/LeaveApplication/LeaveApplicationDetail?id=' + result[i].LeaveApplicationId + '"><i class="fa fa-eye" ></i></a> <a style="padding: .3em .5em .4em .5em!important;" data-toggle="tooltip" data-placement="top" title="Edit" class="btn btn-sm btn-info" href="/LeaveApplication/LeaveApplicationEdit?id=' + result[i].LeaveApplicationId + '"><i class="fa fa-pencil-square" ></i></a>*/
                        //}
                        //else
                        //{
                        //   /* row += "<td class='text-left mb-2'> <a style='padding: .3em .5em .4em .5em !important;' data-toggle='tooltip' data-placement='top' title='View' class='btn btn-sm btn-primary' href='/LeaveApplication/LeaveApplicationDetail?id=" + result[i].LeaveApplicationId + "'><i class='fa fa-eye' ></i></a>  </td>";*/

                        //    row += "<td class='text-left mb-2'>   </td>";
                        //}

                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

                    $('#dtTble').dataTable({
                        "bInfo": true,
                        "bFilter": true,
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        pageLength: 10,
                        dom: 'lBfrtip',


                        buttons: ['copy', 'excel', 'pdf', 'print']
                    });
                }
            });
        }

        function ApproveOrReject(applicationId, approvalStatus)
        {
             
                            Final_ApproveOrReject(applicationId,approvalStatus);
                       
        }

        function Final_ApproveOrReject(applicationId, approvalStatus) {

            var urlpath = 'LeaveApplicationCode.aspx/LeaveApplicationApprove';

            
            
            $.ajax({
                
                data: JSON.stringify({ 'leaveApplicationId': applicationId, 'ApprovalStatus': approvalStatus }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",

                beforeSend: function () {
                },
                success: function (data) {
                   
                    successalert('Operation successful!', 'Success', 'LeaveApplications.aspx');
                },
                complete: function () {
                }
            });

            return false;

        }

        function editClick(id) {
            location.href = '@Url.Action("DoctorSetup", "Setup")?id=' + id + '';
        }

        function DeleteClick(id) {
            $.confirm({
                icon: 'fas fa-question-circle',
                title: 'Are You Sure ?',
                content: 'You are concern to delete the data!',
                theme: 'Supervan',
                type: 'green',
                buttons: {
                    Confirm: {
                        text: 'Confirm',
                        action: function () {
                            Final_DeleteClick(id);
                        }
                    },
                    Cancel: function () {
                    }
                }
            });

            return false;
        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: '/Setup/Delete_Prescription',
                dataType: 'json',
                type: "POST",
                data: { Id: Id },
                async: false,
                beforeSend: function () {
                },
                success: function (data) {
                    alert("Data Deleted Successfully !!!");
                    location.reload();
                },
                complete: function () {
                }
            });

            return false;

        }


    </script>
 --%>


</asp:Content>

