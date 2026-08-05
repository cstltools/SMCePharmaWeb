-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MIATargetList]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
   
 
   DECLARE @Query NVARCHAR(MAX)

SET @Query = ' SELECT  CASE  WHEN  ENTR.EmpName Is Null  THEN  ENUS.UserName 
		ELSE ENTR.EmpName  
		END as EntryBy,   CASE  WHEN UPDT.EmpName  Is Null  THEN  UPUS.UserName 
		ELSE UPDT.EmpName  
		END as  UpdateBy, CONVERT(NVARCHAR(20),mas.EntryDate,106) EntryDate, CONVERT(NVARCHAR(20),mas.UpdateDate,106) UpdateDate, CASE WHEN mas.Period=1 THEN ''January'' WHEN mas.Period=2 THEN ''February'' WHEN mas.Period=3 THEN ''March'' WHEN mas.Period=4 THEN ''April'' WHEN mas.Period=5 THEN ''May'' WHEN mas.Period=6 THEN ''June''  WHEN mas.Period=7 THEN ''July'' WHEN mas.Period=8 THEN ''August'' WHEN mas.Period=9 THEN ''September''  WHEN mas.Period=10 THEN ''October''  WHEN mas.Period=11 THEN ''November''  WHEN mas.Period=12 THEN ''December'' ELSE '''' END  MonthName1 ,* FROM dbo.tblMIATarget mas WITH (NOLOCK)
LEFT JOIN tblUser AS ENUS ON ENUS.UserId = mas.EntryBy
	LEFT JOIN tblUser AS UPUS ON UPUS.UserId = mas.UpdateBy
		LEFT JOIN tblEmpGeneralInfo AS ENTR ON ENTR.EmpInfoId = ENUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS UPDT ON UPDT.EmpInfoId = UPUS.EmpInfoId
 WHERE mas.MiaTargetId IS NOT NULL  '+  @param
 
END

EXEC (@Query)
 

