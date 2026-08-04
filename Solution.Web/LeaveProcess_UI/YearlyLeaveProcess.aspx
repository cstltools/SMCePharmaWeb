<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="YearlyLeaveProcess.aspx.cs" Inherits="LeaveProcess_UI_YearlyLeaveProcess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Yearly Leave Process</div>

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
 
 


                        <div class=" text-center mt-5">  
                           
                                <h4 class="card-title">This process will set employee yearly leave balance  based on <br /> <br /> leave type and yeraly leave allocation.</h4>


                              <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" onclick="Save()">
                                              Process Leave &nbsp;<i class="fa fa-arrow-circle-o-right" aria-hidden="true"></i>
                                            </button>
                               
                            
                            
                        </div>

                        <div class="row">&nbsp;</div>
                        <div class="row">&nbsp;</div>
                        <div class="row">
                            
                        </div>
                   
                      

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    
       <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>
<input id="masterId" value="0" style="display:none" />
 
    <script>

    $(function () {

        $("#coverScreen").hide();


        //$("#zoneSelect").on("change", function (e) {
        //    var areaId = $("#zoneSelect").val();
        //    if (areaId > 0) {
        //        GetArea_ByZone(0, areaId);

        //    }
        //});
    });


    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#acttxt').text("");
        if (isActive) {
            $('#acttxt').text("Active Date:");

        } else {
            $('#acttxt').text("Inactive  Date:");
        }
    }

        function ValidationTooltip(id, message) {


            $(id).empty();

            if ($(id).empty()) {
                $(id).append(message);
            }
            $(id).toast('show');
            $(id).css("display", "block");



        }

        function RemoveValidationTooltip(id) {
            $(id).css("display", "none");
        }

        function Validation() {
            //$('#leave_year').removeClass('is-invalid');

            //RemoveValidationTooltip("#v-leave_year");

             isValid = true;
            //if ($('#leave_year').val() == "") {


            //    $('#leave_year').addClass("is-invalid");
            //    ValidationTooltip("#v-leave_year", "Please fill out of this field!");
            //    isValid = false;
            //}


        //if (isValid == false) {
        //    $.confirm({
        //        icon: 'fas fa-exclamation-triangle',
        //        title: 'Validation Error!',
        //        content: 'Please enter mandatory data',
        //        type: 'red',
        //        typeAnimated: true

        //    });
        //}

        return isValid;
    }



        function Save() {

            
             
                            FinalSave();
                      

       

    }
        function FinalSave() {

        var jsonData = {};
            jsonData["year"] = '2022';
          

            var urlpath = 'YearlyLeaveProcess.aspx/SaveYearlyLeave';
            $.ajax({
                data: JSON.stringify({}),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (result) {
                    result = result.d;


                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'YearlyLeaveProcess.aspx');
                    }
                    

                    else {
                        faildalert('Operation Faild!', 'Faild');
                    }
                },
                complete: function () {
                    $("#coverScreen").hide();
 
                },
                error: function (data) {
                    $("#coverScreen").hide();

                    faildalert('Operation Faild!', 'Faild');

                }
            });
        }

    function GetData(id) {
            var urlpath = '@Url.Action("GetDoctorDegreeEditData", "Setup")';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: {id : id},
                type: "Get",
                async: true,
                success: function (data) {


                    $("#btnSave").html(" <i class='fas fa-check-square'></i>&nbsp;Update Information");
                    $('#mainName').val(data.DegreeName);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.Activedate));
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);
                        $('#acttxt').text("Active Date:");
                    } else {
                        $('#customSwitch1').prop('checked', false);
                        $('#acttxt').text("Inactive  Date:");
                    }
                },
                complete: function() {
                }
            });
        }
    </script>
</asp:Content>

