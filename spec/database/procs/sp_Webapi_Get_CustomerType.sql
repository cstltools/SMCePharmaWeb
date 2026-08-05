-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerType]
	-- Add the parameters for the stored procedure here
AS
    BEGIN
		
        SELECT  CustomerTypeId ,
                CustomerType
        FROM    dbo.tblCustomerType
        WHERE   IsActive = 1


    END

