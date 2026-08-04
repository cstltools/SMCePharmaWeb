<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IVMarketStructureInvoSearch.ascx.cs" Inherits="SInventory_UI_IVMarketStructureInvoSearch" %>


<div style="padding-top:6px;"></div>


<div class="row">
    <div class="col-md-6">
          <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-5 col-form-label">  Group:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <asp:DropDownList runat="server" id="GroupSelect" AutoPostBack="true" OnSelectedIndexChanged="GroupSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                    <asp:HiddenField ID="hfMarket" runat="server"  />
                                    <asp:HiddenField ID="hfSubTeritory" runat="server"  />
                                    <asp:HiddenField ID="hfTeritory" runat="server"  />
                                    <asp:HiddenField ID="hfArea" runat="server"  />
                                    <asp:HiddenField ID="hfZone" runat="server"  />
                                    <asp:HiddenField ID="hfGroupId" runat="server"  />

                                        
  
                                                    </div>
                                    </div>
                                    </div>
 <div class="form-group row">


                                    <label for="ZoneSelect" class="col-sm-5 col-form-label"> Zone:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                      <asp:DropDownList runat="server"  id="ZoneSelect" AutoPostBack="true" OnSelectedIndexChanged="ZoneSelect_SelectedIndexChanged"  class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>   

                                       
                                     
  
                                                    </div>

                                    </div>

                                </div>





                                <div class="form-group row" style="margin-top:6px;">
                                    <label class="col-sm-5 col-form-label">Area:  </label>

                                    <div class="col-sm-7">
                                                <div class="input-group">
                                        <asp:DropDownList runat="server"   id="AreaSelect"  AutoPostBack="true" OnSelectedIndexChanged="AreaSelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2"></asp:DropDownList>

                                        
                                                        
                                                    </div>
                                    </div>

                                     </div>
 <div class="form-group row">
                                   

                                    <label for="AreaSelect" class="col-sm-5 col-form-label">Territory:  </label>

                                    <div class="col-sm-7">

                                         <div class="input-group">
                                           <asp:DropDownList runat="server"    id="TeritorySelect"   AutoPostBack="true" OnSelectedIndexChanged="TeritorySelect_SelectedIndexChanged" class="form-select form-select-sm mb-3 mySelect2">   </asp:DropDownList>

                                        <span id="v-TeritorySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>

                                               
                                                    </div>
                                    </div>
                                    
                                </div>



                                <div class="form-group row" style="margin-top:6px;">

                                       <label for="MarketSelect" class="col-sm-5 col-form-label">Sub-Territory:  </label>

                                    <div class="col-sm-7">

                                         <div class="input-group">
                                          <asp:DropDownList runat="server"     AutoPostBack="true" OnSelectedIndexChanged="SubTeritory_SelectedIndexChanged" id="SubTeritory"  class="form-select form-select-sm mb-3 mySelect2">  </asp:DropDownList>

                                       
                                               
                                                    </div>

                                    </div>     
                                    
                                     </div>
 <div class="form-group row">
                                    <label for="MarketSelect" class="col-sm-5 col-form-label">Market:  </label>

                                    <div class="col-sm-7">

                                         <div class="input-group">
                                       <asp:DropDownList runat="server"    id="MarketSelect"  class="form-select form-select-sm mb-3 mySelect2">  </asp:DropDownList>

                                    
                                               
                                                    </div>

                                    </div>                                    </div>

    </div>


    <div class="col-md-6">
          <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-5 col-form-label">  NSM Name:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <asp:DropDownList runat="server" id="ddlNSM"  class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                     

                                        
  
                                                    </div>
                                    </div>
                                    </div>

         <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-5 col-form-label">  DZSM  Name:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <asp:DropDownList runat="server" id="ddlDZSM"  class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                     

                                        
  
                                                    </div>
                                    </div>
                                    </div>


          <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-5 col-form-label">  AM  Name:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <asp:DropDownList runat="server" id="ddlAM"  class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                     

                                        
  
                                                    </div>
                                    </div>
                                    </div>

           <div class="form-group row">
                                    <label for="GroupSelect" class="col-sm-5 col-form-label">  MIO  Name:  </label>

                                    <div class="col-sm-7">
                                           <div class="input-group">
                                        <asp:DropDownList runat="server" id="ddlMIO"  class="form-select form-select-sm mb-3 mySelect2" >   </asp:DropDownList>
                                     

                                        
  
                                                    </div>
                                    </div>
                                    </div>


                                    </div>
</div>
                              