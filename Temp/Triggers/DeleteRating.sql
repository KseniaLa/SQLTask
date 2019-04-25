SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER dbo.UpdateAverageRatingDelete 
   ON  dbo.Ratings 
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

    DECLARE @articleId int;
	DECLARE @rating float;
	
	DECLARE articles CURSOR
	FOR SELECT ArticleId FROM deleted;

	OPEN articles;

	FETCH NEXT FROM articles INTO @articleId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @rating = (SELECT AVG(CAST(Rating as float)) FROM Ratings WHERE ArticleId = @articleId);
		UPDATE Articles SET Rating = @rating WHERE Id = @articleId;

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RETURN
			END

		FETCH NEXT FROM articles INTO @articleId;
	END

	CLOSE articles;
	DEALLOCATE articles;


END
GO
