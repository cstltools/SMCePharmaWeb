CREATE PROCEDURE [dbo].[sp_Get_DashboardDeptoWiseOrder] 
	-- Add the parameters for the stored procedure here
   
   
AS
    BEGIN
	
	declare  @currentDate DATETIME


set	@currentDate=getdate()

 
	
      SELECT rg.RegionName ComUnitName,  convert(decimal(18,0), ISNULL(sum(A.GrossValue-A.TotalDiscount),0)) TotalOrder
        FROM    dbo.tblOrder A   with (nolock)

		inner join tblRegion rg with (nolock) on A.RegionId=rg.RegionId
		 
  WHERE ActionStatus<>'3'  and  convert(Date,A.SubmissionDate) = convert(Date,@currentDate)

		group by rg.RegionName
		having ISNULL(sum(A.GrossValue-A.TotalDiscount),0)>0



    END

 