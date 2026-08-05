
 
  CREATE PROCEDURE [dbo].[sp_GET_DoctorSpecialDayDetail_ById]

	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	  SELECT spDay.SpecialDay SpecialDay, FORMAT(mas.SpecialDate,'dd MMMM, yyyy') SpecialDate, * from tblDoctorSpecialDayDetail mas with (nolock)
	  left JOIN dbo.tblDoctorSpecialDay spDay ON spDay.SpecialDayId = mas.SpecialDayId

	  
	  where mas.DoctorId = @id
      
    END


