
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_SubMarketData]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @marketId INT ,
    @Name NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME
AS
    BEGIN


        DECLARE @codeD NVARCHAR(MAX)
        DECLARE @preFix NVARCHAR(50)
        DECLARE @postId INT


        IF EXISTS ( SELECT  *
                    FROM    dbo.tbl_SubMarket )
            BEGIN
                DECLARE @charIndex INT ,
                    @maxId INT
                DECLARE @strCode NVARCHAR(50)
                SELECT  @preFix = Prefix
                FROM    dbo.tbl_CodeSetup
                WHERE   SetupName = 'SubMarket'
                SELECT  @strCode = ( SELECT TOP 1
                                            SMCode
                                     FROM   dbo.tbl_SubMarket
                                     ORDER BY SMId DESC
                                   )
                SET @charIndex = CHARINDEX('-', @strCode)
                SET @maxId = ( CAST(SUBSTRING(@strCode, ( @charIndex + 1 ),
                                              LEN(@strCode)) AS INT) + 1 )
                SET @codeD = @preFix + '-' + CONVERT(NVARCHAR(MAX), @maxId)

            END
        ELSE
            BEGIN
                SELECT  @preFix = Prefix ,
                        @postId = StartFrom
                FROM    dbo.tbl_CodeSetup
                WHERE   SetupName = 'SubMarket'
                SET @codeD = @preFix + '-' + CONVERT(NVARCHAR(MAX), @postId)
            END



        INSERT  INTO dbo.tbl_SubMarket
                ( SMCode ,
                  SMName ,
                  MarketId ,
                  IsActive ,
                  AcOrInAcDate ,
                  CreatedBy ,
                  CreatedDate 
                )
        VALUES  ( @codeD ,
                  @Name ,
                  @marketId ,
                  @isActive ,
                  @acInAcDate ,
                  @createdBy ,
                  GETDATE()
                )


        SELECT  SCOPE_IDENTITY()
    END


