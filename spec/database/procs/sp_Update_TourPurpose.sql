
CREATE PROCEDURE [dbo].[sp_Update_TourPurpose]
	-- Add the parameters for the stored procedure here
    @TPId   INT = 0 ,
    @TPName NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
		@IsActive BIT,
 	@IsOtherVisit int,
	@IsMarketVisit int,
	@Activedate DATETIME,
	@MIOAmount decimal(18,2),
	@AMAmount decimal(18,2),
	@DZSMAmount decimal(18,2) 
AS
    BEGIN

	declare @IsExtraBenifit bit=0
if(@IsMarketVisit=1)
begin
set @IsExtraBenifit=1
end

        UPDATE [dbo].[tbl_TourPlanPurpose]
        SET     TPName = @TPName,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive,      
                Activedate = @Activedate, [MIOAmount]=@MIOAmount
           ,[AMAmount]=@AMAmount
           ,[DZSMAmount]=@DZSMAmount
           ,[IsMarketVisit]=@IsMarketVisit
           ,[IsOtherVisit]=@IsOtherVisit, IsExtraBenifit=@IsExtraBenifit
        WHERE   TPId = @TPId

    END
