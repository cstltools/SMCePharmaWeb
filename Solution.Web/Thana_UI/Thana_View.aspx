<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Thana_View.aspx.cs" Inherits="Thana_UI_Thana_View" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
<div class="container-fluid" style="width: 100% !important;">

    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Thana List</div>

                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="ThanaEntry.aspx" class="btn btn-sm btn-outline-info "><i class="fa fa-plus" aria-hidden="true"></i>New Entry</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">
     <table id="dtTble"  class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th >#SL</th>
                                        <th >Division Name</th>
                                        <th >District Name</th>
                                        <th >Thana Name</th>
 
                                      <th  style="padding:18px;">Action</th>
                                    </tr>
                                </thead>
                                <tbody id="dtTableBody">
                                </tbody>
                            </table>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>

    
    <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>

<input id="hfEditbtn" value="0" style="display:none" />


    <script>
        $(function () {

            GetThanaInfoAll();
    });

        function un(o) {
            return o != null ? o : '';
        }

        function GetThanaInfoAll() {

            var urlpath = 'Thana_View.aspx/Get_Thana_All_List';
            $.ajax({
                url: urlpath,
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{}",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function(data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].DivisionName) + "</td>";
                        row += "<td>" + un(result[i].DistrictName) + "</td>";
                        row += "<td>" + un(result[i].ThanaName) + "</td>";

                        //row += "<td>" + un(result[i].EMPEntryBy) + "</td>";
                        //row += "<td>" + un(result[i].EntryDatee) + "</td>";
                        //row += "<td>" + un(result[i].EMPUpdateBy) + "</td>";
                        //row += "<td>" + un(result[i].UpdateDatee) + "</td>";

                        //if (result[i].IsActive) {

                        //    row += "<td class='text-center'> <i class='fa fa-1x fa-check-circle text-success'> Active </i></td>";
                        //}

                        //else {

                        //    row += "<td class='text-center'><i class='fa fa-1x fa-ban text-danger'> Inactive </i></td>";
                        //}

                        row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0'  type='button'  style='display:" + $('#hfEditbtn').val() + "' onclick='editClick(" + result[i].ThanaId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        row += "</tr>";

                        //<button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].EmpInfoId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>
                    }

                    $('#dtTableBody').html(row);
                },
                complete: function () {

                    $("#coverScreen").hide();
                    $('#dtTble').dataTable({
                        "bInfo": true,
                        "bFilter": true,
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        pageLength: 10,
                        dom: 'lBfrtip',


                        buttons: ['copy', 'excel', 'pdf', 'print']
                    });
                }
            });
    }

        function editClick(id) {
            location.href = '../Thana_UI/ThanaEntry.aspx?id=' + id + '';
        }

        function DeleteClick(id) {
            $.confirm({
                icon: 'fas fa-question-circle',
                title: 'Are You Sure ?',
                content: 'You are concern to delete the data!',
                theme: 'Supervan',
                type: 'green',
                buttons: {
                    Confirm: {
                        text: 'Confirm',
                        action: function () {
                            Final_DeleteClick(id);
                        }
                    },
                    Cancel: function () {
                    }
                }
            });

            return false;
        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: '/Reason/Delete_ReasonInformation',
                dataType: 'json',
                type: "POST",
                data: { Id: Id },
                async: false,
                beforeSend: function () {
                },
                success: function (data) {
                    $.confirm({
                        icon: 'fas fa-check-circle',
                        title: 'Success !',
                        content: 'Data Deleted Successfully !!!',
                        type: 'green',
                        buttons: {
                            OK: {
                                text: 'OK',
                                action: function () {
                                    location.reload();
                                }
                            }
                        }
                    });
                },
                complete: function () {
                }
            });
            return false;
        }

    </script>
    

</asp:Content>

