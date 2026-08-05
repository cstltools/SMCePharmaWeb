
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_check_DoctorChamber]
	-- Add the parameters for the stored procedure here
	  @ChamberId INT = 0 ,
    @ChamberName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorChamber WHERE ChamberName=@ChamberName AND     ChamberId NOT IN ( @ChamberId)

END


