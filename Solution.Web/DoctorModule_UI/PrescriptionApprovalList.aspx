<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PrescriptionApprovalList.aspx.cs" Inherits="DoctorModule_UI_PrescriptionApprovalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">\

    <div id="popDiv"></div>
    
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Prescription List Approval</div>
                
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
                                               <input type="radio" checked id="Approve" name="rbApprove" value="Approve">
                                               <label for="Approve">Approve</label>
                                               <input type="radio" id="Reject" name="rbApprove" value="Reject">
                                               <label for="Reject">Reject</label><br>
                                             <br />
                                             
                                               <input type="button" name="next" class="btn btnMyDesignSearch   btn-sm" onclick="SaveApproval()" value="Submit Information" />

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

                            <table id="dtTble" class=" table  blueTable">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Prescription Date </th>
                                        <th>Prescription Type </th>
                                        <th>Doctor</th>
                                        <th>Approval Status</th>


                                        <th><input type="checkbox" id="CheckAll" name="CheckAll"></th>
                                    </tr>
                                </thead>
                                <tbody id="dtTableBody"></tbody>
                            </table>
                        </div>

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>


    <script>

        $(function () {

            GetPrescription();

            $("#CheckAll").click(function () {

                for (var i = 0; i < $('#dtTableBody tr').length; i++) {
                    RowId = i;
                    RowId++;
                    $("input[name='CheckBox[" + RowId + "].rowCount']").not(this).prop('checked', this.checked);
                }


            });


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


                var urlpath = 'Setup.aspx/Approve_PrescriptionList';
                $.ajax({

                    data: JSON.stringify({ 'MyArry': srt, 'rbValue': rbValue }),
                    //data: jsonData,
                    url: urlpath,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    _close_LoadingPopUp_WithMsg();
                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'PrescriptionApprovalList.aspx');
                    } else {
                        faildalert('Operation Faild!', 'Faild');
                    }

                },
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');

                },

            });
            }
        }


        function GetPrescription() {
            var param = " and PM.ApprovalStatus<>'Approved' ";
            var urlpath = 'Setup.aspx/Get_PrescriptionList';
            $.ajax({
               

                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'param': param}),
                contentType: "application/json; charset=utf-8",
                type: "POST",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {

                    $('#tabH').show();
                    var result = JSON.parse(data);

                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        RowId++;
                        var TPMaster = result[i].PrescriptionId;
                        var rowCount = RowId;
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + result[i].PrescriptionDate + "</td>";
                        row += "<td>" + result[i].PrescriptionType + "</td>";
                        row += "<td>" + result[i].DoctorName + "</td>";
                        row += "<td>" + result[i].ApprovalStatus + "</td>";
                        row += "<td>" + '<input type="checkbox" id="CheckBox" name="CheckBox[' + RowId + '].rowCount">' + "</td>";
                        row += "<td>" + '<input type = "hidden" style = "text-align:center" id = "HfFieldName"  name ="DoctorList[' + RowId + '].TPMaster" value = "' + TPMaster + '" />' + "</td>"

                        //if (result[i].IsActive) {
                        //    row += "<td><span class='badge badge-success'>Active</span></td>";
                        //} else {
                        //    row += "<td><span class='badge badge-warning'>Inactive</span></td>";
                        //}
                     /*   row += "<td><button class='btn-outline-warning   btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].PrescriptionId + ")'><i class='fas fa-pen' aria-hidden='true'></i></button> </td>";*/
                        row += "</tr>";

                        //<button class='btn-outline-danger   btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].PrescriptionId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    if ($.fn.dataTable.isDataTable('#dtTb')) {
                        table = $('#dtTb').DataTable();
                    }
                    else {
                        table = $('#dtTb').DataTable({
                            "ordering": false
                        });
                    }
                }
            });
    }


             function editClick(id) {
           location.href = '@Url.Action("DoctorPlanDetailsView", "DoctorVisit")?id=' + id + '';


        }


    </script>

</asp:Content>

