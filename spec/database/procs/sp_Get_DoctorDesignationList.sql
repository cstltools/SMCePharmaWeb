-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorDesignationList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT A.DesignationId ,
          A.DesignationName ,   
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106)AS Activedate ,
		  CONVERT(NVARCHAR(50),A.EntryDate,106)  AS  EntryDate ,
		  CONVERT(NVARCHAR(50),A.UpdateDate,106) AS UpdateDate ,
          En.UserName AS EntryBy,
          A.EntryDate,
		  Up.UserName AS UpdateBy,
		  A.UpdateDate,
		  CASE WHEN DS.S IS NULL THEN 'Yes' else 'No' END AS IsDel   	  
		  FROM dbo.tblDoctorDesignation A
		  LEFT JOIN tblUser En On En.UserId = A.EntryBy
		  LEFT JOIN tblUser Up ON Up.UserId = A.UpdateBy
		  LEFT JOIN (SELECT DesignationId,COUNT(DoctorId) AS S FROM tblDoctorMaster GROUP BY DesignationId) DS ON A.DesignationId = DS.DesignationId
		  Where A.IsDelate is NULL

		  
END

