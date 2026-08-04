<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NoticeDetailsApp.aspx.cs" Inherits="NoticeBoard_UI_NoticeDetailsApp" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title></title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
 
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>

   
     
    
</head>
<body>
    <form id="form1" runat="server">
        <style>
        .table tbody th, .table thead th {
            background: #2F4F4F;
            background: -moz-linear-gradient(top, #637b7b 0%, #436060 66%, #2F4F4F 100%);
            background: -webkit-linear-gradient(top, #637b7b 0%, #436060 66%, #2F4F4F 100%);
            background: linear-gradient(to bottom, #637b7b 0%, #436060 66%, #2F4F4F 100%);
            border-bottom: 2px solid #2F4F4F;
            padding: 10px 8px;
        }

        .table tbody td, .table thead td {
            padding: 10px 8px;
        }

        .tblTHColorChang {
            background-color: #EDF2F5;
            font-weight: bold;
            font-size: 12px;
        }

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
         p.c {
  word-break: break-all;
}
    </style>
         
               <script type="text/javascript">
                                      <%-- window.onload = function () {
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
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                                <asp:HiddenField id="masterId"  runat="server" />
                                <div class="table-responsive " id="MainGradeDiv">
                                    <div style="overflow-x:auto;overflow-y:auto;">
                                        <table class="table table-striped table-bordered table-hover" style="overflow-x:auto;overflow-y:auto;">


                                            <tr>
                                                <td class="tblTHColorChang" style=" width:20%; padding: 10px;">Title:</td>
                                                <td>
                                                    <asp:Label runat="server"  ID="lblTitle"></asp:Label>
                                                </td>



                                            </tr>

                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Announcement: </td>
                                                <td class='text-wrap width-200'>
                                                  
                                                    <p CssClass="c"> <asp:Label  runat="server"  ID="lblAnnouncement"></asp:Label></p>

                                                   
                                                </td>




                                            </tr>

                                         


                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">From Date:</td>
                                                <td>
                                               
                                                    <asp:Label runat="server"  ID="lblFromDate"></asp:Label>
                                                </td>



                                            </tr>

                                            <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">To Date:</td>
                                                <td>
                                                 <asp:Label runat="server"  ID="lblToDate"></asp:Label>
                                                    
                                                </td>


                                            </tr>

                                               <tr>
                                                <td class="tblTHColorChang" style="width: 20%; padding: 10px;">Notice Image:</td>
                                                <td>
                                               
                                       
 
                                                <asp:HiddenField runat="server" ID="hfimgShow"   />
                                    <asp:HiddenField runat="server" ID="hfimgeBase64Str"   />
                                        <div class="input-group" >
                                             <asp:Image runat="server" id="outputimage" class="imgshadow"  />
                                            </div>
                                                </td>


                                            </tr>
                                        </table>
                                    </div>
                                    </div>

                                     </div>
                                </div>
                            </div>
                        </div>
                 
                    
         
   
    

         
    </form>
</body>
</html>
