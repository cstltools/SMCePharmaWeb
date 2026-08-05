
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TerritoryInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @areaId INT ,
    @Name NVARCHAR(MAX) ,
    @CodeStr NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME
AS
    BEGIN
       
	   	IF  NOT EXISTS (SELECT * FROM tblTerritory WHERE TerritoryName = @Name and areaId=@areaId)
		BEGIN

        DECLARE @codeD NVARCHAR(MAX)

        SELECT  @codeD = 'TERI-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(TerritoryId)
                                                           + 10001 )) )
        FROM    dbo.tblTerritory 


        INSERT  INTO dbo.tblTerritory
                ( TerritoryName ,
                  TerritoryCode ,CodeStr,
                  AreaId ,
                  IsActive ,
                  AcOrInAcDate ,
                  EntryBy ,
                  EntryDate 
                )
        VALUES  ( @Name ,@CodeStr,
                  @codeD ,
                  @areaId ,
                  @isActive ,
                  @acInAcDate ,
                  @createdBy ,
                  GETDATE()
                )


        SELECT  SCOPE_IDENTITY()
		END

       	ELSE  	
		Return 0 
    END


