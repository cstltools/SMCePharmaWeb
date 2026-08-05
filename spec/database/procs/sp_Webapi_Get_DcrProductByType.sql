-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DcrProductByType]
	-- Add the parameters for the stored procedure here
	@empId INT,
	@type NVARCHAR(50) =null
AS
BEGIN
		
		DECLARE @typeid INT
        SELECT @typeid = GroupId FROM dbo.tblProductGroup WHERE LTRIM(RTRIM(GroupName))= @type

	SELECT A.ProductId,A.ProductCode,A.ProductName FROM dbo.tblProduct A 
	--INNER JOIN dbo.tblEmpGeneralInfo B ON B.CompanyId = A.CompanyId
	WHERE  A.ProductGroupId = @typeid


END

