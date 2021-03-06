USE [Task]
GO
/****** Object:  Table [dbo].[Articles]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlogId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[IsBlocked] [bit] NOT NULL,
	[Rating] [float] NOT NULL,
 CONSTRAINT [PK_BlogArticles] PRIMARY KEY CLUSTERED 
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
SET IDENTITY_INSERT [dbo].[Articles] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_BlogArticles]    Script Date: 24.04.2019 12:34:45 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_BlogArticles] ON [dbo].[Articles]
(
	[BlogId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articles]  WITH CHECK ADD  CONSTRAINT [FK_BlogArticles_Blogs] FOREIGN KEY([BlogId])
REFERENCES [dbo].[Blogs] ([Id])
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_BlogArticles_Blogs]
GO
