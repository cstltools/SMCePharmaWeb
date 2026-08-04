<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="CustomerPaymentExcelUpload.aspx.cs" Inherits="SInventory_UI_CustomerPaymentExcelUpload" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">





  <%--    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>--%>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Customer Payment Upload </div>

                <div class="ms-auto">
                    <div class="btn-group">
           


                                           <a href="CustomerPayment.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">


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

                

                    <div class="card-body">
                        

                                                                    <div class="row">
    <div class="col-2">&nbsp;</div>
    <div class="col-8">
        <div class="form-group row">
            <label for="mainName" class="col-sm-3 col-form-label">Sales Center:</label>

            <div class="col-sm-5">


                <asp:DropDownList ID="salesCenterDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"
                    AutoPostBack="True" OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                </asp:DropDownList>

                <script type="text/javascript">
                    function pageLoad() {
                        $('.mySelect2').select2({
                            theme: 'bootstrap4',
                            width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                            placeholder: $(this).data('placeholder'),
                            allowClear: Boolean($(this).data('allow-clear')),
                        });
                        $('.datepicker').pickadate({
                            selectMonths: true,
                            selectYears: true
                        })

                    }
                </script>


            </div>
            <span class="text-sm-left text-c-red">*</span>
        </div>


      

 
 

        <div class="form-group row">
            <label for="mainName" class="col-sm-3 col-form-label">Route:</label>

            <div class="col-sm-5">


                <asp:DropDownList ID="rootDropDownList" AutoPostBack="true" OnSelectedIndexChanged="rootDropDownList_SelectedIndexChanged" runat="server" CssClass="form-control form-control-sm mySelect2 "
                    >
                </asp:DropDownList>


            </div>
            <span class="text-sm-left text-c-red">*</span>
        </div>
      

        <div class="form-group row">
            <label for="mainName" class="col-sm-3 col-form-label"> DA Name:</label>

            <div class="col-sm-5">


                 <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 " id="ddlDAName" ></asp:DropDownList>


            </div>
            <span class="text-sm-left text-c-red">*</span>
        </div>
      

    </div>
</div>


                                  <asp:HiddenField ID="HiddenField1" runat="server" />

                       

                            <div class="form-group row" style="display:none">

                              
                                  <div class="col-2">
                                      </div>
                                  <div class="col-4">

      <div class="form-group row">
          <label for="mainName" class="col-sm-4 col-form-label">Deposit Code:</label>

          <div class="col-sm-7">

              <asp:TextBox ID="txtDepositCode" runat="server" AutoPostBack="True" ReadOnly="True" CssClass="form-control form-control-sm"></asp:TextBox>


          </div>
          <span class="text-sm-left text-c-red">*</span>
      </div>

                                      </div>
    
        <div class="col-4">

            

            <div class="form-group row">
                <label for="mainName" class="col-sm-4 col-form-label">Total Amount:</label>

                <div class="col-sm-7">
                      
                      <asp:TextBox   runat="server"   CssClass="form-control form-control-sm mb-3 "   id="txtTotalAmount" placeholder="Total Amount"></asp:TextBox>
          <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                     Enabled="True" TargetControlID="txtTotalAmount" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>


                </div>
                <span class="text-sm-left text-c-red">*</span>
            </div>



        </div>
    
    </div>
                            <br />

    <div class="row">
       <div class="col-md-2"><a href="../Approval_UI/Customer_Payment.xls"  class="btn  btn-secondary   btn-sm">Download Excel Format</a>  </div>
           <div class="col-md-10">
               <div class="form-group row">
                
                <label for="mainName" class="col-sm-2 col-form-label"> Upload File :</label>

                <div class="col-sm-7">

                  <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="form-control form-control-sm" />
                     
                      <asp:HiddenField ID="IsFileUploaded" runat="server" />
                 <br />
                      <asp:Label ID="lbl_up_status" runat="server" CssClass=""></asp:Label>
                </div>

                   <div class="col-sm-3">
                        <asp:Button ID="btnUpload" runat="server" class="btn btnMyDesignAddtoList   btn-sm" Text="Upload" OnClick="btnUpload_Click" />
                    
     
            </div>
            </div>
            </div>            
    </div>


    <br />

                           <div class="row">
                                        <div class="col-6">&nbsp;</div>
                                        <div class="col-6">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-8">

                                                <span  class="ssss btn bg-info"> <asp:Label ID="lblCount" Text="Total Pay Amount : 0" runat="server"  ></asp:Label></span>   

                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>

                       

                        <br/>
                                                 <div class="row" style="margin-top:10px;">
                                                    <div class="table-responsive" id="MainGradeDiv">
                                                        <asp:GridView ID="orderGridView" runat="server"
                                                            AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" DataKeyNames="InvoiceId">
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True"
                                                                            OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                             <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("CustomerMasterId")%>' />
                                                                             <asp:HiddenField runat="server" ID="hfMarketId" Value='<%#Eval("MarketId")%>' />
                                                                             <asp:HiddenField runat="server" ID="hfDistributionRouteId" Value='<%#Eval("DistributionRouteId")%>' />
                                                                             <asp:HiddenField runat="server" ID="hfComUnitId" Value='<%#Eval("ComUnitId")%>' />
                                                                          <asp:HiddenField runat="server" ID="hfInvoiceId" Value='<%#Eval("InvoiceId")%>' />
                                                                              <asp:HiddenField runat="server" ID="hfTP_Pay" Value='<%#Eval("TP_Pay")%>' />
      <asp:HiddenField runat="server" ID="hfVat_Pay" Value='<%#Eval("Vat_Pay")%>' />
                                                                        <asp:CheckBox Checked="true" OnCheckedChanged="chkSelect_CheckedChanged" ID="chkSelect" AutoPostBack="True" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                       <asp:BoundField DataField="CustomerCode" HeaderText="Customer ID" />
       <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />

                                                                  <asp:BoundField DataField="OrderNo" HeaderText="Order Code" />
  <asp:BoundField DataField="OrderDate" HeaderText="Order / Submission Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" />
                                                                <asp:BoundField DataField="InvoiceDate" HeaderText="Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                          
                                                                
                                                                <%--    <asp:BoundField DataField="RtnInvoiceNo" HeaderText="Confirm Invoice No" />
                                                                <asp:BoundField DataField="RtnInvoiceDate" HeaderText="Confirm Invoice Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                                           --%>

                                                                
                                                                    <asp:TemplateField HeaderText="Confirm  Amount">
        <ItemTemplate>
            <asp:Label   runat="server" ID="lblTotalDelivery" Text='<%#Eval("TotalDelivery")%>' />

        </ItemTemplate>
    </asp:TemplateField>

                                                                    <asp:TemplateField HeaderText="Previous Pay">
        <ItemTemplate>
            <asp:Label   runat="server" ID="lblPaymentAmount" Text='<%#Eval("PaymentAmount")%>' />

        </ItemTemplate>
    </asp:TemplateField>

                 
                                                                    <asp:TemplateField HeaderText="Due Amount">
<ItemTemplate>
        <asp:Label   runat="server" ID="lblDue" Text='<%#Eval("Due")%>' />

    </ItemTemplate>
</asp:TemplateField>

                                                               
                                                           
                                                                <asp:TemplateField HeaderText="Pay Amount">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="payAmountTextBox" runat="server" Text='<%#Eval("PayNewAmount")%>' AutoPostBack="True"
                                                                         CssClass="form-control form-control-sm"   OnTextChanged="payAmountTextBox_TextChanged"></asp:TextBox>
                                                                        <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                            Enabled="True" TargetControlID="payAmountTextBox" FilterType="Custom" ValidChars="0123456789.">
                                                                        </asp:FilteredTextBoxExtender>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>

                                                                                                                                    <asp:TemplateField HeaderText="Collection By">
<ItemTemplate>
        <asp:Label   runat="server" ID="lblCollectionBy" Text='<%#Eval("CollectionBy")%>' />

    </ItemTemplate>
</asp:TemplateField>


                                                                <asp:TemplateField  Visible="false">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkAdjust" OnCheckedChanged="chkAdjust_OnCheckedChanged" AutoPostBack="True" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField Visible="false" DataField="AdjustableAmount" HeaderText="AdjustableAmount" />
                                                            </Columns>
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                        <br />
                        <br />

                           <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                         <asp:LinkButton OnClick="saveButton_Click" runat="server" ID="masterButton" OnClientClick="return sweetAlertConfirm_Submit(this);" class="btnMyyNew btnMyyNew-6">  <i class="fa fa-check"></i> ALL Submit</asp:LinkButton>
                            

                                          <asp:LinkButton ID="cancelButton"  runat="server"  OnClick="cancelButton_Click"  style="color:black!important; font-weight:bold" class="btnMyyNew btnMyyNew-5"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
 
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>



                    

          

                             
                                </div>  
                                </div>  
                                </div>  
                                </div>  
                
                                </div>  
                                </div>  
                  </div>  
                               <%-- </div>  
     </ContentTemplate>
    </asp:UpdatePanel>--%>




    <div runat="server" visible="false">

        <table width="100%" class="TableWorkArea">
            <tr>
                <td colspan="6" class="TableHeading">
                    Deposit Slip Data Upload
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
            <tr runat="server" Visible="False">
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                     Document Upload Date:
                </td>
                <td class="TDRight" width="20%">
                  <asp:TextBox ID="documentDateTextBox" runat="server" CssClass="datepick"></asp:TextBox>
                   <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="documentDateTextBox"
                                PopupButtonID="imgDate">
                            </asp:CalendarExtender>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
                </td>
            </tr>
            <tr runat="server" Visible="False">
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Manufacturer:
                </td>
                <td class="TDRight" width="20%">
                    <asp:DropDownList ID="manufacturerDropDownList" runat="server" CssClass="radioButtonList">
                    </asp:DropDownList>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
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
                </td>
                <td width="13%" class="TDLeft">
                </td>
                <td width="20%" class="TDRight">
                </td>
            </tr>
            <tr>
                <td class="TDLeft" width="13%">
                </td>
                <td class="TDRight" width="20%">
                </td>
                <td class="TDLeft" width="13%">
                    Select File:
                </td>
                <td class="TDRight" width="20%">
       <%--             <asp:FileUpload ID="id_fu" runat="server" ToolTip="Select File To Upload." class="btn" />
                    <asp:Button ID="btnUpload" runat="server" class="btn btn-primary" Text="Upload" OnClick="btnUpload_Click" />
                    <asp:Label ID="lbl_up_status" runat="server"></asp:Label>
                    <asp:HiddenField ID="IsFileUploaded" runat="server" />--%>
                </td>
                <td class="TDLeft" width="13%">
                    &nbsp;
                </td>
                <td class="TDRight" width="20%">
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
                </td>
                <td width="100%" class="TDRight" colspan="4">
                     <div id ="gridContainer1" style ="height:auto;overflow:auto;width:960px ">
                  <%--  <asp:GridView ID="loadGridView" runat="server" CssClass="gridview" AutoGenerateColumns="False"
                                  OnRowDataBound="loadGridView_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="SalesCenterName" HeaderText="Sales Center" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                            <asp:BoundField DataField="DepositType" HeaderText="DepositType" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                            <asp:BoundField DataField="BankName" HeaderText="Bank Name" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                            <asp:BoundField DataField="AccountName" HeaderText="Account Name" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                            <asp:BoundField DataField="DepositDate" HeaderText="Deposit Date" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                            <asp:BoundField DataField="Amount" HeaderText="Amount" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                            <asp:BoundField DataField="Remarks" HeaderText="Remarks" HtmlEncode="False" HtmlEncodeFormatString="False"/>
                           
                        </Columns>
                    </asp:GridView>--%>
                    </div>
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
                <td width="13%" class="TDLeft">
                    &nbsp;
                </td>
                <td width="20%" class="TDRight">
                   <%-- <asp:Button ID="submitButton" runat="server" OnClick="submitButton_Click" Text="Submit"  OnClientClick="return confirm('Are you sure you want to Save ?');" />--%>

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
</asp:Content>
