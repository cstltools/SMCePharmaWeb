
//String input validation

function formatDate(date) {

     
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2)
        month = '0' + month;
    if (day.length < 2)
        day = '0' + day;

    return [year, month, day].join('-');
}


//String input validation

function ValidationClassses(field) {

    if ($.trim(field.val()) == '') {

        if (field.hasClass('valid')) {
            field.removeClass("valid");
        }

        field.addClass("invalid");
        return false;

    }
    else {
        if (field.hasClass('invalid')) {
            field.removeClass("invalid");
        }

        field.addClass("valid");
    }

    return true;
}


// Dropdownlist validation

function DropdownValidationClassses(field) {
    if ($.trim(field.val()) == 0) {
        if (field.hasClass('valid')) {
            field.removeClass("valid");
        }
        field.addClass("invalid");
        return false;

    }
    else {
        if (field.hasClass('invalid')) {
            field.removeClass("invalid");
        }
        field.removeClass("invalid");
        field.addClass("valid");
    }

    return true;
}

//Decimal validation

$(".allow_decimal").on("input", function (evt) {
    var self = $(this);
    self.val(self.val().replace(/[^0-9\.]/g, ''));
    if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57)) {
        evt.preventDefault();
    }
});