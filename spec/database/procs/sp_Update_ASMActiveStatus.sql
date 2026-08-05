-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_ASMActiveStatus]
	
	-- Add the parameters for the stored procedure here
	@ASMId INT,
	@InactiveBy INT

AS
BEGIN
   

  UPDATE tblASMInfo SET IsActive = 0,
						InActiveBy = @InactiveBy,
						ActiveInActiveDate = GETDATE() 
						WHERE ASMId = @ASMId


END
