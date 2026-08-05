CREATE   PROCEDURE [dbo].[sp_RPT_SalesReturnStatusByDate]
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;
   
    SELECT 
        CONVERT(date, SalesDocDate) AS SalesDocDate,
        COUNT(IdocNo) AS TotalIdoc,
        CASE 
            WHEN COUNT(IdocNo) > 0 THEN 'Yes'
            ELSE 'No'
        END AS HasIdoc, FORMAT(MAX(R.EntryDate), 'dd-MMM-yyyy hh:mm') AS SendDate,

        ISNULL(D.Qty, 0)      AS Qty,
        ISNULL(D.Discount, 0) AS Discount,
        ISNULL(D.TP, 0)       AS TP,
        ISNULL(D.VAT, 0)      AS VAT
    FROM SAP_API_Data..tblSalesReturnResponseData R
    OUTER APPLY
    (
        SELECT
            SUM(DC.Quantity)                   AS Qty,
            SUM(DC.DiscountAmount)             AS Discount,
            SUM(DC.Quantity * DC.UnitPrice)    AS TP,
            SUM(DC.VAT)                        AS VAT
        FROM SAP_API_Data..tbl_Return DC
        WHERE CONVERT(date, DC.SalesDocDate) = CONVERT(date, R.SalesDocDate)
          
    ) D
    WHERE YEAR(R.SalesDocDate)  = @Year
      AND MONTH(R.SalesDocDate) = @Month
    GROUP BY CONVERT(date, R.SalesDocDate), D.Qty, D.Discount, D.TP, D.VAT
    ORDER BY CONVERT(date, R.SalesDocDate);
END
