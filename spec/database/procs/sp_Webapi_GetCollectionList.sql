CREATE PROCEDURE [dbo].[sp_Webapi_GetCollectionList] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
@empId int = null,
@FromDate  NVARCHAR(max) = NULL,
@ToDate  NVARCHAR(max) = NULL,
@GroupId_   int=null,
@ZoneId_   int=null,
@AreaId_   int=null,
@TerritoryId   int=null,
@SubTerritoryId   int=null,
@MarketId   int=null





AS
BEGIN



IF @FromDate IS NOT NULL
BEGIN
    DECLARE @FromDateString VARCHAR(20) = CONVERT(VARCHAR, @FromDate, 106);
    SET @FromDateString = REPLACE(@FromDateString, 'Sept', 'Sep');
    SET @FromDate = CONVERT(DATETIME, @FromDateString, 106);
END

IF @ToDate IS NOT NULL
BEGIN
    DECLARE @ToDateString VARCHAR(20) = CONVERT(VARCHAR, @ToDate, 106);
    SET @ToDateString = REPLACE(@ToDateString, 'Sept', 'Sep');
    SET @ToDate = CONVERT(DATETIME, @ToDateString, 106);
END


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
		    SET @params=@params+ ' AND  convert(date,custDtl.custPaymentDate)='''+CAST(CONVERT(DATE,@FromDate) AS NVARCHAR(max))+''''
		END
		IF(@FromDate IS NOT NULL AND @ToDate IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  convert(date,custDtl.custPaymentDate) between '''+CAST(CONVERT(DATE,@FromDate) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDate) AS NVARCHAR(max))+''' '
		END

		 

 


		IF(@GroupId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.GroupId)='''+CAST(CONVERT(Int,@GroupId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@AreaId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,ddd.AreaId)='''+CAST(CONVERT(Int,@AreaId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@ZoneId_ <>0)
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tblRegion.RegionId)='''+CAST(CONVERT(Int,@ZoneId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@TerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,cc.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@SubTerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,bb.SubTerritoryId)='''+CAST(CONVERT(Int,@SubTerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@MarketId  <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tblRegion.MarketId)='''+CAST(CONVERT(Int,@MarketId) AS NVARCHAR(max))+''''
		    
		END
			IF(@FromDate IS  NULL AND @ToDate IS NULL)

	begin
	 SET @params=@params+ '  AND  convert(date,custDtl.custPaymentDate) = convert(Date,getdate())'
	end

	declare  @UserType nvarchar(max)

	    SELECT @UserType= uType.RoleType
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @empId;

	if(@UserType='DZSM')
	begin
	SET @params=@params+ ' AND  convert(Int,tblRegion.RegionId)='''+CAST(CONVERT(Int,(select distinct RegionId from View_webapi_FieldForce where RSMEMPId=@empId)) AS NVARCHAR(max))+''''

	end

	if(@UserType='AM')
	begin
	SET @params=@params+ ' AND  convert(Int,ddd.AreaId)='''+CAST(CONVERT(Int,(select distinct AreaId from View_webapi_FieldForce where  ASMEMPId=@empId)) AS NVARCHAR(max))+''''

	end

	
	if(@UserType='MIO')
begin
    SET @params=@params+ ' AND  convert(Int,cc.TerritoryId)='''+CAST(CONVERT(Int,(select distinct ISNULL(TerritoryId,0) from View_webapi_FieldForce where MIOEmpId=@empId)) AS NVARCHAR(max))+''''
end

	

	--+'' Customer:''+ c.CustomerCode +'' Terr:''+ t.TerritoryCode 

DECLARE @Q NVARCHAR(MAX)
	SET @Q='  Select      OrderNo, InvoiceNo as InvoiceNo, format(InvoiceDate,''dd-MMM-yy'') InvoiceDate, isnull(sum(TP_Pay),0) GrossValue from (
		SELECT      OrderNo, InvoiceNo +'' [Cust:''+  mas.CustomerCode +isnull(''Terr:''+  cc.TerritoryCode+'']'','']'')   as InvoiceNo, InvoiceDate ,
 
 sum((isnull(custDtl.TPAmount,0))) TP_Pay,   sum((isnull(custDtl.VATAmount,0)))    TP_Vat
FROM tblCustPayDetail custDtl   with(nolock)
 
 
inner JOIN dbo.tblInvoice I   with (nolock)    ON I.InvoiceId = custDtl.InvoiceId
LEFT JOIN dbo.tblOrder mas  with (nolock)   ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt  with (nolock)   ON mas.ProgramTypeId = ptt.ProgramTypeId
 LEFT JOIN tblCustomertype ct  with (nolock)   ON mas.CusttypeId = ct.CustomerTypeId
inner JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail  with (nolock)   group by InvoiceId)tblinvDetls on tblinvDetls.InvoiceId=I.InvoiceId 
LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId 
LEFT JOIN dbo.tblCompanyUnit CU  with (nolock)   ON CU.ComUnitId = mas.ComUnitId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
 LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1

 where      I.InvoiceId is not null        
		 '+@params+'
			 
group by  OrderNo, InvoiceNo, mas.CustomerCode, cc.TerritoryCode,InvoiceDate 
			  )tbl

 group by OrderNo, InvoiceNo,InvoiceDate       order by InvoiceDate asc'


 


 EXEC sp_executesql @Q


    END



