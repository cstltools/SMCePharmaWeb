<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ExpenseClaim.aspx.cs" Inherits="DoctorModule_UI_ExpenseClaim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
    <div id="popDiv">

</div>

    

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Expense Claim Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/ExpenseClaimView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                      

                                           <div class="col-md-12">

                                       
                                        <div class="row">
                                            <div class="col-2">&nbsp;</div>
                                            <div class="col-10">
                                        
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Expense Date:  </label>

                                                    <div class="col-sm-5">
                                                          <div class="input-group">
                                                        <input type="text" class="form-control form-control-sm mb-3 datepicker" placeholder="Select Date" id="ExpenseDate" name="ExpenseDate" >

                                                        <span id="v-ExpenseDate" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>
   <span class="input-group-text text-c-red">*</span>
                                                          </div>
                                                    </div>
                                                      
                                                </div>



                                                <div class="form-group row">
                                                    <label for="ExpenseTypeIdSelect" class="col-sm-3 col-form-label"> Expense Type:  </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                        <select id="ExpenseTypeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                                        <span id="v-ExpenseTypeIdSelect" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>
                                                                <span class="input-group-text text-c-red">*</span>

 </div> 
                                                    </div>
                                                     
                                                </div>

                                                <div class="form-group row">
                                                    <label for="EntryBySelect" class="col-sm-3 col-form-label"> Entry By:  </label>

                                                    <div class="col-sm-5">
                                                          <div class="input-group">
                                                        <select id="EntryBySelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                                        <span id="v-EntryBySelect" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>
                                                                <span class="input-group-text text-c-red">*</span>
</div>

                                                    </div>
                                                    
                                                </div>

                                                <div class="form-group row">
                                                    <label for="ExpenseAmount" class="col-sm-3 col-form-label"> Expense Amount:  </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                        <input type="text" id="ExpenseAmount" name="ExpenseAmount" class="form-control form-control-sm mb-3" />

                                                        <span id="v-ExpenseAmount" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>

                                                              
                                                                <span class="input-group-text text-c-red">*</span>
                                                    </div>
                                                    </div>
                                                    
                                                </div>



                                                <div class="form-group row">
                                                    <label for="Comments" class="col-sm-3 col-form-label"> Comments:  </label>

                                                    <div class="col-sm-5">
                                                        <textarea type="text" class="form-control" id="Comments" rows="2"></textarea>

                                                        <span id="v-Comments" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>


                                                    </div>

                                                </div>




  
                                                

                                            

                                            </div>
                                        </div>
                                                   <br />

                                               <div class="row">
                                                   <div class="col-1">&nbsp;</div>
                                                    <div class="col-11"> 
                                                       <div class="form-group row">
                                                    <label for="FieldNameSelect" class="col-sm-2 col-form-label">Field Name:  </label>

                                                    <div class="col-sm-4">

                                                        <select id="FieldNameSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                                        <span id="v-FieldNameSelect" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>
                                                    </div>

                                                    <label for="txtValue" class="col-sm-2 col-form-label">Value:  </label>

                                                    <div class="col-sm-2">

                                                        <input id="txtValue" name="txtValue" type="text" class="form-control form-control-sm mb-3">

                                                        <span id="v-txtValue" class="invalid-tooltip fade hide" data-delay="1000"> </span>
                                                    </div>

                                                    <div class="col-sm-2">

                                                        <button type="button" class="btn btn-sm btn-sm btn-outline-success" id="addButton" onclick="PreviewExpenseDetails()"><i class="fa fa-plus"></i>Add to list</button>
                                                      
                                                        <span id="v-btnAddtolist" class="invalid-tooltip fade hide" data-delay="1000">
                                                        </span>
                                                    </div>

                                                </div>


                                                             <br />

                                                <div class="form-group row">
                                                    <div class="table-responsive" id="MainGradeDiv">

                                                        <table id="dtTble"  class="table table-striped table-bordered">
                                                            <thead>
                                                                <tr>
                                                                    <th>#SL</th>
                                                                    <th>Field Name</th>
                                                                    <th>Value</th>
                                                                    <th>Action</th>
                                                                </tr>

                                                            </thead>
                                                            <tbody id="dtTableBody">
                                                            </tbody>
                                                        </table>

                                                    </div>
                                                </div>
                                                               <br />
            <div class="form-group row">
                <label for="MeterImage" class="col-sm-1 col-form-label"></label>
            <h4 class="col-sm-3">Upload Image</h4>   
       
                </div>
         <hr />
         <div class="form-group row" style="margin-top:6px;">


             <label for="MeterImage" class="col-sm-3 col-form-label">Upload Meter Image:  </label>

             <div class="col-sm-8">
                  <div class="input-group">

                 <input type="file" id="imageUploadForm" name="image" accept="image/*" class="form-control form-control-sm mb-3 " onchange="ImageToBase64(this)" />

                 <span id="v-MeterImage" class="invalid-tooltip fade hide" data-delay="2000">
                 </span>
                        <span class="input-group-text text-c-red">*</span>
                             </div>



             </div>
            






         </div>
           <div class="row">
               <div class="col-sm-2">&nbsp;</div>
               <div class="col-8">
                   <img id="output-image" class="imgshadow"  />
               </div>
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
                                        <button type="button" class="btn btnMyDesignReset   btn-sm"  onclick="ResetClick()"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </button>
                                                                
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
                                </div>
                                </div>
                                </div>
    
                                              
 
        <%--<input id="masterId" value="@ViewBag.Id" style="display:none" />--%>
 <input id="imgeBase64Str" style="display:none" />

                        <input id="masterId" value="0" type="hidden" style="display:none" />
  
                            <script>

                                function ImageToBase64(image) {
                                    var img = image.files[0];
                                    var reader = new FileReader();
                                    reader.onloadend = function () {

                                        $("#imgeBase64Str").val("");
                                        var base64result = reader.result.split(',')[1];
                                        $("#imgeBase64Str").val(base64result);

                                        $("#output-image").attr("src", reader.result);

                                        /* $("#fID").attr("href", img);*/
                                    }



                                    reader.readAsDataURL(img);

                                    //  UploadImage();
                                }
                                $('.datepicker').pickadate({
                                    selectMonths: true,
                                    selectYears: true
                                })
    $(function () {




        var masterid = getUrlVars()["id"];
        var RId = getUrlVars()["Rid"];
        if (masterid) {
            $("#masterId").val(getUrlVars()["id"]);
           
        }

        let id = $('#masterId').val();
        if (id > 0) {
            //$('#ExpenseDate').pickadatee({
            //    selectMonths: true,
            //    selectYears: true
            //});
            
           

            GetData(id, RId);
        } else {
            //$('#ExpenseDate').datepicker("update", new Date());
            GetExpenseType(0);
             GetEmpList(0);
        }



        $("#zoneSelect").on("change", function (e) {
            var areaId = $("#zoneSelect").val();
            if (areaId > 0) {
                GetArea_ByZone(0, areaId);

            }
        });
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


                                function ResetClick() {
                                    window.location.href = '../DoctorModule_UI/ExpenseClaim.aspx';

        }


                                var idd = 0;

                                function PreviewExpenseDetails() {


                                    if (ValidationAddtoList()) {
                                        idd++;

                                        var  FieldNameId = $("#FieldNameSelect").val();
                                        var txtFieldName = $("#FieldNameSelect :selected").text()
                                        var txtValue = $("#txtValue").val();

                                        var tr = '<tr id="addr' + (idd) + '">';
                                        var qtyTd = '<td  >' + (idd) + '</td>';
                                        var fieldName = '<td  > <input type="hidden"  id="HfFieldName" name="ExpMaster[' + idd + '].txtFieldName" value="' + FieldNameId + '"/>' + txtFieldName + ' </td>';
                                        var RequierdName = '<td  > <input type="hidden"  id="HfRe" name="ExpDetails[' + idd + '].txtRequired" value="' + txtValue + '"/> ' + txtValue + ' </td>';
                                        var button = '<td  ><button class="btn-outline-danger  btn-xs mb-1 mb-md-0" onclick="RemoveRow(' + idd + ')"><i class="bx bxs-minus-circle" aria-hidden="true"></i></button></td>';
                                        tr += qtyTd + fieldName + RequierdName + button + '</tr>';
                                        $("#dtTableBody").append(tr);

                                        // GetProduct();
                                       

                                        GetExpenseField_ByExpenseType($('#ExpenseTypeIdSelect').val(), 0);
                                       
                                        $('#txtValue').val('');
                                    }

                                }
                                function RemoveRow(tbId) {
                                    $("#addr" + (tbId)).remove();
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

                                $("#ExpenseTypeIdSelect").on("change", function (e) {
                                    $('#dtTble tbody').empty();
                                    idd = 0;
                                    var groupId = $("#ExpenseTypeIdSelect").val();
                                    if (groupId > 0) {
                                        GetExpenseField_ByExpenseType(groupId, 0);
                                    }
                                    else {
                                        GetExpenseField_ByExpenseType(0, 0);
                                    }
                                });



                                function GetExpenseField_ByExpenseType(id, SetId) {

                                    //   _getZone_ByGroupId_Active($('#upperSelect'), 'RegionId', 'RegionName', id);

                                    _GetExpenseField_ByExpenseType($('#FieldNameSelect'), 'ExpenseTypDetailsId', 'FieldName', id, SetId)
                                }

                                function GetEmpList(SetId) {
                                    _getEmployeeList_Active($('#EntryBySelect'), 'EmpInfoId', 'EmpName', SetId);
                                }

                                function GetExpenseType(SetId) {

                                    _getExpenseType($('#ExpenseTypeIdSelect'), 'ExpenseTypeId', 'ExpenseTypeName', SetId);
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

    function GetArea_ByZone(id,areaId) {
        var urlpath = 'ExpenseClaim.aspx/GetAreaList_Active_ByZoneId';
        LoadSelectOption_ById(urlpath, $('#upperSelect'), 'AreaId', 'AreaName', id, areaId);
        //$('#upperSelect').select2();
    }



    function GetThana(id) {
        var urlpath = 'ExpenseClaim.aspx/GetThana_WitTagDetails';
        Selec2_Multiple_DisableOption(urlpath, $('#multiSelectId'), 'ThanaId', 'ThanaName', id);
        }





        function GetZone(id) {
            var urlpath = 'ExpenseClaim.aspx/GetZoneList_Active';
            SelectOption_DtTable_Async_True(urlpath, $('#zoneSelect'), 'ZoneId', 'ZoneName', id);
         //$('#zoneSelect').select2();
        }



                                function ValidationAddtoList() {



                                    $('#FieldNameSelect').removeClass('is-invalid');
                                    $('#txtValue').removeClass('is-invalid');

                                    RemoveValidationTooltip("#v-FieldNameSelect");
                                    RemoveValidationTooltip("#v-txtValue");

                                    isValid = true;

                                    if ($('#FieldNameSelect').val() == null || $('#FieldNameSelect').val() == "" || $('#FieldNameSelect').val() == "0") {


                                        $('#FieldNameSelect').addClass("is-invalid");
                                        ValidationTooltip("#v-FieldNameSelect", "Please fill out of this field!");
                                        isValid = false;
                                    }

                                    if ($('#txtValue').val() == "") {


                                        $('#txtValue').addClass("is-invalid");
                                        ValidationTooltip("#v-txtValue", "Please fill out of this field!");
                                        isValid = false;
                                    }

                                    return isValid;
                                }

                                $(function () {
                                    $("#ExpenseAmount").keypress(function (event) {

                                        $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
                                        if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                                            /* if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {*/
                                            /*  $("#v-AllowedMilagePerKM").html("Number Only").stop().show().fadeOut("slow");*/
                                            ValidationTooltip("#v-ExpenseAmount", "Number Only!");
                                            return false;
                                        }
                                    });
                                });


                                function Validation() {
                                     
                                    $('#ExpenseDate').removeClass('is-invalid'); 
                                    RemoveValidationTooltip("#v-ExpenseDate");

                                    $('#ExpenseTypeIdSelect').removeClass('is-invalid');
                                    RemoveValidationTooltip("#v-ExpenseTypeIdSelect");

                                    $('#EntryBySelect').removeClass('is-invalid');
                                    RemoveValidationTooltip("#v-EntryBySelect");

                                    $('#ExpenseAmount').removeClass('is-invalid');
                                    RemoveValidationTooltip("#v-ExpenseAmount");

                                    isValid = true;
                                    if ($('#ExpenseDate').val() == "") {


                                        $('#ExpenseDate').addClass("is-invalid");
                                        ValidationTooltip("#v-ExpenseDate", "Please fill out of this field!");
                                        isValid = false;
                                    }
                                
                                    if ($('#ExpenseTypeIdSelect').val() == "" || $('#ExpenseTypeIdSelect').val() == null || $('#ExpenseTypeIdSelect').val() == "0") {


                                        $('#ExpenseTypeIdSelect').addClass("is-invalid");
                                        ValidationTooltip("#v-ExpenseTypeIdSelect", "Please fill out of this field!");
                                        isValid = false;
                                    }

                                    if ($('#EntryBySelect').val() == "" || $('#EntryBySelect').val() == null || $('#EntryBySelect').val() == "0") {


                                        $('#EntryBySelect').addClass("is-invalid");
                                        ValidationTooltip("#v-EntryBySelect", "Please fill out of this field!");
                                        isValid = false;
                                    }

                                    if ($('#ExpenseAmount').val() == "") {


                                        $('#ExpenseAmount').addClass("is-invalid");
                                        ValidationTooltip("#v-ExpenseAmount", "Please fill out of this field!");
                                        isValid = false;
                                    }

                                    if ($('#dtTableBody tr').length == 0) {



                                        ValidationTooltip("#v-btnAddtolist", "Please add to list a Row!!");
                                        isValid = false;
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
        jsonData["ExpenseClaimID"] = $('#masterId').val();
        jsonData["ExpenseTypeId"] = $('#ExpenseTypeIdSelect').val();
        jsonData["EmpInfoId"] = $('#EntryBySelect').val();
        jsonData["Amount"] = $('#ExpenseAmount').val();
        jsonData["ExpenseDate"] = $('#ExpenseDate').val();



        jsonData["Remarks"] = $('#Comments').val();
        jsonData["ImageBase64String"] = $('#imgeBase64Str').val();

        var jsonObjs = [];

        $('#dtTble tbody tr').each(function (idd) {
            debugger;
            var theObj = {};
            idd++;
            //  if (typeof FieldName ==="" )
            var FieldName = $("input[name='ExpMaster[" + idd + "].txtFieldName']").val();
            var IsRequired = $("input[name='ExpDetails[" + idd + "].txtRequired']").val();

            theObj["ExpenseTypDetailsId"] = FieldName;
            theObj["ValueText"] = IsRequired;

            jsonObjs.push(theObj);

            jsonData["ExpenseClaimDetailsDAOs"] = jsonObjs;
        });

        var urlpath = 'ExpenseClaim.aspx/Save_ExpenseClaim';
            $.ajax({
                data: JSON.stringify({ 'typeMaster': jsonData }),
                url: urlpath,
                type: "POST",contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    
                },
                success: function (result) {
                    result = result.d;
                    if (result.isSuccess == true) {
                    
                     
                        successalert('Operation successful!', 'Success', 'ExpenseClaimView.aspx');

                    } else {
                        _saveError();
                    }

                },
                error: function (data) {
                    
                },

            });
        }


                                function GetData(id, RId) {
        var urlpath = 'ExpenseClaim.aspx/GetExpenseClaimEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: {id : id},
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    var result =  data.d ;
                    if (result[0].ApprovalStatus == "2") {


                        if (RId != 5) {
                            $("#btnSave").hide()
                        }

                    }
                    else {
                        $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");
                    }

                    $('#ExpenseAmount').val(result[0].Amount);

                    GetExpenseType(result[0].ExpenseTypeId);
                    GetEmpList(result[0].EmpInfoId);
                    GetExpenseField_ByExpenseType(result[0].ExpenseTypeId, 0);



                    $('#ExpenseDate').val(ToJavaScriptDate_Formater(result[0].ExpenseDate));
                    $('#Comments').val(result[0].Remarks);

                                  
                    var src = "data:image/jpeg;base64,";
                    src += result[0].ImageString;
                    $("#output-image").attr("src", src);
                    $("#output-image").show();
                    $("#imgeBase64Str").val(result[0].ImageString);


                  
                    var row = "";
                    $('#dtTableBody').html("");

        
                    for (var i = 0; i < result.length; i++) {




                            idd++;
                        var FieldNameId = result[i].ExpenseTypDetailsId;

                        var txtFieldName = result[i].FieldName;
                        var txtRequired = result[i].ValueText;

                            row += '<tr id="addr' + (idd) + '">';
                            row += "<td style='text-align: center'>" + (idd) + "</td>";
                        row += '<td > <input type="hidden"   id="HfFieldName"  name="ExpMaster[' + idd + '].txtFieldName" value="' + FieldNameId + '"/>' + txtFieldName + '</td>';
                            row += '<td  > <input type="hidden"   id="HfRe"  name="ExpDetails[' + idd + '].txtRequired" value="' + txtRequired + '"/>' + txtRequired + '</td>';
                        row += "<td ><button class='btn-outline-danger  btn-xs mb-1 mb-md-0' onclick='RemoveRow(" + idd + ")'><i class='bx bxs-minus-circle' aria-hidden='true'></i></button></td>";
                            row += "</tr>";
                        }

                        $('#dtTableBody').html(row);
                    }


               ,
                complete: function () {


                }
            });
        }

      function GetThana_ET(id,parameterId) {
          var urlpath = 'ExpenseClaim.aspx/GetThana_WitTagDetails_forEditPage';
          _Selec2_Multiple_DisableOption_WithAjaxParameter(urlpath, $('#multiSelectId'), 'ThanaId', 'ThanaName', id, parameterId);
    }

                            </script>

                        







</asp:Content>

