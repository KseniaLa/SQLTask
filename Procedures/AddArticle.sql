SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE AddArticle 
	-- Add the parameters for the stored procedure here
	@blogId int, 
	@articleName nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @totalArticles int = 10;
	DECLARE @articlesInUnpaidBlog int = 5;

    IF NOT EXISTS (SELECT * FROM Blogs WHERE Id = @blogId)
	BEGIN
		RAISERROR ('Blog not exists', 16, 1)
		RETURN
	END

	DECLARE @isPaid int;
	DECLARE @userId int;

	SELECT @isPaid = IsPaid, @userId = UserId FROM Blogs WHERE Id = @blogId;
	--SET @isPaid = (SELECT IsPaid FROM Blogs WHERE Id = @blogId);

	IF @isPaid = 1
	BEGIN
		BEGIN TRANSACTION
			INSERT INTO [dbo].[Articles]
				   ([BlogId]
				   ,[Name]
				   ,[CreatedDate]
				   ,[IsBlocked]
				   ,[Rating])
			 VALUES
				   (@blogId, @articleName, GETDATE(), 0, 0)

			IF @@ERROR <> 0
				BEGIN
					ROLLBACK
					RAISERROR ('Error adding article', 16, 1)
					RETURN
				END
		COMMIT
		RETURN
	END

	DECLARE @totalArticlesCount int = dbo.GetUnpaidArticlesTotalCount(@userId);
	IF @totalArticlesCount >= @totalArticles
		BEGIN
			RAISERROR ('Error adding article. Too many unpaid articles', 16, 1)
			RETURN
		END

	DECLARE @isBlocked bit;

	IF dbo.ArticlesCountForUnpaidBlog(@blogId) >= @articlesInUnpaidBlog
		SET @isBlocked = 1
	ELSE
		SET @isBlocked = 0

	BEGIN TRANSACTION
		INSERT INTO [dbo].[Articles]
				([BlogId]
				,[Name]
				,[CreatedDate]
				,[IsBlocked]
				,[Rating])
			VALUES
				(@blogId, @articleName, GETDATE(), @isBlocked, 0)

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error adding article', 16, 1)
				RETURN
			END
	COMMIT

END
GO
