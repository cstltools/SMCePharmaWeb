-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_CustomerBSP]
	-- Add the parameters for the stored procedure here
@id int,
 
     @empId INT = NULL ,
	   @CustomerBSPCode NVARCHAR(MAX) = NULL  

AS
BEGIN

 DECLARE @userid INT  


 	 
          DECLARE @CustomerBsPCodeJust VARCHAR(50)=null
          if( @CustomerBsPCode='Select')
          begin
          set @CustomerBsPCodeJust=null
          end
          else
          begin

          SET @CustomerBsPCodeJust = LTRIM(RTRIM((SUBSTRING(@CustomerBsPCode, 1, CHARINDEX(':', @CustomerBsPCode) - 1))))
          end


        SELECT  @userid = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId
        declare @CustomerBsPTag nvarchar(max)=''
        select @CustomerBsPTag=isnull(CustomerBsPTag,'') from tblCustMaster  WHERE CustomerMasterId=@id

        if(@CustomerBsPTag='')
        begin
		 
UPDATE [dbo].tblCustMaster
   SET 
                  CustomerBsPCode =@CustomerBsPCodeJust ,CustomerBsPCodeUpdateBy= @userid, CustomerBsPCodeUpdateDate=GETDATE(), CustomerBsPCodeInfo=   @CustomerBsPCode 


		   WHERE CustomerMasterId=@id

           end
END

