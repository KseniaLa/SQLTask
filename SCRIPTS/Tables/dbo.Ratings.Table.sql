USE [Task]
GO
/****** Object:  Table [dbo].[Ratings]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ratings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[Rating] [int] NOT NULL,
 CONSTRAINT [PK_Ratings_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Ratings] ON 

INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (1, 1, 3, 3)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (2, 2, 3, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (4, 4, 3, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (5, 1, 1, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (7, 4, 1, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (8, 1, 16, 4)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (9, 1, 17, 5)
SET IDENTITY_INSERT [dbo].[Ratings] OFF
/****** Object:  Index [IX_Ratings_UQ]    Script Date: 24.04.2019 12:34:45 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Ratings_UQ] ON [dbo].[Ratings]
(
	[UserId] ASC,
	[ArticleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ratings]  WITH CHECK ADD  CONSTRAINT [FK_Ratings_Articles] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Articles] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Ratings] CHECK CONSTRAINT [FK_Ratings_Articles]
GO
ALTER TABLE [dbo].[Ratings]  WITH CHECK ADD  CONSTRAINT [FK_Ratings_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Ratings] CHECK CONSTRAINT [FK_Ratings_Users]
GO
ALTER TABLE [dbo].[Ratings]  WITH CHECK ADD  CONSTRAINT [CK_Ratings] CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[Ratings] CHECK CONSTRAINT [CK_Ratings]
GO
/****** Object:  Trigger [dbo].[UpdateAverageRating]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[UpdateAverageRating] 
   ON  [dbo].[Ratings] 
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
ALTER TABLE [dbo].[Ratings] ENABLE TRIGGER [UpdateAverageRating]
GO
/****** Object:  Trigger [dbo].[UpdateAverageRatingDelete]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[UpdateAverageRatingDelete] 
   ON  [dbo].[Ratings] 
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
ALTER TABLE [dbo].[Ratings] ENABLE TRIGGER [UpdateAverageRatingDelete]
GO
