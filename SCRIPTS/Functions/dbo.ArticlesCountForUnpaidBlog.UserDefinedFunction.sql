USE [Task]
GO
/****** Object:  UserDefinedFunction [dbo].[ArticlesCountForUnpaidBlog]    Script Date: 24.04.2019 12:34:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[ArticlesCountForUnpaidBlog] 
(
	@blogId int
)
RETURNS int
AS
BEGIN

	DECLARE @result int;
	DECLARE @isPaid int;

	IF NOT EXISTS (SELECT IsPaid FROM Blogs WHERE Id = @blogId)
		RETURN NULL;

	SET @isPaid = (SELECT TOP 1 IsPaid FROM Blogs WHERE Id = @blogId);

	IF @isPaid = 1
		RETURN NULL;

	SET @result = (SELECT COUNT(*) FROM Articles WHERE BlogId = @blogId);

	RETURN @result

END
GO
