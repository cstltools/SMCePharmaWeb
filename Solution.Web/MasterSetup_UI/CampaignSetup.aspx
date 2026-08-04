<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CampaignSetup.aspx.cs" Inherits="MasterSetup_UI_CampaignSetup" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<style type="text/css">
        /*AutoComplete flyout */
        .autocomplete_completionListElement {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto!important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 300px !important;

            overflow: auto!important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35)!important;
        }
         .chkChoice label {
            padding-left: 5px;
            padding-right: 6px;
                  font-size: 16px;
                  font-weight: bold;
        }

         .autocomplete_completionListElement222 {
            margin: 0px !important;
            background-color: White !important;
            color: windowtext !important;
            border: buttonshadow !important;
            border-width: 1px !important;
            border-style: solid !important;
            cursor: 'default' !important;
            overflow: auto!important;
            font-family: Calibri !important;
            font-size: 14px !important;
            text-align: left !important;
            list-style-type: none !important;
            margin-left: 0px !important;
            padding-left: 0px !important;
            max-height: 200px !important;
            width: 600px !important;

            overflow: auto!important;
            box-shadow: 0 0 3px 1px rgba(0,0,0,.35)!important;
        }
        /* AutoComplete highlighted item */

        .autocomplete_highlightedListItem {
            
            
              
    
            background-color: #17A2B8 !important;
            color: white !important;
            padding: 6px !important;
            font-weight: bold !important;
    
    
        }

        /* AutoComplete item */

        .autocomplete_listItem {
            padding: 6px !important;
            cursor: pointer !important;
            font-weight: bold !important;
            background-color: #fff !important;
            border-bottom: 1px solid #d4d4d4 !important; 
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset !important;
        }
    </style>

      <div id="popDiv">

</div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Campaign Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../MasterSetup_UI/CampaignView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">

                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                         <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
 <asp:HiddenField runat="server" ID="id_mastetID"/>

                                        <div class="row">

                                            <div class="col-6">
                                                <div class="form-group row">

                                                    <label for="mainName" class="col-sm-4 col-form-label">Campaign Name: </label>

                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                        <asp:TextBox   runat="server"   class="form-control form-control-sm "  id="txtCampaignName" placeholder="Campaign Name"></asp:TextBox>

                                                        <span id="v-txtCampaignName" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                            </div>


                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-4 col-form-label"> Customer Type: </label>

                                                    <div class="col-sm-8">

                                                         <div class="input-group">
                                                   <%--     <asp:DropDownList  runat="server"  ID="ddlChemistType" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>--%>
                                                              <asp:ListBox runat="server" ID="ddlChemistType" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="BrandSelect"></asp:ListBox>
                                                              <script type="text/javascript">
                                                                  function pageLoad() {


                                                                      $('.multiple-select').select2({
                                                                          includeSelectAllOption: true,
                                                                          theme: 'bootstrap4',
                                                                          width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                                          placeholder: $(this).data('placeholder'),
                                                                          allowClear: Boolean($(this).data('allow-clear')),
                                                                      });


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

                                                                  var dateNow = new Date();
                                                                  $('.datepickess').datepicker("setDate", dateNow);
                                                                  minDate: new Date() // to disable privious dates 
                                                              </script>

                                                        <span id="v-ddlChemistType" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
<span class="input-group-text text-c-red">*</span>

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>
                                        </div>


                                        <div style="padding:2px!important"></div>

                                        <div class="row">




                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-4 col-form-label"> Campaign Type: </label>

                                                    <div class="col-sm-8">
                                                         <div class="input-group">
                                                       <asp:DropDownList  runat="server"  ID="ddlCampaignType" AutoPostBack="true" OnSelectedIndexChanged="ddlCampaignType_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                        <span id="v-ddlCampaignType" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
<span class="input-group-text text-c-red">*</span>

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div> 


                                              <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-4 col-form-label"> Campaign Category: </label>

                                                    <div class="col-sm-8">

                                                         <div class="input-group">
                                                        <asp:DropDownList  runat="server"  ID="ddlCampaignCategory" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
                                                               <span id="v-ddlCampaignCategory" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
<span class="input-group-text text-c-red">*</span>

                                                             </div>
                                                             </div>
                                                             </div>
 
                                        </div>
                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-4 col-form-label"> Payment Type: </label>

                                                    <div class="col-sm-8" style="margin-top:5px!important">
                                                         <div class="input-group">
                                                      <asp:RadioButtonList CssClass="radioChoice" ID="rbPaymentOptions" runat="server" RepeatDirection="Horizontal"  >
    <asp:ListItem Text="COD" Value="COD"></asp:ListItem>
    <asp:ListItem Text="NCOD" Value="NCOD"></asp:ListItem>
    <asp:ListItem Text="Both"  Value="Both"></asp:ListItem>
</asp:RadioButtonList>
                                                     
<span class="input-group-text text-c-red">*</span>

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>
                                          <div style="padding:2px!important"></div>

                                        <div class="row">




                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="ddlProLine" class="col-sm-3 col-form-label"> Product Line: </label>

                                                    <div class="col-sm-7">
                                                         <div class="input-group">
                                                       <asp:DropDownList  runat="server"  ID="ddlProLine" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>

                                                        <span id="Span1" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
<span class="input-group-text text-c-red">*</span>

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>
 
                                        </div>

                                      <div style="padding:2px!important"></div>


                                        <div class="row" id="divProduct"   runat="server" visible="false">
                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-6 col-form-label">Product: </label>

                                                    <div class="col-sm-5">

                                                         <div class="input-group">
                                                        <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 "   ID="ddlProduct"></asp:DropDownList>

                                                        <span id="v-ddlProduct" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
                                            <div class="col-6" runat="server" id="DivPrdQty" visible="false">
                                                <div class="form-group row">
                                                    <label for="txtProductQty"  id="lblProQty" runat="server" class="col-sm-3 col-form-label">  Quantity: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                     <asp:TextBox   runat="server"   class="form-control form-control-sm mb-3 "   id="txtProductQty" placeholder=""></asp:TextBox>
                                                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                                                                        Enabled="True" TargetControlID="txtProductQty" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                                        <span id="v-txtProductQty" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                 
                                                </div>
                                            </div>



                                        </div>

                                        <div style="padding:2px!important"></div>


                                        <div class="row" id="divAmount"    runat="server" visible="false">
                                            <div class="col-6">


                                                     <div class="form-group row">
                                                    <label for="mainName" class="col-sm-6 col-form-label">  </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">

                                                                <asp:CheckBox ID="chkIsRatioWiseIncrement" runat="server" CssClass="chkChoice" Text="Ratio wise Increment" /> 

                                              </div>
                                                    </div>
                                                   
                                                </div>

                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-6 col-form-label">Min Amount: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">

                                                          
                                                       <asp:TextBox   runat="server"   class="form-control form-control-sm mb-3 "   id="txtAmount" placeholder="Min Amount"></asp:TextBox>
                                                             <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="txtAmount" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                                        <span id="v-txtAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Max Amount: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                        <asp:TextBox   runat="server"   class="form-control form-control-sm mb-3 "   id="txtMaxAmount" placeholder="Max Amount"></asp:TextBox>
                                                              <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtMaxAmount" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                                        <span id="v-txtMaxAmount" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>



                                        </div>




                                      
                                        <div style="padding:2px!important"></div>

                                        <div class="row">

                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-6 col-form-label"> Valid From Date: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                   <asp:TextBox  runat="server"  id="frmDate"   type="datetime-local"     class="form-control form-control-sm mb-3 "  autocomplete="off" placeholder="Select Date" 
                                                       ></asp:TextBox>
                                                        <span id="v-frmDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                    
                                                </div>
                                            </div>
                                           

                                            <div class="col-6">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label"> Valid To Date: </label>

                                                    <div class="col-sm-5">
                                                         <div class="input-group">
                                                     <asp:TextBox   runat="server"   id="toDate"  type="datetime-local"  class="form-control form-control-sm mb-3 datepickess"  autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                                        <span id="v-toDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>

<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                  
                                                </div>
                                            </div>
                                        </div>

                                        <div style="padding:2px!important"></div>

                                        <div class="row" style="display:none">

                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-5 col-form-label">   </label>
                                                    <div class="form-check form-check-inline">
                                                        <label class="form-check-label">
                                                            <input type="radio" class="form-check-input" name="optionsRadios5" id="optionsRadios5" value="option5">
                                                            For Cash
                                                            <i class="input-frame"></i>
                                                        </label>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>

                                                    <div class="form-check form-check-inline">
                                                        <label class="form-check-label">
                                                            <input type="radio" class="form-check-input" name="optionsRadios5" id="optionsRadios6" value="option5">
                                                            For Credit
                                                            <i class="input-frame"></i>
                                                        </label>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>

                                                    <div class="form-check form-check-inline">
                                                        <label class="form-check-label">
                                                            <input type="radio" class="form-check-input" name="optionsRadios5" id="optionsRadios6" value="option5">
                                                            Cash / Credit
                                                            <i class="input-frame"></i>
                                                        </label>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>

                                                </div>
                                            </div>



                                        </div>
                                     <asp:HiddenField runat="server" ID="HiddenField1"/>
    <style>
  .radioChoice label {
    padding-left: 5px;
    padding-right: 2px;
          
          font-weight: bold;
}
        </style>

                                        <div class="row">

                                            <div class="col-6">
                                                <div class="form-group row">
                                                   <label for="exampleInputUsername2" class="col-sm-6 col-form-label">&nbsp; </label><br />

                                                    
                                                    <div class="col-sm-5">

                                                                              <asp:CheckBox runat="server" onclick="MutExChkList(this);" ID="chkTradePolicy"   Text="Trade Policy" CssClass="radioChoice"   />
               
               <asp:CheckBox runat="server" onclick="MutExChkList(this);"  ID="chkFCFS"   Text="FCFS" CssClass="radioChoice"   /> 
            
 
                                                                                                             
                                                         <%--<div class="form-check form-switch">
													<input class="form-check-input" runat="server" type="checkbox" id="chkTradePolicy" checked>
												 <label  class="custom-control-label" for="chkTradePolicy">Is Trade Policy</label>
												</div>--%>

                                                    </div>
                                                </div>
                                            </div>


                                            <div class="col-6">
                                               
                                            </div>
                                        </div>
                                        <br />
                                        <br />
                                        <div style="padding:2px"></div>
                                        <div style="padding:2px"></div>
                                        <div class="row">
                                              
                                            <div class="col-12">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-3 col-form-label">Offer Type: <span style="color:red">*</span>   </label>

                                                    <div class="col-sm-7">

                                                           <div class="input-group">
                                                        <asp:DropDownList  runat="server" id="ddlOfferType" AutoPostBack="true" OnSelectedIndexChanged="ddlOfferType_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2 "></asp:DropDownList>
 

                                              </div>

                                                    </div>
                                                   
                                                </div>
                                            </div>
                                            </div>
                                            <div class="row">
                                              

                                            <div class="col-6" id="divProductList"  runat="server" visible="false">
                                                <div class="form-group row">
                                                    <label for="mainName" class="col-sm-6 col-form-label">Product:<span style="color:red">*</span>   </label>
                                                    <div class="col-sm-6">
                                                          
                                                        <asp:DropDownList  runat="server"  class="form-select form-select-sm mb-3 mySelect2 "   id="ddlProductList"></asp:DropDownList>

                                                         


                                              
                                                    </div>
                                                   
                                                </div>
                                            </div>

                                            <div class="col-6"  id="divDisType" runat="server" visible="false">
                                                <div class="form-group row">
                                                    <label for="mainName" id="lblDisType"  runat="server"  class="col-sm-6 col-form-label">   </label>
                                                    <div class="col-sm-4">
                                                         <div class="input-group">
                                                       <asp:TextBox   runat="server"   type="text" class="form-control form-control-sm mb-3"   id="txtQtyList"></asp:TextBox>
                                                                <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                                                                                        Enabled="True" TargetControlID="txtQtyList" FilterType="Custom" ValidChars="0123456789."></asp:FilteredTextBoxExtender>
                                                        <span id="v-txtQtyList" class="invalid-tooltip fade hide" data-delay="2000">
                                                        </span>
<span class="input-group-text text-c-red">*</span>

                                              </div>
                                                    </div>
                                                   
                                                </div>
                                            </div>
                                             
                                            </div>

                                                <div class="form-group row" style="margin-top:6px;" id="divBtn"  runat="server" visible="false">

                                       <label for="MarketSelect" class="col-sm-2 col-form-label">   </label>

                                    <div class="col-sm-3">

                                    

                                    </div>      
                                    <label for="MarketSelect" class="col-sm-2 col-form-label">  </label>

                                    <div class="col-sm-3">

                                          <asp:LinkButton runat="server" ID="bnAddList" class="btn btn-sm btn-success  pull-right" onclick="bnAddList_Click"><i class="fa fa-plus-circle"></i> Add to list</asp:LinkButton>
                                               
                                    </div>                                    </div>

            <br />
                                            <div class="row">

                                                <div class="col-12">
                                                    <div class="form-group row">
                                                        <label for="mainName" class="col-sm-2 col-form-label">   </label>

                                                        <div class="col-sm-8">
                                                            <div class="table-responsive" id="MainGradeDiv">
                                                                

                                                                   <asp:GridView ID="gv_ProductOffer" runat="server" AutoGenerateColumns="False"
                                                               ShowHeaderWhenEmpty="true"        CssClass="table table-bordered  text-center thead-dark"  >
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfBonusTypeId" Value='<%#Eval("BonusTypeId")%>' />

                                             <asp:HiddenField runat="server" ID="CampaignDetailId" Value='<%#Eval("CampaignDetailId")%>' />
                                             <asp:HiddenField runat="server" ID="hfProductId" Value='<%#Eval("ProductId")%>' />
                                            
                                            
                                                  
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                      
                                                <asp:TemplateField HeaderText="Offer Type">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_OfferType" runat="server" Text='<%#Eval("TypeName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Product">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_ProductName" runat="server" Text='<%#Eval("ProductName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Qty">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_Qty" runat="server" Text='<%#Eval("Qty") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Amount">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_Amount" runat="server" Text='<%#Eval("Amount") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                            
 <asp:TemplateField HeaderText="Percent Amount">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_PercentAmount" runat="server" Text='<%#Eval("PercentAmount") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                               
                                               


                                                                        <asp:TemplateField HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="BtnProductOffer" runat="server" OnClick="BtnProductOffer_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                    </Columns>
                                                                </asp:GridView>
                                                              
                                                            </div>
                                                        </div>
                                                    </div>



                                                </div>
                                            </div>



                                            <br />
                                            <br />

                                    <h4>Market Structure</h4>
                                    <hr />
<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />

                                    
                                    <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-2 col-form-label">   </label>

                                    <div class="col-sm-3">

                                    

                                    </div>      
                                    <label for="MarketSelect" class="col-sm-2 col-form-label">  </label>

                                    <div class="col-sm-3">

                                          <asp:LinkButton ID="btnAddtoListMarket" runat="server"  OnClick="btnAddtoListMarket_Click" CssClass="btn btn-sm btn-success pull-right" ><i class="fa fa-plus-circle"></i>Add To List</asp:LinkButton>

                                    </div>                                    </div>

            <br />

                 <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">


                                            <div class="table-responsive" id="MainGradeDiv2">
                                                

                                                  <asp:GridView ID="gv_Market" runat="server" AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark" ShowHeaderWhenEmpty="true" >
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfGroupId" Value='<%#Eval("GroupId")%>' />

                                             <asp:HiddenField runat="server" ID="hfRegionId" Value='<%#Eval("RegionId")%>' />
                                             <asp:HiddenField runat="server" ID="hfAreaId" Value='<%#Eval("AreaId")%>' />
                                             <asp:HiddenField runat="server" ID="hfTerritoryId" Value='<%#Eval("TerritoryId")%>' />
                                             <asp:HiddenField runat="server" ID="hfSubTerritoryId" Value='<%#Eval("SubTerritoryId")%>' />
                                             <asp:HiddenField runat="server" ID="hfMarketId" Value='<%#Eval("MarketId")%>' />
                                            
                                                  
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                      
                                                <asp:TemplateField HeaderText="Group">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_GroupName" runat="server" Text='<%#Eval("GroupName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Zone">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_RegionName" runat="server" Text='<%#Eval("RegionName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                                <asp:TemplateField HeaderText="Area">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_AreaName" runat="server" Text='<%#Eval("AreaName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Territory">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_TerritoryName" runat="server" Text='<%#Eval("TerritoryName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Sub-Territory">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_SubTerritoryName" runat="server" Text='<%#Eval("SubTerritoryName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Market">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_MarketName" runat="server" Text='<%#Eval("MarketName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        
                                               


                                                                        <asp:TemplateField HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="MarketdeleteImageButton" runat="server" OnClick="MarketdeleteImageButton_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                    </Columns>
                                                                </asp:GridView>
                                  

                                </div>

                                     </div>
                                     </div>

                                    <br />
                                    <br />

                                     <h4>Customer List</h4>
                                    <hr />

                                      <div class="row" id="divCus" runat="server">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                  <div class="form-group row">
                                    <label for="mainName" class="col-sm-3 col-form-label">Customer: </label>

                                    <div class="col-sm-5">
                                          <div class="input-group">
                                       <asp:TextBox ID="custNameTextBox" runat="server" CssClass="form-control form-control-sm mb-3 " 
                                AutoPostBack="True" ontextchanged="custNameTextBox_TextChanged"></asp:TextBox>
 

<asp:AutoCompleteExtender
                                                            ID="at_txt_JobCirculation"
                                                            TargetControlID="custNameTextBox"
                                                            runat="server"
                                                            ServiceMethod="GetCustomer_New"
                                                            ServicePath="SInventoryWebService.asmx"
                                                            MinimumPrefixLength="1"
                                                            CompletionInterval="10"
                                                            EnableCaching="false"
                                                            CompletionSetCount="1"
                                                            FirstRowSelected="false"  CompletionListCssClass="autocomplete_completionListElement" 
                                        CompletionListItemCssClass="autocomplete_listItem" 
                                        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"
                                        ShowOnlyCurrentWordInCompletionListItem="true">
                                                        </asp:AutoCompleteExtender>
                                      
                                       

                                              <asp:HiddenField ID="hfCustomerId" runat="server" />
                                          
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                           <div class="col-sm-3">

                                          <asp:LinkButton runat="server" ID="btnCustomerAdd" class="btn btn-sm btn-success  pull-right" onclick="btnCustomerAdd_Click"><i class="fa fa-plus-circle"></i> Add to list</asp:LinkButton>
                                               
                                    </div>    
                                </div>
                                </div>
                                 
                                </div>
                                        <br />

                              <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                           

 

                                            <div class="table-responsive" id="MainGradeDivCustomer" style="max-height:400px;">
                                                
                                                  <asp:GridView ID="gv_Customer" runat="server" AutoGenerateColumns="False"
                                                                ShowHeaderWhenEmpty="true"    CssClass="table table-bordered  text-center thead-dark"  >
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                             <asp:HiddenField runat="server" ID="hfCustomerMasterId" Value='<%#Eval("CustomerMasterId")%>' />
                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                                                     
                                                                         <asp:TemplateField HeaderText="Customer Name">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_CustomerName" runat="server" Text='<%#Eval("CustomerName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        <asp:TemplateField HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="deleteCustomer" runat="server" OnClick="deleteCustomer_Click" CssClass="btn-danger  btn-sm mb-1 mb-md-0"
                                                                                    ><i class='fa fa-minus' aria-hidden='true'></i></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                    </Columns>
                                                                </asp:GridView>
                                  

                                </div>

                                     </div>
                                     </div>
                                       <div class="row" id="div1" runat="server">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">
                                  <div class="form-group row">
                                 <label for="exampleInputUsername2" class="col-sm-3 col-form-label">&nbsp; </label><br />

                                    <div class="col-sm-5">
                                                
                                                
                                                    <div class="col-sm-5">
                                                        <div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" runat="server" id="chkIsActive" checked>
												 <label  class="custom-control-label" for="chkIsActive">Active</label>
												</div>


                                                    </div>
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
                                                              <asp:LinkButton  OnClick="btnSave_Click" Visible="false" OnClientClick="return sweetAlertConfirm_Submit(this);"   runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton  OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Update(this);"   >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  OnClick="Unnamed_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>

</section>

                                             <script>
                                                 function MutExChkList(chk) {
                                                     var chkList = chk.parentNode.parentNode.parentNode;
                                                     var chks = chkList.getElementsByTagName("input");
                                                     for (var i = 0; i < chks.length; i++) {
                                                         if (chks[i] != chk && chk.checked) {
                                                             chks[i].checked = false;
                                                         }
                                                     }
                                                 }
                                             </script>


                                   </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>

    
</asp:Content>

