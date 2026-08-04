<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TopSheetAndPickingslipHtmlViewer_daaw.aspx.cs" Inherits="SInventory_RPTVIEW_TopSheetAndPickingslipHtmlViewer_daaw" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Topsheet and Store Picking Report</title>
    <style type="text/css">
        body { font-family: Arial, sans-serif; font-size: 11px; color: #000; margin: 0; background-color: #f0f0f0; }
        .report-section { 
            width: 210mm;
            min-height: 297mm;
            margin: 8mm auto; 
            padding: 8mm 8mm;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            box-sizing: border-box;
            overflow: hidden;
        }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; table-layout: fixed; word-wrap: break-word; }
        th, td { border: 1px solid #999; padding: 4px 3px; }
        th { font-weight: bold; text-align: center; }
        td { text-align: center; }
        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .print-button { margin: 10px 5px; padding: 8px 18px; font-size: 14px; cursor: pointer; }
        
        @page { size: A4 portrait; margin: 8mm; }
        @media print {
            body { background: #fff; margin: 0; }
            .report-section { 
                width: 100%; 
                min-height: auto; 
                margin: 0; 
                padding: 0; 
                box-shadow: none; 
                border: none;
                overflow: visible;
            }
            table { width: 100%; table-layout: fixed; }
            .no-print { display: none !important; }
            .page-break { page-break-before: always; }
        }
        
        .header-table { table-layout: auto !important; }
        .header-table th, .header-table td { border: none !important; padding: 0 !important; }
        .header-box { border: 1.5px dotted #999; padding: 5px 30px; font-size: 15px; font-weight: bold; font-style: italic; display: inline-block; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="no-print" style="text-align: center; padding: 10px;">
            <button type="button" class="print-button" onclick="printReport();" 
                style="background-color: #2e3192; color: #fff; border: none; border-radius: 5px; padding: 10px 28px; font-size: 15px; cursor: pointer; font-weight: bold;">
                &#128438; Print
            </button>
        </div>
        <script type="text/javascript">
            var batchNo = '<asp:Literal ID="litBatchNoJs" runat="server"></asp:Literal>';
            function printReport() {
                if (batchNo) { document.title = batchNo; }
                window.print();
            }
        </script>

        <div class="report-section">
            <!-- Topsheet Header -->
            <table class="header-table" style="width: 100%;">
                <tr>
                    <td style="width: 80px; vertical-align: top;" rowspan="2">
                        <img src="../images/smc-logo-(horizontal).png" style="height: 50px;" alt="SMC Logo" onerror="this.src='../images/logo.png';" />
                    </td>
                    <td style="text-align: left; vertical-align: top; padding-left: 10px !important;">
                        <div style="font-size: 18px; font-weight: bold; font-style: italic; color: #2e3192;">SMC Enterprise Ltd</div>
                        <div style="font-size: 12px; margin-top: 3px;">SMC Tower, 33, Banani C/A, Dhaka - 1213</div>
                    </td>
                    <td style="text-align: right; vertical-align: top;">
                        <div style="font-size: 11px; font-weight: bold; font-style: italic; margin-top: 15px;">
                            Code: <asp:Literal ID="litBatchNo" runat="server"></asp:Literal>, 
                            Sales Assistant: <asp:Literal ID="litDeliveryMan" runat="server"></asp:Literal>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; vertical-align: bottom; padding-bottom: 5px !important;">
                        <div class="header-box">Invoice Top Sheet Report</div>
                    </td>
                    <td style="text-align: right; vertical-align: bottom; padding-bottom: 5px !important;">
                        <div style="font-weight: bold; font-size: 11px;">
                            Print On : <asp:Literal ID="litPrintDate" runat="server"></asp:Literal>
                        </div>
                    </td>
                </tr>
            </table>

            <hr style="border: 0; border-top: 1px solid #000; margin: 0 0 10px 0;" />

            <asp:Literal ID="litTopSheetContent" runat="server"></asp:Literal>

            <br />
            <br />

            <!-- Store Picking Header -->
            <div style="text-align: center; margin-bottom: 5px;">
                <div class="header-box">Store Picking</div>
            </div>

            <hr style="border: 0; border-top: 1px solid #000; margin: 0 0 10px 0;" />

            <asp:Literal ID="litPickingSlipContent" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>
