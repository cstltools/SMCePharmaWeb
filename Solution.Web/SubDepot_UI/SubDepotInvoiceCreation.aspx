<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SubDepotInvoiceCreation.aspx.cs" Inherits="SubDepot_UI_SubDepotInvoiceCreation" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>  Proforma Invoice Creation </div>

                <div class="ms-auto">
                    <div class="btn-group">
                        
<%-- <asp:LinkButton ID="viewLinkButton"    class="btn btn-sm btn-sm btn-outline-info" 
                                OnClick="viewLinkButton_OnClick" runat="server"> <i class="fa fa-backward"></i>&nbsp;Back to List</asp:LinkButton>--%>

                    
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
             
    
                              <div id="hiddiv" runat="server" Visible="false">
                    
                      
                            
                        
                            <asp:DropDownList ID="TERRITORYDropDownList1" Visible="false" runat="server" AutoPostBack="True"
                                CssClass="DropDown" 
                               >
                            </asp:DropDownList>
                        
                    </div>

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
                                    <label for="mainName" class="col-sm-3 col-form-label">  	Sales Center:</label>

                                    <div class="col-sm-5">
                                          <asp:DropDownList ID="salesCenterDropDownList" runat="server" 
                                CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True" 
                                onselectedindexchanged="salesCenterDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                                  
                                      <%--  <asp:DropDownList ID="dcDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2"  
                        AutoPostBack="True" 
                        onselectedindexchanged="dcDropDownList_SelectedIndexChanged"></asp:DropDownList>--%>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   
                 
                                  

                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">    	 Sub-Depot :</label>

                                    <div class="col-sm-5">
                                      <asp:DropDownList ID="subdeportDropDownList1" runat="server" 
                        CssClass="form-select form-select-sm mb-3 mySelect2" AutoPostBack="True"
                         ></asp:DropDownList>
 
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 

                                    <div class="form-group row" >
                                                <label for="mainName" class="col-sm-3 col-form-label">Route:</label>

                                                <div class="col-sm-5">


                                                    <asp:DropDownList ID="rootDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2   "
                                                            >
                                                    </asp:DropDownList>


                                                </div>
                                                <span class="text-sm-left text-c-red">*</span>
                                            </div>


                                                <div class="form-group row" >
                                    <label for="" class="col-sm-3 col-form-label">    	Manufacture:</label>

                                    <div class="col-sm-5">
                                         <asp:DropDownList ID="manufacDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" 
                                onselectedindexchanged="manufacDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
   
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 
                                   
                                     <div class="form-group row"  runat="server" visible="false">
                                    <label for="" class="col-sm-3 col-form-label">    	Market:</label>

                                    <div class="col-sm-5">
                                      <asp:DropDownList ID="marketDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" 
                                onselectedindexchanged="marketDropDownList_SelectedIndexChanged">
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
                                          
                                  <asp:LinkButton ID="Button1" CssClass="btn btn-sm btn-info mb-2" runat="server" OnClick="Button1_Click" >   <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>
                                                       <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-3">&nbsp;</div>

                                           <div class="col-3">
                                              
                                               
                                               
                                                     <asp:LinkButton ID="reportButton" class="btn btn-sm   mb-2  pull-right" style="background-color: #1A7343; color: #fff;" runat="server" OnClick="viewRptButton_Click"
                                                ><i class="fa fa-print" aria-hidden="true"></i>&nbsp; Print Report </asp:LinkButton>
                                              </div>
                                        <div class="col-2">

                                                <div class="form-group row">
                                                    
                                                             <asp:TextBox runat="server" ID="batchno" placeholder=" Batch NO" CssClass="form-control form-control-sm mb-3"></asp:TextBox>
                                              
                                                    </div>
                                              <div class="form-group row">
                                                   <asp:LinkButton ID="invoiceButton" runat="server"  onclick="invoiceButton_Click" CssClass="btn btn-sm btn-success mb-2 pull-right" ><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Generate Invoice</asp:LinkButton>
                                                  <//div>
                                                

                                        </div>
                                          
                                      
                                       
                                    </div>


                       

                        <br/>
                     <div class="row">
           <div class="table-responsive" id="MainGradeDiv">

                    <asp:GridView ID="orderGridView" runat="server" AutoGenerateColumns="False" 
                               ShowFooter="True" CssClass="table table-bordered  text-center thead-dark" DataKeyNames="ComUnitId,ManufacId,OrderId" >
                                <Columns>
                                    <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                    <asp:BoundField DataField="SubmissionDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}"/>
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                    <%--<asp:BoundField DataField="SalesCenterCode" HeaderText="Sales Center Code" />
                                    <asp:BoundField DataField="SalesCenterName" HeaderText="Sales Center Name" />--%>
                                    <asp:BoundField DataField="MIOCode" HeaderText="MIO Code" />
                                      <asp:BoundField DataField="MIOName" HeaderText="MIO Name" />
                                        <asp:BoundField DataField="TerritoryCode" HeaderText="Territory Code" />
                                      <asp:BoundField DataField="GrossValue" HeaderText="Gross Value(TP)" />
                                        <asp:BoundField DataField="CustomerType" HeaderText="Customer Type" />
                                    <asp:TemplateField HeaderText="Go To Invoice">
                                        <ItemTemplate>
                                            <asp:Button ID="gotoinvoiceButton" runat="server" Text="Go To Invoice"  CssClass="button"
                                                onclick="gotoinvoiceButton_Click" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True"
                                                          OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" AutoPostBack="True" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
       </div>
       </div>

                       </ContentTemplate>
        </asp:UpdatePanel>

     

</asp:Content>

