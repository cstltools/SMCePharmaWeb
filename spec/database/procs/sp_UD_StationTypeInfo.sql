

CREATE PROCEDURE [dbo].[sp_UD_StationTypeInfo]
	-- Add the parameters for the stored procedure here
     @id INT = 0 ,
    @StationTypeName   NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT  ,
	  @StartTime TIME ,
    @EndTime TIME 

AS
    BEGIN


		UPDATE tblStationType 
		SET  StartTime=@StartTime,EndTime=@EndTime,  StationTypeName = @StationTypeName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE StationTypeId =  @id
       

    END

