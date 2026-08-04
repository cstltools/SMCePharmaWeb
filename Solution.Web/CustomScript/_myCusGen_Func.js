// Author : Shariful Islam
// file created : 31 January 2021

function _open_LoadingPopUp_WithMsg(dDivId,strMessage) {
    $('#' + dDivId).html();
    var html = '';
    html += '<div class="modal" id="saveModalCustome" data-dismiss="modal" tabindex="-1" aria-labelledby="exampleModalLabel" data-keyboard="false" data-backdrop="static" aria-hidden="true">';
    html += '<div class="modal-dialog modal-dialog-centered" >';
    html += '<div class="modal-content">';
    html += '<div class="modal-body" style="margin-left: 16%;">';
    html += '' + strMessage +'... &nbsp;&nbsp;&nbsp;&nbsp;';
    html += '<div class="spinner-border text-primary" role="status">';
    html += '<span class="sr-only">Loading...</span>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    $('#' + dDivId).html(html);
    $('#saveModalCustome').modal();
}


function _close_LoadingPopUp_WithMsg() {
    $('#saveModalCustome').modal('hide');
}

//JqueryConfirm

function _errorWithMsg(msg) {
    $.confirm({
        icon: 'fas fa-exclamation-triangle',
        title: 'Encountered an error!',
        content: msg,
        type: 'red',
        typeAnimated: true
    });
}

function _saveError() {
    $.confirm({
        icon: 'fas fa-exclamation-triangle',
        title: 'Encountered an error!',
        content: 'Something went downhill, please try again',
        type: 'red',
        typeAnimated: true
    });
}

function _saveErrorDuplicate() {
    $.confirm({
        icon: 'fas fa-exclamation-triangle',
        title: 'Encountered an error!',
        content: 'Already Exist!!!, please try again',
        type: 'red',
        typeAnimated: true
    });
}





function groupTable($rows, startIndex, total) {
    if (total === 0) {
        return;
    }
    var i, currentIndex = startIndex, count = 1, lst = [];
    var tds = $rows.find('td:eq(' + currentIndex + ')');
    var ctrl = $(tds[0]);
    lst.push($rows[0]);
    for (i = 1; i <= tds.length; i++) {
        if (ctrl.text() == $(tds[i]).text()) {
            count++;
            $(tds[i]).addClass('deleted');
            lst.push($rows[i]);
        }
        else {
            if (count > 1) {
                ctrl.attr('rowspan', count);
                groupTable($(lst), startIndex + 1, total - 1)
            }
            count = 1;
            lst = [];
            ctrl = $(tds[i]);
            lst.push($rows[i]);
        }
    }
}


function JsDateToStringDate(d) {
    let month = String(d.getMonth() + 1);
    let day = String(d.getDate());
    const year = String(d.getFullYear());
    if (day.length < 2) day = '0' + day;
    let monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    //let ds = monthNames[month.replace(/^0+/, '')];
   
    return `${day}-${monthNames[month-1]}-${year}`;
}


function ToJavaScriptDate_Formater(value) {
    var pattern = /Date\(([^)]+)\)/;
    var results = pattern.exec(value);
    var dt = new Date(parseFloat(results[1]));
    var dayData = dt.getDate();
    if (dayData < 10) {
        dayData = "0" + dayData;
    }
    var monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var rDate = dayData + "-" + monthNames[(dt.getMonth())] + "-" + dt.getFullYear();
    return rDate;
}

//Select Option Load


// DtTable
function SelectOption_DtTable_Async_True(urlpath, setControlId, bindId, bindName, setId) {

    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: true,
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
           

        }
    });
}
function SelectOption_DtTable_Async_false(urlpath, setControlId, bindId, bindName, setId) {

    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
            }
        },
        complete: function () {

            setControlId.val(setId);
        }
    });
}
function SelectOption_DtTable_Async_True_WithSelect2Multiple_(urlpath, setControlId, bindId, bindName, setId) {

    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: true,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
            }
        },
        complete: function () {
            if (setId == 0) {

            } else {
                let arr = setId.split(',');
                setControlId.val(arr).change();
            }

            setControlId.select2();
            setControlId.val(setId);
        }
    });
}
function LoadSelectOption_ById(urlpath, setControlId, bindId, bindName, setId, filterId) {
    debugger;
    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",
        data: JSON.stringify({ 'id': filterId }),contentType: "application/json; charset=utf-8",
        async: true,
        success: function (data) {
    debugger;

            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>--- Select ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
            }
        },
        complete: function () {
 
            setControlId.val(setId);
        }
    });
}





// section Only Select Option//


//======================//


// Section Select option Multi Select with Select2


function Selec2_Multiple_DisableOption(urlpath, setControlId, bindId, bindName, setId) {
    var IsDisable = '';
    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: true,
        success: function (data) {
            var result = JSON.parse(data.d);
            setControlId.empty();
            for (var i = 0; i < result.length; i++) {
                if (result[i][IsDisable] == 1) {
                    setControlId.append($("<option disabled='disabled'></option>").val(result[i][bindId]).html(result[i][bindName]));
                } else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
                }
            }
        },
        complete: function () {
            if (setId == 0) {
               // setControlId.val(setId);
            } else {
                let arr = setId.split(',');
               // alert(arr);
                setControlId.val(arr).change();
            }
            
            setControlId.select2();
            
        }
    });
}
function _Selec2_Multiple_DisableOption_WithAjaxParameter(urlpath, setControlId, bindId, bindName, setId,id) {
    var IsDisable = 'IsDisable';
    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({ 'id': id }),
        success: function (data) {
  
            var result = JSON.parse(data.d);
            setControlId.empty();
            for (var i = 0; i < result.length; i++) {
                if (result[i][IsDisable] == 1) {
                    setControlId.append($("<option disabled='disabled'></option>").val(result[i][bindId]).html(result[i][bindName]));
                } else {
                    setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
                }
            }
        },
        complete: function () {
            if (setId == 0) {

            } else {
                let arr = setId.split(',');
                setControlId.val(arr).change();
            }
            setControlId.select2();
   
           
        }
    });
}

//=====================//



function SelectOption_ListObjectReturns_Async_True(urlpath, setControlId, bindId, bindName, setId) {

    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: true,
        success: function (result) {
            console.log(result);
            result = result.d;
            setControlId.empty();
            setControlId.append($("<option>--- Select ---</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
            }
        },
        complete: function () {
            setControlId.val(setId);
        }
    });
}


function SelectOption_DtTable_Async_True(urlpath, setControlId, bindId, bindName, setId) {

    $.ajax({
        url: urlpath,
        dataType: 'json',
        type: "POST",contentType: "application/json; charset=utf-8",
        async: true,
        success: function (data) {
         
            var result = JSON.parse(data.d);
            setControlId.empty();
            setControlId.append($("<option>Select from list</option>").val(0));
            for (var i = 0; i < result.length; i++) {
                setControlId.append($("<option></option>").val(result[i][bindId]).html(result[i][bindName]));
            }
        },
        complete: function () {
            setControlId.val(setId);
        }
    });
}







