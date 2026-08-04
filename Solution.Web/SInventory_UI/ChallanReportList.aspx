<%@ Page Title="" Language="C#" EnableEventValidation="false" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ChallanReportList.aspx.cs" Inherits="SInventory_UI_ChallanReportList" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Challan Report </div>

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


                



                    <div class="card-body">
                        
       
                        <div class="row">&nbsp;</div>

                                      

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
 
                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  National Report :</label>


                                    <script type="text/javascript">
                                              function pageLoad() {
                                                  $('.datepicker').pickadate({
                                                      selectMonths: true,
                                                      selectYears: true
                                                  })
                                                  $('.mySelect2').select2({
                                                      theme: 'bootstrap4',
                                                      width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                      placeholder: $(this).data('placeholder'),
                                                      allowClear: Boolean($(this).data('allow-clear')),
                                                  });
                                              }
                                             </script>
                                    <div class="col-sm-5">
                                    
                                        <div class="form-check form-check-inline">   



                                     <asp:CheckBox ID="CheckBox1" runat="server" 
                                        oncheckedchanged="CheckBox1_CheckedChanged" AutoPostBack="True" />
                                                                 
                                    </div>
                                                </div>
                                    
                                </div>  

                               <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Sales Center :</label>

                                    <div class="col-sm-5">
                                    
                                          

                                   <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                         CssClass="form-select form-select-sm mb-3 mySelect2" >
                                      </asp:DropDownList>
                                                                 
                                    </div>

                                 
                                </div>  

                               <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Challan From Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="dateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker" ></asp:TextBox>
                         <%--   <asp:CalendarExtender ID="manufacturerDate1"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="dateTextBox"
                                TargetControlID="dateTextBox">
                            </asp:CalendarExtender>--%>
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                 
                      
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Challan To Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control form-control-sm  datepicker" ></asp:TextBox>
                     
                           
                                    
                                    </div>
                                 
                                </div>   
                                                 
                                </div>  
                                </div>  
                           <br />
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                  <asp:LinkButton ID="detailsButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="detailsButton_Click" style="background-color: #00bcd4;color: #fff;">    Details Report</asp:LinkButton>
                                  <asp:LinkButton ID="summaryButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="summaryButton_Click" style="background-color: #00bcd4;color: #fff;">    Summary Report</asp:LinkButton>
                                 <asp:LinkButton ID="searchButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="searchButton_Click" style="background-color: #00bcd4;color: #fff;">  View List</asp:LinkButton>

<%--                                 <asp:LinkButton ID="LinkButton1"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                 ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>--%>




                                             
                        </td>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">

              

                             <asp:LinkButton ID="excelButton1"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="btnExportToExcel_Click"
                                 > Export to Excel </asp:LinkButton>

                            </div>
                        </div>                 
                        <br/>
       <div class="row">
           <div class="table-responsive" id="MainGradeDiv">                      
                        


                  <asp:GridView ID="reportListGridView" runat="server"  CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                AutoGenerateColumns="False" DataKeyNames="ReqId">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C.Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C.Name" />
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req.No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="Req.Date" />
                                    <asp:BoundField DataField="IssueChalanNo" HeaderText="DeliveryClnNo" />
                                    <asp:BoundField DataField="IssuChalanDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="DeliveryClnDate" />
                                 
                                    <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate>
                                            <asp:Button ID="printButton" runat="server" Font-Bold="False" CssClass="btn btn-success"
                                                Font-Italic="False" Text="PRINT" onclick="printButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                               <asp:GridView ID="summaryGridView" runat="server"  CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                AutoGenerateColumns="False" >
                                <Columns>
                                      <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                      <asp:BoundField DataField="TotalQuantity" HeaderText="Total Quantity" />
                                    
                                      <asp:BoundField DataField="TotalPriceAmount" HeaderText="Total Price Amount" />
                                    
                                      <asp:BoundField DataField="TotalVATAmount" HeaderText="Total VAT Amount" />
                                    <asp:BoundField DataField="TotalPriceAmountwithVat" HeaderText="Total Amount with Vat" />
                                 
                                </Columns>
                            </asp:GridView>
                               <asp:GridView ID="detailsGridView" runat="server"  CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender"
                                AutoGenerateColumns="False" >
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C.Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C.Name" />
                                    
                                    
                                      <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                      <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    
                                    
                                      <asp:BoundField DataField="TotalQuantity" HeaderText="Total Quantity" />
                                    <asp:BoundField DataField="UnitPrice" HeaderText="TP Price" />
                                    
                                    
                                    
                                      <asp:BoundField DataField="TotalPriceAmount" HeaderText="Total Price Amount" />
                                    <asp:BoundField DataField="VATAmountPerUnit" HeaderText="VAT Amount Per Unit" />
                                    

                                    
                                      <asp:BoundField DataField="TotalVATAmount" HeaderText="Total VAT Amount" />
                                    <asp:BoundField DataField="TotalPriceAmountwithVat" HeaderText="Total Amount with Vat" />
                                    
                                    
<%--
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req.No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="Req.Date" />--%>
                                    <asp:BoundField DataField="IssueChalanNo" HeaderText="DeliveryClnNo" />
                                    <asp:BoundField DataField="SubmitDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="DeliveryClnDate" />
                                 
                             <%--       <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate>
                                            <asp:Button ID="printButton" runat="server" Font-Bold="False" 
                                                Font-Italic="False" Text="PRINT" onclick="printButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>
          </div>
       </div>
                    
                     
                                </div>  
                                </div>  
                                </div>  
                                </div>  
            
                                </div>  
                                </div>  
                 </div> 
           </ContentTemplate>
                    <Triggers>
              <asp:PostBackTrigger ControlID="excelButton1" />
                 
               </Triggers>
    </asp:UpdatePanel>

<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Challan Report 
                        </td>
                    </tr>
                       <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                             	National Report :
                        </td>
                        <td width="20%" class="TDRight">
                       
                       
                            <asp:CheckBox ID="CheckBox1" runat="server" 
                                oncheckedchanged="CheckBox1_CheckedChanged" AutoPostBack="True" />

                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                         <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                            Sales Center
                        </td>
                        <td width="20%" class="TDRight">
                         <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="DropDown" >
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                           Challan From Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="dateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="dateTextBox"
                                PopupButtonID="imgDate">
                            </asp:CalendarExtender>
                        </td>
                        <td width="13%" class="TDLeft">
                           
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                      <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                           Challan to Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate2"></asp:ImageButton>
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="TextBox1"
                                PopupButtonID="imgDate2">
                            </asp:CalendarExtender>
                        </td>
                       
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                     <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                       <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                    
                                </td>
                        <td width="13%" class="TDLeft">
                            
                      </td>
                        <td width="20%" class="TDRight">
                              <asp:Button ID="detailsButton" runat="server" Text="Details Report" 
                                       BackColor="#52be80"  onclick="detailsButton_Click" />
                              <asp:Button ID="summaryButton" runat="server" Text="Summary Report" 
                             BackColor="#0b5345"    onclick="summaryButton_Click" />&nbsp;
                            <asp:Button ID="searchButton" runat="server" Text="View List" 
                                onclick="searchButton_Click" />
                        </td>
                        <td width="13%" class="TDLeft">
                             
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft">
                             <asp:Button ID="excelButton1" runat="server" Text="Export to Excel" OnClick="btnExportToExcel_Click" />
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight" colspan="4">
                            <div id="divForGrid" width="auto" hight="100px" overflow="auto">
                            <asp:GridView ID="reportListGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" DataKeyNames="ReqId">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C.Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C.Name" />
                                    <asp:BoundField DataField="ReqNo" HeaderText="Req.No" />
                                    <asp:BoundField DataField="ReqDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="Req.Date" />
                                    <asp:BoundField DataField="IssueChalanNo" HeaderText="DeliveryClnNo" />
                                    <asp:BoundField DataField="IssuChalanDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="DeliveryClnDate" />
                                 
                                    <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate>
                                            <asp:Button ID="printButton" runat="server" Font-Bold="False" 
                                                Font-Italic="False" Text="PRINT" onclick="printButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                               <asp:GridView ID="summaryGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" >
                                <Columns>
                                      <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                      <asp:BoundField DataField="TotalQuantity" HeaderText="Total Quantity" />
                                    
                                      <asp:BoundField DataField="TotalPriceAmount" HeaderText="Total Price Amount" />
                                    
                                      <asp:BoundField DataField="TotalVATAmount" HeaderText="Total VAT Amount" />
                                    <asp:BoundField DataField="TotalPriceAmountwithVat" HeaderText="Total Amount with Vat" />
                                 
                                </Columns>
                            </asp:GridView>
                               <asp:GridView ID="detailsGridView" runat="server" CssClass="gridview" 
                                AutoGenerateColumns="False" >
                                <Columns>
                                    <asp:BoundField DataField="ComUnitCode" HeaderText="D.C.Code" />
                                    <asp:BoundField DataField="ComUnitName" HeaderText="D.C.Name" />
                                    
                                    
                                      <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                    
                                      <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No" />
                                    
                                    
                                      <asp:BoundField DataField="TotalQuantity" HeaderText="Total Quantity" />
                                    <asp:BoundField DataField="UnitPrice" HeaderText="TP Price" />
                                    
                                    
                                    
                                      <asp:BoundField DataField="TotalPriceAmount" HeaderText="Total Price Amount" />
                                    <asp:BoundField DataField="VATAmountPerUnit" HeaderText="VAT Amount Per Unit" />
                                    

                                    
                                      <asp:BoundField DataField="TotalVATAmount" HeaderText="Total VAT Amount" />
                                    <asp:BoundField DataField="TotalPriceAmountwithVat" HeaderText="Total Amount with Vat" />
                                    
                                    

                                    <asp:BoundField DataField="IssueChalanNo" HeaderText="DeliveryClnNo" />
                                    <asp:BoundField DataField="SubmitDate" DataFormatString="{0:dd/MM/yyyy}" 
                                        HeaderText="DeliveryClnDate" />
                                 
                         
                                </Columns>
                            </asp:GridView>
                            </div>
                        </td>
                       
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
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
                            &nbsp;
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
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" class="TDLeft" >
                            &nbsp;
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
                </table>
            </div>
        </ContentTemplate>
         <Triggers>
              <asp:PostBackTrigger ControlID="excelButton1" />
                 
               </Triggers>
    </asp:UpdatePanel>--%>
</asp:Content>
