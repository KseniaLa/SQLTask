USE [Task]
GO
/****** Object:  StoredProcedure [dbo].[AddComment]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[AddComment] 
	@userId int, 
	@articleId int,
	@commentText nvarchar(50)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT ON;

	IF @commentText = ''
		BEGIN
			RAISERROR ('Error adding comment. Empty comment text.', 16, 1)
			RETURN
		END

	BEGIN TRANSACTION

		INSERT INTO [dbo].[Comments]
			   ([UserId]
			   ,[ArticleId]
			   ,[CommentText]
			   ,[CreatedDate])
		VALUES
			   (@userId, @articleId, @commentText, GETDATE())

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding comment', 16, 1)
			RETURN
		END

	COMMIT

END
GO
