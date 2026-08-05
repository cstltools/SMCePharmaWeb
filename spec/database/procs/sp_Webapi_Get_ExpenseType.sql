-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseType]
	-- Add the parameters for the stored procedure here

AS
BEGIN
			

			SELECT ExpenseTypeId ,
                   ExpenseTypeName ,
                   ImageRequired 
				    FROM dbo.tbl_ExpenseTypeMaster WHERE IsActive  =1 


END

