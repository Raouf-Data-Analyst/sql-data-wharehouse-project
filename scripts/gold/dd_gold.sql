-- Supprimer la vue gold.dim_customers si elle existe déjà
GO
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL 
	DROP VIEW gold.dim_customers
GO

-- Créer la vue gold.dim_customers à partir des données CRM et ERP
CREATE VIEW gold.dim_customers AS 
SELECT 
	-- Clé substitut générée pour la dimension client
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	
	-- Identifiants et informations personnelles
	ci.cst_id AS customer_id, -- ID client (CRM)
	ci.cst_key AS customer_number, -- Clé métier client
	ci.cst_firstname AS fisrt_name, -- Prénom du client (⚠️ à corriger en 'first_name')
	ci.cst_lastname AS last_name, -- Nom du client
	
	-- Localisation issue de l’ERP
	la.cntry AS country,
	
	-- Statut marital
	ci.cst_marital_status AS martial_status, -- (⚠️ à corriger en 'marital_status')

	-- Sexe du client : priorité aux données CRM, sinon ERP, sinon 'n/a'
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master for gender info
		 ELSE COALESCE(ca.gen ,'n/a')
	END AS gender,
	
	-- Date de naissance (ERP)
	ca.bdate AS birthday,

	-- Date de création du client (CRM)
	ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci
-- Jointure avec ERP pour enrichir les infos personnelles (genre, date de naissance)
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
-- Jointure avec ERP pour localisation
LEFT JOIN silver.erp_loc_A101 la ON ci.cst_key = la.cid
GO

-- Supprimer la vue gold.dim_products si elle existe déjà
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products 
GO 

-- Créer la vue gold.dim_products à partir des infos produit CRM enrichies par l’ERP
CREATE VIEW gold.dim_products AS 
SELECT 
	-- Clé substitut générée pour la dimension produit
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

	-- Identifiants produit
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,

	-- Détails produit
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,

	-- Catégorisation (ERP)
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,

	-- Coût et autres attributs
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn 
-- Jointure avec la table de catégories de l’ERP
LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
-- Ne conserver que les produits actifs (non clôturés)
WHERE pn.prd_end_dt IS NULL -- Filter all historical data
GO

-- Supprimer la vue gold.fact_sales si elle existe déjà
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

-- Créer la vue gold.fact_sales, table de faits des ventes
CREATE VIEW gold.fact_sales AS
SELECT
    -- Numéro de commande
    sd.sls_ord_num  AS order_number,

    -- Clés étrangères vers les dimensions produit et client
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,

    -- Dates de commande, d’expédition, d’échéance
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,

    -- Détails financiers
    sd.sls_sales    AS sales_amount, -- Montant total
    sd.sls_quantity AS quantity,     -- Quantité
    sd.sls_price    AS price         -- Prix unitaire

FROM silver.crm_sales_details sd
-- Jointure avec la dimension produit
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
-- Jointure avec la dimension client
LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id;
GO
