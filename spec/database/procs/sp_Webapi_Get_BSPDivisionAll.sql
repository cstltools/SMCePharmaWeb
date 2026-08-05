-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_BSPDivisionAll]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT DivisionId,DivisionName FROM dbo.tblBSPDivision WHERE IsActive = 1

END

