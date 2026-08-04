<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TourPurposeSetup.aspx.cs" Inherits="DoctorModule_UI_TourPurposeSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="popDIv">

</div>


     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Purpose Records Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/TourPurposeRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->

            <style>
        .vvlabel {
            font-weight: bold;
            font-size: 18px;
        }
        .radio-container {
            margin-bottom: 10px;
            margin-right:10px;
        }
           .hidden {
            display: none;
        }
    </style>
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                             <div class="row">&nbsp;</div>
                                        <div class="row">
                                            <div class="col-2">&nbsp;</div>
                                            <div class="col-8">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">Visit Type:  </label>

                                                    <div class="col-sm-7">
                                                          <div class="input-group">
                                                    <div class="radio-container">
            <label class="vvlabel">
                <input type="radio" name="visitType" value="market" onclick="toggleAmountVisibility()"> Market Visit
            </label>
        </div>
        <div class="radio-container">
            <label class="vvlabel">
                <input type="radio" name="visitType" value="other" onclick="toggleAmountVisibility()"> Other Visit
            </label>
        </div>
                                                             </div>


                                                    </div>
                                                    
                                                </div> 
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">Tour Purpose:  </label>

                                                    <div class="col-sm-7">
                                                          <div class="input-group">
                                                        <input type="text" class="form-control form-control-sm mb-3" required="true" id="mainName" placeholder="Tour Purpose">

                                                        <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
    <span class="input-group-text text-c-red">*</span>
                                                             </div>


                                                    </div>
                                                    
                                                </div> 
                                                
                                                <div   class="form-group row hidden" id="divAmt"  >

                                                        <div class="form-group row" >

                                                          
                                                    <label for="mainName" class="col-sm-3 col-form-label">MIO Amount:  </label>

                                                    <div class="col-sm-7">
                                                          <div class="input-group">
                                                        <input type="number" class="form-control form-control-sm mb-3" required  id="txtMIOAmount" placeholder="Amount">

                                                        <span id="v-txtMIOAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
    <span class="input-group-text text-c-red">*</span>
                                                             </div>


                                                    </div>

                                                              </div>     <div class="form-group row" >

                                                          
                                                    <label for="mainName" class="col-sm-3 col-form-label">AM Amount:  </label>

                                                    <div class="col-sm-7">
                                                          <div class="input-group">
                                                        <input type="number" class="form-control form-control-sm mb-3" required  id="txtAMAmount" placeholder="Amount">

                                                        <span id="v-txtAMAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
    <span class="input-group-text text-c-red">*</span>
                                                             </div>


                                                    </div>

                                                              </div>     <div class="form-group row" >

                                                          
                                                    <label for="mainName" class="col-sm-3 col-form-label">DZSM Amount:  </label>

                                                    <div class="col-sm-7">
                                                          <div class="input-group">
                                                        <input type="number" class="form-control form-control-sm mb-3" required  id="txtDZSMAmount" placeholder="Amount">

                                                        <span id="v-txtDZSMAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
    <span class="input-group-text text-c-red">*</span>
                                                             </div>


                                                    </div>

                                                              </div>
                                                    
                                                </div>
                                                <div class="form-group row" >
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
                                                          <div class="input-group">
                                                        <input id="acDate" type="text" class="form-control form-control-sm mb-3 datepicker" required autocomplete="off" placeholder="Select Date">

                                                        <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
                                                                <span class="input-group-text text-c-red">*</span>
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
                                                    <div class="col-sm-9">
                                                         


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
      function toggleAmountVisibility() {
          var otherVisit = document.querySelector('input[name="visitType"][value="other"]').checked;
          var divAmt = document.getElementById('divAmt');
          if (otherVisit) {
              divAmt.classList.remove('hidden');
          } else {
              divAmt.classList.add('hidden');
          }
      }
  </script>
                    
                        <script>

                            $(function () {
                                $('.datepicker').pickadate({
                                    selectMonths: true,
                                    selectYears: true
                                })
                                var masterid = getUrlVars()["id"];
                                if (masterid) {
                                    $("#masterId").val(getUrlVars()["id"]);
                                    GetData(masterid)
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

            var otherVisit = document.querySelector('input[name="visitType"][value="other"]').checked;

            if (otherVisit) {
                if ($('#txtMIOAmount').val() == "") isValid = false;
                if ($('#txtAMAmount').val() == "") isValid = false;
                if ($('#txtDZSMAmount').val() == "") isValid = false;
            }
        if (isValid == false) {
            alert('Please enter mandatory data');
            }

           
        return isValid;
    }

    function Save() {
        if (Validation()) {
            //$.confirm({
            //    icon: 'fas fa-question-circle',
            //    title: 'Are You Sure ?',
            //    content: 'You are about to save the data!',
            //    theme: 'Supervan',
            //    type: 'green',
            //    buttons: {
            //        Confirm: {
            //            text: 'Confirm',
            //            action: function () {
                            FinalSave();
            //            }
            //        },
            //        Cancel: function () {
            //        }
            //    }
            //});
        }
        }

    function FinalSave() {
        var jsonData = {};
        jsonData["TPId"] = $('#masterId').val();
        jsonData["TPName"] = $('#mainName').val();
        jsonData["IsActive"] = $('#customSwitch1').is(':checked');
        jsonData["Activedate"] = $('#acDate').val();

        var marketVisit = document.querySelector('input[name="visitType"][value="market"]');
        var otherVisit = document.querySelector('input[name="visitType"][value="other"]');
        var ismarketVisit = 0;
        var isotherVisit = 0;
        if (marketVisit.checked == true) {
            ismarketVisit = 1;
        } if (otherVisit.checked == true) {
            isotherVisit = 1;
        }
        jsonData["IsMarketVisit"] = ismarketVisit;
        jsonData["IsOtherVisit"] = isotherVisit;
        jsonData["MIOAmount"] = $('#txtMIOAmount').val() ||0;
        jsonData["AMAmount"] = $('#txtAMAmount').val() ||0;
        jsonData["DZSMAmount"] = $('#txtDZSMAmount').val() ||0;

        var urlpath = 'TourPurposeSetup.aspx/Save_TourPurpose';
            $.ajax({
                data: JSON.stringify({ 'purpose': jsonData }),
                url: urlpath,
                type: "POST", contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    //_open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'TourPurposeRecords.aspx');
                    } else {
                        faildalert('Operation Faild!', 'Faild');
                    }

                },
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');
                },

            });
        }


    function GetData(id) {
        var urlpath = 'TourPurposeSetup.aspx/GetTourPurposeEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: {id : id},
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.TPName);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.Activedate));

                    var marketVisit = document.querySelector('input[name="visitType"][value="market"]');
                    var otherVisit = document.querySelector('input[name="visitType"][value="other"]');
                    if (data.IsMarketVisit == 1) {
                        marketVisit.checked = true;
                    }
                    if (data.IsOtherVisit == 1) {
                        otherVisit.checked = true;
                    }
                    toggleAmountVisibility();
                    $('#txtMIOAmount').val(data.MIOAmount);
                    $('#txtAMAmount').val(data.AMAmount);
                    $('#txtDZSMAmount').val(data.DZSMAmount);
                    
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked',true);
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

