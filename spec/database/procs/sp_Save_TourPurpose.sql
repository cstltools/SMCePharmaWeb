CREATE PROCEDURE [dbo].[sp_Save_TourPurpose]
	-- Add the parameters for the stored procedure here
	@TPId  INT,
    @TPName   NVARCHAR(MAX) ,
	@IsActive BIT,
	@IsOtherVisit int,
	@IsMarketVisit int,
	@Activedate DATETIME,
	@MIOAmount decimal(18,2),
	@AMAmount decimal(18,2),
	@DZSMAmount decimal(18,2),
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
		if not exists (select TPName from [tbl_TourPlanPurpose] where TPName=@TPName)
begin 
declare @IsExtraBenifit bit=0
if(@IsMarketVisit=1)
begin
set @IsExtraBenifit=1
end

        INSERT  INTO [dbo].[tbl_TourPlanPurpose]
                ( TPName,                   
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate , IsDelate,[MIOAmount]
           ,[AMAmount]
           ,[DZSMAmount]
           ,[IsMarketVisit]
           ,[IsOtherVisit], IsExtraBenifit
	            )
        VALUES  ( @TPName,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() ,0	,@MIOAmount 
           ,@AMAmount 
           ,@DZSMAmount 
           ,@IsMarketVisit 
           ,@IsOtherVisit,@IsExtraBenifit
	            )

SELECT SCOPE_IDENTITY()
End
else  Return 0
	
 
		
END


