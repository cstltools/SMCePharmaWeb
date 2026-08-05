CREATE   PROCEDURE dbo.spGetProviderTypeDeliveryNetAmointIntrigration
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        prgt.ProgramTypeName AS providerType,
        SUM(ISNULL(iv.DeliveryTpTotal, 0)) AS deliveryNetAmoint,
        CONVERT(DATE, iv.UpdateDate) AS updateDate
    FROM tblInvoice iv
    INNER JOIN tblOrder ord
        ON iv.OrderId = ord.OrderId
    INNER JOIN tblProgramType prgt
        ON prgt.ProgramTypeId = ord.ProgramTypeId
    WHERE CONVERT(DATE, iv.UpdateDate) = CONVERT(DATE, DATEADD(DAY, -1, GETDATE()))
    GROUP BY
        prgt.ProgramTypeName,
        CONVERT(DATE, iv.UpdateDate);
END
