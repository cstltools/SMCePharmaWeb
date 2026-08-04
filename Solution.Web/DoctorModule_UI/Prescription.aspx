<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Prescription.aspx.cs" Inherits="DoctorModule_UI_Prescription" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

     <style>
        .imgshadow{

            width:100%;
            height:300px;
        
/* border: 1px solid #ddd;*/
  border-radius: 4px;
  padding: 5px;
 box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
 border: 3px #1c87c9;
        border-style: dashed;
        }
         .imgshadow:hover {
  box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
}
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Prescription Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/PrescriptionView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                            <div class="row">

                                <div class="col-1">
                                </div>

                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="ddlCapturedBy" class="col-sm-4 col-form-label">Captured By:  </label>

                                        <div class="col-sm-8">

                                            <div class="input-group">
                                                <select id="ddlCapturedBy" name="ddlCapturedBy" class="form-select form-select-sm mb-3 mySelect2">
                                                </select>

                                                <span id="v-ddlCapturedBy" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="PrescripotionDate" class="col-sm-4 col-form-label">Prescripotion Date:  </label>

                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <input id="PrescripotionDate" type="text" class="form-control form-control-sm mb-3 datepicker" placeholder="Select Date">

                                                <span id="v-PrescripotionDate" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>

                                        </div>

                                    </div>

                                </div>
                            </div>

                            <div class="row">

                                <div class="col-1">
                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="ddlDoctor" class="col-sm-4 col-form-label">Doctor:  </label>

                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <select id="ddlDoctor" name="ddlDoctor" class="form-select form-select-sm mb-3 mySelect2">
                                                </select>
                                                <span id="v-ddlDoctor" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>


                                        </div>

                                    </div>

                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="ddlPrescriptionType" class="col-sm-4 col-form-label">Prescription Type:  </label>

                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <select id="ddlPrescriptionType" name="ddlPrescriptionType" class="form-select form-select-sm mb-3 mySelect2">
                                                </select>

                                                <span id="v-ddlPrescriptionType" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>

                                        </div>

                                    </div>

                                </div>
                            </div>

                            <div class="row">

                                <div class="col-1">
                                </div>
                                <div class="col-5">
                                    <div class="form-group row">
                                        <label for="ddlChamber" class="col-sm-4 col-form-label">Chamber:  </label>

                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <select id="ddlChamber" name="ddlChamber" class="form-select form-select-sm mb-3 mySelect2">
                                                </select>
                                                <span id="v-ddlChamber" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                            </div>


                                        </div>

                                    </div>

                                </div>
                                </div>

                            <br />

                            <div class="row">

                                <div class="col-12">
                                    <div class="form-group row">
                                        <label for="ddlProduct" class="col-sm-3 col-form-label pull-right">Product:  </label>

                                        <div class="col-sm-6">
                                            <div class="input-group">
                                                <select id="ddlProduct" name="ddlProduct" class="form-select form-select-sm mb-3 mySelect2">
                                                </select>
                                                <span id="v-ddlProduct" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                <span class="input-group-text text-c-red">*</span>
                                               
                                            </div>

                                        </div>


                                        <div class="col-md-2">
                                            <button type="button" class="btn btn-sm btn-success" id="addButton" onclick="SaveValue()"><i class="fa fa-plus-circle"></i>Add to list</button>
                                            <span id="v-addButton" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                        </div>
                                    </div>

                                </div>

                            </div>

                            <br />
                            <div class="row">


                                <div class="table-responsive" id="MainGradeDiv">

                                    <table id="dtTble" class="table table-striped table-bordered">
                                        <thead>
                                            <tr>
                                                <th>#SL</th>
                                                <th>Product</th>
                                                <th>Action</th>
                                            </tr>

                                        </thead>
                                        <tbody id="dtTableBody">
                                        </tbody>
                                    </table>


                                </div>
                            </div>

                                                                  
                            <div class="row">
                                 <div class="col-2">
                                
                       </div>
                                  <div class="col-8">
                               <div class="form-group row">
                                   <label class="col-form-label">Upload Image</label>
                            <span id="v-imageUploadForm" class="invalid-tooltip fade hide" data-delay="2000"></span>
                                                                <input type="file" id="imageUploadForm" name="image" multiple="multiple" accept="image/*" class="form-control" onchange="ImageToBase64(this)" />


                                                                <a href="#" style="display:none" class="btn btn-sm btn-danger" onclick="UploadImage()">Upload</a>
                                                                <p id="output" > </p>
                                                                <br />

                                                                <img id="output-image" class="imgshadow"/>

                                   </div>
                                   </div>
                                   </div>
                            <br />
                        
                            <div class="row">
                                 <div class="col-4">
                       </div>
                                  <div class="col-5">
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
                                          </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input id="masterId" value="0" style="display: none" />
    <input id="imgeBase64Str" style="display: none" />

    <script type="text/javascript">

        $(document).ready(function () {



            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            })



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

        $(function () {
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
            }
            let id = $('#masterId').val();

            if (id > 0) {
                GetProduct(0);
                GetData(id);
            } else {

                GetUser(0);

                GetDoctor(0);
                GetPrescriptionType(0);
                GetProduct(0);
            }

        });


        $("#ddlDoctor").on("change", function (e) {
            debugger;
            var DocId = $("#ddlDoctor").val();
            if (DocId > 0) {
                GetChamber_ByDoctorId(DocId,0);
            }
        });


        function GetChamber_ByDoctorId(id, setId) {

            _GetChamber_ByDoctorId($('#ddlChamber'), 'ChemberId', 'Chember', id, setId);
        }

        function GetUser(setId) {
            var urlpath = 'Setup.aspx/Get_CapturedBy_For_ddl';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlCapturedBy'), 'EmpInfoId', 'EmpName', setId);
            $('#ddlCapturedBy').select2();
        }

        function GetDoctor(id) {
            var urlpath = 'Setup.aspx/Get_Doctor_For_ddl';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlDoctor'), 'DoctorId', 'DoctorName', id);
            $('#ddlDoctor').select2();
        }

        function GetPrescriptionType(id) {
            var urlpath = 'Setup.aspx/Get_PrescriptionType_For_ddl';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlPrescriptionType'), 'PrescriptionTypeId', 'PrescriptionType', id);
            $('#ddlPrescriptionType').select2();
        }
        function GetProduct(id) {
            var urlpath = 'Setup.aspx/Get_ProductList_List_New';
            SelectOption_DtTable_Async_True(urlpath, $('#ddlProduct'), 'ProductId', 'ProductName', id);
            $('#ddlProduct').select2();
        }


        function SaveValue() {

            if ($('#ddlProduct').val() != "") {

                $('#ddlProduct').removeClass('is-invalid');

                RemoveValidationTooltip("#v-ddlProduct");

                if ($('#ddlProduct').val() != "0" && $('#ddlProduct').val() != "") {





                    var productId = $("#ddlProduct").val();
                    var productName = $("#ddlProduct :selected").text();
                    var tr = '<tr id="addr' + (id) + '">';
                    var qtyTd = '<td >' + (id + 1) + '</td>';
                    var producttd = '<td > <input type="hidden"  id="HfProductId" name="ProductDetails[' + id + '].ProductId" value="' + productId + '"/>' + productName + '</td>';
                    var button = '<td><button class="btn-outline-danger  btn-xs mb-1 mb-md-0" onclick="RemoveRow(' + id + ')"><i class="fa fa-minus" aria-hidden="true"></i></button></td>';
                    tr += qtyTd + producttd + button + '</tr>';
                    $("#dtTableBody").append(tr);
                    id++;

                    GetProduct(0);
                }
                else {
                    $('#ddlProduct').addClass("is-invalid");
                    ValidationTooltip("#v-ddlProduct", "Please fill out of this field!");
                }



            }
        }

        function RemoveRow(tbId) {
            $("#addr" + (tbId)).remove();
        }

        function RemoveValidationTooltip(id) {
            $(id).css("display", "none");
        }

        function ValidationTooltip(id, message) {


            $(id).empty();

            if ($(id).empty()) {
                $(id).append(message);
            }
            $(id).toast('show');
            $(id).css("display", "block");



        }


        function ImageToBase64(image) {
            var img = image.files[0];
            var reader = new FileReader();
            reader.onloadend = function () {
                $("#imgeBase64Str").val("");
                var base64result = reader.result.split(',')[1];
                $("#imgeBase64Str").val(base64result);

                $("#output-image").attr("src", reader.result);
                $('#output-image').show();
            }



            reader.readAsDataURL(img);

            //  UploadImage();
        }



        function Save() {

            $('#imageUploadForm').removeClass('is-invalid');
            RemoveValidationTooltip("#v-imageUploadForm");




            if ($('#imgeBase64Str').val() != "") {




                //$.confirm({
                //    icon: 'fas fa-question-circle',
                //    title: 'Are You Sure ?',
                //    content: 'You are about to save the data!',
                //    theme: 'Supervan',
                //    type: 'green',
                //    buttons: {
                //        Confirm: {
                            //text: 'Confirm',
                            //action: function () {
                                FinalSave();
                //            }
                //        },
                //        Cancel: function () {
                //        }
                //    }
                //});


            }
            else {

                $('#imageUploadForm').addClass("is-invalid");
                ValidationTooltip("#v-imageUploadForm", "Please Choose an Image!");
            }
        }

        function Validation() {


            $('#ddlCapturedBy').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlCapturedBy");


            $('#PrescripotionDate').removeClass('is-invalid');
            RemoveValidationTooltip("#v-PrescripotionDate");


            $('#ddlDoctor').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlDoctor");



            $('#ddlChamber').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlChamber");


            $('#ddlPrescriptionType').removeClass('is-invalid');
            RemoveValidationTooltip("#v-ddlPrescriptionType");

            isValid = true;


            if ($('#ddlCapturedBy').val() == "0" || $('#ddlCapturedBy').val() == "" || $('#ddlCapturedBy').val() ==null) {


                $('#ddlCapturedBy').addClass("is-invalid");
                ValidationTooltip("#v-ddlCapturedBy", "Please fill out of this field!");
                isValid = false;
            }


            if ($('#PrescripotionDate').val() == "") {
                $('#PrescripotionDate').addClass("is-invalid");
                ValidationTooltip("#v-PrescripotionDate", "Please fill out of this field!");
                isValid = false;
            }

            if ($('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == null) {
                $('#ddlDoctor').addClass("is-invalid");
                ValidationTooltip("#v-ddlDoctor", "Please fill out of this field!");
                isValid = false;
            }
            if ($('#ddlChamber').val() == "0" || $('#ddlChamber').val() == "" || $('#ddlChamber').val() == null) {
                $('#ddlChamber').addClass("is-invalid");
                ValidationTooltip("#v-ddlChamber", "Please fill out of this field!");
                isValid = false;
            }


            if ($('#ddlPrescriptionType').val() == "0" || $('#ddlPrescriptionType').val() == "" || $('#ddlPrescriptionType').val() == null) {
                $('#ddlPrescriptionType').addClass("is-invalid");
                ValidationTooltip("#v-ddlPrescriptionType", "Please fill out of this field!");
                isValid = false;
            }



            if ($('#dtTableBody tr').length == 0) {



                ValidationTooltip("#v-addButton", "Please add to list a Row!!");
                isValid = false;
            }





            return isValid;

        }



        function FinalSave() {

            var jsonData = {};

            jsonData["DoctorId"] = $('#ddlDoctor').val();
            jsonData["PrescriptionId"] = $('#masterId').val();
            jsonData["PrescriptionDate"] = $('#PrescripotionDate').val();
            jsonData["EntryBy"] = $('#ddlCapturedBy').val();
            jsonData["PrescriptionTypeId"] = $('#ddlPrescriptionType').val();
            jsonData["ChemberId"] = $('#ddlChamber').val();


            jsonData["ImageString"] = $('#imgeBase64Str').val();
            //alert(jsonData["PrescriptionId"]);

            var jsonObjs = [];


            $('#dtTble tbody tr').each(function (id) {

                var theObj = {};

                var ProductId = $("input[name='ProductDetails[" + id + "].ProductId']").val();

                theObj["ProductId"] = ProductId;

                jsonObjs.push(theObj);

                jsonData["PrescriptionProductDetailDAOs"] = jsonObjs;
            });


            var urlpath = 'Prescription.aspx/Save_Prescription';
            $.ajax({
                data: JSON.stringify({ 'typeMaster':jsonData }),
              

                url: urlpath,
                type: "POST", contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                   // _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (result) {
                    result = result.d;
                    //console.log(result);
                    //_close_LoadingPopUp_WithMsg();
                    if (result.isSuccess == true) {

                        successalert('Operation successful!', 'Success', 'PrescriptionView.aspx');
                         
                    
                     

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


            var urlpath = 'Prescription.aspx/GetPrescriptionEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;


                    if (data.ApprovalStatus == "2") {
                     
                        $("#btnSave").hide()
                    }
                    else {
                        $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    }
                    GetUser(data.EntryBy);
                    GetDoctor(data.DoctorId);
                    GetPrescriptionType(data.PrescriptionTypeId);
                    $('#PrescripotionDate').val(ToJavaScriptDate_Formater(data.PrescriptionDate));
                    //alert(data.DoctorId);
                    //alert(data.ChemberId);
                    GetChamber_ByDoctorId(data.DoctorId, data.ChemberId);
                    GetPrescriptionDetails(data.PrescriptionId);

                    var src = "data:image/jpeg;base64,";
                    src += data.ImageString;
                    $("#output-image").attr("src", src);
                    $("#output-image").show();
                    $("#imgeBase64Str").val(data.ImageString);

                },
                complete: function () {
                }
            });
        }

        function GetPrescriptionDetails(id) {


            var urlpath = 'Prescription.aspx/GetPrescriptionDetailsListForEdit';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                },
                success: function (data) {
                    data = data.d;
                    //  $('#tabH').show();
                    var result = JSON.parse(data);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += '<tr id="addr' + (i) + '">';
                        row += "<td>" + (i + 1) + "</td>";
                        row += '<td> <input type="hidden"   id="HfProductId" al name="ProductDetails[' + i + '].ProductId" value="' + result[i].ProductId + '"/>' + result[i].ProductName + '</td>';
                        row += "<td><button class='btn-outline-danger  btn-xs mb-1 mb-md-0' onclick='RemoveRow(" + i + ")'><i class='bx bxs-trash' aria-hidden='true'></i></button></td>";
                        row += "</tr>";
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {
                    //$('#dtTble').dataTable({
                    //    "ordering": false
                    //});
                }
            });
        }

    </script>

</asp:Content>


