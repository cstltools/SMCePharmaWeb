-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_RSMInfo]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)


   SET @Query = 'SELECT RSM.RSMId, RGN.RegionId,RGN.RegionCode + '':''+ RGN.RegionName AS Region,
   EGI.EmpMasterCode + '':''+ EGI.EmpName AS EmployeeName,
   RSM.IsActive,CONVERT(NVARCHAR(50),RSM.ActiveDate,106)AS ActiveInActiveDate,
   CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus
   FROM tblRSMInfo AS RSM
   LEFT JOIN tblRegion AS RGN ON RSM.RegionId = RGN.RegionId
   LEFT JOIN tblEmpGeneralInfo AS EGI ON RSM.EmployeeId = EGI.EmpInfoId 
   LEFT JOIN (SELECT DISTINCT RSMId,COUNT(RSMId) NoOf FROM tblOrder AS INV GROUP BY RSMId) AS C ON RSM.RSMId = C.RSMId
   WHERE RGN.RegionCode IS NOT NULL ' + @Parameter


   --SELECT RSM.RSMId, RGN.RegionId,RGN.RegionCode + ' : '+ RGN.RegionName AS Region,
   --EGI.EmpMasterCode + ' : '+ EGI.EmpName AS EmployeeName,
   --RSM.IsActive,CONVERT(NVARCHAR(50),RSM.ActiveDate,106)AS ActiveInActiveDate,
   --CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '' END AS DeleteStatus
   --FROM tblRSMInfo AS RSM
   --LEFT JOIN tblRegion AS RGN ON RSM.RegionId = RGN.RegionId
   --LEFT JOIN tblEmpGeneralInfo AS EGI ON RSM.EmployeeId = EGI.EmpInfoId 
   --LEFT JOIN (SELECT DISTINCT RSMId,COUNT(RSMId) NoOf FROM tblOrder AS INV GROUP BY RSMId) AS C ON RSM.RSMId = C.RSMId
   --WHERE RGN.RegionCode IS NOT NULL 


   --SELECT DISTINCT RSMId,COUNT(RSMId) NoOf FROM tblOrder AS INV GROUP BY RSMId
   

   EXEC(@Query)

   --SELECT * ,
   --       CONVERT(NVARCHAR(50),A.ActiveDate,106)AS ActiveInActiveDate	  
		 -- FROM [dbo].tbl_TourPlanType A	 
END
