<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="District_Entry.aspx.cs" Inherits="Thana_UI_District_Entry" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> District Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="District_View.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <br />
 


                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="Division" class="col-sm-3 col-form-label"> Division </label>
                                    <div class="col-sm-7">
                                        <select id="DivisionDDL" name="DivisionDDL" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-DivisionDDL" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                            </div>
                        </div>




                        <div class="row mt-1" style="display:none">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="Division" class="col-sm-3 col-form-label"> District </label>
                                    <div class="col-sm-7">
                                        <select id="DistrictDDL" name="DistrictDDL" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-DistrictDDL" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>
                            </div>
                        </div>


                  
                   

                        <div class="row mt-1">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                <div class="form-group row">
                                    <label for="ThanaName" class="col-sm-3 col-form-label">District</label>
                                    <div class="col-sm-7">
                                        <input type="text" class="form-control form-control-sm sm-3" id="ThanaName" autocomplete="off" placeholder="Enter District">
                                        <span id="v-ThanaName" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                            </div>
                        </div>


                        <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-9">
                                         <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm" onclick="Save()">
                                                <i class="fa fa-check"></i>Submit
                                            </button>
                                            <button type="button" class="btn btnMyDesignReset   btn-sm" onclick="ResetLink()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>

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
        function ResetLink() {
            location.reload();
        }
    $(function () {
        let id = $('#masterId').val();
        id = getUrlVars()["id"];
        if (id > 0) {
         
            GetThanaEdit(id);
            $('#masterId').val(id);
        } else {
            GetDisivionAll(0);
        }
    });

    function getUrlVars() {
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    }

        $("#DivisionDDL").on("change", function (e) {

            var divisionId = $("#DivisionDDL").val();
            if (divisionId > 0) {
                GetDistrictByDisivion(0, divisionId);
            }
        });


    function ConfirmationClick() {
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


    function GetDisivionAll(id) {
        var urlpath = 'ThanaEntry.aspx/Get_Division_All_DDL';
        SelectOption_DtTable_Async_True(urlpath, $('#DivisionDDL'), 'DivisionId', 'DivisionName', id);
        $('#DivisionDDL').select2();
     }


    function GetDistrictByDisivion(SetId, id) {

        var urlpath = 'ThanaEntry.aspx/Get_District_All_DDL';
        LoadSelectOption_ById(urlpath, $('#DistrictDDL'), 'DistrictId', 'DistrictName', SetId, id);
        $('#DistrictDDL').select2();
       
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

         $('#DivisionDDL').removeClass('is-invalid');
         $('#DistrictDDL').removeClass('is-invalid');
         $('#ThanaName').removeClass('is-invalid');
          
         RemoveValidationTooltip("#v-DivisionDDL");
         RemoveValidationTooltip("#v-DistrictDDL");
         RemoveValidationTooltip("#v-ThanaName");       
         isValid = true;

         if ($('#DivisionDDL').val() == 0) {

             $('#DivisionDDL').addClass("is-invalid");
             ValidationTooltip("#v-DivisionDDL", "Please fill out of this field!");
                isValid = false;
            }

         //if ($('#DistrictDDL').val() == 0) {

         //    $('#DistrictDDL').addClass("is-invalid");
         //    ValidationTooltip("#v-DistrictDDL", "Please fill out of this field!");
         //       isValid = false;
         //   }

         if ($('#ThanaName').val() == "") {

             $('#ThanaName').addClass("is-invalid");
             ValidationTooltip("#v-ThanaName", "Please fill out of this field!");
                isValid = false;
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
        jsonData["ThanaId"] = $('#masterId').val();
        jsonData["district_id"] = $('#DivisionDDL').val();
        jsonData["ThanaName"] = $('#ThanaName').val();

        var urlpath = 'ThanaEntry.aspx/Save_DistictInfo';
            $.ajax({
                data: JSON.stringify({ 'thanaDao': jsonData }),
                url: urlpath,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'District_View.aspx');
                    }
                    else if (result.isValiCheck == true) {

                        faildalert('Data cannot be deactivated!', 'Faild');
                    }
                    else {
                        faildalert('Operation Faild!', 'Faild');
                    }
                    
                  

                },
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');
                },


            });
    }


    function GetThanaEdit(id) {

        var urlpath = 'ThanaEntry.aspx/Get_District_By_Id';
            $.ajax({
                url: urlpath,
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{id : '" + id + "'}",
                async: false,
                success: function (data) {

                    var result = JSON.parse(data.d);

                 
                    GetDisivionAll(result[0].DivisionId);
                    //GetDistrictByDisivion(result[0].DistrictId, result[0].DivisionId)
                 
                    $('#ThanaName').val(result[0].DistrictName);
                    
                },
                complete: function () {

                    $("#btnSave").html(" <i class='fa fa-check-square'></i>&nbsp;Update");

                }
            });
        }

    </script>
</asp:Content>

