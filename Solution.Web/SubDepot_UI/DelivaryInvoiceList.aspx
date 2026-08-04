<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master"
    AutoEventWireup="true" CodeFile="DelivaryInvoiceList.aspx.cs" Inherits="SubDepot_UI_DelivaryInvoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

     <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

                  <asp:UpdateProgress ID="UpdateProgress1" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>   Delivery Invoice Creation  </div>

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
                                    <label for="mainName" class="col-sm-3 col-form-label">  	Sales Center :</label>

                                    <div class="col-sm-5">
                                          <asp:DropDownList ID="salesCenterDropDownList" CssClass="form-select form-select-sm mb-3 mySelect2" runat="server"  
                                AutoPostBack="True" OnSelectedIndexChanged="salesCenterDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                              
                                                                 
                                    </div>

                                   
                                </div>
                                

                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  	Sub-Depot :</label>

                                    <div class="col-sm-5">

                                               <asp:DropDownList ID="subdeportDropDownList1" runat="server" 
                      AutoPostBack="True" CssClass="form-select form-select-sm mb-3 mySelect2" 
                         ></asp:DropDownList>
                                                                 
                                    </div>

                                   
                                </div>  


                                     <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  	Manufacture :</label>

                                    <div class="col-sm-5">

                                               <asp:DropDownList ID="manufacDropDownList" runat="server"  CssClass="form-select form-select-sm mb-3 mySelect2"  AutoPostBack="True"
                                OnSelectedIndexChanged="manufacDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                                                 
                                    </div>

                                   
                                </div> 

                                     <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  	Market :</label>

                                    <div class="col-sm-5">
                                         <asp:DropDownList ID="marketDropDownList" runat="server" CssClass="form-select form-select-sm mb-3 mySelect2" OnSelectedIndexChanged="marketDropDownList_SelectedIndexChanged">
                            </asp:DropDownList>
                                              
                                                                 
                                    </div>

                                   
                                </div> 


                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  </label>

                                    <div class="col-sm-5">

                                              

                                   <asp:LinkButton runat="server"  id="btnSearch" class="btn btnMyDesignSearch   btn-sm "  onclick="Button1_Click">  <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                                  
                                
                               <asp:LinkButton  runat="server" class="btn btnMyDesignReset   btn-sm"   id="resetBtn" onclick="resetBtn_Click" ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                
                       
                                                        
                                    </div>

                                   
                                </div> 

                                </div>  
                                </div>  


                        <div style="padding-top:10px;"></div>
                                             <div class="table-responsive" id="MainGradeDiv">
                                                  <asp:GridView ID="orderGridView" runat="server" AutoGenerateColumns="False"  
                                DataKeyNames="ComUnitId,ManufacId,OrderId,InvoiceId" CssClass="table table-striped table-bordered" OnPreRender="gv_DocumentUpload_PreRender">
                                <Columns>
                                    <asp:BoundField DataField="OrderCode" HeaderText="Order No" />
                                    <asp:BoundField DataField="SubmissionDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                    <asp:BoundField DataField="MarketName" HeaderText="Market" />
                                    <asp:BoundField DataField="MIOCode" HeaderText="MIO Code" />
                                    <asp:BoundField DataField="MIOName" HeaderText="MIO Name" />
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice Code" />
                                    <asp:BoundField DataField="InvoiceDate" HeaderText="InvoiceDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                      <asp:BoundField DataField="TpGrandTotal" HeaderText="Net Amount" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="statusDropDownList" runat="server" AutoPostBack="True" OnTextChanged="statusDropDownList_OnTextChanged">
                                                <asp:ListItem>Full</asp:ListItem>
                                                <asp:ListItem>Partial</asp:ListItem>
                                                <asp:ListItem>Reject</asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Submit">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="reasonReturnDropDownList" Visible="False" runat="server" CssClass="TextBoxMini" >
                                                 <asp:ListItem Value="1">Cash Short</asp:ListItem>
                                                 <asp:ListItem Value="2">No Order</asp:ListItem> 
                                                   <asp:ListItem Value="3">Wrong Order</asp:ListItem>
                                                 <asp:ListItem Value="4">Damaged  Broken</asp:ListItem> 
                                                   <asp:ListItem Value="5">Quality Issue</asp:ListItem>
                                                 <asp:ListItem Value="11">Shop Closed</asp:ListItem> 
                                                   <asp:ListItem Value="6">Order Cancelled</asp:ListItem>
                                                 <asp:ListItem Value="7">Slow Moving</asp:ListItem> 
                                                   <asp:ListItem Value="8">Price Error</asp:ListItem>
                                                 <asp:ListItem Value="9">Return Others</asp:ListItem> 
                                                     <asp:ListItem Value="10">Date Expired</asp:ListItem> 
                                                 
                                                 
                                                 
                                                  </asp:DropDownList>
                                            <contenttemplate>
                                                    <asp:Button ID="gotoinvoiceButton" runat="server" Text="Submit" OnClick="gotoinvoiceButton_Click"
                                                        OnClientClick="return confirm('Are you sure you want to Submit ?');" />
                                                </contenttemplate>
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
            </ContentTemplate>
         </asp:UpdatePanel>
    
</asp:Content>
