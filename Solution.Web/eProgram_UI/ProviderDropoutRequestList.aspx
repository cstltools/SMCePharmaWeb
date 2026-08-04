<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ProviderDropoutRequestList.aspx.cs" Inherits="eProgram_UI_ProviderDropoutRequestList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .btn-approve-disabled {
            opacity: 0.45;
            cursor: not-allowed !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="page-wrapper">
        <div class="page-content">
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Provider Dropout List</div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body position-relative">
                            <div id="ajaxLoader" class="divWaiting" style="display: none;">
                                <img class="position-set" src="../images/Spinner.gif" alt="Loading" width="180" height="180" />
                            </div>

                            <div class="table-responsive">
                                <table id="tblProviderDropout" class="table table-bordered text-center thead-dark dtclass" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th>#SL</th>
                                            <th>Program</th>
                                            <th>Provider Code</th>
                                            <th>Provider Name</th>
                                            <th>Mobile No</th>
                                            <th>NID</th>
                                            <th>Email</th>
                                            <th>Outlet</th>
                                            <th>Dropout Reason</th>
                                            <th>Inserted At (UTC)</th>
                                            <th>Approve Date (UTC)</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            if ($.fn && $.fn.dataTable) {
                $.fn.dataTable.ext.errMode = "none";
            }

            $("#tblProviderDropout").on("error.dt", function () {
                toggleLoader(false);
                showFailMessage("Table rendering error.");
            });

            loadProviderDropoutList();

            $(document).on("click", ".btn-approve-dropout", function () {
                var $btn = $(this);
                var id = $btn.data("id");

                if (!id) {
                    showFailMessage("Invalid row id.");
                    return;
                }

                approveProviderDropout(id, $btn);
            });
        });

        function loadProviderDropoutList() {
            toggleLoader(true);

            $.ajax({
                type: "POST",
                url: "ProviderDropoutRequestList.aspx/GetProviderDropoutIntrigrationList",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                timeout: 30000
            }).done(function (response) {
                try {
                    var result = response && response.d ? response.d : null;

                    if (!result || result.isSuccess !== true) {
                        renderProviderDropoutRows([]);
                        showFailMessage(result && result.message ? result.message : "Data load failed.");
                        return;
                    }

                    renderProviderDropoutRows(result.data || []);
                } catch (error) {
                    renderProviderDropoutRows([]);
                    showFailMessage("Data processing failed.");
                }
            }).fail(function (xhr, status) {
                renderProviderDropoutRows([]);
                showFailMessage(status === "timeout" ? "Request timeout." : "Request failed.");
            }).always(function () {
                toggleLoader(false);
            });
        }

        function renderProviderDropoutRows(rows) {
            var $tbody = $("#tblProviderDropout tbody");
            $tbody.empty();

            if (!rows || rows.length === 0) {
                bindDropoutGrid();
                return;
            }

            $.each(rows, function (index, item) {
                var approved = isApprovedValue(item.isApprove);
                var actionHtml = approved
                    ? "<button type='button' class='btn btn-sm btn-secondary btn-approve-disabled' disabled='disabled'>Approved</button>"
                    : "<button type='button' class='btn btn-sm btn-info btn-approve-dropout' data-id='" + safeValue(item.providerIDropoutIntrigrationd) + "'>Approve</button>";

                var rowHtml = "<tr>"
                    + "<td>" + (index + 1) + "</td>"
                    + "<td>" + safeValue(item.programShortName) + "</td>"
                    + "<td>" + safeValue(item.providerCode) + "</td>"
                    + "<td>" + safeValue(item.providerName) + "</td>"
                    + "<td>" + safeValue(item.mobileNo) + "</td>"
                    + "<td>" + safeValue(item.nid) + "</td>"
                    + "<td>" + safeValue(item.email) + "</td>"
                    + "<td>" + safeValue(item.outlet) + "</td>"
                    + "<td>" + safeValue(item.dropoutReason) + "</td>"
                    + "<td>" + safeValue(item.insertedAt) + "</td>"
                    + "<td>" + safeValue(item.approveDate) + "</td>"
                    + "<td>" + actionHtml + "</td>"
                    + "</tr>";

                $tbody.append(rowHtml);
            });

            bindDropoutGrid();
        }

        function bindDropoutGrid() {
            try {
                if (!$.fn || !$.fn.dataTable) {
                    return;
                }

                if ($.fn.dataTable.isDataTable && $.fn.dataTable.isDataTable("#tblProviderDropout")) {
                    $("#tblProviderDropout").DataTable().destroy();
                }

                $("#tblProviderDropout").DataTable({
                    deferRender: true,
                    bInfo: true,
                    bFilter: true,
                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    pageLength: 10,
                    dom: "lfrtip",
                    language: {
                        emptyTable: "No data found."
                    }
                });
            } catch (error) {
                toggleLoader(false);
                showFailMessage("Table rendering error.");
            }
        }

        function approveProviderDropout(providerIDropoutIntrigrationd, $btn) {
            $btn.prop("disabled", true);
            toggleLoader(true);
            var approvedSuccessfully = false;

            $.ajax({
                type: "POST",
                url: "ProviderDropoutRequestList.aspx/ApproveProviderDropoutIntrigration",
                data: JSON.stringify({ providerIDropoutIntrigrationd: providerIDropoutIntrigrationd }),
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            }).done(function (response) {
                var result = response && response.d ? response.d : null;

                if (!result || result.isSuccess !== true) {
                    showFailMessage(result && result.message ? result.message : "Approve failed.");
                    return;
                }

                approvedSuccessfully = true;
                setApprovedButtonState($btn);
                showSuccessMessage(result.message || "Approved successfully.");
                setTimeout(function () {
                    loadProviderDropoutList();
                }, 150);
            }).fail(function () {
                showFailMessage("Approve request failed.");
            }).always(function () {
                if (!approvedSuccessfully) {
                    $btn.prop("disabled", false);
                }
                toggleLoader(false);
            });
        }

        function setApprovedButtonState($btn) {
            if (!$btn || $btn.length === 0) {
                return;
            }

            $btn.removeClass("btn-info btn-approve-dropout")
                .addClass("btn-secondary btn-approve-disabled")
                .text("Approved")
                .prop("disabled", true);
        }

        function safeValue(value) {
            if (value === null || value === undefined) {
                return "";
            }

            return $("<div/>").text(value).html();
        }

        function isApprovedValue(value) {
            if (value === true || value === 1 || value === "1") {
                return true;
            }

            if (typeof value === "string") {
                var normalizedValue = value.toLowerCase();
                return normalizedValue === "true" || normalizedValue === "yes";
            }

            return false;
        }

        function toggleLoader(show) {
            if (show) {
                $("#ajaxLoader").show();
            } else {
                $("#ajaxLoader").hide();
            }
        }

        function showFailMessage(message) {
            if (typeof faildalert === "function") {
                faildalert(message, "Faild");
            }
        }

        function showSuccessMessage(message) {
            if (typeof ShowSuccesalert === "function") {
                ShowSuccesalert(message, "Success");
            }
        }
    </script>
</asp:Content>
