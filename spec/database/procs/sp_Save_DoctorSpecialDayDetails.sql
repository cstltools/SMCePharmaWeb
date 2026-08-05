-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_DoctorSpecialDayDetails]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@SpecialDayId INT,
	@SpecialDate datetime=null 

AS
BEGIN
	
	INSERT INTO [dbo].tblDoctorSpecialDayDetail
           (DoctorId
           ,SpecialDayId
           ,SpecialDate )
     VALUES
           (@DoctorId
           ,@SpecialDayId,@SpecialDate)
END

