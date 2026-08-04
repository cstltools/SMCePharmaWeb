<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TADAMarketRuleConfigurationView.aspx.cs" Inherits="DoctorModule_UI_TADAMarketRuleConfigurationView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 

                   
 <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   DA Market Rule Config List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">
                        <a href="TADAMarketRuleConfiguration.aspx"  class="btn btn-sm btn-outline-info " ><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>
                      

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                        <div class="table-responsive" id="MainGradeDiv">


                            <table id="dtTble" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>SL</th>
                                        <th>Tour Type</th>
                                        <th>User Role</th>
                                        <%--<th>TA Amount </th>--%>
                                        <th>DA Amount </th>
                                        <th>Status</th>
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
     
    <script>
        $(function () {

            GetPrescription();
    });

        function GetPrescription() {

            var urlpath = 'Setup.aspx/GetTADAMarketRuleConfigurationList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                type: "POST",
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
                        row += "<td>" + result[i].TourType + "</td>";
                        row += "<td>" + result[i].RoleName + "</td>";
                        //row += "<td>" + result[i].TAAmount + "</td>";
                        row += "<td>" + result[i].DAAmount + "</td>";
                        
                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        }
                        else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }
                     
                        row += "<td><button class='btn-outline-warning     btn-xs mb-1 mb-md-0' type='button'    onclick='editClick(" + result[i].TADAMarketRuleConfigId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button> </td>";
                        row += "</tr>";
                       /* <button class='btn-outline-danger btn-sm' onclick='DeleteClick(" + result[i].TADAMarketRuleConfigId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/
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
            location.href = '../DoctorModule_UI/TADAMarketRuleConfiguration.aspx?id=' + id + '';
        }

        function DeleteClick(id) {
            //$.confirm({
            //    icon: 'fas fa-question-circle',
            //    title: 'Are You Sure ?',
            //    content: 'You are concern to delete the data!',
            //    theme: 'Supervan',
            //    type: 'green',
            //    buttons: {
            //        Confirm: {
            //            text: 'Confirm',
            //            action: function () {
                            Final_DeleteClick(id);
            //            }
            //        },
            //        Cancel: function () {
            //        }
            //    }
            //});

            return false;
        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: 'Setup.aspx/Delete_TADAMarketRuleConfiguration',
                dataType: 'json',
                data: JSON.stringify({ 'Id': Id }),
                contentType: "application/json; charset=utf-8",
                type: "POST",
                //data: { Id: Id },
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

