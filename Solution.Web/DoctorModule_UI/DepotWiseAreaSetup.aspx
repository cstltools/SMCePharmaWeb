<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DepotWiseAreaSetup.aspx.cs" Inherits="DoctorModule_UI_DepotWiseAreaSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>

    .form-switch {
        padding-left: 2.5em !important;
    }

    .form-check {
        display: block !important;
        min-height: 1.5rem !important;
        padding-left: 1.5em !important;
        margin-bottom: .125rem !important;
    }

</style>

    <div id="popDiv"></div>
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Depot Wise Area Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/MarketRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                               <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Company Name: </label>
                                    <div class="col-sm-5">

                                        <div class="input-group">
                                        <select id="ddlCompany"  class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                     
                                </div>

                                <div  class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Depot Name: </label>
                                    <div class="col-sm-5">
                                        <div class="input-group">
                                        <select id="ddlDepot"  class="form-select form-select-sm mb-3 mySelect2"></select>
                                         <span class="input-group-text text-c-red">*</span>
                                    </div>
                                    </div>
                                     
                                </div>


                            </div>
                           
                        </div>

                              <div class="row">
                             
                            <div class="col-12">
                             <div class="form-group row">
                        <div  id="areas" class="row"></div>
                                 </div>
                                 </div>
                                  </div>
                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                        
                                         <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ConfirmationClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                      
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

 

<input id="masterId" value="0" style="display:none" />

 
    <script>

    $(function () {

        let id = $('#masterId').val();

        if (id > 0) {

            GetData(id);
        }

        // Load Dropdown

        LoadCompanyDdl();

        $("#ddlCompany").on("change", function (e) {
            var companyId = $("#ddlCompany").val();
            if (companyId > 0) {
                GetDepot_ByCompany(companyId);
            }
        });

        $("#ddlDepot").on("change", function (e) {
            var depotId = $("#ddlDepot").val();
            if (depotId > 0) {
                GetArea_ByDepot(depotId);
            }
        });

    });

        function LoadCompanyDdl()
        {

            var urlpath = 'DepotWiseAreaSetup.aspx/LoadCompany';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlCompany'), 'CompanyId', 'CompanyName', 0);
            $('#ddlCompany').select2();

        }

        function GetDepot_ByCompany(id) {

            _getDepot_ByCompanyId_Active($('#ddlDepot'), 'ComUnitId', 'UnitName', id);
        }

        function GetArea_ByDepot(id) {

            $.ajax({
                url: 'DepotWiseAreaSetup.aspx/LoadAreaByDepotId',

                dataType: 'json',

                type: "POST", contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'depotId': id }),
                //data: { comapnyId: id },
                async: true,
                 
                success: function (data) {
                    var result = JSON.parse(data.d);

                  

                    var html = "";

                    for (var i = 0; i < result.length; i++) {

                        html += '<div class="col-3">';
                        html += '<div class=" form-check">';
                        html += '<input class="form-check-input" type="checkbox" value="' + result[i].AreaId + '" ' + result[i].CheckStatus + '  id="flexCheckDefault' + result[i].AreaId + '">';
                        html += '<label class="form-check-label" for="flexCheckDefault' + result[i].AreaId + '">' + result[i].Area + '</label> &nbsp; ';
                        html += '</div> &nbsp;&nbsp;';
                        html += '</div>';
                       
                    }


                    $('#areas').html(html);


                    //setControlId.empty();
                    //setControlId.append($("<option>Select from list</option>").val(0));
                    //for (var i = 0; i < result.length; i++) {
                    //    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                    //}
                }
            });
        }


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

            debugger;

            $('#mainName').removeClass('is-invalid');

            RemoveValidationTooltip("#v-mainName");

             isValid = true;
            if ($('#mainName').val() == "") {


                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }


        return isValid;
    }



        function Save() {

            var jsonData = {};
            var depotId = $("#ddlDepot").val();
            

            var jsonObjs = [];


            $('#areas input:checked').each(function () {


                var theObj = {};
   
                theObj["AreaId"] = $(this).val();
                theObj["DepotId"] = depotId;

                jsonObjs.push(theObj);

                jsonData["DepotList"] = jsonObjs;

            });

            console.log(jsonData);


            var urlpath = 'DepotWiseAreaSetup.aspx/Save_DepotWiseAreaInfo';
            $.ajax({
                
                data: JSON.stringify({ 'areaDao': jsonData, 'DcId': depotId }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    _close_LoadingPopUp_WithMsg();

                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'DepotWiseAreaSetup.aspx');
                    } else {
                        faildalert('Operation Faild!', 'Faild');
                    }

                }
                 ,
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');
                },
            });


        //    if (Validation()) {
        //    $.confirm({
        //        icon: 'fas fa-question-circle',
        //        title: 'Are You Sure ?',
        //        content: 'You are about to save the data!',
        //        theme: 'Supervan',
        //        type: 'green',
        //        buttons: {
        //            Confirm: {
        //                text: 'Confirm',
        //                action: function () {
        //                    FinalSave();
        //                }
        //            },
        //            Cancel: function () {
        //            }
        //        }
        //    });

        //}

    }
        function FinalSave() {

            debugger;

        var jsonData = {};
            jsonData["DesignationId"] = $('#masterId').val();
            jsonData["DesigName"] = $.trim($('#mainName').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');


          var urlpath = '@Url.Action("Save_DesignationInfo", "Degisnation")';
            $.ajax({
                data: jsonData,
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
                            content: 'Operation successfully done!!',
                            type: 'green',
                            buttons: {
                                OK: {
                                    text: 'OK',
                                    action: function () {
                                var url = '@Url.Action("DesignationView", "Degisnation")';
                                window.location.href = url;
                                    }
                                }
                            }
                        });
                    } else {
                        _saveErrorDuplicate();
                    }
                },
                error: function (data) {
                    _close_LoadingPopUp_WithMsg();
                    _saveError();
                },
            });
        }

        function GetData(id) {

            var urlpath = '@Url.Action("GetDesignationEditData", "Degisnation")';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: {id : id},
                type: "Get",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fas fa-check-square'></i>&nbsp;Update Information");

                    $('#mainName').val(data.DesigName);


                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);

                    } else {
                        $('#customSwitch1').prop('checked', false);

                    }
                },
                complete: function() {
                }
            });
        }
    </script>




</asp:Content>

