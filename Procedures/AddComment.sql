SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE AddComment 
	@userId int, 
	@articleId int,
	@commentText nvarchar(50)
AS
BEGIN
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
