USE [Task]
GO
/****** Object:  View [dbo].[UserArticlesRaiting]    Script Date: 24.04.2019 12:34:45 ******/
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
