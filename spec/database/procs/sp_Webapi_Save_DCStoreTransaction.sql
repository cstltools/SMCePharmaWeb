
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DCStoreTransaction]
	-- Add the parameters for the stored procedure here
    
    @DCStoreId INT,
    @Date DATETIME,
    @Id INT,
    @Type NVARCHAR(MAX),
    @Quantity DECIMAL(18,0)

AS
    BEGIN

INSERT INTO dbo.tblDCStoreTransaction
(
    DCStoreId,
    Date,
    Id,
    Type,
    Quantity
)
VALUES
(   @DCStoreId,
    @Date,
    @Id,
    @Type,
    @Quantity
    )

SELECT SCOPE_IDENTITY() AS Id
	END

