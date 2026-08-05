-- =============================================
-- Author:		Liton
-- Create date: 02-Sep-2016
-- Description:	Update
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_FixedCustomer] 
	(
		@code NVARCHAR(MAX) = NULL
		
	)
AS
BEGIN

DECLARE @CustomerCode NVARCHAR(500)

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------

SELECT [Code] FROM [dbo].[FixedC] WHERE Code = @code

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@CustomerCode

WHILE @@FETCH_STATUS = 0
BEGIN

update tblCustMaster SET FixedCustomer=1
WHERE CustomerCode=@CustomerCode

UPDATE FixedC SET IsUploaded = 1
WHERE Code = @CustomerCode

FETCH NEXT FROM @MyCursor
INTO 
@CustomerCode

END
CLOSE @MyCursor
DEALLOCATE @MyCursor

END

