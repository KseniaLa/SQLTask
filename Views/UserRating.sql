USE Task;   
GO  
CREATE VIEW dbo.UserArticleRaiting  
AS  
	SELECT Users.Name, AVG(Rating) AS 'Avarage Rating' FROM Users, Articles 
	WHERE Rating > 0 AND Articles.Id IN 
	(SELECT Id FROM Articles WHERE BlogId in 
	(SELECT Id FROM Blogs WHERE UserId = Users.Id)) 
	GROUP BY Users.Name; 
GO  