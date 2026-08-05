-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_CustProductLineDetail]
	-- Add the parameters for the stored procedure here

	@ProductLineID INT,
	@CustomerMasterId INT

AS
BEGIN
	
	INSERT INTO [dbo].[tblCustProductLine]
           ([ProductLineID]
           ,[CustomerMasterId])
     VALUES
           (@ProductLineID
           ,@CustomerMasterId)
END

