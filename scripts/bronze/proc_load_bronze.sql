--===========================================================
-- STORED PROCEDURE: Load Data into Bronze Layer with Duration Tracking and Error Handling
--===========================================================
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
    DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME   
    BEGIN TRY

        PRINT 'Starting data load process for Bronze Layer...';
		SET @batch_start_time = GETDATE()
        --===========================================================
        -- CREATE Tables from CRM
        --===========================================================

        PRINT 'Creating CRM tables...';

        -- Check and Drop crm_cust_info
        IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
        BEGIN
            PRINT 'Dropping existing table: bronze.crm_cust_info';
            DROP TABLE bronze.crm_cust_info;
        END

        PRINT 'Creating table: bronze.crm_cust_info';
        CREATE TABLE bronze.crm_cust_info
        (
            cst_id INT,
            cst_key NVARCHAR(50),
            cst_firstname NVARCHAR(50),
            cst_lastname NVARCHAR(50),
            cst_marital_status NVARCHAR(20),
            cst_gndr NVARCHAR(50),
            cst_create_date DATETIME 
        );

        -- TRUNCATE and BULK INSERT into crm_cust_info
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT 'Truncating and loading data into bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load Duration for crm_cust_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds';

        -- Repeat for crm_prd_info
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT 'Truncating and loading data into bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load Duration for crm_prd_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds';

        -- Repeat for crm_sales_details
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT 'Truncating and loading data into bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load Duration for crm_sales_details: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds';

        --===========================================================
        -- TRUNCATE and LOAD DATA INTO ERP TABLES
        --===========================================================

        -- Repeat for erp_cust_az12
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT 'Truncating and loading data into bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_erp\cust_az12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load Duration for erp_cust_az12: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds';

        -- Repeat for erp_loc_a101
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT 'Truncating and loading data into bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_erp\loc_a101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load Duration for erp_loc_a101: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds';

        -- Repeat for erp_px_cat_g1v2
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT 'Truncating and loading data into bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        PRINT 'Load Duration for erp_px_cat_g1v2: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds';

        
		SET @batch_end_time = GETDATE()
		PRINT '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		PRINT 'Data load process for Bronze Layer completed successfully!';
		PRINT '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
        PRINT 'Total Batch Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' Seconds';
    END TRY
    BEGIN CATCH
        PRINT '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
        PRINT 'ERROR OCCURRED DURING load process for Bronze Layer'
        PRINT '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
    END CATCH

END;
