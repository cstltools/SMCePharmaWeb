<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorPlanDetailsView.aspx.cs" Inherits="DoctorVisit_UI_DoctorPlanDetailsView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Doctor Visit Information</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        
                        <a href="../DoctorVisit_UI/DoctorVisit.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                       

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">


                          <div class="row">
                              <div class="col-md-4"></div>
                              <div class="col-md-4">
                                  
					<div class="col">
					<div class="card radius-10 bg-success bg-gradient">
							<div class="card-body">
								<div class="text-center">
									<div>
										<h5 class="my-1 text-white">Employee: <label style="font-size:16px;"  id="lblEmpName"></label></h5>
										<h5 class="my-1 text-white">Designation: <label style="font-size:16px;" id="lblEmpDgs"></label> </h5>
									</div>
									
									</div>
								</div>
							</div>
						</div>
					</div>
                               
                              </div>
                          </div>
                          


                               <br />
                        <div class="table-responsive" id="tableDetail" style="position: relative; min-height: 360px !important;">
                        </div>
                        <div class="table-responsive " id="MainGradeDiv">
                            <table class="table greyGridTable table-striped table-hover" id="dtTb">
                                <tbody id="dtTableBody">
                                

                                </tbody>
                            </table>

                          
                        </div>

                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            
    
<style>
    table.greyGridTable {
        border-collapse: collapse;
    }

        table.greyGridTable td, table.greyGridTable th {
            border: 1px solid #FFFFFF;
            padding: 5px 4px;
        }

        table.greyGridTable tr:nth-child(even) {
            background: #EBEBEB;
        }

        table.greyGridTable tbody td {
            font-size: 13px;
            font-weight: bold;
        }

        table.greyGridTable tfoot td {
            font-size: 14px;
        }

    .tdDesign {
        border-right: 5px solid #003842;
    }

    table {
        border-collapse: separate;
        border-spacing: 0 1em;
    }
    #mytable tr td {
        padding: 1em !important;
    }
</style>
 

     <input id="masterId" value="0" style="display:none" />
    <script>

        function un(o) {
            return o != null ? o : '';
        }


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
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
                GetDegree(masterid);
            }

            


        });

        function GetDegree(id) {
            var urlpath = 'DoctorPlanDetailsView.aspx/GetDoctorPlanDetailsViewDatabyID';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ "id": id }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function () { },
                success: function (data) {
                    data = data.d;
                    $('#tabH').show();
                    var result = JSON.parse(data);
                    $('#lblEmpName').text(un(result[0].EmpName));
                    $('#lblEmpDgs').text(un(result[0].DesigName));

                    var html = "<table id='mytable' cellpadding='10' class='table greyGridTable table-striped table-hover'>";
                    var dates = [];

                    for (var i = 0; i < result.length; i++) {

                        // 🧩 New Section Divider by TourPlanDate
                        if (i == 0) {
                            dates.push(result[i].TourPlanDate);

                            html += "<tr>";
                            html += "<td style='border-right:5px solid #003842;border-bottom:5px solid white;font-size:22px;'>"
                                + un(result[i].TourPlanDate) + "</td>";
                            html += "<td style='border-bottom:5px solid white;'>";

                            // 👇 Conditional Name Section
                            if (un(result[i].Type_DV) === 'C') {
                                html += "<h6>Customer Name: <span style='font-weight:normal'>" + un(result[i].DoctorName) + "</span></h6>";
                            } else if (un(result[i].Type_DV) === 'D') {
                                html += "<h6>Doctor Name: <span style='font-weight:normal'>" + un(result[i].DoctorName) + "</span></h6>";
                            }  

                            html += "<br/>";
                        }
                        else {

                            if (jQuery.inArray(result[i].TourPlanDate, dates) == -1) {

                                html += "</td>";
                                dates.push(result[i].TourPlanDate);

                                html += "<tr>";
                                html += "<td style='border-right:5px solid #003842;border-bottom:5px solid white;font-size:22px;'>"
                                    + un(result[i].TourPlanDate) + "</td>";
                                html += "<td style='border-bottom:5px solid white;'>";

                                // 👇 Conditional Name Section
                                if (un(result[i].Type_DV) === 'C') {
                                    html += "<h6>Customer Name: <span style='font-weight:normal'>" + un(result[i].DoctorName) + "</span></h6>";
                                } else if (un(result[i].Type_DV) === 'D') {
                                    html += "<h6>Doctor Name: <span style='font-weight:normal'>" + un(result[i].DoctorName) + "</span></h6>";
                                }  

                                html += "<br/>";
                            }
                            else {
                                // 👇 Same date group
                                if (un(result[i].Type_DV) === 'C') {
                                    html += "<h6>Customer Name: <span style='font-weight:normal'>" + un(result[i].DoctorName) + "</span></h6>";
                                } else if (un(result[i].Type_DV) === 'D') {
                                    html += "<h6>Doctor Name: <span style='font-weight:normal'>" + un(result[i].DoctorName) + "</span></h6>";
                                } 

                                html += "<br/>";
                            }
                        }
                    }

                    html += "</table>";
                    $('#tableDetail').html(html);
                },
                complete: function () {
                    // optional: after load
                }
            });
        }



    </script>

 

</asp:Content>

