<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TerritoryWiseTargetSetupApps.aspx.cs" Inherits="DWSP_TerritoryWiseTargetSetupApps" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title></title>
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="../VerticalAsset/plugins/simplebar/css/simplebar.css" rel="stylesheet" />
    <link href="../VerticalAsset/plugins/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" />
    <link href="../VerticalAsset/plugins/metismenu/css/metisMenu.min.css" rel="stylesheet" />
    <!-- loader-->

    <%--<link href="../VerticalAsset/css/pace.min.css" rel="stylesheet" />--%>

    <%--<link href="../VerticalAsset/plugins/datatable/css/dataTables.bootstrap5.min.css" rel="stylesheet" />--%>
    <%--<script src="../VerticalAsset/js/pace.min.js"></script>--%>
    <!-- Bootstrap CSS -->
    <link href="../VerticalAsset/css/bootstrap.min.css" rel="stylesheet">
    <link href="../VerticalAsset/css/bootstrap-extended.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&amp;display=swap" rel="stylesheet">
    <link href="../VerticalAsset/css/app.css" rel="stylesheet">
    <link href="../VerticalAsset/css/icons.css" rel="stylesheet">
    <!-- Theme Style CSS -->
    <link rel="stylesheet" href="../VerticalAsset/css/dark-theme.css" />
    <link rel="stylesheet" href="../VerticalAsset/css/semi-dark.css" />
    <link rel="stylesheet" href="../VerticalAsset/css/header-colors.css" />

    <link href="../VerticalAsset/plugins/select2/css/select2.min.css" rel="stylesheet" />
    <link href="../VerticalAsset/plugins/select2/css/select2-bootstrap4.css" rel="stylesheet" />

    <%--Date Picker--%>

    <link href="../VerticalAsset/plugins/datetimepicker/css/classic.css" rel="stylesheet" />
    <link href="../VerticalAsset/plugins/datetimepicker/css/classic.time.css" rel="stylesheet" />
    <link href="../VerticalAsset/plugins/datetimepicker/css/classic.date.css" rel="stylesheet" />


    <link rel="stylesheet" href="../VerticalAsset/css/header-colors.css" />
    <link rel="stylesheet" href="../VerticalAsset/plugins/bootstrap-material-datetimepicker/css/bootstrap-material-datetimepicker.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">

    <link href="../VerticalAsset/plugins/Drag-And-Drop/dist/imageuploadify.min.css" rel="stylesheet" />

    <script src="../VerticalAsset/js/bootstrap.bundle.min.js"></script>
    <script src="../VerticalAsset/js/jquery.min.js"></script>
    <script src="../VerticalAsset/plugins/simplebar/js/simplebar.min.js"></script>
    <script src="../VerticalAsset/plugins/metismenu/js/metisMenu.min.js"></script>
    <script src="../VerticalAsset/plugins/perfect-scrollbar/js/perfect-scrollbar.js"></script>


    <script src="../VerticalAsset/plugins/datetimepicker/js/legacy.js"></script>
    <script src="../VerticalAsset/plugins/datetimepicker/js/picker.js"></script>
    <script src="../VerticalAsset/plugins/datetimepicker/js/picker.time.js"></script>
    <script src="../VerticalAsset/plugins/datetimepicker/js/picker.date.js"></script>
    <script src="../VerticalAsset/plugins/bootstrap-material-datetimepicker/js/moment.min.js"></script>
    <script src="../VerticalAsset/plugins/bootstrap-material-datetimepicker/js/bootstrap-material-datetimepicker.min.js"></script>

    <script src="../VerticalAsset/plugins/select2/js/select2.min.js"></script>

  <%--  <script src="../VerticalAsset/plugins/datatable/js/jquery.dataTables.min.js"></script>
    <script src="../VerticalAsset/plugins/datatable/js/dataTables.bootstrap5.min.js"></script>--%>

    	<link href="../VerticalAsset/plugins/datatable/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/scroller/2.0.6/css/scroller.dataTables.min.css" rel="stylesheet" />
    	<script src="../VerticalAsset/plugins/datatable/js/jquery.dataTables.min.js"></script>

	<script src="../VerticalAsset/plugins/datatable/js/dataTables.bootstrap5.min.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.css" />
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


    <script src="../VerticalAsset/plugins/Drag-And-Drop/dist/imageuploadify.min.js"></script>


    <link media="screen" rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.css" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/js/toastr.js"></script>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.css" media="screen">
    <script src="//cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.js"></script>


    <script src="../assets/jquery-ui.min.js"></script>
    <link href="../assets/jquery-ui.min.css" rel="stylesheet" />
    <script src="../CustomScript/_myCusGen_Func.js"></script>
    <script src="../CustomScript/_QuickDataAccess.js"></script>

    <script src="../VerticalAsset/js/app.js"></script>
       <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
 <%--   <style>
        .btnexcel {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 8px 12px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
            margin: 4px 2px;
            cursor: pointer;
        }
    </style>--%>
    <style>
        .imgCSS {
            border-radius: 50%;
            box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.2), 0 3px 10px 0 rgba(0, 0, 0, 0.19);
        }
         .GridPager a,
            .GridPager span {
                display: inline-block;
                padding: 3px 14px;
                margin-right: 8px;
                border-radius: 3px;
              /*  height: 20px;*/
                border: solid 1px #c0c0c0;
                background: #e9e9e9;
                box-shadow: inset 0px 1px 0px rgba(255,255,255, .8), 0px 1px 3px rgba(0,0,0, .1);
                font-size: 14px;
                font-weight: bold;
                text-decoration: none;
                color: #717171;
                text-shadow: 0px 1px 0px rgba(255,255,255, 1);
            }

            .GridPager a {
                background-color: #f5f5f5;
                color: #969696;
                border: 1px solid #969696;
            }

            .GridPager span {
                background: #616161;
                box-shadow: inset 0px 0px 8px rgba(0,0,0, .5), 0px 1px 0px rgba(255,255,255, .8);
                color: #f0f0f0;
                text-shadow: 0px 0px 3px rgba(0,0,0, .5);
                border: 1px solid #3AC0F2;
            }


    </style>
    <script type="text/javascript">

        function showpop6(msg, title) {
            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": false,
                "progressBar": true,
                "positionClass": "toast-bottom-right",
                "preventDuplicates": true,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "3000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
            // toastr['success'](msg, title);
            var d = Date();
            toastr.error(msg, title);
            return false;
        }
        function showpop5(msg, title) {
            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": false,
                "progressBar": true,
                "positionClass": "toast-bottom-right",
                "preventDuplicates": true,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "3000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
            // toastr['success'](msg, title);
            var d = Date();
            toastr.success(msg, title);
            return false;
        }
        //$(document).ready(function () {
        //    debugger;
        //    var a = 'aa';
        //    var st = sessionStorage.data;
        //    if (st != null) {
        //        //$("#mCSB_1_container").css(st);
        //        $("#mCSB_1_container").attr("style", st);
        //    }


        //    setInterval(function () {

        //        var styl = $("#mCSB_1_container").attr("style");
        //        sessionStorage.data = styl;
        //    }, 1);
        //});

        function successalert(msg1, type, url) {


            swal({
                icon: 'success',
                title: 'Congratulations!',
                text: msg1,
                type: 'success',
                showClass: {
                    popup: 'animate__animated animate__fadeInDown'
                },
                hideClass: {
                    popup: 'animate__animated animate__fadeOutUp'
                }
            }).then((willDelete) => {
                if (type == 'Success') {


                    window.location.href = url; //replace ID value-->
                }
                else {
                    alert("Operation Faild!!!")
                }

                //swal({
                //    title: "Congratulations!",
                //    text: msg2,
                //    type: 'success'
                //}).then((willDelete) => {
                //    swal({
                //        title: "Congratulations!",
                //        text: msg3,
                //        type: 'success'
                //    })
                //})
            })
        }


        function ShowSuccesalert(msg1, type) {


            swal({
                icon: 'success',
                title: 'Congratulations!',
                text: msg1,

                type: 'success'
            }).then((willDelete) => {
                if (type == 'success') {



                }
                else {

                }

                //swal({
                //    title: "Congratulations!",
                //    text: msg2,
                //    type: 'success'
                //}).then((willDelete) => {
                //    swal({
                //        title: "Congratulations!",
                //        text: msg3,
                //        type: 'success'
                //    })
                //})
            })
        }

        function faildalert(msg1, type) {


            swal({
                icon: 'error',
                title: 'Oops...',
                text: msg1,

                type: 'faild'
            }).then((willDelete) => {
                if (type == 'Faild') {



                }
                else {

                }

                //swal({
                //    title: "Congratulations!",
                //    text: msg2,
                //    type: 'success'
                //}).then((willDelete) => {
                //    swal({
                //        title: "Congratulations!",
                //        text: msg3,
                //        type: 'success'
                //    })
                //})
            })
        }


        function sweetAlertConfirm_Submit(btnSave) {
            if (btnSave.dataset.confirmed) {
                // The action was already confirmed by the user, proceed with server event
                btnSave.dataset.confirmed = false;
                return true;
            } else {
                // Ask the user to confirm/cancel the action
                event.preventDefault();
                swal({
                    title: 'Are You Sure ?',
                    text: 'You are about to submit the data!',
                    type: 'info',
                    icon: 'warning',
                    buttons: {
                        yes: {
                            text: "Confirm",
                            value: "yes"
                        },
                        no: {
                            text: "Cancel",
                            value: "no",
                            className: "",
                            closeModal: true,
                        }
                    }
                }
                )

                    .then((value) => {
                        if (value === "yes") {
                            btnSave.dataset.confirmed = true;
                            // Trigger button click programmatically
                            btnSave.click();
                        }
                        return false;
                        // Set data-confirmed attribute to indicate that the action was confirmed

                    }).catch(function (reason) {
                        // The action was canceled by the user
                    });

            }
        }


        function sweetAlertConfirm_Update(btnUpdate) {
            if (btnUpdate.dataset.confirmed) {
                // The action was already confirmed by the user, proceed with server event
                btnUpdate.dataset.confirmed = false;
                return true;
            } else {
                // Ask the user to confirm/cancel the action
                event.preventDefault();
                swal({
                    title: 'Are You Sure ?',
                    text: 'You are about to submit the data!',
                    type: 'green',
                    icon: 'warning',
                    buttons: {
                        yes: {
                            text: "Confirm",
                            value: "yes"
                        },
                        no: {
                            text: "Cancel",
                            value: "no",
                            className: "",
                            closeModal: true,
                        }
                    }
                }
                )

                    .then((value) => {
                        if (value === "yes") {
                            btnUpdate.dataset.confirmed = true;
                            // Trigger button click programmatically
                            btnUpdate.click();
                        }
                        return false;
                        // Set data-confirmed attribute to indicate that the action was confirmed

                    }).catch(function (reason) {
                        // The action was canceled by the user
                    });

            }
        }





        function sweetAlertConfirm_Delete(btnUpdate) {
            if (btnUpdate.dataset.confirmed) {
                // The action was already confirmed by the user, proceed with server event
                btnUpdate.dataset.confirmed = false;
                return true;
            } else {
                // Ask the user to confirm/cancel the action
                event.preventDefault();
                swal({
                    title: 'Are You Sure ?',
                    text: 'You are about to Remove the data!',
                    type: 'green',
                    icon: 'warning',
                    buttons: {
                        yes: {
                            text: "Confirm",
                            value: "yes"
                        },
                        no: {
                            text: "Cancel",
                            value: "no",
                            className: "",
                            closeModal: true,
                        }
                    }
                }
                )

                    .then((value) => {
                        if (value === "yes") {
                            btnUpdate.dataset.confirmed = true;
                            // Trigger button click programmatically
                            btnUpdate.click();
                        }
                        return false;
                        // Set data-confirmed attribute to indicate that the action was confirmed

                    }).catch(function (reason) {
                        // The action was canceled by the user
                    });

            }
        }
    </script>
  

  

    <style>
        .swal-button.swal-button--no {
            background-color: #DD6B55;
        }
        /*form progress bar*/
        .divWaiting {
            background-color: #262424;
            position: fixed;
            left: 0px;
            top: 0px;
            z-index: 2147483647;
            width: 100%;
            height: 2215px;
            opacity: 0.8;
            overflow: hidden;
            text-align: center;
        }

        .divWaitingJquery {
            background-color: #262424;
            position: fixed;
            left: 0px;
            top: 0px;
            z-index: 2147483647;
            width: 100%;
            height: 2215px;
            opacity: 0.8;
            overflow: hidden;
            text-align: center;
        }



        .position-set {
            margin: 300px auto;
        }

        .sidebar-wrapper .metismenu ul a i {
            margin-right: 5px !important;
        }

        .sidebar-wrapper .metismenu a .parent-icon {
            font-size: 20px !important;
            line-height: 1;
        }

        .page-content {
            padding: 0.7rem !important;
        }

        .sidebar-wrapper .metismenu a .menu-title {
            margin-left: 5px !important;
        }

        div.dataTables_wrapper div.dataTables_filter {
            text-align: right !important;
            margin-top: -45px !important;
        }

        table.table-bordered.dataTable th {
            /* border-right-width: 0; */
            text-align: center !important;
        }

        .btnMyDesignSave {
            background-color: #2EAF5A !important;
            color: white !important;
            font-style: normal !important;
            font-weight: bold;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }


        .btnMyDesignDraft {
            background-color: #051937 !important;
            color: white !important;
            font-style: normal !important;
            font-weight: bold;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

        .btnMyDesignAddtoList {
            background-color: #00A8C5 !important;
            color: white !important;
            font-style: normal !important;
            font-weight: bold;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

        .btnMyDesignSearch {
            background-image: linear-gradient(to right, #7474BF 0%, #348AC7 51%, #7474BF 100%);
            color: white !important;
            font-style: normal !important;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }


         .btnMyDesignSaveNew {
           background-image: linear-gradient(to right, #f6d365 0%, #fda085 51%, #f6d365 100%);
            color: black !important;
            font-style: normal !important;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }


        .btnMyDesignOne {
            background-color: #0ba360 !important;
            color: white !important;
            font-style: normal !important;
            font-weight: bold;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }


        .btnMyDesignGrid {
            background-image: linear-gradient(to right, #DD5E89 0%, #DD5E89 51%, #DD5E89 100%);
            color: white !important;
            font-style: normal !important;
            font-weight: bold;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

        .btnMyDesignReset {
            background-color: #FF7D00 !important;
            color: white !important;
            font-style: normal !important;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

        .btnMyDesignEdit {
            color: #FF7D00 !important;
            font-style: normal !important;
            font-weight: bold;
            margin: 1px 1px !important;
            padding: 8px, 8px;
            cursor: pointer !important;
            font-size: 14px !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

        .btn-smm {
            padding: .3rem .1rem !important;
            font-size: .375rem !important;
            border-radius: .2rem !important;
        }

        .btnGridSize {
            color: #ffc107 !important;
            border-color: #ffc107 !important;
            display: inline-block;
            font-weight: 400;
            line-height: 1.5;
            color: #212529;
            text-align: center;
            text-decoration: none;
            vertical-align: middle;
            cursor: pointer;
            -webkit-user-select: none;
            -moz-user-select: none;
            user-select: none;
            background-color: transparent;
            border: 1px solid transparent;
            border-top-color: transparent;
            border-right-color: transparent;
            border-bottom-color: transparent;
            border-left-color: transparent;
            padding: 2px 2px;
            font-size: 1rem;
            border-radius: .25rem;
            transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
        }

            .btnGridSize:hover {
                color: black !important;
            }

        .border-myinfo {
            border-color: #0d6efd;
        }

        table.blueTable {
            font-family: Verdana, Geneva, sans-serif;
            width: 100%;
            text-align: center;
            border-collapse: collapse;
            border-style: none !important;
        }

            table.blueTable td, table.blueTable th {
                padding: 3px 2px;
                border-style: none !important;
            }

            table.blueTable tbody td {
                font-size: 12px;
                color: #000000;
            }

            table.blueTable tr:nth-child(even) {
                background: #D0E4F5;
            }

            table.blueTable thead {
                background: #52A8E6;
                background: -moz-linear-gradient(top, #7dbeec 0%, #63b0e8 66%, #52A8E6 100%);
                background: -webkit-linear-gradient(top, #7dbeec 0%, #63b0e8 66%, #52A8E6 100%);
                background: linear-gradient(to bottom, #7dbeec 0%, #63b0e8 66%, #52A8E6 100%);
                border-style: none !important;
            }

                table.blueTable thead th {
                    font-size: 14px;
                    font-weight: bold;
                    color: #ffffff;
                    text-align: center;
                    padding: 8px;
                    border-style: none !important;
                }

        .text-c-red {
            color: red !important;
            background-color: white;
            border-style: none;
            margin-top: 7px !important;
            height: 10px !important;
            width: 2px !important;
        }


        .text_Link {
            height: 30px !important;
        }



        .select2-container--bootstrap4 .select2-selection--single {
            height: calc(1.2em + 0.75rem + 2px) !important;
        }

        .btn.btn-outline-secondary.buttons-excel.buttons-html5 {
            /* margin-top: -43px!important;
    margin-left: 50px!important;*/
            /*  text-align: center !important;
    margin-left: 500px!important;*/
            /*	height: 35px !important;*/
            /* background-color: #1D6F42!important;
	color:white!important;*/
            /*font-size: 14px!important;*/
        }

        .form-switch {
            padding-left: 0.8em !important;
        }

        .col-form-label {
            padding-top: calc(.375rem + 1px) !important;
            padding-bottom: calc(.375rem + 1px) !important;
            margin-bottom: 0 !important;
            font-size: inherit !important;
            line-height: 1.5 !important;
            text-align: right !important;
            font-weight: bold !important;
        }

        .dt-buttons.btn-group {
            margin-left: 450px !important;
            margin-top: -45px !important;
        }

        #ContentPlaceHolder1_loadGridView_filter {
            margin-top: -45px !important;
        }

        .chkRadioChoice label {
            padding-left: 5px;
            padding-right: 10px;
            font-weight: bold;
        }
    </style>
     
    
</head>
<body>
    <form id="form1" runat="server">
        <style>
        /*.table tbody th, .table thead th {
            background: #2F4F4F;
            background: -moz-linear-gradient(top, #637b7b 0%, #436060 66%, #2F4F4F 100%);
            background: -webkit-linear-gradient(top, #637b7b 0%, #436060 66%, #2F4F4F 100%);
            background: linear-gradient(to bottom, #637b7b 0%, #436060 66%, #2F4F4F 100%);
            border-bottom: 2px solid #2F4F4F;
            padding: 10px 8px;
        }

        .table tbody td, .table thead td {
            padding: 10px 8px;
        }

        .tblTHColorChang {
            background-color: #EDF2F5;
            font-weight: bold;
            font-size: 12px;
        }

         .imgshadow{

            width:100%;
            height:300px;
        
 border: 1px solid #ddd;
  border-radius: 4px;
  padding: 5px;
 box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
 border: 3px #1c87c9;
        border-style: dashed;
        }
         .imgshadow:hover {
  box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
}
         p.c {
  word-break: break-all;
}*/



        .btnMyDesignSearch {
            background-image: linear-gradient(to right, #7474BF 0%, #348AC7 51%, #7474BF 100%);
            color: white !important;
            font-style: normal !important;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

        .btnMyDesignReset {
            background-color: #FF7D00 !important;
            color: white !important;
            font-style: normal !important;
            margin: 2px 1px !important;
            cursor: pointer !important;
            -webkit-transition-duration: 0.4s !important;
            transition-duration: 0.4s !important;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 3px 10px 0 rgba(0,0,0,0.19) !important;
        }

    </style>
    
    <style>

        .form-switch {
            padding-left: 2.5em;
        }

        .form-check {
            display: block;
            min-height: 1.5rem;
            padding-left: 1.5em;
            margin-bottom: .125rem;
        }

        .chkChoice label {
            padding-left: 2px;
            padding-right: 2px;
        }
    </style>
    
    

               <script type="text/javascript">
                                      <%-- window.onload = function () {
                                           CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                       }--%>

                                            function pageLoad() {
                                                $('.datepicker').pickadate({
                                                    selectMonths: true,
                                                    selectYears: true
                                                })

                                                $('.multiple-select').select2({
                                                    includeSelectAllOption: true,
                                                    theme: 'bootstrap4',
                                                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                    placeholder: $(this).data('placeholder'),
                                                    allowClear: Boolean($(this).data('allow-clear')),
                                                });




                                        <%--   //CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');--%>
                                           //CKEDITOR.replace('ContentPlaceHolder1_TrainningMeterial');
                                         <%--  var prm = Sys.WebForms.PageRequestManager.getInstance();
                                           if (prm != null) {
                                               prm.add_endRequest(function (sender, e) {
                                                   if (sender._postBackSettings.panelsToUpdate != null) {
                                                       CKEDITOR.remove(CKEDITOR.instances['<%=TrainningMeterial.ClientID %>']);
                                                       CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                                       OpenModal();
                                                   }
                                               });
                                           } else {
                                              
                                           }
                                           ;--%>
                                                $('.mySelect2').select2({
                                                    theme: 'bootstrap4',
                                                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                    placeholder: $(this).data('placeholder'),
                                                    allowClear: Boolean($(this).data('allow-clear')),
                                                });
                                            }


                                            function ImageToBase64ShopImg(image) {



                                                var img = image.files[0];
                                                var reader = new FileReader();
                                                reader.onloadend = function () {
                                                    $("#ContentPlaceHolder1_imgeBase64Str").val("");
                                                    $("#ContentPlaceHolder1_hfimgeBase64Str").val("");
                                                    var base64result = reader.result.split(',')[1];
                                                    $("#ContentPlaceHolder1_imgeBase64Str").val(base64result);
                                                    $("#ContentPlaceHolder1_hfimgeBase64Str").val(base64result);

                                                    $("#ContentPlaceHolder1_outputimage").attr("src", reader.result);
                                                    $("#ContentPlaceHolder1_hfimgShow").val(reader.result);
                                                }



                                                reader.readAsDataURL(img);
                                            }
                                             
               </script> 
        

                  
        
           <style>

    .form-switch {
        padding-left: 2.5em;
    }

    .form-check {
        display: block;
        min-height: 1.5rem;
        padding-left: 1.5em;
        margin-bottom: .125rem;
    }

      .chkChoice label {
            padding-left: 2px;
            padding-right: 2px;
        }
</style>

            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                     <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
    
        <div class="page-content">
      

            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            
                        <asp:ScriptManager ID="ScriptManager1" runat="server">
                        </asp:ScriptManager>
                              
                                         
                                                 <script type="text/javascript">
                                                     function pageLoad() {
                                                         $('.datepicker').pickadate({
                                                             selectMonths: true,
                                                             selectYears: true
                                                         });
                                                         $('.mySelect2').select2({
                                                             theme: 'bootstrap4',
                                                             width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                             placeholder: $(this).data('placeholder'),
                                                             allowClear: Boolean($(this).data('allow-clear')),
                                                         });
                                                     }

                                                     var dateNow = new Date();
                                                     $('.datepickess').datepicker("setDate", dateNow);
                                                     minDate: new Date() // to disable privious dates 
                                                 </script>
                        <div class="row">&nbsp;</div>

                   

                                <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Year:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:DropDownList  runat="server"   AutoPostBack="true" OnSelectedIndexChanged="ddlmonth_SelectedIndexChanged" id="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                              <%--  <span id="v-year" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>--%>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>
                                    
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Month:  </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList  runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlmonth_SelectedIndexChanged"   id="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                      

                                          <%--              <span id="v-month" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
                                                        <span class="input-group-text text-c-red">*</span>--%>

                                                    </div>

                                                </div> 
    
                                 
                                            </div>
                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                            <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Group:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="groupname_SelectedIndexChanged1" id="groupname"  CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                              <%--                  <span id="v-groupname" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>--%>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                                <div class="row">
                                    <div class="col-2">&nbsp;</div>
                                    <div class="col-8">
                                        <div class="form-group row">
                                            <label for="mainName" class="col-sm-3 col-form-label">Zone:  </label>
                                            <asp:HiddenField ID="hfAreaId" runat="server" /> 
                                            <asp:HiddenField ID="hfZoneId" runat="server" /> 
                                            <div class="col-sm-7">
                                                <div class="input-group">
                                                    <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlZone_OnSelectedIndexChanged" id="ddlZone" CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                   <%-- <span id="v-ddlZone" class="invalid-tooltip fade hide" data-delay="2000">
                                                    </span>
                                                    <span class="input-group-text text-c-red">*</span>--%>

                                                </div>

                                            </div> 
    
                                 
                                        </div>
                                    </div>
                                    <div class="col-2">&nbsp;</div>
                                </div>

                                          <div class="row">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                        <label for="mainName" class="col-sm-3 col-form-label">Area:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                               <asp:DropDownList  runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlArea_SelectedIndexChanged" id="ddlArea"  CssClass="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                            <%--    <span id="v-ddlArea" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>--%>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>

                            <div class="row" >
                                <div class="col-2">&nbsp;</div>
                                <div class="col-8">
                                    <div class="form-group row">
                                   
                                        
                                        <label for="mainName" class="col-sm-3 col-form-label">Target:  </label>

                                        <div class="col-sm-7">
                                            <div class="input-group">
                                                <asp:TextBox   runat="server" id="amount" ReadOnly="true" CssClass=" form-control form-control-sm mb-3 clsDecimal" ></asp:TextBox>
                                                
                                                <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server"
                                                                             TargetControlID="amount"
                                                                             FilterType="Custom, Numbers"
                                                                             ValidChars="." />

                                   <%--             <span id="v-amount" class="invalid-tooltip fade hide" data-delay="2000">
                                                </span>
                                                <span class="input-group-text text-c-red">*</span>--%>

                                            </div>

                                        </div> 
    
                                 
                                    </div>
                                </div>
                                <div class="col-2">&nbsp;</div>
                            </div>


                        <br/>    


                                <div class="row">
                                
                                <div class="col-12">
                                    <div class="table-responsive" id="MainGradeDiv">

                                        <asp:GridView ID="gv_List" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                                  <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="HFTerritoryId" Value='<%#Eval("TerritoryId")%>' />

                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                    <asp:TemplateField HeaderText="Amount">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtAmount" runat="server" Text='<%#Eval("Amount") %>' AutoPostBack="True" OnTextChanged="txtAmount_OnTextChanged" CssClass="form-control form-control-sm mb-3 clsDecimal"></asp:TextBox>
                                                        
                                                        <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server"
                                                                                     TargetControlID="txtAmount"
                                                                                     FilterType="Custom, Numbers"
                                                                                     ValidChars="." />
                                                        

                                                    
                                                           
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                </Columns>
                            </asp:GridView>

                                    </div>
                                    

                                </div>
                                
                            </div>
                        <br />
                            <br />
                                

                        <div class="row"> 
                            <div class="col-12">

                                <div class="form-group row">
                                  
                                    <div class="col-sm-9">

                                         <asp:LinkButton  OnClick="btnSave_Click"  OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                           <asp:LinkButton  runat="server" ID="btnAdd"  OnClick="btnAdd_Click"  class="btn btnMyDesignAddtoList  btn-sm"  ><i class="fa fa-plus-circle" aria-hidden="true"></i>&nbsp; Add Vacant Target </asp:LinkButton>
                       
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
                         
 
                    
         
   </ContentTemplate>
                </asp:UpdatePanel>
    

         
    </form>
</body>
</html>