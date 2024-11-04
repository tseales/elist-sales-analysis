-- Request 1: What were the order counts, sales, and AOV for Macbooks sold in North America for each quarter across all years?

-- Join orders, customers, and geo_lookup to match orders with regions
-- Filter for NA region & Macbooks
-- EXTRACT() for years & relative quarters
-- Round averages to two decimal places

SELECT
  EXTRACT(YEAR FROM orders.purchase_ts) AS Year
  , EXTRACT(QUARTER FROM orders.purchase_ts) AS Quarter
  , COUNT(DISTINCT orders.id) AS Order_Counts
  , ROUND(SUM(orders.usd_price),2) AS Sales
  , ROUND(AVG(orders.usd_price),2) AS AOV
FROM
  core.orders JOIN core.customers ON orders.customer_id = customers.id JOIN core.geo_lookup geo ON customers.country_code = geo.country_code
WHERE
  orders.product_name = 'Macbook Air Laptop' AND 
  geo.region = 'NA'
GROUP BY 1, 2
ORDER BY 1 DESC, 2 ASC;
--Findings: Averaging the resulting orders & sales for trends results in, per quarter, an (1) avg. 98 units sold & (2) avg. $155k in sales


-- Request 2: Of people who bought Apple products, which 5 customers bring the most value? 
SELECT
  customer_id
  , AVG(usd_price) AS aov
  , ROW_NUMBER() OVER (ORDER BY AVG(usd_price) DESC) AS customer_ranking
FROM
  core.orders LEFT JOIN core.customers ON orders.customer_id = customers.id
WHERE 
  product_name LIKE 'Apple%' OR product_name LIKE 'Macbook%' 
GROUP BY 1
QUALIFY customer_ranking <= 5;
--Findings: Customers listed have the highest AOV


-- Request 3: Within each purchase platform, what are the top two marketing channels that bring the highest value?

-- Need purchase platform dichotomy
-- Rank marketing channels based on purchase_platform split
-- Order By AOV DESC
SELECT
  orders.purchase_platform
  , customers.marketing_channel
  , ROUND(AVG(orders.usd_price),2) AS aov
  , DENSE_RANK() OVER (PARTITION BY purchase_platform ORDER BY AVG(orders.usd_price) DESC) AS ranking
FROM
  core.orders LEFT JOIN core.customers ON orders.customer_id = customers.id
GROUP BY 1, 2
QUALIFY ranking IN (1,2)
ORDER BY 1;
--Findings: For our mobile platform, the 'social media' & 'affiliate' channels return the highest AOV (86.71 & 70.63, respectively). Our web platform's highest AOV channels are 'affiliate' and 'direct', at 329.42 & 306.73, respectively.


-- Request 4: For products purchased in 2022 on the website or products purchase on mobile in any year, which region has the average highest time to deliver?

--(non-split: mobile & 2020 web combined) 
-- Join orders, customers, order_status, and geo_lookup tables to match regions, delivery times, and purchase platforms
-- DATE_DIFF() for finding the avg. delivery time (in days)
-- Filter results for website purchases made in 2022 OR any mobile purchases

SELECT
  geo.region AS Region,
  -- calculate averaged difference between delivery & purchase timestamps
  ROUND(AVG(DATE_DIFF(status.delivery_ts, status.purchase_ts, day)),2) AS Days_to_Ship
FROM
  core.orders JOIN core.customers ON orders.customer_id = customers.id LEFT JOIN core.order_status status ON orders.id = status.order_id LEFT JOIN core.geo_lookup geo ON customers.country_code = geo.country_code
WHERE
  -- filters for web platform orders made in 2020 OR mobile platform  
  (EXTRACT(YEAR from status.purchase_ts) = 2020 AND orders.purchase_platform = 'website') OR (orders.purchase_platform = 'mobile app') 
GROUP BY 1
ORDER BY 2 DESC;
-- Findings: APAC has highest shipping time at 7.48 days, EMEA closely behind at 7.5 days

-- (split mobile vs. 2020 web) 
-- Join orders, customers, order_status, and geo_lookup tables to match regions, delivery times, and purchase platforms
-- CASE statements (2) to differentiate between web & mobile platforms
-- DATE_DIFF() for finding the avg. delivery time for web & mobile (in days)
-- Filter results for website purchases made in 2022 OR any mobile purchases

SELECT
  geo.region AS Region
  -- creates calculated column for avg. shipping days for web platform 
  , ROUND(AVG(CASE WHEN orders.purchase_platform = 'website' THEN DATE_DIFF(status.delivery_ts, status.purchase_ts, day) END),2) AS Web2020_Shipping_Days
  -- creates calculated column for avg. shipping days for mobile platform
  , ROUND(AVG(CASE WHEN orders.purchase_platform = 'mobile app' THEN DATE_DIFF(status.delivery_ts, status.purchase_ts, day) END),2) AS Mobile_Shipping_Days
FROM
  core.orders LEFT JOIN core.customers ON orders.customer_id = customers.id LEFT JOIN core.order_status status ON orders.id = status.order_id LEFT JOIN core.geo_lookup geo ON customers.country_code = geo.country_code
WHERE
  -- filters for web platform orders made in 2020 OR mobile platform
  (EXTRACT(YEAR from status.purchase_ts) = 2020 AND orders.purchase_platform = 'website') OR (orders.purchase_platform = 'mobile app') 
GROUP BY 1;
--Findings: Overall, all regions averaged 7.4 & 7.5 days for web & mobile shipping, respectively. EMEA has highest delivery time for Mobile shipping at 7.64, with APAC trailing behind in second at 7.53. In regard 2020 Web orders, it appears that orders with no tracked region take the longest to ship at 7.52 - it may be worth clarifying if 'NULL' values indicate other specific global regions, or if it can be considered as a "catch-all" for the rest of the global market.


-- Request 5: What was the refund rate and refund count for each product overall?

-- Join orders & order_status to match refunds with timestamps
-- CASE statement to avg. where there is an existing refund-timestamp, for calculating rate
-- COUNT() refund-timestamps for magnitude of refunds (if no timestamp then NULL is present)
-- GROUP BY product, ORDER BY refund rate descending

SELECT
  CASE WHEN orders.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE orders.product_name END AS Product
  -- takes avg. of refund-timestamp for calculating rate
  , ROUND(AVG(CASE WHEN status.refund_ts IS NOT NULL THEN 1 ELSE 0 END),3) AS Refund_Rate
  , COUNT(status.refund_ts) AS Refunds
FROM
  core.orders JOIN core.order_status status ON orders.id = status.order_id
GROUP BY 1
ORDER BY 2 DESC;
--Findings: 
  --(1) Top refunded Project is the 'ThinkPad Laptop' with an 11.7% refund rate. Although, the 'Macbook Air Laptop' is closely trailing behind with an 11.4% refund rate.
  --(2) In regard to the magnitude of refunds, 'Apple Airpods Headphones' has the highest amount at 2.6K - however, it does have a relatively smaller refund rate at 5.4%.


-- Request 6: Within each region, what is the most popular product?

-- Join orders, customers, and geo_lookup tables to match regions and orders
-- CTE & DENSE_RANK() to rank products by region, ORDERED BY total orders
-- Call CTE & filter results where ranking = 1, to show top product sold in relative region 

-- CTE for top-purchased products by region
WITH regional_ranks AS(
  SELECT
    geo.region AS region
    -- cleaning product name for proper grouping
    , CASE WHEN orders.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE orders.product_name END AS product
    , COUNT(DISTINCT orders.id) AS order_count
    --ranks products based on order count & groups/partitions by region
    , DENSE_RANK() OVER(PARTITION BY geo.region ORDER BY COUNT(DISTINCT orders.id) DESC) AS ranking
  FROM
    core.orders JOIN core.customers ON orders.customer_id = customers.id JOIN core.geo_lookup geo ON customers.country_code = geo.country_code
  GROUP BY 1, 2
)
SELECT
  region AS Region 
  , product AS Product
  , order_count
FROM
  regional_ranks
WHERE 
  -- filters for #1 ranking, only, for each region
  regional_ranks.ranking = 1;
--Findings: 'Apple Airpods Headphones' are unequivocally the highest-ordered product across all regions. NA having the most total sales at 18K, with EMEA following-up with 11.2K; LATAM had the lowest total sales at 1.9K. As this was discovered to have the highest amount of refunds (see query #3), it may be worth investigating probable cause for refunds.


-- Request 7: How does the time to make a purchase differ between loyalty customers vs. non-loyalty customers?

-- Join customers & orders to match orders with loyalty/non-loyalty status
-- CASE for helper column with loyalty/non-loyalty status differentiation
-- DATE_DIFF() to find difference between purchase & account creation timestamps (in days & months)
-- GROUP BY loyalty status of customer

SELECT 
  -- helper column for explicit loyalty vs. non-loyalty status
  CASE WHEN customers.loyalty_program = 1 THEN 'Loyalty' ELSE 'Non-Loyalty' END AS Loyalty_Status
  , ROUND(AVG(DATE_DIFF(orders.purchase_ts, customers.created_on, day)),2) AS Days_to_Purchase
  , ROUND(AVG(DATE_DIFF(orders.purchase_ts, customers.created_on, month)),2) AS Months_to_Purchase
FROM
  core.customers JOIN core.orders ON customers.id = orders.customer_id
GROUP BY 1;
--Findings: Comparably, loyalty customers take ~30% less time than non-loyalty customers to make a purchase after account creation; loyalty taking 1.6 months vs. non-loyalty at 2.3 months.
