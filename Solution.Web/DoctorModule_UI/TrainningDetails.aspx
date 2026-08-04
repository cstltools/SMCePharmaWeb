<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TrainningDetails.aspx.cs" Inherits="DoctorModule_UI_TrainningDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
<input id="masterId" value="0" style="display:none" />
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
    

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Trainning Report</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../DoctorModule_UI/TrainningView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <br />
                            
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
 

 
    <script>
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
            if (masterid > 0) {
                $("#masterId").val(getUrlVars()["id"]);
                GetData(masterid);
            } else {
                  var url = 'TrainningView.aspx';
        window.location.href = url;

            }

        });


          function GetData(id) {
              var urlpath = 'Setup.aspx/GetTrainningEditData';
        $.ajax({
        url: urlpath,
            dataType: 'json',
            data: JSON.stringify({ 'id': id }),
            type: "POST", contentType: "application/json; charset=utf-8",
            async: true,
        async: true,
            success: function (data) {
                data = data.d;

                $('#lblTitle').text(data.Title);
                $('#lblDescription').text(data.Description);
               
                $('#lblTrainningMeterial').append(data.TrainningMeterial);
                var fromDate = formatDate(new Date(parseInt(data.FromDate.substr(6))));
                var ToDate = formatDate(new Date(parseInt(data.ToDate.substr(6))));

                $('#lblFromDate').text(fromDate);
                $('#lblToDate').text(ToDate);






        },
        complete: function() {
        }
        });
        }
    </script>
 
</asp:Content>

