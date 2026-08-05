-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorChamberList]
	-- Add the parameters for the stored procedure here

AS
BEGIN 
          SELECT A.ChamberId ,
          A.ChamberName ,   
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106)AS Activedate ,
		  CONVERT(NVARCHAR(50),A.EntryDate,106)  AS  EntryDate ,
          CONVERT(NVARCHAR(50),A.UpdateDate,106) AS UpdateDate ,
          En.UserName AS EntryBy,
          Up.UserName AS UpdateBy,
		  CASE WHEN DS.S IS NULL THEN 'Yes' else 'No' END AS IsDel  
		  FROM dbo.tblDoctorChamber A
		  LEFT JOIN tblUser En On En.UserId = A.EntryBy
          LEFT JOIN tblUser Up ON Up.UserId = A.UpdateBy
		  LEFT JOIN (SELECT ChamberTypeId,COUNT(ChemberId) AS S FROM dbo.tblDoctorChemberDetail GROUP BY ChamberTypeId) AS DS ON DS.ChamberTypeId =              A.ChamberId
		  Where A.IsDelate is NULL
END

