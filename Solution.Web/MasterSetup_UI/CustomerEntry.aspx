<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="CustomerEntry.aspx.cs" Inherits="MasterSetup_UI_CustomerEntry" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructure.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <style>
        .imgshadow{

            width:100%;
            height:300px;
        
/* border: 1px solid #ddd;*/
  border-radius: 4px;
  padding: 5px;
 box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
 border: 3px #1c87c9;
        border-style: dashed;
        }
         .imgshadow:hover {
  box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
}
    </style>
        <div id="popDiv">
            

</div>
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Customer   Information</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="../MasterSetup_UI/CustomerView.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Customer  Name:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtChemistName" placeholder=" Customer  Name"></asp:TextBox>

                                          
                                                                            
    <span class="input-group-text text-c-red">*</span>
                                              </div>

                                    </div> 
                                </div>
                                           </div>

                                             <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Customer  Type:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlChemisType" ></asp:DropDownList>
                                               <script type="text/javascript">
                                                   function pageLoad() {
                                                       $('.multiple-select').select2({
                                                           includeSelectAllOption: true,
                                                           theme: 'bootstrap4',
                                                           width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                           placeholder: $(this).data('placeholder'),
                                                           allowClear: Boolean($(this).data('allow-clear')),
                                                       });
                                                       $('.mySelect2').select2({
                                                           theme: 'bootstrap4',
                                                           width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                           placeholder: $(this).data('placeholder'),
                                                           allowClear: Boolean($(this).data('allow-clear')),
                                                       });

                                                    
                                                   }
                                                  
                                                   function ImageToBase64ShopImg(image) {

                                                      
                                                       var img = image.files[0];

                                                       var fileType = file["type"];
                                                       var validImageTypes = ["image/gif", "image/jpeg", "image/png"];
                                                       if ($.inArray(fileType, validImageTypes) < 0) {
                                                           // invalid file type code goes here.
                                                       }
                                                       else {

                                                           var reader = new FileReader();
                                                           reader.onloadend = function () {

                                                               $("#ContentPlaceHolder1_imgeBase64Str").val("");
                                                               var base64result = reader.result.split(',')[1];
                                                               $("#ContentPlaceHolder1_imgeBase64Str").val(base64result);

                                                               $("#ContentPlaceHolder1_outputimage").attr("src", reader.result);
                                                               $("#ContentPlaceHolder1_hfimgShow").val(reader.result);

                                                               /* $("#fID").attr("href", img);*/
                                                           }



                                                           reader.readAsDataURL(img);
                                                       }

                                                       //  UploadImage();
                                                   }

                                                   function ImageToBase64Trade(image) {

                                                       debugger;
                                                       var img = image.files[0];
                                                       var reader = new FileReader();
                                                       reader.onloadend = function () {

                                                           $("#ContentPlaceHolder1_hfTradeBase64Str").val("");
                                                           var base64result = reader.result.split(',')[1];
                                                           $("#ContentPlaceHolder1_hfTradeBase64Str").val(base64result);

                                                           $("#ContentPlaceHolder1_Tradeimage").attr("src", reader.result);
                                                           $("#ContentPlaceHolder1_hfimgShowTrade").val(reader.result);

                                                           /* $("#fID").attr("href", img);*/
                                                       }



                                                       reader.readAsDataURL(img);

                                                       //  UploadImage();
                                                   }
                                               </script>
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

 

                                    
                                    <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Distribution Route:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlDistributionRoute" ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                         
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">Email:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtEmail" placeholder=" Email Address"></asp:TextBox>

                                          

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                                           <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Mobile:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                      <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtMobile" placeholder=" Mobile" MaxLength="11"></asp:TextBox>
                                              
                                         <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                                                                        Enabled="True" TargetControlID="txtMobile" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                         
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">Owner Name:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       
                                                <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtOwnerName" placeholder=" Owner Name"></asp:TextBox>
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>



                                            <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Address:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                      <asp:TextBox  CssClass="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="1" runat="server" id="txtAddress" placeholder=" Address"></asp:TextBox>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                         
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">NID NO:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       
                                                <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtVoterID" placeholder=" NID NO"  MaxLength="17"></asp:TextBox>
                                             <asp:FilteredTextBoxExtender ID="FilnidteredTextBoxExtenderunitValue" runat="server"
                                                                                        Enabled="True" TargetControlID="txtVoterID" FilterType="Custom" ValidChars="0123456789"></asp:FilteredTextBoxExtender>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>
                                         

                                       <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Trade License:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                      <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtTradeLicense" placeholder=" Trade License"></asp:TextBox>
                                              
                                          

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                         
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">Drug License:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       
                                                <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtDrugLicense" placeholder=" Drug License"></asp:TextBox>
                                          

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>


                                        <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">  Pharmacy Council Certificate:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                      <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtPharmacyCouncilCertificate" placeholder=" Pharmacy Council Certificate"></asp:TextBox>
                                              
                                          

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                         
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">BCDS Registration:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       
                                                <asp:TextBox  CssClass="form-control form-control-sm mb-3 " runat="server" id="txtBCDS" placeholder=" Drug License"></asp:TextBox>
                                          

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                                    <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Station Type (MIO):</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlStationType"   ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>

                                          <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Provider Type:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlProgramType" ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>

                                                 <div class="form-group row">
                                                <label for="txtNID" class="col-sm-5 col-form-label">Pharma Platform:</label>

                                                <div class="col-sm-7">
                                                    <div class="input-group">
                                                        <asp:DropDownList CssClass="form-select form-select-sm mb-3 mySelect2 " runat="server" ID="ddlPharmaPlatform"></asp:DropDownList>


                                                       

                                                    </div>

                                                </div>
                                            </div>
                                           </div>

                                        </div>



                                        <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row"  runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Station Type (AM):</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlAMStationType"   ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                            </div>

                                           <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Station Type (DZSM):</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlDZSMStationType"   ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                            </div>

                                    <div class="row" runat="server" visible="false">
                            
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label"> Product Line:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                        
                                                <asp:ListBox   runat="server"  id="ddlProLine"  SelectionMode="Multiple"   class="form-select form-select-sm mb-3 multiple-select"  name="ddlProLine"></asp:ListBox>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>

                                                       <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="ddlDoctorTag" class="col-sm-5 col-form-label">Doctor:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">

                                                <asp:ListBox runat="server" id="ddlDoctorTag" SelectionMode="Multiple" class="form-select form-select-sm mb-3 multiple-select" name="ddlDoctorTag"></asp:ListBox>

                                              </div>

                                    </div>
                                </div>
                                           </div>
                                         
                                       <div class="col-6">
                                <div class="form-group row">
                                    <label for="txtNID" class="col-sm-5 col-form-label">Remarks:</label>

                                    <div class="col-sm-7">
                                          <div class="input-group">
                                       
                                                <asp:TextBox  CssClass="form-control form-control-sm mb-3 " TextMode="MultiLine" Rows="2" runat="server" id="txtRemarks" placeholder=" Remarks"></asp:TextBox>
                                         
     

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                           </div>
                                    <br />
                                      <h4>Market Structure</h4>
                                    <hr />

                                    <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-4 col-form-label"> Distribution Center:</label>

                                    <div class="col-sm-6">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlDistributionCenter" ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>
                                    <uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                      <br />
                                      <br />
                                      <br />
                                        <div class="row" style="padding-top:20px;">

                                        </div>
                                      <br />

                                    <div class="row">
                            
                                       <div class="col-6">
                                <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-4 col-form-label"> Division:</label>

                                    <div class="col-sm-6">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlDivision" AutoPostBack="true" OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged" ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>


                                            <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-4 col-form-label"> District:</label>

                                    <div class="col-sm-6">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 " AutoPostBack="true" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged"  runat="server" id="ddlDistrict" ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>

                                            <div class="form-group row" runat="server" visible="false">
                                    <label for="txtNID" class="col-sm-4 col-form-label"> Thana:</label>

                                    <div class="col-sm-6">
                                          <div class="input-group">
                                       <asp:DropDownList  CssClass="form-select form-select-sm mb-3 mySelect2 "  runat="server" id="ddlThana" ></asp:DropDownList>
                                              
                                         
    <span class="input-group-text text-c-red">*</span>

                                              </div>

                                    </div> 
                                </div>
                                           </div>

                                          <div class="col-6">
                               
                                           </div>

                                        </div>



                                      

                                    <br />
                                      <div class="row">
                            
                                       <div class="col-6">
                                    <div class="form-group row">
                                  <label for="chkIsActive" class="col-sm-4 col-form-label">&nbsp; </label><br />

                                    <div class="col-sm-6">
                                          <div class="input-group">
                                       
                                                      <div class="form-check form-switch">
													<input class="form-check-input" runat="server" type="checkbox" id="chkIsActive" checked>
													 <label  class="custom-control-label" for="chkIsActive">Active</label>
												</div>         

                                              </div>

                                    </div> 
                                </div>
                                </div>
                                </div>

                                    <br />
                                   <div class="form-group row">
                                       <label for="MeterImage" class="col-sm-1 col-form-label"></label>
                                   <h4 class="col-sm-3"> Images</h4>   
                              
                                       </div>
                                <hr />
                                <div class="form-group row" style="margin-top:6px;">


                                    <label for="MeterImage" class="col-sm-2 col-form-label">Shop Image:  </label>

                                    <div class="col-sm-4">
                                         <div class="input-group"  runat="server" visible="false">

                                        <input type="file" id="ShopImgUploadForm" name="image" accept="image/*" class="form-control form-control-sm mb-3 " onchange="ImageToBase64ShopImg(this)" />

                                        <span id="v-ShopImgUploadForm" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                               <span class="input-group-text text-c-red">*</span>
                                                    </div>



                                    </div>


                                      <label for="MeterImage" class="col-sm-2 col-form-label">Trade License Image:  </label>

                                    <div class="col-sm-4" runat="server" visible="false">
                                         <div class="input-group">

                                        <input type="file" id="TradeLicenseimageUploadForm" name="image" accept="image/*" class="form-control form-control-sm mb-3 " onchange="ImageToBase64Trade(this)" />

                                        <span id="v-TradeLicenseimageUploadForm" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                               <span class="input-group-text text-c-red">*</span>
                                                    </div>



                                    </div>
                                   






                                </div>
                                        <div class="row">
                            <div class="col-sm-2">&nbsp;</div>
                            <div class="col-4">
                                <asp:Image runat="server" id="outputimage" class="imgshadow"  />
                            </div>
                             
                            <div class="col-sm-2">&nbsp;</div>
                            <div class="col-4">
                               <asp:Image runat="server"  id="Tradeimage" class="imgshadow"  />
                            </div>
                            </div>
                                    <br />
                                       
                            <div class="row" style="padding-top:20px">
                                <div class="col-2">&nbsp;</div>
                                <div class="col-7">
                                    <asp:HiddenField runat="server" ID="hfimgShowTrade"   />
                                    <asp:HiddenField runat="server" ID="hfimgShow"   />
                                    <asp:HiddenField runat="server" ID="hfTradeBase64Str"   />
                                    <asp:HiddenField runat="server" ID="imgeBase64Str"   />
                                    <div class="form-group row">
                                        <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                        <div class="col-sm-9">
                                                              <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Submit(this);"  OnClick="btnSave_Click" Visible="false"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton   OnClientClick="return sweetAlertConfirm_Update(this);"   OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"   ID="btnReset" OnClick="btnReset_OnClick" class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="col-2">&nbsp;</div>
                                            </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>


</asp:Content>

