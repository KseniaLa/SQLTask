SELECT Users.Name, Users.Email, AVG(Rating) AS 'Avarage Rating' FROM Users
	LEFT JOIN Articles
	ON  Rating > 0 AND Articles.Id IN 
		(SELECT Id FROM Articles WHERE BlogId in 
		(SELECT Id FROM Blogs WHERE UserId = Users.Id)) 
		GROUP BY Users.Name, Users.Email;

SELECT Users.Name, Users.Email, AVG(Rating) AS 'Avarage Rating' FROM Users
	LEFT JOIN Articles
	ON  Rating > 0 AND Articles.Id IN 
	(SELECT Articles.Id FROM Articles INNER JOIN Blogs ON BlogId = Blogs.Id WHERE UserId = Users.Id)
		GROUP BY Users.Name, Users.Email;

