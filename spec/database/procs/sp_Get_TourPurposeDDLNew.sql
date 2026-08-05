
--------------------------------------------------
-- PROCEDURE: sp_Get_TourPurposeDDLNew
--------------------------------------------------
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_Get_TourPurposeDDLNew]
	-- Add the parameters for the stored procedure here

AS
BEGIN
 select * from (
   SELECT A.TPId,TPName + case when  isnull(ctTourPurposeId,0)=0 then ' (Not Done)' else ' (Done)' end   TPName
  
		  FROM [dbo].tbl_TourPlanPurpose A
		  left join (select count(TourPurposeId) ctTourPurposeId,  TourPurposeId from tblTourPurposeOtherSetup group by TourPurposeId) st on a.TPId=st.TourPurposeId
		  WHERE  A.IsOtherVisit=1 and A.IsActive=1
		  union all
		  SELECT A.TPId,TPName + case when  isnull(ctTourPurposeId,0)=0 then ' (Not Done)' else ' (Done)' end   TPName
  
		  FROM [dbo].tbl_TourPlanPurpose A
		  left join (select count(TourPurposeId) ctTourPurposeId,  TourPurposeId from tblTourPurposeOtherSetup group by TourPurposeId) st on a.TPId=st.TourPurposeId
		  WHERE  A.TPId=19 and A.IsActive=1
		  
		  ) tbl 
		ORDER BY 
    CASE 
        WHEN TPName LIKE '%(Done)%' THEN 1 
        ELSE 2 
    END;
END

