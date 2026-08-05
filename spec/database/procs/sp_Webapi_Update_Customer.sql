-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_Customer]
	-- Add the parameters for the stored procedure here
@id int,

  @name NVARCHAR(MAX) = NULL ,
    @address NVARCHAR(MAX) = NULL ,
    @phone NVARCHAR(MAX) = NULL ,
    @conPerson NVARCHAR(MAX) = NULL ,
    @termOfPayment NVARCHAR(50) = NULL ,
    @isFromApp BIT = NULL ,
    @marketId INT = NULL ,
    @ProgramTypeId INT = NULL ,
     @empId INT = NULL ,
	   @CustomerBSPCode NVARCHAR(MAX) = NULL ,
    --@districtId INT = NULL ,
    --@divisionId INT = NULL ,
  
    

	 
	@VoterID  NVARCHAR(MAX) = NULL ,

            @TradeLicense NVARCHAR(MAX) = NULL  ,
			@Reamrks NVARCHAR(MAX) = NULL ,

    @Latitude NVARCHAR(MAX) = NULL ,
    @Longitude NVARCHAR(MAX) = NULL ,

	@StreetAddress NVARCHAR(MAX) = NULL ,
    @SMCTypeId INT = NULL  ,
	@DoctorAddress NVARCHAR(MAX) = NULL

AS
BEGIN

 DECLARE @userid INT  


        SELECT  @userid = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId

		 DECLARE 	@GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId INT,@SubTerritoryId INT
		select @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		  where  MarketId=@MarketId
UPDATE [dbo].tblCustMaster
   SET 
                  CustomerName =@name,
                  Address =@address,
                  CellNo=@phone ,
                  ConPerson=@conPerson ,  
                  TermOfPayment=@termOfPayment ,
				  UpdateBy=@userid,
				  UpdateDate=GETDATE(),
				 [VoterID]=@VoterID
           ,[TradeLicense]=@TradeLicense,
		   Reamrks=@Reamrks,
		   OwnerName=@conPerson,
		   GroupId=@GroupId,
		   RegionId=@RegionId,
		   AreaId=@AreaId,
		   TerritoryId=@TerritoryId,
		   SubTerritoryId=@SubTerritoryId, 
		   MarketId=@marketId,
		    ProgramTypeId=@ProgramTypeId, SMCTypeId=@SMCTypeId

		   WHERE CustomerMasterId=@id
END

