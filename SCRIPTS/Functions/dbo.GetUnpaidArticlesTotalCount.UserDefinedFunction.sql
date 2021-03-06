USE [Task]
GO
/****** Object:  UserDefinedFunction [dbo].[GetUnpaidArticlesTotalCount]    Script Date: 24.04.2019 12:34:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[GetUnpaidArticlesTotalCount] 
(
	@userId int
)
RETURNS int
AS
BEGIN
	DECLARE @result int = 0;
	DECLARE @blogId int;
	DECLARE @artCnt int;

	IF NOT EXISTS (SELECT * FROM Users WHERE Id = @userId)
		RETURN NULL;

	DECLARE user_blogs CURSOR
	FOR SELECT Id FROM Blogs WHERE UserId = @userId AND IsPaid = 0;

	OPEN user_blogs;

	FETCH NEXT FROM user_blogs INTO @blogId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @artCnt = (SELECT COUNT(*) FROM Articles WHERE BlogId = @blogId);
		SET @result = @result + @artCnt;
		FETCH NEXT FROM user_blogs INTO @blogId;
	END

	CLOSE user_blogs;
	DEALLOCATE user_blogs;

	RETURN @result

END
GO
