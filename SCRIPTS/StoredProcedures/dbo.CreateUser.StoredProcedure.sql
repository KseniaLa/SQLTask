USE [Task]
GO
/****** Object:  StoredProcedure [dbo].[CreateUser]    Script Date: 24.04.2019 12:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ksenia
-- Create date: 2019-03-31
-- =============================================

CREATE PROCEDURE [dbo].[CreateUser] 
	@name nvarchar(50) = 'undefined', 
	@email nvarchar(50) = 'undefined',
	@login nvarchar(50) = 'undefined',
	@password nvarchar(50) = 'undefined'
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	BEGIN TRANSACTION
		INSERT INTO [dbo].[Users]
				   ([Login]
				   ,[Email]
				   ,[Name]
				   ,[Password])
			 VALUES
				   (@login, @email, @name, @password)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK
			RAISERROR ('Error adding user', 16, 1)
			RETURN
		END

	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO
