<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="GenericGroupEntry.aspx.cs" Inherits="DoctorModule_UI_GenericGroupEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="popDiv">

</div>

    
      
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"> <i class="bx bx-customize"></i> Generic Group Entry</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                           <a href="../DoctorModule_UI/GenericGroupView.aspx" class="btn btn-sm btn-sm btn-outline-info">
                          
                          <i class="fa fa-backward"></i>&nbsp; Back to list
                        </a>

                       


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            
                                    <div class="p-4 border rounded">
                                        <div class="row g-3 needs-validation">

                                            <div class="row">&nbsp;</div>
                                            <div class="row">&nbsp;</div>
                                            <div class="row">
                                                <div class="col-2">&nbsp;</div>
                                                <div class="col-10">

                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">Generic Group:  </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                                                                  <input type="text" class="form-control form-control-sm mb-3" required="true" id="GenericGroup" placeholder="Generic Group">

                                        <span id="v-GenericGroup" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                                <span class="input-group-text text-c-red">*</span>
                                                            </div>

                                                       
                                                           


                                                            </div>
                                                        </div>

                                                 


                                                       <div class="form-group row">
                                                        <label for="mainName" class="col-sm-3 col-form-label">   </label>

                                                        <div class="col-sm-5">
                                                            <div class="input-group">
                                                                 <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="customSwitch1" checked onchange="IsActiveChange()">
                                            <label style="padding-top:4px;" class="custom-control-label" for="customSwitch1"> Is Active</label>
                                        </div>
                                                            </div>

                                                       <br />
                                                           
                                                  

                                                            </div>

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

                                                    </div>

                                                   </div>

                                                </div>
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
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
            }

        let id = $('#masterId').val();

        if (id > 0) {
            GetData(id);
        } else {

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

            $('#GenericGroup').removeClass('is-invalid');
            RemoveValidationTooltip("#v-GenericGroup");
            isValid = true;
            if ($('#GenericGroup').val() == "") {

                $('#GenericGroup').addClass("is-invalid");
                ValidationTooltip("#v-GenericGroup", "Please fill out of this field!");
                isValid = false;
            }


        return isValid;
    }



        function ConfirmationClick() {
            location.reload();
        }


        function Save() {

            if (Validation()) {
            
                            FinalSave();
            

        }

    }
        function FinalSave() {



        var jsonData = {};
            jsonData["GenericGroupId"] = $('#masterId').val();
            jsonData["GenericGroupName"] = $.trim($('#GenericGroup').val());
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');


            var urlpath = 'GenericGroupEntry.aspx/Save_GenericGroup';
            $.ajax({
                
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'generic': jsonData }),
                type: "POST", contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    //_close_LoadingPopUp_WithMsg();
                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'GenericGroupView.aspx');
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

        function GetData(id) {

            var urlpath = 'GenericGroupEntry.aspx/GetGenericGroupEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#GenericGroup').val(data.GenericGroupName);
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

