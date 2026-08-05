-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_MIOActiveStatus]
	
	-- Add the parameters for the stored procedure here
	@MIOId INT,
	@InactiveBy INT

AS
BEGIN
   

  UPDATE tblMIOInfo SET IsActive = 0,
						InActiveBy = @InactiveBy,
						ActiveInActiveDate = GETDATE() 
						WHERE MIOId = @MIOId


END
