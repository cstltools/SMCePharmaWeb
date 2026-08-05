-- =============================================
-- Author:		<Author,LITON>
-- Create date: <Create Date,05/13/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_I_InvoiceAutoGeneration] 
	(
		--@StoreRequisitionIssueDetailsId INT OUT,
		@StoreRequisitionIssueId INT =null,
		@ItemDescriptionId INT=null,
		@UOMDetailsId INT=NULL,
		@StoreRequisitionDetailId INT=NULL,
		@IssueQuantity DECIMAL(18,3)=NULL,
		@IsReject bit=null,
		@RackID  INT=NULL
		
	)
AS
BEGIN

	if	(@IsReject=0)
     begin
    
     
   DECLARE @IssueQuantityAfterConv decimal(18,3)  
   DECLARE @IssueQuantityTemp decimal(18,3)  
   DECLARE @UomConvValue decimal(18,3)
 select @UomConvValue=ConvertionValue from tblUomDetails where UOMDetailsId=@UOMDetailsId
     
    
     set @IssueQuantityAfterConv=@IssueQuantity*@UomConvValue
     
     
     
DECLARE @TransectionQuantity decimal(18,3)
DECLARE @CurrentStockId int
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR





		select CurrentStockId,TransectionQuantity from tblCurrentStockforUnit 
		left join tblDirectStockInDetail on tblCurrentStockforUnit.DirectStockInDetailId=tblDirectStockInDetail.DirectStockInDetailId
		inner join tblDirectStockInMaster on tblDirectStockInMaster.DirectStockInId=tblDirectStockInDetail.DirectStockInId
		where  tblDirectStockInMaster.RackId=isnull(@RackID,'') and  tblCurrentStockforUnit.ItemDescriptionId=@ItemDescriptionId and tblCurrentStockforUnit.UnitId in (
		select R.RequisitionUnit from tblStoreRequisitionMaster R inner join 
		tblStoreRequisitionIssueMaster I on R.StoreRequisitionId=I.StoreRequisitionId
		where I.StoreRequisitionIssueId=@StoreRequisitionIssueId) and TransectionQuantity>0
		order by tblCurrentStockforUnit.StockInDate asc

		
		
		
		

		--  select * from tblCurrentStockforUnit






OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @CurrentStockId,@TransectionQuantity
WHILE @@FETCH_STATUS = 0
BEGIN

if	(@IssueQuantityAfterConv>0)
begin
-----------
if	(@TransectionQuantity>=@IssueQuantityAfterConv)
begin



INSERT INTO dbo.tblStoreRequisitionIssueDetail
	         ( StoreRequisitionIssueId,
	           ItemDescriptionId,
	           UOMDetailsId,
	           StoreRequisitionDetailId,
	           IssueQuantity,
	           CurrentStockId
	         )
	 VALUES  ( @StoreRequisitionIssueId,
	           @ItemDescriptionId,
	           @UOMDetailsId,
	           @StoreRequisitionDetailId,
	           (@IssueQuantityAfterConv/@UomConvValue),
	           @CurrentStockId
	         )


update tblCurrentStockforUnit set TransectionQuantity=(@TransectionQuantity-@IssueQuantityAfterConv)
where CurrentStockId=@CurrentStockId

set @IssueQuantityAfterConv=0



end
else
begin

set @IssueQuantityAfterConv=@IssueQuantityAfterConv-@TransectionQuantity



 INSERT INTO dbo.tblStoreRequisitionIssueDetail
	         ( StoreRequisitionIssueId,
	           ItemDescriptionId,
	           UOMDetailsId,
	           StoreRequisitionDetailId,
	           IssueQuantity,
	           CurrentStockId
	         )
	 VALUES  ( @StoreRequisitionIssueId,
	           @ItemDescriptionId,
	           @UOMDetailsId,
	           @StoreRequisitionDetailId,
	           (@TransectionQuantity/@UomConvValue),
	           @CurrentStockId
	         )
	         
update tblCurrentStockforUnit set TransectionQuantity=0
where CurrentStockId=@CurrentStockId

end

-----------
end

 
FETCH NEXT FROM @MyCursor
INTO @CurrentStockId,@TransectionQuantity
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
     end
	else
	begin
	if exists (select * from dbo.tblStoreRequisitionIssueDetail where StoreRequisitionDetailId=@StoreRequisitionDetailId)
	begin
	
	update tblStoreRequisitionDetail set RejectStatus='Partial Reject',IssueStatus='Full' where StoreRequisitionDetailId=@StoreRequisitionDetailId
	
	end
	else
	begin
	
	update tblStoreRequisitionDetail set RejectStatus='Full Reject',IssueStatus='Full' where StoreRequisitionDetailId=@StoreRequisitionDetailId
	
	end
	end
END

