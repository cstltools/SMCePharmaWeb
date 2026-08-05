-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_RSMActiveStatus]
	
	-- Add the parameters for the stored procedure here
	@RSMId INT,
	@InactiveBy INT

AS
BEGIN
   

  UPDATE tblRSMInfo SET IsActive = 0,
						InActiveBy = @InactiveBy,
						InActiveDate = GETDATE() 
						WHERE RSMId = @RSMId


END
