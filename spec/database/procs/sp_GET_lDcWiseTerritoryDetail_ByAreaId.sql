

 CREATE PROCEDURE [dbo].[sp_GET_lDcWiseTerritoryDetail_ByAreaId]
	-- Add the parameters for the stored procedure here
   @DCId NVARCHAR(max),
   @SubDepotId NVARCHAR(max)


AS
    BEGIN

	IF(@SubDepotId=0)
	 BEGIN
	select TerritoryId,mas.DcWiseTerritoryMasterId from tblDcWiseTerritoryDetail dtl  with (nolock) 

	inner join tblDcWiseTerritoryMaster mas on dtl.DcWiseTerritoryMasterId=mas.DcWiseTerritoryMasterId
	 
	 where mas.DCId= @DCId
      
    END
	ELSE
     BEGIN
	select TerritoryId,mas.DcWiseTerritoryMasterId from tblDcWiseTerritoryDetail dtl  with (nolock) 

	inner join tblDcWiseTerritoryMaster mas on dtl.DcWiseTerritoryMasterId=mas.DcWiseTerritoryMasterId
	 
	 where mas.DCId= @DCId AND  SubDepotId=@SubDepotId
      
    END
    END

