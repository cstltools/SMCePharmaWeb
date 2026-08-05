-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorSpecailDayList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT A.SpecialDayId ,
          A.SpecialDay ,   
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106)AS Activedate ,
		  CONVERT(NVARCHAR(50),A.EntryDate,106)AS EntryDate ,
		  CONVERT(NVARCHAR(50),A.UpdateDate,106)AS UpdateDate ,
		  En.UserName AS EntryBy,
          A.EntryBy ,
          A.EntryDate,
		  Up.UserName AS UpdateBy
		  FROM [dbo].[tblDoctorSpecialDay] A
		  LEFT JOIN tblUser En On En.UserId = A.EntryBy
		  LEFT JOIN tblUser Up ON Up.UserId = A.UpdateBy
		  Where A.IsDelate is NULL
END

