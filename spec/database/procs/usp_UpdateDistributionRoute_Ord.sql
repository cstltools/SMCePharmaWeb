
CREATE PROCEDURE dbo.usp_UpdateDistributionRoute_Ord
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        UPDATE o
        SET o.DistributionRoute_Ord = rt.RouteName
        FROM dbo.tblOrder o
        INNER JOIN dbo.tblInvoice i WITH (NOLOCK)
                ON o.OrderId = i.OrderId
        INNER JOIN dbo.tblCompanyUnit cu WITH (NOLOCK)
                ON o.ComUnitCode = cu.ComUnitCode
        INNER JOIN dbo.tblRouteInformationMaster rt WITH (NOLOCK)
                ON o.DistributionRouteid = rt.RouteInformationMasterId
        INNER JOIN (
                SELECT D.InvoiceId, SUM(D.NetAmount) AS ManufacId
                FROM dbo.tblInvoiceDetail D WITH (NOLOCK)
                GROUP BY D.InvoiceId
        ) AS tblD
                ON i.InvoiceId = tblD.InvoiceId
        WHERE i.TpGrandTotal > 0
          AND o.DistributionRoute_Ord IS NULL;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrState INT = ERROR_STATE();

        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END
