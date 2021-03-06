USE [Task]
GO
/****** Object:  StoredProcedure [dbo].[CreateBlog]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ksenia
-- Create date: 2019-03-31
-- =============================================

CREATE PROCEDURE [dbo].[CreateBlog] 
	@name nvarchar(50) = 'undefined', 
	@isPaid bit = 0,
	@userId int
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION

		INSERT INTO [dbo].[Blogs]
				   ([UserId]
				   ,[Name]
				   ,[CreatedDate]
				   ,[IsPaid])
			 VALUES
				   (@userId, @name, GETDATE(), @isPaid)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding blog', 16, 1)
			RETURN
		END

	COMMIT
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
