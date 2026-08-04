<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="WHStockInReportList.aspx.cs" Inherits="SInventory_UI_WHStockInReportList" %>

<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .mg-lft
        {
            margin-left: 20px;
            color: #006666;
        }
        
        .button-padding-right {
            margin-right: 5px;
        } 
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



      <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Warehouse Stock Report </div>

            <%--    <div class="ms-auto">
                    <div class="btn-group">
                        

                    
                    </div>
                </div>--%>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                

                    <div class="card-body">
 
                       
                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                     

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

                            <div class="form-group row">
                          <label for="" class="col-sm-3 col-form-label">  Report Type :</label>

                           <div class="col-sm-5">
                                     

                               <asp:DropDownList ID="reportDropDownList" AutoPostBack="True" OnTextChanged="reportDropDownList_OnTextChanged" CssClass="form-select form-select-sm mb-3 mySelect2"  runat="server">
                                <asp:ListItem>--- Select ---</asp:ListItem>
                                <asp:ListItem Value="STD"> StockIn Detail Report </asp:ListItem>
                                <asp:ListItem Value="CSR"> Current Stock Report </asp:ListItem>
                            </asp:DropDownList>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  


                            <div class="form-group row" id="stockInDate" runat="server" visible="False">
                                    <label for="" class="col-sm-3 col-form-label"> Stock In Date Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="stockInDateTextBox" runat="server" CssClass="form-control form-control-sm datepicker" ></asp:TextBox>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>   
                                
                           <div class="form-group row" id="productName" runat="server" visible="False">
                                    <label for="" class="col-sm-3 col-form-label"> Product :</label>

                                    <div class="col-sm-5">
                                     

                             
                                  <asp:DropDownList ID="productDropDownList"  CssClass="form-control form-control-sm " runat="server">
                            </asp:DropDownList>
                           
                           
                                    
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

                                     <asp:LinkButton ID="searchButton" Visible="True" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="searchButton_Click" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-search-plus"></i>&nbsp; Search Report</asp:LinkButton>
    
                                     <asp:LinkButton ID="reportButton" Visible="False"  CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="reportButton_OnClick" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-eye"></i>&nbsp; View Report</asp:LinkButton>

                                     <asp:LinkButton ID="excelButton"  Visible="False" class="btn btn-sm btn-warning  mb-2" style="background-color: forestgreen; color: #fff;" runat="server" OnClick="excelButton_OnClick"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp; Export To Excel </asp:LinkButton>

                                     <asp:LinkButton ID="LinkButton1"  class="btn btn-sm btn-warning  mb-2" style="background-color: orangered; color: #fff;" runat="server" OnClick="cancelButton_Click"><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset Information </asp:LinkButton>
                                    
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>                 
                        <br/>

                        <div class="row">
         <div class="table-responsive" id="MainGradeDiv">
       
             

              <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"  CssClass="table  blueTable" OnPreRender="gv_DocumentUpload_PreRender" 
                                     DataKeyNames="WHStockInMasterID">
                                    <Columns>
                                        <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                        <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                        <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="TotalQuantity" HeaderText="Total Qty" />
                                        <asp:BoundField DataField="TotalValue" HeaderText="Total Amt" />
                                        <asp:TemplateField HeaderText="Report">
                                            <ItemTemplate>
                                    
                                                  <asp:ImageButton ID="printButton" runat="server" 
                                                  OnClick="printButton_Click"  ImageUrl="../images/image/if_paste-clipboard-copy_2931174.png"/>
                                            </ItemTemplate>
                                        </asp:TemplateField>
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

   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Warehouse Stock Report
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
                        <td width="20%" class="TDRight">
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
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Report Type:
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="reportDropDownList" AutoPostBack="True" OnTextChanged="reportDropDownList_OnTextChanged" CssClass="DropDown" Height="23px" runat="server">
                                <asp:ListItem>--- Select ---</asp:ListItem>
                                <asp:ListItem Value="STD"> StockIn Detail Report </asp:ListItem>
                                <asp:ListItem Value="CSR"> Current Stock Report </asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr id="stockInDate" runat="server" visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Stock In Date:
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="stockInDateTextBox" Height="23px" Width="140px" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                TabIndex="4" ID="imgDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" TargetControlID="stockInDateTextBox"
                                PopupButtonID="imgDate">
                            </asp:CalendarExtender>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr id="productName" runat="server" visible="False">
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                        <td width="13%" style="text-align: right; padding-right: 10px;" class="TDLeft">
                            Product:
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="productDropDownList" Height="23px" CssClass="DropDown" runat="server">
                            </asp:DropDownList>
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
                            <br />
                            <asp:Button ID="searchButton" Visible="True" runat="server" CssClass="button-padding-right" Text="Search" OnClick="searchButton_Click" />
                            <asp:Button ID="reportButton" runat="server" CssClass="button-padding-right" BackColor="#cc6600"  Visible="False" Text="View Report" OnClick="reportButton_OnClick" />
                            <asp:Button ID="excelButton" runat="server" BackColor="#006666" Visible="False" Text="Excel" OnClick="excelButton_OnClick" />
                        </td>
                        <td width="13%" class="TDLeft">
                            
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td class="TDRight" colspan="4">
                            <div id="gridContainer1" style="height: 500px; overflow: auto; width: auto">
                                <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"
                                    CssClass="gridview" DataKeyNames="WHStockInMasterID">
                                    <Columns>
                                        <asp:BoundField DataField="WHStockInCode" HeaderText="Code" />
                                        <asp:BoundField DataField="ChallanNo" HeaderText="Challan No" />
                                        <asp:BoundField DataField="ChallanDate" HeaderText="Challan Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="TotalQuantity" HeaderText="Total Qty" />
                                        <asp:BoundField DataField="TotalValue" HeaderText="Total Amt" />
                                        <asp:TemplateField HeaderText="Report">
                                            <ItemTemplate>
                                    
                                                  <asp:ImageButton ID="printButton" runat="server" 
                                                  OnClick="printButton_Click"  ImageUrl="../images/image/if_paste-clipboard-copy_2931174.png"/>
                                            </ItemTemplate>
                                        </asp:TemplateField>
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
