

CREATE PROCEDURE [dbo].[sp_GET_SMCtypeInfo]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN

	DECLARE @Query NVARCHAR(MAX)

	--SET @Query = 'SELECT DeptId,DeptCode,DeptName,EntryBy,EntryDate,UpdateBy,UpdateDate,
	--	 IsActive,CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus
	--	FROM tblDepartment AS DPT 
	--	LEFT JOIN (SELECT DISTINCT DepartmentId, COUNT(DepartmentId) NoOf FROM tblEmpGeneralInfo GROUP BY DepartmentId) AS C ON DPT.DeptId = C.DepartmentId
	--	WHERE DeptId IS NOT NULL' + @Parameter

		SET @Query = 'SELECT DPT.SMCTypeCode,
		 DPT.SMCTypeId,CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,
		    CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,					
		convert(varchar,DPT.EntryDate, 0) EntryDatee,			
	    convert(varchar,DPT.UpdateDate, 0) UpdateDatee,
		CONVERT(NVARCHAR(50),DPT.InactiveDate,106)AS InactiveDatee,
		DPT.SMCType,  
		IsActive,*
		FROM tblSMCType AS DPT 
		LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = DPT.UpdateBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = DPT.InactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId			
		WHERE DPT.SMCTypeId IS NOT NULL ' + @Parameter

		
    END

	EXEC(@Query)

