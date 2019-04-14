SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE AddRating 
	-- Add the parameters for the stored procedure here
	@userId int, 
	@articleId int,
	@rating int
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRANSACTION

		IF EXISTS(SELECT * FROM Ratings WHERE UserId = @userId AND ArticleId = @articleId)
			UPDATE [dbo].[Ratings]
			SET [Rating] = @rating
			WHERE UserId = @userId AND ArticleId = @articleId;
		ELSE
			INSERT INTO [dbo].[Ratings]
			   ([UserId], [ArticleId], [Rating])
			VALUES
			   (@userId, @articleId, @rating)

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error adding rating', 16, 1)
				RETURN
			END

	COMMIT

END
GO
