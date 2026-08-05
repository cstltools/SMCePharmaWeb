-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_MonthlyAllowance_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT dtl.EmpInfoId, dtl.UserRoleId, A.MonthlyAllowanceId ,
          A.MonthlyAllowanceName ,
		  A.MonthlyAllowance,   
          A.IsActive ,
          A.Activedate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM [dbo].[tbl_MonthlyAllowance] A with (nolock)
		  left join tbl_MonthlyAllowanceDetail dtl  with (nolock) on A.MonthlyAllowanceId=dtl.MonthlyAllowanceId
				WHERE A.MonthlyAllowanceId = @id

    END
