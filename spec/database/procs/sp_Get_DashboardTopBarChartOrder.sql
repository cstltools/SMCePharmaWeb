CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarChartOrder] 
	-- Add the parameters for the stored procedure here
   
   
AS
    BEGIN
declare @Day1 nvarchar(50)
declare @Day2 nvarchar(50)
declare @Day3 nvarchar(50)
declare @Day4 nvarchar(50)
declare @Day5 nvarchar(50)
declare @Day6 nvarchar(50)
declare @Day7 nvarchar(50)


 SELECT  @Day1 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-7) 
		
		 SELECT  @Day2 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-6)  
		
		 SELECT  @Day3 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-5)  
		
		
		 SELECT  @Day4 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-4)  
		
		 SELECT  @Day5 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-3)  
		
		 SELECT  @Day6 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-2)  
		
		 SELECT  @Day7 =ISNULL(sum(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) =  convert(Date, getdate()-1)   

	 

        SELECT  1 [DayName], ISNULL(@Day1, 0) AS  DayCount  Union All
        SELECT 2 [DayName],   ISNULL(@Day2, 0) AS  DayCount  Union All
        SELECT 3 [DayName],  ISNULL(@Day3, 0) AS    DayCount  Union All
        SELECT 4 [DayName],  ISNULL(@Day4, 0) AS DayCount  Union All
        SELECT 5 [DayName],  ISNULL(@Day5, 0) AS  DayCount  Union All
        SELECT 6 [DayName],  ISNULL(@Day6, 0) AS  DayCount  Union All
        SELECT 7 [DayName],  ISNULL(@Day7, 0) AS  DayCount  



                end