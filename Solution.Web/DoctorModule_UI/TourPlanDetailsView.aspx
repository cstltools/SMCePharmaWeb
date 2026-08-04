<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="TourPlanDetailsView.aspx.cs" Inherits="DoctorModule_UI_TourPlanDetailsView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 
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

    #mytable tr td{
        padding: 1em !important;
    }

</style>


    
    
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Tour Plan  Report</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        
                        <a href="TourPlannedUserList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                       

                    </div>
                </div>
            </div>
            <!--end breadcrumb-->



            <div class="row" >
                <div class="col">
                      <button type="button" runat="server" visible="false" id="exportButton">Export to Excel</button>

                    <div class="card border-top border-0 border-4 border-success" id="exportTable">
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

                               <div class="col-md-4">
                                    
                                         <div class="table-responsive" id="MainGradeDsiv">
                                <table id="dtTb" class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th class="text-center"># SL No</th>
                                            <th>Tour Type  </th>
                                            <th>Count  </th>
                                             
                                        </tr>
                                    </thead>
                                    <tbody id="dtTableBody" class="txtCenter">
                                    </tbody>
                                </table>

                            </div>
                            
                               </div>
                               
                              </div>


                             <br />

                        <div class="table-responsive" id="tableDetail" style="position: relative; min-height: 360px !important;">
                            </div>
                        <div class="table-responsive " id="MainGradeDiv">
                              </div>
                              </div>
                              </div>
                              </div>
                              </div>
                              </div> 
        </div>
    <input id="masterId" value="0" style="display:none" />
    <input id="Month" value="0" style="display:none" />
    <input id="year" value="0" style="display:none" />
    <input id="empId" value="0" style="display:none" /> 
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.0/xlsx.full.min.js"></script>

 
    <script>

    
          $(document).ready(function() {
              $("#exportButton").click(function () {
                  var table = document.getElementById('exportTable');
                  var wb = XLSX.utils.table_to_book(table, { sheet: "Sheet1" });
                  XLSX.writeFile(wb, "myFileName.xlsx");
              });
});
 
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

        function un(o) {
            return o != null ? o : '';
        }

        $(function () {
            var masterid = getUrlVars()["id"];
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);

                GetDegree(masterid);
 

            }
            

             
        });

        function GetDegree(id) {
            var urlpath = 'TourPlanDetailsView.aspx/GetTourPlanDetailsViewDatabyID';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({
                    "id": id
                }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function() {
                },
                success: function (data) {


                   
                    $('#tabH').show();
                    var result = JSON.parse(data.d);

                    $('#lblEmpName').text(un(result[0].EmpName));
                    $('#lblEmpDgs').text(un(result[0].DesigName));

                    //$("#Month").val(un(result[0].MonthValue));
                    //$("#year").val(un(result[0].YearValue));
                    //$("#empId").val(un(result[0].EmpInfoId));

                    GetStationType(un(result[0].EmpInfoId), un(result[0].MonthValue), un(result[0].YearValue));

                    var row = "";


                    var html = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";
                    var dates = [];
                    
                    for (var i = 0; i < result.length; i++) {


                        if (i == 0) {

                            dates.push(result[i].TourPlanDate);

                            html += "<tr>";
                            html += "<td style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + un(result[i].TourPlanDate) + "</td>";
                            html += "<td  style='border-bottom:5px solid white;'>";
                            html += "<h6> Visit Type: <span style='font-weight:normal; text-decoration:underline'>" + un(result[i].MarketWise) + "</span></h6>";

                            html += "<h6> Start Place: <span style='font-weight:normal'>" + un(result[i].MarketName) + "</span></h6>";
                            html += "<h6> End Place: <span style='font-weight:normal'>" + un(result[i].MarketNameEnd) + "</span></h6>";

                            html += "<h6> Tour Purpose: <span style='font-weight:normal'>" + un(result[i].StationTypeName) + "</span></h6>";

                            html += "<h6>Other Market Visit: <span style='font-weight:normal'>" + un(result[i].CustomerName) + "</span></h6>";
                            html += "<h6> Worked With  : <span style='font-weight:normal'>" + un(result[i].VisitedWithEmp) + "</span></h6>";
                            html += "<h6> Objective: <span style='font-weight:normal'>" + un(result[i].Objective) + "</span></h6> <br/>";
                            
                        }
                        else {

                            if (jQuery.inArray(result[i].TourPlanDate, dates) == -1) {

                                html += " </td>";

                                dates.push(result[i].TourPlanDate);

                                html += "<tr>";
                                html += "<td  style='border-right: 5px solid #003842;border-bottom:5px solid white;font-size:22px;'> " + un(result[i].TourPlanDate) + "</td>";
                                html += "<td style='border-bottom:5px solid white;'>";
                                html += "<h6> Visit Type: <span style='font-weight:normal; text-decoration:underline'>" + un(result[i].MarketWise) + "</span></h6>";

                                html += "<h6> Start Place: <span style='font-weight:normal'>" + un(result[i].MarketName) + "</span></h6>";
                                html += "<h6> End Place: <span style='font-weight:normal'>" + un(result[i].MarketNameEnd) + "</span></h6>";


                                html += "<h6> Tour Purpose: <span style='font-weight:normal'>" + un(result[i].StationTypeName) + "</span></h6>";

                                html += "<h6> Other Market Visit: <span style='font-weight:normal'>" + un(result[i].CustomerName) + "</span></h6>";
                                html += "<h6> Worked With  : <span style='font-weight:normal'>" + un(result[i].VisitedWithEmp) + "</span></h6>";
                                html += "<h6> Objective: <span style='font-weight:normal'>" + un(result[i].Objective) + "</span></h6> <br/>";
                             
                               
                               
                            }
                            else {
                                html += "<h6> Visit Type: <span style='font-weight:normal; text-decoration:underline'>" + un(result[i].MarketWise) + "</span></h6>";

                                html += "<h6> Start Place: <span style='font-weight:normal'>" + un(result[i].MarketName) + "</span></h6>";
                                html += "<h6> End Place: <span style='font-weight:normal'>" + un(result[i].MarketNameEnd) + "</span></h6>";

                                html += "<h6> Tour Purpose: <span style='font-weight:normal'>" + un(result[i].StationTypeName) + "</span></h6>";
                                html += "<h6>Other Market Visit: <span style='font-weight:normal'>" + un(result[i].CustomerName) + "</h6>";
                                html += "<h6> Worked With  : <span style='font-weight:normal'>" + un(result[i].VisitedWithEmp) + "</span></h6>";
                                html += "<h6> Objective: <span style='font-weight:normal'>" + un(result[i].Objective) + "</h6> <br/>";
                                 
                            }
                        }

                    }

                    html += "</table>"
                  
                
                    $('#tableDetail').html(html);
                   
                },
                complete: function () {
                    
                }
            });
        }



        function GetStationType(empId,Month, year) {
            var urlpath = 'TourPlanDetailsView.aspx/Get_TourPlanBalance';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({
                    "empId": empId,
                    "Month": Month,
                    "year": year

                   
                }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                async: true,
                beforeSend: function () {
                },
                success: function (data) {
                   



                    $('#tabH').show();

                    var row = "";
                    $('#dtTableBody').html("");

                    var result = JSON.parse(data.d);


                    for (var i = 0; i < result.length; i++) {

                        row += "<tr>";
                        row += "<td  >" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].StationTypeName) + "</td>";
                        row += "<td>" + un(result[i].Balance) + "</td>";
                        row += "</tr>";

                    }

                    $('#dtTableBody').html(row);


                },
                complete: function () {

                }
            });
        }

    </script>
 

</asp:Content>

