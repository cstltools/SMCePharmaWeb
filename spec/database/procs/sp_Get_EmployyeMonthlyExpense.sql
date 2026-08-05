-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_EmployyeMonthlyExpense]
	-- Add the parameters for the stored procedure here
		@EmpId NVARCHAR(max),
		@frmDate NVARCHAR(max),
		@ToDate NVARCHAR(max)
AS
BEGIN
   
 
    
SELECT tblDA.StationTypeName StationTypeName, ISNULL(tblDA.DAAmount,0) DAAmount , ISNULL(tblMilag.MilageExpense,0) MilageExpense, ISNULL(tblExpense.ExpenseAmount,0) ExpenseAmount, ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0) TotalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
 
 

 


 

LEFT JOIN (SELECT  st.StationTypeName, DAMas.EmpInfoId, SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
 left join tblStationType st on DAMas.TourTypeId= st.StationTypeId
 where DAMas.EmpInfoId=@EmpId and DATENAME(month,CONVERT(date,DAMas.EntryDate)) = @frmDate and YEAR(CONVERT(date,DAMas.EntryDate)) =@ToDate 

GROUP BY  DAMas.EmpInfoId,st.StationTypeName )tblDA    ON  tblDA.EmpInfoId= EmpMas.EmpInfoId 

 
LEFT JOIN (SELECT  milMas.EmpInfoId, SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0))  MilageExpense FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.EmpInfoId=@EmpId and   DATENAME(month,CONVERT(date,milMas.EntryDate)) = @frmDate and YEAR(CONVERT(date,milMas.EntryDate)) =@ToDate   GROUP BY  milMas.EmpInfoId)tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId 

LEFT JOIN (SELECT  EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK) where  EMas.EmpInfoId=@EmpId and    DATENAME(month,CONVERT(date,EMas.EntryDate)) = @frmDate and YEAR(CONVERT(date,EMas.EntryDate)) =@ToDate GROUP BY  EMas.EmpInfoId)tblExpense    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId 

WHERE EmpMas.EmpInfoId is not null    and EmpMas.EmpInfoId=@EmpId
 
END

 
