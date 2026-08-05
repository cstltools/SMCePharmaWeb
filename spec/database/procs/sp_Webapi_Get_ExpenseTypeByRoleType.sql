-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseTypeByRoleType]
	-- Add the parameters for the stored procedure here
	@RoleType nvarchar(max)
AS
BEGIN
			

			SELECT ExpenseTypeId ,
                   ExpenseTypeName ,
                   ImageRequired ,ISNULL([ExpenseAmount],0) ExpenseAmount
      ,ISNULL([isFixed],0) isFixed
      
				    FROM dbo.tbl_ExpenseTypeMaster v
					left join tblRoleType rt on  v.RoleType_xp=rt.RoleTypeId
					WHERE IsActive  =0   and rt.RoleType=@RoleType


END

