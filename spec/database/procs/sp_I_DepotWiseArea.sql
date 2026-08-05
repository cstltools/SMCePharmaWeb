-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_I_DepotWiseArea] 

	@DepotId INT,
	@AreaId INT,
	@EntryBy INT

AS
BEGIN
	

	 INSERT INTO tblDcWiseAreaInfo
           (DCId
           ,AreaId
           ,IsActive
           ,EntryBy
           ,EntryDate)
     VALUES
           (@DepotId,
		   @AreaId,
		   1,
		   @EntryBy,
		   GETDATE())


	SELECT SCOPE_IDENTITY()

END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 


