USE [master]
GO
/****** Object:  Database [Task]    Script Date: 13.06.2019 22:21:03 ******/
CREATE DATABASE [Task]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Task', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Task.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Task_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Task_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Task] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Task].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Task] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Task] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Task] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Task] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Task] SET ARITHABORT OFF 
GO
ALTER DATABASE [Task] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Task] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Task] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Task] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Task] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Task] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Task] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Task] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Task] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Task] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Task] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Task] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Task] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Task] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Task] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Task] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Task] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Task] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Task] SET  MULTI_USER 
GO
ALTER DATABASE [Task] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Task] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Task] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Task] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Task] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Task] SET QUERY_STORE = OFF
GO
USE [Task]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Task]
GO
/****** Object:  UserDefinedFunction [dbo].[ArticlesCountForUnpaidBlog]    Script Date: 13.06.2019 22:21:03 ******/
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
	@blogId bigint
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
/****** Object:  UserDefinedFunction [dbo].[GetUnpaidArticlesTotalCount]    Script Date: 13.06.2019 22:21:03 ******/
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
	@userId bigint
)
RETURNS int
AS
BEGIN
	DECLARE @result int = 0;
	DECLARE @blogId bigint;
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
/****** Object:  Table [dbo].[Blogs]    Script Date: 13.06.2019 22:21:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blogs](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[IsPaid] [bit] NOT NULL,
 CONSTRAINT [PK_Blogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articles]    Script Date: 13.06.2019 22:21:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[BlogId] [bigint] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[IsBlocked] [bit] NOT NULL,
	[Rating] [float] NULL,
 CONSTRAINT [PK_BlogArticles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 13.06.2019 22:21:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Login] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[UserArticlesRaiting]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UserArticlesRaiting]  
AS  
	SELECT Users.Name, Users.Email, AVG(Rating) AS 'Avarage Rating' FROM Users
	LEFT JOIN Articles
	ON  Rating > 0 AND Articles.Id IN 
		(SELECT Id FROM Articles WHERE BlogId in 
		(SELECT Id FROM Blogs WHERE UserId = Users.Id)) 
		GROUP BY Users.Name, Users.Email; 
GO
/****** Object:  View [dbo].[UnpaidBlogs]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UnpaidBlogs]  
AS  
	SELECT Blogs.Id, Blogs.Name AS 'Blog Name', Users.Id AS 'UserId', Users.Name AS 'User Name', 
	(SELECT COUNT(*) FROM Articles WHERE IsBlocked = 1 AND Articles.BlogId = Blogs.Id) AS 'Blocked Articles Count', 
	(SELECT COUNT(*) FROM Articles WHERE IsBlocked = 0 AND Articles.BlogId = Blogs.Id) AS 'Opened Articles Count', 
	COUNT(Articles.Id) AS 'Total Articles Count', AVG(CASE WHEN Articles.Rating > 0 THEN Articles.Rating ELSE NULL END) AS 'Blog Rating' FROM Blogs 
	INNER JOIN Users ON Blogs.UserId = Users.Id
	LEFT JOIN Articles ON Articles.BlogId = Blogs.Id
	WHERE IsPaid = 0
	GROUP BY Blogs.Id, Users.Id, Blogs.Name, Users.Name; 
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ArticleId] [bigint] NOT NULL,
	[CommentText] [nvarchar](max) NOT NULL,
	[CreatedDate] [date] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ratings]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ratings](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ArticleId] [bigint] NOT NULL,
	[Rating] [int] NOT NULL,
 CONSTRAINT [PK_Ratings_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Articles] ON 

INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (1, 2, N'Article1', CAST(N'2019-05-05' AS Date), 1, 5)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (3, 2, N'Article2', CAST(N'2019-06-04' AS Date), 1, 4.333333333333333)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (4, 5, N'ArticleBlog2', CAST(N'2019-06-05' AS Date), 0, 1)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (5, 5, N'ArticleBlod2-1', CAST(N'2019-01-01' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (6, 5, N'ArticleBlog2-2', CAST(N'2019-01-01' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (7, 5, N'ArticleBlog2-3', CAST(N'2019-01-01' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (8, 5, N'ArticleBlog2-4', CAST(N'2019-01-01' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (9, 3, N'MyArticle', CAST(N'2019-04-14' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (10, 5, N'ArticleA', CAST(N'2019-04-14' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (11, 2, N'ArticleB', CAST(N'2019-04-14' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (12, 5, N'ArtA', CAST(N'2019-04-14' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (13, 7, N'ArticleC', CAST(N'2019-04-14' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (14, 5, N'ArticleAAA', CAST(N'2019-04-14' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (15, 7, N'AAA', CAST(N'2019-04-14' AS Date), 0, 3.5)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (16, 11, N'TestArticle1', CAST(N'2019-04-23' AS Date), 0, 4)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (17, 11, N'TestArticle2', CAST(N'2019-04-23' AS Date), 0, 5)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (18, 11, N'ArticleTest3', CAST(N'2019-04-23' AS Date), 1, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (19, 12, N'HelloArticle1', CAST(N'2019-06-13' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (20, 12, N'HelloArticle2', CAST(N'2019-06-13' AS Date), 0, 0)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (21, 12, N'HelloArticle3', CAST(N'2019-06-13' AS Date), 0, 4.5)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (22, 12, N'Helloooooooo', CAST(N'2019-06-13' AS Date), 0, NULL)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (23, 12, N'Hello1', CAST(N'2019-06-13' AS Date), 0, NULL)
INSERT [dbo].[Articles] ([Id], [BlogId], [Name], [CreatedDate], [IsBlocked], [Rating]) VALUES (24, 12, N'Hello2', CAST(N'2019-06-13' AS Date), 0, NULL)
SET IDENTITY_INSERT [dbo].[Articles] OFF
SET IDENTITY_INSERT [dbo].[Blogs] ON 

INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (2, 1, N'Blog1', CAST(N'2019-05-05' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (3, 1, N'MYBlog', CAST(N'2019-03-31' AS Date), 1)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (5, 1, N'Blog2', CAST(N'2019-03-31' AS Date), 1)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (7, 2, N'Blog3', CAST(N'2019-03-31' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (10, 1, N'Blog11', CAST(N'2019-03-31' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (11, 5, N'TestBlog1', CAST(N'2019-04-23' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (12, 7, N'HelloBlog', CAST(N'2019-06-13' AS Date), 1)
SET IDENTITY_INSERT [dbo].[Blogs] OFF
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (1, 1, 1, N'hello', CAST(N'2019-04-14' AS Date))
INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (2, 1, 16, N'great', CAST(N'2019-04-24' AS Date))
INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (3, 2, 16, N'good', CAST(N'2019-04-24' AS Date))
INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (4, 1, 15, N'good', CAST(N'2019-04-24' AS Date))
SET IDENTITY_INSERT [dbo].[Comments] OFF
SET IDENTITY_INSERT [dbo].[Ratings] ON 

INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (1, 1, 3, 3)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (2, 2, 3, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (4, 4, 3, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (5, 1, 1, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (7, 4, 1, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (8, 1, 16, 4)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (9, 1, 17, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (10, 7, 21, 5)
INSERT [dbo].[Ratings] ([Id], [UserId], [ArticleId], [Rating]) VALUES (11, 1, 21, 4)
SET IDENTITY_INSERT [dbo].[Ratings] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (1, N'KseniaLa', N'ksenia@test.com', N'Ksenia', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (2, N'olga111', N'olga@test.com', N'Olga', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (4, N'OOO', N'OOO@test.com', N'OOO', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (5, N'test111', N'test@test1.com', N'Test', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (6, N'T', N'T', N'T', N'T')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (7, N'hello', N'hello', N'hello', N'hello')
SET IDENTITY_INSERT [dbo].[Users] OFF
/****** Object:  Index [IX_Date]    Script Date: 13.06.2019 22:21:04 ******/
CREATE NONCLUSTERED INDEX [IX_Date] ON [dbo].[Articles]
(
	[CreatedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Ratings_UQ]    Script Date: 13.06.2019 22:21:04 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Ratings_UQ] ON [dbo].[Ratings]
(
	[UserId] ASC,
	[ArticleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UQ_Email]    Script Date: 13.06.2019 22:21:04 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_Email] ON [dbo].[Users]
(
	[Id] ASC
)
INCLUDE ( 	[Email]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UQ_Login]    Script Date: 13.06.2019 22:21:04 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_Login] ON [dbo].[Users]
(
	[Id] ASC
)
INCLUDE ( 	[Login]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articles] ADD  CONSTRAINT [DF_Articles_Rating]  DEFAULT (NULL) FOR [Rating]
GO
ALTER TABLE [dbo].[Blogs] ADD  CONSTRAINT [DF_Blogs_IsPaid]  DEFAULT ((0)) FOR [IsPaid]
GO
ALTER TABLE [dbo].[Articles]  WITH CHECK ADD  CONSTRAINT [FK_BlogArticles_Blogs] FOREIGN KEY([BlogId])
REFERENCES [dbo].[Blogs] ([Id])
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_BlogArticles_Blogs]
GO
ALTER TABLE [dbo].[Blogs]  WITH CHECK ADD  CONSTRAINT [FK_Blogs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Blogs] CHECK CONSTRAINT [FK_Blogs_Users]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Articles] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Articles] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Articles]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Users]
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
/****** Object:  StoredProcedure [dbo].[AddArticle]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[AddArticle] 
	-- Add the parameters for the stored procedure here
	@blogId bigint, 
	@articleName nvarchar(50)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
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

	IF @isPaid = 1
	BEGIN
		BEGIN TRANSACTION
			INSERT INTO [dbo].[Articles]
				   ([BlogId]
				   ,[Name]
				   ,[CreatedDate]
				   ,[IsBlocked])
			 VALUES
				   (@blogId, @articleName, GETUTCDATE(), 0)

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
				,[IsBlocked])
			VALUES
				(@blogId, @articleName, GETUTCDATE(), @isBlocked)

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error adding article', 16, 1)
				RETURN
			END
	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
/****** Object:  StoredProcedure [dbo].[AddComment]    Script Date: 13.06.2019 22:21:04 ******/
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
	@userId bigint, 
	@articleId bigint,
	@commentText nvarchar(MAX)
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
			   (@userId, @articleId, @commentText, GETUTCDATE())

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding comment', 16, 1)
			RETURN
		END

	COMMIT

END
GO
/****** Object:  StoredProcedure [dbo].[AddRating]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[AddRating] 
	-- Add the parameters for the stored procedure here
	@userId bigint, 
	@articleId bigint,
	@rating int
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
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
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
/****** Object:  StoredProcedure [dbo].[CreateBlog]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ksenia
-- Create date: 2019-03-31
-- =============================================

CREATE PROCEDURE [dbo].[CreateBlog] 
	@name nvarchar(MAX), 
	@userId bigint
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION

		INSERT INTO [dbo].[Blogs]
				   ([UserId]
				   ,[Name]
				   ,[CreatedDate])
			 VALUES
				   (@userId, @name, GETUTCDATE())

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding blog', 16, 1)
			RETURN
		END

	COMMIT
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
/****** Object:  StoredProcedure [dbo].[CreateUser]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ksenia
-- Create date: 2019-03-31
-- =============================================

CREATE PROCEDURE [dbo].[CreateUser] 
	@name nvarchar(MAX), 
	@email nvarchar(MAX),
	@login nvarchar(MAX),
	@password nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	BEGIN TRANSACTION

		if @name IS NULL OR @email IS NULL OR @login IS NULL OR @password IS NULL
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding user. Required fields are empty', 16, 1)
			RETURN
		END

		INSERT INTO [dbo].[Users]
				   ([Login]
				   ,[Email]
				   ,[Name]
				   ,[Password])
			 VALUES
				   (@login, @email, @name, @password)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding user', 16, 1)
			RETURN
		END

	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticlesAfterDate]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetArticlesAfterDate] 
	@date date 
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT ON;

    SELECT Articles.Name AS 'Article Name', CONCAT(Blogs.Id, ' - ', Blogs.Name, ' - Created on ', Blogs.CreatedDate) AS 'Blog Info', 
		CONCAT(Users.Id, ' - ', Users.Name, ' - ', Users.Email) AS 'User Info', COUNT(Comments.Id) AS 'Comments Count' FROM Articles 
	INNER JOIN Blogs ON Blogs.Id = BlogId
	INNER JOIN Users ON Blogs.UserId = Users.Id
	LEFT JOIN Comments ON Comments.ArticleId = Articles.Id
		WHERE Articles.CreatedDate > @date
	GROUP BY Articles.Name, Blogs.Name, Blogs.CreatedDate, Users.Name, Users.Id, Users.Email, Blogs.Id;

END
GO
/****** Object:  StoredProcedure [dbo].[PayBlog]    Script Date: 13.06.2019 22:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[PayBlog] 
	@blogId bigint
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM Blogs WHERE Id = @blogId)
	BEGIN
		RAISERROR ('Blog not exists', 16, 1)
		RETURN
	END
	
	DECLARE @isPaid bit;
	SET @isPaid = (SELECT IsPaid FROM Blogs WHERE Id = @blogId);

	IF @isPaid = 1
	BEGIN
		PRINT 'Blog is paid';
		RETURN
	END

	BEGIN TRANSACTION
		UPDATE [dbo].[Blogs] SET [IsPaid] = 1 WHERE Id = @blogId;

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error updating blog', 16, 1)
				RETURN
			END

		UPDATE [dbo].[Articles] SET [IsBlocked] = 0 WHERE BlogId = @blogId;

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error updating articles', 16, 1)
				RETURN
			END
	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
/****** Object:  Trigger [dbo].[UpdateAverageRating]    Script Date: 13.06.2019 22:21:04 ******/
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

	DECLARE @articleId bigint;
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
/****** Object:  Trigger [dbo].[UpdateAverageRatingDelete]    Script Date: 13.06.2019 22:21:04 ******/
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
USE [master]
GO
ALTER DATABASE [Task] SET  READ_WRITE 
GO
