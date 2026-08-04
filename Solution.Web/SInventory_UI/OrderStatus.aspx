<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="OrderStatus.aspx.cs" Inherits="SInventory_UI_OrderStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style>
        
.title-widget {
	color: #898989;
	font-size: 20px;
	font-weight: 300;
	line-height: 1;
	position: relative;
	text-transform: uppercase;
	font-family: 'Fjalla One', sans-serif;
	margin-top: 0;
	margin-right: 0;
	margin-bottom: 25px;
	 
	padding-left: 12px;

}

.title-widget::before {
    background-color: #ea5644;
    content: "";
    height: 22px;
    left: 0px;
    position: absolute;
    top: -2px;
    width: 5px;
}

    </style>


       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Order Status </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="LinkButton1"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="LinkButton1_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">







             
                    


                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">



                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Order No:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                       <asp:TextBox ID="orderNoTextBox" runat="server" ReadOnly="true"  CssClass="form-control form-control-sm "></asp:TextBox>


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  


                  

                                </div>  
                                </div>  




                           <br />
                        <div class="row" runat="server" visible="false">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

 <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="searchButton_OnClick" style="background-color: #00bcd4;color: #fff;"
                           >   <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                            <asp:LinkButton ID="cancelButton"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                             
                      

                        <h2 class="blue title-widget" style="color:#2196F3; text-shadow:  0 0 2px black;">  Order Information</h2>
                            <hr/>

                                       

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Sales Center Code:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                          <asp:Label ID="salesCenterCodeTextBox" runat="server" Text=""></asp:Label>

                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  MIO Code:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                      <asp:Label ID="mioCodeTextBox" runat="server" Text=""></asp:Label>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Sales Center Name:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                        <asp:Label ID="salesCenterNameTextBox" runat="server" Text=""></asp:Label>

                                    </div>
                      
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  MIO Name:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                        <asp:Label ID="mioNameTextBox" runat="server" Text=""></asp:Label>

                                    </div>
                     
                                </div>  


                                </div>  
                            </div>  


                         <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Customer Code:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">

                                         <asp:Label ID="customerCodeTextBox" runat="server" Text=""></asp:Label>
                                       
                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Gross Value:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">

                                      <asp:Label ID="grossValueTextBox" runat="server" Text=""></asp:Label>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

                         <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Customer Name:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                         <asp:Label ID="CustomerNameTextBox" runat="server" Text=""></asp:Label>

                                    </div>
                      
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Create Information:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                         <asp:Label ID="submissionDateTextBox" runat="server" Text=""></asp:Label>

                                    </div>
                     
                                </div>  


                                </div>  
                            </div>  

                        <br />
                        <br />
                                 <h2 class="blue title-widget" style="color:#2196F3; text-shadow:  0 0 2px black;">  Order Details</h2>
                            <hr/>

                       <div class="row">
      <div class="table-responsive" id="MainGrassdeDiv">


                  <asp:GridView ID="loadGridView" runat="server" ShowFooter="True"  onrowdatabound="GridView1_RowDataBound" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" AutoGenerateColumns="False"
                                DataKeyNames="OrderDetailId">
                                <Columns>

                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                          <asp:BoundField DataField="TradePrice" HeaderText="TP" />
                                    <asp:BoundField DataField="TotalTradePrice" HeaderText="Total TP" />
                                               <asp:BoundField DataField="UnitVatAmount" HeaderText="Unit Vat" />
                                    <asp:BoundField DataField="TotalVatAmount" HeaderText="Total Vat" />
                                       <asp:BoundField DataField="DiscountPercent" HeaderText="Dis. Percent" />
                                     <asp:BoundField DataField="DiscountAmount" HeaderText="Dis. Amount" />
                                       <asp:BoundField DataField="NetAmount" HeaderText="Net Amount" />
                                                <asp:BoundField DataField="CampaignName2" HeaderText="Campaign Name" />
                                        <asp:BoundField DataField="ISGiftProduct" HeaderText="Gift/Bonus Product" />
                              
                                </Columns>
                            </asp:GridView>


          </div>
          </div>
                        <br />

                             <br />
                                 <h2 class="blue title-widget" style="color:#2196F3; text-shadow:  0 0 2px black;"> Invoice Information</h2>
                            <hr/>

                    <%--    Proforma--%>

                           <div class="row">
                      
                            <div class="col-md-12">
 
                                 <div class="form-group row">
                                        <asp:Label ID="proformaMessageLabel" runat="server" Text=""></asp:Label> &nbsp;
                                </div>  
                  
                            </div>  
                            </div>  

                                        <br />

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Invoice Number:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                          <asp:Label ID="invoiceNumberLabel" runat="server" Text=""></asp:Label>

                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Invoice Date:</label>

                                    <div class="col-sm-5"style="margin-top:6px;">
                                        <asp:Label ID="invoiceDateLabel" runat="server" Text=""></asp:Label>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  TP Total:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                               <asp:Label ID="tpTotalLabel" runat="server" Text=""></asp:Label>

                                    </div>
                      
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  TP Discount:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">

                                           <asp:Label ID="tpDiscountLabel" runat="server" Text=""></asp:Label>

                                    </div>
                     
                                </div>  


                                </div>  
                            </div>  

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> TP VAT:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                                <asp:Label ID="tpVatLabel" runat="server" Text=""></asp:Label>

                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  TP Grand Total:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                            <asp:Label ID="tpGrandTotalLabel" runat="server" Text=""></asp:Label>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

            
                                   <br />

                   

   <div class="row">
      <div class="table-responsive" id="MainGradeDsiv">

                <asp:GridView ID="proformaGridView" runat="server" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" AutoGenerateColumns="False"
                                DataKeyNames="InvoiceDetailId">
                                <Columns>
                                     <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                         
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="TotalPrice" HeaderText="Total Price" />
                                    <asp:BoundField DataField="TotalPriceVatAmount" HeaderText="Total Price Vat Amount" />
                                    <asp:BoundField DataField="DiscountPercentage" HeaderText="Discount Percentage" />
                                    <asp:BoundField DataField="NetAmount" HeaderText="Net Amount" />
                                </Columns>
                            </asp:GridView>


          </div>
          </div>
                        <br />

                       
                                 <h2 class="blue title-widget" style="color:#2196F3; text-shadow:  0 0 2px black;"> Delivery Information</h2>
                            <hr/>

                         <div class="row">
                      
                            <div class="col-md-12">
                                 

                                <asp:Label ID="deliveryInvoiceMsgLabel" ForeColor="red" runat="server" Text=""></asp:Label> &nbsp;

                                </div>  
                  
                            </div>  

                          <br />

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Delivery Invoice Number:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
     
                                         <asp:Label ID="deliveryInvoiceNumberLabel" runat="server" Text=""></asp:Label>

                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Delivery TP Total:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
     
                                         <asp:Label ID="deliveryTPTotalLabel" runat="server" Text=""></asp:Label>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Delivery TP Discount:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                              
                                                <asp:Label ID="deliveryTPDiscountLabel" runat="server" Text=""></asp:Label>

                                    </div>
                      
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Delivery TP VAT:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                    
                                                <asp:Label ID="deliveryTPVATLabel" runat="server" Text=""></asp:Label>

                                    </div>
                     
                                </div>  


                                </div>  
                            </div>  

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Delivery TP Grand Total:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                     
                                          <asp:Label ID="deliveryTPGrandTotalLabel" runat="server" Text=""></asp:Label>

                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Delivery Status:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                
                                          <asp:Label ID="deliveryStatusLabel" runat="server" Text=""></asp:Label>

                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

                        <br />






                           <div class="row">
      <div class="table-responsive" id="MainGradeDiv">

        
               <asp:GridView ID="deliveryGridView" runat="server" CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" AutoGenerateColumns="False"
                                DataKeyNames="InvoiceDetailId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="DeliveryTotalPrice" HeaderText="Total Price" />
                                    <asp:BoundField DataField="DeliveryTotalPriceVatAmount" HeaderText="Total Price Vat Amount" />
                                    <asp:BoundField DataField="DeliveryDiscountPercentage" HeaderText="Discount Percentage" />
                                    <asp:BoundField DataField="DeliveryNetAmount" HeaderText="Net Amount" />
                                </Columns>
                            </asp:GridView>


          </div>
          </div>

                       
                         <br />
                         <br />

                       
                                 <h2 class="blue title-widget" style="color:#2196F3; text-shadow:  0 0 2px black;"> Payment Status</h2>
                            <hr/>

                         <div class="row">
                      
                            <div class="col-md-12">

                                

                                <asp:Label ID="paymentMsgLabel" ForeColor="red" runat="server" Text=""></asp:Label>

                                </div>  
                  
                            </div>  

                          <br />

                          <div class="row">
                      
                            <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label"> Payment Amount:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                                <asp:Label ID="paymentAmountLabel" runat="server" Text=""></asp:Label>

                                    </div>
         
                                </div>  


                                </div>  

                               <div class="col-md-6">

                                 <div class="form-group row">
                                    <label for="mainName" class="col-sm-4 col-form-label">  Payment Status:</label>

                                    <div class="col-sm-5" style="margin-top:6px;">
                                        <asp:Label ID="paymentStatusLabel" runat="server" Text=""></asp:Label>


                                    </div>
                  
                                </div>  


                                </div>  
                            </div>  

                          <br/>


                              
                                </div>  
                                </div>  
                                </div>  
                
                                </div>  
                                </div>  

             </div>

            </ContentTemplate>
    </asp:UpdatePanel>


<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Order Status
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <td width="13%" class="TDLeft">
                            </td>
                            <td width="20%" class="TDRight">
                                &nbsp;
                            </td>
                            <td width="13%" class="TDLeft">
                                &nbsp;
                            </td>
                            <td width="20%" class="TDRight">
                                &nbsp;
                            </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style="text-align: right;" class="TDRight">
                            Order No: &nbsp;
                        </td>
                        <td width="13%"  class="TDLeft">
                             <asp:TextBox ID="orderNoTextBox" runat="server" CssClass="TextBox"></asp:TextBox>
                        </td>
                        <td width="20%" class="TDRight">        
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Button ID="searchButton" runat="server" OnClick="searchButton_OnClick" Text="Search" />
                        </td>
                        <td class="TDRight" width="20%">
                            
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            MIO Order:
                        </td>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Sales Center Code: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="salesCenterCodeTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            MIO Code: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="mioCodeTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Sales Center Name: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="salesCenterNameTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            MIO Name: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="mioNameTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                            Customer Code: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="customerCodeTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                            Gross Value: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="grossValueTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%"  class="TDRight">
                            Customer Name: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="CustomerNameTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="10%"  class="TDRight">
                            Submission Date:&nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="submissionDateTextBox" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="16%" class="TDLeft">
                        </td>
                        <td width="43%" class="TDRight"colspan="4">
                            <asp:GridView ID="loadGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                DataKeyNames="OrderDetailId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="TradePrice" HeaderText="Trade Price" />
                                    <asp:BoundField DataField="TotalTradePrice" HeaderText="Total Trade Price" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            Proforma Information:
                        </td>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" style="color: red; font-size: 14px;" width="13%">
                           <asp:Label ID="proformaMessageLabel" runat="server" Text=""></asp:Label> &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Invoice Number: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="invoiceNumberLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                           Invoice Date: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="invoiceDateLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            TP Total: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="tpTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            TP Discount: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="tpDiscountLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                            TP VAT: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="tpVatLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                            TP Grand Total: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="tpGrandTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                   
                    <tr>
                        <td width="16%" class="TDLeft">
                        </td>
                        <td width="43%" class="TDRight"colspan="4">
                            <asp:GridView ID="proformaGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                DataKeyNames="InvoiceDetailId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="TotalPrice" HeaderText="Total Price" />
                                    <asp:BoundField DataField="TotalPriceVatAmount" HeaderText="Total Price Vat Amount" />
                                    <asp:BoundField DataField="DiscountPercentage" HeaderText="Discount Percentage" />
                                    <asp:BoundField DataField="NetAmount" HeaderText="Net Amount" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            Delivery Information:
                        </td>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    
                     <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" style="color: red; font-size: 10px;" width="13%">
                           <asp:Label ID="deliveryInvoiceMsgLabel" ForeColor="red" runat="server" Text=""></asp:Label> &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Delivery Invoice Number: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryInvoiceNumberLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                           Delivery TP Total: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryTPTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%"  class="TDRight">
                            Delivery TP Discount: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryTPDiscountLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%"  class="TDRight">
                            Delivery TP VAT: &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Label ID="deliveryTPVATLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                           Delivery TP Grand Total: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="deliveryTPGrandTotalLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                           Delivery Status: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="deliveryStatusLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="16%" class="TDLeft">
                        </td>
                        <td width="43%" class="TDRight"colspan="4">
                            <asp:GridView ID="deliveryGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                DataKeyNames="InvoiceDetailId">
                                <Columns>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    <asp:BoundField DataField="DeliveryTotalPrice" HeaderText="Total Price" />
                                    <asp:BoundField DataField="DeliveryTotalPriceVatAmount" HeaderText="Total Price Vat Amount" />
                                    <asp:BoundField DataField="DeliveryDiscountPercentage" HeaderText="Discount Percentage" />
                                    <asp:BoundField DataField="DeliveryNetAmount" HeaderText="Net Amount" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" style=" font-size: 15px; font-weight: bold; " class="TDRight">
                            Payment Status:
                        </td>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" style="color: red; font-size: 10px;" width="13%">
                           <asp:Label ID="paymentMsgLabel" ForeColor="red" runat="server" Text=""></asp:Label> &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                        </td>
                        <td class="TDRight"  width="20%">
                           Payment Amount: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="paymentAmountLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight"  width="20%">
                           Payment Status: &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            <asp:Label ID="paymentStatusLabel" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="TDRight" width="20%">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    

                    
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>

                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
