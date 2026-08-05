-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DivisionAll]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT DivisionId,DivisionName FROM dbo.tbl_Division WHERE IsActive = 1

END

