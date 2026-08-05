
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_SubTerritoryInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @TerritoryId INT ,
    @Name NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    --@remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME
AS
    BEGIN
       
	   	IF  NOT EXISTS (SELECT * FROM tblSubTerritory WHERE SubTerritoryName = @Name and TerritoryId=@TerritoryId)
		BEGIN

        DECLARE @codeD NVARCHAR(MAX)

        SELECT  @codeD = 'Sub_TERI-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(SubTerritoryId)
                                                           + 10001 )) )
        FROM    dbo.tblSubTerritory 


        INSERT  INTO dbo.tblSubTerritory
                ( SubTerritoryName ,
                  SubTerritoryCode ,
                  TerritoryId ,
                  IsActive ,
                  AcOrInAcDate ,
                  EntryBy ,
                  EntryDate 
                )
        VALUES  ( @Name ,
                  @codeD ,
                  @TerritoryId ,
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


