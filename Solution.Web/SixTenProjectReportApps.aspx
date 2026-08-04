<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SixTenProjectReportApps.aspx.cs" Inherits="SixTenProjectReportApps" %>
 
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>


    <!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

<!-- Font Awesome (icons) -->
<link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.6.0/css/all.min.css" rel="stylesheet" />

<!-- Select2 core + Bootstrap 5 theme -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

<!-- Pickadate themes -->
<link href="https://cdn.jsdelivr.net/npm/pickadate@3.6.4/lib/themes/default.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/pickadate@3.6.4/lib/themes/default.date.css" rel="stylesheet" />
<!-- jQuery -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

<!-- Bootstrap 5 Bundle (with Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- Pickadate JS -->
<script src="https://cdn.jsdelivr.net/npm/pickadate@3.6.4/lib/picker.js"></script>
<script src="https://cdn.jsdelivr.net/npm/pickadate@3.6.4/lib/picker.date.js"></script>
    <style>
  html, body, form { height:100%; }
  body { margin:0; }
  .app-screen { min-height:100svh; padding-bottom:16px; }

  .app-topbar { border:0; }
  .app-topbar h5, .app-topbar i { }

  .kpi { background:#fff; border:0; padding:.75rem; border-radius:1rem;
         box-shadow:0 2px 10px rgba(0,0,0,.05); }
  .kpi-title { font-size:.8rem; color:#6c757d; margin-bottom:.25rem; }
  .kpi-value { font-size:1.1rem; font-weight:700; }

  .card { border-radius:1rem; }
  .card-header { border-top-left-radius:1rem; border-top-right-radius:1rem; }

  .app-table-wrap { max-height:65svh; overflow:auto; }
  .table { font-size:.9rem; }
  @media (max-width:576px){
    .app-table-wrap { max-height:55svh; }
    .card-header strong { font-size:.95rem; }
  }
</style>

</head>
<body>
    <form id="form1" runat="server">
        <!-- ===== App-style Single Page ===== -->
<%--<asp:UpdatePanel runat="server">
    <ContentTemplate>--%>
        <div class="container-fluid px-2 px-md-3 py-2 app-screen">

  <!-- Sticky Topbar -->
<div class="app-topbar d-flex align-items-center justify-content-between bg-white border-bottom py-2 px-2 sticky-top">
  <h5 class="mb-0 d-flex align-items-center gap-2">
    <i class="fa fa-file-archive-o"></i>
    <span>6/10 Project Report</span>
  </h5>

  <div class="d-flex align-items-center gap-2">
    <!-- open modal instead of collapse -->
    <button class="btn btn-outline-secondary btn-sm"
            type="button"
            data-bs-toggle="modal"
            data-bs-target="#filterModal">
      <i class="fa fa-sliders-h"></i> Filters
    </button>
       
  </div>
</div>

 <!-- Filters Modal -->
<div class="modal fade" id="filterModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-lg modal-fullscreen-sm-down">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fa fa-sliders-h"></i> Filters</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body">
        <div class="row g-3 align-items-end">
          <!-- Market Structure -->
          <div class="col-12 col-lg-4">
            <div class="form-group row" runat="server"  >
    <label for="GroupSelect" class="col-sm-3 col-form-label">Group:  </label>

    <div class="col-sm-8">
        <div class="input-group">
            <asp:DropDownList runat="server" ID="GroupSelect" AutoPostBack="true" OnSelectedIndexChanged="GroupSelect_SelectedIndexChanged" CssClass="form-select form-select-sm mb-3 "></asp:DropDownList>
             
                <asp:HiddenField ID="hfMarket" runat="server" />
    <asp:HiddenField ID="hfSubTeritory" runat="server" />
    <asp:HiddenField ID="hfTeritory" runat="server" />
    <asp:HiddenField ID="hfArea" runat="server" />
    <asp:HiddenField ID="hfZone" runat="server" />
    <asp:HiddenField ID="hfGroupId" runat="server" />

            
        </div>
    </div>
</div>
<div class="form-group row">


    <label for="ZoneSelect" class="col-sm-3 col-form-label">Zone:  </label>

    <div class="col-sm-8">
        <div class="input-group">
            <asp:DropDownList runat="server" ID="ZoneSelect" AutoPostBack="true" OnSelectedIndexChanged="ZoneSelect_SelectedIndexChanged" CssClass="form-select form-select-sm mb-3 "></asp:DropDownList>



          
        </div>

    </div>

</div>





<div class="form-group row" style="margin-top: 6px;">
    <label class="col-sm-3 col-form-label">Area:  </label>

    <div class="col-sm-8">
        <div class="input-group">
            <asp:DropDownList runat="server" ID="AreaSelect" AutoPostBack="true" OnSelectedIndexChanged="AreaSelect_SelectedIndexChanged" CssClass="form-select form-select-sm mb-3 "></asp:DropDownList>


   
        </div>
    </div>

</div>
<div class="form-group row">


    <label for="AreaSelect" class="col-sm-3 col-form-label">Territory:  </label>

    <div class="col-sm-8">

        <div class="input-group">
            <asp:DropDownList runat="server" ID="TeritorySelect"  CssClass="form-select form-select-sm mb-3 "></asp:DropDownList>

            <span id="v-TeritorySelect" class="invalid-tooltip fade hide" data-delay="2000"></span>

     
        </div>
    </div>

</div>
          </div>

          <!-- From Date -->
          <div class="col-6 col-md-4 col-lg-3">
            <label for="FromDate" class="form-label mb-1">From Date</label>
            <asp:TextBox runat="server" ID="FromDate" type="date"
              CssClass="form-control form-control-sm"
              autocomplete="off" placeholder="Select Date" />
          </div>

          <!-- To Date -->
          <div class="col-6 col-md-4 col-lg-3">
            <label for="ToDate" class="form-label mb-1">To Date</label>
            <asp:TextBox runat="server" ID="ToDate" type="date"
              CssClass="form-control form-control-sm"
              autocomplete="off" placeholder="Select Date" />
          </div>

          <!-- Approval Status (optional) -->
          <div class="col-12 col-lg-2 d-none">
            <label for="ApprovalStatusSelect" class="form-label mb-1">Approval Status</label>
            <asp:DropDownList runat="server" ID="ApprovalStatusSelect"
              CssClass="form-select form-select-sm mySelect2" />
          </div>
        </div>
      </div>

      <div class="modal-footer d-flex justify-content-between">
         

        <div class="d-flex gap-2">
          <!-- একই server handlers ব্যবহার -->
          <asp:LinkButton runat="server" ID="btnSearchModal"
            CssClass="btn btn-info  btn-sm" OnClick="btnSearch_Click"
           >
            <i class="fa fa-search-plus"></i>&nbsp; Apply Filters
          </asp:LinkButton>

           

          <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
<style>
  /* আগে যেটা ছিল সেটা থাক, নতুন কিছু লাগলে */
  .modal-fullscreen-sm-down { } /* Bootstrap 5 ক্লাসই যথেষ্ট */
</style>

<script>
    // Modal open হলে pickadate/select2 রি-ইনিট
    document.addEventListener('DOMContentLoaded', function () {
        var fm = document.getElementById('filterModal');
        if (fm) {
            fm.addEventListener('shown.bs.modal', function () {
                if (typeof pageLoad === 'function') pageLoad();
            });
        }

        // Clear all (basic): date clear + approval clear + (optional) market structure clear
        $(document).on('click', '#btnClearFilters', function () {
            $('#FromDate, #ToDate').val('');
            try { $('#ApprovalStatusSelect').val(null).trigger('change'); } catch (e) { }
            // যদি IVMarketStructure-এ ক্লিয়ার ফাংশন থাকে:
            if (window.clearMarketStructure) { window.clearMarketStructure(); }
        });
    });
</script>

  <!-- KPI chips (optional; bind from code-behind if needed) -->
  <div class="row g-2 mt-2">
    <div class="col-6 col-md-3">
      <div class="kpi card shadow-sm">
        <div class="kpi-title">DCP</div>
        <div class="kpi-value">
          <asp:Label runat="server" ID="lblKpiDCP" Text="—" />
        </div>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="kpi card shadow-sm">
        <div class="kpi-title">DCR</div>
        <div class="kpi-value">
          <asp:Label runat="server" ID="lblKpiDCR" Text="—" />
        </div>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="kpi card shadow-sm">
        <div class="kpi-title">RX</div>
        <div class="kpi-value">
          <asp:Label runat="server" ID="lblKpiRX" Text="—" />
        </div>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="kpi card shadow-sm">
        <div class="kpi-title">Total Sales (Net TP)</div>
        <div class="kpi-value">
          <asp:Label runat="server" ID="lblKpiSales" Text="—" />
        </div>
      </div>
    </div>
  </div>

  <!-- Data Card -->
  <div class="card shadow-sm border-0 mt-2">
    <div class="card-header bg-light d-flex align-items-center justify-content-between">
      <strong>Results</strong>
      <small class="text-muted">
        <asp:Label runat="server" ID="lblResultInfo" />
      </small>
    </div>

    <div class="card-body p-0">
      <div class="table-responsive app-table-wrap">

        <asp:GridView ID="loadGridView" runat="server"
          AutoGenerateColumns="False"
          CssClass="table table-striped table-hover table-bordered mb-0"
         >
          <Columns>

            <asp:TemplateField HeaderText="SL" ItemStyle-Width="60px">
              <ItemTemplate>
                <asp:Label ID="LabelSL" runat="server" Text='<%# Container.DataItemIndex + 1 %>' />
                <asp:HiddenField runat="server" ID="hfEmpInfoId" Value='<%#Eval("EmpInfoId")%>' />
                <asp:HiddenField runat="server" ID="hfRoleType" Value='<%#Eval("RoleType")%>' />
              </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-Width="90px" />

            <asp:TemplateField HeaderText="Territory">
              <ItemTemplate>
                <asp:Label runat="server" ID="lblTerritory" Text='<%#Eval("Territory")%>' />
              </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="EmployeeName" HeaderText="Name Of the Employee" />
            <asp:BoundField DataField="RoleType" HeaderText="User Role" />

            <asp:TemplateField HeaderText="Base HQ">
              <ItemTemplate>
                <asp:Label runat="server" ID="hfTerritoryCode" Text='<%#Eval("TerritoryCode")%>' />
              </ItemTemplate>
            </asp:TemplateField>
               
           <asp:TemplateField HeaderText="DCP">
  <ItemTemplate>
    <asp:Label ID="lblDCP" runat="server" Text='<%# Eval("DCP") %>' />
  </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="DCR">
  <ItemTemplate>
    <asp:Label ID="lblDCR" runat="server" Text='<%# Eval("DCR") %>' />
  </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="RX">
  <ItemTemplate>
    <asp:Label ID="lblRX" runat="server" Text='<%# Eval("RX") %>' />
  </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Customer Visit Plan (CVP)">
    <ItemTemplate>
          <asp:Label ID="lblCustomerCoverage" runat="server" Text='<%# Eval("CustomerCoverage") %>' />
      
    </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Customer Visit Report (CVR)">
    <ItemTemplate>
        
          <asp:Label ID="lblCVRCount" runat="server" Text='<%# Eval("CVRCount") %>' />
       
    </ItemTemplate>
</asp:TemplateField>
              <asp:TemplateField HeaderText="Customer Coverage">
    <ItemTemplate>
        <asp:Label ID="lnkCustomerCsoveragenn" runat="server"
            Text='<%#Eval("CustomerCoverageNew")%>'
            
             />
    </ItemTemplate>
</asp:TemplateField> 

<asp:TemplateField HeaderText="GP Sales (Net TP)">
  <ItemTemplate>
    <asp:Label ID="lblGPSales" runat="server" Text='<%# Eval("GPSales") %>' />
  </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Total Sales (Net TP)">
  <ItemTemplate>
    <asp:Label ID="lblTSales" runat="server" Text='<%# Eval("TSalesNetTP") %>' />
  </ItemTemplate>
</asp:TemplateField>

          </Columns>
        </asp:GridView>

      </div>
    </div>
  </div>

  <!-- Detail Modal (server fills content & shows via ScriptManager) -->
  <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h6 class="modal-title">
            <i class="fa fa-list-alt"></i> Details
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
          </button>
        </div>
        <div class="modal-body">
          <asp:PlaceHolder runat="server" ID="phModalContent"></asp:PlaceHolder>
        </div>
      </div>
    </div>
  </div>

</div>

  <%--  </ContentTemplate>
</asp:UpdatePanel>--%>
<!-- Styles -->
<style>
  .app-topbar { z-index: 1030; }
  .app-table-wrap { max-height: 65vh; overflow: auto; }
  .kpi { border: 0; padding: .75rem; }
  .kpi-title { font-size: .8rem; color: #6c757d; margin-bottom: .25rem; }
  .kpi-value { font-size: 1.1rem; font-weight: 700; }
  /* App buttons */
  .btnMyDesignSearch { background: #0d6efd; color: #fff; border: 0; }
  .btnMyDesignSearch:hover { filter: brightness(.95); color: #fff; }
  .btnMyDesignReset { background: #6c757d; color: #fff; border: 0; }
  .btnMyDesignReset:hover { filter: brightness(.95); color: #fff; }
  /* Table fine-tune */
  .table th, .table td { vertical-align: middle; }
  /* Small screens: make action buttons full width */
  @media (max-width: 767.98px) {
    .app-table-wrap { max-height: 60vh; }
  }
</style>

<!-- Scripts -->
<script type="text/javascript">
  // Works with WebForms partial postbacks (Microsoft AJAX)
  function pageLoad() {
    try {
      // Datepicker (pickadate) – init if present
      if ($('.datepicker').length && typeof $('.datepicker').pickadate === 'function') {
        $('.datepicker').pickadate({ selectMonths: true, selectYears: true });
      }
      // Select2 – init if present
      if ($('.mySelect2').length && typeof $.fn.select2 === 'function') {
        $('.mySelect2').select2({
          theme: 'bootstrap4',
          width: function () {
            return $(this).data('width') ? $(this).data('width') :
              $(this).hasClass('w-100') ? '100%' : 'style';
          },
          placeholder: function () { return $(this).data('placeholder'); },
          allowClear: function () { return Boolean($(this).data('allow-clear')); }
        });
      }
    } catch (e) {
      console && console.warn && console.warn('Init error:', e);
    }
  }

  // Helper to show modal from server: ScriptManager.RegisterStartupScript(this, GetType(), "showModal", "$('#detailModal').modal('show');", true);
</script>

    </form>
</body>
</html>
