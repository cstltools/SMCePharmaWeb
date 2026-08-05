CREATE PROCEDURE [dbo].[sp_GET_Manufacturer]
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

		SET @Query = 'SELECT MT.ManufacId,MT.ManufacName,MT.ManufacAddress, MT.ManufacCode,CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,
		   CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,		
		convert(varchar,MT.EntryDate, 0) EntryDatee,			
	    convert(varchar,MT.UpdateDate, 0) UpdateDatee,
	    convert(varchar,MT.ActiveInactiveDate, 0) InactiveDatee,
		MT.IsActive
		FROM tblManufacturer AS MT
		LEFT JOIN tblUser us ON us.UserId = MT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = MT.UpdateBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = MT.InactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
	    LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId		
		WHERE MT.ManufacId IS NOT NULL
' + @Parameter
		
    END

	EXEC(@Query)