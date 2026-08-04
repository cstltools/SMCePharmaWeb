<%@ Page Title="Tour Plan Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TourPlanReportNew.aspx.cs" Inherits="Reports_UI_TourPlanReportNew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <style>
    .header-wrap {
        white-space: normal;
    }
</style>


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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Tour Plan Report</div>
                
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
                                    <label for="FromDate" class="col-sm-4 col-form-label">Month:  <span style="color: red;">*</span>  </label>

                                    <div class="col-sm-8">
                                        
                                         <asp:DropDownList  runat="server"   id="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="EmployeeIdSelect" class="col-sm-4 col-form-label">Employee: <span style="color: red;">*</span></label>

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
                                    <label for="ToDate" class="col-sm-4 col-form-label">Year:    <span style="color: red;">*</span></label>

                                    <div class="col-sm-8">

                                           <asp:DropDownList  runat="server"   id="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                 

                                    </div>

                                </div>

                            </div>
                            <div class="col-5">
                                   
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  Visible="false" runat="server"   id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                           <div class="form-group row" runat="server" visible="false">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">Employee Status:  </label>

                                    <div class="col-sm-8">

                                    <asp:DropDownList  runat="server"   id="ddlEmployeeStatus" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2">
                                            <asp:ListItem Value="0">All</asp:ListItem>
                                            <asp:ListItem  Value="Active">Active</asp:ListItem>
                                            <asp:ListItem  Value="Inactive">Inactive</asp:ListItem>
                                        </asp:DropDownList>   </div>

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
                            <div class="col-md-4" style="align-content:center">

                                   <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="btnSearch_Click">  <i class="fa fa-print" aria-hidden="true"></i>
&nbsp; Print Report</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                
                            </div>
                        </div>
                                           <div class="row" style="display:none">
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
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                  
                                  
                                  
                                     <div class="col-md-3">
                                         
                                          <asp:LinkButton ID="btnPrint" Visible="false" runat="server" CssClass="btn btn-info " OnClick="btnPrint_OnClick" ><span aria-hidden="true" class="fa fa-print" ></span> &nbsp;Print Report</asp:LinkButton>  
                                         <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click" ><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export to Excel</asp:LinkButton>
                                       
                                       
        
  </div>
                     </div>
                                 
                        <div style="padding-top:10px;"></div>
                                             <div class="table-responsive" id="MainGradeDiv"  style="display:none">

                                                 <div style="margin-top:40px!important"></div>
                                     <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
    <tr>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Name:</td>
        <td style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblName" runat="server"></asp:Label>
        </td>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">E.Code:</td>
        <td style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblECode" runat="server"></asp:Label>
        </td>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Month:</td>
        <td style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblMonth" runat="server"></asp:Label>
        </td>
    </tr>
    <tr>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Desig:</td>
        <td style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblDesig" runat="server"></asp:Label>
        </td>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Posting Place:</td>
        <td style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblPostingPlace" runat="server"></asp:Label>
        </td>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Posting Place Code:</td>
        <td style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblPostingPlaceCode" runat="server"></asp:Label>
        </td>
    </tr>
    <tr>
        <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Zone:</td>
        <td colspan="5" style="border: 1px solid #ddd; padding: 4px;">
            <asp:Label ID="lblZone" runat="server"></asp:Label>
        </td>
    </tr>
</table>

                                                    <%--<asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                          
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnRowCreated="loadGridView_RowCreated"   >
                                <Columns>

                                   

                                    
                                                

                                    <asp:BoundField DataField="TourPlanDate" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee Code" />
                           
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                               <asp:BoundField DataField="RoleName" HeaderText="Designation" />



                               <asp:BoundField DataField="SMarketName" HeaderText="Start Market" />
                               <asp:BoundField DataField="SStarttime" HeaderText="Start Time" /> 
                               <asp:BoundField DataField="EMarketName" HeaderText="End Market" />
                               <asp:BoundField DataField="EEndtime" HeaderText="End Time" />
                               <asp:BoundField DataField="STourPurpose" HeaderText="Tour Purpose" />
                               <asp:BoundField DataField="OtherVisitM" HeaderText="Other Market Visit" />
                               <asp:BoundField DataField="SObjective" HeaderText="Objective" />


                             
                                
 


                               <asp:BoundField DataField="SMarketNameE" HeaderText="Start Market" />
                               <asp:BoundField DataField="SStarttimeE" HeaderText="Start Time" /> 
                               <asp:BoundField DataField="EMarketNameE" HeaderText="End Market" />
                               <asp:BoundField DataField="EEndtimeE" HeaderText="End Time" />
                               <asp:BoundField DataField="STourPurposeE" HeaderText="Tour Purpose" />
                               <asp:BoundField DataField="OtherVisitME" HeaderText="Other Market Visit" />
                               <asp:BoundField DataField="SObjectiveE" HeaderText="Objective" />


                               <asp:BoundField DataField="STourPurposeO" HeaderText="Tour Purpose" />


                             
                                
 
                                
                                   
                                   
                                   
                                </Columns>
                            </asp:GridView>--%>


                                              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered" OnRowCreated="loadGridView_RowCreated">
    <Columns>
        <asp:BoundField HeaderText="Date" DataField="Date" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Day" DataField="Day" HeaderStyle-CssClass="header-wrap" />

        <asp:BoundField HeaderText="Starting place with time" DataField="MorningStartingPlaceTime" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Ending place with time" DataField="MorningEndingPlaceTime" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Working Markets" DataField="MorningWorkingMarkets" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Working Types (HQ /Ex.HQ /OS)" DataField="WorkingTypesM" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Work with MIO (for AM & DSM)" DataField="WorkWithMIOM" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />

        <asp:BoundField HeaderText="Starting place with time" DataField="EveningStartingPlaceTime" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Ending place with time" DataField="EveningEndingPlaceTime" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Working Markets" DataField="EveningWorkingMarkets" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Working Types (HQ /Ex.HQ /OS)" DataField="WorkingTypesE" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
        <asp:BoundField HeaderText="Work with MIO (for AM & DSM)" DataField="WorkWithMIOE" HtmlEncode="false" HeaderStyle-CssClass="header-wrap" />
    </Columns>
</asp:GridView>


                         
                        </div>


                <div style="margin-top:40px; display:none">
    <table style="width: 20%; border-collapse: collapse; border: 1px solid #ddd;">
        <tr>
            <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">No of HQ</td>
            <td style="text-align:right; border: 1px solid #ddd; padding: 4px;">
                <asp:Label ID="lblNoOfHQ" runat="server">0</asp:Label>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">No of Ex. HQ</td>
            <td style="text-align:right; border: 1px solid #ddd; padding: 4px;">
                <asp:Label ID="lblNoOfExHQ" runat="server">0</asp:Label>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">No of OS</td>
            <td style="text-align:right; border: 1px solid #ddd; padding: 4px;">
                <asp:Label ID="lblNoOfOS" runat="server">0</asp:Label>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">No of OS-DCC</td>
            <td style="text-align:right; border: 1px solid #ddd; padding: 4px;">
                <asp:Label ID="lblOSDCC" runat="server">0</asp:Label>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold; border: 1px solid #ddd; padding: 4px;">Total</td>
            <td style="text-align:right; border: 1px solid #ddd; padding: 4px;">
                <asp:Label ID="lblTotal" runat="server">0</asp:Label>
            </td>
        </tr>
    </table>
</div>

        <!-- Submission, Update, and Approval Details -->
        <div style="margin-top:40px; display:none">
            <table style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td style="font-weight: bold;">Tour Plan Submitted by:</td>
                    <td>__________________</td>
                    <td style="font-weight: bold;">Tour Plan updated by:</td>
                    <td>__________________</td>
                    <td style="font-weight: bold;">Tour Plan approved by:</td>
                    <td>__________________</td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Submitted date & time:</td>
                    <td>__________________</td>
                    <td style="font-weight: bold;">Updated date & time:</td>
                    <td>__________________</td>
                    <td style="font-weight: bold;">Approved date & time:</td>
                    <td>__________________</td>
                </tr>
            </table>
        </div>

                        
                                   </ContentTemplate>
                                            <Triggers>
      <asp:PostBackTrigger ControlID="btnExportToExcel" />
  </Triggers>
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



    <script>

        //$(document).ready(function () {

        //    var table = $('#ContentPlaceHolder1_loadGridView').DataTable(
        //        {
        //            "bInfo": true,
        //            "bFilter": false,
        //            paging: false,
        //            "ordering": true,
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
        //                        "bFilter": false,
        //                        paging: false,
        //                        "ordering": true,

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

