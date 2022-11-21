-- CATEGORIES
INSERT INTO CATEGORIES (category_name)
VALUES ('iphone');

INSERT INTO CATEGORIES (category_name)
VALUES ('iphone +');

-- PRODUITS
INSERT INTO PRODUITS (produit_name, produit_category, produit_price, produit_stock)
VALUES ('iphone 13', 1, 958, 10);

INSERT INTO PRODUITS (produit_name, produit_category, produit_price, produit_stock)
VALUES ('iphone X', 1, 1050, 250);

INSERT INTO PRODUITS (produit_name, produit_category, produit_price, produit_stock)
VALUES ('iphone 13', 2, 2000, 500);

COMMIT WORK;