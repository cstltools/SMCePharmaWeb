-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorSpecialDayDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@SpecialDayId INT,
	@SpecialDate Datetime

AS
BEGIN
	
	
	INSERT INTO [dbo].[tblDoctorSpecialDayDetail]
           (DoctorId
           ,SpecialDayId
           ,SpecialDate)
     VALUES
           (@DoctorId
           ,@SpecialDayId
           ,@SpecialDate)

END

