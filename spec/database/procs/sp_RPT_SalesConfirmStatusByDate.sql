

CREATE PROCEDURE [dbo].[sp_RPT_SalesConfirmStatusByDate]
    @Month INT,
    @Year  INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CONVERT(date, R.SalesDocDate) AS SalesDocDate,
        COUNT(R.IdocNo)              AS TotalIdoc,
        CASE WHEN COUNT(R.IdocNo) > 0 THEN 'Yes' ELSE 'No' END AS HasIdoc,
        FORMAT(MAX(R.EntryDate), 'dd-MMM-yyyy hh:mm') AS SendDate,

        ISNULL(D.Qty, 0)      AS Qty,
        ISNULL(D.Discount, 0) AS Discount,
        ISNULL(D.TP, 0)       AS TP,
        ISNULL(D.VAT, 0)      AS VAT
    FROM SAP_API_Data..tblSalesConfirmResponseData R
    OUTER APPLY
    (
        SELECT
            SUM(DC.Quantity)                   AS Qty,
            SUM(DC.DiscountAmount)             AS Discount,
            SUM(DC.Quantity * DC.UnitPrice)    AS TP,
            SUM(DC.VAT)                        AS VAT
        FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales DC
        WHERE CONVERT(date, DC.SalesDocDate) = CONVERT(date, R.SalesDocDate)
          AND ISNULL(DC.isDemo, 0) = 1
    ) D
    WHERE YEAR(R.SalesDocDate)  = @Year
      AND MONTH(R.SalesDocDate) = @Month
    GROUP BY CONVERT(date, R.SalesDocDate), D.Qty, D.Discount, D.TP, D.VAT
    ORDER BY CONVERT(date, R.SalesDocDate);
END
