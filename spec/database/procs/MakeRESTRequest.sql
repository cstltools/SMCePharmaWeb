CREATE PROCEDURE [dbo].[MakeRESTRequest]
 @StoNo varchar(50),
 @RcvBy int

AS


BEGIN



		


    DECLARE @Object int;
    DECLARE @ResponseText varchar(MAX);

    -- Create an HTTP object
    EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;

    -- Specify the API endpoint
    DECLARE @url varchar(200) = 'https://smcsap.smc-bd.org:42223/RESTAdapter/eph_sto';

    -- Open the connection to the endpoint
    EXEC sp_OAMethod @Object, 'open', NULL, 'POST', @url, false, 'smc_epharma', 'Eph@rma2023#';

    -- Set request headers
    EXEC sp_OAMethod @Object, 'setRequestHeader', NULL, 'Content-Type', 'application/json';

    -- Set the request body
    DECLARE @jsonRequest varchar(MAX) = '{"StoNo":"' + @StoNo + '","PostingDate":"' + CONVERT(varchar, GETDATE(), 120) + '","DocDate":"' + format( GETDATE(),'dd.MM.yyyy') + '"}';

	--DECLARE @jsonRequest = '{"StoNo":"' + @StoNo + '","PostingDate":"' + CONVERT(, GETDATE(), 120) + '"}';


    -- Send the request
    EXEC sp_OAMethod @Object, 'send', NULL, @jsonRequest;

    -- Get the response text
    EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT;

    -- Do something with the response (e.g., print it)
    PRINT @ResponseText;

    -- Clean up
    EXEC sp_OADestroy @Object;

		UPDATE  SAP_API_Data..tblSAP_StockMovementMaster SET  truck_no='Ok' , ReceiveBy=@RcvBy 
				WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM( @StoNo)))  
END;
