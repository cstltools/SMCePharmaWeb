<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="TargetExcelUpload.aspx.cs" Inherits="SInventory_UI_TargetExcelUpload" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">





  <%--    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>--%>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Monthly Target Upload </div>

                <div class="ms-auto">
                    <div class="btn-group">
           

                        
                              <a href="TargetExcelUploadList.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>

                                          
                    
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
                        



                                  <asp:HiddenField ID="HiddenField1" runat="server" />

                       

                            <br />

    <div class="row">
       <div class="col-md-2"><a href="../Approval_UI/TargetEntry.xls"  class="btn  btn-secondary   btn-sm">Download Excel Format</a>  </div>
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

                         

                       

                        <br/>
    <div class="row">
           <div class="table-responsive" id="MainGradeDiv">
       
                    
                <asp:GridView ID="loadGridView" runat="server"   AutoGenerateColumns="False"
                               CssClass="table table-bordered  text-center thead-dark"    OnPreRender="gv_DocumentUpload_PreRender"  OnRowDataBound="loadGridView_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="#SL">
                                <ItemTemplate>
                                    <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                       
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Territory ID">
            <ItemTemplate>
                <asp:Label ID="lblTerritoryCode" runat="server" Text='<%# Bind("TerritoryCode") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>   

                    


                                                 <asp:TemplateField HeaderText="Target Value">
    <ItemTemplate>
        <asp:Label ID="lblTargetValue" runat="server" Text='<%# Bind("TargetValue") %>'></asp:Label>
    </ItemTemplate>
</asp:TemplateField> 
                             
                            
                            <asp:TemplateField HeaderText="Month Value">
    <ItemTemplate>
        <asp:Label ID="lblMonthValue" runat="server" Text='<%# Bind("MonthValue") %>'></asp:Label>
    </ItemTemplate>
</asp:TemplateField>
                             <asp:TemplateField HeaderText="Year Value">
    <ItemTemplate>
        <asp:Label ID="lblYearValue" runat="server" Text='<%# Bind("YearValue") %>'></asp:Label>
    </ItemTemplate>
</asp:TemplateField>
                             <asp:TemplateField HeaderText="Financial Year">
    <ItemTemplate>
        <asp:Label ID="lblFinancialYear" runat="server" Text='<%# Bind("FinancialYear") %>'></asp:Label>
    </ItemTemplate>
</asp:TemplateField>
                            
                        </Columns>
                    </asp:GridView>

          </div>
          </div>


                           <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">

                                           <asp:LinkButton ID="btnSave"  OnClientClick="return sweetAlertConfirm_Submit(this);" runat="server" OnClick="submitButton_Click"  class="btn btnMyDesignSearch   btn-sm"  > <i class="fa fa-check"></i>&nbsp; Submit </asp:LinkButton>
                            

                                          <asp:LinkButton ID="cancelButton"  runat="server"  OnClick="cancelButton_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
 
                                         
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
