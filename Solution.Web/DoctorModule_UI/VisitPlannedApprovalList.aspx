<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="VisitPlannedApprovalList.aspx.cs" Inherits="DoctorModule_UI_VisitPlannedApprovalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <div id="popDiv"></div>
    
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Visit Plan  List Approval</div>
                
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
                              <div class="col-md-4"></div>
                              <div class="col-md-4">
                                  
					<div class="col">
					<div class="card radius-10  bg-gradient">
							<div class="card-body">
								<div class="text-center">
									<div>
										  <div class="form-group">

                                               <label style="font-weight: bold">Approval Status:&nbsp;<span style="color: #a52a2a">*</span></label>

                                             <div style="padding:10px;text-align:center">
                                                  <asp:RadioButtonList runat="server" ID="chkAction" CssClass="chkRadioChoice" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                  <asp:ListItem Selected="True" Value="2">Approve</asp:ListItem>
                                                  <asp:ListItem Value="3">Reject</asp:ListItem>
                                               </asp:RadioButtonList>
                                             </div>
                                              
                                             
                                                <asp:LinkButton  OnClick="btnSave_Click"  OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit Information
                                        </asp:LinkButton>

                                           </div>
									</div>
									
									</div>
								</div>
							</div>
						</div>
					</div>
                               
                              </div>
                         
                          

                              


                            <div style="padding-top:10px;"></div>


                                            <div class="table-responsive" id="MainGradeDiv">

                                   


                                                    <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="DocTPMaster" 
                                CssClass="table table-striped table-bordered"    onrowcommand="loadGridView_RowCommand"   OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("DocTPMaster")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                           <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-control-sm" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" CssClass="form-control-sm"   runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                                    <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                                    <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                    
                                    <asp:BoundField DataField="RoleName" HeaderText="User Role" />
                                    <asp:BoundField DataField="YearValue" HeaderText="Year" />
                                    <asp:BoundField DataField="MonthName1" HeaderText="Month" />
                                    <asp:BoundField DataField="FinalSubmitRemarks" HeaderText="Remarks" />
                                    <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />
                              
         <asp:TemplateField HeaderText="View">
                                        <ItemTemplate>

                                               <asp:LinkButton ID="LinkButton1" runat="server" class="btn-success  btn-sm mb-1 mb-md-0"
                                                                    CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData"><i class='fa fa-eye' aria-hidden='true'></i></asp:LinkButton>
                                             
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                </Columns>
                            </asp:GridView>
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
 <%--    <script>

        $(function () {

            GetPrescription();

          


    });
         $("#CheckAll").click(function () {

             for (var i = 0; i < $('#dtTableBody tr').length; i++) {
                 RowId = i;
                 RowId++;
                 $("input[name='CheckBox[" + RowId + "].rowCount']").not(this).prop('checked', this.checked);
             }


         });

        function IsActiveChange() {
            var isActive = $('#customSwitch1').is(':checked');
            $('#acttxt').text("");
            if (isActive) {
                $('#acttxt').text("Approve");

            } else {
                $('#acttxt').text("Reject");
            }
        }



        var RowId = 0;



        function validation() {

            debugger;
            var Isvalid = true;
            var NotValid = false;

            var countCh = 0;

            for (var i = 0; i < $('#dtTableBody tr').length; i++) {
                RowId = i;
                RowId++;

                var Cb = $("input[name='CheckBox[" + RowId + "].rowCount']").is(':checked');

                if (Cb != true) {
                    countCh++;
                }


            }

            if (countCh == i) {

                alert("Please select at least one row from List!!!")
                return NotValid;
            }

             return Isvalid;
        }

        function SaveApproval() {

            if (validation()) {

                var jsonData = {};
                jsonData["Id"] = $('#masterId').val();

               // var jsonObjs = [];

                var MyArry = [];

                var id = "";

                for (var i = 0; i < $('#dtTableBody tr').length; i++) {

                        RowId = i;
                        RowId++;

                    var TPMaster = $("input[name='DoctorList[" + RowId + "].TPMaster']").val();
                        var check = $("input[name='CheckBox[" + RowId + "].rowCount']").is(':checked');
                       if (check == true) {


                           id = id + TPMaster + ',';

                      //  MyArry.push(DoctorId);
                            //theObj["DoctorId"] = DoctorId;
                            //jsonObjs.push(theObj);
                            //jsonData["doctors"] = jsonObjs;
                    }


                }

                var index = id.lastIndexOf(',');

                var srt = id.substring(0, index);

                var radioValue = $("input[name='rbApprove']:checked").val();



              //  console.log(MyArry);


                var urlpath = 'Setup.aspx/Approve_TourPlanList';
            $.ajax({
                
                data: JSON.stringify({ 'MyArry': srt, 'rbValue': radioValue }),
                //data: jsonData,
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (result) {
                    $("#coverScreen").hide();

                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'TourPlannedApprovalList.aspx');
                    } else {
                        faildalert('Operation Faild!', 'Faild');
                    }

                },
                error: function (data) {
                    $("#coverScreen").hide();

                    faildalert('Operation Faild!', 'Faild');

                },

            });
            }
        }


        function GetPrescription() {
 
            var param = " and mas.ApprovalStatus<>'2' ";
            var urlpath = 'Setup.aspx/TourPlanApproveList';
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

                    $('#tabH').show();
                    var result = JSON.parse(data.d);

                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        RowId++;
                        var TPMaster = result[i].TPMaster;
                        var rowCount = RowId;
                        row += "<tr>";
                        row += "<td>" + (RowId) + "</td>";
                   
                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $("#coverScreen").hide();

                    $('#dtTble').dataTable({
                        "ordering": false
                    });
                }
            });
    }



           function editClick(id) {
            location.href = '@Url.Action("TourPlanDetailsView", "TourPlan")?id=' + id + '';

        }

     </script>--%>



</asp:Content>

