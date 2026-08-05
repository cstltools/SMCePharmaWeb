

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_Trainning]
	-- Add the parameters for the stored procedure here
	@TrainningId INT,
    @Title Nvarchar(MAX) =NULL,
	@Description Nvarchar(MAX) =null,
	@TrainningMeterial Nvarchar(MAX) =null,
	@FromDate Datetime =null,
	@ToDate Datetime =null,
	@EntryBy int = null,
	@IsActive bit = null
AS
    BEGIN
	
        INSERT  INTO [dbo].[tblTrainning]
                ( Title ,                
                  Description,
                  TrainningMeterial ,	     
				  FromDate,
				  ToDate,
				  IsActive,
                  EntryBy,
                  EntryDate 
	            )
        VALUES  ( @Title ,              
                  @Description ,
                  @TrainningMeterial,	
				  @FromDate,
				  @ToDate,
				  @IsActive,
				  @EntryBy,		
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()

END



