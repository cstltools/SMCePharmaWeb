-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_DoctorExpenseClaim_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT  (SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Expense')AS ImagePreName,  A.ExpenseDate, *  	  
		  FROM dbo.tbl_ExpenseClaim A
		  LEFT JOIN tbl_ExpenseClaimDetails DTL ON DTL.ExpenseClaimID = A.ExpenseClaimID
		 
		 LEFT JOIN dbo.tbl_ExpenseTypeDetails exDtl ON exDtl.ExpenseTypDetailsId = DTL.ExpenseTypDetailsId
				WHERE A.ExpenseClaimID = @id

    END


