CREATE PROCEDURE 
[dbo].[sp_Webapi_Get_CampaignMasterInfoMultiPro]
	-- Add the parameters for the stored procedure here
	@CustomerId INT,

	@PaymentType NVARCHAR(20),
	@param NVARCHAR(MAX)

AS
BEGIN
	
	DECLARE @CustTypeId INT=0

	SELECT @CustTypeId=CustomerTypeId FROM dbo.tblCustMaster WHERE CustomerMasterId=@CustomerId

	 
	declare @codPrm nvarchar(50)=''
	if(@PaymentType='COD')
	begin
	set @codPrm = ' and IsPTforCOD=1'
	end
	
	if(@PaymentType='NCOD')
	begin
	set @codPrm = ' and IsPTforOther=1'
	end

	DECLARE @q NVARCHAR(MAX)='
	SELECT distinct isnull(IsFCFS,0) IsFCFS, tbl_BonusCampaignNewMaster.*, tbl_BonusCampaignNewDetail.* FROM dbo.tbl_BonusCampaignNewMaster
	inner join tbl_BonusCampaignBonusProductDtls proDtl on proDtl.CampgainMasterId=tbl_BonusCampaignNewMaster.CampgainMasterId
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId AND CampainTypeId=3 
	 WHERE 
    tbl_BonusCampaignNewMaster.CampgainMasterId IN (
        SELECT CampgainMasterId 
        FROM dbo.tbl_BonusCampaignBonusProductDtls
        GROUP BY CampgainMasterId
        HAVING COUNT(BonusProductId) = 2
    ) and  IsActive=1 '+@codPrm+' AND (GETDATE() BETWEEN FromDate AND Todate) AND (tbl_BonusCampaignNewMaster.CampgainMasterId IN ( select CampaignMasterId from tblCustMasterCampNew where CustomerMasterId='+CONVERT(NVARCHAR(MAX),@CustomerId)+' and custtypeid='+CONVERT(NVARCHAR(MAX),@CustTypeId)+'  )) '+@param
	 +' ORDER BY tbl_BonusCampaignNewMaster.CampainTypeId ASC'

	 EXEC sys.sp_executesql @q
	

END