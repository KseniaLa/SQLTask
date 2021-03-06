USE [Task]
GO
/****** Object:  Table [dbo].[Blogs]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[IsPaid] [bit] NOT NULL,
 CONSTRAINT [PK_Blogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Blogs] ON 

INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (2, 1, N'Blog1', CAST(N'2019-05-05' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (3, 1, N'MYBlog', CAST(N'2019-03-31' AS Date), 1)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (5, 1, N'Blog2', CAST(N'2019-03-31' AS Date), 1)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (7, 2, N'Blog3', CAST(N'2019-03-31' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (10, 1, N'Blog11', CAST(N'2019-03-31' AS Date), 0)
INSERT [dbo].[Blogs] ([Id], [UserId], [Name], [CreatedDate], [IsPaid]) VALUES (11, 5, N'TestBlog1', CAST(N'2019-04-23' AS Date), 0)
SET IDENTITY_INSERT [dbo].[Blogs] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserBlog_UQ]    Script Date: 24.04.2019 12:34:45 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserBlog_UQ] ON [dbo].[Blogs]
(
	[UserId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Blogs]  WITH CHECK ADD  CONSTRAINT [FK_Blogs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Blogs] CHECK CONSTRAINT [FK_Blogs_Users]
GO
