-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_NonEffectiveReason] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT ReasonId, ReasonName  
			    FROM dbo.tblNonEffectiveReason WHERE IsActive = 1


END

