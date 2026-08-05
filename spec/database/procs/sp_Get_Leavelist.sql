

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Leavelist]
	
	--@Parameter NVARCHAR(max) = null

AS
BEGIN
   
	--DECLARE @Query NVARCHAR(MAX)

	--SET @Query = 'SELECT CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DelateStatus ,* FROM  Employe_LeaveTypeInfos  AS LVTP
	--	LEFT JOIN (SELECT DISTINCT LeaveTypeId, COUNT(LeaveTypeId) NoOf FROM Employee_YearlyLeaveBalance GROUP BY LeaveTypeId) AS C ON LVTP.LeaveTypeId = C.LeaveTypeId
	--	WHERE LVTP.LeaveTypeId IS NOT NULL ' 


	--	EXEC(@Query)

		SELECT CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '''' END AS DelateStatus ,  	 
		CASE  WHEN Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EnrtryBy,
	    CASE  WHEN Entryemp.EmpName Is Null  THEN  up.UserName 
		ELSE Entryemp.EmpName  
		END as UpdateBy,
	
		CONVERT(NVARCHAR,LVTP.EntryDate, 0) EntryDatee,			
	    CONVERT(NVARCHAR,LVTP.UpdateDate, 0) UpdateDatee,

		 * FROM  Employe_LeaveTypeInfos  AS LVTP
		LEFT JOIN (SELECT DISTINCT LeaveTypeId, COUNT(LeaveTypeId) NoOf FROM Employee_YearlyLeaveBalance GROUP BY LeaveTypeId) AS C ON LVTP.LeaveTypeId = C.LeaveTypeId
		LEFT JOIN tblUser us ON us.UserId = LVTP.EntryBy
		LEFT JOIN tblUser up ON up.UserId = LVTP.UpdateBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId				
		WHERE LVTP.LeaveTypeId IS NOT NULL 


END


