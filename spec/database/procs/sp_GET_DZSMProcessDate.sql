

 CREATE PROCEDURE [dbo].[sp_GET_DZSMProcessDate]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select  FORMAT(max(DZSMProcessDate),'dd MMM, yyyy hh:mm tt') LastProcessDate 
	 , FORMAT(DATEADD(minute,30,max(DZSMProcessDate)),'dd MMM, yyyy hh:mm tt') NextProcessDate from tblDZSMProcessDate  
      
	  

    END


