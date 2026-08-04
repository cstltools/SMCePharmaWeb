<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="AttendanceInfoList.aspx.cs" Inherits="DoctorModule_UI_AttendanceInfoList" %>






<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 
       
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Attendance List Information</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                       <%-- <a href="../DoctorModule_UI/ShiftInfoEntry.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>--%>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            
                            
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
                                                              closeEffect: "none",
                                                              
                                                               'autoSize': false,
                                                              'width': 400,
                                                              'height': 600
                                                          });

                                                          $(".zoom").hover(function () {

                                                              $(this).addClass('transition');
                                                          }, function () {

                                                              $(this).removeClass('transition');
                                                          });
                                                      }

                                                  </script>
                            
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

                            </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">User Role:  </label>

                                    <div class="col-sm-8">


                                        <asp:DropDownList  runat="server"   id="UserRoleSelect" name="UserRoleSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                    </div>

                                </div>

                            </div>
                        </div>

                      
                        <div class="row">

                             <div class="col-1">
                                                               </div>
                            <div class="col-5">
                                <div class="form-group row">
                                    <label for="UserRoleSelect" class="col-sm-4 col-form-label">Approval Status:  </label>

                                    <div class="col-sm-8">


                                              <asp:DropDownList  runat="server"   id="ApprovalStatusSelect" name="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
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
                        <div style="padding-top:10px;"></div>
                                      <div class="row">
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
                                         
                                       
                                       </div>
                                  
                                  
                                     <div class="col-md-3">
                                         <asp:LinkButton ID="btnExportToExcel" runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click" ><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton> 
                                       
                                      
                                       
        
  </div>
                     </div>
                                            <br />
                                             <div class="table-responsive" id="MainGradeDiv">


                                                 
                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"  AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                <Columns>
                     

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="AttendanceDate" HeaderText="Attendance Date" />
                                    <asp:TemplateField HeaderText="Punch IN Image">
                                        <ItemTemplate>
                                        <a href='<%#Eval("ImagePreName")%>'
             ID="hpImg"
             runat="server" class="fancybox "  >
                          
                                                   <asp:Image ID="imgShow" runat="server" CssClass="imgCSS"   ImageUrl='<%#Eval("ImagePreName")%>'  Width="45" Height="45"  />
                                                   </a>
                                            </ItemTemplate>
                                         </asp:TemplateField>


                                       <asp:TemplateField HeaderText="Punch Out Image">
                                        <ItemTemplate>
                                        <a href='<%#Eval("ImageOut")%>'
             ID="hpImg"
             runat="server" class="fancybox "  >
                          
                                                   <asp:Image ID="imgShow" runat="server" CssClass="imgCSS"   ImageUrl='<%#Eval("ImageOut")%>'  Width="45" Height="45"  />
                                                   </a>
                                            </ItemTemplate>
                                         </asp:TemplateField>

                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                                   
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                               <asp:BoundField DataField="DesigName" HeaderText="Designation" />

                                    
                                    <asp:BoundField DataField="RoleName" HeaderText="User Role" />

                                    <asp:BoundField DataField="ShiftText" HeaderText="Shift" 
 />

                                     <asp:TemplateField HeaderText="Punch In Time">
                                        <ItemTemplate>
                                             <asp:Label ID="lbl_GroupName" runat="server" Text='<%#Eval("PunchInTime") %>'></asp:Label>
                                            <a  data-toggle='tooltip' title='Show in map'    target='_blank' style='font-size:20px' href='http://maps.google.com/?q="<%# Eval("PInLoc") %>"'  class='bx bx-location-plus'></a>
                                            </ItemTemplate>
                                         </asp:TemplateField>

                                    
                                     <asp:TemplateField HeaderText="Punch Out Time">
                                        <ItemTemplate>
                                             <asp:Label ID="lbl_GjjroupName" runat="server" Text='<%#Eval("PunchOutTime") %>'></asp:Label>
                                            <a  data-toggle='tooltip' title='Show in map'    target='_blank' style='font-size:20px;display:<%# Eval("AttStatus") %>' href='http://maps.google.com/?q="<%# Eval("POutLoc") %>"'  class='bx bx-location-plus'></a>
                                            </ItemTemplate>
                                         </asp:TemplateField>

                                     <asp:BoundField DataField="InAddress"  HeaderText="Punch IN Address"  />
                                    <asp:BoundField DataField="OutAddress"   HeaderText="Punch OUT Address"   />
                                    
                                    <asp:BoundField DataField="POutRemarks" HeaderText="Remarks"  />
                                   
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status"  />
                                     
                                   
                                  
                                </Columns>
                                                          <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />

                            </asp:GridView>


                                                            
                                        <div style="display:none">
                                                        <asp:GridView ID="gv_Export" runat="server" AutoGenerateColumns="False"
                                 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"  AllowPaging="True" PageIndex="0" OnPageIndexChanging="loadGridView_PageIndexChanging">
                                <Columns>
                     

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="AttendanceDate" HeaderText="Attendance Date" />
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                                   
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                               <asp:BoundField DataField="DesigName" HeaderText="Designation" />

                                    
                                    <asp:BoundField DataField="RoleName" HeaderText="User Role" />

                                    <asp:BoundField DataField="ShiftText" HeaderText="Shift" 
 />
                                       <asp:BoundField DataField="PunchInTime"  HeaderText="Punch In Time"  />
                                       <asp:BoundField DataField="PunchOutTime"  HeaderText="Punch Out Time"  />
                                 

                                 

                                     <asp:BoundField DataField="InAddress"  HeaderText="Punch IN Address"  />
                                    <asp:BoundField DataField="OutAddress"   HeaderText="Punch OUT Address"   />
                                    
                                    <asp:BoundField DataField="POutRemarks" HeaderText="Remarks"  />
                                   
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status"  />
                                    
                                   
                                  
                                </Columns>
                                                          <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />

                            </asp:GridView>
                                        </div>

                            
                    
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
                                             
  
   <%-- <script>

        function ResetLink() {
            location.reload();
        }

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
            //$('#FromDate').datepicker();
            //$('#ToDate').datepicker();
                                //$('#FromDate').datepicker("update", new Date());
                                //$('#ToDate').datepicker("update", new Date());
            GetEmpList(0);
            GetApprovalStatusList("");
            GetAreaList();
                                

    });

        function GetApprovalStatusList(id) {
            _getApprovalList_Active($('#ApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', id);
        }

        function GetEmpList(SetId) {
            _getEmployeeList_Active($('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', SetId);
        }



        function GetAreaList() {

            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var formatted = d.getFullYear() + '/' +
                (('' + month).length < 2 ? '0' : '') + month + '/' +
                (('' + day).length < 2 ? '0' : '') + day;


            var param = "";

            if ($('#FromDate').val() != "" && $('#ToDate').val() != "") {
                param = param + " AND CONVERT(date,att1.AttendanceDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + $('#ToDate').val() + "' ";
            }
            if ($('#FromDate').val() !=  "" && $('#ToDate').val() ==  "") {
                param = param + " AND CONVERT(date,att1.AttendanceDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
            }

            if ($('#ToDate').val() !=  "" && $('#FromDate').val() ==  "") {
                param = param + " AND CONVERT(date,att1.AttendanceDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
            }
            if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                param = param + " AND att1.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";

               
            }

            if ($('#EmployeeIdSelect').val() != "" && $('#EmployeeIdSelect').val() != null && $('#EmployeeIdSelect').val() != "0") {

                param = param + " AND att1.EmpInfoId='" + $('#EmployeeIdSelect').val() + "'";

            }


           


            var urlpath = 'AttendanceInfoList.aspx/Emp_AttendanceInfoList';
            $.ajax({
                url: urlpath,
                data: JSON.stringify({ 'param': param }),
                dataType: 'json',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function(data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";

                        //var src = "data:image/jpeg;base64,";
                        //src += result[i].ImageString;
                        //$("#output-image").attr("src", src);
                        //$("#output-image").show();
                        //$("#imgeBase64Str").val(result[i].ImageString);

                        row += "<td>" + un(result[i].AttendanceDate) + "</td>";
                        row += "<td>" + un(result[i].EmpMasterCode) + "</td>";
                        row += "<td>" + un(result[i].EmpName) + "</td>";
                        row += "<td  >" + un(result[i].DesigName) + "</td>";
                        row += "<td  >" + un(result[i].RoleName) + "</td>";
                        row += "<td>" + un(result[i].ShiftText) + "</td>"; 
                        row += "<td>" + un(result[i].PunchInTime) + "   <a  data-toggle='tooltip' title='Show in map'    target='_blank' style='font-size:20px' href='http://maps.google.com/?q=" + result[i].PInLoc + "'  class='bx bx-location-plus'></a> </td>";


                        if(result[i].PunchOutTime!=null){
                        row += "<td>" + un(result[i].PunchOutTime) + "   <a  data-toggle='tooltip' title='Show in map'    target='_blank' style='font-size:20px' href='http://maps.google.com/?q=" + result[i].POutLoc + "'  class='bx bx-location-plus'></a> </td>";

                      
                    }
                    else
{
    row += "<td>" +   "</td>";
}



                        //row += "<td><button class='btn-outline-primary btn-sm' onclick='editClick(" + result[i].AreaId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button></td>";
                        row += "</tr>";


                    }

                    $('#dtTableBody').html(row);
                },
                complete: function() {
                    $("#coverScreen").hide();

                    //if ($.fn.dataTable.isDataTable('#dtTble')) {
                    //    table = $('#dtTble').DataTable();
                    //}
                    //else {
                    //    table = $('#dtTble').DataTable({
                    //        "ordering": false
                    //    });
                    //}
                }
            });
    }


        function editClick(id) {
            //location.href = 'AttendanceInfoList.aspx/AreaSetup", "Setup")?id=' + id + '';

        }
    </script>
--%>



</asp:Content>

