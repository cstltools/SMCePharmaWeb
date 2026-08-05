
CREATE PROCEDURE [dbo].[sp_Get_GetDWSPTotalsByEmpId] 
	-- Add the parameters for the stored procedure here
   @month int,
   @year int,
   @empId int

   
AS
    BEGIN


	 DECLARE @TotalTarget NVARCHAR(max) ,
            @TotalFcb NVARCHAR(max) ,
            @TotalGeneral NVARCHAR(max) ,
            @TotalCampaign NVARCHAR(max),
			  @TotalExtra1 NVARCHAR(max),
			   @TotalExtra2 NVARCHAR(max),
			   @ApprovalStatus NVARCHAR(max),
			   @CheckInfo NVARCHAR(max),

			   @IsFinalSubmit bit
Declare @MonthName nvarchar(max)
Select @MonthName=DateName( month , DateAdd( month , @month , -1 ) )

 

 select  @TotalFcb= CAST(ISNULL(sum(dtl.FCBAmount),0) as nvarchar(max)) ,@TotalGeneral= CAST(ISNULL(sum(dtl.GeneralAmount),0) as nvarchar(max)),@TotalCampaign= CAST(ISNULL(sum(dtl.CampaignAmount),0) as nvarchar(max)), @CheckInfo = FLOOR(ISNULL(ISNULL(sum(dtl.FCBAmount),0) +ISNULL(sum(dtl.GeneralAmount),0) +ISNULL(sum(dtl.CampaignAmount),0),0)) from [tbl_DWSPMaster] mas

inner join [tbl_DWSPDetail] dtl on mas.DWSPMasterId=dtl.DWSPMasterId
 where mas.EmpInfoId=@empId and mas.MonthValue=@month and mas.YearValue=@year
 

 select @IsFinalSubmit=ISNULL(mas.IsFinalSubmit,0), @ApprovalStatus=ISNULL(mas.ApprovalStatus,0)  from [tbl_DWSPMaster] mas where mas.EmpInfoId=@empId and mas.MonthValue=@month and mas.YearValue=@year

 set @TotalTarget=@CheckInfo
   SELECT  ISNULL(@TotalTarget, 0) AS  TotalTarget ,
                ISNULL(@TotalFcb, 0) AS  TotalFcb ,
                ISNULL(@TotalGeneral, 0) AS TotalGeneral ,
                ISNULL(@TotalCampaign, 0) AS TotalCampaign,
				ISNULL(@TotalExtra1, 0) AS TotalExtra1,
				ISNULL(@TotalExtra2, 0) AS TotalExtra2 ,
				ISNULL(@IsFinalSubmit, 0) AS IsFinalSubmit ,
				ISNULL(@ApprovalStatus, 0) AS  ApprovalStatus,
				ISNULL(@CheckInfo, 0) AS   CheckInfo



 end