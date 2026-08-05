


create PROCEDURE [dbo].[sp_CS_GetArea_ByZoneId_ForAMOnly]
    -- Add the parameters for the stored procedure here
    @id nvarchar(max)
AS
BEGIN
        
        SELECT   AreaId, AreaCode+' : '+  CASE WHEN IsActive=1 THEN   AreaName  ELSE   AreaName+' (Inactive)' END  AreaName  FROM dbo.tblArea WITH (NOLOCK)  where  AreaId in (select * from fnSplit(@id,','))
END
