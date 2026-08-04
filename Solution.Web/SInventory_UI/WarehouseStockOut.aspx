<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="WarehouseStockOut.aspx.cs" Inherits="SInventory_UI_WarehouseStockIn" %>

<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



     <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Warehouse Stock Out </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
 <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="LinkButton1_Click" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">



                    <div class="card-body">
               

<%--                         <br/>--%>
                        <asp:HiddenField ID="masterIdHiddenField" runat="server" />

                        <div class="row">
                              

                            <div class="col-md-4">
                                  
                            </div>


                            <div class="col-md-6">
                            
                               
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Manufacturer :</label>

                                    <div class="col-sm-5">
                                    
                                         
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

                            <asp:DropDownList ID="manufacturerDropDownList" CssClass="form-select form-select-sm mb-3 mySelect2" runat="server" >
                            </asp:DropDownList>


                                                                 
                                    </div>

                                 
                                </div>  
                               
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Stock In Date :</label>

                                    <div class="col-sm-5">
                                    
                                                                   
                            <asp:TextBox ID="stockInDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                            <%--<cc1:CalendarExtender ID="CalendarExtender1"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="stockInDateTextBox"
                                TargetControlID="stockInDateTextBox">
                            </cc1:CalendarExtender>--%>


                                                                 
                                    </div>

                                 
                                </div>  


                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Challan No :</label>

                                    <div class="col-sm-5">
                                    
                                          
                                    <asp:TextBox ID="challanNoTextBox" runat="server" CssClass="form-control form-control-sm" ></asp:TextBox>

                                                           
                                    </div>

                                 
                                </div>  
                                             

                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Challan Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="challanDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker" ></asp:TextBox>
                            <%--<cc1:CalendarExtender ID="CalendarExtender4"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="challanDateTextBox"
                                TargetControlID="challanDateTextBox">
                            </cc1:CalendarExtender>--%>

                                            
                                    </div>
                                 
                                </div>   
                 
                      
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Reference No :</label>

                                    <div class="col-sm-5">
                                     

                                     <asp:TextBox ID="referenceNoTextBox" runat="server" CssClass="form-control form-control-sm"  ></asp:TextBox>
                           
                           
                                    
                                    </div>
                                 
                                </div>   


                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Reference Date :</label>

                                    <div class="col-sm-5">
                                     

                         <asp:TextBox ID="referenceDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                          <%--  <cc1:CalendarExtender ID="CalendarExtender5"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="referenceDateTextBox"
                                TargetControlID="referenceDateTextBox">
                            </cc1:CalendarExtender>--%>

                                            
                                    </div>
                                 
                                </div>   
                 
                      
                           <div id="Div1" class="form-group row"  runat="server" Visible="False">
                                    <label for="" class="col-sm-3 col-form-label">  Remark :</label>

                                    <div class="col-sm-5">
                                     

                                     <asp:TextBox ID="remarksTextBox" runat="server" CssClass="form-control form-control-sm"  ></asp:TextBox>
                           
                           
                                    
                                    </div>
                                 
                                </div>   


                            <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  Reason :</label>

                                    <div class="col-sm-5">
                                     

                                     <asp:TextBox ID="reasonTextBox" runat="server" CssClass="form-control form-control-sm"  ></asp:TextBox>
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                                                 
                                </div>  



                            </div>  

                       <br />
                        
                      <div class="row">
           <div class="table-responsive" id="MainGradeDiv">                      
                                                 
                 <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender" DataKeyNames="WHStockInDetailID,ReceiveId">
                                <Columns>
                                    <asp:BoundField DataField="SL" HeaderText="SL" />
                                    <asp:TemplateField HeaderText="Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server"  CssClass="form-control form-control-sm"
                                                AutoPostBack="True" ToolTip="true" OnTextChanged="productCodeTextBox_TextChanged"
                                                Text='<%# Eval("ProductCode")%>'></asp:TextBox>
                                            <asp:HiddenField ID="productidHiddenField" Value='<%# Eval("ProductId")%>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server"  CssClass="form-control form-control-sm"
                                                Text='<%# Eval("ProductName")%>' AutoPostBack="True" ReadOnly="True" ToolTip="true"
                                                OnTextChanged="productNameTextBox_TextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:TextBox ID="packSizeTextBox"  runat="server" CssClass="form-control form-control-sm"
                                                ReadOnly="True" Text='<%# Eval("PackSize")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchTextBox"  runat="server" CssClass="form-control form-control-sm" ReadOnly="True"
                                                Text='<%# Eval("Batch")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Mfg. Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="mfgDateTextBox" runat="server"  Text='<%# Eval("MfgDate")%>'
                                                CssClass="form-control form-control-sm" AutoPostBack="True" OnTextChanged="mfgDateTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="manufacturerDate1" runat="server" Format="dd-MMM-yyyy"
                                                TargetControlID="mfgDateTextBox">
                                            </cc1:CalendarExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exp. Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="expDateDateTextBox" runat="server"  Text='<%# Eval("ExpDate")%>'
                                                CssClass="form-control form-control-sm" AutoPostBack="True" OnTextChanged="expDateDateTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="manufacturerDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="expDateDateTextBox">
                                            </cc1:CalendarExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="reqQtyTextBox" runat="server"  CssClass="form-control form-control-sm"
                                                Text='<%# Eval("Quantity")%>' AutoPostBack="True" OnTextChanged="reqQtyTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderQuantity" runat="server"
                                                Enabled="True" TargetControlID="reqQtyTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="costPriceTextBox" runat="server"  Text='<%# Eval("Price")%>'
                                                CssClass="form-control form-control-sm" AutoPostBack="True" OnTextChanged="costPriceTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderPrice" runat="server" Enabled="True"
                                                TargetControlID="costPriceTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vat">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("Vat")%>' AutoPostBack="True" OnTextChanged="vatTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderVat" runat="server" Enabled="True"
                                                TargetControlID="vatTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Amount">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalValueTextBox" runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("TotalAmount")%>' ReadOnly="True" AutoPostBack="True" OnTextChanged="totalValueTextBox_OnTextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="C.Stock">
                                        <ItemTemplate>
                                            <asp:TextBox ID="cStockTextBox" runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("CStock")%>' ReadOnly="True" AutoPostBack="True" ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Stock Out Qty.">
                                        <ItemTemplate>
                                            <asp:TextBox ID="qtyTextBox" runat="server" CssClass="form-control form-control-sm"
                                                 AutoPostBack="True" OnTextChanged="qtyTextBox_OnTextChanged"></asp:TextBox>
                                                 <cc1:FilteredTextBoxExtender ID="fqtyTextBox" runat="server"
                                                        TargetControlID="qtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                            
                                </Columns>
                            </asp:GridView>

           
          </div>
       </div>

                       <br />

                      <div class="row">

                            <div class="col-md-4">


                                  <div class="form-group row">
                              


<%--                                       <asp:LinkButton ID="LinkButton1"  class="btn btn-sm btn-info" OnClick="LinkButton1_Click"  runat="server"> <i data-feather="corner-up-right" style="width: 16px !important; height: 16px !important;"></i> Back to List </asp:LinkButton>--%>
                                                                 
                                    </div>

                                 
                                </div>                                               

                            <div class="col-md-4">

               
 
                                    
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Total QTY </label>

                                    <div class="col-sm-5">
                                     

                                    <asp:TextBox ID="totalQtyTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="true" ></asp:TextBox>
                      
                           
                                                        
                                    </div>
                                 
                                </div>   


                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Total VAT </label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="totalVatTextBox" runat="server" CssClass="form-control form-control-sm "  ReadOnly="true"></asp:TextBox>
                          
                           
                           
                                    
                                    </div>
                                 
                                </div>   
                 
                      
                           <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label"> Grand Total </label>

                                    <div class="col-sm-5">
                                     

                                        <asp:TextBox ID="grandTotalTextBox" runat="server" CssClass="form-control form-control-sm" ReadOnly="true" ></asp:TextBox>

                                                                   
                                    </div>
                                 
                                </div>   
                                                 
                                </div>  
                
                      </div>  

                       <br />

                      <div class="row">
                            <div class="col-3">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                 <asp:LinkButton ID="submitButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="submitButton_Click" OnClientClick="return confirm('Are you sure you want to Save ?');"  style="background-color: #00bcd4;color: #fff;"><i class="fa fa-check-square" aria-hidden="true"></i>&nbsp;  Submit Information</asp:LinkButton>
                                      
                             <%--    <asp:LinkButton ID="btn"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                 ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>--%>


                

                                  

                                             
                
                          
                                         
                                    </div>
                                </div>

                            </div>
                       
                        </div>                 
                       <br/>
              
                     
                                </div>  
                                </div>  
                                </div>  


            
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>  

    </div>  











<%--    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Warehouse Stock Out
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" style="text-align: right; padding-right: 10px;" class="TDRight">
        
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
                            &nbsp;
                            <asp:HiddenField ID="masterIdHiddenField" runat="server" />
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Manufacturer: 
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="manufacturerDropDownList" Width="175px" Height="23px" runat="server"
                                CssClass="DropDown">
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
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Stock In Date: 
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="stockInDateTextBox" Width="150px" Height="23px" runat="server" CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="stockInDateTextBox_OnTextChanged"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <cc1:CalendarExtender ID="manufacturerDate1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="stockInDateTextBox" PopupButtonID="imgDate">
                            </cc1:CalendarExtender>
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
                            &nbsp;
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Challan No: 
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="challanNoTextBox" Height="23px" runat="server"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
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
                        <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                            Challan Date: 
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="challanDateTextBox" Width="150px" Height="23px" runat="server" CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="challanDateTextBox_OnTextChanged"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="ImageButton4"></asp:ImageButton>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="challanDateTextBox" PopupButtonID="ImageButton4">
                            </cc1:CalendarExtender>
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
                        <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                            Reference No:
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="referenceNoTextBox" Height="23px" runat="server"></asp:TextBox>
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
                        <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                            Reference Date:
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="referenceDateTextBox" Width="150px" Height="23px" runat="server"
                                CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="referenceDateTextBox_OnTextChanged"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="ImageButton5"></asp:ImageButton>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="referenceDateTextBox" PopupButtonID="ImageButton5">
                            </cc1:CalendarExtender>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr runat="server" Visible="False">
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                            Remarks:
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="remarksTextBox" Height="20px" runat="server"></asp:TextBox>
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
                        <td class="TDLeft" width="13%" style="text-align: right; padding-right: 10px;" width="13%">
                            Reason<span style="color: red">*</span>
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="reasonTextBox" Height="20px" runat="server"></asp:TextBox>
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
                        <td class="TDRight" width="20%" colspan="4">
                            <asp:GridView ID="productGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="WHStockInDetailID,ReceiveId">
                                <Columns>
                                    <asp:BoundField DataField="SL" HeaderText="SL" />
                                    <asp:TemplateField HeaderText="Code">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productCodeTextBox" runat="server" Height="23px" Width="50px" CssClass="TextBoxCalander"
                                                AutoPostBack="True" ToolTip="true" OnTextChanged="productCodeTextBox_TextChanged"
                                                Text='<%# Eval("ProductCode")%>'></asp:TextBox>
                                            <asp:HiddenField ID="productidHiddenField" Value='<%# Eval("ProductId")%>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="productNameTextBox" runat="server" Height="23px" Width="130px" CssClass="TextBox"
                                                Text='<%# Eval("ProductName")%>' AutoPostBack="True" ReadOnly="True" ToolTip="true"
                                                OnTextChanged="productNameTextBox_TextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="PackSize">
                                        <ItemTemplate>
                                            <asp:TextBox ID="packSizeTextBox" Height="23px" Width="30px" runat="server" CssClass="TextBoxCalander"
                                                ReadOnly="True" Text='<%# Eval("PackSize")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch">
                                        <ItemTemplate>
                                            <asp:TextBox ID="batchTextBox" Width="40px" Height="23px" runat="server" CssClass="TextBoxCalander" ReadOnly="True"
                                                Text='<%# Eval("Batch")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Mfg. Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="mfgDateTextBox" runat="server" Height="23px" Width="80px" Text='<%# Eval("MfgDate")%>'
                                                CssClass="TextBox" AutoPostBack="True" OnTextChanged="mfgDateTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="manufacturerDate1" runat="server" Format="dd-MMM-yyyy"
                                                TargetControlID="mfgDateTextBox">
                                            </cc1:CalendarExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exp. Date">
                                        <ItemTemplate>
                                            <asp:TextBox ID="expDateDateTextBox" runat="server" Height="23px" Width="80px" Text='<%# Eval("ExpDate")%>'
                                                CssClass="TextBox" AutoPostBack="True" OnTextChanged="expDateDateTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="manufacturerDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="expDateDateTextBox">
                                            </cc1:CalendarExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Qty">
                                        <ItemTemplate>
                                            <asp:TextBox ID="reqQtyTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                Text='<%# Eval("Quantity")%>' AutoPostBack="True" OnTextChanged="reqQtyTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderQuantity" runat="server"
                                                Enabled="True" TargetControlID="reqQtyTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <asp:TextBox ID="costPriceTextBox" runat="server" Height="23px" Width="60px" Text='<%# Eval("Price")%>'
                                                CssClass="TextBoxCalander" AutoPostBack="True" OnTextChanged="costPriceTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderPrice" runat="server" Enabled="True"
                                                TargetControlID="costPriceTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vat">
                                        <ItemTemplate>
                                            <asp:TextBox ID="vatTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                Text='<%# Eval("Vat")%>' AutoPostBack="True" OnTextChanged="vatTextBox_OnTextChanged"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderVat" runat="server" Enabled="True"
                                                TargetControlID="vatTextBox" FilterType="Custom" ValidChars="0123456789.">
                                            </cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Amount">
                                        <ItemTemplate>
                                            <asp:TextBox ID="totalValueTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                Text='<%# Eval("TotalAmount")%>' ReadOnly="True" AutoPostBack="True" OnTextChanged="totalValueTextBox_OnTextChanged"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="C.Stock">
                                        <ItemTemplate>
                                            <asp:TextBox ID="cStockTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                Text='<%# Eval("CStock")%>' ReadOnly="True" AutoPostBack="True" ></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Stock Out Qty.">
                                        <ItemTemplate>
                                            <asp:TextBox ID="qtyTextBox" runat="server" Height="23px" Width="60px" CssClass="TextBoxCalander"
                                                 AutoPostBack="True" OnTextChanged="qtyTextBox_OnTextChanged"></asp:TextBox>
                                                 <cc1:FilteredTextBoxExtender ID="fqtyTextBox" runat="server"
                                                        TargetControlID="qtyTextBox"         
                                                        FilterType="Custom, Numbers"
                                                        ValidChars="." />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" 
                                                    oncheckedchanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                              
                                </Columns>
                            </asp:GridView>
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
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Total Qty :
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="totalQtyTextBox" Height="23px" runat="server" class="TextBox" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" style="text-align: right; padding-right: 10px;" width="20%">
                            &nbsp;
                        </td>
                        <td class="TDLeft" style="text-align: right; padding-right: 10px;" width="13%">
                            Total Vat:
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:TextBox ID="totalVatTextBox" Height="23px" ReadOnly="True" class="TextBox" runat="server"></asp:TextBox>
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
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Grand Total:
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="grandTotalTextBox" Height="23px" runat="server" class="TextBox"
                                ReadOnly="True"></asp:TextBox>
                        </td>
                        <td width="13%" class="TDLeft">
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
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                            <asp:LinkButton ID="LinkButton1" runat="server" onclick="LinkButton1_Click">&lt;&lt;&lt;&lt;-Back To List</asp:LinkButton>
                        </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click" Text="Submit"
                            OnClientClick="return confirm('Are you sure you want to Save ?');" />
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
