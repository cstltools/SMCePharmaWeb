
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ExpenseTypeData_ByExpenseTypeId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        SELECT  ExpenseAmount,isFixed,RoleType_xp, STUFF( (SELECT CONCAT(',', mm.ExpenseTypDetailsId , '') FROM dbo.tbl_ExpenseTypeDetails mm (NOLOCK)   WHERE mm.ExpenseTypeId=A.ExpenseTypeId ORDER BY mm.ExpenseTypDetailsId FOR XML PATH ('') ),1,1,'') as ExpenseTypDetailsIdStr ,   A.ExpenseTypeId ,
                A.ExpenseTypeName ,
                A.ImageRequired ,         
                A.IsActive , A.*
           
    
        FROM    dbo.tbl_ExpenseTypeMaster A
  
				WHERE A.ExpenseTypeId = @id


    END


