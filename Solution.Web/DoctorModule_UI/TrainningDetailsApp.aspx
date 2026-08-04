<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrainningDetailsApp.aspx.cs" Inherits="DoctorModule_UI_TrainningDetailsApp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
</head>
<body>
    <form id="form1" runat="server">
        <style>
        .table tbody th, .table thead th {
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
            font-size: 13px;
        }
    </style>

    <div class="container-fluid" style="width: 100%  ;">

        <div class="page-body m-t-20">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="card main-card  pb-4">

                        <div class="card-body">
                            <div class="row">
                                <asp:HiddenField id="masterId"  runat="server" />
                                <div class="table-responsive " id="MainGradeDiv">
                                    <div style="overflow-x:auto;">
                                        <table class="table table-bordered table-striped table-hover" style="overflow-x:auto;">


                                            <tr>
                                                <td class="tblTHColorChang" style=" width:20%; padding: 10px;">Title:</td>
                                                <td>
                                                    <label id="lblTitle"></label>
                                                </td>



                                            </tr>

                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Description: </td>
                                                <td>
                                                    <label id="lblDescription"></label>
                                                </td>




                                            </tr>

                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Trainning Meterial: </td>
                                                <td>
                                                    <div ID="lblTrainningMeterial">

                                                    </div>

                                                </td>



                                            </tr>


                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">From Date:</td>
                                                <td>
                                                    <label ID="lblFromDate"></label>
                                                </td>



                                            </tr>

                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">To Date:</td>
                                                <td>
                                                    <label ID="lblToDate"></label>
                                                </td>


                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    

         
    </form>
</body>
</html>
