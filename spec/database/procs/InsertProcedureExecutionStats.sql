CREATE PROCEDURE InsertProcedureExecutionStats
AS
BEGIN
    -- Clear the table before inserting new data (optional)
   --TRUNCATE TABLE tbl_ProcedureExecutionStats;

   --select * from tbl_ProcedureExecutionStats

    -- Insert the data from sys.dm_exec_procedure_stats into the table
    INSERT INTO tbl_ProcedureExecutionStats (DatabaseName, ProcedureName, ExecutionCount, LastExecutionTime)
    SELECT 
        DB_NAME(database_id) AS DatabaseName,
        OBJECT_NAME(object_id, database_id) AS ProcedureName,
        execution_count AS ExecutionCount,
        last_execution_time AS LastExecutionTime
    FROM 
        sys.dm_exec_procedure_stats
    WHERE 
        CONVERT(date, last_execution_time)  = CONVERT(date, GETDATE())
    ORDER BY 
        execution_count DESC;
END;