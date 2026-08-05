
CREATE PROCEDURE [dbo].[sp_GET_DAInfo]
    @Parameter int
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX);
	 
        SELECT 
            DA.DACode,
			cc.ComUnitName AS ComUnitName,
            DA.DAId,
            DA.NID,
            DA.Name,
            DA.Address,
            DA.PhoneNo,
            DA.EmergencyContactNo,
            DA.ReferenceName,
            DA.ReferencePhone,
            DA.Remarks,
            DA.ComUnitId,
            DA.JoiningDate,
            DA.IsActive,
			 case when  ISNULL( DA.IsActive,0)=1 then 'Active' else 'Inactive' end StatusText,
          case when  ISNULL( DA.IsActive,0)=1 then   DA.ActiveDate else DA.InactiveDate end ActiveInActiveDate,
            DA.InactiveDate,
            UE.UserName AS EntryBy,
            UU.UserName AS UpdateBy,
            DA.EntryDate,
            DA.UpdateDate
        FROM tblDAInfo AS DA WITH (NOLOCK)
        LEFT JOIN tblUser AS UE WITH (NOLOCK) ON DA.EntryBy = UE.UserId
		LEFT JOIN tblCompanyUnit cc on cc.ComUnitId=da.ComUnitId
        LEFT JOIN tblUser AS UU WITH (NOLOCK) ON DA.UpdateBy = UU.UserId
        WHERE DA.DAId IS NOT NULL  and da.ComUnitId in (  SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=cast(@Parameter as int))
END

