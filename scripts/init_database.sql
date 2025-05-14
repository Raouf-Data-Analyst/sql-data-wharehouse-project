/* This Script create a new database 'Datawarehouse' after cheking if it already exist ! Proceed with caution */ 

USE master;
GO 

-- DROP and  recreate the 'Datawarehouse' database 

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')

BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END ; 
GO 

--Create Database 
CREATE DATABASE Datawarehouse;
GO
USE Datawarehouse
GO
-- Create Shemas 
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
