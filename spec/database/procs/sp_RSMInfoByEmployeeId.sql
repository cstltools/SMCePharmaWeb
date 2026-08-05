CREATE PROCEDURE [dbo].[sp_RSMInfoByEmployeeId]
	-- Add the parameters for the stored procedure here
    @EmployeeId  INT 

AS
    BEGIN

select rg.GroupId, rsm.RegionId,* from tblRSMInfo rsm
inner join tblRegion rg on rsm.RegionId=rsm.RegionId
where EmployeeId=@EmployeeId and rsm.IsActive=1

end