

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Vali_PromoMIOTag]
	-- Add the parameters for the stored procedure here
	  @PromoGroupId  INT ,
	  @EmpInfoId  INT ,

      @PageName     NVARCHAR(MAX) 

AS
BEGIN

 

	 if(@PageName='PromoMIOTag')
	BEGIN	 
	SELECT dtl.MIOId FROM dbo.tblPromoMIOTagDetail dtl 
	inner join tblPromoMIOTagMaster mas on dtl.MIOTagMasterId=mas.MIOTagId
	  WHERE mas.PromoGroupId not in (@PromoGroupId) and   dtl.EmpInfoId=@EmpInfoId
 
	END
	
END



