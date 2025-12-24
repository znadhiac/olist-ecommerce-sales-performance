-- ======================================================
-- OLIST E-COMMERCE SALES PERFORMANCE ANALYSIS
-- Schema Definition
-- Author: Zulfi Nadhia Cahyani
-- ======================================================

/*
This schema defines analytical tables derived from the Olist Brazilian e-commerce dataset.
The original Kaggle dataset contains 9 tables, including geolocation.
For this analysis, 8 tables were selected, focusing on core sales, customers, products, sellers, and payments,
while excluding geolocation due to its large size.
The tables are organized in a relational model to support join-based analysis for business performance and insights.
*/

-- ------------------------------
-- 1. Customers
-- ------------------------------
-- Stores unique customer information. This table acts as a dimension table for orders.

CREATE TABLE customers (
    customer_id CHAR(32) PRIMARY KEY,              -- Unique customer identifier (as Primary Key)
    customer_unique_id CHAR(32) NOT NULL,          -- Original customer ID (may have duplicates for the same person)
    customer_zip_code_prefix INT,                  -- Postal code
    customer_city VARCHAR(50),                     -- City name
    customer_state CHAR(2)                         -- State abbreviation
);

-- ------------------------------
-- 2. Orders
-- ------------------------------
-- Stores order-level information (fact table) and linked to customers.

CREATE TABLE orders (
    order_id CHAR(32) PRIMARY KEY,                -- Unique order identifier (as Primary Key)
    customer_id CHAR(32) NOT NULL,                -- Customer who placed the order (as Foreign Key)
    order_status VARCHAR(20),                     -- Current status of the order (delivered, canceled, etc.)
    order_purchase_timestamp DATETIME,            -- When the order was placed
    order_approved_at DATETIME,                   -- When payment was approved
    order_delivered_carrier_date DATETIME,        -- When order was shipped to carrier
    order_delivered_customer_date DATETIME,       -- When order was delivered to customer
    order_estimated_delivery_date DATETIME,       -- Estimated delivery date
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ------------------------------
-- 3. Order Items
-- ------------------------------
-- Stores item-level details for each order (fact table) and linked to products and sellers.

CREATE TABLE order_items (
    order_id CHAR(32) NOT NULL,                   -- Order identifier (as Foreign Key)
    order_item_id INT PRIMARY KEY,                -- Line item number within the order (as Primary Key)
    product_id CHAR(32) NOT NULL,                 -- Product sold (as Foreign Key)
    seller_id CHAR(32) NOT NULL,                  -- Seller fulfilling the item (as Foreign Key)
    shipping_limit_date DATETIME,                 -- Max shipping date allowed
    price DECIMAL(10,2),                          -- Item price
    freight_value DECIMAL(10,2),                  -- Shipping cost
    PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_orderitems_products FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT fk_orderitems_sellers FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);

-- ------------------------------
-- 4. Order Payments
-- ------------------------------
-- Stores payment information for each order (fact table).

CREATE TABLE order_payments (
    order_id CHAR(32) NOT NULL,                   -- Order identifier (as Foreign Key)
    payment_sequential INT NOT NULL,              -- Payment sequence number (multiple payments possible)
    payment_type VARCHAR(20),                     -- Payment method (credit card, boleto, etc.)
    payment_installments INT,                     -- Number of installments
    payment_value DECIMAL(10,2),                  -- Payment amount
    PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_payments_orders FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ------------------------------
-- 5. Order Reviews
-- ------------------------------
-- Stores customer reviews for each order (fact table).

CREATE TABLE order_reviews (
    review_id CHAR(32) PRIMARY KEY,             -- Review identifier (as Primary Key)
    order_id CHAR(32) NOT NULL,                 -- Associated order identifier (as Foreign Key)
    review_score INT,                           -- Review score (e.g., 1-5)
    review_creation_date DATETIME,              -- Date and time review was created
    review_answer_timestamp DATETIME,           -- Date and time review was answered
    PRIMARY KEY (review_id),
    CONSTRAINT fk_reviews_orders FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ------------------------------
-- 6. Products
-- ------------------------------
-- Stores product attributes and category information (dimension table).

CREATE TABLE products (
    product_id CHAR(32) PRIMARY KEY,             -- Unique product identifier (as Primary Key)
    product_category_name VARCHAR(50),           -- Product category (Portuguese)
    product_name_length INT,                     -- Length of product name
    product_description_length INT,              -- Length of product description
    product_photos_qty INT,                      -- Number of product photos
    product_weight_g INT,                        -- Product weight in grams
    product_length_cm INT,                       -- Product dimensions
    product_height_cm INT,
    product_width_cm INT
);

-- ------------------------------
-- 7. Sellers
-- ------------------------------
-- Stores seller information and location details (dimension table).

CREATE TABLE sellers (
    seller_id CHAR(32) PRIMARY KEY,             -- Unique seller identifier (as Primary Key)
    seller_zip_code_prefix INT,                 -- Postal code
    seller_city VARCHAR(50),                    -- City
    seller_state CHAR(2)                        -- State
);

-- -------------------------------
-- 8. Product Category Translation
-- -------------------------------
-- Maps product category names from Portuguese to English.

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(50) PRIMARY KEY,      -- Original Portuguese category (as Primary Key)
    product_category_name_english VARCHAR(50)           -- Translated English category
);