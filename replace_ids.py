import re

file_path = r"D:\Tools\param_ePharmaWeb\Solution.Web\SInventory_UI\CustomerPayment_DA.aspx.cs"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace property name
content = content.replace("SelectedInvoiceIds", "SelectedAppLogIds")

# Replace in BindSelectedGrid
content = content.replace('SelectedAppLogIds.Contains(row["InvoiceId"].ToString())', 'SelectedAppLogIds.Contains(row["PaymentCollectionAppLogId"].ToString())')

# Replace in UpdateReferenceNoFromGrid
content = content.replace('HiddenField hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");')

content = content.replace('if (hfInvoiceId == null || referenceNoTextBox == null)', 'if (hfPaymentCollectionAppLogId == null || referenceNoTextBox == null)')

content = content.replace('dataRow["InvoiceId"].ToString() == hfInvoiceId.Value', 'dataRow["PaymentCollectionAppLogId"].ToString() == hfPaymentCollectionAppLogId.Value')

content = content.replace('selectedGridView.DataKeys[i]["InvoiceId"]', 'selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"]')

content = content.replace('string invoiceId = selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"].ToString();\n                DataRow row = mainTable.AsEnumerable()\n                    .FirstOrDefault(dataRow => dataRow["InvoiceId"].ToString() == invoiceId);', 'string appLogId = selectedGridView.DataKeys[i]["PaymentCollectionAppLogId"].ToString();\n                DataRow row = mainTable.AsEnumerable()\n                    .FirstOrDefault(dataRow => dataRow["PaymentCollectionAppLogId"].ToString() == appLogId);')

# Replace in SyncMainGridCheckboxes
content = content.replace('HiddenField hfInvoiceId = (HiddenField)row.FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField)row.FindControl("hfPaymentCollectionAppLogId");')
content = content.replace('if (hfInvoiceId != null && chkSelect != null)', 'if (hfPaymentCollectionAppLogId != null && chkSelect != null)')
content = content.replace('selectedIds.Contains(hfInvoiceId.Value)', 'selectedIds.Contains(hfPaymentCollectionAppLogId.Value)')

# Replace in btnRemove_Click
content = content.replace('string invoiceId = btn.CommandArgument;', 'string appLogId = btn.CommandArgument;')
content = content.replace('selectedIds.Contains(invoiceId)', 'selectedIds.Contains(appLogId)')
content = content.replace('selectedIds.Remove(invoiceId);', 'selectedIds.Remove(appLogId);')

# Replace in chkSelectAll_CheckedChanged
content = content.replace('HiddenField hfInvoiceId = (HiddenField) row.FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField) row.FindControl("hfPaymentCollectionAppLogId");')
content = content.replace('if (ChkBoxRows == null || hfInvoiceId == null)', 'if (ChkBoxRows == null || hfPaymentCollectionAppLogId == null)')
content = content.replace('selectedIds.Contains(hfInvoiceId.Value)', 'selectedIds.Contains(hfPaymentCollectionAppLogId.Value)')
content = content.replace('selectedIds.Add(hfInvoiceId.Value);', 'selectedIds.Add(hfPaymentCollectionAppLogId.Value);')
content = content.replace('selectedIds.Remove(hfInvoiceId.Value);', 'selectedIds.Remove(hfPaymentCollectionAppLogId.Value);')

# Replace in Validation
content = content.replace('FirstOrDefault(r => r["InvoiceId"].ToString() == id);', 'FirstOrDefault(r => r["PaymentCollectionAppLogId"].ToString() == id);')

# Replace in saveButton_Click
content = content.replace('HiddenField hfInvoiceId = (HiddenField) orderGridView.Rows[i].FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField) orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");')
# Make sure we didn't miss this due to space:
content = content.replace('if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))', 'if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))')

# Replace in rejectButton_Click
content = content.replace('foreach (string invoiceIdStr in selectedIds)', 'foreach (string appLogIdStr in selectedIds)')
content = content.replace('dataRow["InvoiceId"].ToString() == invoiceIdStr', 'dataRow["PaymentCollectionAppLogId"].ToString() == appLogIdStr')

# In rejectButton_Click, we still need the invoiceId, but we are looking it up from the mainTable using appLogIdStr!
# The original code was:
# int invoiceId;
# if (int.TryParse(invoiceIdStr, out invoiceId))
# Let's see:
reject_old = """        foreach (string appLogIdStr in selectedIds)
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
        }"""
reject_new = """        foreach (string appLogIdStr in selectedIds)
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
        }"""
content = content.replace(reject_old, reject_new)

# Replace in CalculateTotal
# content already replaced the findControl part hopefully if it matches exact string but let's be sure:
content = content.replace('HiddenField hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");', 'HiddenField hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");')

# Replace in GenerateParameter
gen_param_old = """        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");

            if (hfInvoiceId != null && selectedIds.Contains(hfInvoiceId.Value))"""
gen_param_new = """        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            var hfPaymentCollectionAppLogId = (HiddenField)orderGridView.Rows[i].FindControl("hfPaymentCollectionAppLogId");
            var hfInvoiceId = (HiddenField)orderGridView.Rows[i].FindControl("hfInvoiceId");

            if (hfPaymentCollectionAppLogId != null && selectedIds.Contains(hfPaymentCollectionAppLogId.Value))"""
content = content.replace(gen_param_old, gen_param_new)

# Replace in chkSelect_CheckedChanged
chkselect_old = """        HiddenField hfInvoiceId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfInvoiceId"));

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
        }"""
chkselect_new = """        HiddenField hfPaymentCollectionAppLogId = ((HiddenField)orderGridView.Rows[rowindex].FindControl("hfPaymentCollectionAppLogId"));

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
        }"""
content = content.replace(chkselect_old, chkselect_new)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Done")
