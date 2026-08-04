<%@ Page Title="Yearly Leave Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Employee_YearlyLeaveBalanceRpt.aspx.cs" Inherits="Reports_UI_Employee_YearlyLeaveBalanceRpt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
            font-size: 20px;
            font-weight: bold;
        }

        .radioChoice2 label {
            padding-left: 5px;
            padding-right: 30px;
            font-size: 16px;
            font-weight: bold;
        }



        .Label_Title {
            background-color: #C7C7C7;
            width: 100%;
            text-align: center;
            margin: 0px;
            padding: 3px;
            text-align: center;
            color: #000;
            margin-right: 5%;
            font-weight: bold;
            font-size: 13px;
        }
    </style>



    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Yearly Leave Report</div>

                <div class="ms-auto">
                    <div class="btn-group">
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>

                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                            </div>
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                    <script type="text/javascript">


                                         function pageLoad() {


                                             $('.datepicker').pickadate({
                                                 selectMonths: true,
                                                 selectYears: true
                                             })
                                             $('.multiple-select').select2({
                                                 includeSelectAllOption: true,
                                                 theme: 'bootstrap4',
                                                 width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                 placeholder: $(this).data('placeholder'),
                                                 allowClear: Boolean($(this).data('allow-clear')),
                                             });
                                             $('.mySelect2').select2({
                                                 theme: 'bootstrap4',
                                                 width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                 placeholder: $(this).data('placeholder'),
                                                 allowClear: Boolean($(this).data('allow-clear')),
                                             });
                                         }
                                    </script>



                                    <div class="row" runat="server" visible="false">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Month:  </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                        </select>

                                        <span id="v-month" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                    </div>

                                                </div>


                                            </div>
                                        </div>

                                    </div>



                                    <div class="row">
                                        <div class="col-4">


                                            <div class="Label_Title  ">Report Type </div>

                                            <div class="form-group">

                                                <asp:RadioButtonList runat="server" ID="rbReportTypeName" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rbReportTypeName_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                                                    <%--   <asp:ListItem Value="1">User Wise</asp:ListItem>--%>

                                                    <asp:ListItem Value="1">Summary</asp:ListItem>
                                                    <asp:ListItem Value="2">Details</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </div>

                                        </div>


                                        <div class="col-6">

                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Year:  </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                        <span id="v-year" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                    </div>

                                                </div>


                                            </div>
                                            <div class="form-group row">
                                                <label for="mainName" class="col-sm-3 col-form-label">Employee Name:  </label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList runat="server" ID="ddlMIO" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                        <span id="v-ddlMIO" class="invalid-tooltip fade hide" data-delay="2000"></span>


                                                    </div>

                                                </div>


                                            </div>
                                        </div>

                                    </div>

                                    <div style="padding-top: 16px;"></div>
                                    <div class="row">
                                        <div class="col-md-5">
                                        </div>
                                        <div class="col-md-4" style="align-content: center">
                                            <asp:LinkButton runat="server" ID="btnSearch" class="btn btnMyDesignSearch   btn-sm " OnClick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>


                                            <asp:LinkButton runat="server" class="btn btnMyDesignReset   btn-sm" ID="resetBtn" OnClick="resetBtn_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                        </div>
                                    </div>

                                    <br />

                                      <div class="row">
                                        <div class="col-md-12">
                                            <label></label>
                                        </div>


                                        <div class="col-md-2">
                                        </div>
                                        <div class="col-md-2">
                                        </div>
                                        <div class="col-md-2">
                                        </div>
                                        <div class="col-md-1">
                                        </div>
                                        <div class="col-md-1">
                                        </div>

                                        <div class="col-md-2" style="margin-top: 5px;">
                                            


                                        </div>


                                        <div class="col-md-2" runat="server" >

                                           <%--  <button id="export-btn" type="button" class="btn btn-sm btn-outline-primary rounded-pill pull-right" data-mdb-ripple-color="#000000"><i class="fa fa-file-excel-o" aria-hidden="true"></i> Excel Export </button>--%>
                                            <asp:LinkButton ID="btnExportToExcel"   runat="server" CssClass="btn btn-success pull-right" OnClick="btnExport_Click"><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton>

                                      <%--    <a href="javascript:void(processPrint());">Print</a>--%>

                                        </div>

                                           
                                    </div>

                                    <br />
                                    <div class="table-responsive" id="MainGradeDiv">

                                        <%--onrowcommand="loadGridView_RowCommand"--%>

                                       <div class="row" runat="server" id="repotDiv" visible="false">
                                           
                                                <div class="col-md-9"> 
                                                   
                                                   <table class="table table-striped table-bordered">
                                               <thead>

                                                    <tr>
                                                    <th>Emp. ID.:</th>
                                                    <th colspan="3"><asp:Label ID="lblEmpId" runat="server"></asp:Label></th>
                                                    <th>Emp. Name:</th>
                                                     <th colspan="4"><asp:Label ID="lblEmpName" runat="server"></asp:Label></th>
                                                    <th >User Role:</th>
                                                   
                                                    <th colspan="4"  ><asp:Label ID="lbluR" runat="server"></asp:Label></th>
                                                </tr>
                                                    <tr>
                                                  
                                                     <th colspan="4">Casual</th>
                                                    <th colspan="4">Sick</th>
                                                   
                                                    <th  colspan="5">Annual</th>
                                                </tr>

                                                 <tr>
                                                    
                                                     <th  >Eligibility</th>
                                                          <th  >Available</th>
                                                     <th  >Taken</th>
                                                     <th  >Balance</th>
                                                
                                                      <th  >Eligibility</th>
                                                     
                                                     <th  >Available</th>
                                                     <th  >Taken</th>
                                                       <th  >Balance</th>

                                                      <th  >Eligibility</th>
                                                    
                                                     <th  >Available</th>
                                                     <th  >Previous AL</th>
                                                         <th  >Taken</th>
                                                       <th  >Balance</th>
                                                    
                                                </tr>
                                               </thead>
                                               <tbody>
                                                    <tr>
                                                   

                                                    <td><asp:Label ID="ElliCasual" runat="server"></asp:Label></td>
                                                         <td ><asp:Label ID="abCasual" runat="server"></asp:Label></td>
                                                  
                                                     <td ><asp:Label ID="TKCasual" runat="server"></asp:Label></td>
                                                           <td ><asp:Label ID="CasualBlnc" runat="server"></asp:Label></td>
                                                    
                                                     <td ><asp:Label ID="ElliSick" runat="server"></asp:Label></td>
                                                   <td ><asp:Label ID="abSick" runat="server"></asp:Label></td>
                                                    <td ><asp:Label ID="TKSick" runat="server"></asp:Label></td>
                                                           <td ><asp:Label ID="SickBlnc" runat="server"></asp:Label></td>



                                                   

                                                    <td ><asp:Label ID="ElliAnnual" runat="server"></asp:Label></td>
                                                           <td ><asp:Label ID="abAnnual" runat="server"></asp:Label></td>
                                                     <td ><asp:Label ID="PreviousAL" runat="server"></asp:Label></td>
                                                  
                                     
                                                    <td ><asp:Label ID="TKAnnual" runat="server"></asp:Label></td>
                                                                  <td ><asp:Label ID="AnnualBlnc" runat="server"></asp:Label></td>
                                                   
                                                     
                                                    </tr>
                                               </tbody>
                                            </table></div> 
                                         
                                           
                                      
                                                <div class="col-md-3">
                                                    
                                                    <h4 class="alert alert-info">Day Wise Leave</h4>
                                                   <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            OnRowCommand="loadGridView_RowCommand"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                            <Columns>
                                                <%--<asp:BoundField DataField="EmpMasterCode" HeaderText="Employee ID" />
                                                <asp:BoundField DataField="EmpName" HeaderText="Employee Name" />
                                                <asp:BoundField DataField="RoleName" HeaderText="User Role" />--%>
                                                <asp:BoundField DataField="LeaveFromDate" HeaderText="Leave From Date" />

                                                <asp:BoundField DataField="LeaveToDate" HeaderText="Leave To Date" />
                                                <asp:BoundField DataField="Days" HeaderText="Day(s)" />

                                                <asp:BoundField DataField="LeaveTypeName" HeaderText="Leave Type" />
                                                <asp:BoundField DataField="ApprovalStatus" HeaderText="Approval Status" />




                                            </Columns>
                                        </asp:GridView>

                                                    </div>
                                          
                                       </div>
                                     
                                         <div class="row" runat="server" id="rptSum" visible="false">
                                        
                                        <asp:GridView ID="gv_Summary" runat="server" AutoGenerateColumns="False"
                                            CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                            <Columns>
                                                <asp:BoundField DataField="EmpMasterCode" HeaderText="Emp. ID" />
                                                <asp:BoundField DataField="MarketCode" HeaderText="Territory" />
                                                <asp:BoundField DataField="EmpName" HeaderText="Name of the Employee" />
                                                <asp:BoundField DataField="DesigName" HeaderText="Desig." />
                                                <asp:BoundField DataField="BaseHQ" HeaderText="Base HQ." />
                                                <asp:BoundField DataField="Dateofjoin" HeaderText="DoJ" />



                                                <asp:BoundField DataField="Los" HeaderText="LoS [Y-M-D]" />

                                                <asp:BoundField DataField="MonthCount" HeaderText="Month Count" />

                                                <asp:BoundField DataField="PreviousLeave" HeaderText="Previous Leave (AL)" />

                                                <asp:BoundField DataField="Casual" HeaderText=" Casual Leave" />

                                                <asp:BoundField DataField="Sick" HeaderText="Sick Leave" />

                                                <asp:BoundField DataField="Annual" HeaderText="Annual Leave" />
                                                <%--<asp:BoundField DataField="Annual" HeaderText="Annual Leave" />--%>


                                                <asp:BoundField DataField="Eligible" HeaderText="Eligible (AL)" />

                                                <asp:BoundField DataField="Balance" HeaderText="Balance (AL)" />
                                                <%--<asp:BoundField DataField="Annual" HeaderText="Annual Leave" />--%>

                                                <asp:BoundField DataField="LeaveEncash" HeaderText="Leave Encash" />
                                                <asp:BoundField DataField="AccumulatedLeave" HeaderText="Accumulated Leave (AL)" />

                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                    </div>






                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnExportToExcel" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>



    <script language="javascript">



        $(document).on('click', '#export-btn', function () {
            // Get the HTML table data
            var data = $('#MainGradeDiv').html();

            // Create a temporary HTML element to hold the table data
            var table = document.createElement('table');
            table.innerHTML = data;

            // Add a border style to the table cells
            var cells = table.getElementsByTagName('td');
            for (var i = 0; i < cells.length; i++) {
                cells[i].style.border = '1px solid black';
            }

            // Create a Blob object with the modified table data
            var blob = new Blob([table.outerHTML], {
                type: 'application/vnd.ms-excel'
            });

            // Save the file using FileSaver.js
            saveAs(blob, 'TA & DA Report.xls');
        });

        var gAutoPrint = true;

        function processPrint() {

            if (document.getElementById != null) {
                var html = '<HTML>\n<HEAD>\n';
                if (document.getElementsByTagName != null) {
                    var headTags = document.getElementsByTagName("head");
                    if (headTags.length > 0) html += headTags[0].innerHTML;
                }

                html += '\n</HE' + 'AD>\n<BODY>\n';
                var printReadyElem = document.getElementById("printMe");

                if (printReadyElem != null) html += printReadyElem.innerHTML;
                else {
                    alert("Error, no contents.");
                    return;
                }

                html += '\n</BO' + 'DY>\n</HT' + 'ML>';
                var printWin = window.open("", "processPrint");
                printWin.document.open();
                printWin.document.write(html);
                printWin.document.close();

                if (gAutoPrint) printWin.print();
            } else alert("Browser not supported.");

        }
    </script>

      <script>
          $(function () {
              $("#btnExport").click(function (e) {
                  debugger;

                  $("#repotDiv :hidden").remove();
                  let file = new Blob([$('#repotDiv').html()], { type: "application/vnd.ms-excel" });
                  let url = URL.createObjectURL(file);

                  let a = $("<a />", {
                      href: url,
                      download: "Yearly Leave Detail Report.xls"
                  }).appendTo("body").get(0).click();
                  e.preventDefault();




              });
          });
      </script> 
</asp:Content>

