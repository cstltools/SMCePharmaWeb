
CREATE PROCEDURE [dbo].[sp_GET_RouterMasterInfo]
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

		SET @Query = 'SELECT
		CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,				
		convert(varchar,DPT.EntryDate, 0) EntryDatee,			
	    convert(varchar,DPT.UpdateDate, 0) UpdateDatee,			
		DPT.RouterMasterId,DPT.RouterName,DPT.RouterCode,DPT.IsActive FROM RouterMaster AS DPT 
		LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = DPT.UpdateBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		WHERE DPT.RouterMasterId IS NOT NULL ' + @Parameter

					
    END

	EXEC(@Query)
