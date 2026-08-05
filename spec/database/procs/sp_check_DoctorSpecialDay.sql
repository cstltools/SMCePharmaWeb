
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorSpecialDay]
	-- Add the parameters for the stored procedure here
	  @SpecialDayId INT,
    @SpecialDay NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorSpecialDay WHERE SpecialDay=@SpecialDay AND SpecialDayId NOT IN ( @SpecialDayId)

END


