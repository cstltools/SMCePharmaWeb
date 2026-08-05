

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_ASMInfo]
	-- Add the parameters for the stored procedure here
	  @AreaId  INT ,
	  @ASMId  INT  
AS
BEGIN
		 
	SELECT * FROM dbo.tblASMInfo WHERE AreaId=@AreaId AND  ASMId NOT IN ( @ASMId) and tblASMInfo.IsActive=1

END



