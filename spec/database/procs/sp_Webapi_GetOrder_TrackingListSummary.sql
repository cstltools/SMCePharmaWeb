CREATE PROCEDURE [dbo].[sp_Webapi_GetOrder_TrackingListSummary] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
@empId int = null,
@FromDate  DATETIME=null,
@ToDate   DATETIME=null,
@AppStatus nvarchar(max)= NULL,
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
		    SET @params=@params+ ' AND  convert(Date,  D.SubmissionDate)='''+CAST(CONVERT(DATE,@FromDate) AS NVARCHAR(max))+''''
		END
		IF(@FromDate IS NOT NULL AND @ToDate IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  convert(Date,  D.SubmissionDate) between '''+CAST(CONVERT(DATE,@FromDate) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDate) AS NVARCHAR(max))+''' '
		END

		IF(@AppStatus<>'Select'  and @AppStatus<>'')
		BEGIN

		SET @params=@params+ ' AND  convert(Int,D.ActionStatus)='''+CAST(CONVERT(Int,@AppStatus) AS NVARCHAR(max))+''''
		    
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
DECLARE @Q NVARCHAR(MAX)
		SET @Q='  select  isnull(sum(GrossValue),0) GrossValue from (SELECT  distinct  case when D.CustTypeId=2 then  ''Approval Status: ''+  case when  D.ActionStatus=''0'' then ''Pending''  when  D.ActionStatus=''1'' then ''Verified'' when  D.ActionStatus=''2'' then ''Approved'' when  D.ActionStatus=''3'' then ''Rejected''  else  D.ActionStatus end   else  '''' end ApprovalStatus, ct.CustomerType,  
		D.OrderId,
		D.OrderCode,
		D.MIOName,
		D.CustomerCode+ '' : '' +	D.CustomerName CustomerName,
		isnull(D.GrossValue-D.TotalDiscount,0) as GrossValue,
		FORMAT(D.EntryDate,''dd MMM, yyyy hh:mm tt'') CreatedAt,

	case when 	emp.EmpInfoId is null then u.LoginName else emp.empmastercode +'' : ''+ emp.empname end  CreatedBy,
		CONVERT(NVARCHAR(50),D.SubmissionDate,106) AS SubmissionDate,
		( SELECT  PaymentStatus
                            FROM    dbo.tblInvoice with (nolock)
                            WHERE   OrderId = D.OrderId
                          ) AS dsd,
		''Own''  AS OrderType,
		 CASE		WHEN ( SELECT  PaymentStatus
                            FROM    dbo.tblInvoice with (nolock)
                            WHERE   OrderId = D.OrderId
                          ) IS NOT NULL THEN ''Payment Completed''

						  WHEN ( SELECT  DelivaryInvoiceNo
                            FROM    dbo.tblInvoice with (nolock)
                            WHERE   OrderId = D.OrderId
                          ) IS NOT NULL THEN ''Delivery Completed''

					WHEN IsInvoice = 1 THEN ''Invoiced''
					WHEN IsInvoice = 0 THEN ''Invoice Pending''
					WHEN IsInvoice IS NULL THEN ''Pending''
					END AS OrderStatus

FROM    dbo.tblOrder D with (nolock) 
 
left join tblCustomertype ct with (nolock) on ct. CustomertypeId=D.CustTypeId
left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
 

			    WHERE      	(fs.MIOEmpId='+convert(nvarchar(max),@empId)+' or fs.ASMEMPId='+convert(nvarchar(max),@empId)+' or fs.RSMEMPId='+convert(nvarchar(max),@empId)+' or fs.NSMEMPId='+convert(nvarchar(max),@empId)+') 
		 '+@params+'
			)tbl

			 '

EXEC sys.sp_executesql @Q


--(D.EntryBy = '+CAST(@mioCode as nvarchar(max))+'  OR
--			D.AreaId='+CAST(@AreaId as nvarchar(max))+' OR 
--			D.RegionId='+CAST(@ZoneId as nvarchar(max))+' OR 
--			D.GroupId='+CAST(@GroupId as nvarchar(max))+')


    END