<%@ Page Title="DWSP Report" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DWSPMonthlyRpt.aspx.cs" Inherits="Reports_UI_DWSPMonthlyRpt" %>
<%@ Register Src="~/Reports_UI/IVMarketStructureMarket.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../VerticalAsset/jquery.tabletoCSV.js"></script>
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


    <script type="text/javascript">
        function pageLoad() {

            $('.multiple-select').select2({
                includeSelectAllOption: true,
                theme: 'bootstrap4',
                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                placeholder: $(this).data('placeholder'),
                allowClear: Boolean($(this).data('allow-clear')),
            });
            $('.datepicker').pickadate({
                selectMonths: true,
                selectYears: true
            });
            $('.mySelect2').select2({
                theme: 'bootstrap4',
                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                placeholder: $(this).data('placeholder'),
                allowClear: Boolean($(this).data('allow-clear')),
            });

            $(".fancybox").fancybox({
                openEffect: "none",
                closeEffect: "none"
            });

            $(".zoom").hover(function () {

                $(this).addClass('transition');
            }, function () {

                $(this).removeClass('transition');
            });
        }

    </script>

    <div id="popDiv"></div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> DWSP Report</div>

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

                           <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                                        <ProgressTemplate>

                                            <div class="divWaiting">
                                                <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                                            </div>
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>--%>
                                    <div class="row">
                                             <div class="col-4"  runat="server" visible="false">
                                         
                                            <div class="form-group row">
                                                

                                                <div class="col-sm-8" runat="server" visible="false">

                                                    <asp:RadioButtonList runat="server" ID="rbType" CssClass="radioChoice" AutoPostBack="True" OnSelectedIndexChanged="rbType_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                        <asp:ListItem  Value="0">DCR</asp:ListItem>
                                                        <asp:ListItem Selected="True" Value="1">RX</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                    <asp:DropDownList Visible="false" runat="server" ID="EmployeeIdSelect" name="EmployeeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                                </div>

                                                    <div class="col-sm-8 " runat="server" visible="false">
                                                   
                                                        <div class="Label_Title  ">Report Type </div>
                                                            
                                                                <div class="form-group">
                                                        
                                                    <asp:RadioButtonList runat="server" ID="rbReportTypeName" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rbReportTypeName_SelectedIndexChanged"   RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                                                     <%--   <asp:ListItem Value="1">User Wise</asp:ListItem>--%>

                                                        <asp:ListItem Selected="True" Value="1">Doctor Wise</asp:ListItem>
                                                        <asp:ListItem Value="2">Product Brand Wise</asp:ListItem>
                                                        <asp:ListItem Value="3">Product Wise</asp:ListItem>
                                                            <asp:ListItem Value="4">User Wise</asp:ListItem>

                                                    </asp:RadioButtonList>
                                                     </div>
                                                     
                                                    

                                                </div>

                                            </div>
                         
                                        </div>

                                       
                                        <div class="col-6">
                                            <div class="form-group row">
                                                <label for="FromDate" class="col-sm-4 col-form-label">Month:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ddlmonth" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>
                                                </div>

                                            </div>

                                             <div class="form-group row">
                                                <label for="ToDate" class="col-sm-4 col-form-label">Year:  </label>

                                                <div class="col-sm-8">

                                                    <asp:DropDownList runat="server" ID="ddlYear" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>



                                                </div>

                                            </div>

                                              <div class="form-group row">
                                                    <label for="mainName" class="col-sm-4 col-form-label"> Approval Status: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                     <asp:DropDownList  class="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlApprovalStatus"   ></asp:DropDownList>
                                                         
 

                                              </div>
                                                    </div>
                                                  
                                                </div>

                                        </div>


                                         <div class="col-6">
                                              <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                             </div>
                                     
                                        
                                    </div>


                                    <div class="row">
                                        <div class="col-1">
                                        </div>
                                        <div class="col-5">
                                           

                                        </div>
                                        <div class="col-5">
                                        </div>
                                    </div>


                                    <div class="row">

                                        <div class="col-1">
                                        </div>
                                        <div class="col-5">
                                            <div class="form-group row">
                                            </div>

                                        </div>
                                    </div>


                                    <br />

                                    <div class="row">
                                        <div class="col-md-5">
                                        </div>
                                        <div class="col-md-4" style="align-content: center">

                                            <asp:LinkButton runat="server"  ID="btnSearch" class="btn btnMyDesignSearch   btn-sm " OnClick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                             

                                            <asp:LinkButton runat="server" class="btn btnMyDesignReset   btn-sm" ID="resetBtn" OnClick="resetBtn_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>

                                        </div>
                                    </div>
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
                                        <div class="col-md-1">
                                        </div>
                                         

                                        <div class="col-md-3 ">
                                           <asp:LinkButton ID="btnExportToExcel"  runat="server" CssClass="btn btn-success" OnClick="btnExportToExcel_Click"><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton>

                                                            <%-- <button type="button"  class="btn btn-success pull-right"   onclick="exporttocsv()"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>


                                        </div>
                                    </div>

                                    <div style="padding-top: 10px;"></div>
                                    <div class="table-responsive" id="export" style="height:600px">

                           
                                      <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                            OnRowCommand="loadGridView_RowCommand" CssClass="table table-striped table-bordered"   OnRowCreated="loadGridView_OnRowCreated"  OnPageIndexChanging="loadGridView_PageIndexChanging"  AllowPaging="True" PageIndex="0"  >
                                            <Columns>

                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="EmpMasterCode" HeaderText="Emp. ID" />

                                                <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                                <asp:BoundField DataField="EmpName" HeaderText="Emp. Name" />
                                                <asp:BoundField DataField="DesigName" HeaderText="Designation" />
                                                <asp:BoundField DataField="RoleName" HeaderText="Role" />
                                                <asp:BoundField DataField="" HeaderText="Target Set" />

                                                <asp:BoundField DataField="1_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="1_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="1_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="1_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true" />

                                                <asp:BoundField DataField="2_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="2_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="2_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="2_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="3_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="3_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="3_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="3_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="4_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="4_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="4_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="4_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="5_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="5_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="5_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="5_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="6_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="6_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="6_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="6_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="7_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="7_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="7_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="7_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="8_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="8_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="8_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="8_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="9_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="9_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="9_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="9_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="10_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="10_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="10_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="10_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="11_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="11_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="11_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="11_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="12_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="12_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="12_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="12_Total" HeaderText="Total" ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true" />

                                                <asp:BoundField DataField="13_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="13_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="13_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="13_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="14_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="14_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="14_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="14_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="15_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="15_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="15_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="15_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="16_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="16_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="16_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="16_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="17_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="17_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="17_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="17_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="18_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="18_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="18_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="18_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="19_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="19_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="19_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="19_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="20_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="20_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="20_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="20_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="21_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="21_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="21_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="21_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="22_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="22_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="22_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="22_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="23_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="23_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="23_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="23_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="24_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="24_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="24_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="24_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="25_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="25_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="25_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="25_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="26_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="26_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="26_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="26_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="27_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="27_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="27_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="27_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="28_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="28_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="28_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="28_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="29_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="29_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="29_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="29_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="30_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="30_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="30_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="30_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>

                                                <asp:BoundField DataField="31_Gen" HeaderText="General" />
                                                <asp:BoundField DataField="31_Cam" HeaderText="Campaign" />
                                                <asp:BoundField DataField="31_FCB" HeaderText="FCB" />
                                                <asp:BoundField DataField="31_Total" HeaderText="Total"  ItemStyle-BackColor="AliceBlue" ItemStyle-Font-Bold="true"/>


                                                 <asp:BoundField DataField="Total_Gen" HeaderText="General"  ItemStyle-BackColor="SpringGreen" ItemStyle-Font-Bold="true"/>
                                                <asp:BoundField DataField="Total_Cam" HeaderText="Campaign"  ItemStyle-BackColor="SpringGreen" ItemStyle-Font-Bold="true"/>
                                                <asp:BoundField DataField="Total_FCB" HeaderText="FCB"  ItemStyle-BackColor="SpringGreen" ItemStyle-Font-Bold="true"/>
                                                <asp:BoundField DataField="Grand_Total" HeaderText="Total"  ItemStyle-BackColor="SpringGreen" ItemStyle-Font-Bold="true"/>






                                            </Columns>
                                            <PagerStyle HorizontalAlign="Left" CssClass="GridPager" />
                                        </asp:GridView> 

                                    </div>





                          <%--      </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnExportToExcel" />
                                </Triggers>
                            </asp:UpdatePanel>--%>


                              <script type="text/javascript">

                                     //<asp:ListItem Selected="True" Value="1">Doctor Wise</asp:ListItem>
                                     //                   <asp:ListItem Value="2">Product Brand Wise</asp:ListItem>
                                     //                   <asp:ListItem Value="3">Product Wise</asp:ListItem>
                                     //                       <asp:ListItem Value="4">User Wise</asp:ListItem>
                                  function exporttocsv() {
                                      
                                      var checked_radio = $("[id*=rbReportTypeName] input:checked");
                                      var value = checked_radio.val();
                                      var txt = "";
                                      if (value == "1") {
                                          txt = "Doctor Wise ";
                                      }

                                      if (value == "2") {
                                          txt = "Product Brand Wise ";
                                      }

                                      if (value == "3") {
                                          txt = "Product Wise ";
                                      }

                                      if (value == "4") {
                                          txt = "User Wise ";
                                      }
                                      $("#export").tableToCSV({
                                          filename:   'DWSP Report'
                                      });
                                  }
                              </script>

                                        <script>
                                            function exportToExcel() {

                                                var file = new Blob([$('#export').html()], { type: "application/vnd.ms-excel" });
                                                var url = URL.createObjectURL(file);
                                                var a = $("<a />", {
                                                    href: url,
                                                    download: "RX_Report.xls"
                                                }).appendTo("body").get(0).click();
                                                e.preventDefault();

                                            }

                                            function exportTableToExcel(tableID, filename) {
                                                var downloadLink;
                                                var dataType = 'application/vnd.ms-excel';
                                                var tableSelect = document.getElementById(tableID);
                                                var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

                                                // Specify file name
                                                filename = filename ? filename + '.xls' : 'excel_data.xls';

                                                // Create download link element
                                                downloadLink = document.createElement("a");

                                                document.body.appendChild(downloadLink);

                                                if (navigator.msSaveOrOpenBlob) {
                                                    var blob = new Blob(['\ufeff', tableHTML], {
                                                        type: dataType
                                                    });
                                                    navigator.msSaveOrOpenBlob(blob, filename);
                                                } else {
                                                    // Create a link to the file
                                                    downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

                                                    // Setting the file name
                                                    downloadLink.download = filename;

                                                    //triggering the function
                                                    downloadLink.click();
                                                }
                                            }

                                            function ExportToPdf() {


                                                //alert('PDF');

                                                //var doc = new jsPDF();

                                                var doc = new jsPDF('p', 'pt', 'letter');
                                                //pdf.addHTML($('#tableDetail')[0], function () {
                                                //    pdf.save('Test.pdf');
                                                //});

                                                //var HTMLElement = $("#tableDetail").html();
                                                var HTMLElement = document.querySelector("#html");

                                                doc.fromHTML(HTMLElement);
                                                ////doc.text("Hello world!", 10, 10);
                                                doc.save("a4.pdf");
                                                //var doc = new jsPDF('p', 'pt', 'letter');
                                                //var htmlstring = '';
                                                //var tempVarToCheckPageHeight = 0;
                                                //var pageHeight = 0;
                                                //pageHeight = doc.internal.pageSize.height;
                                                //specialElementHandlers = {

                                                //    '#bypassme': function (element, renderer) {

                                                //        return true;
                                                //    }
                                                //};
                                                //margins = {
                                                //    top: 150,
                                                //    bottom: 60,
                                                //    left: 40,
                                                //    right: 40,
                                                //    width: 600
                                                //};
                                                //var y = 20;
                                                //doc.setLineWidth(2);
                                                //doc.text(200, y = y + 30, "TOTAL MARKS OF STUDENTS");
                                                //doc.autoTable({
                                                //    html: '#tableDetail',
                                                //    startY: 70,
                                                //    theme: 'grid',
                                                //    columnStyles: {
                                                //        0: {
                                                //            cellWidth: 180,
                                                //        },
                                                //        1: {
                                                //            cellWidth: 180,
                                                //        },
                                                //        2: {
                                                //            cellWidth: 180,
                                                //        }
                                                //    },
                                                //    styles: {
                                                //        minCellHeight: 40
                                                //    }
                                                //})
                                                //doc.save('Marks_Of_Students.pdf');
                                            }
                                        </script>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>




    <%--    <script>
        function un(o) {
            return o != null ? o : '';
        }
      
                            $(function () {

                                $('.datepicker').pickadate({
                                    selectMonths: true,
                                    selectYears: true
                                })
                                GetUserRoleInfo(0);
                                GetEmpList(0);
                                GetApprovalStatusList("");
        GetAreaList();
                            });

                 function ResetClick() {
                     location.href = '../DoctorModule_UI/MileageClaim.aspx';

        }

        function GetEmpList(SetId) {
            _getEmployeeList_Active($('#EmployeeIdSelect'), 'EmpInfoId', 'EmpName', SetId);
        }

        function GetApprovalStatusList(id) {
            _getApprovalList_Active($('#ApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', id);
        }
        function GetAreaList() {


            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var formatted = d.getFullYear() + '/' +
                (('' + month).length < 2 ? '0' : '') + month + '/' +
                (('' + day).length < 2 ? '0' : '') + day;


            var param = " and  mas.MileageClaimId IS NOT NULL";

                                if ($('#FromDate').val() != "" && $('#ToDate').val() != "") {
                                    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + $('#ToDate').val() + "' ";
                                }
                                if ($('#FromDate').val() != "" && $('#ToDate').val() == "") {
                                    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
                                }

                                if ($('#ToDate').val() != "" && $('#FromDate').val() == "") {
                                    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + $('#FromDate').val() + "' AND '" + formatted + "' ";
                                }
            if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                                    param = param + " AND mas.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";


                                }

            if ($('#UserRoleSelect').val() != "" && $('#UserRoleSelect').val() != null && $('#UserRoleSelect').val() != 0) {

                                    param = param + " AND us.UserRoleID='" + $('#UserRoleSelect').val() + "'";

                                }

            if ($('#EmployeeIdSelect').val() != "" && $('#EmployeeIdSelect').val() != null && $('#EmployeeIdSelect').val() != 0) {

                                    param = param + " AND mas.EmpInfoId='" + $('#EmployeeIdSelect').val() + "'";

                                }


            var urlpath = 'MileageClaimView.aspx/GetMileageClaimList';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'param': param }),
                contentType: "application/json; charset=utf-8",
                type: "POST",
                async: true,
                beforeSend: function () {
                    $("#coverScreen").show();

                },
                success: function (data) {
                    //console.log(data);
                   
                    var result = JSON.parse(data.d);
                    console.log(result);
                    var row = "";
                    $('#dtTableBody').html("");
                    for (var i = 0; i < result.length; i++) {
                        row += "<tr>";
                        row += "<td>" + (i + 1) + "</td>";
                        row += "<td>" + un(result[i].EmpMasterCode) + "</td>";
                        row += "<td>" + un(result[i].EmpName) + "</td>";
                        row += "<td>" + un(result[i].MileageDate)  + "</td>";
                        row += "<td>" + un(result[i].TransportName)  + "</td>";
                        row += "<td>" + un(result[i].MileageInKM) + "</td>";
                        row += "<td>" + un(result[i].Expense)  + "</td>";
                     
                        row += "<td>" + un(result[i].MeterReading)  + "</td>";
                        row += "<td>" + un(result[i].ApprovalStatus) + "</td>";
                        var im2 = "";
                        var img1 =  result[i].ImagePreName ;

                        const getBase64FromUrl = async (url) => {
                            const data = await fetch(url);
                            const blob = await data.blob();
                            return new Promise((resolve) => {
                                const reader = new FileReader();
                                reader.readAsDataURL(blob);
                                reader.onloadend = () => {
                                    const base64data = reader.result;
                                    resolve(base64data);

                                    
                                }
                            });
                        }
                      
                        getBase64FromUrl(img1);

                        row += "<td>" + '<a href="' + getBase64FromUrl(img1) + '"><img src="' + getBase64FromUrl(img1) + '"/></a>' + "</td>";




                        row += "<td><button class='btn-outline-warning  btn-xs mb-1 mb-md-0'  type='button'  onclick='editClick(" + result[i].MileageClaimId + ")'><i class='bx bxs-edit' aria-hidden='true'></i></button>   </td>";
                        row += "</tr>";

                    /*    <button class='btn-outline-danger    btn-xs mb-1 mb-md-0' onclick='DeleteClick(" + result[i].MileageClaimId + ")'><i class='fas fa-trash' aria-hidden='true'></i></button>*/


                    }

                    $('#dtTableBody').html(row);
                },
                complete: function() {

                    $("#coverScreen").hide();

                }
            });
    }

                            function editClick(id) {
                                location.href = '../DoctorModule_UI/MileageClaim.aspx?id=' + id + '';

                            }


                               function GetUserRoleInfo(id) {
                                   var urlpath = 'ExpenseClaimView.aspx/Get_UserRoleInfo';
            SelectOption_DtTable_Async_True(urlpath, $('#UserRoleSelect'), 'UserRoleID', 'RoleName', id);
             $('#UserRoleSelect').select2();
    }
    </script>--%>
</asp:Content>

