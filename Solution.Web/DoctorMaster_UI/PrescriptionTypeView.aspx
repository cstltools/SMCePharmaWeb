<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="PrescriptionTypeView.aspx.cs" Inherits="DoctorMaster_UI_PrescriptionTypeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
      <div class="page-wrapper">
         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
             <ContentTemplate>
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Special Day list </div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="../DoctorMaster_UI/SpecialDaySetup.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>

                    </div>
                </div>
            </div>

            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <div class="table-responsive" id="MainGradeDiv">
                                  <table id="dtTble"     class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>PrescriptionType </th>
                                        <th>Active/Inactive Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
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
         </ContentTemplate>
         </asp:UpdatePanel>
                                </div>
       <script type="text/javascript">
      $(function () {
          GetPrescriptionType();
       });

      function GetPrescriptionType() {         
            $.ajax({
                url: 'PrescriptionTypeView.aspx/Get_PrescriptionTypeList',
                type: 'post',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                data: "{}",
                async: true,

                beforeSend: function() {
                },
                success: function(data) {

                    $('#tabH').show();
                    var result = JSON.parse(data.d);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + result[i].PrescriptionType + "</td>";
                        row += "<td>" + result[i].Activedate + "</td>";

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-danger'>Inactive</span></td>";
                        }

                  /*      row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].PrescriptionTypeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> <button class='btn-outline-danger btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].PrescriptionTypeId + ")'><i class='fa fa-minus-circle' aria-hidden='true'></i></button></td>";*/

                        row += "<td><button class='btn-outline-warning btn-xs mb-1 mb-md-0' onclick='editClick(" + result[i].PrescriptionTypeId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button></td>";


                        row += "</tr>";
                    }
                    $('#dtTableBody').html(row);

                  
                },
                complete: function () {
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

               location.href = '../DoctorMaster_UI/PrescriptionType.aspx?id=' + id;
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

                url: '/Setup/Delete_PrescriptionType',
                dataType: 'json',
                type: "POST",
                data: { Id: Id },
                async: false,

                beforeSend: function () {
                },
                success: function (data) {
                    alert("Data Deleted Successfully !!!");
                    location.reload();
                },
                complete: function () {
                }
            });
            return false;
       }

       </script>      
</asp:Content>

