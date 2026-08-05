CREATE PROCEDURE [dbo].[sp_Update_DcWiseTerritoryMaster]
	-- Add the parameters for the stored procedure here
	@DcWiseTerritoryMasterId INT,
    @DCId  INT
           ,@GroupId  INT
           ,@RegionId  INT
           ,@AreaId  INT,
            @SubDepotId  INT=NULL,

	@UpdateBy NVARCHAR(50)

   
AS
    BEGIN

       UPDATE [dbo].[tblDcWiseTerritoryMaster] set
    [DCId]=@DCId
           ,[GroupId]=@GroupId
           ,[RegionId]=@RegionId
           ,[AreaId]=@AreaId,
           SubDepotId=@SubDepotId,
	  UpdateBy=@UpdateBy,
	  UpdateDate=getdate()                     
        WHERE    DcWiseTerritoryMasterId = @DcWiseTerritoryMasterId

		--Delete From dbo.tblDcWiseTerritoryDetail where  DcWiseTerritoryMasterId = @DcWiseTerritoryMasterId
		 

    END

