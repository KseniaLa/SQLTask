SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE GetArticlesAfterDate 
	@date date 
AS
BEGIN
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
