<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="SCPickingGenerate.aspx.cs" Inherits="SInventory_UI_SCPickingGenerate" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=3.0.20820.28364, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
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
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> SC Picking Generate </div>

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
                                    <label for="mainName" class="col-sm-3 col-form-label"> Sales Center :</label>

                                    <div class="col-sm-5">

                                                   <asp:DropDownList ID="dcDropDownList1" runat="server"    CssClass="form-select form-select-sm mb-3 mySelect2" 
                                AutoPostBack="True" onselectedindexchanged="dcDropDownList1_SelectedIndexChanged"
                                >
                            </asp:DropDownList>
                                                                 
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row" runat="server" Visible="false">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Manufacturer :</label>

                                    <div class="col-sm-5">
                                                           
            

                                              <asp:DropDownList ID="manufacturerDropDownList" runat="server" AutoPostBack="True"
                                 CssClass="form-select form-select-sm mb-3 mySelect2" 
                                onselectedindexchanged="manufacturerDropDownList_SelectedIndexChanged" >
                            </asp:DropDownList>

                        


                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  
                 
                                   <div class="form-group row" runat="server" Visible="false">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Market :</label>

                                    <div class="col-sm-5">
                                    
                               <asp:DropDownList ID="MarketDropDownList1" runat="server" AutoPostBack="True"
                                 CssClass="form-select form-select-sm mb-3 mySelect2" 
                                onselectedindexchanged="MarketDropDownList1_SelectedIndexChanged" >
                            </asp:DropDownList>
                                                  
                                             
                                    </div>

                                    <span class="text-sm-left text-c-red">*</span>
                                </div>  

                                   <div class="form-group row">
                                    <label for="" class="col-sm-3 col-form-label">   Invoice Date :</label>

                                    <div class="col-sm-5">
                                     

                             <asp:TextBox ID="InvoiceDateTextBox" runat="server" CssClass="form-control form-control-sm  datepicker" ></asp:TextBox>
                      <%--      <asp:CalendarExtender ID="Date"  PopupPosition="TopRight"   CssClass="MyCalendar"  runat="server" Format="dd-MMM-yyyy" PopupButtonID="InvoiceDateTextBox"
                                TargetControlID="InvoiceDateTextBox">
                            </asp:CalendarExtender>--%>
                           
                           
                                    
                                    </div>
                                    <span class="text-sm-left text-c-red">*</span>
                                </div> 

                                   
                                
                                   <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">  Distribution Route :</label>

                                    <div class="col-sm-5">
                                    
                               <asp:DropDownList ID="ddlRoute" runat="server" 
                                 CssClass="form-select form-select-sm mb-3 mySelect2" 
                              >
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

                                  <asp:LinkButton ID="LinkButton2" CssClass="btn btn-sm btn-info mb-2" runat="server" OnClick="SearchButton_Click" >   <i class="fa fa-search-plus"></i>&nbsp; Search</asp:LinkButton>
                          
                                         
                                    </div>
                                </div>

                            </div>
                            <div class="col-2">&nbsp;</div>
                        </div>

                       

                        <br/>
                     <div class="row">
           <div class="table-responsive" id="MainGradeDiv">
       
                           
                   <asp:GridView ID="loadGridView" runat="server" AutoGenerateColumns="False"    CssClass="table table-bordered  text-center thead-dark" OnPreRender="gv_DocumentUpload_PreRender"
                                    DataKeyNames="InvoiceId" >
                                    <Columns>
                                        <asp:TemplateField HeaderText="#SL">
                                            <ItemTemplate>
                                                <asp:Label ID="LabelSL" Text='<%# Container.DataItemIndex + 1 %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="InvoiceNo" HeaderText="InvoiceNo" />
                                        <asp:BoundField DataField="InvoiceDate" HeaderText="InvoiceDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="OrderNo" HeaderText="OrderNo" />
                                        <asp:BoundField DataField="OrderDate" HeaderText="OrderDate" DataFormatString="{0:dd-MMM-yyyy}" />
                                        <asp:BoundField DataField="TpGrandTotal" HeaderText="Total Amount" />
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
                            <div class="col-2">&nbsp;</div>
                            <div class="col-8">

                                <div class="form-group row">
                                    <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                    <div class="col-sm-8">
                               
                            <asp:LinkButton ID="ViewButton" CssClass="btn btnMyDesignSearch   btn-sm" runat="server" OnClick="ViewButton_Click"  > <i class="fa fa-cog" aria-hidden="true"></i>&nbsp; Generate Picking</asp:LinkButton>
                            <asp:LinkButton ID="LinkButton4"  class="btn btnMyDesignReset   btn-sm"  runat="server" OnClick="cancelButton_Click"
                                ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                         
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
     </ContentTemplate>
    </asp:UpdatePanel>

     

</asp:Content>

