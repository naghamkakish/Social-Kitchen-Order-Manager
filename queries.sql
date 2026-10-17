-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- Typical queries run on the Social Kitchen database



-- 1. Insert a new customer who just placed an order via Instagram DM
INSERT INTO "customers" ("full_name", "instagram_handle", "phone_number", "delivery_address")
VALUES ('Sara Zaid', '@sara_zz', '+962791234567', 'Amman, Jubaiha');

-- 2. Insert a new order for that customer
INSERT INTO "orders" ("customer_id", "fulfillment_date", "status", "total_amount")
VALUES (1, '2026-06-15', 'Pending', 25.00);

-- 3. Add items to that specific order
INSERT INTO "order_items" ("order_id", "product_id", "quantity", "custom_notes")
VALUES (1, 2, 2, 'Extra chocolate drizzle please');

-- SELECT STATEMENT 1: View all available products on the menu
SELECT "id", "name", "category", "price"
FROM "products"
WHERE "is_available" = 1;

-- SELECT STATEMENT 2: View a specific customer's order history and details
SELECT
    "o"."id" AS "order_id",
    "o"."fulfillment_date",
    "o"."status",
    "p"."name" AS "product_name",
    "oi"."quantity",
    "oi"."custom_notes"
FROM "orders" AS "o"
JOIN "order_items" AS "oi" ON "o"."id" = "oi"."order_id"
JOIN "products" AS "p" ON "oi"."product_id" = "p"."id"
WHERE "o"."customer_id" = 1;

-- SELECT STATEMENT 3: Query the daily baking list view for active orders
SELECT *
FROM "daily_baking_list";

-- 4. Update an order status when it is out for delivery
UPDATE "orders"
SET "status" = 'Out for Delivery'
WHERE "id" = 1;

-- 5. Remove an item from an order if the customer changes their mind
DELETE FROM "order_items"
WHERE "order_id" = 1 AND "product_id" = 2;
