-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DcWiseTerritoryDetail]
	-- Add the parameters for the stored procedure here
	 

@DcWiseTerritoryMasterId  INT
          
           
           ,@TerritoryId  int =NULL
          
AS
    BEGIN
	
    IF not EXISTS ( SELECT  * FROM    dbo.tblDcWiseTerritoryDetail where TerritoryId=@TerritoryId)
            BEGIN
  
INSERT INTO [dbo].tblDcWiseTerritoryDetail
           (DcWiseTerritoryMasterId
          
           ,TerritoryId
           )
     VALUES
           (@DcWiseTerritoryMasterId 
         
           ,@TerritoryId 
          )

 END 
 --else

   --BEGIN
  
--INSERT INTO [dbo].tblDcWiseTerritoryDetail
--           (DcWiseTerritoryMasterId
          
--           ,TerritoryId
--           )
--     VALUES
--           (@DcWiseTerritoryMasterId 
         
--           ,@TerritoryId 
--          )

 --END 


END

