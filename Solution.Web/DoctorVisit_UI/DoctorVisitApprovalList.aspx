<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorVisitApprovalList.aspx.cs" Inherits="DoctorVisit_UI_DoctorVisitApprovalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
<style>


    #msform .action-button {
        width: 100px;
        background: #52A8E6;
        font-weight: bold;
        color: white;
        border: 0 none;
        border-radius: 0px;
        cursor: pointer;
        padding: 10px 5px;
        margin: 10px 0px 10px 5px;
        float: right
    }

        #msform .action-button:hover,
        #msform .action-button:focus {
            background-color: #311B92
        }

    #msform .action-button-previous {
        width: 100px;
        background: #616161;
        font-weight: bold;
        color: white;
        border: 0 none;
        border-radius: 0px;
        cursor: pointer;
        padding: 10px 5px;
        margin: 10px 5px 10px 0px;
        float: right
    }

        #msform .action-button-previous:hover,
        #msform .action-button-previous:focus {
            background-color: #000000
        }


    fieldset.for-panel {
        background-color: #fcfcfc;
        border: 1px solid #999;
        padding: 15px 10px;
        background-color: white;
        margin-bottom: 12px;
    }

        fieldset.for-panel legend {
            background-color: #fafafa;
            border: 1px solid #ddd;
            border-radius: 1px;
            font-size: 12px;
            font-weight: bold;
            line-height: 10px;
            margin: inherit;
            padding: 7px;
            width: auto;
            margin-bottom: 0;
            color: black;
        }
</style>

<div class="container-fluid" style="width: 100% !important;">

    <div class="page-body m-t-20">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                        <h5 class=""> <i class="fas fa-1x fa-th-large "></i> Doctor Visit Approval List </h5>

                    </div>



                    <div class="card-body">



                        <div class="row">
                            <div class="col-md-4">
                            </div>
                            <div class="col-md-3">


                                <fieldset class="for-panel">
                                    <div class="row">
                                        <div class="col-md-6" style="text-align:right">
                                            <label style="font-weight: bold">Approval Status:&nbsp;<span style="color: #a52a2a">*</span></label>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">


                                                <input type="radio" checked id="Approve" name="rbApprove" value="Approved">
                                                <label for="Approved">Approve</label>
                                                <input type="radio" id="Reject" name="rbApprove" value="Rejected">
                                                <label for="Reject">Reject</label><br>


                                                <input type="button" name="next" class="btn btn-success btn-block" onclick="SaveApproval()" value="Submit" />

                                            </div>
                                        </div>
                                    </div>
                                </fieldset>


                            </div>
                        </div>







                        <div style="padding-top:10px;"></div>

                        <div class="table-responsive" id="MainGradeDiv">

                            <table id="dtTble" class=" table  blueTable">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Employee ID</th>
                                        <th>Employee Name</th>
                                        <th>Designation</th>
                                        <th>User Role</th>
                                        <th>Year</th>
                                        <th>Month</th>
                                        <th>Remarks</th>

                                        <th>Approval Status</th>
                                        <th>View</th>

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


            var urlpath = '@Url.Action("Approve_DoctorPlanList", "DoctorVisit")';
            $.ajax({
                data: { MyArry: srt, rbValue: radioValue },
                url: urlpath,
                type: "POST",
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    _close_LoadingPopUp_WithMsg();
                    if (result.isSuccess == true) {
                        $.confirm({
                            icon: 'fas fa-check-circle',
                            title: 'Success !',
                            content: 'Information Approved successfully',
                            type: 'green',
                            buttons: {
                                OK: {
                                    text: 'OK',
                                    action: function () {

                                        location.reload();
                                        $("input[name='CheckAll").prop('checked', false);
                                    }
                                }
                            }
                        });

                    } else {
                        _saveError();
                    }

                },
                error: function (data) {
                    _close_LoadingPopUp_WithMsg();
                    _saveError();
                },

            });
            }
        }


        function GetPrescription() {
            var param = "";
           var urlpath = '@Url.Action("GetDoctorVisitList", "DoctorVisit")';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: { param: param },
                type: "Get",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {

                    $('#tabH').show();
                    var result = JSON.parse(data);

                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        RowId++;
                        var TPMaster = result[i].DocTPMaster;
                        var rowCount = RowId;
                        row += "<tr>";
                        row += "<td>" + (RowId) + "</td>";
                        row += "<td  >" + result[i].EmpMasterCode + "</td>";
                        row += "<td  >" + result[i].EmpName + "</td>";
                        row += "<td  >" + result[i].DesigName + "</td>";
                        row += "<td  >" + result[i].RoleName + "</td>";
                        row += "<td  >" + result[i].YearValue + "</td>";
                        row += "<td  >" + result[i].MonthName1 + "</td>";
                        row += "<td  >" + result[i].FinalSubmitRemarks + "</td>";
                        row += "<td>" + result[i].ApprovalStatus + "</td>";

                        row += "<td><button class='btn-outline-success  btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].DocTPMaster + ")'><i class='fas fa-eye' aria-hidden='true'></i></button> </td>";


                        row += "<td>" + '<input type="checkbox" id="CheckBox" name="CheckBox[' + RowId + '].rowCount">' + "</td>";
                        row += "<td>" + '<input type = "hidden" style = "text-align:center" id = "HfFieldName"  name ="DoctorList[' + RowId + '].TPMaster" value = "' + TPMaster + '" />' + "</td>"

                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    $('#dtTble').dataTable({
                        "ordering": false
                    });
                }
            });
    }


             function editClick(id) {
           location.href = '@Url.Action("DoctorPlanDetailsView", "DoctorVisit")?id=' + id + '';


        }


    </script>

 
</asp:Content>

