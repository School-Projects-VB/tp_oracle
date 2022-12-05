CREATE VIEW VCategory AS (
    SELECT C.category_id,
           C.category_name,
           SUM(P.produit_price) AS category_sum_product_price,
           SUM(P.produit_stock) AS category_sum_product_stock
    FROM CATEGORIES C
    INNER JOIN PRODUITS P on C.CATEGORY_ID = P.PRODUIT_CATEGORY
    GROUP BY C.CATEGORY_ID, C.CATEGORY_NAME
);

CREATE VIEW VCategoryPourcents AS (
    SELECT category_id,
           category_name,
           category_sum_product_price,
           100*category_sum_product_price/(SELECT SUM(category_sum_product_price) FROM VCategory) AS Pourcentage
    FROM VCATEGORY
    GROUP BY category_id, category_name, category_sum_product_price
);

CREATE OR REPLACE VIEW V_PRODUIT AS
    SELECT * FROM PRODUITS;

CREATE OR REPLACE VIEW V_CATEGORY AS
    SELECT C.CATEGORY_NAME, P.PRODUIT_NAME FROM CATEGORIES C
    INNER JOIN PRODUITS P ON P.PRODUIT_CATEGORY = C.CATEGORY_ID
    GROUP BY C.CATEGORY_NAME, P.PRODUIT_NAME

CREATE MATERIALIZED VIEW VM_PRODUIT
TABLESPACE TBS_CLIENT
BUILD IMMEDIATE
REFRESH FORCE
ON COMMIT
AS SELECT * FROM PRODUITS;