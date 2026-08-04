<%@ Page Title="Mileage Claim List" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="MileageClaimView.aspx.cs" Inherits="DoctorModule_UI_MileageClaimView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Mileage Claim  List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                            <a href="../DoctorModule_UI/MileageClaim.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                                                       <asp:HiddenField ID="hfEmpTerrId" runat="server" />
<asp:HiddenField ID="hfEmpAreaId" runat="server" />
<asp:HiddenField ID="hfEmpRegionId" runat="server" />
<asp:HiddenField ID="hfEmpGroupId" runat="server" />
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
                                             <div class="table-responsive" id="MainGradeDiv">


                                                 
                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="MileageClaimId" 
                                onrowcommand="loadGridView_RowCommand"  CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                      <asp:BoundField DataField="MileageDate" HeaderText="Mileage Claim  Date" />
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                                   
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                             

                                    <asp:BoundField DataField="TransportName" HeaderText="Transport Name" 
 />
                                    <asp:BoundField DataField="MileageInKM" HeaderText="Mileage In KM"  />
                                    <asp:BoundField DataField="Expense" HeaderText="Expense"  />
                                    <asp:BoundField DataField="MeterReading" HeaderText="Meter Reading"  />

                                       <asp:TemplateField HeaderText="Meter Image">
                                        <ItemTemplate>
                                          <a href='<%#Eval("ImageString")%>'
             ID="hpImg"
             runat="server" class="fancybox "  >
                          
                                               <asp:Image ID="imgShow" runat="server" CssClass="imgCSS"   ImageUrl='<%#Eval("ImageString")%>'  Width="45" Height="45"  />
                                                </a>
                                            </ItemTemplate>
                                         </asp:TemplateField>
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status"  />
                                  
                                      <asp:BoundField DataField="CreateBy" HeaderText="Created By"  /> 
                                    <asp:BoundField DataField="EntryDate" HeaderText="Created At"  /> 
                                 
                                 

                                        <asp:BoundField DataField="UpdateBy" HeaderText="Updated By"  /> 
                                    <asp:BoundField DataField="UpdateDate" HeaderText="Updated At"  /> 

                                     <asp:BoundField DataField="" HeaderText="Forwarded By"  /> 
                                    <asp:BoundField DataField="" HeaderText="Forwarded At"  /> 

                                    
                                     <asp:BoundField DataField="ApprovalLog" HeaderText="Approved By"  /> 
                                    <asp:BoundField DataField="ApproveDate" HeaderText="Approved At"  /> 

                                 
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="LinkButton1" runat="server" class="btn-warning  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='bx bxs-edit' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
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

