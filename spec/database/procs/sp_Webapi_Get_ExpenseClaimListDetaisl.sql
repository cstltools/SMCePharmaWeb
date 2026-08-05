-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseClaimListDetaisl]
	-- Add the parameters for the stored procedure here
    @ExpenseClaimID INT  
AS
    BEGIN
	
        SELECT distinct  ExpDtlT.ExpenseTypDetailsId,  ExpDtl.FieldName,ExpDtlT.ValueText 
                FROM    tbl_ExpenseClaimDetails ExpDtlT 
                       -- LEFT JOIN dbo.tbl_ExpenseTypeMaster B ON B.ExpenseTypeId = A.ExpenseTypeId
                        LEFT JOIN dbo.tbl_ExpenseTypeDetails ExpDtl ON ExpDtl.ExpenseTypDetailsId = ExpDtlT.ExpenseTypDetailsId
                       
                      
                     where ExpDtlT.ExpenseClaimID=@ExpenseClaimID

    END

