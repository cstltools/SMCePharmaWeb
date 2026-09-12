<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DAExpenseDayWiseSummaryViewer.aspx.cs" Inherits="SInventory_RPTVIEW_DAExpenseDayWiseSummaryViewer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Expense Bill (Delivery, Market Visit, Tour)</title>
    <style type="text/css">
        body { font-family: "Times New Roman", Times, serif; font-size: 12px; color: #000; margin: 0; background-color: #f0f0f0; }
        .report-section {
            width: 210mm;
            margin: 8mm auto;
            padding: 8mm;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            box-sizing: border-box;
        }
        .title { text-align: center; font-weight: bold; }
        .title .co { font-size: 16px; }
        .title .div { font-size: 15px; }
        .title .rpt { font-size: 14px; text-decoration: underline; margin-top: 4px; }

        .info-row { width: 100%; border-collapse: collapse; margin-top: 10px; table-layout: fixed; }
        .info-row > tbody > tr > td { vertical-align: top; padding: 0 4px; }
        .info-box { border: 1px solid #000; border-radius: 10px; padding: 6px 8px; height: 100%; box-sizing: border-box; }
        .info-box .cap { font-weight: bold; font-size: 13px; }
        .info-box table { border-collapse: collapse; width: 100%; }
        .info-box td { padding: 3px 2px; white-space: nowrap; }
        .fill { display: inline-block; border-bottom: 1px solid #000; min-width: 40px; padding: 0 3px; }
        .fill-lg { min-width: 130px; }

        .grid { border-collapse: collapse; width: 100%; margin-top: 8px; table-layout: fixed; }
        .grid th, .grid td { border: 1px solid #000; padding: 3px 2px; font-size: 11px; }
        .grid th { background: #f2dff2; text-align: center; font-weight: bold; }
        .grid td { height: 17px; text-align: center; word-wrap: break-word; }
        .grid td.l { text-align: left; }
        .grid td.r { text-align: right; }
        .grid tr.subtotal td { background: #f2dff2; font-weight: bold; }
        .place-cap { border: 1px solid #000; background: #f2dff2; text-align: center; font-weight: bold; }

        .foot { width: 100%; border-collapse: collapse; margin-top: 6px; table-layout: fixed; }
        .foot > tbody > tr > td { vertical-align: top; }
        .feedback { border: 1px solid #000; border-radius: 10px; height: 95px; padding: 4px 6px; font-weight: bold; }
        .allow td { padding: 3px 2px; text-align: right; white-space: nowrap; font-weight: bold; }

        .sign { width: 100%; margin-top: 22px; border-collapse: collapse; table-layout: fixed; }
        .sign td { font-weight: bold; font-size: 11px; text-align: center; }

        .print-button { background-color: #2e3192; color: #fff; border: none; border-radius: 5px; padding: 10px 28px; font-size: 15px; cursor: pointer; font-weight: bold; }

        @page { size: A4 portrait; margin: 6mm; }
        @media print {
            body { background: #fff; margin: 0; }
            .report-section { width: 100%; margin: 0; padding: 0; box-shadow: none; page-break-after: always; }
            .report-section:last-child { page-break-after: auto; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="no-print" style="text-align: center; padding: 10px;">
            <button type="button" class="print-button" onclick="window.print();">&#128438; Print</button>
        </div>

        <asp:Literal ID="litReport" runat="server"></asp:Literal>

        <asp:Literal ID="litAutoPrint" runat="server"></asp:Literal>
    </form>
</body>
</html>
