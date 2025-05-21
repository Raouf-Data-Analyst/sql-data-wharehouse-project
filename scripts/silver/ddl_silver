--CREATE Tables from CRM

--TSQL check

IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info


CREATE TABLE silver.crm_cust_info
(
    cst_id INT ,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50) ,
    cst_lastname NVARCHAR(50) ,
    cst_marital_status NVARCHAR(20),
    cst_gndr NVARCHAR(50),
    cst_create_date DATETIME 
);

--TSQL check 
IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL
	DROP TABLE silver.crm_prd_info

CREATE TABLE silver.crm_prd_info
(
    prd_id INT,
    prd_key NVARCHAR(50) ,
    prd_nm NVARCHAR(50) ,
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME ,
    prd_end_dt DATETIME

)

--TSQL check 
IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num NVARCHAR(50) ,
    sls_prd_key NVARCHAR(50) ,
    sls_cust_id INT ,
    sls_order_dt INT ,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT 
);


--CREATE Tables from ERP

--TSQL check 
IF OBJECT_ID('silver.erp_cust_az12','U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12

CREATE TABLE silver.erp_cust_az12
(
    cid NVARCHAR(50),
    bdate DATETIME,
    gen NVARCHAR(50)
);

IF OBJECT_ID('silver.erp_loc_a101','U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101

CREATE TABLE silver.erp_loc_a101
(
    cid NVARCHAR(50) ,
	cntry NVARCHAR(50)
);

IF OBJECT_ID('silver.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2

CREATE TABLE silver.erp_px_cat_g1v2
(
    id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);

--Load data from csv to tables 

-- Before laoding we do TRUNCATE ( Make table empty and than do the Fulllaod) 

--===========================================================
-- TRUNCATE and LOAD DATA INTO CRM TABLES
--===========================================================

-- TRUNCATE crm_cust_info
TRUNCATE TABLE silver.crm_cust_info;

-- BULK INSERT into crm_cust_info
-- Loads customer information data
BULK INSERT silver.crm_cust_info
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\cust_info.csv'
WITH 
(
    FIRSTROW = 2,   -- Skips the header row
    FIELDTERMINATOR = ',',   -- Specifies comma as the delimiter
    TABLOCK   -- Optimizes the bulk load
);


-- TRUNCATE crm_prd_info
TRUNCATE TABLE silver.crm_prd_info;

-- BULK INSERT into crm_prod_info
-- Loads product information data
BULK INSERT silver.crm_prd_info
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\prd_info.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


-- TRUNCATE crm_sales_details
TRUNCATE TABLE silver.crm_sales_details;

-- BULK INSERT into crm_sales_details
-- Loads sales details data
BULK INSERT silver.crm_sales_details
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\sales_details.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


--===========================================================
-- TRUNCATE and LOAD DATA INTO CRM TABLES
--===========================================================
-- TRUNCATE crm_sales_details
TRUNCATE TABLE silver.crm_sales_details;

-- BULK INSERT into crm_sales_details
BULK INSERT silver.crm_sales_details
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\sales_details.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


BULK INSERT silver.crm_sales_details
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_crm\sales_details.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

--===========================================================
-- TRUNCATE and LOAD DATA INTO ERP TABLES
--===========================================================

-- TRUNCATE erp_cust_az12
TRUNCATE TABLE silver.erp_cust_az12;

-- BULK INSERT into erp_cust_az12
BULK INSERT silver.erp_cust_az12
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_erp\cust_az12.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- TRUNCATE erp_loc_a101
TRUNCATE TABLE silver.erp_loc_a101;

-- BULK INSERT into erp_loc_a101
BULK INSERT silver.erp_loc_a101
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_erp\loc_a101.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- TRUNCATE erp_px_cat_g1v2
TRUNCATE TABLE silver.erp_px_cat_g1v2;

-- BULK INSERT into erp_px_cat_g1v2
BULK INSERT silver.erp_px_cat_g1v2
FROM 'D:\15 - Cours SQL\01- sql-data-warehouse -Project\datasets\source_erp\px_cat_g1v2.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
