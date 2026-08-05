
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerInfos]
	@CustomerMasterId INT 
AS
    BEGIN
		
        SELECT * FROM dbo.tblCustMaster WHERE CustomerMasterId=@CustomerMasterId


    END


