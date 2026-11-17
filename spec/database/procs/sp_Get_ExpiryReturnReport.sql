ALTER PROCEDURE dbo.sp_Get_ExpiryReturnReport
    @ComUnitId INT = 0,
    @FromDate DATE,
    @ToDate DATE,
    @RoleTypeName NVARCHAR(50) = NULL,
    @EmpInfoId INT = 0,
    @ApprovalStatus NVARCHAR(20) = N'APPROVED'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Role NVARCHAR(50) = UPPER(LTRIM(RTRIM(ISNULL(@RoleTypeName, N''))));

    -- Approved Expiry Return requests only, one row per returned product/batch
    SELECT mas.ExpiryReturnId,
           ISNULL(cu.ComUnitCode, N'') AS ComUnitCode,
           ISNULL(cu.ComUnitName, N'') AS ComUnitName,
           ISNULL(da.DACode, N'') AS DACode,
           ISNULL(da.Name, N'') AS DAName,
           mas.CustomerCode,
           mas.CustomerName,
           mas.SubmitDate,
           mas.Remarks,
           det.ProductCode,
           det.ProductName,
           dcs.PackSize,
           det.BatchNo,
           dcs.ExpDate,
           det.ReturnQty,
           det.ReasonName,
           mas.AM_ApproveBy AS AM_EmpCode,
           amEmp.EmpName AS AM_EmpName,
           mas.AM_ApproveDate,
           mas.DZSM_ApproveBy AS DZSM_EmpCode,
           dzsmEmp.EmpName AS DZSM_EmpName,
           mas.DZSM_ApproveDate,
           mas.DIC_ApproveBy AS DIC_EmpCode,
           dicEmp.EmpName AS DIC_EmpName,
           mas.DIC_ApproveDate
    FROM dbo.tblExpiryReturn_appLog mas WITH (NOLOCK)
    INNER JOIN dbo.tblExpiryReturn_appLogDetail det WITH (NOLOCK) ON mas.ExpiryReturnId = det.ExpiryReturnId
    LEFT JOIN dbo.tblCompanyUnit cu WITH (NOLOCK) ON mas.ComUnitId = cu.ComUnitId
    LEFT JOIN dbo.tblDAInfo da WITH (NOLOCK) ON mas.DaId = da.DAId
    -- ApproveBy columns store the approver's login name = employee code
    OUTER APPLY (SELECT TOP 1 e.EmpName FROM dbo.tblEmpGeneralInfo e WITH (NOLOCK) WHERE e.EmpMasterCode = mas.AM_ApproveBy) amEmp
    OUTER APPLY (SELECT TOP 1 e.EmpName FROM dbo.tblEmpGeneralInfo e WITH (NOLOCK) WHERE e.EmpMasterCode = mas.DZSM_ApproveBy) dzsmEmp
    OUTER APPLY (SELECT TOP 1 e.EmpName FROM dbo.tblEmpGeneralInfo e WITH (NOLOCK) WHERE e.EmpMasterCode = mas.DIC_ApproveBy) dicEmp
    LEFT JOIN dbo.tblDCStore dcs WITH (NOLOCK)
           ON (det.DCStoreId > 0 AND det.DCStoreId = dcs.DCStoreId)
           OR (ISNULL(det.DCStoreId, 0) = 0 AND dcs.DCStoreId = (
               SELECT TOP 1 subDcs.DCStoreId
               FROM dbo.tblDCStore subDcs WITH (NOLOCK)
               WHERE subDcs.ProductCode = det.ProductCode
                 AND subDcs.BatchNo = det.BatchNo
                 AND subDcs.ComUnitId = mas.ComUnitId
               ORDER BY subDcs.DCStoreId DESC
           ))
    WHERE (ISNULL(@ApprovalStatus, N'') IN (N'', N'ALL') OR UPPER(LTRIM(RTRIM(ISNULL(mas.ApprovalStatus, N'')))) = UPPER(LTRIM(RTRIM(@ApprovalStatus))))
      AND (@ComUnitId <= 0 OR mas.ComUnitId = @ComUnitId)
      AND CONVERT(date, mas.SubmitDate) BETWEEN @FromDate AND @ToDate
      AND (
          @Role IN ('', 'ADMIN', 'SUPERADMIN', 'HO', 'DIC')
          OR (@Role = 'AM' AND (@EmpInfoId <= 0 OR mas.AmEmpId = @EmpInfoId OR mas.AreaId IN (SELECT AreaId FROM dbo.tblASMInfo WHERE EmployeeId = @EmpInfoId)))
          OR (@Role IN ('DZSM', 'RSM') AND (@EmpInfoId <= 0 OR mas.DzsmEmpId = @EmpInfoId OR mas.RegionId IN (SELECT RegionId FROM dbo.tblRSMInfo WHERE EmployeeId = @EmpInfoId)))
      )
    ORDER BY mas.ExpiryReturnId DESC, det.ExpiryReturnDetailId;
END

