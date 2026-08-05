-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_ExpenseClaimDetails]
	-- Add the parameters for the stored procedure here
@pk INT,
@typeDetailsId INT = NULL,
@vStr NVARCHAR(max) = NULL
AS
BEGIN
	
	INSERT INTO dbo.tbl_ExpenseClaimDetails
	        ( ExpenseClaimID ,
	          ExpenseTypDetailsId ,
	          ValueText
	        )
	VALUES  ( @pk,
	@typeDetailsId,
	@vStr
	        )
END

