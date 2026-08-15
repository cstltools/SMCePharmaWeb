<%@ Page Title="Deposit List " Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="DepositList.aspx.cs" EnableEventValidation="false" Inherits="SInventory_UI_DepositList" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
     <style>
        .star-mark {
            color: red;
        }

          .ssss {
                                                                                                                     font-size: 13px;
                                                                                                                     font-weight: bold;
                                                                          
                                               
                                                                                                                 }
    </style>
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Deposit List </div>

                <div class="ms-auto">
                    <div class="btn-group">

    

                                 <a href="DepositSlipExcelUpload.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-plus" aria-hidden="true"></i> New Entry</a>


                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">


 <%--       <div class="container-fluid" style="width: 100% !important;">

    <div class="page-body m-t-20">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
              <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                        <div class="divWaiting">
                            <asp:Image ID="imgWait7" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Pulse45.gif" Width="150px" Height="150px" />
                        </div>
                       
                    </ProgressTemplate>
                </asp:UpdateProgress>
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <div class="card main-card  pb-4">
                    <div class="card-header main-card-head">
                                <h5 class=""> <i style="color: #64B1E8!important" data-feather="grid"></i>  Proforma Invoice Print </h5>
                      

                    </div>--%>
                

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


                       <asp:HiddenField ID="HiddenField1" runat="server" />

                        <div class="row">
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">
                                                                                
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label"> Sales Center :</label>

                                    <div class="col-sm-5">
                                <asp:DropDownList ID="companyNameDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                              >
                            </asp:DropDownList>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                
                 

                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">   Deposit From Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="fromDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                          <%--  <asp:CalendarExtender ID="Date"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="InvoiceDateTextBox"
                                TargetControlID="InvoiceDateTextBox">
                            </asp:CalendarExtender>--%>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 


                                
                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">   Deposit To Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="toDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker " ></asp:TextBox>
                          <%--  <asp:CalendarExtender ID="Date"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="InvoiceDateTextBox"
                                TargetControlID="InvoiceDateTextBox">
                            </asp:CalendarExtender>--%>
                           
                           
                                    
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
                                         <asp:LinkButton runat="server"  id="SearchButton" class="btn btnMyDesignSearch   btn-sm "  onclick="Button_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="reportButton" onclick="clearButton_OnClick" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
 
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                       

                        <br/>

                            <div class="row" runat="server" visible="false">
                            <div class="col-md-8">&nbsp;</div>
                            <div class="col-md-4">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-2 col-form-label"></label>
                                    <div class="col-sm-10">


                            <asp:LinkButton ID="excelButton1" class="btn btn-sm btn-warning  mb-2 pull-right" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="btnExportToExcel_Click"><i class="fa fa-file-excel-o" aria-hidden="true"></i>&nbsp;Export to Excel  </asp:LinkButton>
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>





                            <div class="row">
                 <div class="col-md-12">
                                       <label>  </label>
                                       </div>
                                   
                                   
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                   <div class="col-md-2">
                                       
                                       
                                       </div>
                                     <div class="col-md-1">
                                       
                                       
                                       </div>
                              
                                   <div class="col-md-2"  >
                                        
                                       
                                       
                                       </div>
                                  
                                  
                                     <div class="col-md-3">
                                       
                                        <asp:Label ID="lblCount" runat="server" CssClass="ssss btn bg-info pull-right"   Text="Total Amount: 0" ></asp:Label>
                                      
                                       
        
  </div>
                     </div>
                                            <br />


                           <div class="row">
              <div class="table-responsive" id="MainGradeDiv">
                     
                          
                                <asp:GridView ID="invoiceGridView" runat="server" OnPreRender="gv_DocumentUpload_PreRender" AutoGenerateColumns="False" class="table table-striped table-bordered table-hover"  
                                DataKeyNames="DepositId,DepositDate"  onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Unit Name" />
                                    <asp:BoundField DataField="DepositType" HeaderText="Deposit Type" />
                                    <asp:BoundField DataField="BankName" HeaderText="Bank Name" />
                                    <asp:BoundField DataField="AccountName" HeaderText="Account Number" />
                                    <asp:BoundField DataField="BranchName" HeaderText="Branch Name" />
                                    <asp:BoundField DataField="CheckNumber" HeaderText="Instrument Number" />
                                    <asp:BoundField DataField="CheckDate" HeaderText="Instrument Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="DepositDate" HeaderText="Deposit Date" DataFormatString="{0:dd-MMM-yyyy}" />     
                                    <asp:BoundField DataField="EmpMasterCode" HeaderText="Emp. ID" />
                                    <asp:BoundField DataField="EmpName" HeaderText="Emp. Name" />
                                    
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                      <asp:BoundField DataField="AIT" HeaderText="AIT" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    
                                    
                                   <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="btnEdit" runat="server" ToolTip="Edit"
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditDeposit" 
                                                ImageUrl="~/images/edit.png" Width="16px" Height="16px" />
                                            &nbsp;
                                            <asp:ImageButton ID="editImageButton" runat="server" ToolTip="Delete"
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                OnClientClick="return confirmDepositDelete();"
                                                ImageUrl="~/images/delete.png" Width="16px" Height="16px" />
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
                                </div>
      </ContentTemplate>
    </asp:UpdatePanel>

        <script>

            var depositListScrollLeft = 0;

            function saveDepositListScrollPosition() {
                var tableDiv = document.getElementById('MainGradeDiv');
                if (tableDiv) {
                    depositListScrollLeft = tableDiv.scrollLeft;
                }
            }

            function restoreDepositListScrollPosition() {
                window.setTimeout(function () {
                    var tableDiv = document.getElementById('MainGradeDiv');
                    if (tableDiv) {
                        tableDiv.scrollLeft = depositListScrollLeft;
                    }
                }, 0);
            }

            function confirmDepositDelete() {
                saveDepositListScrollPosition();
                return confirm('Are you sure you want to delete this deposit slip?');
            }

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
                    prm.add_beginRequest(function (sender, e) {
                        saveDepositListScrollPosition();
                    });

                    prm.add_endRequest(function (sender, e) {
                        if (sender._postBackSettings.panelsToUpdate != null) {
                            table = $('#ContentPlaceHolder1_invoiceGridView').DataTable(
                                {
                                    "bInfo": true,
                                    "bFilter": true,
                                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                                    pageLength: 10,
                                    dom: 'lBfrtip',


                                    buttons: ['copy', 'excel', 'pdf', 'print']


                                }
                            );
                            restoreDepositListScrollPosition();
                        }
                    });
                };


                table.columns().every(function () {
                    var that = this;


                });
            });


        </script>


            <div runat="server" visible="false"> 
                <table width="100%" class="TableWorkArea">
                    <tr>
                        <td colspan="6" class="TableHeading">
                            Deposit List
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    <tr>
                        <td width="13%" class="TDLeft">
                            &nbsp;</td>
                        <td width="20%" class="TDRight">
                        <%--    <asp:ImageButton ID="ListImageButton" runat="server" 
                                ImageUrl="~/images/addnew.jpg" onclick="ListImageButton_Click" />--%>
                        </td>
                        <td width="13%" class="TDLeft">
                        </td>
                        <td width="20%" class="TDRight">
                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#009900"></asp:Label>
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
                        <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                            Sales Center:<span class="star-mark"> * </span>
                        </td>
                        <td width="20%" class="TDRight">
                         <%--   <asp:DropDownList ID="companyNameDropDownList" Width="180px" runat="server" CssClass="DropDown">
                            </asp:DropDownList>--%>
                        </td>
                        
                        <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                           Deposit from date: <span class="star-mark"> * </span>
                        </td>
                        <td width="20%" class="TDRight">
                          <%--  <asp:TextBox ID="fromDateTextBox" runat="server" Width="145px" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton ID="imgDate" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="4" />
                            <asp:CalendarExtender ID="Date" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgDate"
                                TargetControlID="fromDateTextBox">
                            </asp:CalendarExtender>--%>
                        </td>
                        
                        <td width="13%" class="TDLeft" style="text-align: right; padding-right: 10px;">
                            Deposit to date: <span class="star-mark"> * </span>
                        </td>
                        <td width="20%" class="TDRight">
                            <%--<asp:TextBox ID="toDateTextBox" runat="server" Width="145px" CssClass="TextBoxCalander"></asp:TextBox>
                            <asp:ImageButton ID="ImageButton1" runat="server" AlternateText="Click to show calendar"
                                ImageUrl="~/Images/Calendar_scheduleHS.png" TabIndex="5" />
                            <asp:CalendarExtender ID="CalendarExtender12" runat="server" Format="dd-MMM-yyyy" PopupButtonID="ImageButton1"
                                TargetControlID="toDateTextBox">
                            </asp:CalendarExtender>--%>
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
                        </td>
                        <td width="20%" class="TDRight">
                            
                     <%--       <asp:Button ID="Button1" runat="server" CssClass="button-margin-right" OnClick="Button_Click" Text="Search" />
                            <asp:Button ID="clearButton" runat="server" Text="Clear" CssClass="margin-right"
                                OnClick="clearButton_OnClick" BackColor="#F47322" />--%>
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
                           <%-- <asp:Button ID="excelButton1" runat="server" Text="Export to Excel" OnClick="btnExportToExcel_Click" />--%>
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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
                    <tr>
                        <td class="TDLeft" colspan="6">
                            
                            <%--<div id="gridContainer" style=" text-align: center; height: auto; overflow: auto; width: 97%; margin: 0 auto; ">
                                
                                <asp:GridView ID="invoiceGridView" runat="server" AutoGenerateColumns="False" CssClass="gridview" ShowFooter="True"
                                DataKeyNames="DepositId"  onrowcommand="loadGridView_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ComUnitName" HeaderText="Unit Name" />
                                    <asp:BoundField DataField="DepositType" HeaderText="Deposit Type" />
                                    <asp:BoundField DataField="BankName" HeaderText="Bank Name" />
                                    <asp:BoundField DataField="AccountName" HeaderText="Account Name" />
                                    <asp:BoundField DataField="BranchName" HeaderText="Branch Name" />
                                    <asp:BoundField DataField="CheckNumber" HeaderText="Check Number" />
                                    <asp:BoundField DataField="CheckDate" HeaderText="Check Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="DepositDate" HeaderText="Deposit Date" DataFormatString="{0:dd-MMM-yyyy}" />                                    
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                                      <asp:BoundField DataField="AIT" HeaderText="AIT" />
                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                                    
                                    
                                   <asp:TemplateField HeaderText="Delete">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="editImageButton" runat="server" ToolTip=""
                                                CommandArgument="<%# Container.DataItemIndex %>" CommandName="EditData" 
                                                ImageUrl="~/images/delete.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                                 
                            </div>--%>
                            
                        </td>
                    </tr>
                      </ContentTemplate>
    </asp:UpdatePanel>

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
                            &nbsp;
                        </td>
                        <td width="20%" class="TDRight">
                        </td>
                    </tr>
                </table>
            </div>
      
</asp:Content>

