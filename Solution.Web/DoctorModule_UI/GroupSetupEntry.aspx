<%@ Page Title="Region Setup" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="GroupSetupEntry.aspx.cs" Inherits="DoctorModule_UI_GroupSetupEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="popDiv">

</div>
    
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Region  Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/GroupSetupView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                <label for="mainName" class="col-sm-3 col-form-label"> National </label>

                                <div class="col-sm-5">
                                      <div class="input-group">
                                                                            <select id="NationalSelect" name="NationalSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
                                        <span id="v-NationalSelect" class="invalid-tooltip fade hide" data-delay="1000"></span>
<span class="input-group-text text-c-red">*</span>
                                  

                                          </div>

                                </div> 
                            </div>
                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Group Code </label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3 "   id="GroupCode" placeholder="Group Code">

                                        <span id="v-GroupCode" class="invalid-tooltip fade hide" data-delay="1000">
                                        </span>
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>

                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Group Name </label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3 " required="true" id="GroupName" placeholder="Group Name">

                                        <span id="v-GroupName" class="invalid-tooltip fade hide" data-delay="1000">
                                        </span>
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>


                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />
                                    <div class="col-sm-7">
                                         <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="customSwitch1" checked>
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

        $(function () {

            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }
            else {
                GetNationalInfo(0);
            }
        });

       
        function GetNationalInfo(id) {
            _GetNational_Active($('#NationalSelect'), 'NationalId', 'NationalName', id);
            $('#NationalSelect').val(1).trigger('change');

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


        function ResetLink() {
            location.reload();
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

        

            $('#GroupName').removeClass('is-invalid');

            RemoveValidationTooltip("#v-GroupName");


            $('#GroupCode').removeClass('is-invalid');

            RemoveValidationTooltip("#v-GroupCode");
        
             isValid = true;
            if ($('#GroupName').val() == "") {


                $('#GroupName').addClass("is-invalid");
                ValidationTooltip("#v-GroupName", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#GroupCode').val() == "") {


                $('#GroupCode').addClass("is-invalid");
                ValidationTooltip("#v-GroupCode", "Please fill out of this field!");
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
            jsonData["GroupId"] = $('#masterId').val();
           
            jsonData["NationalId"] = $('#NationalSelect').val();
            jsonData["GroupName"] = $.trim($('#GroupName').val());
            jsonData["CodeStr"] = $.trim($('#GroupCode').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');

            var urlpath = 'GroupSetupEntry.aspx/Save_groupSetupInfo';
            $.ajax({
                data: JSON.stringify({ 'department': jsonData }),
                url: urlpath,
                type: "POST", contentType: "application/json; charset=utf-8",
               
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    //_close_LoadingPopUp_WithMsg();
                    result = result.d;


                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'GroupSetupView.aspx');
                    }
                    else if (result.isValiCheck == true) {

                        faildalert('Data cannot be deactivated!', 'Faild');
                    }
                    else if (result.isDuplicateCheck == true) {

                        faildalert('Already Exist!', 'Faild');
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

            var urlpath = 'GroupSetupEntry.aspx/GetGroupSetupEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    GetGroupInfo(data.NationalId);
                    $('#GroupName').val(data.GroupName);
                    $('#GroupCode').val(data.GroupCode);
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

