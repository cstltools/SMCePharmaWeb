-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_TadaClaimMaster_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT format(mas.TadaDate,'dd MMMM, yyyy')  TadaDate,*	  
		  FROM [tbl_TadaClaimMaster] mas with (nolock)
		  
				WHERE mas.TadaID = @id

    END
