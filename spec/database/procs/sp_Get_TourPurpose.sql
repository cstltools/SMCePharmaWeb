-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourPurpose]
	-- Add the parameters for the stored procedure here

AS
BEGIN
 
   SELECT case when isnull(IsMarketVisit,0) =1 then 'Market Visit' else 'Other Visit' end VisitType,   case when  IsExtraBenifit=1 then TPName+' [MIO: '+convert(nvarchar(max),MIOAmount)+ ', AM: '+convert(nvarchar(max),AMAmount)+ ', DZSM: '+convert(nvarchar(max),DZSMAmount)+']' else TPName end TPName,   *	 ,
          CONVERT(NVARCHAR(50),A.Activedate,106)AS ActiveInActiveDate	 
		  FROM [dbo].tbl_TourPlanPurpose A  WHERE A.IsDelate =0
		
END
