CREATE PROCEDURE [dbo].[sp_Webapi_Get_PrescriptionList]
	-- Add the parameters for the stored procedure here
@empId int,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX) =NULL,
@providertype   NVARCHAR(MAX)= NULL,
@pharmatype   NVARCHAR(MAX)= NULL,
@doctortype   NVARCHAR(MAX)= NULL
AS
BEGIN
 
 DECLARE @UserId NVARCHAR(max),  @params NVARCHAR(max)=''

	 IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND A.PrescriptionDate='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND A.PrescriptionDate between '''+@FromDt+''' AND '''+@ToDt+''' '
		END


		IF(@providertype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,A.DoctorProgramypeId)='''+CAST(CONVERT(Int,@providertype) AS NVARCHAR(max))+''''
		    
		END

			IF(@pharmatype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,A.SmcTypeId_RX)='''+CAST(CONVERT(Int,@pharmatype) AS NVARCHAR(max))+''''
		    
		END

			IF(@doctortype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,M.Doctortypeid)='''+CAST(CONVERT(Int,@doctortype) AS NVARCHAR(max))+''''
		    
		END
			IF(@FromDt IS  NULL AND @ToDt IS NULL)

	begin
	 SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,A.PrescriptionDate),CONVERT(DATE,GETDATE())))<=7  '
	end


	SELECT @UserId=UserId FROM dbo.tblUser WHERE EmpInfoId=@empId

		DECLARE @Q NVARCHAR(MAX)
	SET @Q='
 SELECT FORMAT(A.EntryDate, ''MMMM dd, yyyy hh:mm tt'') PrescriptionDate,A.ApprovalStatus,  d.EmpMasterCode+'' - ''+D.EmpName EmpName , M.DoctorCode+'' - ''+M.DoctorName DoctorName FROM dbo.tbl_PrescriptionMaster A   with (NOLOCK)  
	LEFT JOIN dbo.tblUser us   with (NOLOCK)   ON us.UserId = A.EntryBy
                LEFT JOIN dbo.tblEmpGeneralInfo D   with (NOLOCK)   ON D.EmpInfoId = us.EmpInfoId
                LEFT JOIN dbo.tblDoctorMaster M   with (NOLOCK)   ON M.DoctorId = A.DoctorId
 WHERE A.EntryBy='+@userId  +@params 

EXEC sys.sp_executesql @Q


    END