USE [Task]
GO
/****** Object:  Trigger [dbo].[UpdateAverageRating]    Script Date: 18.06.2019 0:19:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
ALTER TRIGGER [dbo].[UpdateAverageRating] 
   ON  [dbo].[Ratings] 
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Solution 1 - Join

	UPDATE Articles
	SET Rating = (SELECT AVG(CAST(Rating as float)) FROM Ratings WHERE Ratings.ArticleId = inserted.ArticleId)
	FROM inserted
	JOIN Articles
	ON inserted.ArticleId = Articles.Id;

	IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RETURN
		END

	-- Solution 2 - temp table

	--SELECT *
	--INTO   #Temp
	--FROM   inserted

	--DECLARE @artId bigint
	--DECLARE @rating float

	--WHILE EXISTS(SELECT * FROM #Temp)
	--BEGIN

	--	SELECT TOP 1 @artId = ArticleId FROM #Temp

	--	SET @rating = (SELECT AVG(CAST(Rating as float)) FROM Ratings WHERE ArticleId = @artId);
	--	UPDATE Articles SET Rating = @rating WHERE Id = @artId;

	--	IF @@ERROR <> 0
	--		BEGIN
	--			ROLLBACK
	--			RETURN
	--		END

	--	DELETE #Temp WHERE ArticleId = @artId

	--End

END
