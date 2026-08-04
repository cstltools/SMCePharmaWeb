<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="Market_Transfer.aspx.cs" Inherits="TransferUI_Market_Transfer" %>


<%@ Register Src="~/TransferUI/IVMarketStructureFrom_ToTranser.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
<%@ Register Src="~/TransferUI/IVMarketStructureFrom_ToTranser.ascx" TagPrefix="uc1" TagName="IVMarketStructureTo" %> 



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        
        .Label_Title {
            background-color: #C7C7C7;
            width: 100%;
            text-align: center;
            margin: 0px;
            padding: 3px;
            text-align: center;
            color: #000;
            margin-right: 5%;
            font-weight: bold;
            font-size: 13px;
        }
          .chkChoice label {
            padding-left: 10px;
            padding-right: 30px;
        }
          .radioChoice label {
            padding-left: 5px;
            padding-right: 30px;
                  font-size: 20px;
                  font-weight: bold;
        }

       .SelectchkChoice label {
            padding-left: 6px;
            font-weight: bold;
        }

    </style>
      <div id="popDiv">

</div>
    
     <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Market Transfer</div>

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
                              <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                      <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                             <div class="row">
                                  
              			
				
				 
                                  <div class="col-md-12" style="text-align:center">
                
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
                  </div>


                                 </div>

                                    <br />
                              <div class="row">

                                  <div class="col-md-6">
                                      <fieldset class="for-panel">
                                                            <legend>From</legend>
<uc1:IVMarketStructure runat="server" ID="IVMarketStructure" />
                                           <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-3 col-form-label">   </label>

                                    <div class="col-sm-8">
                                           <div class="input-group">
                                            
                                               <asp:LinkButton runat="server" id="btnSearch" class="btn btnMyDesignAddtoList   btn-sm pull-left"  onclick="btnSearch_Click">
                                               <i class="fa fa-search-plus"></i>Search &nbsp; 
                                </asp:LinkButton>

  <span class="input-group-text text-c-red">&nbsp;</span>

                                           </div>
                                           </div>
                                           </div>
                                          </fieldset>
                                  </div>
                                  <div class="col-md-6">
                                       <fieldset class="for-panel">
                                                            <legend>To</legend>
<uc1:IVMarketStructureTo runat="server" ID="IVMarketStructureTo" />


                                              
 


                                            </fieldset>
                                  </div>

                                  </div>



                                      <br />
                              <div class="row">
                           
                                       <div class="col-12">

                                           

                                                 <div class="row">
                                                            <div class="col-md-12">
                                                               
                                                                <div class="Label_Title">Market List</div>
                                                              
                                                                <div class="form-group">
                                                                    <div style="overflow: scroll; height: 230px">
                                                                         <asp:CheckBox runat="server" ID="chkMarket" CssClass="SelectchkChoice" AutoPostBack="True" OnCheckedChanged="chkMarket_CheckedChanged" Text=" Select All / Unselect All" />
                                                                        <br />
                                                                        <asp:CheckBoxList ID="chkListMarket"  CssClass="chkChoice" RepeatColumns="4" RepeatDirection="Horizontal" runat="server"></asp:CheckBoxList>
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
                                


                                        
                                                         <asp:LinkButton  OnClick="btnSave_Click"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm" OnClientClick="return sweetAlertConfirm_Submit(this);"    >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  id="btnReset"  OnClick="btnReset_Click" class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
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

