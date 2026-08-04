IF COL_LENGTH('dbo.tblProviderDropoutIntrigration', 'IsApprove') IS NULL
BEGIN
    ALTER TABLE dbo.tblProviderDropoutIntrigration
    ADD IsApprove BIT NOT NULL
        CONSTRAINT DF_tblProviderDropoutIntrigration_IsApprove DEFAULT (0);
END
GO

IF COL_LENGTH('dbo.tblProviderDropoutIntrigration', 'IsApproveBy') IS NULL
BEGIN
    ALTER TABLE dbo.tblProviderDropoutIntrigration
    ADD IsApproveBy NVARCHAR(50) NULL;
END
GO

IF COL_LENGTH('dbo.tblProviderDropoutIntrigration', 'ApproveDate') IS NULL
BEGIN
    ALTER TABLE dbo.tblProviderDropoutIntrigration
    ADD ApproveDate DATETIME2 NULL;
END
GO
