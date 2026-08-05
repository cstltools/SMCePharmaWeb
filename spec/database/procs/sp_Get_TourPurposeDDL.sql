-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourPurposeDDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
 
   SELECT A.TPId,TPName +' ('+ case when isnull(IsMarketVisit,0) =1 then 'Market Visit' else 'Other Visit' end  + ') '  TPName,A.*
  
		  FROM [dbo].tbl_TourPlanPurpose A  --WHERE A.IsDelate =0
		
END
