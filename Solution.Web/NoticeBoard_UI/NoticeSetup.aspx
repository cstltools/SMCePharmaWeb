<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="NoticeSetup.aspx.cs" Inherits="NoticeBoard_UI_NoticeSetup" %>

<%@ Register Src="~/MasterSetup_UI/IVMarketStructureForTeritory.ascx" TagPrefix="uc1" TagName="IVMarketStructure" %> 
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
    
<style>

</style>



    
        <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i>Notice Setup</div>

                <div class="ms-auto">
                    <div class="btn-group">


                        <a href="NoticeRecords.aspx" class="btn btn-sm btn-sm btn-outline-info"><i class="fa fa-backward"></i>&nbsp;Back to List</a>


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
                                        <script type="text/javascript">
                                     <%--  window.onload = function () {
                                           CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                       }--%>

                                            function pageLoad() {
                                                $('.datepicker').pickadate({
                                                    selectMonths: true,
                                                    selectYears: true
                                                })

                                                $('.multiple-select').select2({
                                                    includeSelectAllOption: true,
                                                    theme: 'bootstrap4',
                                                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                    placeholder: $(this).data('placeholder'),
                                                    allowClear: Boolean($(this).data('allow-clear')),
                                                });




                                        <%--   //CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');--%>
                                           //CKEDITOR.replace('ContentPlaceHolder1_TrainningMeterial');
                                         <%--  var prm = Sys.WebForms.PageRequestManager.getInstance();
                                           if (prm != null) {
                                               prm.add_endRequest(function (sender, e) {
                                                   if (sender._postBackSettings.panelsToUpdate != null) {
                                                       CKEDITOR.remove(CKEDITOR.instances['<%=TrainningMeterial.ClientID %>']);
                                                       CKEDITOR.replace('<%=TrainningMeterial.ClientID %>');
                                                       OpenModal();
                                                   }
                                               });
                                           } else {
                                              
                                           }
                                           ;--%>
                                                $('.mySelect2').select2({
                                                    theme: 'bootstrap4',
                                                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style',
                                                    placeholder: $(this).data('placeholder'),
                                                    allowClear: Boolean($(this).data('allow-clear')),
                                                });
                                            }


                                            function ImageToBase64ShopImg(image) {



                                                var img = image.files[0];
                                                var reader = new FileReader();
                                                reader.onloadend = function () {
                                                    $("#ContentPlaceHolder1_imgeBase64Str").val("");
                                                    $("#ContentPlaceHolder1_hfimgeBase64Str").val("");
                                                    var base64result = reader.result.split(',')[1];
                                                    $("#ContentPlaceHolder1_imgeBase64Str").val(base64result);
                                                    $("#ContentPlaceHolder1_hfimgeBase64Str").val(base64result);

                                                    $("#ContentPlaceHolder1_outputimage").attr("src", reader.result);
                                                    $("#ContentPlaceHolder1_hfimgShow").val(reader.result);
                                                }



                                                reader.readAsDataURL(img);
                                            }
                                             
                                        </script>
           
      <div class="row">
                                        <div class="col-1">&nbsp;</div>
                                        <div class="col-9">
                                            <div class="form-group row">
                                                <label for="title" class="col-sm-3 col-form-label"> Title:  </label>

                                                <div class="col-sm-8">
                                                     <div class="input-group">

                                                    <asp:TextBox  runat="server"    class="form-control form-control-sm mb-3" id="txtTitle" name="title" ></asp:TextBox>

                                                    <span id="v-title" class="invalid-tooltip fade hide" data-delay="2000">
                                                    </span>
 <span class="input-group-text text-c-red">*</span>
                                    </div>
                                                </div>
                                                
                                            </div>

                                            <div class="form-group row">
                                                <label for="Announcement" class="col-sm-3 col-form-label">  Announcement:  </label>

                                                <div class="col-sm-8">
                                                     <div class="input-group">

                                                     <asp:TextBox  TextMode="MultiLine"   runat="server" id="Announcement" class="form-control form-control-sm mb-3" rows="10"></asp:TextBox>
                                                    <span id="v-Announcement" class="invalid-tooltip fade hide" data-delay="2000">
                                                    </span>
                                                          <span class="input-group-text text-c-red">*</span>
                                    </div>
                                                </div>
                                               
                                            </div>

                                            <div style="padding-top:12px;"></div>

                                            <div class="form-group row">
                                                <label for="frmDate" class="col-sm-3 col-form-label">  From Date:   </label>

                                                <div class="col-sm-3">
                                                      <div class="input-group">
                                                    <asp:TextBox  runat="server"    id="frmDate" type="text" class="datepicker form-control form-control-sm mb-3"   autocomplete="off" placeholder="Select Date"></asp:TextBox>
                                                    <span id="v-frmDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                    </span>

                                                     <span class="input-group-text text-c-red">*</span>
                                                </div>
                                                </div>

                                                <label for="toDate" class="col-sm-2 col-form-label"> To Date:  </label>

                                                <div class="col-sm-3">
                                                      <div class="input-group">

                                                    <asp:TextBox  runat="server"   id="toDate" type="text" class="datepicker form-control form-control-sm mb-3 "   autocomplete="off" placeholder="Select Date" ></asp:TextBox>
                                                    <span id="v-toDate" class="invalid-tooltip fade hide" data-delay="2000">
                                                    </span>
                                                     <span class="input-group-text text-c-red">*</span>
                                                </div>
                                                </div>

                                            </div>



                                        </div>

                                    </div>
                                   
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

                                                  <asp:GridView ID="gv_Market" runat="server"  ShowHeaderWhenEmpty="true"  AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark"  >
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
                                                                        
                                                <asp:TemplateField HeaderText="Area ">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_AreaName" runat="server" Text='<%#Eval("AreaName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Territory">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_TerritoryName" runat="server" Text='<%#Eval("TerritoryName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Sub-Territory" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_SubTerritoryName" runat="server" Text='<%#Eval("SubTerritoryName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                                        
                                                <asp:TemplateField HeaderText="Market"  Visible="false">
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
                                      <h4>User Role</h4>
                                    <hr />


                                      <div class="row">
                            <div class="col-1">&nbsp;</div>
                            <div class="col-9">
                                 <div class="form-group row">
                                    <label  class="col-sm-2 col-form-label">User Role:  </label>

                                    <div class="col-sm-10">
                                 <asp:ListBox ID="UserRoleSelect" runat="server" CssClass=" form-select form-select-sm mb-3 multiple-select" SelectionMode="Multiple"></asp:ListBox>
                                </div>
                                </div>
                                </div>
                                </div>
                                     <br />
                                   <div class="form-group row">
                                       <label for="MeterImage" class="col-sm-1 col-form-label"></label>
                                   <h4 class="col-sm-3"> Upload Image</h4>   
                              
                                       </div>
                                      <hr />
                                <div class="form-group row" style="margin-top:6px;">


                                    <label for="MeterImage" class="col-sm-2 col-form-label"> Image:  </label>

                                    <div class="col-sm-8">
                                         <div class="input-group" >

                                        <input type="file" id="ShopImgUploadForm" name="image" accept="image/*" class="form-control form-control-sm mb-3 " onchange="ImageToBase64ShopImg(this)" />

                                        <span id="v-ShopImgUploadForm" class="invalid-tooltip fade hide" data-delay="2000">
                                        </span>
                                               <span class="input-group-text text-c-red">*</span>
                                                    </div>
                                                <asp:HiddenField runat="server" ID="hfimgShow"   />
                                    <asp:HiddenField runat="server" ID="hfimgeBase64Str"   />
                                        <div class="input-group" >
                                             <asp:Image runat="server" id="outputimage" class="imgshadow"  />
                                            </div>

                                    </div>
                                    
                                    </div>
                           

                                            <br />
                                    <div class="row">
                                        <div class="col-2">&nbsp;</div>
                                        <div class="col-8">

                                            <div class="form-group row">
                                                <label for="exampleInputUsername2" class="col-sm-3 col-form-label"></label>
                                                <div class="col-sm-9"> 

                                                   <asp:LinkButton OnClientClick="return sweetAlertConfirm_Submit(this);"  OnClick="btnSave_Click" Visible="false"  runat="server" id="btnSave" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Submit
                                        </asp:LinkButton>

                                                             <asp:LinkButton OnClientClick="return sweetAlertConfirm_Update(this);"   OnClick="btnSave_Click"  Visible="false"   runat="server" id="btnUpdate" class="btn btnMyDesignSearch   btn-sm"  >
                                            <i class="fa fa-check"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton  runat="server"  ID="btnReset" OnClick="btnReset_Click"  class="btn btnMyDesignReset   btn-sm"  ><i class="fa fa-retweet" aria-hidden="true"></i>&nbsp; Reset </asp:LinkButton>
                                          
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-2">&nbsp;</div>
                                    </div>


                                    <br />
                                    <br />
                                       <div class="row">
                            <div class="col-2">&nbsp;</div>
                                       <div class="col-8">

                                            <div class="table-responsive" id="MainGrade88Div2" style="height:600px">

                                                  <asp:GridView ID="gv_Seen" runat="server"  ShowHeaderWhenEmpty="true"  AutoGenerateColumns="False"
                                                                    CssClass="table table-bordered  text-center thead-dark"  >
                                                                    <Columns>

                                                                         <asp:TemplateField HeaderText="SL#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                               </ItemTemplate>
                                    </asp:TemplateField>
                                                                      
                                                <asp:TemplateField HeaderText="Seen By">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbl_EmpName" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                                        </Columns>
                                                      </asp:GridView>
                                                </div>
                                                </div>
                                                </div>
                                    </ContentTemplate>
                                 </asp:UpdatePanel>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            
     
    <input id="masterId" value="0" style="display:none" />

   
    <script src="//cdn.ckeditor.com/4.14.1/standard/ckeditor.js"></script>
    
    <%--    <script>
           
            //CKEDITOR.replace('Announcement');
            var idd = 0;


            $(document).ready(function () {

                $('.datepicker').pickadate({
                    selectMonths: true,
                    selectYears: true
                })

            var current_fs, next_fs, previous_fs; 
            var opacity;
            var current = 1;
            var steps = $("fieldset").length;

            setProgressBar(current);

            $(".next").click(function () {

                if (basic_Validation()) {

                    current_fs = $(this).parent();
                    next_fs = $(this).parent().next();

                    //Add Class Active
                    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

                    //show the next fieldset
                    next_fs.show();
                    //hide the current fieldset with style
                    current_fs.animate({ opacity: 0 }, {
                        step: function (now) {
                            // for making fielset appear animation
                            opacity = 1 - now;

                            current_fs.css({
                                'display': 'none',
                                'position': 'relative'
                            });
                            next_fs.css({ 'opacity': opacity });
                        },
                        duration: 500
                    });
                    setProgressBar(++current);
                }
              
            });

            $(".next1").click(function () {


                if (MarketInfo_Validation()) {
                    current_fs = $(this).parent();
                    next_fs = $(this).parent().next();

                    //Add Class Active
                    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

                    //show the next fieldset
                    next_fs.show();
                    //hide the current fieldset with style
                    current_fs.animate({ opacity: 0 }, {
                        step: function (now) {
                            // for making fielset appear animation
                            opacity = 1 - now;

                            current_fs.css({
                                'display': 'none',
                                'position': 'relative'
                            });
                            next_fs.css({ 'opacity': opacity });
                        },
                        duration: 500
                    });
                    setProgressBar(++current);
                }

              
            });

            //$(".next2").click(function () {


            //    if (Image_Validation()) {
            //        current_fs = $(this).parent();
            //        next_fs = $(this).parent().next();

            //        //Add Class Active
            //        $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

            //        //show the next fieldset
            //        next_fs.show();
            //        //hide the current fieldset with style
            //        current_fs.animate({ opacity: 0 }, {
            //            step: function (now) {
            //                // for making fielset appear animation
            //                opacity = 1 - now;

            //                current_fs.css({
            //                    'display': 'none',
            //                    'position': 'relative'
            //                });
            //                next_fs.css({ 'opacity': opacity });
            //            },
            //            duration: 500
            //        });
            //        setProgressBar(++current);
            //    }


            //});


            $(".previous").click(function () {

                current_fs = $(this).parent();
                previous_fs = $(this).parent().prev();

                //Remove class active
                $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

                //show the previous fieldset
                previous_fs.show();

                //hide the current fieldset with style
                current_fs.animate({ opacity: 0 }, {
                    step: function (now) {
                        // for making fielset appear animation
                        opacity = 1 - now;

                        current_fs.css({
                            'display': 'none',
                            'position': 'relative'
                        });
                        previous_fs.css({ 'opacity': opacity });
                    },
                    duration: 500
                });
                setProgressBar(--current);
            });

            function setProgressBar(curStep) {
                var percent = parseFloat(100 / steps) * curStep;
                percent = percent.toFixed();
                $(".progress-bar")
                    .css("width", percent + "%")
            }

            $(".submit").click(function () {
                return false;
            })

        });


        $(document).ready(function () {

                $("#fileInput").on("change", function () {
                    debugger;
                    var fileInput = document.getElementById('fileInput');

                    // Iterating through each files selected in fileInput
                    for (i = 0; i < fileInput.files.length; i++) {
                        debugger;
                        var sfilename = fileInput.files[i].name;
                        let srandomid = Math.random().toString(36).substring(7);
                        formdata.append(sfilename, fileInput.files[i]);

                        var markup = "<tr id='" + srandomid + "'><td> " + sfilename + "</td><td><a href='#' onclick='DeleteFile(\"" + srandomid + "\",\"" + sfilename +
                            "\")'><span class='glyphicon glyphicon-remove red'>Remove</span></a></td></tr>";

                        $("#FilesList tbody").append(markup);

                        //                  <img src='" + fileInput.files[i] + "' id='output' width='100' height='100' />
                        //<img src='#' id='blah' width='200' height='200' /> </td >
                        //                        $("#blah").val('');

                        //                    if (fileInput.files[i]) {
                        //                        blah.src = URL.createObjectURL(fileInput.files[i])
                        //                    }

                    }
                    chkatchtbl();
                    $('#fileInput').val('');

                });

            });


            function getUrlVars() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            }
        $(function () {

            var masterid = getUrlVars()["id"];
            if (masterid) {

                $("#masterId").val(getUrlVars()["id"]);

                GetData(masterid);
            }
            else {

                //$('#frmDate').datepicker("update", new Date());
                //$('#toDate').datepicker("update", new Date());
                //GetGroup(0);
            }

     

            $("#GroupNameSelect").on("change", function (e) {
                var zoneId = $("#GroupNameSelect").val();
                if (zoneId > 0) {
                    GetZone_ByGroup(zoneId);

                }
            });

            $("#zoneSelect").on("change", function (e) {
                var zoneId = $("#zoneSelect").val();
                if (zoneId > 0) {
                    GetArea_ByZone(zoneId);

                }
            });

            $("#areaSelect").on("change", function (e) {
                debugger;
                var id = $("#areaSelect").val();
                if (id > 0) {
                    GetTerritory_ByAreaId(id);

                }
            });

            $("#territorySelect").on("change", function (e) {
                debugger;
                var id = $("#territorySelect").val();
                if (id > 0) {
                    GetMarket_ByTerritoryId(id);

                }
            });


        });


         function GetGroup(id) {
        var urlpath = '@Url.Action("GetGroupList", "SeedData")';
        SelectOption_DtTable_Async_True(urlpath, $('#GroupNameSelect'), 'GroupId', 'GroupName', id);
        $('#GroupNameSelect').select2();
         }

         function GetZone_ByGroup(id) {

        _getZone_ByGroupId_Active($('#zoneSelect'), 'RegionId', 'RegionName', id);
    }

         function GetArea_ByZone(id) {
            _getArea_ByZoneId_Active($('#areaSelect'), 'AreaId', 'AreaName', id);
    }

         function GetTerritory_ByAreaId(id) {
        _getTerritory_ByAreaId_Active($('#territorySelect'), 'TerritoryId', 'TerritoryName', id);
    }

         function GetMarket_ByTerritoryId(id) {
                _getMarket_ByTerritoryId_Active($('#MarketSelect'), 'MarketId', 'MarketName', id);
       }


         function PreloadMarketInfo() {

         idd++;
            if ($("#GroupNameSelect").val() != 0 && $("#MarketSelect").val() !=0 ) {

                var dtGroupId = $("#GroupNameSelect").val();
                var dtGroupName = $("#GroupNameSelect :selected").text();

                var dtZoneId = $("#zoneSelect").val();
                var dtZoneName = $("#zoneSelect :selected").text();

                var dtAreaId = $("#areaSelect").val();
                var dtAreaName = $("#areaSelect :selected").text();

                var dtterritoryId = $("#territorySelect").val();
                var dtterritoryName = $("#territorySelect :selected").text();

                var dtmarketId = $("#MarketSelect").val();
                var dtmarketName = $("#MarketSelect :selected").text();

                var tr = '<tr id="addr' + (idd) + '">';
                var qtyTd = '<td style="text-align:center">' + (idd) + '</td>';
                var Group = '<td style="text-align:center"> <input type="hidden"  id="HfGroupId" name="Group[' + idd + '].dtGroupId" value="' + dtGroupId + '"/>' + dtGroupName + ' </td>';
                var Zone = '<td style="text-align:center"> <input type="hidden"  id="HfZoneId" name="Zonee[' + idd + '].dtZoneId" value="' + dtZoneId + '"/>' + dtZoneName + ' </td>';
                var Area = '<td style="text-align:center"> <input type="hidden"  id="HfAreaId" name="Areaa[' + idd + '].dtAreaId" value="' + dtAreaId + '"/> ' + dtAreaName + ' </td>';
                var territory = '<td style="text-align:center"> <input type="hidden"  id="HfterritoryId" name="Territoryy[' + idd + '].dtterritoryId" value="' + dtterritoryId + '"/>' + dtterritoryName + ' </td>';
                var market = '<td style="text-align:center"> <input type="hidden"  id="HfmarketId" name="markett[' + idd + '].dtmarketId" value="' + dtmarketId + '"/> ' + dtmarketName + ' </td>';
                var button = '<td style="text-align:center"><button class="btn btn-danger btn-icon" onclick="RemoveRow(' + idd + ')"><i class="fa fa-trash" aria-hidden="true"></i></button></td>';
                tr += qtyTd + Group + Zone + Area + territory + market  + button + '</tr>';
                $("#dtTableBody").append(tr);

                }

            }

         function RemoveRow(tbId) {
            $("#addr" + (tbId)).remove();
            --idd;
         }

        function DeleteFile(Fileid, FileName) {
            formdata.delete(FileName)
            $("#" + Fileid).remove();
            chkatchtbl();
        }

        function chkatchtbl() {
            if ($('#FilesList tr').length > 1) {
                $("#FilesList").css("visibility", "visible");
            } else {
                $("#FilesList").css("visibility", "hidden");
            }
        }

        function Visible() {
                $("#FilesList").css("visibility", "visible");
        }


        function ValidationTooltip(id, message) {

                $(id).empty();

                if ($(id).empty()) {
                    $(id).append(message);
                }
                $(id).toast('show');
                $(id).css("display", "block");

            }

        function RemoveValidationTooltip(id) {
            $(id).css("display", "none");

        }

       

        function basic_Validation() {


            $('#title').removeClass('is-invalid');
            $('#Announcement').removeClass('is-invalid');
      
            RemoveValidationTooltip("#v-title");

            RemoveValidationTooltip("#v-Announcement");

                isValid = true;


                if ($('#title').val() == "") {

                    $('#title').addClass("is-invalid");
                    ValidationTooltip("#v-title", "Please fill out of this field!");
                    isValid = false;
                }

                if ($('#Announcement').val() == "") {

                    $('#Announcement').addClass("is-invalid");
                    ValidationTooltip("#v-Announcement", "Please fill out of this field!");
                    isValid = false;
                }


             
                return isValid;
            }
       

        function MarketInfo_Validation() {
       
             isValid = true;

            if ($('#dtTableBody tr').length == 0) {
                
                _errorWithMsg("Please!! Add Details list");
                return false;
            }
            
                return isValid;
        }



        function Image_Validation() {

            isValid = true;

            if ($('#masterId').val() == 0) {
                if ($('input[type=file]').val() == "") {
                    _errorWithMsg("Please!! Select Image");
                    return false;
                }
            }      
                return isValid;
            }


        function ImageToBase64(image) {
            var img = image.files[0];
            
                var reader = new FileReader();
                reader.onloadend = function () {
                 
                    $("#imgeBase64Str").val("");
                    var base64result = reader.result.split(',')[1];
                    $("#imgeBase64Str").val(base64result);

                    $("#output-image").attr("src", reader.result);
                    $('#output-image').show();
                    $("#fID").attr("href", img);
                }

                reader.readAsDataURL(img);

            }

        function Save() {

            if (basic_Validation()) {
           
                            FinalSave();
                        

         }
        }

        function FinalSave() {

        var jsonData = {};

        jsonData["NoticeId"] = $('#masterId').val();
        jsonData["NoticeTitle"] = $('#title').val();
        jsonData["Announcement"] = $('#Announcement').val();
        jsonData["FromDate"] = $('#frmDate').val();
        jsonData["ToDate"] = $('#toDate').val();
            var filename = 'Mileage-13.jpg'; /*$('input[type=file]').val().replace(/C:\\fakepath\\/i, '');*/
        jsonData["filename"] = filename;         
        jsonData["file"] = $('#imgeBase64Str').val();

         //var jsonObjs =[];

         //   for (var i = 0; i < $('#dtTableBody tr').length; i++) {

         //       debugger;
         //       idd = i;
         //       idd++;
         //       var theObj = {};
                
         //       var dtGroupId = $("input[name='Group[" + idd + "].dtGroupId']").val();
         //       var dtZoneId = $("input[name='Zonee[" + idd + "].dtZoneId']").val();
         //       var dtAreaId = $("input[name='Areaa[" + idd + "].dtAreaId']").val();
         //       var dtterritoryId = $("input[name='Territoryy[" + idd + "].dtterritoryId']").val();
         //       var dtmarketId = $("input[name='markett[" + idd + "].dtmarketId']").val();

         //       theObj["GroupId"] = dtGroupId;
         //       theObj["RegionId"] = dtZoneId;
         //       theObj["AreaId"] = dtAreaId;
         //       theObj["TerritoryId"] = dtterritoryId;
         //       theObj["MarketId"] = dtmarketId;

         //       jsonObjs.push(theObj);
         //       jsonData["NoticeMarketDetails"] = jsonObjs;
         //   }

            //var formdata = new FormData();

            var urlpath = 'NoticeBoard.aspx/Save_Notice';

            $.ajax({
                data: JSON.stringify({ 'master': jsonData }),
                url: urlpath,
                type: "POST", contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                  //  _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
            success: function (result) {
                result = result.d;
                if (result.isSuccess == true) {

                    successalert('Operation successful!', 'Success', 'NoticeRecords.aspx');
                } else {
                    faildalert('Operation Faild!', 'Faild');
                } 
                },
            });
        }

        function ImageSave(id) {
            var Id = id;
            formdata.append('ID', Id);
            var urlpath = '@Url.Action("UploadFiles", "NoticeBoard")';

            $.ajax({
                data: formdata,
            contentType: false,
            processData: false,
            async: false,
                url: urlpath,
                type: "POST",
                beforeSend: function () {
                    _open_LoadingPopUp_WithMsg("popDiv", "Please wait. Data is Saving...");
                },
                success: function (success) {
                    _close_LoadingPopUp_WithMsg();
                    debugger;
                    if (success == true) {
                        $.confirm({
                            icon: 'fas fa-check-circle',
                            title: 'Success !',
                            content: 'Operation successfully done!!',
                            type: 'green',
                            buttons: {
                                OK: {
                                    text: 'OK',
                                    action: function () {
                                var url = '@Url.Action("NoticeRecords", "NoticeBoard")';
                                window.location.href = url;
                                    }
                                }
                            }
                        });

                    } else {
                        _errorWithMsg("Some error occurred.. Please try again");
                    }

                },
                error: function (data) {
                    _close_LoadingPopUp_WithMsg();
                    _errorWithMsg("Some error occurred.. Please try again");
                },

            });
        }


        function GetData(id) {

            var urlpath = 'NoticeBoard.aspx/GetNoticeMasterEditData';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                data: JSON.stringify({ 'id': id }),
                type: "POST", contentType: "application/json; charset=utf-8",
                async: true,
                success: function (data) {
                    data = data.d;
                    $("#btnSave").html(" <i class='fa fa-check'></i>&nbsp;Update");

                    $('#title').val(data.NoticeTitle);
                    $('#Announcement').val(data.Announcement);
                    $('#frmDate').val(ToJavaScriptDate_Formater(data.FromDate));
                    $('#toDate').val(ToJavaScriptDate_Formater(data.ToDate));
                   // GetNoticeDetails(data.NoticeId);
                },
                complete: function() {
                }
            });
        }

        function GetNoticeDetails(id) {

            var urlpath = '@Url.Action("GetNotticeDetailsEditForEdit", "NoticeBoard")';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "Get",
                data: { id: id },
                async: true,
                beforeSend: function() {
                },
                success: function (data) {
      
                    var result = JSON.parse(data);
               
                    for (var i = 0; i < result.length; i++) {

                    
                        idd++
                        var dtGroupId = result[i].GroupId;
                        var dtGroupName = result[i].GroupName;

                        var dtZoneId = result[i].RegionId;
                        var dtZoneName = result[i].RegionName;

                        var dtAreaId = result[i].AreaId;
                        var dtAreaName = result[i].AreaName;

                        var dtterritoryId = result[i].TerritoryId;
                        var dtterritoryName = result[i].TerritoryName;

                        var dtmarketId = result[i].MarketId;
                        var dtmarketName = result[i].MarketName;

                        var tr = '<tr id="addr' + (idd) + '">';
                        var qtyTd = '<td style="text-align:center">' + (idd) + '</td>';
                        var Group = '<td style="text-align:center"> <input type="hidden"  id="HfGroupId" name="Group[' + idd + '].dtGroupId" value="' + dtGroupId + '"/>' + dtGroupName + ' </td>';
                        var Zone = '<td style="text-align:center"> <input type="hidden"  id="HfZoneId" name="Zonee[' + idd + '].dtZoneId" value="' + dtZoneId + '"/>' + dtZoneName + ' </td>';
                        var Area = '<td style="text-align:center"> <input type="hidden"  id="HfAreaId" name="Areaa[' + idd + '].dtAreaId" value="' + dtAreaId + '"/> ' + dtAreaName + ' </td>';
                        var territory = '<td style="text-align:center"> <input type="hidden"  id="HfterritoryId" name="Territoryy[' + idd + '].dtterritoryId" value="' + dtterritoryId + '"/>' + dtterritoryName + ' </td>';
                        var market = '<td style="text-align:center"> <input type="hidden"  id="HfmarketId" name="markett[' + idd + '].dtmarketId" value="' + dtmarketId + '"/> ' + dtmarketName + ' </td>';
                        var button = '<td style="text-align:center"><button class="btn btn-danger btn-icon" onclick="RemoveRow(' + idd + ')"><i class="fa fa-trash" aria-hidden="true"></i></button></td>';
                        tr += qtyTd + Group + Zone + Area + territory + market + button + '</tr>';
                        $("#dtTableBody").append(tr);
                     

                    }
         
                },
                complete: function () {
              
                }
            });

            }


        function GetNoticeImage(id) {


            var urlpath = '@Url.Action("GetNoticeImageListForEdit", "NoticeBoard")';
            $.ajax({
                url: urlpath,
                dataType: 'json',
                type: "Get",
                data: { id: id },
                async: true,
                beforeSend: function() {
                },
                success: function (data) {
                    debugger;
                    var result = JSON.parse(data);
                    //var row = "";
                    //$('#FilesList').html("");
                    var formdata = new FormData();
                    for (var i = 0; i < result.length; i++) {

                        //row += '<tr id="addr' + (i) + '">';
                        //row += "<td style='text - align: center'>" + (i + 1) + "</td>";
                        //row += '<td style="text-align:center"> <input type="hidden" style="text-align:center" id="HfProductId" al name="ProductDetails[' + i + '].ProductId" value="' + result[i].ProductId + '"/>' + result[i].ProductName  + '</td>';
                        //row += "<td style='text - align: center'><button class='btn btn-danger btn-icon' onclick='RemoveRow(" + i + ")'><i class='fas fa-trash' aria-hidden='true'></i></button></td>";
                        //row += "</tr>";

                        $('#fileInput').content(result[i].ImagePath);

                        var fileInput = document.getElementById('fileInput');
                        console.log(fileInput.files);
                        var sfilename = result[i].ImageName;
                        let srandomid = result[i].NoticeId;

                        formdata.append(sfilename, fileInput.files);

                        var markup = "<tr id='" + srandomid + "'><td> <img src='#' id='blah' width='200' height='200' /> </td> </td> <td>" + sfilename + "</td><td><a href='#' onclick='DeleteFile(\"" + result[i].NoticeId + "\",\"" + result[i].ImageName +
                            "\")'><span class='glyphicon glyphicon-remove red'>Remove</span></a></td></tr>";
                        $("#FilesList tbody").append(markup);
                        $('#fileInput').val('');

                        //if (result[i].ImagePath) {
                        //    blah.src = URL.createObjectURL(result[i].ImagePath)
                        //}
                    }

                    //$('#FilesList').html(row);
                    Visible();
                    //$('#fileInput').val('');
                },
                complete: function () {
                    //$('#dtTble').dataTable({
                    //    "ordering": false
                    //});
                }
            });
            }



        </script>--%>



   

</asp:Content>

