
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseClaimList]
	-- Add the parameters for the stored procedure here
    @monthValue INT ,
    @yearValue INT ,
    @statusTxt NVARCHAR(50) ,
    @empId INT
AS
    BEGIN
	
	if(@statusTxt='' or @statusTxt is null)
	begin

set	@statusTxt= 'All'
	end
        IF ( @statusTxt = 'All' )
            BEGIN
                SELECT (SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='ExpenseMy')+CAST(A.ExpenseClaimID as nvarchar(max))+'.jpg' AS   ImageString, A.ExpenseTypeId, A.ExpenseClaimID,  CONVERT(NVARCHAR(50), A.ExpenseDate, 106) AS ExpDate ,
                        ( C.EmpName + ' - ' + C.EmpMasterCode ) AS EmpName ,
                        B.ExpenseTypeName ,
                        A.ApprovalStatus ,
                        A.Amount ,
                        A.ExpenseClaimID,A.Remarks,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Expense')AS ImagePreName
                FROM    dbo.tbl_ExpenseClaim A
                        LEFT JOIN dbo.tbl_ExpenseTypeMaster B ON B.ExpenseTypeId = A.ExpenseTypeId
                        LEFT JOIN dbo.tblEmpGeneralInfo C ON C.EmpInfoId = A.EmpInfoId
                WHERE   MONTH(A.ExpenseDate) = @monthValue
                        AND YEAR(A.ExpenseDate) = @yearValue
                        AND A.EmpInfoId = @empId
            END
        ELSE
            BEGIN
                  SELECT (SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='ExpenseMy')+CAST(A.ExpenseClaimID as nvarchar(max))+'.jpg' AS   ImageString, A.ExpenseTypeId, A.ExpenseClaimID,  CONVERT(NVARCHAR(50), A.ExpenseDate, 106) AS ExpDate ,
                        ( C.EmpName + ' - ' + C.EmpMasterCode ) AS EmpName ,
                        B.ExpenseTypeName ,
                        A.ApprovalStatus ,
                        A.Amount ,
                        A.ExpenseClaimID,A.Remarks,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Expense')AS ImagePreName
                FROM    dbo.tbl_ExpenseClaim A
                        LEFT JOIN dbo.tbl_ExpenseTypeMaster B ON B.ExpenseTypeId = A.ExpenseTypeId
                        LEFT JOIN dbo.tblEmpGeneralInfo C ON C.EmpInfoId = A.EmpInfoId
                WHERE   MONTH(A.ExpenseDate) = @monthValue
                        AND YEAR(A.ExpenseDate) = @yearValue
                        AND A.ApprovalStatus = @statusTxt
                        AND A.EmpInfoId = @empId
            END


    END
