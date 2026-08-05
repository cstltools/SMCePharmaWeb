
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TerritoryThanaRelation]
	-- Add the parameters for the stored procedure here
@territroId INT,
@thanaId int
AS
BEGIN
	
INSERT INTO dbo.tbl_TerritoryThanaRelation
        ( TerritoryId, ThanaId )
VALUES  ( @territroId,
@thanaId
          )
END


