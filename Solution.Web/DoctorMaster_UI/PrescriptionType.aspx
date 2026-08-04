<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PrescriptionType.aspx.cs" Inherits="DoctorMaster_UI_PrescriptionType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <style>
        .form-switch {
        padding-left: 2.5em;
    }
    .form-check {
        display: block;
        min-height: 1.5rem;
        padding-left: 1.5em;
        margin-bottom: .125rem;
    }
</style>


        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Prescription Type Entry</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        <a href="../DoctorMaster_UI/PrescriptionTypeView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            
                            <div class="row">&nbsp;</div>
                            <div class="row">&nbsp;</div>
                            <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Prescription Type:  </label>

                                    <div class="col-sm-7">
                                        <input type="text" class="form-control form-control-sm " required="true" id="mainName" placeholder="Prescription Type">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                                <div class="form-group row" style="margin-top:7px;">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                    <div class="col-sm-7">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label style="padding-top:4px;" class="custom-control-label" for="customSwitch1"> Active</label>
                                        </div>
                                    </div>

                                </div>

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"> Active Date: </label>
                                    <div class="col-sm-7">
                                        <input id="acDate" type="text" class="form-control" required autocomplete="off" placeholder="Select Date" data-date-autoclose="true" data-date-today-highlight="true" data-date-format="dd-M-yyyy">

                                        <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>




                                </div>
                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                        <br /> 

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                        <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" style="background-color: #00bcd4;color: #fff;" onclick="Save()">
                                            <i class="fa fa-check"></i>&nbsp; Submit 
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm" style="background-color: orangered; color: #fff;" onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset  </button>
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                  


                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
    
    
    <asp:TextBox runat="server" ID="masterId" Style="display: none"></asp:TextBox>
    

    <script type="text/javascript">

        $(function () {

            var id = $('#ContentPlaceHolder1_masterId').val();

        if (id > 0) {
           // $('#acDate').datepicker();
           GetPrescriptionTypeData(id);
        } 
    });


        function ConfirmationClick(parameters) {
            location.reload();
        }


    function IsActiveChange() {
        var isActive = $('#customSwitch1').is(':checked');
        $('#pacinTxt').text("");
        if (isActive) {
            $('#pacinTxt').text("Active Date");
        } else {
            $('#pacinTxt').text("InActive Date");
        }
    }

        function Validation() {
        var isValid = true;
        if ($('#mainName').val() == "") isValid = false;
        if ($('#acDate').val() == "") isValid = false;
        if (isValid == false) {
            $.confirm({
                icon: 'fas fa-exclamation-triangle',
                title: 'Validation Error!',
                content: 'Please enter mandatory data',
                type: 'red',
                typeAnimated: true

            });
        }
        return isValid;
    }

    function Save() {

        if (Validation()) {
            FinalSave();
        }

    }
    function FinalSave() {
        var jsonData = {};
        jsonData["PrescriptionTypeId"] = $('#ContentPlaceHolder1_masterId').val();
        jsonData["PrescriptionTypename"] = $('#mainName').val();
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["Activedate"] = $('#acDate').val();
        $.ajax({
                url: 'PrescriptionType.aspx/Save_PrescriptionType',
                data: '{aPrescriptionType: ' + JSON.stringify(jsonData) + '}',
                dataType: 'json',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    _close_LoadingPopUp_WithMsg();
                    if (result.d.isSuccess == true) {
                        successalert('Operation successful!', 'Success', 'PrescriptionTypeView.aspx');
                    } else {

                        alert("Already exists");
                        //_saveErrorDuplicate();
                      //  faildalert('Operation Faild!', 'Faild');
                    }
                },
                error: function (data) {

                    faildalert('Operation Faild!', 'Faild');

                }

            });
        }

       
        function GetPrescriptionTypeData(id) {
            $.ajax({
                url: 'PrescriptionType.aspx/GetDoctorSpecialDayForEdit',
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{id : '" + id + "'}",
                async: true,
                success: function (data) {
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.d.PrescriptionTypename);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.d.Activedate));
                    if (data.d.IsActive) {
                        $('#customSwitch1').prop('checked', true);
                        $('#acttxt').text("Active Date: ");
                    } else {
                        $('#customSwitch1').prop('checked', false);
                        $('#acttxt').text("Inactive Date: ");
                    }
                },
                complete: function () {

                }
            });
        }
    </script>
</asp:Content>

