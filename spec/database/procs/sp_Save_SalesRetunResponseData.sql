create PROCEDURE [dbo].[sp_Save_SalesRetunResponseData]
    @code NVARCHAR(50),
    @sales_doc_date NVARCHAR(20),  -- Format: 'dd.MM.yyyy'
    @idoc_no NVARCHAR(50) 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @convertedDate DATE;
    SET @convertedDate = TRY_CONVERT(DATE, @sales_doc_date, 104);  -- 104 = German (dd.MM.yyyy)

    INSERT INTO SAP_API_Data..tblSalesReturnResponseData (Code, SalesDocDate, IdocNo)
    VALUES (@code, @convertedDate, @idoc_no);

    select SCOPE_IDENTITY();
END;