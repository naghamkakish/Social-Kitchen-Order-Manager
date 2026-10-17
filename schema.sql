-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Social Kitchen & Order Manager Database Schema
-- Designed for home-based / Instagram food businesses

-- 1. Customers table to store buyer information and delivery contacts
CREATE TABLE "customers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "full_name" TEXT NOT NULL,
    "instagram_handle" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "delivery_address" TEXT NOT NULL
);

-- 2. Products table to store menu items and pricing
CREATE TABLE "products" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "price" NUMERIC NOT NULL,
    "is_available" BOOLEAN DEFAULT 1
);

-- 3. Orders table to track individual purchases placed via DMs or messages
CREATE TABLE "orders" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "customer_id" INTEGER NOT NULL,
    "order_date" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "fulfillment_date" DATE NOT NULL,
    "status" TEXT DEFAULT 'Pending',
    "total_amount" NUMERIC NOT NULL,
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id")
);

-- 4. Order Items table (Junction table) for the many-to-many relationship between orders and products
CREATE TABLE "order_items" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "custom_notes" TEXT,
    FOREIGN KEY ("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY ("product_id") REFERENCES "products"("id")
);

-- Indexes for performance optimization on frequent lookups
CREATE INDEX "idx_orders_fulfillment_date" ON "orders"("fulfillment_date");
CREATE INDEX "idx_orders_customer_id" ON "orders"("customer_id");

-- View for the daily baking and prep list
CREATE VIEW "daily_baking_list" AS
SELECT
    "p"."name" AS "product_name",
    SUM("oi"."quantity") AS "total_quantity_needed",
    "o"."fulfillment_date"
FROM "order_items" AS "oi"
JOIN "products" AS "p" ON "oi"."product_id" = "p"."id"
JOIN "orders" AS "o" ON "oi"."order_id" = "o"."id"
WHERE "o"."status" != 'Completed'
GROUP BY "p"."id", "o"."fulfillment_date";
