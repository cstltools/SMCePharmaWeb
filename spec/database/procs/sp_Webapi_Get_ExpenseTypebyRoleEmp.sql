-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseTypebyRoleEmp]
	-- Add the parameters for the stored procedure here
	@RoleType nvarchar(max),
	@empId nvarchar(max)

AS
BEGIN
	--		declare @RoleType nvarchar(max),
	--@empId nvarchar(max) 

	--set @RoleType='1,2'
	--set @empId='129,165,181'

		select  distinct * from (	SELECT   
       v.ExpenseTypeId,
       v.ExpenseTypeName,
       v.ImageRequired,
       ISNULL(v.ExpenseAmount, 0) AS ExpenseAmount,
       ISNULL(v.isFixed, 0) AS isFixed
FROM dbo.tbl_ExpenseTypeMaster v
CROSS APPLY fnSplit(v.RoleTypeMult, ',') AS s
--CROSS APPLY fnSplit(v.EmpNameMult, ',') AS sEmp
WHERE v.IsActive = 1 
  AND    ( s.item in (@RoleType) 
 -- or sEmp.item in ( @empId)
  )


  union all

  
			SELECT   
       v.ExpenseTypeId,
       v.ExpenseTypeName,
       v.ImageRequired,
       ISNULL(v.ExpenseAmount, 0) AS ExpenseAmount,
       ISNULL(v.isFixed, 0) AS isFixed
FROM dbo.tbl_ExpenseTypeMaster v
--CROSS APPLY fnSplit(v.RoleTypeMult, ',') AS s
CROSS APPLY fnSplit(v.EmpNameMult, ',') AS sEmp
WHERE v.IsActive = 1 
 -- AND    ( s.item in (@RoleType) 
and sEmp.item in ( @empId)
   )
   tbl
END

