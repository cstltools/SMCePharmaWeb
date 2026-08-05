
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Thana_WithTagInfo]
	-- Add the parameters for the stored procedure here

AS
BEGIN

SELECT DISTINCT  A.ThanaId , A.ThanaName, 0 AS IsDisable
FROM    dbo.tbl_Thana A
         
         
		WHERE A.IsActive = 1  order by  A.ThanaName asc





END


