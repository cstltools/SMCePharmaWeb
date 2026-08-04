<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="WhStockMonitoringReport.aspx.cs" Inherits="SInventory_UI_WhStockMonitoringReport" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> WH Stock Information </div>

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
                                    <label for="" class="col-sm-3 col-form-label">  From Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker" ></asp:TextBox>
                          
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>   

                              <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">  To Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                       
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
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

                                     <asp:LinkButton ID="viewRptButton" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="viewRptButton_Click" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-search-plus"></i>&nbsp; Search Information</asp:LinkButton>
                                       <asp:LinkButton ID="LinkButton1"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"
                                        ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">

                                                           <asp:LinkButton ID="excelButton"  class="btn btn-sm btn-warning  mb-2" style="background-color: forestgreen; color: #fff;" runat="server" OnClick="excelButton_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export To Excel </asp:LinkButton>
                            </div>
                        </div>                 
                        <br/>

                        <div class="row">
         <div class="table-responsive" id="MainGradeDiv">
       
       
        
                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender"  ShowFooter="True">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />

                                    <asp:BoundField DataField="OpeningStockQty" HeaderText="Opening Stock Qty"
                                        ItemStyle-Width="60"  ItemStyle-HorizontalAlign="Right">
                                        <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>

                                    <asp:BoundField DataField="OpAmount" HeaderText="Opening Stock amount"
                                        ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right">
                                        <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>

                                    <asp:BoundField DataField="StockInQty" HeaderText="WH Total Stock In Qty"
                                        DataFormatString="{0:N2}" />

                                    <asp:BoundField DataField="IssueQty" HeaderText="S.T.O Total Issue Qty" />

                                    <asp:BoundField DataField="saleQty" HeaderText="Sales Qty"/>
                                    <asp:BoundField DataField="saleAmount"  DataFormatString="{0:N2}"  HeaderText="Sales Amount" />
                                    
                                    <asp:BoundField DataField="ClosingBal"  DataFormatString="{0:N2}" HeaderText="Closing Qty" />
                                    
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
    </asp:UpdatePanel>


  <%--  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            WH Stock Information
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
                        <td width="13%" class="TDLeft">
                            From Date
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="fromDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDateFrom"
                                TargetControlID="fromDateTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="imgDateFrom" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
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
                        <td width="13%" class="TDLeft">
                            To Date
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="toDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:CalendarExtender ID="toDate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDateTo"
                                TargetControlID="toDateTextBox">
                            </asp:CalendarExtender>
                            <asp:ImageButton ID="imgDateTo" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
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
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                            <asp:Button ID="viewRptButton" runat="server" OnClick="viewRptButton_Click" Text="Search" />
                        </td>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                            &nbsp;
                            <asp:Button ID="excelButton" BackColor="green" ForeColor="white" runat="server" Text="Export to Excel"
                                OnClick="excelButton_Click" />
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
                        <td width="13%" class="TDLeft" colspan="6">
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview" ShowFooter="True">
                                <Columns>
                                    <asp:TemplateField HeaderText="#SL">
                                        <ItemTemplate>
                                            <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />

                                    <asp:BoundField DataField="OpeningStockQty" HeaderText="Opening Stock Qty"
                                        ItemStyle-Width="60"  ItemStyle-HorizontalAlign="Right">
                                        <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>

                                    <asp:BoundField DataField="OpAmount" HeaderText="Opening Stock amount"
                                        ItemStyle-Width="60" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right">
                                        <ItemStyle HorizontalAlign="Right" Width="60px" />
                                    </asp:BoundField>

                                    <asp:BoundField DataField="StockInQty" HeaderText="WH Total Stock In Qty"
                                        DataFormatString="{0:N2}" />

                                    <asp:BoundField DataField="IssueQty" HeaderText="S.T.O Total Issue Qty" />

                                    <asp:BoundField DataField="saleQty" HeaderText="Sales Qty"/>
                                    <asp:BoundField DataField="saleAmount"  DataFormatString="{0:N2}"  HeaderText="Sales Amount" />
                                    
                                    <asp:BoundField DataField="ClosingBal"  DataFormatString="{0:N2}" HeaderText="Closing Qty" />
                                    
                                </Columns>
                            </asp:GridView>
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
    </asp:UpdatePanel>--%>
</asp:Content>
