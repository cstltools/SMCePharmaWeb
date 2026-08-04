<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="NoticeRecords.aspx.cs" Inherits="NoticeBoard_UI_NoticeRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Notice List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../NoticeBoard_UI/NoticeSetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">
                               <table id="dtTble"   class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Title</th>
                                        <th>Announcement </th>
                                        <th>From Date </th>
                                        <th>To Date</th>
                                        <th>Action</th>

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
     <div id="coverScreen" class="divWaitingJquery ">
        <img src="../images/Spinner.gif" style="width:180px" class="position-set" />
                </div>
    <script>

        function un(o) {
            return o != null ? o : '';
        }
        $(function () {

            GetPrescription();
    });

        function GetPrescription() {

            var urlpath = 'NoticeBoard.aspx/GetNoticeMasterList';
            $.ajax({
                url: urlpath,
                //url: urlpath,
                dataType: 'json',
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function(data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + result[i].NoticeTitle + "</td>";
                        row += "<td class='text-wrap width-200'>" + result[i].Announcement + "</td>";
                        row += "<td>" + un(result[i].FromDate) + "</td>";
                        row += "<td>" + un(result[i].ToDate) + "</td>";
                        row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0'    type='button'   onclick='editClick(" + result[i].NoticeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        row += "</tr>";

                       /* <button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].NoticeId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/
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
            location.href = 'NoticeSetup.aspx?MID=' + id + '';
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
                url: '/NoticeBoard/Delete_NoticeMaster',
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
                            content: 'Data Deleted successfully',
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

