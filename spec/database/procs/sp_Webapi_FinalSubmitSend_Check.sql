
CREATE PROCEDURE [dbo].[sp_Webapi_FinalSubmitSend_Check]
	-- Add the parameters for the stored procedure here
@empId INT=null,
@month INT = NULL,
@year INT = NULL,
@remarks NVARCHAR(max) = NULL
As
BEGIN

Declare @MonthName nvarchar(max),@TotalTarget decimal
Select @MonthName=DateName( month , DateAdd( month , @month , -1 ) )

select @TotalTarget= CAST(ISNULL(sum(dtl.Amount),0) as nvarchar(max))   from tblMIOInfo mas

inner join tblTerritoryWiseTargetSetup dtl on mas.TerritoryId=dtl.TerritoryId
 where mas.IsActive=1 and mas.EmployeeId=@empId and dtl.Month=@MonthName and dtl.Year=@year
	declare	@CheckInfo	decimal
			select  @CheckInfo = ISNULL(ISNULL(sum(dtl.FCBAmount),0) +ISNULL(sum(dtl.GeneralAmount),0) +ISNULL(sum(dtl.CampaignAmount),0),0) from [tbl_DWSPMaster] mas

inner join [tbl_DWSPDetail] dtl on mas.DWSPMasterId=dtl.DWSPMasterId
 where mas.EmpInfoId=@empId and mas.MonthValue=@month and mas.YearValue=@year

 --if(@TotalTarget=@CheckInfo)
 --begin
			select 1 col
		union all 	select 1 col
			





--END

--else
--begin 

--			select  'Target Amount='+cast(@TotalTarget as nvarchar(max)) +'& Submitted Amount=' +cast(@CheckInfo as nvarchar(max))+' [Did not Matched]'  col



--END

END