$filePath = "D:\Tools\param_ePharmaWeb\Solution.Web\SInventory_UI\CustomerPayment_DA.aspx.cs"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

$content = $content.Replace("SelectedInvoiceIds", "SelectedAppLogIds")

$content = $content.Replace('SelectedAppLogIds.Contains(row["InvoiceId"].ToString())', 'SelectedAppLogIds.Contains(row["PaymentCollectionAppLogId"].ToString())')

$content = $content.Replace('HiddenField hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");')

$content = $content.Replace('if (hfInvoiceId == null || referenceNoTextBox == null)', 'if (hfPaymentCollectionAppLogId == null || referenceNoTextBox == null)')

$content = $content.Replace('dataRow["InvoiceId"].ToString() == hfInvoiceId.Value', 'dataRow["PaymentCollectionAppLogId"].ToString() == hfPaymentCollectionAppLogId.Value')

$content = $content.Replace('selectedGridView.DataKeys[i]["InvoiceId"]', 'selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"]')

$content = $content.Replace('string invoiceId = selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"].ToString();
                DataRow row = mainTable.AsEnumerable()
                    .FirstOrDefault(dataRow => dataRow["InvoiceId"].ToString() == invoiceId);', 'string appLogId = selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"].ToString();
                DataRow row = mainTable.AsEnumerable()
                    .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == appLogId);')

$content = $content.Replace('HiddenField hfInvoiceId = (HiddenField)row.FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField)row.FindControl("hfPaymentCollectionAppLogId");')
$content = $content.Replace('if (hfInvoiceId != null && chkSelect != null)', 'if (hfPaymentCollectionAppLogId != null && chkSelect != null)')
$content = $content.Replace('selectedIds.Contains(hfInvoiceId.Value)', 'selectedIds.Contains(hfPaymentCollectionAppLogId.Value)')

$content = $content.Replace('string invoiceId = btn.CommandArgument;', 'string appLogId = btn.CommandArgument;')
$content = $content.Replace('selectedIds.Contains(invoiceId)', 'selectedIds.Contains(appLogId)')
$content = $content.Replace('selectedIds.Remove(invoiceId);', 'selectedIds.Remove(appLogId);')

$content = $content.Replace('HiddenField hfInvoiceId = (HiddenField) row.FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField) row.FindControl("hfPaymentCollectionAppLogId");')
$content = $content.Replace('if (ChkBoxRows == null || hfInvoiceId == null)', 'if (ChkBoxRows == null || hfPaymentCollectionAppLogId == null)')
$content = $content.Replace('selectedIds.Add(hfInvoiceId.Value);', 'selectedIds.Add(hfPaymentCollectionAppLogId.Value);')

$content = $content.Replace('FirstOrDefault(r => r["InvoiceId"].ToString() == id);', 'FirstOrDefault(r => r["PaymentCollectionAppLogId"].ToString() == id);')

$content = $content.Replace('HiddenField hfInvoiceId = (HiddenField) orderGridView.Rows[i].FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField) orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");')
$content = $content.Replace('if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))', 'if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))')

$content = $content.Replace('foreach (string invoiceIdStr in selectedIds)', 'foreach (string appLogIdStr in selectedIds)')
$content = $content.Replace('dataRow["InvoiceId"].ToString() == invoiceIdStr', 'dataRow["PaymentCollectionAppLogId"].ToString() == appLogIdStr')

$reject_old = @"
        foreach (string appLogIdStr in selectedIds)
        {
            int invoiceId;
            if (int.TryParse(appLogIdStr, out invoiceId))
            {
                DataRow row = mainTable.AsEnumerable()
                    .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == appLogIdStr);
                
                int appLogId = 0;
                if (row != null && mainTable.Columns.Contains("PaymentCollectionAppLogId") && row["PaymentCollectionAppLogId"] != DBNull.Value)
                {
                    int.TryParse(row["PaymentCollectionAppLogId"].ToString(), out appLogId);
                }

                if (aCustPaymentBll.RejectInvoiceDAPaymentCollection(invoiceId, appLogId))
                {
                    hasRejected = true;
                }
            }
        }
"@

$reject_new = @"
        foreach (string appLogIdStr in selectedIds)
        {
            DataRow row = mainTable.AsEnumerable()
                .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == appLogIdStr);
            
            int invoiceId = 0;
            if (row != null && row["InvoiceId"] != DBNull.Value)
            {
                int.TryParse(row["InvoiceId"].ToString(), out invoiceId);
            }
            
            int appLogId;
            if (int.TryParse(appLogIdStr, out appLogId) && invoiceId > 0)
            {
                if (aCustPaymentBll.RejectInvoiceDAPaymentCollection(invoiceId, appLogId))
                {
                    hasRejected = true;
                }
            }
        }
"@
$content = $content.Replace($reject_old.Replace("`r`n", "`n"), $reject_new.Replace("`r`n", "`n"))
$content = $content.Replace($reject_old, $reject_new)


$gen_param_old = @"
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");

            if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))
"@
$gen_param_new = @"
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
            var hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");

            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
"@
$content = $content.Replace($gen_param_old.Replace("`r`n", "`n"), $gen_param_new.Replace("`r`n", "`n"))
$content = $content.Replace($gen_param_old, $gen_param_new)

$chkselect_old = @"
        HiddenField hfInvoiceId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfInvoiceId"));

        List<string> selectedIds = SelectedAppLogIds;

        if (button.Checked)
        {
            if (hfInvoiceId != null && !selectedIds.Contains(hfInvoiceId.Value))
            {
                selectedIds.Add(hfInvoiceId.Value);
            }
        }
        else
        {
            if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))
            {
                selectedIds.Remove(hfInvoiceId.Value);
            }
        }
"@
$chkselect_new = @"
        HiddenField hfPaymentCollectionAppLogId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfPaymentCollectionAppLogId"));

        List<string> selectedIds = SelectedAppLogIds;

        if (button.Checked)
        {
            if (hfPaymentCollectionAppLogId != null && !selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                selectedIds.Add(hfPaymentCollectionAppLogId.Value);
            }
        }
        else
        {
            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))
            {
                selectedIds.Remove(hfPaymentCollectionAppLogId.Value);
            }
        }
"@
$content = $content.Replace($chkselect_old.Replace("`r`n", "`n"), $chkselect_new.Replace("`r`n", "`n"))
$content = $content.Replace($chkselect_old, $chkselect_new)

[System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
