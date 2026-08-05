
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Update_OrderDC]
	-- Add the parameters for the stored procedure here
   
    @DCID NVARCHAR(MAX) ,
    @RouteNameId NVARCHAR(MAX) ,


    @ApprovedBy NVARCHAR(50) ,
	@OrdId NVARCHAR(MAX)  

  

AS
    BEGIN
  
  declare @ComUnitCode  NVARCHAR(MAX), @ComUnitName NVARCHAR(MAX)
  select  @ComUnitCode=ComUnitCode,@ComUnitName= ComUnitName from tblCompanyUnit where ComUnitId=@DCID


  update tblOrder set ComUnitId=@DCID,ComUnitCode= @ComUnitCode, ComUnitName=@ComUnitName, DistributionRouteId=@RouteNameId, IsSubDepo=0

    WHERE  OrderId in (select * from fnSplit(@OrdId,',')) 

    END
	

