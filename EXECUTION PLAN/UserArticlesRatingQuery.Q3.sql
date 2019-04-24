--initial
SELECT Users.Name, Users.Email, AVG(Rating) AS 'Avarage Rating' FROM Users
	LEFT JOIN Articles
	ON  Rating > 0 AND Articles.Id IN 
		(SELECT Id FROM Articles WHERE BlogId in 
		(SELECT Id FROM Blogs WHERE UserId = Users.Id)) 
		GROUP BY Users.Name, Users.Email;

-- optimized
SELECT Users.Name, Users.Email, AVG(Rating) AS 'Avarage Rating' FROM Users
	LEFT JOIN Blogs ON Blogs.UserId = Users.Id
	LEFT JOIN Articles
	ON  Rating > 0 AND Articles.BlogId = Blogs.Id
	GROUP BY Users.Name, Users.Email;

