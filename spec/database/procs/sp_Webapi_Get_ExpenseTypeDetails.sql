-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseTypeDetails]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
			

			SELECT ExpenseTypDetailsId ,
                   m.ExpenseTypeId ,
                   FieldName ,
                   IsRequied , ISNULL([ExpenseAmount],0) ExpenseAmount
      ,ISNULL([isFixed],0) isFixed FROM dbo.tbl_ExpenseTypeDetails m
				   inner join dbo.tbl_ExpenseTypeMaster v on m.ExpenseTypeId=v.ExpenseTypeId
				   WHERE m.ExpenseTypeId = @id


END

