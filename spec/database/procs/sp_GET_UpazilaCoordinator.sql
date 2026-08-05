

Create PROCEDURE [dbo].[sp_GET_UpazilaCoordinator]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN

	DECLARE @Query NVARCHAR(MAX)

		SET @Query = 'SELECT
		DPT.UpCoordinatorCode,DPT.UpCoordinatorId,DV.DivisionName,DT.DistrictName,DC.EmpName, TH.ThanaName, CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,
		    CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,		
		CONVERT(varchar,DPT.EntryDate, 0) EntryDatee,			
	    CONVERT(varchar,DPT.UpdateDate, 0) UpdateDatee,	
		CONVERT(NVARCHAR(50),DPT.InactiveDate,106)AS InactiveDatee,
		DPT.IsActive
		FROM tblUpazilaCoordinator AS DPT 
		LEFT JOIN tbl_Division DV ON DV.DivisionId = DPT.DivisionId
		LEFT JOIN tbl_District DT ON DT.DistrictId = DPT.DistrictId
		LEFT JOIN tbl_Thana TH ON TH.ThanaId = DPT.ThanaId
		LEFT JOIN tblEmpGeneralInfo DC ON DC.EmpInfoId = DPT.EmpInfoId
		LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = DPT.UpdateBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = DPT.InactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId		
		WHERE UpCoordinatorId IS NOT NULL ' + @Parameter
					
    END

	EXEC(@Query)

