CREATE   PROCEDURE dbo.sp_GET_WebAPI_CheckList_GetAssignmentScreenData
(
    @UserId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- 1) User এর Active Program list নাও (multiple)
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#UserPrograms') IS NOT NULL DROP TABLE #UserPrograms;

    SELECT DISTINCT CAST(A.ProgramId AS INT) AS ProgramId
    INTO #UserPrograms
    FROM dbo.tbl_User_ProgrameDetail A WITH (NOLOCK)
    WHERE A.UserId = @UserId
      AND ISNULL(A.IsActive, 1) = 1;   -- আপনার টেবিলে IsActive না থাকলে এই লাইন remove করবেন

    IF NOT EXISTS (SELECT 1 FROM #UserPrograms)
    BEGIN
        RAISERROR('No active ProgramId found for this user.', 16, 1);
        RETURN;
    END

    ------------------------------------------------------------
    -- 2) ঐ Program গুলোর Active Assignment + SetIds
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#AssignedSets') IS NOT NULL DROP TABLE #AssignedSets;

    SELECT DISTINCT A.AssignmentId, A.SetId, A.ProgramId
    INTO #AssignedSets
    FROM dbo.tbl_CheckList_Assignment A WITH (NOLOCK)
    INNER JOIN #UserPrograms UP
        ON UP.ProgramId = CAST(A.ProgramId AS INT)
    WHERE A.IsActive = 1;

    ------------------------------------------------------------
    -- Resultset-1: Program + Assignment + Set
    ------------------------------------------------------------
    SELECT
        ASG.ProgramId,
        ASG.AssignmentId,
        S.SetId,
        S.SetCode,
        S.SetName
    FROM #AssignedSets ASG
    INNER JOIN dbo.tbl_CheckList_Set S WITH (NOLOCK)
        ON S.SetId = ASG.SetId
       AND S.IsActive = 1
    ORDER BY ASG.ProgramId, S.SetId;

    ------------------------------------------------------------
    -- Resultset-2: Set Questions + Question Info
    ------------------------------------------------------------
    SELECT
        ASG.ProgramId,
        SQ.SetQuestionId,
        SQ.SetId,
        SQ.QuestionId,
        SQ.SortOrder,
        QB.QuestionTitle,
        QB.QuestionDescription,
        QB.AnswerGroupType,
        QB.QuestionTitle_Norm
    FROM dbo.tbl_CheckList_SetQuestion SQ WITH (NOLOCK)
    INNER JOIN #AssignedSets ASG
        ON ASG.SetId = SQ.SetId
    INNER JOIN dbo.tbl_CheckList_QuestionBank QB WITH (NOLOCK)
        ON QB.QuestionId = SQ.QuestionId
       AND QB.IsActive = 1
    WHERE SQ.IsActive = 1
    ORDER BY ASG.ProgramId, SQ.SetId, SQ.SortOrder, SQ.SetQuestionId;

    ------------------------------------------------------------
    -- Resultset-3: Options (সব selected Question এর জন্য)
    ------------------------------------------------------------
    ;WITH Q AS
    (
        SELECT DISTINCT SQ.QuestionId
        FROM dbo.tbl_CheckList_SetQuestion SQ WITH (NOLOCK)
        INNER JOIN #AssignedSets ASG
            ON ASG.SetId = SQ.SetId
        WHERE SQ.IsActive = 1
    )
    SELECT
        O.QuestionOptionId,
        O.QuestionId,
        O.OptionText,
        O.SortOrder,
        O.IsCorrectAnswer
    FROM dbo.tbl_CheckList_QuestionBankOption O WITH (NOLOCK)
    INNER JOIN Q
        ON Q.QuestionId = O.QuestionId
    WHERE O.IsActive = 1
    ORDER BY O.QuestionId, O.SortOrder, O.QuestionOptionId;

END
