CREATE PROCEDURE [dbo].[sp_Get_DashboardOrder_DeptoWise] 
	-- Add the parameters for the stored procedure here
   
   
AS
    BEGIN
	
	declare  @currentDate DATETIME


set	@currentDate=getdate()

 
	
      SELECT rg.ShortName ComUnitName,  convert(decimal(18,0), ISNULL(sum(A.GrossValue-A.TotalDiscount),0)) TotalOrder
        FROM    dbo.tblOrder A   with (nolock)

		inner join tblCompanyUnit rg with (nolock) on A.ComUnitId=rg.ComUnitId
		 
  WHERE ActionStatus<>'3'  and  convert(Date,A.SubmissionDate) = convert(Date,@currentDate)

		group by rg.ShortName
		having ISNULL(sum(A.GrossValue-A.TotalDiscount),0)>0



    END