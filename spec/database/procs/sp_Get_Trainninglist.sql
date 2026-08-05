

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Trainninglist]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
SELECT  ISNULL(emp.EmpMasterCode+' : '+ emp.EmpName,us.UserName) empName,   CONVERT(NVARCHAR(50),T.FromDate,106)AS FromDate, CONVERT(NVARCHAR(50),T.ToDate,106)AS ToDate, convert(varchar,T.EntryDate, 0) EntryDate, * from  tblTrainning T

LEFT JOIN dbo.tblUser us ON us.UserId=t.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=us.EmpInfoId

order by T.EntryDate desc


END


