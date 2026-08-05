-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_BSPThana] -- Add the parameters for the stored procedure here
 
AS
BEGIN
	
	SELECT  UpazilaId ThanaId,UpazilaName ThanaName,DistrictId district_id FROM dbo.tblBSPUpazila WHERE IsActive = 1 

END

