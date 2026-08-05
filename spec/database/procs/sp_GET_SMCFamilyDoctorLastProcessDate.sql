

 create PROCEDURE [dbo].[sp_GET_SMCFamilyDoctorLastProcessDate]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select  FORMAT(max(ProcessDate),'dd MMM, yyyy hh:mm tt') LastProcessDate from tblProcess_SMCFamilyDoctor  
      
    END


