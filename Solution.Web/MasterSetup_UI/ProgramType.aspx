<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ProgramType.aspx.cs" Inherits="MasterSetup_UI_ProgramType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <div id="popDiv">
    </div>


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Provider Type Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="ProgramTypeView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="mainName" class="col-sm-3 col-form-label"> Provider Type  </label>

                                    <div class="col-sm-5">
                                        <input type="text" class="form-control form-control-sm " required="true" id="mainName" placeholder="Type name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>

                                  <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="IsCustomer" checked   >
												 <label  class="custom-control-label" for="IsCustomer">For Customer</label>
												</div>
                                          
                                          
                                        </div>

                                    </div>

                                
                                  <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="IsDoctor" checked   >
												 <label  class="custom-control-label" for="IsDoctor">For Doctor</label>
												</div>
                                          
                                          
                                        </div>

                                    </div>

                              <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="IsDefault" checked   >
												 <label  class="custom-control-label" for="IsDefault">Is Default</label>
												</div>
                                          
                                          
                                        </div>

                                    </div>

                                

                                <div class="form-group row" style="margin-top:7px;">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                    <div class="col-sm-7">
                                      <div class="form-check form-switch">
                                            <input type="checkbox"  class="form-check-input"  id="customSwitch1" checked onchange="IsActiveChange()">
                                          	 <label  class="custom-control-label" for="customSwitch1">Active</label>
                                        </div>
                                    </div>

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
                                    <div class="col-sm-8">
                                          <button type="button" id="btnSave" class="btn btnMyDesignSearch   btn-sm"   onclick="Save()">
                                            <i class="fa fa-check"></i>Submit
                                        </button>
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ResetLink()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
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
        $(function () {

            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }





        });

           function ResetClick() {
            location.href = '@Url.Action("ProgramType", "ProgramType")';

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

            if (Validation()) {
            
                            FinalSave();
                       

        }

    }
        function FinalSave() {

            debugger;

        var jsonData = {};
            jsonData["ProgramTypeId"] = $('#masterId').val();
            jsonData["ProgramTypeName"] = $.trim($('#mainName').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');

            jsonData["IsCustomer"] = $('#IsCustomer').is(':checked');
            jsonData["IsDoctor"] = $('#IsDoctor').is(':checked');
            jsonData["IsDefault"] = $('#IsDefault').is(':checked');

            var urlpath = 'ProgramTypeView.aspx/Save_DepartmentInfo';
            $.ajax({
                data: JSON.stringify({ 'department': jsonData }),
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    _close_LoadingPopUp_WithMsg();
                    var result = result.d;
                    if (result.isSuccess == true) {
                        successalert('Operation successful!', 'Success', 'ProgramTypeView.aspx');
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

        function GetData(id) {

            var urlpath = 'ProgramTypeView.aspx/GetDepartmentEditData'; 
            $.ajax({
                url: urlpath,
                //data: {id : id},
                data: JSON.stringify({ 'id': id }),
                dataType: 'json',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {

                    data = data.d;

                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.ProgramTypeName);
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);

                    } else {
                        $('#customSwitch1').prop('checked', false);

                    }


                    if (data.IsCustomer) {
                        $('#IsCustomer').prop('checked', true);

                    } else {
                        $('#IsCustomer').prop('checked', false);

                    }

                    if (data.IsDoctor) {
                        $('#IsDoctor').prop('checked', true);

                    } else {
                        $('#IsDoctor').prop('checked', false);

                    }

                    if (data.IsDefault) {
                        $('#IsDefault').prop('checked', true);

                    } else {
                        $('#IsDefault').prop('checked', false);

                    }
                },
                complete: function() {
                }
            });
        }
    </script>

 


</asp:Content>

