SELECT Articles.Name AS 'Article Name', CONCAT(Blogs.Id, ' - ', Blogs.Name, ' - Created on ', Blogs.CreatedDate) AS 'Blog Info', 
	CONCAT(Users.Id, ' - ', Users.Name, ' - ', Users.Email) AS 'User Info', COUNT(Comments.Id) AS 'Comments Count' FROM Articles 
INNER JOIN Blogs ON Blogs.Id = BlogId
INNER JOIN Users ON Blogs.UserId = Users.Id
LEFT JOIN Comments ON Comments.ArticleId = Articles.Id
WHERE Articles.CreatedDate > '2018-01-01'
GROUP BY Articles.Name, Blogs.Name, Blogs.CreatedDate, Users.Name, Users.Id, Users.Email, Blogs.Id;