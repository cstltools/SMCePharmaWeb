-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Save_TopSheetGenReportCode]
	-- Add the parameters for the stored procedure here
    @EntryBy int,
    @DeliveryMan NVARCHAR(MAX)
as

BEGIN

DECLARE @CustCode NVARCHAR(MAX)
	DECLARE @CustCodeint INT
SELECT TOP 1 @CustCodeint=CONVERT(INT,SUBSTRING(TopSheetGenCode,3,LEN(TopSheetGenCode)+1))+1 FROM dbo.tblTopSheetGenReport   ORDER BY TopSheetGenReportId DESC
 SET @CustCode='TP'+CONVERT(NVARCHAR(MAX),ISNULL(@CustCodeint,'1001'))
PRINT @CustCode
PRINT @CustCodeint

     
		 
   INSERT INTO [dbo].[tblTopSheetGenReport]
           ([TopSheetGenCode]
           ,[EntryBy]
           ,[EntryDate], DeliveryMan)
     VALUES
           (@CustCode 
           ,@EntryBy 
           ,GETDATE(),@DeliveryMan)

SELECT SCOPE_IDENTITY()

END
 

