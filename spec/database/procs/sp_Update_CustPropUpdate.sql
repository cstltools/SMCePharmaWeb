CREATE PROCEDURE [dbo].[sp_Update_CustPropUpdate]

	
    @CustPropMasterId INT NULL,
	@UpdateBy int
AS
BEGIN

DECLARE @CustId INT
DECLARE @ProvId INT
DECLARE @CustTypeId INT
DECLARE @MarketId INT
DECLARE @PharmaPlatformId INT

DECLARE @ConvertType nvarchar(max)

DECLARE @CustPropUpdateDetailId INT


--DELETE FROM dbo.tblApprovalMapDetail WHERE ApprovalMapMasterId=@ApprovalMapMasterId AND ToRoleId=@ToRoleId

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR

SELECT CustomerId,MarketId,ProviderTypeId,tblCustomerPropUpdateDetail.CustTypeId, ConvertType,CustPropUpdateDetailId, tblCustomerPropUpdateDetail.PharmaPlatformId FROM dbo.tblCustomerPropUpdateMaster with (nolock)
LEFT JOIN dbo.tblCustomerPropUpdateDetail  with (nolock) ON tblCustomerPropUpdateDetail.CustPropMasterId = tblCustomerPropUpdateMaster.CustPropMasterId
WHERE tblCustomerPropUpdateDetail.CustPropMasterId=@CustPropMasterId  

OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO   @CustId,@MarketId,@ProvId,@CustTypeId,@ConvertType,@CustPropUpdateDetailId,@PharmaPlatformId


WHILE @@FETCH_STATUS = 0
BEGIN

if(@ConvertType='Market Update')
BEGIN

if(@MarketId is not null)
BEGIN

UPDATE dbo.tblCustMaster SET MarketId=@MarketId , UpdateBy=@UpdateBy, UpdateDate=GETDATE() WHERE CustomerMasterId=@CustId 

UPDATE tblCustomerPropUpdateDetail SET IsSuccess=1 where   CustPropUpdateDetailId=@CustPropUpdateDetailId
End
End

if(@ConvertType='Provider Type')
BEGIN
if(@ProvId is not null)
BEGIN
UPDATE dbo.tblCustMaster SET  ProgramTypeId=@ProvId , UpdateBy=@UpdateBy, UpdateDate=GETDATE() WHERE CustomerMasterId=@CustId
UPDATE tblCustomerPropUpdateDetail SET IsSuccess=1 where   CustPropUpdateDetailId=@CustPropUpdateDetailId
End
End

if(@ConvertType='Customer Type')
BEGIN
if(@CustTypeId is not null)
BEGIN
UPDATE dbo.tblCustMaster SET  CustomerTypeId=@CustTypeId, UpdateBy=@UpdateBy, UpdateDate=GETDATE() WHERE CustomerMasterId=@CustId
UPDATE tblCustomerPropUpdateDetail SET IsSuccess=1 where   CustPropUpdateDetailId=@CustPropUpdateDetailId
End
End

if(@ConvertType='Pharma Platform Type')
BEGIN
if(@PharmaPlatformId is not null)
BEGIN
UPDATE dbo.tblCustMaster SET  SMCTypeId=@PharmaPlatformId, UpdateBy=@UpdateBy, UpdateDate=GETDATE() WHERE CustomerMasterId=@CustId
UPDATE tblCustomerPropUpdateDetail SET IsSuccess=1 where   CustPropUpdateDetailId=@CustPropUpdateDetailId
End
End
 

FETCH NEXT FROM @MyCursor
INTO   @CustId,@MarketId,@ProvId,@CustTypeId,@ConvertType,@CustPropUpdateDetailId,@PharmaPlatformId
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
	

UPDATE dbo.tblCustomerPropUpdateMaster SET IsTransfer=1 WHERE CustPropMasterId=@CustPropMasterId

END
