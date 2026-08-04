//Common Data Load function
// Do not modify any function.
//If needs any create new
//Author :  Shaon
//setControlId = html input control id, bindId and bindName is attribute from database
function _getDepot_ByCompanyId_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: '../DoctorModule_UI/DepotWiseAreaSetup.aspx/LoadDepotlist',
        dataType: 'json',
        
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'comapnyId': id }),
        //data: { comapnyId: id },
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>Select from list</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
           setControlId.select2();
        }
    });

}
function _getZone_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetZone_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Zone ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _getUserList_Active(setControlId, bindId, bindName) {

    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetUserList_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select User ---</option>").val(""));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {

            //setControlId.select2();
            //    //setControlId.select2();
        }
    });

}

function _getEmployeeList_Active(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: '../DoctorModule_UI/ExpenseClaim.aspx/GetEmployeeList_Active',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Employee ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
        setControlId.select2();
              //setControlId.select2();
        }
    });

}


function _getApprovalList_Active(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: '../DoctorModule_UI/Setup.aspx/Get_ApprovalStatus_ddl',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>Select Approval Status</option>").val(""));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
            setControlId.select2();
            //setControlId.select2();
        }
    });

}



function _getEmployeeList_All(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetEmployeeList_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select an Employee ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
            }




        },
        complete: function () {
            setControlId.val(SetId);
            setControlId.select2();
            //setControlId.select2();
        }
    });

}


function _getDepartment_Active(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetDepartment_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Department ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
            //setControlId.select2();
            //    //setControlId.select2();
        }
    });

}


function _getDesignation_Active_Emp(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetDesignation_Active_Emp',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Designation ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
            //setControlId.select2();
            //    //setControlId.select2();
        }
    });

}


function _getShift_Active(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetShift_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Shift ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
            //setControlId.select2();
            //    //setControlId.select2();
        }
    });

}


function _getCompanyList_Active(setControlId, bindId, bindName, SetId) {
     
    $.ajax({
        url: 'CommonDataLoad.aspx/GetEmployeeList_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Employee ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
          //setControlId.select2();
        //    //setControlId.select2();
        }
    });

}

function _getTourTypeList_Active(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetTourTypeList_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Tour Type ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
            setControlId.select2();
            //    //setControlId.select2();
        }
    });

}
function _getTourTypeList_All(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetTourTypeList_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Tour Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }



                /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(SetId);
            setControlId.select2();
            //    //setControlId.select2();
        }
    });

}


function _getTransportList_Active(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetTransportList_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Transport ---</option>").val("0"));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(SetId);
             setControlId.select2();
            //    //setControlId.select2();
        }
    });

}



function _getTransportList_All(setControlId, bindId, bindName, SetId) {

    $.ajax({
        url: 'CommonDataLoad.aspx/GetTransportList_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Transport ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }



                /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(SetId);
            setControlId.select2();
            //    //setControlId.select2();
        }
    });

}


function _GetFiscalYearInfo_Active(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetFiscalYearInfo_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Fiscal Year ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {

            setControlId.val(setId);
            //setControlId.select2();
        }
    });

}
function _GetGroupInfo_Active(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetGroupInfo_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Group ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {

            setControlId.val(setId);
        setControlId.select2();
        }
    });

}


function _GetNational_Active(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetNational_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
           
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {

            setControlId.val(setId);
        setControlId.select2();
        }
    });

}


function _GetDoctorType_Active_New(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetDoctorType_Active',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Doctor Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {

            setControlId.val(setId);
            setControlId.select2();
        }
    });

}


function _GetRoleTypeInfo(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetRoleTypeInfo',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>Select From List</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {

            setControlId.val(setId);
            setControlId.select2();
        }
    });

}

function _GetGroupInfo_All(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetGroupInfo_All',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Group ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
            }
        },
        complete: function () {

            setControlId.val(setId);
           setControlId.select2();
        }
    });

}



function _GetCustomerType_All(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetCustomerType_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Group ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


               
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                 
            }
        },
        complete: function () {

            setControlId.val(setId);
            setControlId.select2();
        }
    });

}


function _GetThanaInfo_All(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetThanaInfo_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Thana ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
            }
        },
        complete: function () {

            setControlId.val(setId);
            setControlId.select2();
        }
    });

}

function _getZone_Active_SetValue(setControlId, bindId, bindName,setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetZone_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Zone ---</option>").val(""));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
        
            setControlId.val(setId);
            //setControlId.select2();
        }
    });

}


function _Zone_Active(setControlId, bindId, bindName, id) {
    debugger;
    $.ajax({
        url: 'CommonDataLoad.aspx/GetZone_ActiveById',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            debugger;
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Zone ---</option>").val(""));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _Zone_ActiveAll(setControlId, bindId, bindName,  setId, id) {
    debugger;
    $.ajax({
        url: 'CommonDataLoad.aspx/GetZone_ActiveById',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            debugger;
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Zone ---</option>").val(""));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();
        }
    });

}



function _getZone_ByGroupId_Active(setControlId, bindId, bindName, id) {

    $.ajax({

        url: 'CommonDataLoad.aspx/GetZone_byGroupId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Zone ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.select2();
        }
    });

}function _getZone_ByGroupId_all(setControlId, bindId, bindName, id) {

    $.ajax({

        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetZone_byGroupId_All',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Zone ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.select2();
        }
    });

}

function _getZone_ByGroupId_Active_SetValue(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetZone_byGroupId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}



function _GetChamber_ByDoctorId(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetChamber_ByDoctorId',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}

function _getZone_ByGroupId_All_SetValue(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetZone_byGroupId_All',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');

              
                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));
                    
                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }

           
                
               /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(setId);
             setControlId.select2();

        }
    });

}



function _getNSMEmployee_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetNSMEmployee_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }



                /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}

function _getDZSMSMEmployee_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDZSMEmployee_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }



                /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}

function _getAMEmployee_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetAMEmployee_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }



                /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}


function _getMIOEmployee_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetMIOEmployee_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }



                /* $("#ddlList option[value='jquery']").attr("disabled", "disabled");*/
            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}





function _GetExpenseField_ByExpenseType(setControlId, bindId, bindName, id, setId) {
   
    $.ajax({
        url: 'ExpenseClaim.aspx/GetExpenseField_ByExpenseType',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select  ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            
            setControlId.val(setId);
         setControlId.select2();

        }
    });

}


function _getArea_ByZoneId_Active(setControlId, bindId, bindName,id) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetArea_ByZoneId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Area ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.val(id);
       setControlId.select2();
        }
    });

}


function _getArea_ByZoneId_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetArea_ByZoneId_All',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Area ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }

            }
        },
        complete: function () {
            setControlId.val(setId);
             setControlId.select2();
        }
    });

}

function _getDistrict_ByDivision_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDistrict_ByDivision_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select District ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(id);

            setControlId.select2();
        }
    });

}


function _getThana_ByDistrict_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetThana_ByDistrict_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select District ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(id);

             setControlId.select2();
        }
    });

}

function _getArea_ByZoneId_Active_SetValue(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetArea_ByZoneId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Area ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();

        }
    });

}

function _getTerritory_ByAreaId_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetTerritory_ByAreaId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(id);

            setControlId.select2();
        }
    });

}
function _GetSubTerritory_ByTerritoryId_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetSubTerritory_ByTerritoryId_Active',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Sub-Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(id);

            setControlId.select2();
        }
    });

}



function _GetMarket_BySubTerritoryId_All_new(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetMarket_BySubTerritoryId_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {

            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {

                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));
                } else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }


            }
             
        },
        complete: function () {
             
            setControlId.val(setId);

            setControlId.select2();
        }
    });

}

function _GetMarket_BySubTerritoryId_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetMarket_BySubTerritoryId_Active',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(id);

            setControlId.select2();
        }
    });

}

function _GetSubTerritory_ByTerritoryId_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetSubTerritory_ByTerritoryId_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Sub-Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                debugger;
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));
                } else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }


            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();
        }
    });

}

function _getTerritory_ByAreaId_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetTerritory_ByAreaId_All',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }

            }
        },
        complete: function () {
            setControlId.val(setId);
            setControlId.select2();
        }
    });

}
function _getSubTerritory_ByAreaId_Active_SetValue(setControlId, bindId, bindName, id,setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetTerritory_ByAreaId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();

        }
    });

}

function _getTerritory_ByAreaId_Active_SetValue(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetTerritory_ByAreaId_Active',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();

        }
    });

}

function _getSubTerritory_ByTertory_Active_SetValuee(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetSubTerritory_ByTerritoryId_Active',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Territory ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();

        }
    });

}

function _getMarket_ByTerritoryId_Active(setControlId, bindId, bindName, id) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetMarket_ByTerritoryId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getMarket_ByTerritoryId_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetMarket_ByTerritoryId_All',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();
        }
    });

}



function _GetMarket_BySubTerritoryId_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: '../DoctorModule_UI/CommonDataLoad.aspx/GetMarket_BySubTerritoryId_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();
        }
    });

}



function _getSubTerritory_ByTerritoryId_All(setControlId, bindId, bindName, id, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetSubTerritory_ByTerritoryId_All',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                var data = result[i][bindName];
                var arr = data.split('(');


                if (arr[1] == 'Inactive)') {
                    setControlId.append($("<option disabled></option>").val(result[i][bindId]).html(result[i][bindName]));

                }
                else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

                }

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();
        }
    });

}

function _getMarket_ByTerritoryId_Active_SetValue(setControlId, bindId, bindName, id,setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetMarket_ByTerritoryId_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'id': id }),
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Market ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
            //setControlId.select2();

        }
    });

}

// Doctor Designation

function _getDesignation_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDesignation_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Designation ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

// Doctor Speciality

function _getDoctorSpeciality_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDoctorSpeciality_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Speciality ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getDoctorBrand_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDoctorBrand_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Brand ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _getInstitute_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetInstitute_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Brand ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getContactType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetContactType',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Contact Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _getSpecialDay_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetSpecialDay_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Contact Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _geStationType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetStationType_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Brand ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getChamberType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetChamberType_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Chamber Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}



function _geStationType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetStationType_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Brand ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _geStationType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetStationType_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Brand ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}

function _getDoctorType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: '../DoctorMaster_UI/CommonDataLoad.aspx/GetDoctorType_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Brand ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getDivision_Active_Active(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDivision_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Division ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            setControlId.val(setId);
             setControlId.select2();
        }
    });

}

function _getDoctorProgramType_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetProgramType_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Program Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getDoctorCustomer_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDoctorCustomer_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Customer ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });

}


function _getExpenseType(setControlId, bindId, bindName, setId) {
    $.ajax({
        url: '../DoctorModule_UI/ExpenseClaim.aspx/GetExpenseType',
        dataType: 'json',
        type: "POST", contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Expense Type ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            
            setControlId.val(setId);
           setControlId.select2();
        }
    });

}


// Doctor Degree
function _getDegree_Active(setControlId, bindId, bindName) {
    $.ajax({
        url: 'CommonDataLoad.aspx/GetDegree_Active',
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select Degree ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));

            }
        },
        complete: function () {
            //setControlId.select2();
        }
    });
}

// 