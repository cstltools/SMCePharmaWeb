
CREATE PROCEDURE [dbo].[sp_Webapi_Get_MileageClaimList]
	-- Add the parameters for the stored procedure here
    @monthValue INT ,
    @yearValue INT ,
    @statusTxt NVARCHAR(50) ,
    @empId INT
AS
    BEGIN
	
	if(@statusTxt='' or @statusTxt is null or @statusTxt='0' )
	begin

set	@statusTxt= 'All'
	end
		
        IF ( @statusTxt = 'All' )
            BEGIN

			        SELECT  A.MeterReading, A.Remarks, A.MileageClaimId ,
             FORMAT(A.MileageDate,'dd')   AS MileageDate ,
                B.TransportName ,
                ( C.EmpName + '-' + C.EmpMasterCode ) AS EmpName ,
                A.MileageInKM ,   ISNULL(m.MarketName ,'')as MarketName,
                A.ApprovalStatus,(SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='MileageMy')+CAST(A.MileageClaimId as nvarchar(max))+'.jpg' AS   ImageString  
        FROM    dbo.tbl_MileageClaim A
                LEFT JOIN dbo.tbl_Transport B ON B.TransportId = A.TransportId
                LEFT JOIN dbo.tblEmpGeneralInfo C ON C.EmpInfoId = A.EmpInfoId
                LEFT JOIN dbo.tblMarket m ON m.MarketId = A.MarketId
        WHERE   MONTH(A.MileageDate) = @monthValue
                        AND YEAR(A.MileageDate) = @yearValue
                        AND A.EmpInfoId = @empId

						order by A.MileageDate desc

			END
            
			ELSE
            BEGIN
            				        SELECT A.MeterReading, A.Remarks,  A.MileageClaimId ,
        FORMAT(A.MileageDate,'dd')    AS MileageDate ,
                B.TransportName ,
                ( C.EmpName + '-' + C.EmpMasterCode ) AS EmpName ,
                A.MileageInKM ,
                                
						                  ISNULL(m.MarketName ,'')as MarketName,
                A.ApprovalStatus,(SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='MileageMy')+CAST(A.MileageClaimId as nvarchar(max))+'.jpg' AS   ImageString
        FROM    dbo.tbl_MileageClaim A
                LEFT JOIN dbo.tbl_Transport B ON B.TransportId = A.TransportId
                LEFT JOIN dbo.tblEmpGeneralInfo C ON C.EmpInfoId = A.EmpInfoId
                LEFT JOIN dbo.tblMarket m ON m.MarketId = A.MarketId
        WHERE   MONTH(A.MileageDate) = @monthValue
                        AND YEAR(A.MileageDate) = @yearValue
                        AND A.EmpInfoId = @empId
						   AND A.ApprovalStatus = @statusTxt
						   order by A.MileageDate desc

            END

	


    END
