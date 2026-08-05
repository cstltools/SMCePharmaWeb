create PROCEDURE [dbo].[sp_Save_SalesConfirmResponseData]
    @code NVARCHAR(50),
    @sales_doc_date NVARCHAR(20),  -- Accepting as NVARCHAR to parse dd.MM.yyyy
    @idoc_no NVARCHAR(50) 
AS
BEGIN
    SET NOCOUNT ON;

    -- Convert date from dd.MM.yyyy to DATE
    DECLARE @convertedDate DATE;
    SET @convertedDate = TRY_CONVERT(DATE, @sales_doc_date, 104);  -- 104 = German (dd.MM.yyyy)

    INSERT INTO SAP_API_Data..tblSalesConfirmResponseData (Code, SalesDocDate, IdocNo)
    VALUES (@code, @convertedDate, @idoc_no);

    select SCOPE_IDENTITY();
END;
