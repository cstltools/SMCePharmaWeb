-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourPlanTypeDDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
 select st.StationTypeId TourTypeId,st.StationTypeName + case when St.Isactive=0 then ' (Inactive)' else '' end  TourTypeName from tblStationType   st where St.Isactive=1

END
