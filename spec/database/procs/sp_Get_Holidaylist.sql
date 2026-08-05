

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Holidaylist]
	
	--@Parameter NVARCHAR(max) = null

AS
BEGIN
   
	--DECLARE @Query NVARCHAR(MAX)

	--SET @Query = 'SELECT CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DelateStatus ,* FROM  Employe_LeaveTypeInfos  AS LVTP
	--	LEFT JOIN (SELECT DISTINCT LeaveTypeId, COUNT(LeaveTypeId) NoOf FROM Employee_YearlyLeaveBalance GROUP BY LeaveTypeId) AS C ON LVTP.LeaveTypeId = C.LeaveTypeId
	--	WHERE LVTP.LeaveTypeId IS NOT NULL ' 

	--	EXEC(@Query)

		SELECT 
			CASE  WHEN Entryemp.EmpName Is Null  THEN  usEntry.UserName 
		ELSE Entryemp.EmpName  
		END as EmpEntryby,
	    CASE  WHEN updateby.EmpName Is Null  THEN  up.UserName 
		ELSE updateby.EmpName  
		END as EmpUpdateBy,

		CASE  WHEN Inactiveby.EmpName Is Null  THEN  Inac.UserName 
		ELSE Inactiveby.EmpName  
		END as EmpInactiveBy, 	 

		format(LVTP.HolidayDate, 'dd-MMM-yyyy') HolidayDate,	
		format(LVTP.HolidayToDate, 'dd-MMM-yyyy') HolidayToDate,	
		convert(varchar,LVTP.EntryDate, 0) EntryDate,			
	    convert(varchar,LVTP.UpdateDate, 0) UpdateDate,

	    CONVERT(NVARCHAR(50),LVTP.InactiveDate,106)AS InactiveDate,
		Year(fs.YearFromDate) as FiscalYearDesc,
		 * FROM  Employee_GovtHolidays  AS LVTP
		
		LEFT JOIN tblUser usEntry ON usEntry.UserId = LVTP.EntryBy
		LEFT JOIN tblUser up ON up.UserId = LVTP.UpdateBy
		LEFT JOIN tblUser Inac ON Inac.UserId = LVTP.InactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = usEntry.EmpInfoId		
	    LEFT JOIN tblEmpGeneralInfo updateby  ON updateby.EmpInfoId = up.EmpInfoId		
		LEFT JOIN tblEmpGeneralInfo Inactiveby  ON Inactiveby.EmpInfoId = Inac.EmpInfoId	

		LEFT JOIN tblFiscalYearInfos fs On fs.FiscalYearId = LVTP.FiscalYear

		WHERE LVTP.HolidayId IS NOT NULL 


END
