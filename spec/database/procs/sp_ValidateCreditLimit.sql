
CREATE PROCEDURE [dbo].[sp_ValidateCreditLimit]
    @CustomerId INT,
    @CustomerTypeId INT,
    @OrderGrossValue DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AllowedCreditLimit DECIMAL(18,2)
    DECLARE @IsCreditLimitExceeded BIT = 0

    -- ★★★ Customer-level rule কে CustomerType-level rule এর চেয়ে priority (TOP 1) ★★★
    SELECT TOP 1
        @AllowedCreditLimit = NB1.AllowedCreditLimit
    FROM dbo.tblInvoiceNotBinding NB1 WITH (NOLOCK)
    WHERE
        (
            (NB1.ApplyType = 'Customer' AND NB1.CustomerId = @CustomerId)
            OR
            (NB1.ApplyType = 'CustomerType' AND NB1.CustomerTypeId = @CustomerTypeId)
        )
        AND NB1.IsActive = 1
        AND CONVERT(date, GETDATE()) BETWEEN NB1.ActiveFromDate AND ISNULL(NB1.ActiveToDate, CONVERT(date, GETDATE()))
    ORDER BY
        CASE WHEN NB1.ApplyType = 'Customer' THEN 0 ELSE 1 END ASC

    IF ISNULL(@OrderGrossValue,0) > ISNULL(@AllowedCreditLimit,50000)
    BEGIN
        SET @IsCreditLimitExceeded = 1
    END

    SELECT
        @CustomerId AS CustomerId,
        @CustomerTypeId AS CustomerTypeId,
        ISNULL(@OrderGrossValue,0) AS OrderGrossValue,
        ISNULL(@AllowedCreditLimit,50000) AS AllowedCreditLimit,
        @IsCreditLimitExceeded AS IsCreditLimitExceeded

END
