-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE
 PROCEDURE [dbo].[sp_Get_Employee_ShiftInfos_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT CONVERT(varchar(100),CAST(ShiftInTime AS TIME),100)   ShiftInTime,CONVERT(varchar(100),CAST(ShiftOutTime AS TIME),100)    ShiftOutTime,  *	  
		  FROM dbo.tbl_Shift A
				WHERE A.ShiftId = @id

    END


