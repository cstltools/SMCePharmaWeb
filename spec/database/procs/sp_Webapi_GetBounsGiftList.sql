CREATE PROCEDURE [dbo].[sp_Webapi_GetBounsGiftList] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
@empId int = null,
@FromDate  DATETIME=null,
@ToDate   DATETIME=null, 
@GroupId_   int=null,
@ZoneId_   int=null,
@AreaId_   int=null,
@TerritoryId   int=null,
@SubTerritoryId   int=null,
@MarketId   int=null





AS
BEGIN

DECLARE @TerrId INT
DECLARE @AreaId INT
DECLARE @ZoneId INT
DECLARE @GroupId INT


SELECT @AreaId=AreaId,@ZoneId=RegionId,@GroupId=GroupId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@empId




		DECLARE @mioCode NVARCHAR(50)

        SELECT  @mioCode = usr.UserId
        FROM    dbo.tblEmpGeneralInfo A with (nolock)

		inner join tblUser usr  with (nolock) on a.EmpInfoId=usr.EmpInfoId
        WHERE   A.EmpInfoId = @empId 

		DECLARE @params NVARCHAR(max)='  '

		IF(@FromDate IS NOT NULL AND @ToDate IS NULL)
		BEGIN
		    SET @params=@params+ ' AND  convert(Date,D.SubmissionDate)='''+CAST(CONVERT(DATE,@FromDate) AS NVARCHAR(max))+''''
		END
		IF(@FromDate IS NOT NULL AND @ToDate IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  convert(Date,D.SubmissionDate) between '''+CAST(CONVERT(DATE,@FromDate) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDate) AS NVARCHAR(max))+''' '
		END

		 

 


		IF(@GroupId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.GroupId)='''+CAST(CONVERT(Int,@GroupId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@AreaId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.AreaId)='''+CAST(CONVERT(Int,@AreaId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@ZoneId_ <>0)
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.RegionId)='''+CAST(CONVERT(Int,@ZoneId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@TerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@SubTerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.SubTerritoryId)='''+CAST(CONVERT(Int,@SubTerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@MarketId  <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.MarketId)='''+CAST(CONVERT(Int,@MarketId) AS NVARCHAR(max))+''''
		    
		END
			IF(@FromDate IS  NULL AND @ToDate IS NULL)

	begin
	 SET @params=@params+ '  AND   convert(Date,D.SubmissionDate)= convert(Date,getdate())'
	end



DECLARE @Q NVARCHAR(MAX)
	SET @Q=' select     D.OrderCode OrderNo, ID.InvoiceNo, FORMAT(ID.InvoiceDate, ''dd-MMM-yy'') InvoiceDate, convert(int, ISNULL(tblGift.GivtQty,0)) GiftQty , convert(int, ISNULL(tblB.BounsQty,0))  BounsQty from  dbo.tblOrder D with (nolock)
 
  left JOIN  tblInvoice ID ON ID.OrderID = D.OrderID 
    left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId

left JOIN (select OrderID, sum(Quantity) GivtQty   from tblOrderDetail m  with (nolock)
inner join tblProduct pro   with (nolock) on  m.ProductCode=pro.ProductCode 
 where    TotalTradePrice=0   and pro.ProductGroupId=3 group by OrderID) tblGift on   D.OrderID = tblGift.OrderID 

left JOIN (select OrderID, sum(Quantity) BounsQty   from tblOrderDetail m  with (nolock)
inner join tblProduct pro   with (nolock) on  m.ProductCode=pro.ProductCode 
 where   TotalTradePrice=0   and pro.ProductGroupId=1 group by OrderID) tblB on   D.OrderID = tblB.OrderID 


 where   D.OrderID   is not null  and  (ISNULL(tblGift.GivtQty,0)  + ISNULL(tblB.BounsQty,0) >0)  and   	(fs.MIOEmpId='+convert(nvarchar(max),@empId)+' or fs.ASMEMPId='+convert(nvarchar(max),@empId)+' or fs.RSMEMPId='+convert(nvarchar(max),@empId)+' or fs.NSMEMPId='+convert(nvarchar(max),@empId)+') 
		 '+@params+'
			ORDER BY D.SubmissionDate DESC  '


 


 EXEC sp_executesql @Q


    END



