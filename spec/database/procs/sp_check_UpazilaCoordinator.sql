

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_check_UpazilaCoordinator]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @EmpInfoId     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblUpazilaCoordinator WHERE EmpInfoId=@EmpInfoId AND UpCoordinatorId NOT IN ( @id)

END



