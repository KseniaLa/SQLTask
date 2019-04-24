SELECT Blogs.Name AS 'Blog Name', Users.Name AS 'User Name', 
(SELECT COUNT(*) FROM Articles WHERE IsBlocked = 1 AND Articles.BlogId = Blogs.Id) AS 'Blocked Articles Count', 
(SELECT COUNT(*) FROM Articles WHERE IsBlocked = 0 AND Articles.BlogId = Blogs.Id) AS 'Opened Articles Count', 
COUNT(Articles.Id) AS 'Total Articles Count', AVG(CASE WHEN Articles.Rating > 0 THEN Articles.Rating ELSE NULL END) AS 'Blog Rating' FROM Blogs 
INNER JOIN Users ON Blogs.UserId = Users.Id
LEFT JOIN Articles ON Articles.BlogId = Blogs.Id
WHERE IsPaid = 0
GROUP BY Blogs.Name, Users.Name, Blogs.Id;