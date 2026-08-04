<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SalesReturnList.aspx.cs" Inherits="SInventory_UI_SalesReturnList" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
             <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
             <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Sales Return List </div>

                <div class="ms-auto">
                    <div class="btn-group">
           


                                        <asp:LinkButton ID="EmpCetegoryAddImageButton" CssClass="btn btn-sm btn-outline-info " runat="server" OnClick="EmpCetegoryAddImageButton_Click"><i class="fa fa-plus" aria-hidden="true"></i> New Entry </asp:LinkButton>
                    
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

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                                                                    
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> From Date :</label>

                                    <div class="col-sm-5">

                                              
                                                     <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker"></asp:TextBox>            
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                                                                  
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> To Date :</label>

                                    <div class="col-sm-5">

                                                <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker"></asp:TextBox>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                  
                                  
                     
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  DC  :</label>

                                    <div class="col-sm-5">
                                    
                              
                                                     <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                         CssClass="form-select form-select-sm mb-3 mySelect2" >
                        </asp:DropDownList>
                                                                 
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

                                  <asp:LinkButton ID="LinkButton2" CssClass="btn btn-sm btn-primary mb-2" runat="server" OnClick="Button1_Click" style="background-color: #00bcd4;color: #fff;">   <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                       

                        <br/>
    <div class="row">
           <div class="table-responsive" id="MainGradeDiv">
       
                    
                  <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="ReturnInvoiceId" 
                                onrowcommand="loadGridView_RowCommand"   CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender"  >
                                <Columns>
                                    <asp:BoundField DataField="ReturnInvoiceNo" HeaderText="ReturnInvoiceNo" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="CustomerCode" />
                                    <asp:BoundField DataField="TpTotal" HeaderText="TpTotal" />
                                
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="rptImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="reportData" 
                                                ImageUrl="~/images/viewlists.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

          </div>
          </div>



                    

              <script>

                  $(document).ready(function () {

                      var table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                          {
                              "bInfo": true,
                              "bFilter": true,
                              lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                              pageLength: 10,
                              dom: 'lBfrtip',


                              buttons: ['copy', 'excel', 'pdf', 'print']
                          }
                      );

                      var prm = Sys.WebForms.PageRequestManager.getInstance();
                      if (prm != null) {
                          prm.add_endRequest(function (sender, e) {
                              if (sender._postBackSettings.panelsToUpdate != null) {
                                  table = $('#ContentPlaceHolder1_loadGridView').DataTable(
                                      {
                                          "bInfo": true,
                                          "bFilter": true,
                                          lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                          pageLength: 10,
                                          dom: 'lBfrtip',


                                          buttons: ['copy', 'excel', 'pdf', 'print']


                                      }
                                  );
                              }
                          });
                      };


                      table.columns().every(function () {
                          var that = this;


                      });
                  });


              </script>

                             
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











<%--    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Sales Return View
                        </td>
                    </tr>
                     <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;
                         </td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="SalesReturn.aspx">Add New</asp:HyperLink>                          
                            
                            &nbsp;
                        </td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
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
                        <td width="13%" class="TDLeft">
                            From Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                             TabIndex="4" ID="imgfDate"></asp:ImageButton>
                            <asp:CalendarExtender ID="orderDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="fromDateTextBox"
                                                  PopupButtonID="imgfDate">
                            </asp:CalendarExtender></td>
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
                            To Date</td>
                        <td width="20%" class="TDRight">
                            <asp:TextBox ID="toDateTextBox" runat="server" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton runat="server" AlternateText="Click to show calendar" ImageUrl="~/Images/Calendar_scheduleHS.png"
                                             TabIndex="4" ID="ImageButton1"></asp:ImageButton>
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="toDateTextBox"
                                                  PopupButtonID="ImageButton1">
                            </asp:CalendarExtender>
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
                            DC</td>
                        <td width="20%" class="TDRight">
                            <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                AutoPostBack="True" CssClass="DropDown">
                            </asp:DropDownList>
                        </td>
                        <td width="13%" class="TDLeft">
                            <asp:Button ID="Button1" runat="server" Text="Search" onclick="Button1_Click" />
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;
                        </td>
                        <td class="TDRight" colspan="4" rowspan="3">
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False" 
                                CssClass="gridview" DataKeyNames="ReturnInvoiceId" 
                                onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ReturnInvoiceNo" HeaderText="ReturnInvoiceNo" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="CustomerCode" />
                                    <asp:BoundField DataField="TpTotal" HeaderText="TpTotal" />
                                
                                    <asp:TemplateField HeaderText="Report">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="rptImageButton" runat="server" 
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="reportData" 
                                                ImageUrl="~/images/viewlists.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
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
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                        <td class="TDLeft" width="13%">
                            &nbsp;</td>
                        <td class="TDRight" width="20%">
                            &nbsp;</td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>--%>

</asp:Content>

