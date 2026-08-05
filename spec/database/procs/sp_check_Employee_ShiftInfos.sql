
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Employee_ShiftInfos]
	-- Add the parameters for the stored procedure here
	  @ShiftId INT = 0 ,
    @ShiftText NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tbl_Shift WHERE ShiftText=@ShiftText AND    ShiftId NOT IN ( @ShiftId)

END


