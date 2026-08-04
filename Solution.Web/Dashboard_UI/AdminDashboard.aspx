<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="Dashboard_UI_AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<link href="../VerticalAsset/plugins/highcharts/css/highcharts.css" rel="stylesheet" />
 	<link href="../VerticalAsset/plugins/vectormap/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
    <div class="page-wrapper">


        <style>
  .view-more-link {
   color: #0dcaf0!important;
    text-decoration: underline;
  }
</style>
			<div class="page-content">

             <div class="dash-wrapper bg-dark">
                 <div class="row row-cols-1 row-cols-md-2 row-cols-xl-4 row-cols-xxl-5">
                     

                     



                     <div class="col border-end border-light-2">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Order Count </p>  
							   <h3 class="mb-3 text-white"><label id="totalPayment" >0</label></h3>
							  <%-- <p class="font-13 text-white"><span class="text-success"><i class="lni lni-arrow-up"></i> 2.5%</span> vs last 7 days</p>--%>
							   <div id="chartOrderCount"></div>
                                 <p class="font-13 text-white"><span class="text-danger">Figure of last 7 days</span></p>
							</div>
						</div>
					</div>
					 <div class="col border-end border-light-2">
						 <div class="card bg-transparent shadow-none mb-0">
							 <div class="card-body text-center">
                                <p class="mb-1 text-white">Today's Order Amount<a href="../MasterSetup_UI/OrderTrackingListDBH.aspx" target="_blank" class="view-more-link">&#10132;More</a></p>  
								<h3 class="mb-3 text-white" ><label id="TotalOrder" >0</label></h3>
								<p class="font-13 text-white"  runat="server" visible="false"><span class="text-success"><i class="lni lni-arrow-up"></i><label id="TotalOrderPer" >0</label>%</span> vs last 7 days</p>
								<div id="TotalOrderchart"></div>
                                  <p class="font-13 text-white"><span class="text-primary">Figure of last 7 days</span></p>
							
							 </div>
						 </div>
					 </div>
					 <div class="col border-end border-light-2">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Invoice Amount</p>  
							   <h3 class="mb-3 text-white"><label id="TotalInvoice" >0</label></h3>
							 <%--  <p class="font-13 text-white"><span class="text-success"><i class="lni lni-arrow-up"></i><label id="TotalInvoicerPer" >0</label>% </span> last 7 days</p>--%>
							   <div id="chartInvoiceAmount"></div>
                                 <p class="font-13 text-white"><span class="text-info">Figure of last 7 days</span></p>
							
							</div>
						</div>
					</div>
					<div class="col border-end border-light-2">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Collection Amount<a href="../SInventory_UI/DHB_DeliveryPaymentReport.aspx" target="_blank" class="view-more-link">&#10132;More</a></p>  
							   <h3 class="mb-3 text-white"><label id="totalDelivery" >0</label></h3>
							  <%-- <p class="font-13 text-white"><span class="text-danger"><i class="lni lni-arrow-down"></i> 3.6%</span> vs last 7 days</p>--%>
							   <div id="chartDeliveryAmount"></div>
                                    <p class="font-13 text-white"><span class="text-warning">Figure of last 7 days</span></p>
							
							</div>
						</div>
					</div>

                     	<div class="col">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Rejection Amount</p>  
							   <h3 class="mb-3 text-white"><label id="TotalRejection" >0</label></h3>
							 <%--  <p class="font-13 text-white"><span class="text-danger"><i class="lni lni-arrow-down"></i> 5.2%</span> vs last 7 days</p>--%>
							   <div id="chartTotalRejection"></div>
                                 <p class="font-13 text-white"><span style="color:#F24FE8">Figure of last 7 days</span></p>
							
							</div>
						</div>
					</div>
					
				
				 </div><!--end row-->


                     <div class="row row-cols-1 row-cols-md-2 row-cols-xl-4 row-cols-xxl-5">
                     



                     <div class="col border-end border-light-2">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's DCR</p>  
							   <h4 class="mb-3 text-white"><label id="totalDCR" >0  </label> <label style="font-size:15px!important" id="TotalDcrType" >0 </label></h4>
							  <%-- <p class="font-13 text-white"><span class="text-success"><i class="lni lni-arrow-up"></i> 2.5%</span> vs last 7 days</p>--%>
							   <div id="chartDCR"></div>
                                 <p class="font-13 text-white"><span style="color:#FFFFFF">Figure of last 7 days</span></p>

							</div>
						</div>
					</div>
					 <div class="col border-end border-light-2">
						 <div class="card bg-transparent shadow-none mb-0">
							 <div class="card-body text-center">
                                <p class="mb-1 text-white">Today's RX</p>  
								<h4 class="mb-3 text-white" ><label id="TotalRX" >0</label> <label style="font-size:15px!important" id="TotalRXType" >0 </label></h4>
								<p class="font-13 text-white"  runat="server" visible="false"><span class="text-success"><i class="lni lni-arrow-up"></i><label id="TotalRXPer" >0</label>%</span> vs last 7 days</p>
								<div id="TotalRXchart"></div>
                                    <p class="font-13 text-white"><span style="color:#889DA8">Figure of last 7 days</span></p>

							 </div>
						 </div>
					 </div>
					 <div class="col border-end border-light-2">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Attendance </p>  
							   <h5 class="mb-3 text-white"><label id="TotalAttandence" >0</label></h5>
							 <%--  <p class="font-13 text-white"><span class="text-success"><i class="lni lni-arrow-up"></i><label id="TotalInvoicerPer" >0</label>% </span> last 7 days</p>--%>
							   <div id="chartAttandence"></div>
                                 <p class="font-13 text-white"><span style="color:#91C12F">Figure of last 7 days</span></p>

							</div>
						</div>
					</div>
					<div class="col border-end border-light-2">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Customer Coverage </p>  
							   <h3 class="mb-3 text-white"><label id="totalCustomerCoverage" >0</label></h3>
							  <%-- <p class="font-13 text-white"><span class="text-danger"><i class="lni lni-arrow-down"></i> 3.6%</span> vs last 7 days</p>--%>
							   <div id="chartCustomerCoverage"></div>
                                  <p class="font-13 text-white"><span style="color:#7CFC00">Figure of last 7 days</span></p>

							</div>
						</div>
					</div>

                     	<div class="col">
						<div class="card bg-transparent shadow-none mb-0">
							<div class="card-body text-center">
							   <p class="mb-1 text-white">Today's Leave</p>  
							   <h3 class="mb-3 text-white"><label id="TotalLeave" >0</label></h3>
							 <%--  <p class="font-13 text-white"><span class="text-danger"><i class="lni lni-arrow-down"></i> 5.2%</span> vs last 7 days</p>--%>
							   <div id="chartLeave"></div>
                                  <p class="font-13 text-white"><span style="color:#FF7F50">Figure of last 7 days</span></p>

							</div>
						</div>
					</div>
					
				
				 </div><!--end row-->
			 </div>

			  <div class="row row-cols-1 row-cols-xl-2">
				<div class="col d-flex">
					<div class="card radius-10 w-100">
						<div class="card-body">
							<div class="d-flex align-items-center">
								  <div class="col-md-4" >
									<h6 class="mb-0">Today's Order Amount</h6>
                                    
								</div>
                                   <div class="col-md-5" >
                                       </div>
								     <div class="col-md-3" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Zone" id="TodayOrderZone" name="TodayOrderCheck" required>
											<label class="form-check-label" for="TodayOrderZone">Zone Wise</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Depot"  id="TodayOrderDepot" name="TodayOrderCheck" required>
											<label class="form-check-label" for="TodayOrderDepot">Depot Wise</label>
											 
										</div>
										 	 

                                    </div>
							</div>
                            <br />
						   <figure class="highcharts-figure">
                        <div id="DeptoWiseOrder" style="width:100%!important"></div>

                    </figure>
						</div>
					</div>
				</div>
				<div class="col d-flex">
					<div class="card radius-10 w-100">
						<div class="card-body">
							<div class="d-flex align-items-center">
								 

                                <div class="col-md-4" >
									<h6 class="mb-0">Today's Invoice Amount</h6>
                                    
								</div>
                                   <div class="col-md-5" >
                                       </div>
								     <div class="col-md-3" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Zone" id="TodayInvoiceZone" name="TodayInvoiceCheck" required>
											<label class="form-check-label" for="TodayInvoiceZone">Zone Wise</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Depot"  id="TodayInvoiceDepot" name="TodayInvoiceCheck" required>
											<label class="form-check-label" for="TodayInvoiceDepot">Depot Wise</label>
											 
										</div>
										 	 

                                    </div>
							 
							</div>
                            <br />
						 <figure class="highcharts-figure">
                        <div id="DeptoWiseInvoice" style="width:100%!important"></div>

                    </figure>
						</div>
					</div>
				</div>
			  </div><!--end row-->

                <div class="row">
					<div class="col-xl-12 mx-auto">
                        <div class="card">
                            <div class="card-body">

                                <div class="row">

                                        
                                           <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Group</label>
										 
                                       
                                               <select id="GroupNameSelect" name="GroupNameSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
								 
                                    </div>

                                       <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Zone</label>
										 
                                       
                                               <select id="zoneSelect" name="zoneSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
								 
                                    </div>
                                    
                                        
                                     <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Area</label>
										 
                                       
                                                <select id="areaSelect" name="areaSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
								 
                                    </div>
                                       
                                       <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Territory</label>
										 
                                          <select id="territorySelect" name="territorySelect" class="form-select form-select-sm mb-3 mySelect2"></select>
								 
                                    </div>
                                         
                                    <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Sub-Territory</label>
										 
                                             <select id="SubTerritory" name="SubterritorySelect" class="form-select form-select-sm mb-3 mySelect2"></select>
								 
                                    </div>
                                          
                                       <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Market</label>
										 
                                             <select id="MarketSelect" name="MarketSelect" class="form-select form-select-sm mb-3 mySelect2"></select>
								 
                                    </div>

                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
						<div class="row">
					<div class="col-xl-12 mx-auto">

                             <div class="card">
                            <div class="card-body">

                                <div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Order Amount Report</h6>
								</div>
							 
							</div>
                            <br />
                                   <div class="row">

                                                 <div class="col-md-3">
                                        
                                             
										<label for="RxMonth"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="OrderMonth" name="RxMonth" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option  value="1">January</option>
                                            <option  value="2">February</option>
                                            <option value="3">March</option>
                                            <option     value="4" >April</option>
                                            <option   value="5">May</option>
                                            <option  value="6">June</option>
                                            <option value="7">July</option>
                                            <option   value="8">August</option>
                                            <option   value="9">September</option>
                                            <option  value="10">October</option>
                                            <option   value="11">November</option>
                                            <option      value="12">December</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2">

                                             
										<label for="RxYear"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="OrderYear" name="RxYear" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022">2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>
                                       
                                      <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Customer Type</label>
										 
                                            <select id="CustomerTypeSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>



                                        <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Zone" id="OrderZone" name="OrderCheck" required>
											<label class="form-check-label" for="OrderZone">Zone Wise</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Depot"  id="OrderDepot" name="OrderCheck" required>
											<label class="form-check-label" for="OrderDepot">Depot Wise</label>
											 
										</div>
										 	 

                                    </div>

                                    <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="orderfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3"  style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="ordertodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSaveorder" class="btn btn-success"  onclick="GetData(2)">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                           
                               



                                <div id="orderchart"></div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Sales Amount Report</h6>
								</div>
								   
							</div>
                                
                                <br />
                                <div class="row">

                                    	
                                 <div class="col-md-3">

                                      	<label for="SalesMonthNew"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="SalesMonthNew" name="SalesMonth_New" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option  value="">Select Month</option>
                                            <option    value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option    value="4" >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option    value="8">August</option>
                                            <option  value="9">September</option>
                                            <option   value="10">October</option>
                                            <option       value="11">November</option>
                                            <option      value="12">December</option>

                                        </select>
                                     </div>
                                        <div class="col-md-2">

                                             
										<label for="SalesYearNew"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="SalesYearNew" name="SalesYearNew" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>

                                     <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Customer Type</label>
										 
                                            <select id="SalesCustomerTypeSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>
                                       
                                    <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									 
                                        <input id="salesfromdate" onload="getDate()" class="form-control form-control-sm datepicker" /> 
								</div>
                                    </div>


                                      <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								   <input   id="salestodate" class="form-control form-control-sm datepickerEnd" /> 
								</div>
                                    </div>

                                      <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Invoice" id="SalesCheckInvoice" name="SalesdWiseCheck" required>
											<label class="form-check-label" for="SalesCheckInvoice">Invoice</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Payment"  id="SalesWiseCheckPayment" name="SalesdWiseCheck" required>
											<label class="form-check-label" for="SalesWiseCheckPayment">Payment</label>
											 
										</div>
										 	 

                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavesales" class="btn btn-success"   onclick="GetData(1)">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i> </button>
                                          </div>
                                </div>
                           
                                       
                                   

                                    
                                       
                                </div>
                           
                               

                                <div id="saleschart"></div>
                            </div>
                        </div>
                   
                        <div class="card" style="display:none">
                            <div class="card-body">



                                
                                   <div class="row">
                                    <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="returnfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="returntodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavereturn" class="btn btn-success"  onclick="GetData(3)">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                           
                                 



                                <div id="returnchart"></div>
                            </div>
                        </div>

                            <div class="card">
                            <div class="card-body">

                                <div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Brand Wise Sales Report</h6>
								</div>
							 
							</div>
                                <br />

                            
                                    <div class="row">

                                             <div class="col-md-3">
                                        
                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="brandMonthSelect" name="brandMonthSelect" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option    value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option     value="4"  >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option value="8">August</option>
                                            <option     value="9">September</option>
                                            <option    value="10">October</option>
                                            <option       value="11">November</option>
                                            <option      value="12">December</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="brandYear" name="FiscalYearSelect" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>

                                         <div class="col-md-3">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Brand</label>
										 
                                              <select id="brandNameSelect" name="brandNameSelect" multiple="multiple" autocomplete="off" class="form-select form-select-sm mb-3 multiple-select">
                                            

                                        </select>
                                    </div>
                                       
                                       <div class="col-md-1" >

                                             
								 



                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Invoice" id="BrandWiseCheckInvoice" name="BrandWiseCheck" required>
											<label class="form-check-label" for="BrandWiseCheckInvoice">Invoice</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Payment"  id="BrandWiseCheckPayment" name="BrandWiseCheck" required>
											<label class="form-check-label" for="BrandWiseCheckPayment">Payment</label>
											 
										</div>
										 	 

                                    </div>


                                         <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="DayWise" id="chkDayWsie" name="chkBrandDay" required>
											<label class="form-check-label" for="chkDayWsie">Day Wise</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="BrandWise"  id="chkBrandWise" name="chkBrandDay" required>
											<label class="form-check-label" for="chkBrandWise">Brand Wise</label>
											 
										</div>
										 	 
                                             	<div class="form-check">
											<input type="radio" class="form-check-input"   value="ProductWise"  id="chkProductWise" name="chkBrandDay" required>
											<label class="form-check-label" for="chkProductWise">Product Wise</label>
											 
										</div>
                                    </div>


                                    <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="brandwisefromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="brandwisetodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavebrandwise" class="btn btn-success"  onclick="LoadBrandWiseOrder()">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                                              
                               


                                <div id="brandwisechart"></div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-body">

                                 <div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Customer Coverage report</h6>
								</div>
								   
							</div>
                                
                                <br />
                                  <div class="row">


                                            <div class="col-md-3">

                                      	<label for="CovMonthNew"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="CovMonthNew" name="SalesMonth_New" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option    value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option     value="4"  >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option    value="8">August</option>
                                            <option      value="9">September</option>
                                            <option     value="10">October</option>
                                            <option       value="11">November</option>
                                            <option      value="12">December</option>

                                        </select>
                                     </div>
                                        <div class="col-md-2">

                                             
										<label for="SalesYearNew"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="CovYearNew" name="SalesYearNew" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>

                                     <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Customer Type</label>
										 
                                            <select id="CovCustomerTypeSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>
                                        <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Invoice" id="CovCheckInvoice" name="CovWiseCheck" required>
											<label class="form-check-label" for="CovCheckInvoice">Invoice</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Payment"  id="CovWiseCheckPayment" name="CovWiseCheck" required>
											<label class="form-check-label" for="CovWiseCheckPayment">Payment</label>
											 
										</div>
										 	 

                                    </div>
                                    <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="customerfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="customertodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavecustomer" class="btn btn-success"  onclick="GetData(4)">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                                      



                                <div id="customerchart"></div>
                            </div>
                        </div>


                       
                        <div class="card">
                            <div class="card-body">
 	<div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Doctor Call Report (DCR)</h6>
								</div>
							 
							</div>
                            <br />

                                <div class="row">


                                     <div class="col-md-3">
                                        
                                             
										<label for="RxMonth"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="VRMonth" name="RxMonth" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option   value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option     value="4"  >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option    value="8">August</option>
                                            <option      value="9">September</option>
                                            <option     value="10">October</option>
                                            <option       value="11">November</option>
                                            <option       value="12">December</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2">

                                             
										<label for="RxYear"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="VRYear" name="RxYear" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>
                                       
                                      <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Approval Status</label>
										 
                                            <select id="VRApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>

                                    
                                        

                                          <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="GMP" id="VRGMPCheck" name="VRCheck" required>
											<label class="form-check-label" for="VRGMPCheck">GMP</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="NONGMP"  id="VRNONGMPCheck" name="VRCheck" required>
											<label class="form-check-label" for="VRNONGMPCheck">Non-GMP</label>
											 
										</div>
										 	 

                                    </div>

                                     <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Day" id="VRDayWiseCheck" name="VRDayZoneCheck" required>
											<label class="form-check-label" for="VRDayWiseCheck">Day Wise</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Zone"  id="VRZoneWiseCheck" name="VRDayZoneCheck" required>
											<label class="form-check-label" for="VRZoneWiseCheck">Zone Wise</label>
											 
										</div>
										 	 

                                    </div>
                                    <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="gmpfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="gmptodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavegmp" class="btn btn-success"  onclick="LoadVRChart()">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                
                                                    

                                <div id="gmpchart"></div>
                            </div>
                        </div>
                        <div class="card" style="display:none">
                            <div class="card-body">


                                
                                <div class="row">
                                    <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="nongmpfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="nongmptodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavenongmp" class="btn btn-success"  onclick="GetData(6)">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                
                                 



                                <div id="nongmpchart"></div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-body">

                                	<div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Rx Report</h6>
								</div>
							 
							</div>
                            <br />
                                  <div class="row">

                                      <div class="col-md-3">
                                        
                                             
										<label for="RxMonth"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="RxMonth" name="RxMonth" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option    value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option     value="4"  >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option    value="8">August</option>
                                            <option      value="9">September</option>
                                            <option     value="10">October</option>
                                            <option       value="11">November</option>
                                            <option      value="12">December</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2">

                                             
										<label for="RxYear"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="RxYear" name="RxYear" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>
                                       
                                      <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Approval Status</label>
										 
                                            <select id="RxApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>

                                           <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="GMP" id="RXGMPCheck" name="RXCheck" required>
											<label class="form-check-label" for="RXGMPCheck">GMP</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="NONGMP"  id="RXNONGMPCheck" name="RXCheck" required>
											<label class="form-check-label" for="RXNONGMPCheck">Non-GMP</label>
											 
										</div>
										 	 

                                    </div>


                                         <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Day" id="RXDayWiseCheck" name="RXDayZoneCheck" required>
											<label class="form-check-label" for="RXDayWiseCheck">Day Wise</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="Zone"  id="RXZoneWiseCheck" name="RXDayZoneCheck" required>
											<label class="form-check-label" for="RXZoneWiseCheck">Zone Wise</label>
											 
										</div>
										 	 

                                    </div>
                                       
                                    <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="gmprxfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3" style="display:none">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="gmprxtodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavegmprx" class="btn btn-success"  onclick="LoadRXChart()">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                
                                                                

                                


                                <div id="gmprxchart"></div>
                            </div>
                        </div>
                        <div class="card" style="display:none">
                            <div class="card-body">
                                

                                       <div class="row">
                                    <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="nongmprxfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="nongmprxtodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1"  style="margin-top:20px;">
                                      <button type="button" id="btnSavenongmprx" class="btn btn-success"  onclick="GetData(8)">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                                      

                                <div id="nongmprxchart"></div>
                            </div>
                        </div>
                     
                        <div class="card">
                            <div class="card-body">

                                
                                <div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Attendance Report</h6>
								</div>
							 
							</div>
                                <br />

                                   <div class="row">
                                    <div class="col-md-3">
                                        
                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="AttMonth" name="MonthSelect" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option    value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option     value="4"  >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option    value="8">August</option>
                                            <option      value="9">September</option>
                                            <option     value="10">October</option>
                                            <option       value="11">November</option>
                                            <option       value="12">December</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="AttYear" name="FiscalYearSelect" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>

                                        <div class="col-md-1" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="AttIN" id="AttInCheck" name="AttCheck" required>
											<label class="form-check-label" for="AttInCheck">IN</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="AttOut"  id="AttOutCheck" name="AttCheck" required>
											<label class="form-check-label" for="AttOutCheck">OUT</label>
											 
										</div>
										 	 

                                    </div>
                                       
                                      <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Approval Status</label>
										 
                                            <select id="AttApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>
                                       
                                       <div class="col-md-1" style="margin-top:20px;">
                                      <button type="button" id="btnSaveatt" class="btn btn-success"  onclick="LoadAtt()">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>
                                    <div class="row"  style="display:none">
                                    <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="text" id="attfromdate" class="form-control form-control-sm datepicker" />  
								</div>
                                    </div>


                                      <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="text" id="atttodate" class="form-control form-control-sm datepickerEnd">
								</div>
                                    </div>
                                      <div class="col-md-1">
                                    
                                          </div>
                                </div>
                                                  
                                


                                                 

                                <div id="attchart"></div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-body">
                                  <div class="d-flex align-items-center">
								<div>
									<h6 class="mb-0">Expense Report</h6>
								</div>
							 
							</div>
                                <br />
                                <div class="row">
                                    <div class="col-md-3">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Month</label>
										 
                                              <select id="MonthSelect" name="MonthSelect" class="form-select form-select-sm mb-3 multiple-select"  multiple="multiple">
                                            <option value="">Select Month</option>
                                            <option    value="1">January</option>
                                            <option   value="2">February</option>
                                            <option    value="3">March</option>
                                            <option     value="4"  >April</option>
                                            <option   value="5">May</option>
                                            <option   value="6">June</option>
                                            <option   value="7">July</option>
                                            <option    value="8">August</option>
                                            <option      value="9">September</option>
                                            <option     value="10">October</option>
                                            <option       value="11">November</option>
                                            <option      value="12">December</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2">

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Year</label>
										 
                                              <select id="FiscalYearSelect" name="FiscalYearSelect" class="form-select form-select-sm mb-3 mySelect2">
                                            <option value="">Select Year</option>
                                            <option    value="2019">2019</option>
                                            <option value="2020">2020</option>
                                            <option value="2021">2021</option>
                                            <option value="2022"  >2022</option>
                                            <option value="2023"  >2023</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                                   <option value="2026">2026</option>
 <option value="2027">2027</option>
 <option value="2028">2028</option>
 <option value="2029">2029</option>
 <option value="2030">2030</option>

                                        </select>
                                    </div>

                                        <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Expense Type</label>
										 
                                            <select id="ExpenseTypeIdSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>

                                      <div class="col-md-2" >

                                             
										<label for="inputFirstName"  style="font-weight:bold"  class="form-label">Approval Status</label>
										 
                                            <select id="ApprovalStatusSelect" class="form-select form-select-sm mb-3 mySelect2"></select>

                                    </div>

                                       

                                      <div class="col-md-2" >

                                             
								 

                                           <div class="form-check">
											<input type="radio"   class="form-check-input" checked   value="Expense" id="ExpenseCheck" name="ExpenseDACheck" required>
											<label class="form-check-label" for="ExpenseCheck">Expense</label>
										</div>
										<div class="form-check">
											<input type="radio" class="form-check-input"   value="DA"  id="DACheck" name="ExpenseDACheck" required>
											<label class="form-check-label" for="DACheck">DA</label>
											 
										</div>
										 	 

                                    </div>

                                       <div class="col-md-1" style="margin-top:20px;">
                                      <button type="button" id="btnSavetotalexp" class="btn btn-success"  onclick="LoadExense()">
                                         <i class='fadeIn animated bx bx-search-alt me-0'></i>
                                        </button>
                                          </div>
                                </div>

                                
                                    <div class="row" style="display:none">
                                    <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >From Date:</span>
									<input type="date" id="totalexpfromdate" class="form-control form-control-sm" />  
								</div>
                                    </div>


                                      <div class="col-md-3">
                                         <div class="input-group mb-3"> <span class="input-group-text" >To Date:</span>
								     <input type="date" id="totalexptodate" class="form-control form-control-sm">
								</div>
                                    </div>

                                         
                                   
                                </div>
                                                  
                                
                                 



                                <div id="totalexpchart"></div>
                            </div>
                        </div>
						<%--<div class="card">
							<div class="card-body">
								<div id="chart12"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart13"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart14"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart15"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart1"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart2"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart3"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart4"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart5"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart6"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart7"></div>
							</div>
						</div>--%>
						
						<%--<div class="card">
							<div class="card-body">
								<div id="chart9"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart10"></div>
							</div>
						</div>
						<div class="card">
							<div class="card-body">
								<div id="chart11"></div>
							</div>
						</div>--%>
						
					</div>
				</div>
				</div>
			 
   
	<script src="../VerticalAsset/plugins/vectormap/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="../VerticalAsset/plugins/vectormap/jquery-jvectormap-world-mill-en.js"></script>
	<script src="../VerticalAsset/plugins/highcharts/js/highcharts.js"></script>
	<script src="../VerticalAsset/plugins/highcharts/js/exporting.js"></script>
	<script src="../VerticalAsset/plugins/highcharts/js/variable-pie.js"></script>
	<script src="../VerticalAsset/plugins/highcharts/js/export-data.js"></script>
	<script src="../VerticalAsset/plugins/highcharts/js/accessibility.js"></script>
	<script src="../VerticalAsset/plugins/apexcharts-bundle/js/apexcharts.min.js"></script>
    <script>
		new PerfectScrollbar('.dashboard-top-countries');
    </script>

		<script src="../VerticalAsset/js/index.js"></script>
	<!--app JS-->
 	<script>
         // Dashbaord date start

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
      
  // Dashbaord date end
         $(document).ready(function () {
             var currentMonth = new Date().getMonth() + 1; // Get current month (1-12)
             $('#SalesMonthNew').val(currentMonth).trigger('change');
             $('#OrderMonth').val(currentMonth).trigger('change');
             $('#brandMonthSelect').val(currentMonth).trigger('change');
             $('#CovMonthNew').val(currentMonth).trigger('change');
             $('#VRMonth').val(currentMonth).trigger('change');
             $('#RxMonth').val(currentMonth).trigger('change');
             $('#AttMonth').val(currentMonth).trigger('change');
             $('#MonthSelect').val(currentMonth).trigger('change');


             var currentYear = new Date().getFullYear(); // Get current year
             $('#OrderYear').val(currentYear).trigger('change');
             $('#SalesYearNew').val(currentYear).trigger('change');
             $('#brandYear').val(currentYear).trigger('change');
             $('#CovYearNew').val(currentYear).trigger('change');

             $('#RxYear').val(currentYear).trigger('change');
             $('#AttYear').val(currentYear).trigger('change');
             $('#FiscalYearSelect').val(currentYear).trigger('change');
             $('#VRYear').val(currentYear).trigger('change');
             

             //$('.datepicker').pickadate({
             //    selectMonths: true,
             //    selectYears: true,

             //});

             if ($('.datepicker').length) {
                 var date = new Date();
                 var today = new Date(date.getFullYear(), date.getMonth(), '01');
                 $('.datepicker').datepicker({
                     format: "dd-MM-yyyy",
                     todayHighlight: true,
                     autoclose: true
                 });
                 $('.datepicker').datepicker('setDate', today);
             }


             if ($('.datepickerEnd').length) {
                 var date = new Date();
                 var today = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                 $('.datepickerEnd').datepicker({
                     format: "dd-MM-yyyy",
                     todayHighlight: true,
                     autoclose: true
                 });
                 $('.datepickerEnd').datepicker('setDate', today);
             }

             
            
             // Staggering heavy AJAX calls to prevent browser freeze and connection bottlenecks on page load
             setTimeout(function () {
                 GetGroupAllInfo(0);
                 GetCustomerTypeAllInfo(1);
                 GetExpenseType(0);
                 GetBrandName(0);
                 GetApprovalList(2);
                 GetTotalData(1);
             }, 100);

             setTimeout(function () {
                 LoadTotalOrderchart();
                 LoadTotalInvoicechart();
                 LoadTotalOrderCountchart();
                 LoadTotalDelAmount();
                 LoadTotalRejectionAmount();
             }, 500);

             setTimeout(function () {
                 LoadDeptoWiseOrder("");
                 LoadDeptoWiseInvoice("");
             }, 1000);

             setTimeout(function () {
                 LoadDCR();
                 LoadRX();
                 LoadTotalAttandence();
             }, 1500);

             setTimeout(function () {
                 LoadTotalCustomerCoverage();
                 LoadTotalLeave();
                 LoadExense();
                 LoadBrandWiseOrder();
             }, 2000);

             var currd = CurrentDate();
            // GetDoctorType(1);
             //LoadAtt();
             //LoadRXChart();
             //LoadVRChart();


             //for (var i = 0; i < 4; i++) {
             //    GetData(i + 1);


             //}
         });


         function GetBrandName(id) {
             var urlpath = '../DoctorModule_UI/SeedData.aspx/GetBrandNameALL';
             Multiple_DisableOption(urlpath, $('#brandNameSelect'), 'ProductBrandId', 'ProductSQName', id);
         }
         function Multiple_DisableOption(urlpath, setControlId, bindId, bindName, setId) {
           
             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     var result = JSON.parse(data.d);
                     setControlId.empty();
                   
                    
                     for (var i = 0; i < result.length; i++) {
                          
                             setControlId.append($("<option ></option>").val(result[i][bindId]).html(result[i][bindName]));
                         
                     }
                 },
                 complete: function () {
                     if (setId == 0) {

                     } else {
                         let arr = setId.split(',');
                         setControlId.val(arr).change();
                     }

                     setControlId.select2();
                     setControlId.val(setId);
                 }
             });
         }

         function GetExpenseType(SetId) {

             _getExpenseType($('#ExpenseTypeIdSelect'), 'ExpenseTypeId', 'ExpenseTypeName', SetId);
         }
         function GetApprovalList(SetId) {

             _getApprovalList_Active($('#ApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', SetId);
             _getApprovalList_Active($('#AttApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', SetId);
             _getApprovalList_Active($('#RxApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', SetId);
             _getApprovalList_Active($('#VRApprovalStatusSelect'), 'SoftwareUseId', 'WebShow', SetId);
             
             
         }
         function GetGroupAllInfo(id) {
             _GetGroupInfo_All($('#GroupNameSelect'), 'GroupId', 'GroupName', id);

         }

         function GetCustomerTypeAllInfo(id) {
             _GetCustomerType_All($('#CustomerTypeSelect'), 'CustomerTypeId', 'CustomerType', id);
             _GetCustomerType_All($('#SalesCustomerTypeSelect'), 'CustomerTypeId', 'CustomerType', id);
             _GetCustomerType_All($('#CovCustomerTypeSelect'), 'CustomerTypeId', 'CustomerType', id);
             

         }

         $("#GroupNameSelect").on("change", function (e) {
             $('#zoneSelect').empty().append('<option  value=""></option>');
             $('#areaSelect').empty().append('<option  value=""></option>');
             $('#territorySelect').empty().append('<option  value=""></option>');
             $('#SubTerritory').empty().append('<option  value=""></option>');
            
             $('#MarketSelect').empty().append('<option  value=""></option>');
             var groupId = $("#GroupNameSelect").val();
             if (groupId > 0) {
              

                 GetZone_All(groupId, 0);
             }
         });


         $("#zoneSelect").on("change", function (e) {

             $('#areaSelect').empty().append('<option  value=""></option>');
             $('#territorySelect').empty().append('<option  value=""></option>');
             $('#SubTerritory').empty().append('<option  value=""></option>');
            
             $('#MarketSelect').empty().append('<option  value=""></option>');
             var zoneId = $("#zoneSelect").val();
             if (zoneId > 0) {
                 GetArea_All_ByZone(zoneId, 0);
             }
         });


         $("#areaSelect").on("change", function (e) {
             
             $('#territorySelect').empty().append('<option  value=""></option>');
             $('#SubTerritory').empty().append('<option  value=""></option>');
             
             $('#MarketSelect').empty().append('<option  value=""></option>');
             var id = $("#areaSelect").val();
             if (id > 0) {
                 GetTerritory_ByAreaId_All(id,0);

             }
         });
   
         $("#territorySelect").on("change", function (e) {
         
             $('#SubTerritory').empty().append('<option  value=""></option>');
          
             $('#MarketSelect').empty().append('<option  value=""></option>');
             var id = $("#territorySelect").val();
             if (id > 0) {
                 GetSubTerritory_ByTerritoryId_All(id,0);

             }
         });


         $("#SubTerritory").on("change", function (e) {
          
             $('#MarketSelect').empty().append('<option  value=""></option>');
             var id = $("#SubTerritory").val();
             if (id > 0) {
                 GetMarket_BySubTerritoryId_All(id, 0);

             }
         });

         function GetZone_All(id, SetId) {



             _getZone_ByGroupId_All_SetValue($('#zoneSelect'), 'RegionId', 'RegionName', id, SetId)
         }
         function GetArea_All_ByZone(id, SetId) {
             _getArea_ByZoneId_All($('#areaSelect'), 'AreaId', 'AreaName', id, SetId);
         }

         function GetTerritory_ByAreaId_All(id, SetId) {
             _getTerritory_ByAreaId_All($('#territorySelect'), 'TerritoryId', 'TerritoryName', id, SetId);
         }



         function GetSubTerritory_ByTerritoryId_All(id, SetId) {
             _GetSubTerritory_ByTerritoryId_All($('#SubTerritory'), 'SubTerritoryId', 'SubTerritoryName', id, SetId);
         }

         function GetMarket_BySubTerritoryId_All(id, SetId) {
             _GetMarket_BySubTerritoryId_All($('#MarketSelect'), 'MarketId', 'MarketName', id, SetId);
         }


         function LoadTotalOrderchart() {
             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartOrder';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }
                      
  // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#8833ff',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#8833ff"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#8833ff"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#TotalOrderchart"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }
         function LoadTotalDelAmount() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartDeliveryAmount';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#FFD045',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#FFD045"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#FFD045"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartDeliveryAmount"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }

         function LoadDCR() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartDCR';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#FFFFFF',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#FFFFFF"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#FFFFFF"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartDCR"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }

         function LoadRX() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartTotalRX';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#889DA8',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#889DA8"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#889DA8"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#TotalRXchart"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }


         function LoadTotalAttandence() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartTotalAttandence';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#91C12F',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#91C12F"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#91C12F"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartAttandence"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }


         function LoadTotalCustomerCoverage() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartCustomerCoverage';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#7CFC00',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#7CFC00"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#7CFC00"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartCustomerCoverage"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }

         function LoadTotalLeave() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartTotalLeave';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#FF7F50',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#FF7F50"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#FF7F50"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartLeave"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }


         function LoadTotalRejectionAmount() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartRejectionAmount';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#F24FE8',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#F24FE8"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: false,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#F24FE8"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartTotalRejection"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }

         function LoadTotalOrderCountchart() {
             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartOrderCount';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#F41127',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#F41127"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: true,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#F41127"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartOrderCount"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }


         function LoadTotalInvoicechart() {

             var param = "";



             var urlpath = 'AdminDashboard.aspx/Get_TopBarChartTotalInvoice';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         //var serie = new Array(Result[i].DayCount);
                         var serie = new Array(Result[i].DayName, Result[i].DayCount);
                         chdata.push(serie);
                     }

                     // alert(chdata);
                     var options = {
                         series: [{
                             name: 'last 7 days Order',
                             data: chdata
                         }],





                         chart: {

                             type: 'line',
                             height: 60,
                             toolbar: {
                                 show: false
                             },
                             zoom: {
                                 enabled: false
                             },
                             dropShadow: {
                                 enabled: false,
                                 top: 3,
                                 left: 14,
                                 blur: 4,
                                 opacity: 0.12,
                                 color: '#40E6D6',
                             },
                             sparkline: {
                                 enabled: true
                             }

                         },
                         markers: {
                             size: 0,
                             colors: ["#40E6D6"],
                             strokeColors: "#fff",
                             strokeWidth: 2,
                             hover: {
                                 size: 7,
                             }
                         },
                         plotOptions: {
                             bar: {
                                 horizontal: true,
                                 columnWidth: '45%',
                                 endingShape: 'rounded'
                             },
                         },

                         dataLabels: {
                             enabled: false
                         },
                         stroke: {
                             show: true,
                             width: 2.5,
                             curve: 'smooth'
                         },
                         colors: ["#40E6D6"],
                         xAxis: {
                             type: 'category'
                         },
                         fill: {
                             opacity: 1
                         },
                         tooltip: {
                             theme: 'dark',
                             fixed: {
                                 enabled: false
                             },
                             x: {
                                 show: false
                             },
                             y: {
                                 title: {
                                     formatter: function (seriesName) {
                                         return ''
                                     }
                                 }
                             },
                             marker: {
                                 show: false
                             }
                         }


                     };
                     var chart = new ApexCharts(document.querySelector("#chartInvoiceAmount"), options);
                     chart.render();


                 },
                 complete: function () {
                 }
             });
         }

 
         function LoadDeptoWiseInvoice(param) {
         



             var urlpath = 'AdminDashboard.aspx/Get_DeptoWiseInvoice';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].ComUnitName, Result[i].TotalInvoice);
                         chdata.push(serie);
                     }


                     GetDeptoWiseInvoice(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetDeptoWiseInvoice(chdata) {

             $('#DeptoWiseInvoice').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },
                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{
                   
                     name: 'Depot Wise Invoice',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the top
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }

         $('input:radio[name=TodayOrderCheck]').change(function () {
             var param = "";
             if (this.value == 'Depot') {

                 param = "Depot";
                 LoadDeptoWiseOrder(param);
             }
             else {
                 LoadDeptoWiseOrder(param);
             }
         });


         $('input:radio[name=TodayInvoiceCheck]').change(function () {
             var param = "";
             if (this.value == 'Depot') {

                 param = "Depot";
                 LoadDeptoWiseInvoice(param);
             }
             else {
                 LoadDeptoWiseInvoice(param);
             }
         });

         function LoadDeptoWiseOrder(param) {


           
              
 


             var urlpath = 'AdminDashboard.aspx/Get_DeptoWiseOrder';
            
             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].ComUnitName, Result[i].TotalOrder);
                         chdata.push(serie);
                     }


                     GetDeptoWiseOrder(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetDeptoWiseOrder(chdata) {

             $('#DeptoWiseOrder').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },
                 
                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{
                    
                     name: 'Zone Wise Order',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the top
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }

         function CurrentDate() {
             var d = new Date();

             var month = d.getMonth() + 1;
             var day = d.getDate();

             var output = d.getFullYear() + '-' +
                 (('' + month).length < 2 ? '0' : '') + month + '-' +
                 (('' + day).length < 2 ? '0' : '') + day;

             return output;
         }




         function LoadExense() {
             var param = "";


           

             
             var value = $('input[name="ExpenseDACheck"]:checked').val();

             if (value == 'Expense') {
                 fromdate = 'Expense';

                 if ($('#MonthSelect').val() != "" && $('#MonthSelect').val() != "0" && $('#MonthSelect').val() != null) {

                     param = param + " AND MONTH(mas.ExpenseDate) in (" + $('#MonthSelect').val() + ")";
                 }
                 if ($('#FiscalYearSelect').val() != "" && $('#FiscalYearSelect').val() != "0" && $('#FiscalYearSelect').val() != null) {

                     param = param + " AND  YEAR(mas.ExpenseDate)='" + $('#FiscalYearSelect').val() + "'";
                 }




                 if ($('#ExpenseTypeIdSelect').val() != "" && $('#ExpenseTypeIdSelect').val() != "0" && $('#ExpenseTypeIdSelect').val() != null) {

                     param = param + " AND mas.ExpenseTypeId='" + $('#ExpenseTypeIdSelect').val() + "'";
                 }

                 if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                     param = param + " AND mas.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";
                 }
             }
             else {
                 fromdate = 'DA';


                 if ($('#MonthSelect').val() != "" && $('#MonthSelect').val() != "0" && $('#MonthSelect').val() != null) {

                     param = param + " AND MONTH(mas.TadaDate) in (" + $('#MonthSelect').val() + ")";
                 }
                 if ($('#FiscalYearSelect').val() != "" && $('#FiscalYearSelect').val() != "0" && $('#FiscalYearSelect').val() != null) {

                     param = param + " AND  YEAR(mas.TadaDate)='" + $('#FiscalYearSelect').val() + "'";
                 }




                 //if ($('#ExpenseTypeIdSelect').val() != "" && $('#ExpenseTypeIdSelect').val() != "0" && $('#ExpenseTypeIdSelect').val() != null) {

                 //    param = param + " AND mas.ExpenseTypeId='" + $('#ExpenseTypeIdSelect').val() + "'";
                 //}

                 if ($('#ApprovalStatusSelect').val() != "" && $('#ApprovalStatusSelect').val() != null) {

                     param = param + " AND mas.ApprovalStatus='" + $('#ApprovalStatusSelect').val() + "'";
                 }

             }
              
             todate = $('#totalexptodate').val();
             var urlpath = 'AdminDashboard.aspx/GetExpanseClaimMonthlyChartDataDayWise';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'fromdt': fromdate, 'todt': todate, 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].Criteria, Result[i].Amount);
                         chdata.push(serie);
                     }


                     GetExpense(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetExpense(chdata) {

             $('#totalexpchart').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },

                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{

                     name: 'Monthyly Expense',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the topr
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }


         function LoadBrandWiseOrder() {
             var param = "";
             var Brand = "";


      var       fromdate = '';
             var todate = $('#brandwisetodate').val();

             var  BrandDay = $('input[name="chkBrandDay"]:checked').val();
             var value = $('input[name="BrandWiseCheck"]:checked').val();

             if (BrandDay == 'DayWise') {
                 Brand = 'DayWise';


             }
             if (BrandDay == 'BrandWise') {
                 Brand = 'BrandWise';

             }
             if (BrandDay == 'ProductWise') {
                 Brand = 'ProductWise';

             }
             if (value == 'Invoice') {
                 fromdate = 'Invoice';

                 if ($('#brandMonthSelect').val() != "" && $('#brandMonthSelect').val() != "0" && $('#brandMonthSelect').val() != null) {

                     param = param + " AND  MONTH(InvoiceDate) in (" + $('#brandMonthSelect').val() + ")";
                 }

                 if ($('#brandYear').val() != "" && $('#brandYear').val() != "0" && $('#brandYear').val() != null) {

                     param = param + " AND  YEAR(InvoiceDate)='" + $('#brandYear').val() + "'";
                 }


             }
             if (value == 'Payment') {
                 fromdate = 'Payment';


                 if ($('#brandMonthSelect').val() != "" && $('#brandMonthSelect').val() != "0" && $('#brandMonthSelect').val() != null) {

                     param = param + " AND  MONTH(tblInvoice.UpdateDate) in (" + $('#brandMonthSelect').val() + ")";
                 }

                 if ($('#brandYear').val() != "" && $('#brandYear').val() != "0" && $('#brandYear').val() != null) {

                     param = param + " AND  YEAR(tblInvoice.UpdateDate)='" + $('#brandYear').val() + "'";
                 }



             }
             if ($('#brandNameSelect').val() != "" && $('#brandNameSelect').val() != "0" && $('#brandNameSelect').val() != null) {

                 param = param + " AND probr.ProductBrandId in (" + $('#brandNameSelect').val() + ")";
             }

         
            


             if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

                 param = param + " AND tblOrder.GroupId=" + $('#GroupNameSelect').val() + "";
             }
             if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

                 param = param + " AND tblOrder.RegionId=" + $('#zoneSelect').val() + "";
             }


             if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

                 param = param + " AND tblOrder.AreaId=" + $('#areaSelect').val() + "";
             }
             if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

                 param = param + " AND tblOrder.TerritoryId=" + $('#territorySelect').val() + "";
             }


             if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

                 param = param + " AND tblOrder.SubterritoryId=" + $('#SubTerritory').val() + "";
             }
             if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

                 param = param + " AND tblOrder.MarketId=" + $('#MarketSelect').val() + "";
             }






             var urlpath = 'AdminDashboard.aspx/GetBrandWiseOrderReportDayWise';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'fromdt': fromdate, 'todt': todate, 'param': param, 'Brand': Brand }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].Criteria, Result[i].Amount);
                         chdata.push(serie);
                     }


                     GetBrandWiseOrder(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetBrandWiseOrder(chdata) {

             $('#brandwisechart').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },

                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{

                     name: 'Brand Wise Sales',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the top
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }
         function LoadAtt() {
             var param = "";



            
             var value = $('input[name="AttCheck"]:checked').val();


             if (value == 'AttIN') {
                 param = param + " AND mas.AttType=1 ";
             }
             if (value == 'AttOut') {
                 param = param + " AND mas.AttType=2";

             }

             if ($('#AttMonth').val() != "" && $('#AttMonth').val() != "0" && $('#AttMonth').val() != null) {

                 param = param + " AND MONTH(mas.AttendanceDate) in (" + $('#AttMonth').val() + ")";
             }
             if ($('#AttYear').val() != "" && $('#AttYear').val() != "0" && $('#AttYear').val() != null) {

                 param = param + " AND  YEAR(mas.AttendanceDate)='" + $('#AttYear').val() + "'";
             }

             
             if ($('#AttApprovalStatusSelect').val() != ""   && $('#AttApprovalStatusSelect').val() != null) {

                 param = param + " AND mas.ApprovalStatus='" + $('#AttApprovalStatusSelect').val() + "'";
             }


             


             var fromdate = $('#attfromdate').val();
             var todate = $('#atttodate').val();
             var urlpath = 'AdminDashboard.aspx/GetAttandenceMonthlyReport';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'fromdt': fromdate, 'todt': todate, 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].Criteria, Result[i].Amount);
                         chdata.push(serie);
                     }


                     GetAtt(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetAtt(chdata) {

             $('#attchart').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },

                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{

                     name: 'Monthly Attendance',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the top
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }


         function LoadRXChart() {
             var param = "";




          var    fromdate = "";
             var   todate = $('#gmprxtodate').val();



             var value = $('input[name="RXCheck"]:checked').val();
             var valueDay = $('input[name="RXDayZoneCheck"]:checked').val();



             if (valueDay == 'Day') {
                 fromdate = "Day";

             }
             if (valueDay == 'Zone') {
                 fromdate = "Zone";



             }

             if (value == 'GMP') {
                 param = param + " AND tblDoctorMaster.DoctorTypeId=2";

             }
             if (value == 'NONGMP') {
                 param = param + " AND tblDoctorMaster.DoctorTypeId=1";


             }



             if ($('#RxMonth').val() != "" && $('#RxMonth').val() != "0" && $('#RxMonth').val() != null) {

                 param = param + " AND  MONTH(PrescriptionDate) in (" + $('#RxMonth').val() + ")";
             }

             if ($('#RxYear').val() != "" && $('#RxYear').val() != "0" && $('#RxYear').val() != null) {

                 param = param + " AND  YEAR(PrescriptionDate)='" + $('#RxYear').val() + "'";
             }

             if ($('#RxApprovalStatusSelect').val() != ""  && $('#RxApprovalStatusSelect').val() != null) {

                 param = param + " AND  tbl_PrescriptionMaster.ApprovalStatus='" + $('#RxApprovalStatusSelect').val() + "'";
             }


 



             if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

                 param = param + " AND tbl_PrescriptionMaster.GroupId=" + $('#GroupNameSelect').val() + "";
             }
             if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

                 param = param + " AND tbl_PrescriptionMaster.RegionId=" + $('#zoneSelect').val() + "";
             }


             if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

                 param = param + " AND tbl_PrescriptionMaster.AreaId=" + $('#areaSelect').val() + "";
             }
             if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

                 param = param + " AND tbl_PrescriptionMaster.TerritoryId=" + $('#territorySelect').val() + "";
             }


             if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

                 param = param + " AND tbl_PrescriptionMaster.SubterritoryId=" + $('#SubTerritory').val() + "";
             }
             if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

                 param = param + " AND tbl_PrescriptionMaster.MarketId=" + $('#MarketSelect').val() + "";
             }


             

 
             var urlpath = 'AdminDashboard.aspx/GetGMPRXReportChartDataDayWise';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'fromdt': fromdate, 'todt': todate, 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].Criteria, Result[i].Amount);
                         chdata.push(serie);
                     }


                     GetRXChart(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetRXChart(chdata) {

             $('#gmprxchart').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },

                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{

                     name: 'RX Report',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the top
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }



         function LoadVRChart() {
             var param = "";




             var fromdate = $('#gmprxfromdate').val();
             var todate = $('#gmprxtodate').val();



             var value = $('input[name="VRCheck"]:checked').val();

             var valueDay = $('input[name="VRDayZoneCheck"]:checked').val();



             if (valueDay == 'Day') {
                 fromdate = "Day";

             }
             if (valueDay == 'Zone') {
                 fromdate = "Zone";
             }



             if (value == 'GMP') {
                 param = param + " AND tblDoctorMaster.DoctorTypeId=2";

             }
             if (value == 'NONGMP') {
                 param = param + " AND tblDoctorMaster.DoctorTypeId=1";


             }



             if ($('#VRMonth').val() != "" && $('#VRMonth').val() != "0" && $('#VRMonth').val() != null) {

                 param = param + " AND  MONTH(tbl_DCRInfo.DcrDate) in (" + $('#VRMonth').val() + ")";
             }

             if ($('#VRYear').val() != "" && $('#VRYear').val() != "0" && $('#VRYear').val() != null) {

                 param = param + " AND  YEAR(tbl_DCRInfo.DcrDate)='" + $('#RxYear').val() + "'";
             }

             if ($('#VRApprovalStatusSelect').val() != ""  && $('#VRApprovalStatusSelect').val() != null) {

                 param = param + " AND  tbl_DCRInfo.ApprovalStatus='" + $('#RxApprovalStatusSelect').val() + "'";
             }




                 if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

                     param = param + " AND tbl_DCRInfo.GroupId=" + $('#GroupNameSelect').val() + "";
                 }
                 if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

                     param = param + " AND tbl_DCRInfo.RegionId=" + $('#zoneSelect').val() + "";
                 }


                 if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

                     param = param + " AND tbl_DCRInfo.AreaId=" + $('#areaSelect').val() + "";
                 }
                 if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

                     param = param + " AND tbl_DCRInfo.TerritoryId=" + $('#territorySelect').val() + "";
                 }


                 if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

                     param = param + " AND tbl_DCRInfo.SubterritoryId=" + $('#SubTerritory').val() + "";
                 }
                 if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

                     param = param + " AND tbl_DCRInfo.MarketId=" + $('#MarketSelect').val() + "";
                 }


             

             var urlpath = 'AdminDashboard.aspx/GetGMPVisitReportChartDataDayWise';

             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'fromdt': fromdate, 'todt': todate, 'param': param }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;

                     var Result = JSON.parse(data);
                     var chdata = [];
                     for (var i in Result) {
                         var serie = new Array(Result[i].Criteria, Result[i].Amount);
                         chdata.push(serie);
                     }


                     GetVRChart(chdata);

                 },
                 complete: function () {
                 }
             });
         }

         function GetVRChart(chdata) {

             $('#gmpchart').highcharts({


                 chart: {

                     type: 'column'

                 }, credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     type: 'category',
                     labels: {
                         rotation: -45,
                         style: {
                             fontSize: '13px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: ''
                     }
                 },
                 legend: {
                     enabled: false
                 },
                 tooltip: {
                     pointFormat: '<b>{point.y} </b>'
                 },

                 plotOptions: {
                     series: {
                         colorByPoint: true
                     }
                 },
                 series: [{

                     name: 'Visit Report',
                     data: chdata,
                     dataLabels: {
                         enabled: true,
                         //rotation: -90,
                         color: '#000000',
                         align: 'center',
                         format: '{point.y}', // one decimal
                         y: 2, // 10 pixels down from the top
                         style: {
                             fontSize: '10px',
                             fontFamily: 'Verdana, sans-serif'
                         }
                     }
                 }]

             });
         }

         function GetTotalData(id) {

             var urlpath = 'AdminDashboard.aspx/GetTotalInfoByCurrentDate';
             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'id': id }),
                 type: "POST", contentType: "application/json; charset=utf-8",
                 async: true,
                 success: function (data) {
                     data = data.d;
                    

                    
                
                     $("#TotalOrder").html(data.TotalOrder );
                     $("#TotalInvoice").html(data.totalInvoice );
                     $("#totalDelivery").html(data.totalDelivery );
                     $("#totalPayment").html(data.totalPayment);
                     $("#TotalRejection").html(data.TotalRejection);
                     $("#TotalOrderPer").html(data.TotalOrderPer);
                     $("#TotalInvoicerPer").html(data.TotalInvoicerPer);


                     $("#totalDCR").html(data.TotalDcr);
                     $("#TotalDcrType").html(data.TotalDcrType);
                     $("#TotalRX").html(data.TotalRX);
                     $("#TotalRXType").html(data.TotalRXType);
                     $("#totalCustomerCoverage").html(data.totalCustomerCoverage);
                     $("#TotalAttandence").html(data.TotalAttandence);
                     $("#TotalLeave").html(data.TotalLeave);

                     
                 },
                 complete: function () {
                 }
             });
         }

         function GetData(type) {
             var param = "";
             var fromdate = "";
             var todate = "";
             var SSMonthNew = '';
             var SSYearNew = '';
             var urlpath = '';
             if (type == '1') {
                 var value = $('input[name="SalesdWiseCheck"]:checked').val();



                 if (value == 'Invoice') {
                     fromdate = 'Invoice';
                 }
                 if (value == 'Payment') {
                     fromdate = 'Payment';

                 }


                 todate = $('#SalesCustomerTypeSelect').val();


                  
               
                 SSMonthNew = SSMonthNew + $('#SalesMonthNew').val()   ;
                 SSYearNew = SSYearNew + $('#SalesYearNew').val()  ;
                 
                 if ($('#SalesCustomerTypeSelect').val() != "" && $('#SalesCustomerTypeSelect').val() != "0" && $('#SalesCustomerTypeSelect').val() != null) {

                     param = param + " AND tblOrder.CustTypeId=" + $('#SalesCustomerTypeSelect').val() + "";
                 }

                 
                 if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {
                      
                     param = param + " AND tblOrder.GroupId=" + $('#GroupNameSelect').val() + "";
                 }
                 if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {
                      
                     param = param + " AND tblOrder.RegionId=" + $('#zoneSelect').val() + "";
                 }


                 if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

                     param = param + " AND tblOrder.AreaId=" + $('#areaSelect').val() + "";
                 }
                 if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

                     param = param + " AND tblOrder.TerritoryId=" + $('#territorySelect').val() + "";
                 }


                 if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

                     param = param + " AND tblOrder.SubterritoryId=" + $('#SubTerritory').val() + "";
                 }
                 if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

                     param = param + " AND tblOrder.MarketId=" + $('#MarketSelect').val() + "";
                 }


             

                  
                 urlpath = 'AdminDashboard.aspx/GetSalesChartData';
             }
             if (type == '2') {
                 

                 
                   // fromdate = $('#CustomerTypeSelect').val() + ':' + $('#OrderMonth').val() + ':' + $('#OrderYear').val();
 

                 fromdate = $('#CustomerTypeSelect').val();
                
                 var value = $('input[name="OrderCheck"]:checked').val();



                 if (value == 'Zone') {
                     todate = 'Zone';
                 }
                 if (value == 'Depot') {
                     todate = 'Depot';

                 }



                 SSMonthNew = SSMonthNew + $('#OrderMonth').val();
                 SSYearNew = SSYearNew + $('#OrderYear').val();




                 if ($('#CustomerTypeSelect').val() != "" && $('#CustomerTypeSelect').val() != "0" && $('#CustomerTypeSelect').val() != null) {

                     param = param + " AND tblOrder.CustTypeId=" + $('#CustomerTypeSelect').val() + "";
                 }

                

                 if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

                     param = param + " AND tblOrder.GroupId=" + $('#GroupNameSelect').val() + "";
                 }
                 if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

                     param = param + " AND tblOrder.RegionId=" + $('#zoneSelect').val() + "";
                 }


                 if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

                     param = param + " AND tblOrder.AreaId=" + $('#areaSelect').val() + "";
                 }
                 if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

                     param = param + " AND tblOrder.TerritoryId=" + $('#territorySelect').val() + "";
                 }


                 if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

                     param = param + " AND tblOrder.SubterritoryId=" + $('#SubTerritory').val() + "";
                 }
                 if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

                     param = param + " AND tblOrder.MarketId=" + $('#MarketSelect').val() + "";
                 }

                 urlpath = 'AdminDashboard.aspx/GetOrderChartData';
             }
             //if (type == '3') {
             //    fromdate = $('#returnfromdate').val();
             //    todate = $('#returntodate').val();


             //    if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

             //        param = param + " AND tblOrder.GroupId='" + $('#GroupNameSelect').val() + "'";
             //    }
             //    if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

             //        param = param + " AND tblOrder.RegionId='" + $('#zoneSelect').val() + "'";
             //    }


             //    if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

             //        param = param + " AND tblOrder.AreaId='" + $('#areaSelect').val() + "'";
             //    }
             //    if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

             //        param = param + " AND tblOrder.TerritoryId='" + $('#territorySelect').val() + "'";
             //    }


             //    if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

             //        param = param + " AND tblOrder.SubterritoryId='" + $('#SubTerritory').val() + "'";
             //    }
             //    if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

             //        param = param + " AND tblOrder.MarketId='" + $('#MarketSelect').val() + "'";
             //    }

             //    urlpath = 'AdminDashboard.aspx/GetSalesRetrunChartData';
             //}
             if (type == '4') {
                 
                 var value = $('input[name="CovWiseCheck"]:checked').val();



                 if (value == 'Invoice') {
                     todate = 'Invoice';
                 }
                 if (value == 'Payment') {
                     todate = 'Payment';



                 }



                 fromdate = $('#CovCustomerTypeSelect').val();
 



                 SSMonthNew = SSMonthNew + $('#CovMonthNew').val();
                 SSYearNew = SSYearNew + $('#CovYearNew').val();

                 if ($('#CovCustomerTypeSelect').val() != "" && $('#CovCustomerTypeSelect').val() != "0" && $('#CovCustomerTypeSelect').val() != null) {

                     param = param + " AND tblOrder.CustTypeId=" + $('#CovCustomerTypeSelect').val() + "";
                 }

                
                 if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

                     param = param + " AND tblOrder.GroupId=" + $('#GroupNameSelect').val() + "";
                 }
                 if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

                     param = param + " AND tblOrder.RegionId=" + $('#zoneSelect').val() + "";
                 }


                 if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

                     param = param + " AND tblOrder.AreaId=" + $('#areaSelect').val() + "";
                 }
                 if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

                     param = param + " AND tblOrder.TerritoryId=" + $('#territorySelect').val() + "";
                 }


                 if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

                     param = param + " AND tblOrder.SubterritoryId=" + $('#SubTerritory').val() + "";
                 }
                 if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

                     param = param + " AND tblOrder.MarketId=" + $('#MarketSelect').val() + "";
                 }

                 


                 urlpath = 'AdminDashboard.aspx/GetCustomerReportChartData';
             }
             //if (type == '5') {
             //    fromdate = $('#gmpfromdate').val();
             //    todate = $('#gmptodate').val();



             //    if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

             //        param = param + " AND tbl_DCRInfo.GroupId=" + $('#GroupNameSelect').val() + "";
             //    }
             //    if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

             //        param = param + " AND tbl_DCRInfo.RegionId=" + $('#zoneSelect').val() + "";
             //    }


             //    if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

             //        param = param + " AND tbl_DCRInfo.AreaId=" + $('#areaSelect').val() + "";
             //    }
             //    if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

             //        param = param + " AND tbl_DCRInfo.TerritoryId=" + $('#territorySelect').val() + "";
             //    }


             //    if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

             //        param = param + " AND tbl_DCRInfo.SubterritoryId=" + $('#SubTerritory').val() + "";
             //    }
             //    if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

             //        param = param + " AND tbl_DCRInfo.MarketId=" + $('#MarketSelect').val() + "";
             //    }


                
             //    urlpath = 'AdminDashboard.aspx/GetGMPVisitReportChartData';
             //}
             //if (type == '6') {
             //    fromdate = $('#nongmpfromdate').val();
             //    todate = $('#nongmptodate').val();
             //    urlpath = 'AdminDashboard.aspx/GetNONGMPVisitReportChartData';
             //}
             //if (type == '7') {
             //    fromdate = $('#gmprxfromdate').val();
             //    todate = $('#gmprxtodate').val();



             //    var value = $('input[name="RXCheck"]:checked').val();

                 

             //    if (value == 'GMP') {
             //        param = param + " AND tblDoctorMaster.DoctorTypeId=2";

             //    }
             //    if (value == 'NONGMP') {
             //        param = param + " AND tblDoctorMaster.DoctorTypeId=1";


             //    }
                 


             //    if ($('#RxMonth').val() != "" && $('#RxMonth').val() != "0" && $('#RxMonth').val() != null) {

             //        param = param + " AND  MONTH(PrescriptionDate) in (" + $('#RxMonth').val() + ")";
             //    }

             //    if ($('#RxYear').val() != "" && $('#RxYear').val() != "0" && $('#RxYear').val() != null) {

             //        param = param + " AND  YEAR(PrescriptionDate)='" + $('#RxYear').val() + "'";
             //    }

             //    if ($('#RxApprovalStatusSelect').val() != "" && $('#RxApprovalStatusSelect').val() != "0" && $('#RxApprovalStatusSelect').val() != null) {

             //        param = param + " AND  ApprovalStatus='" + $('#RxApprovalStatusSelect').val() + "'";
             //    }



             //    if ($('#GroupNameSelect').val() != "" && $('#GroupNameSelect').val() != "0" && $('#GroupNameSelect').val() != null) {

             //        param = param + " AND tbl_PrescriptionMaster.GroupId=" + $('#GroupNameSelect').val() + "";
             //    }
             //    if ($('#zoneSelect').val() != "" && $('#zoneSelect').val() != "0" && $('#zoneSelect').val() != null) {

             //        param = param + " AND tbl_PrescriptionMaster.RegionId=" + $('#zoneSelect').val() + "";
             //    }


             //    if ($('#areaSelect').val() != "" && $('#areaSelect').val() != "0" && $('#areaSelect').val() != null) {

             //        param = param + " AND tbl_PrescriptionMaster.AreaId=" + $('#areaSelect').val() + "";
             //    }
             //    if ($('#territorySelect').val() != "" && $('#territorySelect').val() != "0" && $('#territorySelect').val() != null) {

             //        param = param + " AND tbl_PrescriptionMaster.TerritoryId=" + $('#territorySelect').val() + "";
             //    }

                 


             //    if ($('#SubTerritory').val() != "" && $('#SubTerritory').val() != "0" && $('#SubTerritory').val() != null) {

             //        param = param + " AND tbl_PrescriptionMaster.SubterritoryId=" + $('#SubTerritory').val() + "";
             //    }
             //    if ($('#MarketSelect').val() != "" && $('#MarketSelect').val() != "0" && $('#MarketSelect').val() != null) {

             //        param = param + " AND tbl_PrescriptionMaster.MarketId=" + $('#MarketSelect').val() + "";
             //    }

             //    urlpath = 'AdminDashboard.aspx/GetGMPRXReportChartDataDayWise';
             //}
             //if (type == '8') {
             //    fromdate = $('#nongmprxfromdate').val();
             //    todate = $('#nongmprxtodate').val();
                
             //    urlpath = 'AdminDashboard.aspx/GetNONGMPRXReportChartData';
             //}
             //if (type == '9') {
             //    fromdate = $('#brandwisefromdate').val();
             //    todate = $('#brandwisetodate').val();
             //    urlpath = 'AdminDashboard.aspx/GetSalesChartData';
             //}
             //if (type == '10') {
             //    fromdate = $('#attfromdate').val();
             //    todate = $('#atttodate').val();
             //    urlpath = 'AdminDashboard.aspx/GetSalesChartData';
             //}
             //if (type == '11') {

             //    if ($('#MonthSelect').val() != "" && $('#MonthSelect').val() != "0" && $('#MonthSelect').val() != null) {

             //        param = param + " AND MONTH(mas.ExpenseDate)='" + $('#MonthSelect').val() + "'";
             //    }
             //    if ($('#FiscalYearSelect').val() != "" && $('#FiscalYearSelect').val() != "0" && $('#FiscalYearSelect').val() != null) {

             //        param = param + " AND  YEAR(mas.ExpenseDate)='" + $('#FiscalYearSelect').val() + "'";
             //    }

                 
             //    //if ($('#ExpenseTypeIdSelect').val() != "" && $('#ExpenseTypeIdSelect').val() != "0" && $('#ExpenseTypeIdSelect').val() != null) {

             //    //    param = param + " AND tblOrder.AreaId='" + $('#ExpenseTypeIdSelect').val() + "'";
             //    //}
             //    fromdate = $('#totalexpfromdate').val();
             //    todate = $('#totalexptodate').val();
             //    urlpath = 'AdminDashboard.aspx/GetExpanseClaimMonthlyChartData';
             //}

             
             //urlpath = 'Chart.aspx/GetSalesChartData';
             $.ajax({
                 url: urlpath,
                 dataType: 'json',
                 data: JSON.stringify({ 'fromdt': fromdate, 'todt': todate, 'param': param, 'SSMonthNew': SSMonthNew, 'SSYearNew': SSYearNew  }),
                 contentType: "application/json; charset=utf-8",
                 type: "POST",
                 async: true,
                 beforeSend: function () {

                 },
                 success: function (data) {
                     //console.log(data);
                      
                     var colname = [];
                     var rowname = [];
                     var xaxis = [];
                     var yaxis = [];

                     var result = JSON.parse(data.d);
                     var newData = result[0];
                     var status = false;
                     for (i = 0; i < result.length; i++) {
                         for (var key in result[i]) {
                             var ydata = {};
                             if (key == "Criteria") {
                                 xaxis.push(result[i][key]);
                             } else {
                                 if (status == true) {
                                     for (var ykeys in yaxis) {
                                         if (yaxis[ykeys]["name"] == key) {
                                             yaxis[ykeys]["data"].push(parseFloat(result[i][key]));
                                         }
                                     }
                                 } else {
                                     ydata["name"] = key;
                                     ydata["data"] = [];
                                     ydata["data"].push(parseFloat(result[i][key]));
                                     yaxis.push(ydata);
                                     if (key == "Total") {
                                         status = true;
                                     }
                                 }

                             }

                         }
                     }

                     if (type == '1') {
                         SalesChartAdd(xaxis, yaxis);
                     }
                     if (type == '2') {
                         OrderChartAdd(xaxis, yaxis);
                     }
                     if (type == '3') {
                         ReturnChartAdd(xaxis, yaxis);
                     }
                     if (type == '4') {
                         CustomerChartAdd(xaxis, yaxis);
                     }
                     //if (type == '5') {
                     //    GMPChartAdd(xaxis, yaxis);
                     //}
                     if (type == '6') {
                         NongmpChartAdd(xaxis, yaxis);
                     }
                     //if (type == '7') {
                     //    GMPRxChartAdd(xaxis, yaxis);
                     //}
                     if (type == '8') {
                         NongmprxChartAdd(xaxis, yaxis);
                     }
                     //if (type == '9') {
                     //    BrandChartAdd(xaxis, yaxis);
                     //}
                     //if (type == '10') {
                     //    AttChartAdd(xaxis, yaxis);
                     //}
                     //if (type == '11') {
                     //    TotalExpChartAdd(xaxis, yaxis);
                     //}













                 },
                 complete: function () {



                 }
             });

         }

         function SalesChartAdd(xax, yax) {
              
             Highcharts.chart('saleschart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Figure of TP'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                    
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function OrderChartAdd(xax, yax) {
              
             Highcharts.chart('orderchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: ''
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Figure of TP'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f}  </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function ReturnChartAdd(xax, yax) {
              
             Highcharts.chart('returnchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: 'Return Report'
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Figure of TP'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         

         function CustomerChartAdd(xax, yax) {
              
             Highcharts.chart('customerchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: ' '
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Figure of TP'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function GMPChartAdd(xax, yax) {
              
             Highcharts.chart('gmpchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: ' '
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Amount'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function NongmpChartAdd(xax, yax) {
              
             Highcharts.chart('nongmpchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: 'Non-GMP Visit Report'
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Amount'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function GMPRxChartAdd(xax, yax) {
              
             Highcharts.chart('gmprxchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: ' '
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Figure of Quantity'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function NongmprxChartAdd(xax, yax) {
              
             Highcharts.chart('nongmprxchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: 'Non-GMP Rx Report'
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Amount'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function BrandChartAdd(xax, yax) {
              
             Highcharts.chart('brandwisechart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: 'Brand Wise Sales Report'
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Amount'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }
         function AttChartAdd(xax, yax) {
              
             Highcharts.chart('attchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: 'Attendance Report'
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Amount'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }

         function TotalExpChartAdd(xax, yax) {
              
             Highcharts.chart('totalexpchart', {
                 chart: {
                     type: 'column',
                     styledMode: true
                 },
                 credits: {
                     enabled: false
                 },
                 title: {
                     text: 'Total Expense Claim Report'
                 },
                 subtitle: {
                     text: ''
                 },
                 xAxis: {
                     //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                     categories: xax,
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'Amount'
                     }
                 },
                 tooltip: {
                     headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: yax
                 //[{
                 //    name: 'Tokyo',
                 //    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
                 //}, {
                 //    name: 'New York',
                 //    data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
                 //}, {
                 //    name: 'London',
                 //    data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]
                 //}, {
                 //    name: 'Berlin',
                 //    data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]
                 //}]
             });
         }










     </script>
</asp:Content>

