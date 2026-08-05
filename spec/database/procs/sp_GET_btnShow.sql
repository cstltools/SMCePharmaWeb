
create PROCEDURE [dbo].[sp_GET_btnShow]
	-- Add the parameters for the stored procedure here
    @PageName nvarchar(max)


AS
    BEGIN
 select * from  [dbo].[tblSubmitButton] where [LinkText]=@PageName  and [btnVisible]=1
    END

	

