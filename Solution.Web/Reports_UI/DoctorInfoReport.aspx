<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DoctorInfoReport.aspx.cs" Inherits="Reports_UI_DoctorInfoReport" %>


<%@ Register Src="~/Reports_UI/IVMasterStructureForDoctorReport.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../VerticalAsset/jquery.tabletoCSV.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    
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

             .alert {
    position: relative!important;
    padding: 0.2rem 0.2rem!important;
    margin-bottom: 1rem!important;
    border: 1px solid transparent!important;
    border-radius: 0.25rem!important;
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>SMC Family Doctor Report</div>

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
                                    <div class="row">
                                        
                                        <div class="col-2">
                                         
                                            <div class="form-group row">


                                                    <div class="col-sm-10" >
                                                   
                                                        <div class="Label_Title  ">Report Type </div>
                                                            
                                                                <div class="form-group">
                                                        
                                                    <asp:RadioButtonList runat="server" ID="rbReportTypeName" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rbReportTypeName_SelectedIndexChanged"   RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                                                     <%--   <asp:ListItem Value="1">User Wise</asp:ListItem>--%>

                                                        <asp:ListItem Value="1">Summary</asp:ListItem>
                                                        <asp:ListItem Value="2">Details</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                     </div>
                                                     
                                                    

                                                </div>

                                            </div>
                         
                                        </div>
                                        

                                          <div class="col-3" runat="server" Visible="False" ID="OtherReport">
                                              <div class="form-group row">
                                                  <div class="col-sm-8 " >
                                                      <div class="Label_Title  "> Report Category </div>
                                                      <div class="form-group">
                                                          <asp:RadioButtonList runat="server" ID="rdoAnotherReport" CssClass="radioChoice2" AutoPostBack="True" OnSelectedIndexChanged="rdoAnotherReport_OnSelectedIndexChanged"   RepeatDirection="Horizontal" RepeatColumns="1" RepeatLayout="Flow">
                                                     <%--   <asp:ListItem Value="1">User Wise</asp:ListItem>--%>

                                                        <asp:ListItem Value="Zone">Zone Wise</asp:ListItem>
                                                        <asp:ListItem Value="Area">Area Wise</asp:ListItem>
                                                        <asp:ListItem Value="MIO">MIO Wise</asp:ListItem>
                                                        <asp:ListItem Value="Doctor">Doctor Wise</asp:ListItem>
                                                              <%--<asp:ListItem Value="Provider">Provider Wise</asp:ListItem>--%>
                                                    </asp:RadioButtonList>
                                                     </div>
                                                  </div>
                                              </div>
                                          </div>
                                        

                                        <div class="col-3">
                                            <div class="form-group row">
                                                <label for="txtFromDate" class="col-sm-6 col-form-label">From Date:  </label>
                                                <div class="col-sm-6">
                                                    <asp:TextBox ID="txtFromDate" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="From Date" ></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label for="txtTodate" class="col-sm-6 col-form-label">To Date:  </label>
                                                 <div class="col-sm-6">
                                                    <asp:TextBox ID="txtTodate" runat="server" class="form-control form-control-sm mb-3 datepicker" autocomplete="off" placeholder="To Date" ></asp:TextBox>
                                                </div>
                                             </div>
                                        </div>
                                        
                                        
                                        <div class="col-4" runat="server" Visible="False" ID="MarketSt">
                                            
                                            <div class="Label_Title  "> Additional Filter </div>
                                            <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />




                                            <asp:Panel class="form-group row" style="margin-top:6px;"   visible="false" id="divCChk" runat="server">
                                   

                                   <div class="row">
                                        <label for="AreaSelect" class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-6">

                                         <div class="input-group">
                                           
                                               
                                                 <div class="form-check form-switch" style="padding-left: 35px !important;">
													<input class="form-check-input" runat="server" type="checkbox" id="chkDownload"  >
													 <label  class="custom-control-label" for="chkIsActive">Is only download</label>
												</div>      
                                                       
                                                    </div>
                                    </div>
                                   </div>

   <div class="row"> 
                                                  <div class="col-sm-12">

                                         <div class="input-group">
                                         <span class="alert alert-info"> Last Process Date: <asp:Label runat="server" ID="lblInfo"></asp:Label></span>
                                               
                                                    </div>
                                    </div>
                                       </div>
                                </asp:Panel>
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

                                            <asp:LinkButton runat="server" ID="btnSearch" class="btn btnMyDesignSearch   btn-sm " OnClick="btnSearch_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>


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
                                            <asp:LinkButton ID="btnExportToExcel"  runat="server" CssClass="btn btn-success pull-right" OnClick="btnExportToExcel_Click"><span aria-hidden="true" class="fa fa-file-excel-o" ></span> &nbsp;Export To Excel</asp:LinkButton>

                                                       <%--      <button type="button"  class="btn btn-success pull-right"   onclick="exporttocsv()"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export to Excel </button>--%>


                                        </div>
                                    </div>
                                    <div id="export">
                                    <div style="padding-top: 10px;"></div>
                                    <div class="table-responsive" ID="PPOVIDERWISE" style="height:600px" runat="server" Visible="False">

                                      <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                           CssClass="table table-striped table-bordered"  OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="loadGridView_OnRowCreated" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                                <asp:BoundField DataField="TerritoryName" HeaderText="Territory" />
                                                <asp:BoundField DataField="MIO" HeaderText="MIO" />

                                                <asp:BoundField DataField="AssignBSP" HeaderText="BSP" />
                                                <asp:BoundField DataField="AssignGSP" HeaderText="GSP" />
                                                <asp:BoundField DataField="AssignPSP" HeaderText="PSP" />
                                                <asp:BoundField DataField="AssignGeneralSP" HeaderText="General" />
                                                <asp:BoundField DataField="AssignTotal" HeaderText="Total" />

                                                <asp:BoundField DataField="VisiBSP" HeaderText="BSP" />
                                                <asp:BoundField DataField="VisiGSP" HeaderText="GSP" />
                                                <asp:BoundField DataField="VisiPSP" HeaderText="PSP" />
                                                <asp:BoundField DataField="VisiGeneralSP" HeaderText="General" />
                                                <asp:BoundField DataField="Visitotal" HeaderText="Total" />
                                                
                                                <asp:BoundField DataField="repBSP" HeaderText="BSP" />
                                                <asp:BoundField DataField="repGSP" HeaderText="GSP" />
                                                <asp:BoundField DataField="repPSP" HeaderText="PSP" />
                                                <asp:BoundField DataField="repGeneralSP" HeaderText="General" />
                                                <asp:BoundField DataField="reptotal" HeaderText="Total" />
                                                
                                  
                                                <asp:BoundField DataField="prescBSP" HeaderText="BSP" />
                                                <asp:BoundField DataField="prescGSP" HeaderText="GSP" />
                                                <asp:BoundField DataField="prescPSP" HeaderText="PSP" />
                                                <asp:BoundField DataField="prescGeneralSP" HeaderText="General" />
                                                <asp:BoundField DataField="presctotal" HeaderText="Total" />
                                                


                                            </Columns>
                                        </asp:GridView> 

                                    </div>


                                    
                                
                                
                                  <div class="table-responsive" ID="MIOWISE" style="height:600px" runat="server"  Visible="False">
                                    
                                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                                           CssClass="table table-striped table-bordered"  OnPageIndexChanging="OnPageIndexChanging" ShowFooter="true" OnRowCreated="GridView1_OnRowCreated" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                    <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                                <asp:BoundField DataField="MIOCode" HeaderText="Territory" />
                                                <asp:BoundField DataField="MIOName" HeaderText="MIO" />

                                                <asp:BoundField DataField="AssignDocCount" HeaderText="Assign" />
                                                <asp:BoundField DataField="DCRDocCount" HeaderText="Coverage" />

                                                  <asp:BoundField DataField="DCPTotalCount" HeaderText="Total DCP" />


                                                <asp:BoundField DataField="RepatCount" HeaderText="Repeat" />
                                                <asp:BoundField DataField="NORXCount" HeaderText="No. of Prescriber" />

                                                <asp:BoundField DataField="RXCount" HeaderText="Prescription" />


                                                <asp:BoundField DataField="1WeekV" HeaderText="Coverage" />
                                                     <asp:BoundField DataField="1WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="1WeekR" HeaderText="Repeat" />
                                                  <asp:BoundField DataField="1WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="1WeekP" HeaderText="Prescription" />

                                               <asp:BoundField DataField="2WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="2WeekDCP" HeaderText="DCP" />

                                                <asp:BoundField DataField="2WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="2WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="2WeekP" HeaderText="Prescription" />

                                              <asp:BoundField DataField="3WeekV" HeaderText="Coverage" />

                                                   <asp:BoundField DataField="3WeekDCP" HeaderText="DCP" />

                                                <asp:BoundField DataField="3WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="3WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="3WeekP" HeaderText="Prescription" />

                                                <asp:BoundField DataField="4WeekV" HeaderText="Coverage" />

                                                 <asp:BoundField DataField="4WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="4WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="4WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="4WeekP" HeaderText="Prescription" />

                                            </Columns>
                                        </asp:GridView>




                                        <asp:GridView ID="gv_Zone" runat="server" AutoGenerateColumns="False"
                                           CssClass="table table-striped table-bordered"  OnPageIndexChanging="OnPageIndexChanging" ShowFooter="true" OnRowCreated="gv_Zone_OnRowCreated" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                               
                                                <asp:BoundField DataField="AssignDocCount" HeaderText="Assign" />
                                                <asp:BoundField DataField="DCRDocCount" HeaderText="Coverage" />

                                                      <asp:BoundField DataField="DCPTotalCount" HeaderText="Total DCP" />

                                                   <asp:BoundField DataField="DCRTotalCount" HeaderText="Total Visit" />
                                                <asp:BoundField DataField="RepatCount" HeaderText="Repeat" />
                                                <asp:BoundField DataField="NORXCount" HeaderText="No. of Prescriber" />

                                                <asp:BoundField DataField="RXCount" HeaderText="Prescription" />


                                                <asp:BoundField DataField="1WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="1WeekDCP" HeaderText="DCP" />

                                                <asp:BoundField DataField="1WeekR" HeaderText="Repeat" />
                                                  <asp:BoundField DataField="1WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="1WeekP" HeaderText="Prescription" />

                                                  
                                               <asp:BoundField DataField="2WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="2WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="2WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="2WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="2WeekP" HeaderText="Prescription" />


                                                    
                                              <asp:BoundField DataField="3WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="3WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="3WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="3WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="3WeekP" HeaderText="Prescription" />


                                                
                                                    
                                                <asp:BoundField DataField="4WeekV" HeaderText="Coverage" />

                                                 <asp:BoundField DataField="4WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="4WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="4WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="4WeekP" HeaderText="Prescription" />

                                            </Columns>
                                        </asp:GridView>


                                        <asp:GridView ID="gv_Area" runat="server" AutoGenerateColumns="False"
                                           CssClass="table table-striped table-bordered"  OnPageIndexChanging="OnPageIndexChanging" ShowFooter="true" OnRowCreated="gv_Area_OnRowCreated" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                               
                                              <asp:BoundField DataField="AssignDocCount" HeaderText="Assign" />
                                                <asp:BoundField DataField="DCRDocCount" HeaderText="Coverage" />

                                                      <asp:BoundField DataField="DCPTotalCount" HeaderText="Total DCP" />

                                                   <asp:BoundField DataField="DCRTotalCount" HeaderText="Total Visit" />
                                                <asp:BoundField DataField="RepatCount" HeaderText="Repeat" />
                                                <asp:BoundField DataField="NORXCount" HeaderText="No. of Prescriber" />

                                                <asp:BoundField DataField="RXCount" HeaderText="Prescription" />


                                                <asp:BoundField DataField="1WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="1WeekDCP" HeaderText="DCP" />

                                                <asp:BoundField DataField="1WeekR" HeaderText="Repeat" />
                                                  <asp:BoundField DataField="1WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="1WeekP" HeaderText="Prescription" />

                                                  
                                               <asp:BoundField DataField="2WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="2WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="2WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="2WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="2WeekP" HeaderText="Prescription" />


                                                    
                                              <asp:BoundField DataField="3WeekV" HeaderText="Coverage" />
                                                 <asp:BoundField DataField="3WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="3WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="3WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="3WeekP" HeaderText="Prescription" />


                                                
                                                    
                                                <asp:BoundField DataField="4WeekV" HeaderText="Coverage" />

                                                 <asp:BoundField DataField="4WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="4WeekR" HeaderText="Repeat" />
                                                 <asp:BoundField DataField="4WeekNP" HeaderText="No. of Prescriber" />
                                                <asp:BoundField DataField="4WeekP" HeaderText="Prescription" />

                                            </Columns>
                                        </asp:GridView>



                                 
                                  </div>
                                

                                    
                                
                                   <div class="table-responsive" runat="server"  ID="DocWise" style="height:600px" Visible="False">
                                       <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False"
                                           CssClass="table table-striped table-bordered"  ShowFooter="true" OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="GridView2_OnRowCreated" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                                <asp:BoundField DataField="MIOCode" HeaderText="Territery" />
                                                <asp:BoundField DataField="MIOName" HeaderText="MIO" />
                                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="Speciality" />
                                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider" />
                                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />

                                                 <asp:BoundField DataField="DCPTotalCount" HeaderText="DCP" />
                                                <asp:BoundField DataField="DCRDocCount" HeaderText="Total Visit" />
                                                <asp:BoundField DataField="RXCount" HeaderText="Prescription" />

                                                    <asp:BoundField DataField="1WeekDCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="1WeekV" HeaderText="Visit" />
                                             
                                                <asp:BoundField DataField="1WeekP" HeaderText="Prescription" />
                                                                                                 <asp:BoundField DataField="2WeekDCP" HeaderText="DCP" />
                                                   <asp:BoundField DataField="2WeekV" HeaderText="Visit" />

                                             
                                                <asp:BoundField DataField="2WeekP" HeaderText="Prescription" />


                                          
                                                <asp:BoundField DataField="3WeekDCP" HeaderText="DCP" />
                                                   <asp:BoundField DataField="3WeekV" HeaderText="Visit" />
                                                <asp:BoundField DataField="3WeekP" HeaderText="Prescription" />

                                                
                                                     <asp:BoundField DataField="4WeekDCP" HeaderText="DCP" />
                                                   <asp:BoundField DataField="4WeekV" HeaderText="Visit" />
                                                <asp:BoundField DataField="4WeekP" HeaderText="Prescription" />
                                               

                                            </Columns>
                                        </asp:GridView> 

                                    </div>
                                
                                
                                
                                
                                  <div class="table-responsive" runat="server"  ID="Details" style="height:600px" Visible="False">
                                       <asp:GridView ID="GridView3" ShowFooter="true" runat="server" AutoGenerateColumns="False"
                                           CssClass="table table-striped table-bordered"  OnPageIndexChanging="OnPageIndexChanging" OnRowCreated="GridView3_OnRowCreated" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="SL">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RegionName" HeaderText="Zone" />
                                                <asp:BoundField DataField="AreaName" HeaderText="Area" />
                                                <asp:BoundField DataField="MIOCode" HeaderText="Territery" />
                                                <asp:BoundField DataField="MIOName" HeaderText="MIO" />
                                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                                                <asp:BoundField DataField="ProgramTypeName" HeaderText="Provider" />
                                                <asp:BoundField DataField="DoctorTypeName" HeaderText="Doctor Type" />
                                                <asp:BoundField DataField="DegreeName" HeaderText="Degree" />
                                                <asp:BoundField DataField="DoctorSpeciality" HeaderText="speciality" />

                                                <asp:BoundField DataField="1_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="1_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="1_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="2_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="2_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="2_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="3_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="3_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="3_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="4_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="4_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="4_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="5_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="5_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="5_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="6_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="6_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="6_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="7_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="7_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="7_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="8_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="8_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="8_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="9_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="9_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="9_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="10_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="10_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="10_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="11_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="11_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="11_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="12_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="12_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="12_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="13_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="13_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="13_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="14_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="14_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="14_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="15_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="15_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="15_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="16_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="16_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="16_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="17_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="17_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="17_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="18_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="18_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="18_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="19_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="19_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="19_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="20_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="20_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="20_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="21_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="21_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="21_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="22_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="22_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="22_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="23_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="23_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="23_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="24_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="24_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="24_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="25_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="25_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="25_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="26_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="26_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="26_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="27_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="27_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="27_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="28_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="28_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="28_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="29_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="29_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="29_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="30_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="30_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="30_RX" HeaderText="RX" />

                                                <asp:BoundField DataField="31_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="31_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="31_RX" HeaderText="RX" />

                                               <asp:BoundField DataField="to_DCP" HeaderText="DCP" />
                                                <asp:BoundField DataField="to_DCR" HeaderText="DCR" />
                                                <asp:BoundField DataField="to_RX" HeaderText="RX" />

                                             
                                            </Columns>
                                        </asp:GridView> 

                                    </div>

                                        </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:PostBackTrigger ControlID="btnExportToExcel" />
                                </Triggers>
                            </asp:UpdatePanel>


                              <script type="text/javascript">

                                     //<asp:ListItem Selected="True" Value="1">Doctor Wise</asp:ListItem>
                                     //                   <asp:ListItem Value="2">Product Brand Wise</asp:ListItem>
                                     //                   <asp:ListItem Value="3">Product Wise</asp:ListItem>
                                     //                       <asp:ListItem Value="4">User Wise</asp:ListItem>
                                  function exporttocsv() {
                                      
                                      var checked_radio = $("[id*=rbReportTypeName] input:checked");
                                      var value = checked_radio.val();
                                      var txt = "";
                                      if (value == "2") {
                                          txt = "Detail of  ";
                                      }

                                      else {
                                          var checked_radio2 = $("[id*=rdoAnotherReport] input:checked");
                                          var value2 = checked_radio2.val();
                                          if (value2 == "1") {
                                              txt = "Zone Wise ";
                                          }

                                          if (value2 == "2") {
                                              txt = "Area Wise ";
                                          }

                                          if (value2 == "3") {
                                              txt = "MIO Wise ";
                                          }

                                          if (value2 == "3") {
                                              txt = "Doctor Wise ";
                                          }
                                      }
                                       
                                      $("#export").tableToCSV({
                                          filename: txt + ' SMC Family Doctor Report'
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

