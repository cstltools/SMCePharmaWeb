-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DcrListById]
	-- Add the parameters for the stored procedure here
    @empId NVARCHAR(50),
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX) =NULL,
	@providertype NVARCHAR(MAX) =NULL,
	@pharmatype NVARCHAR(MAX) =NULL,
	@doctortype NVARCHAR(MAX) =NULL
AS
    BEGIN

	DECLARE @userId NVARCHAR(max) ,   @params NVARCHAR(max) =''
	SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @empId
	 IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND convert(Date, A.DcrDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND convert(Date,A.DcrDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END


		
		IF(@providertype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,A.DoctorProgramypeId)='''+CAST(CONVERT(Int,@providertype) AS NVARCHAR(max))+''''
		    
		END

			IF(@pharmatype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,A.SmcTypeId_DCR)='''+CAST(CONVERT(Int,@pharmatype) AS NVARCHAR(max))+''''
		    
		END

			IF(@doctortype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,M.Doctortypeid)='''+CAST(CONVERT(Int,@doctortype) AS NVARCHAR(max))+''''
		    
		END




		DECLARE @Q NVARCHAR(MAX)
	SET @Q='
	
        SELECT  A.DcrId ,
                FORMAT(A.DcrDate, ''MMMM dd, yyyy hh:mm tt'') AS DcrDate ,
                B.TourTypeName ,
                C.Name AS ChamberAddress ,
                D.EmpName ,
                A.IsApproved ,
                M.DoctorName AS Name, A.ApprovalStatus
        FROM    dbo.tbl_DCRInfo A
                LEFT JOIN dbo.tbl_TourPlanType B ON B.TourTypeId = A.TourTypeId
                LEFT JOIN dbo.tblDoctorChemberDetail C ON C.ChemberId = A.ChemberId
				LEFT JOIN dbo.tblUser us ON us.UserId = A.EntryBy
                LEFT JOIN dbo.tblEmpGeneralInfo D ON D.EmpInfoId = us.EmpInfoId
                LEFT JOIN dbo.tblDoctorMaster M ON M.DoctorId = A.DoctorId
             

WHERE A.EntryBy='+@userId  +@params 

EXEC sys.sp_executesql @Q


    END
