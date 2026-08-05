
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_Transport_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT * 	  
		  FROM [dbo].tbl_Transport A
		  WHERE A.TransportId = @id

    END

