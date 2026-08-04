<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CustomerType.aspx.cs" Inherits="MasterSetup_UI_CustomerType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

        <div id="popDiv">

</div>
    
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Customer Type Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="CustomerTypeView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                             <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">



                                    <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Customer Category </label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                           <select id="CategorySelect" name="CategorySelect" class="form-select form-select-sm mb-3 mySelect2">


                                             
                                        </select>
                                        <span id="v-CategorySelect" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                                  <span class="input-group-text text-c-red">*</span>
</div>

                                    </div>
                                   
                                </div>

                                <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Customer Type </label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                        <input type="text" class="form-control form-control-sm mb-3" required="true" id="mainName" placeholder="Type name">

                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                                  <span class="input-group-text text-c-red">*</span>
</div>

                                    </div>
                                   
                                </div>

                                  <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="IsCampaign" checked   >
												 <label  class="custom-control-label" for="IsCampaign">Is Order Approval</label>
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

                                   <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="customSwitch1" checked   >
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

        $(function () {


            GetCustomerCategory(0);

            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            }





        });


        function GetCustomerCategory(id) {
            var urlpath = '../DoctorModule_UI/Setup.aspx/GetCustomerCategory';
            SelectOption_DtTable_Async_True(urlpath, $('#CategorySelect'), 'CustomerCategoryId', 'CustomerCategory', id);
            $('#CategorySelect').select2();
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
                function ResetClick() {
            location.href = '@Url.Action("CustomerType", "CustomerType")';

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
            $('#CategorySelect').removeClass('is-invalid');

            RemoveValidationTooltip("#v-mainName");
            RemoveValidationTooltip("#v-Days");
             isValid = true;
            if ($('#mainName').val() == "") {


                $('#mainName').addClass("is-invalid");
                ValidationTooltip("#v-mainName", "Please fill out of this field!");
                isValid = false;
            }


            if ($('#CategorySelect').val() == "" && $('#CategorySelect').val() == null && $('#CategorySelect').val() == "0") {
                $('#CategorySelect').addClass("is-invalid");
                ValidationTooltip("#v-CategorySelect", "Please fill out of this field!");
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
            jsonData["CustomerTypeId"] = $('#masterId').val();
            jsonData["CustomerTypee"] = $.trim($('#mainName').val());

            jsonData["CustomerCategoryId"] = $('#CategorySelect').val() ;


            jsonData["IsActive"] = $('#customSwitch1').is(':checked');

            jsonData["IsCampaign"] = $('#IsCampaign').is(':checked');
            jsonData["IsDefault"] = $('#IsDefault').is(':checked');
            //jsonData["IsTradeDiscount"] = $('#IsTradeDiscount').is(':checked');
            //jsonData["IsFixedDiscount"] = $('#IsFixedDiscount').is(':checked');


            var urlpath = 'CustomerTypeSetup.aspx/Save_DepartmentInfo';
            $.ajax({
                data: JSON.stringify({ 'department': jsonData }),
                url: urlpath,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                 //   _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    
                    var result = result.d;

                    if (result.isSuccess == true) {
                       
                            successalert('Operation successful!', 'Success', 'CustomerTypeView.aspx');
                        
                    }
                    else if (result.isDuplicateCheck == true) {

                        faildalert('Already Exist!', 'Faild');


                    }

                    else if (result.isValiCheck == true) {

                        faildalert('Is Default Already Exist!', 'Faild');


                    }

                    else {
                        faildalert('Operation Faild!', 'Faild');
                    }
                },
                error: function (data) {
                    //_close_LoadingPopUp_WithMsg();
                    faildalert('Operation Faild!', 'Faild');
                },
            });
        }

        function GetData(id) {

            var urlpath = 'CustomerTypeSetup.aspx/GetDepartmentEditData';
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

                    $('#mainName').val(data.CustomerTypee);
                  GetCustomerCategory(data.CustomerCategoryId);
                   // $('#CategorySelect').val(data.CustomerCategoryId)

                    if (data.IsCampaign) {
                        $('#IsCampaign').prop('checked', true);

                    } else {
                        $('#IsCampaign').prop('checked', false);

                    }

                    if (data.IsDefault) {
                        $('#IsDefault').prop('checked', true);

                    } else {
                        $('#IsDefault').prop('checked', false);

                    }


                    //if (data.IsFixedDiscount) {
                    //    $('#IsFixedDiscount').prop('checked', true);

                    //} else {
                    //    $('#IsFixedDiscount').prop('checked', false);

                    //}



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

