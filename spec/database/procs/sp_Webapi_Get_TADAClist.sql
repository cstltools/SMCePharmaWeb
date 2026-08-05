-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TADAClist]
	-- Add the parameters for the stored procedure here
    @monthValue INT ,
    @yearValue INT ,
    @statusTxt NVARCHAR(50) ,
    @userId INT,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX) =NULL
AS
    BEGIN
	DECLARE @empId INT , @params NVARCHAR(max)=''

	 IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND A.TadaDate='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND A.TadaDate between '''+@FromDt+''' AND '''+@ToDt+''' '
		END

		IF(@statusTxt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND A.ApprovalStatus = '''+@statusTxt+''''
		END

	SELECT @empId=UserId FROM dbo.tblUser WHERE EmpInfoId=@userId

		DECLARE @Q NVARCHAR(MAX)
	SET @Q='
        SELECT  format(A.TadaDate,''dd'') AS TadaDate ,
                c.EmpName ,
                 
                CAST(A.DAAmount AS NVARCHAR(10)) AS DaAmt ,
                isnull(mar.MarketName+'' [''+st.StationTypeName+'']'',''Other Visit'') AS Market ,
                A.ApprovalStatus
        FROM    dbo.tbl_TadaClaimMaster A with (nolock)
                
                INNER JOIN dbo.tblEmpGeneralInfo  c  with (nolock) ON c.EmpInfoId = A.EmpInfoId


				left JOIN dbo.tblMarket  mar  with (nolock) ON mar.MarketId = A.MarketId

				left JOIN dbo.tblStationType  st  with (nolock) ON st.StationTypeId = A.TourtypeId
        WHERE   MONTH(A.TadaDate) = '+CONVERT(NVARCHAR(max), @monthValue)+' 
                AND YEAR(A.TadaDate) = '+CONVERT(NVARCHAR(max),@yearValue)+' 
                AND A.EntryBy ='+CONVERT(NVARCHAR(max),@empId)  +@params 
				+' order by A.TadaDate Desc '
EXEC sys.sp_executesql @Q


    END