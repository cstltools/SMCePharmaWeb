


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_EmployeeLeaveIinfo_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

	--SELECT CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '''' END AS DelateStatus ,  	 


      --Select * from Employe_LeaveTypeInfos where LeaveTypeId = @id


		SELECT   	 
		    CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,
		    CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,
					
		CONVERT(NVARCHAR(50),LVTP.EntryDate,106)AS EntryDatee,
		CONVERT(NVARCHAR(50),LVTP.UpdateDate,106)AS UpdateDatee,
		CONVERT(NVARCHAR(50),LVTP.InactiveDate,106)AS InactiveDatee,
		 * FROM  Employe_LeaveTypeInfos  AS LVTP
		LEFT JOIN (SELECT DISTINCT LeaveTypeId, COUNT(LeaveTypeId) NoOf FROM Employee_YearlyLeaveBalance GROUP BY LeaveTypeId) AS C ON LVTP.LeaveTypeId = C.LeaveTypeId
		LEFT JOIN tblUser us ON us.UserId = LVTP.EntryBy
		LEFT JOIN tblUser up ON up.UserId = LVTP.UpdateBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = LVTP.InactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId		
		WHERE LVTP.LeaveTypeId  = @id


    END

