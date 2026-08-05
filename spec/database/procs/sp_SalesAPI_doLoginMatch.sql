CREATE PROCEDURE [dbo].[sp_SalesAPI_doLoginMatch]
    @username NVARCHAR(50) ,
    @password NVARCHAR(50),
	@Imei NVARCHAR(max),
	@DeviceInfo NVARCHAR(max),
	 
	 
	@OS NVARCHAR(max),
	@OS_Version NVARCHAR(max) ,
	@AppVersion NVARCHAR(max) 
AS
    BEGIN

 select * from tblUser WHERE LoginName=@username AND Password=@password AND UserStatus = 'Active' 
	

    END