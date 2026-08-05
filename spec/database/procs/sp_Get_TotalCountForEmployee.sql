CREATE PROCEDURE [dbo].[sp_Get_TotalCountForEmployee] 
	-- Add the parameters for the stored procedure here
   @currentDate datetime,

   @EmpId int
   
AS
    BEGIN
	declare 	   @TotalOrder NVARCHAR(50),
	 @totalDcr NVARCHAR(50),
	 @TotalRX NVARCHAR(50),
	 @UserId int


	select @UserId=UserId from tbluser where empInfoid=@EmpId


	
        SELECT  @TotalOrder =CONVERT(decimal(18,2), ISNULL(sum(GrossValue-TotalDiscount),0))
        FROM    dbo.tblOrder  with (nolock)
        WHERE    EntryBy=@UserId and    convert(Date,SubmissionDate) =convert(Date, @currentDate)

			SELECT @totalDcr = ISNULL(COUNT(*),0) FROM dbo.tbl_DCRInfo  with (nolock) WHERE  tbl_DCRInfo.EntryBy=@UserId and  convert(Date,DcrDate) = convert(Date,@currentDate)  



			
		SELECT @TotalRX = ISNULL(COUNT(*),0) FROM dbo.tbl_PrescriptionMaster  with (nolock) WHERE EntryBy=@UserId and  convert(Date,PrescriptionDate) = convert(Date,@currentDate)  



		   SELECT  ISNULL(@TotalOrder, 0) AS  TotalOrder ,ISNULL(@totalDcr, 0) AS   totalDcr , ISNULL(@TotalRX, 0) AS    TotalRX
		   
		   
		   
		   
		   
		   end  