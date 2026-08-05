CREATE PROCEDURE [dbo].[spInsertTourPurposeOtherSetupDtl]
    @TourPurposeOtherSetupId INT,
    @RoleName NVARCHAR(50),
    @TerritoryId INT = NULL,
    @AreaId INT = NULL,
    @RegionId INT = NULL,
    @GroupId INT = NULL,
    @TourTypeId INT = NULL
AS
BEGIN
    -- Begin transaction to ensure atomicity


        -- Insert the data into tblTourPurposeOtherSetupDtl
        INSERT INTO [dbo].[tblTourPurposeOtherSetupDtl] 
        (
            TourPurposeOtherSetupId,
            RoleName,
            TerritoryId,
            AreaId,
            RegionId,GroupId,
            TourTypeId
        )
        VALUES
        (
            @TourPurposeOtherSetupId,
            @RoleName,
            @TerritoryId,
            @AreaId,
            @RegionId,@GroupId,
            @TourTypeId
        );

     
END
