-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_UD_DepotWiseArea] 

	@DepotWiseAreaId INT,
	@UpdateBy INT

AS
BEGIN
	

	UPDATE dbo.tblDcWiseAreaInfo SET IsActive = 0,UpdateBy = @UpdateBy,UpdateDate = GETDATE()
	WHERE DcWiseAreaId = @DepotWiseAreaId	

END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 


