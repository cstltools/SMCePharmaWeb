

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_RSMInfo]
	-- Add the parameters for the stored procedure here
	  @RegionId  INT ,
	  @RSMId  INT  
AS
BEGIN
		 
	SELECT * FROM dbo.tblRSMInfo WHERE RegionId=@RegionId and ISNULL(IsActive,0)=1 AND  RSMId NOT IN ( @RSMId)

END



