-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_BDoctorChemberDetail]
	-- Add the parameters for the stored procedure here
	 

@ChamberTypeId  INT,
@DoctorId  INT,
@Name   nvarchar(max)=null,
@Phone   nvarchar(max)=null,
@Address   nvarchar(max)=null
 
AS
    BEGIN
	declare @coun  INT=0
	if(@Name is not null)

select @coun=ISNULL(count(*),0) from [tblDoctorChemberDetail] where ChamberTypeId=@ChamberTypeId and  DoctorId=@DoctorId and Name=@Name

if(@coun=0)

BEGIN
	INSERT INTO [dbo].[tblDoctorChemberDetail]
           ([ChamberTypeId]
           ,[DoctorId]
           ,[Name]
           ,[Phone]
           ,[Address])
     VALUES
           (@ChamberTypeId 
           ,@DoctorId 
           ,@Name 
           ,@Phone
           ,@Address)

 END

END

