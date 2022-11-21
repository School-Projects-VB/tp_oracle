CREATE TABLE CATEGORIES (
  category_id NUMERIC(8) GENERATED ALWAYS AS IDENTITY (START WITH 10 INCREMENT BY 10) NOT NULL
    PRIMARY KEY,
  category_name VARCHAR(64) NOT NULL,
  category_sum_product_price INT,
  category_sum_product_stock INT
);