-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TPCustomerDetailList]
	-- Add the parameters for the stored procedure here
	@TourPlanId INT 
AS
BEGIN
	 
	SELECT distinct dtl.CustomerMasterId, cust.CustomerCode,cust.CustomerName  
        
             FROM dbo.tblTPCustomerDetail dtl with (nolock)
			 left join dbo.tblCustMaster cust on dtl.CustomerMasterId=cust.CustomerMasterId

			  WHERE dtl.TourPlanId = @TourPlanId
END

