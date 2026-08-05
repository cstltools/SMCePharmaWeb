-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteDwpotToWhChalan]

	@masterId INT
    
AS
BEGIN


	DELETE  FROM dbo.tblDepotToWHChalanInfo WHERE SChalanId = @masterId
	DELETE  FROM dbo.tblDepotToWHChalanDetail WHERE SChalanId = @masterId

 

END

