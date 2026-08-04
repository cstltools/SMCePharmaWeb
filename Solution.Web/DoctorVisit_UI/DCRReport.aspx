<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DCRReport.aspx.cs" Inherits="DoctorVisit_UI_DCRReport" %>

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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  DCR  Report</div>

                <div class="ms-auto">
                    <div class="btn-group">

                        
                        <a href="../DoctorVisit_UI/DCRList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                       

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


                             <table class="table table-bordered table-striped table-hover">


                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Doctor Info: </td>
                                    <td>
                                        <label id="lblDoctorName"></label>
                                    </td>




                                </tr>

                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Visit Date: </td>
                                    <td>
                                        <label id="lblDcrDate"></label>
                                    </td>




                                </tr>


                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Visit Type: </td>
                                    <td>
                                        <label id="lblTourTypeName"></label>
                                    </td>




                                </tr>




                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Chamber: </td>
                                    <td>
                                        <label id="lblChamberName"></label>
                                    </td>




                                </tr>

                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Visited With:</td>
                                    <td>
                                        <div class="table-responsive" id="tableDetailVisit" style="position: relative;">
                                        </div>
                                    </td>



                                </tr>

                                <tr runat="server" visible="false">
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Commercial:</td>
                                    <td>
                                        <div class="table-responsive" id="tableDetail" style="position: relative;">
                                        </div>
                                    </td>



                                </tr>


                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Sample:</td>
                                    <td>
                                        <div class="table-responsive" id="tableDetailSample" style="position: relative;">
                                        </div>
                                    </td>



                                </tr>

                                <tr>
                                    <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Gift:</td>
                                    <td>
                                        <div class="table-responsive" id="tableDetailGift" style="position: relative;">
                                        </div>
                                    </td>



                                </tr>



                            </table>
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
            if (masterid) {
                $("#masterId").val(getUrlVars()["id"]);
              
                GetDegree(masterid);
            }


             else {
              

            }

        });


        function un(o) {
            return o != null ? o : '';
        }

            function GetDegree(id) {
                var urlpath = 'DCRReport.aspx/GetDCRReportDataById';
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
                success: function(data) {
                    data = data.d;
                    $('#tabH').show();


                    var result = JSON.parse(data);
                    $('#lblEmpName').text(un(result[0].empInfo));
                    $('#lblEmpDgs').text(un(result[0].DesigName));


 
                    $('#lblDoctorName').append(un(result[0].DoctorName));
                    $('#lblDcrDate').append(un(result[0].DcrDate));
                    $('#lblTourTypeName').append(un(result[0].TourTypeName));
                    $('#lblChamberName').append(un(result[0].ChamberName));

                 
                    var htmlEmp = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";
                    
                    var html = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";

                    var htmlSam = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";

                    var htmlGift = "<table id='mytable' cellpadding='10'  class='table greyGridTable table-striped table-hover'>";
                    var ProductNamelist = [];
                     
                    var ProductNamelistGift = [];
                    var EmpArr = [];
                    for (var i = 0; i < result.length; i++) {



                        if (i == 0) {
                           

                            EmpArr.push(result[i].EmpName);
                            htmlEmp += "<tr>";
                            htmlEmp += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].EmpName) + "</td>";
                            htmlEmp += "</tr>";

                            



                        }
                        else {

                            if (jQuery.inArray(result[i].EmpName, EmpArr) == -1) {
                                
                                EmpArr.push(result[i].EmpName);

                                htmlEmp += "<tr>";
                                htmlEmp += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].EmpName )+ "</td>";
                                htmlEmp += "</tr>";

                                 
                            }
                        }


                        if (i == 0) {
                            if (result[i].Type == "Commercial") {

                                ProductNamelist.push(result[i].ProductName);
                                html += "<tr>";
                                html += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].ProductName) + "</td>";
                                html += "</tr>";

                            }



                        }
                        else {

                            if (jQuery.inArray(result[i].ProductName, ProductNamelist) == -1) {
                                if (result[i].Type == "Commercial") {
                                    ProductNamelist.push(result[i].ProductName);

                                    html += "<tr>";
                                    html += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].ProductName) + "</td>";
                                    html += "</tr>";

                                }
                            }
                        }






                        if (i == 0) {
                            if (result[i].Type == "Sample") {

                                ProductNamelist.push(result[i].ProductName);
                                htmlSam += "<tr>";
                                htmlSam += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].ProductName) + "</td>";
                                htmlSam += "</tr>";

                            }



                        }
                        else {

                            if (jQuery.inArray(result[i].ProductName, ProductNamelist) == -1) {
                                if (result[i].Type == "Sample") {
                                    ProductNamelist.push(result[i].ProductName);

                                    htmlSam += "<tr>";
                                    htmlSam += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;'> " + un(result[i].ProductName) + "</td>";
                                    htmlSam += "</tr>";

                                }
                            }
                        }


                        if (i == 0) {
                            if (result[i].Type == "Gift") {

                                ProductNamelistGift.push(result[i].ProductName);
                                htmlGift += "<tr>";
                                htmlGift += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].ProductName) + "</td>";
                                htmlGift += "</tr>";

                            }



                        }
                        else {

                            if (jQuery.inArray(result[i].ProductName, ProductNamelistGift) == -1) {
                                if (result[i].Type == "Gift") {
                                    ProductNamelistGift.push(result[i].ProductName);

                                    htmlGift += "<tr>";
                                    htmlGift += "<td style='border-left: 3px solid #003842;border-bottom:4px solid white;font-size:15px;''> " + un(result[i].ProductName) + "</td>";
                                    htmlGift += "</tr>";

                                }
                            }
                        }
                    }


                  
 
                   
                    html += "</table>"
                    htmlSam += "</table>"
                    htmlGift += "</table>"
                    htmlEmp += "</table>"
                    $('#tableDetail').html(html);
                    $('#tableDetailSample').html(htmlSam);
                    $('#tableDetailGift').html(htmlGift);
                    $('#tableDetailVisit').html(htmlEmp);
                    
                    console.log(htmlSam);
                    //for (var i = 0; i < result.length; i++) {

                    //    row += "<tr style=''>";
                    //    row += "<td style=' border-bottom: 10px solid white;pading:200px;'>" + (i + 1) + ")  Date: " + result[i].TourPlanDate +" </td>";
                    //    row += "<td  style='border-left: 6px solid #003842;border-bottom: 10px solid white;'><div style='pading:10px!important;'> <p> Doctor Name: " + result[i].DoctorName   +   "</p> </div></td>";




                    //    row += "</tr>";
                    //}

                    //$('#dtTableBody').html(row);
                },
                complete: function () {
                    //$('#dtTb').dataTable({
                    //    "ordering": false
                    //});
                }
            });
        }


        
    </script>
 
</asp:Content>

