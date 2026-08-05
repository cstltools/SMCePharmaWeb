

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Approve_TADAClaim]
	-- Add the parameters for the stored procedure here
   
    @TadaID NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) 
  

AS
    BEGIN
         

		UPDATE tbl_TadaClaimMaster 
	    Set ApprovalStatus = 'Approved' ,
	        ApprovedBy = @ApprovedBy ,
			ApprovedDate = GETDATE()

	    WHERE  TadaID in (select * from fnSplit(@TadaID,','))

    END
	


