<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TharapeuticGroupView.aspx.cs" Inherits="DoctorModule_UI_TharapeuticGroupView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Therapeutic Group List</div>
                
                <div class="ms-auto">
                    <div class="btn-group">

                        

                           <a href="TharapeuticGroupEntry.aspx" class="btn btn-sm btn-outline-info">
                            <i class="fa fa-plus" aria-hidden="true"></i>&nbsp;New Entry
                        
                        </a>
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                         
                                   
                                    <div class="p-4 border rounded">
                                        <div class="row g-3 needs-validation">



                                            <div class="table-responsive" id="MainGradeDiv">

                                               

                                              


                                                  <table id="dtTble" class="table table-striped table-bordered">
                             <thead>
                                    <tr>
                                        <th class="text-center"># SL No</th>
                                        <th > Therapeutic Group </th>
                                        <th > Therapeutic Group Code</th>
                                        <th > Entry By </th>
                                        <th > Entry Date </th>
                                        <th > Update By </th>
                                        <th > Update Date </th>
                                        <th > Active/Inactive By </th>
                                        <th > Active/Inactive Date </th>
                                        <th > Is Active </th>
                                        <th > Action </th>
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
    </div>
 



    <script>

        $(function () {

            GetFinancialYear();
        });


        function un(o) {
            return o != null ? o : '';
        }


        function GetFinancialYear() {

            debugger;
            var urlpath = 'TharapeuticGroupView.aspx/GetTherapueticGroupList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                //data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();

                    var row = "";

                    var result = JSON.parse(data);

                    $('#dtTableBody').html("");

                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td >" + (i + 1) + "</td>";
                        row += "<td >" + un(result[i].TherapeuticGroupName) + "</td>";
                        row += "<td >" + un(result[i].TherapeuticGroupCode) + "</td>";
                        row += "<td >" + un(result[i].EMPEntryBy) + "</td>";
                        row += "<td >" + un(result[i].EntryDatee) + "</td>";
                        row += "<td >" + un(result[i].EMPUpdateBy) + "</td>";
                        row += "<td >" + un(result[i].UpdateDatee) + "</td>";
                        row += "<td >" + un(result[i].EMPActiveInactiveBy) + "</td>";
                        row += "<td >" + un(result[i].InactiveDatee) + "</td>";

                        if (result[i].IsActive) {
                            row += "<td><span class='badge bg-success'>Active</span></td>";
                        } else {
                            row += "<td><span class='badge bg-warning'>Inactive</span></td>";
                        }




                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0'   type='button'   onclick='editClick(" + result[i].TherapeuticGroupId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button>  </td>";


                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);


                },
                complete: function () {
                    //$('#dtTble').dataTable({
                    //    "ordering": false
                    //});
                }
            });
        }


        function editClick(id) {
            location.href = '../DoctorModule_UI/TharapeuticGroupEntry.aspx?id=' + id + '';
        }

        function DeleteClick(id) {
            
                            Final_DeleteClick(id);
            

            return false;
        }

        function Final_DeleteClick(id) {
            var Id = id;
            $.ajax({
                url: '/ReferralCentre/Delete_ReferralCentre',
                dataType: 'json',
                data: JSON.stringify({ 'Id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                //data: { Id: Id },
                async: false,
                beforeSend: function () {
                },
                success: function (data) {

                    
                                    location.reload();
                    
                },
                complete: function () {
                }
            });

            return false;

        }


    </script>














</asp:Content>

