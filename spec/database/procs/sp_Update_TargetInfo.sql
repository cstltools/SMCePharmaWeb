
 create PROCEDURE [dbo].[sp_Update_TargetInfo]
	-- Add the parameters for the stored procedure here
	@SL INT,
  
	@UpdateBy nvarchar(50)=NULL,

	 

	  @Value DECIMAL(18,2)=NULL,
 
	@FYId int=null,
	@YearValue int=null,
	@MonthName int=null,
	@EmpId int=null 
	 

 

   
AS
    BEGIN

      UPDATE [dbo].[tblTerritoryDataMigration]
   SET  [Value] = @Value 
     
     
 WHERE    SL=@SL
    END
