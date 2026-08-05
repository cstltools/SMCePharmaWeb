-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Save_NationaltargetSetup]
	-- Add the parameters for the stored procedure here
	@NatargetSpId INT,
    @Year  NVARCHAR(MAX) NULL,
	@Month NVARCHAR(MAX) NULL,
	@GroupId INT NULL,
	@Amount NVARCHAR(MAX) NULL,
    @EntryBy NVARCHAR(MAX) NULL

AS
    BEGIN

	IF(@NatargetSpId=0)
	 BEGIN 

		IF NOT EXISTS (select Year, Month, GroupId from tblNationalTargetSetup where Year=@Year AND Month=@Month AND GroupId=@GroupId )
        begin 
        INSERT  INTO dbo.tblNationalTargetSetup
                ( Year ,                 
                  Month ,
                  GroupId ,
				  Amount,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @Year ,              
                  @Month ,
                  @GroupId,
				  @Amount,
                  @EntryBy ,
                  GETDATE() 	
	            )

         SELECT SCOPE_IDENTITY()

        End
        else  Return 0
	END

	 

	--Update tblNationalTargetSetup SET  Amount= @Amount , UpdateBy=@EntryBy , UpdateDate= GETDATE()  Where NatargetSpId=@NatargetSpId
 
		
END


