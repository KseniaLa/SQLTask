USE [Task]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[CommentText] [nvarchar](max) NOT NULL,
	[CreatedDate] [date] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (1, 1, 1, N'hello', CAST(N'2019-04-14' AS Date))
INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (2, 1, 16, N'great', CAST(N'2019-04-24' AS Date))
INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (3, 2, 16, N'good', CAST(N'2019-04-24' AS Date))
INSERT [dbo].[Comments] ([Id], [UserId], [ArticleId], [CommentText], [CreatedDate]) VALUES (4, 1, 15, N'good', CAST(N'2019-04-24' AS Date))
SET IDENTITY_INSERT [dbo].[Comments] OFF
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
