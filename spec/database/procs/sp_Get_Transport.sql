
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Transport]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    	 
   SELECT  ISNULL(emp.EmpMasterCode+' : '+ emp.EmpName,us.UserName) empName, A.TransportId ,
          A.TransportName ,   
		  A.AllowedMilagePerKM,
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106)AS Activedate,
          A.EntryBy,
           convert(varchar, A.EntryDate, 0)  EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM [dbo].[tbl_Transport] A WITH (NOLOCK)
		  LEFT JOIN dbo.tblUser us ON us.UserId=A.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=us.EmpInfoId
		  Where A.IsDelate is NULL 
END

