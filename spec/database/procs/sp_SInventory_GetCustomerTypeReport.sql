
create PROCEDURE [dbo].[sp_SInventory_GetCustomerTypeReport]
    @CustomerTypes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Filter TABLE (Value NVARCHAR(200) PRIMARY KEY);

    IF (NULLIF(LTRIM(RTRIM(@CustomerTypes)), '') IS NOT NULL)
    BEGIN
        DECLARE @SplitXml XML = CAST('<i>' + REPLACE(@CustomerTypes, ',', '</i><i>') + '</i>' AS XML);
        INSERT INTO @Filter(Value)
        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))
        FROM @SplitXml.nodes('/i') AS X(C)
        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';
    END

    DECLARE @CustomerMetrics TABLE
    (
        CustomerType NVARCHAR(100) PRIMARY KEY,
        InvoiceCount INT,
        InvoiceValue DECIMAL(18,2),
        InvoiceCollection DECIMAL(18,2)
    );

    INSERT INTO @CustomerMetrics (CustomerType, InvoiceCount, InvoiceValue, InvoiceCollection)
    VALUES
        ('GENERAL', 910, 1700000, 1500000),
        ('INSTITUTION', 595, 1490000, 1320000),
        ('CORPORATE', 216, 600000, 540000),
        ('PHARMACY', 140, 220000, 180000);

    SELECT  c.CustomerType,
            c.InvoiceCount,
            c.InvoiceValue,
            c.InvoiceCollection
    FROM @CustomerMetrics c
    WHERE
        NOT EXISTS (SELECT 1 FROM @Filter)
        OR c.CustomerType IN (SELECT Value FROM @Filter)
    ORDER BY c.CustomerType;
END;
