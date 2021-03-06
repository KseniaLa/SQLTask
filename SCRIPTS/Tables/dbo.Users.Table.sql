USE [Task]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24.04.2019 12:34:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Login] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (1, N'KseniaLa', N'ksenia@test.com', N'Ksenia', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (2, N'olga111', N'olga@test.com', N'Olga', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (4, N'OOO', N'OOO@test.com', N'OOO', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (5, N'test111', N'test@test1.com', N'Test', N'12345678')
INSERT [dbo].[Users] ([Id], [Login], [Email], [Name], [Password]) VALUES (6, N'T', N'T', N'T', N'T')
SET IDENTITY_INSERT [dbo].[Users] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Email_UQ]    Script Date: 24.04.2019 12:34:45 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email_UQ] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Login_UQ]    Script Date: 24.04.2019 12:34:45 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Login_UQ] ON [dbo].[Users]
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
