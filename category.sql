CREATE TABLE CATEGORIES (
  category_id INT GENERATED START 10 INCREMENT 10,
  category_name VARCHAR(64) NOT NULL,
  category_sum_product_price INT,
  category_sum_product_stock INT
);