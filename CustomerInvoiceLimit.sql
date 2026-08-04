USE [SSIDB]
GO

/****** Object:  Table [dbo].[tblCustomerInvoiceLimit] ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCustomerInvoiceLimit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCustomerInvoiceLimit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[MaximumInvoiceValue] [decimal](18, 2) NOT NULL DEFAULT 50000,
	[Remarks] [nvarchar](250) NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblCustomerInvoiceLimit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  StoredProcedure [dbo].[sp_InsertCustomerInvoiceLimit] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_InsertCustomerInvoiceLimit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_InsertCustomerInvoiceLimit]
GO

CREATE PROCEDURE [dbo].[sp_InsertCustomerInvoiceLimit]
	@CustomerId INT,
	@MaximumInvoiceValue DECIMAL(18,2),
	@Remarks NVARCHAR(250),
	@IsActive BIT,
	@CreatedBy NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
    
	IF EXISTS(SELECT 1 FROM dbo.tblCustomerInvoiceLimit WHERE CustomerId = @CustomerId)
	BEGIN
		RAISERROR('This customer already has a maximum invoice configuration.', 16, 1);
		RETURN;
	END

	INSERT INTO dbo.tblCustomerInvoiceLimit (CustomerId, MaximumInvoiceValue, Remarks, IsActive, CreatedBy, CreatedDate)
	VALUES (@CustomerId, @MaximumInvoiceValue, @Remarks, @IsActive, @CreatedBy, GETDATE());
END
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateCustomerInvoiceLimit] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateCustomerInvoiceLimit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_UpdateCustomerInvoiceLimit]
GO

CREATE PROCEDURE [dbo].[sp_UpdateCustomerInvoiceLimit]
	@Id INT,
	@MaximumInvoiceValue DECIMAL(18,2),
	@Remarks NVARCHAR(250),
	@IsActive BIT,
	@UpdatedBy NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
    
	UPDATE dbo.tblCustomerInvoiceLimit
	SET 
		MaximumInvoiceValue = @MaximumInvoiceValue,
		Remarks = @Remarks,
		IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,
		UpdatedDate = GETDATE()
	WHERE Id = @Id;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_DeleteCustomerInvoiceLimit] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteCustomerInvoiceLimit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_DeleteCustomerInvoiceLimit]
GO

CREATE PROCEDURE [dbo].[sp_DeleteCustomerInvoiceLimit]
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;
    
	DELETE FROM dbo.tblCustomerInvoiceLimit WHERE Id = @Id;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetCustomerInvoiceLimitById] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCustomerInvoiceLimitById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetCustomerInvoiceLimitById]
GO

CREATE PROCEDURE [dbo].[sp_GetCustomerInvoiceLimitById]
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT 
		CIL.Id,
		CIL.CustomerId,
		C.CustomerCode,
		C.CustomerName,
		ISNULL(C.CellNo, '') AS MobileNo,
		CIL.MaximumInvoiceValue,
		CIL.Remarks,
		CIL.IsActive
	FROM dbo.tblCustomerInvoiceLimit CIL
	INNER JOIN dbo.tblCustMaster C ON CIL.CustomerId = C.CustomerMasterId
	WHERE CIL.Id = @Id;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetCustomerInvoiceLimits] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCustomerInvoiceLimits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetCustomerInvoiceLimits]
GO

CREATE PROCEDURE [dbo].[sp_GetCustomerInvoiceLimits]
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT 
		CIL.Id,
		CIL.CustomerId,
		C.CustomerCode,
		C.CustomerName,
		ISNULL(C.CellNo, '') AS MobileNo,
		CIL.MaximumInvoiceValue,
		CIL.Remarks,
		CIL.IsActive,
		CIL.CreatedBy,
		CIL.CreatedDate
	FROM dbo.tblCustomerInvoiceLimit CIL
	INNER JOIN dbo.tblCustMaster C ON CIL.CustomerId = C.CustomerMasterId
	ORDER BY CIL.CreatedDate DESC;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetCustomerAutoComplete] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCustomerAutoComplete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetCustomerAutoComplete]
GO

CREATE PROCEDURE [dbo].[sp_GetCustomerAutoComplete]
	@Keyword NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT TOP 20
		CustomerMasterId AS CustomerId,
		CustomerCode,
		CustomerName,
		ISNULL(CellNo, '') AS MobileNo
	FROM dbo.tblCustMaster
	WHERE CustomerCode LIKE '%' + @Keyword + '%'
	   OR CustomerName LIKE '%' + @Keyword + '%'
	   OR ISNULL(CellNo, '') LIKE '%' + @Keyword + '%';
END
GO

/****** Object:  Table [dbo].[tblInvoiceNotBinding] ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblInvoiceNotBinding]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblInvoiceNotBinding](
	[InvoiceNotBindingId] [int] IDENTITY(1,1) NOT NULL,
	[ApplyType] [varchar](20) NOT NULL DEFAULT 'Customer',
	[CustomerId] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[CustomerTypeId] [int] NULL,
	[ActiveFromDate] [date] NOT NULL,
	[ActiveToDate] [date] NULL,
	[AllowedNoOfInvoice] [int] NULL DEFAULT 4,
	[AllowedCreditLimit] [decimal](18, 2) NULL DEFAULT 100000.00,
	[NumberOfDaysInTransit] [int] NULL DEFAULT 45,
	[Remarks] [nvarchar](250) NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblInvoiceNotBinding] PRIMARY KEY CLUSTERED
(
	[InvoiceNotBindingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Upgrade path for an already-existing table created before ApplyType/CustomerTypeId were introduced
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblInvoiceNotBinding]') AND type in (N'U'))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[tblInvoiceNotBinding]') AND name = 'ApplyType')
		ALTER TABLE [dbo].[tblInvoiceNotBinding] ADD [ApplyType] [varchar](20) NOT NULL DEFAULT 'Customer';

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[tblInvoiceNotBinding]') AND name = 'CustomerTypeId')
		ALTER TABLE [dbo].[tblInvoiceNotBinding] ADD [CustomerTypeId] [int] NULL;

	IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[tblInvoiceNotBinding]') AND name = 'CustomerId' AND is_nullable = 0)
		ALTER TABLE [dbo].[tblInvoiceNotBinding] ALTER COLUMN [CustomerId] [int] NULL;

	IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[tblInvoiceNotBinding]') AND name = 'CustomerCode' AND is_nullable = 0)
		ALTER TABLE [dbo].[tblInvoiceNotBinding] ALTER COLUMN [CustomerCode] [varchar](50) NULL;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_InsertInvoiceNotBinding] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_InsertInvoiceNotBinding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_InsertInvoiceNotBinding]
GO

CREATE PROCEDURE [dbo].[sp_InsertInvoiceNotBinding]
	@ApplyType VARCHAR(20) = 'Customer',
	@CustomerId INT = NULL,
	@CustomerCode VARCHAR(50) = NULL,
	@CustomerTypeId INT = NULL,
	@ActiveFromDate DATE,
	@ActiveToDate DATE = NULL,
	@AllowedNoOfInvoice INT = 4,
	@AllowedCreditLimit DECIMAL(18,2) = 100000.00,
	@NumberOfDaysInTransit INT = 45,
	@Remarks NVARCHAR(250) = NULL,
	@IsActive BIT = 1,
	@CreatedBy NVARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @ApplyType = 'CustomerType'
	BEGIN
		IF @CustomerTypeId IS NULL OR @CustomerTypeId <= 0
		BEGIN
			RAISERROR('Customer Type is required.', 16, 1);
			RETURN;
		END

		IF EXISTS(SELECT 1 FROM dbo.tblInvoiceNotBinding WHERE ApplyType = 'CustomerType' AND CustomerTypeId = @CustomerTypeId)
		BEGIN
			RAISERROR('This customer type already exists in Invoice Limit Setup.', 16, 1);
			RETURN;
		END

		INSERT INTO dbo.tblInvoiceNotBinding
			(ApplyType, CustomerId, CustomerCode, CustomerTypeId, ActiveFromDate, ActiveToDate, AllowedNoOfInvoice, AllowedCreditLimit, NumberOfDaysInTransit, Remarks, IsActive, CreatedBy, CreatedDate)
		VALUES
			('CustomerType', NULL, NULL, @CustomerTypeId, @ActiveFromDate, @ActiveToDate, @AllowedNoOfInvoice, @AllowedCreditLimit, @NumberOfDaysInTransit, @Remarks, @IsActive, @CreatedBy, GETDATE());
	END
	ELSE
	BEGIN
		IF @CustomerId IS NULL OR @CustomerId <= 0
		BEGIN
			RAISERROR('Customer is required.', 16, 1);
			RETURN;
		END

		IF ISNULL(@CustomerCode, '') = ''
		BEGIN
			SELECT @CustomerCode = CustomerCode FROM dbo.tblCustMaster WHERE CustomerMasterId = @CustomerId;
		END

		IF EXISTS(SELECT 1 FROM dbo.tblInvoiceNotBinding WHERE ApplyType = 'Customer' AND CustomerId = @CustomerId)
		BEGIN
			RAISERROR('This customer already exists in Invoice Limit Setup.', 16, 1);
			RETURN;
		END

		INSERT INTO dbo.tblInvoiceNotBinding
			(ApplyType, CustomerId, CustomerCode, CustomerTypeId, ActiveFromDate, ActiveToDate, AllowedNoOfInvoice, AllowedCreditLimit, NumberOfDaysInTransit, Remarks, IsActive, CreatedBy, CreatedDate)
		VALUES
			('Customer', @CustomerId, @CustomerCode, NULL, @ActiveFromDate, @ActiveToDate, @AllowedNoOfInvoice, @AllowedCreditLimit, @NumberOfDaysInTransit, @Remarks, @IsActive, @CreatedBy, GETDATE());
	END
END
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateInvoiceNotBinding] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateInvoiceNotBinding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_UpdateInvoiceNotBinding]
GO

CREATE PROCEDURE [dbo].[sp_UpdateInvoiceNotBinding]
	@InvoiceNotBindingId INT,
	@ActiveFromDate DATE,
	@ActiveToDate DATE = NULL,
	@AllowedNoOfInvoice INT = 4,
	@AllowedCreditLimit DECIMAL(18,2) = 100000.00,
	@NumberOfDaysInTransit INT = 45,
	@Remarks NVARCHAR(250) = NULL,
	@IsActive BIT = 1,
	@UpdatedBy NVARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	-- ApplyType, CustomerId/CustomerCode and CustomerTypeId are fixed at creation time and not editable.
	UPDATE dbo.tblInvoiceNotBinding
	SET
		ActiveFromDate = @ActiveFromDate,
		ActiveToDate = @ActiveToDate,
		AllowedNoOfInvoice = @AllowedNoOfInvoice,
		AllowedCreditLimit = @AllowedCreditLimit,
		NumberOfDaysInTransit = @NumberOfDaysInTransit,
		Remarks = @Remarks,
		IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,
		UpdatedDate = GETDATE()
	WHERE InvoiceNotBindingId = @InvoiceNotBindingId;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_DeleteInvoiceNotBinding] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteInvoiceNotBinding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_DeleteInvoiceNotBinding]
GO

CREATE PROCEDURE [dbo].[sp_DeleteInvoiceNotBinding]
	@InvoiceNotBindingId INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM dbo.tblInvoiceNotBinding WHERE InvoiceNotBindingId = @InvoiceNotBindingId;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetInvoiceNotBindingById] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetInvoiceNotBindingById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetInvoiceNotBindingById]
GO

CREATE PROCEDURE [dbo].[sp_GetInvoiceNotBindingById]
	@InvoiceNotBindingId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		INB.InvoiceNotBindingId,
		INB.ApplyType,
		INB.CustomerId,
		INB.CustomerCode,
		C.CustomerName,
		ISNULL(C.CellNo, '') AS MobileNo,
		INB.CustomerTypeId,
		CT.CustomerType AS CustomerTypeName,
		INB.ActiveFromDate,
		INB.ActiveToDate,
		ISNULL(INB.AllowedNoOfInvoice, 4) AS AllowedNoOfInvoice,
		ISNULL(INB.AllowedCreditLimit, 100000.00) AS AllowedCreditLimit,
		ISNULL(INB.NumberOfDaysInTransit, 45) AS NumberOfDaysInTransit,
		INB.Remarks,
		INB.IsActive
	FROM dbo.tblInvoiceNotBinding INB
	LEFT JOIN dbo.tblCustMaster C ON INB.CustomerId = C.CustomerMasterId
	LEFT JOIN dbo.tblCustomerType CT ON INB.CustomerTypeId = CT.CustomerTypeId
	WHERE INB.InvoiceNotBindingId = @InvoiceNotBindingId;
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetInvoiceNotBindingList] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetInvoiceNotBindingList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetInvoiceNotBindingList]
GO

CREATE PROCEDURE [dbo].[sp_GetInvoiceNotBindingList]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		INB.InvoiceNotBindingId,
		INB.ApplyType,
		INB.CustomerId,
		INB.CustomerCode,
		C.CustomerName,
		ISNULL(C.CellNo, '') AS MobileNo,
		INB.CustomerTypeId,
		CT.CustomerType AS CustomerTypeName,
		INB.ActiveFromDate,
		INB.ActiveToDate,
		ISNULL(INB.AllowedNoOfInvoice, 4) AS AllowedNoOfInvoice,
		ISNULL(INB.AllowedCreditLimit, 100000.00) AS AllowedCreditLimit,
		ISNULL(INB.NumberOfDaysInTransit, 45) AS NumberOfDaysInTransit,
		INB.Remarks,
		INB.IsActive,
		INB.CreatedBy,
		INB.CreatedDate
	FROM dbo.tblInvoiceNotBinding INB
	LEFT JOIN dbo.tblCustMaster C ON INB.CustomerId = C.CustomerMasterId
	LEFT JOIN dbo.tblCustomerType CT ON INB.CustomerTypeId = CT.CustomerTypeId
	ORDER BY INB.CreatedDate DESC;
END
GO
