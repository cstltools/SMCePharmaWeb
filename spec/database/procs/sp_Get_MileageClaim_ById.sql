-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Get_MileageClaim_ById]
	-- Add the parameters for the stored procedure here
	@id INT 


	 

AS
    BEGIN
	 SELECT (SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Mileage')AS ImagePreName,   *  FROM dbo.tbl_MileageClaim dmas
     
	  

	 

	  WHERE          MileageClaimId=@id
 
		
END


