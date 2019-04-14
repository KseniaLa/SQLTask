SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER dbo.UpdateAverageRating 
   ON  dbo.Ratings 
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @articleId int;
	DECLARE @rating float;
	
	DECLARE articles CURSOR
	FOR SELECT ArticleId FROM inserted;

	OPEN articles;

	FETCH NEXT FROM articles INTO @articleId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @rating = (SELECT AVG(Rating) FROM Ratings WHERE ArticleId = @articleId);
		UPDATE Articles SET Rating = @rating WHERE Id = @articleId
		FETCH NEXT FROM articles INTO @articleId;
	END

	CLOSE articles;
	DEALLOCATE articles;

END
GO
