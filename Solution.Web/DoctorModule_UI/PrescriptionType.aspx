<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PrescriptionType.aspx.cs" Inherits="DoctorModule_UI_PrescriptionType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

     

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="popDiv">
    </div>


    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Prescription Type Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/PrescriptionTypeView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                        <label for="mainName" class="col-sm-3 col-form-label">Prescription Type:  </label>

                                        <div class="col-sm-7">

                                             <div class="input-group">
                                            <input type="text" class="form-control form-control-sm mb-3" required  id="mainName" placeholder="Prescription Type">

                                            <span id="v-mainName" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                   <span class="input-group-text text-c-red">*</span>
                                               
                                                 </div>
                                        </div>
                                         
                                    </div>
                                    <div class="form-group row" >
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label>
                                        <br />
                                        <div class="col-sm-7">

                                            <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="customSwitch1" checked  onchange="IsActiveChange()">
												 <label  class="custom-control-label" for="customSwitch1">Active</label>
												</div>
                                          
                                          
                                        </div>

                                    </div>

                                    <div class="form-group row">
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label">Active Date: </label>
                                        <div class="col-sm-7">
                                               <div class="input-group">
                                            <input id="acDate" type="date" class="form-control form-control-sm mb-3 datepicker" required   placeholder="Select Date"  >

                                            <span id="v-acDate" class="invalid-tooltip fade hide" data-delay="2000"></span>
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

                            
 
    <input id="masterId" value="0" style="display: none" />



     

    <script type="text/javascript">
        function ConfirmationClick() {
            window.location.href = "PrescriptionTypeView.aspx";
        }
        $(function () {

            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })
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

        var id = 0;

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
                                
                //            }
                //        },
                //        Cancel: function () {
                //        }
                //    }
                //});
            }

        }



        function FinalSave() {

            debugger;

            var jsonData = {};

            jsonData["PrescriptionTypeId"] = $('#masterId').val();
            jsonData["PrescriptionTypename"] = $('#mainName').val();
            jsonData["IsActive"] = $('#customSwitch1').is(':checked');
            jsonData["Activedate"] = $('#acDate').val();

            //var urlpath = '@Url.Action("Save_PrescriptionType", "Setup")';


            //var prescriptionTypeId = $('#masterId').val();

            //$.ajax({
            //    type: "POST",
            //    url: "PrescriptionType.aspx/Save",
            //    data: JSON.stringify({ prescriptionTypeId: prescriptionTypeId }),
            //    dataType: "JSON",
            //    contentType: "application/json;charset=utf-8",
            //    async: false,
            //    success: function (data) {

            //        var result = data.d;


            //        console.log(result);

            //        //for (var i in result) {

            //        //    $("#OrderNo").html(result[i].NoOfOrder);
            //        //    $("#invoiceNo").html(result[i].NoOfInvoice);
            //        //    $("#actualSales").html(result[i].ActualSales);
            //        //    $("#deliveryNo").html(result[i].DeliveryConfirmed);
            //        //    $("#collection").html(result[i].TotalCollection);
            //        //    $("#due").html(numberWithCommas(parseFloat(result[i].TotalDue).toFixed(2)));
            //        //}

            //        //$('#productsales-detail').html(html);



            //    }
            //});

            //debugger;
            $.ajax({

                url: "PrescriptionType.aspx/Save_PrescriptionType",
                data: '{prescription: ' + JSON.stringify(jsonData) + '}',
                dataType: 'json',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: false,
                beforeSend: function () { },
                success: function (data) {

                    var result = data.d;
                   // console.log(result);

                    if (result.isSuccess == true) {
                        successalert('Operation successful!', 'Success', 'PrescriptionTypeView.aspx');
                    }
                    else {
                        faildalert('Operation Faild!', 'Faild');
                    }

                    //if (result.isSuccess == true) {
                    //    $.confirm({
                    //        icon: 'fas fa-check-circle',
                    //        title: 'Success !',
                    //        content: 'Operation successfully done !!',
                    //        type: 'green',
                    //        buttons: {
                    //            OK: {
                    //                text: 'OK',
                    //                action: function () {
                    //                    var url = 'PrescriptionTypeView.aspx/GetPrescriptiontTypeList';
                    //                    window.location.href = url;
                    //                }
                    //            }
                    //        }
                    //    });

                    //} 
                },
                error: function (data) {
                    faildalert('Operation Faild!', 'Faild');

                },
            });
        }


        function GetData(id) {

         
            var urlpath = 'PrescriptionType.aspx/GetPrescriptionTypeForEdit';

            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    $('#mainName').val(data.PrescriptionTypename);
                    $('#acDate').val(ToJavaScriptDate_Formater(data.Activedate));
                    if (data.IsActive) {
                        $('#customSwitch1').prop('checked', true);
                    } else {
                        $('#customSwitch1').prop('checked', false);
                    }
                },
                complete: function () {

                }
            });
        }
    </script>


</asp:Content>

