CREATE FUNCTION dbo.Remove_SpecialCharacters( @str VARCHAR(MAX))
RETURNS VARCHAR(MAX) AS
BEGIN
DECLARE @expres  VARCHAR(50) = '%[~,@,#,$,%,&,*,(,),.,!"]%'

WHILE PATINDEX( @expres, @str ) > 0
SET @str = Replace(REPLACE( @str, SUBSTRING( @str, PATINDEX( @expres, @str ), 1 ),' '),'-',' ')
RETURN @str
END
