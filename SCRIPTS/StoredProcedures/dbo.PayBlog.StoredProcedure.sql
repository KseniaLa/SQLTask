USE [Task]
GO
/****** Object:  StoredProcedure [dbo].[PayBlog]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ksenia
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[PayBlog] 
	@blogId int
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM Blogs WHERE Id = @blogId)
	BEGIN
		RAISERROR ('Blog not exists', 16, 1)
		RETURN
	END
	
	DECLARE @isPaid bit;
	SET @isPaid = (SELECT IsPaid FROM Blogs WHERE Id = @blogId);

	IF @isPaid = 1
	BEGIN
		PRINT 'Blog is paid';
		RETURN
	END

	BEGIN TRANSACTION
		UPDATE [dbo].[Blogs] SET [IsPaid] = 1 WHERE Id = @blogId;

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error updating blog', 16, 1)
				RETURN
			END

		UPDATE [dbo].[Articles] SET [IsBlocked] = 0 WHERE BlogId = @blogId;

		IF @@ERROR <> 0
			BEGIN
				ROLLBACK
				RAISERROR ('Error updating articles', 16, 1)
				RETURN
			END
	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
