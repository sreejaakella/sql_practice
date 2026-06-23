-- window fucntions
/*
sql normally works in two ways 
rows level- select,where
group level-groupby 
but sometimes we need row+group
this retieves the all rows and also the calualtions
running total,previous row compariison,moving average,top n 
SELECT
    column,
    window_function_name() OVER (
        PARTITION BY column
        ORDER BY column
    )
FROM table;
*/
/*
OVER CLAUSE

➤ OVER() defines the window (group of rows).

➤ Which rows should be considered for calculation.
   It creates a "window" (a group of rows).

➤ Think like:
   "For this row, which other rows should I look at?"
   SELECT
    column,
    window_function_name()
    OVER ( (over decides where tocalualte)
        PARTITION BY column (partition by is like grouping)
        ORDER BY column  (order by is sued for sorting) frame limit rows
    )
FROM table;
*/

/*
| **Category**     | **Functions**                               |
| ---------------- | ------------------------------------------- |
| **Aggregate**    | `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`         |
| **Ranking**      | `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE` |
| **Navigation**   | `LAG`, `LEAD`, `FIRST_VALUE`, `LAST_VALUE`  |
| **Distribution** | `CUME_DIST`, `PERCENT_RANK`                 |

*/

use pratice
-- find grand total show it in every order
SELECT
    city,
    sales,
    SUM(sales) OVER () AS total_sales,
    (sales / SUM(sales) OVER ()) * 100 AS pct
FROM sales_data;

-- total sales per state 
select customer_name,city,
sum(sales) over(partition by state order by customer_name)
from sales_data

-- find running sales inside each state

select
country,
max(sales) over(partition by sub_category)
from sales_data;
/*
ROW_NUMBER()
ROW_NUMBER() assigns a unique sequential number to each row within a partition.
Ranking starts from 1.
No two rows will have the same number.
Even if values are equal → ranking is still different.
Ranking restarts when partition changes.

ROW_NUMBER() OVER (
    PARTITION BY column_name
    ORDER BY column_name [ASC|DESC]
)
used with top n in group
duplicate
unique ordering 
*/
select ï»¿order_id,sales,sub_category,category,
row_number() over(partition by category)
from sales_data;

/*
RANK()
Same rank for equal values (ties allowed).
Skips next rank after tie.
If two rows tie for rank 1 → next rank will be 3.
Used in competition-style ranking.
RANK() OVER (
    PARTITION BY column_name
    ORDER BY column_name [ASC|DESC]
)
*/
SELECT
    customer_name,
    RANK() OVER (
        PARTITION BY customer_name
        ORDER BY sales DESC
    ) AS rnk
FROM sales_data;

SELECT
    customer_name,
    dense_RANK() OVER (
        PARTITION BY customer_name
        ORDER BY sales DESC
    ) AS rnk
FROM sales_data;
-- windoe fucntions
-- Show each order along with total sales of all orders.
SELECT 
    ï»¿order_id,
    SUM(sales) OVER() AS sum_sales
FROM sales_data;

-- Show each order with total sales per region.
SELECT 
    ï»¿order_id,
    avg(sales) OVER() AS total_sales
FROM sales_data;

-- Show each order with average profit per category
select customer_name,ï»¿order_id,
avg(sales) over(partition by category) as avg_sales_by_category
from sales_data;

-- Rank orders based on sales (highest to lowest)
SELECT
    ï»¿order_id,
    sales,
    RANK() OVER(ORDER BY sales DESC) AS sales_rank
FROM sales_data;
--
SELECT
    ï»¿order_id,
    region,
    sales,
    ROW_NUMBER() OVER(
        PARTITION BY region
        ORDER BY sales DESC
    ) AS rn
FROM sales_data;

-- Find top 3 highest sales orders in each region
SELECT *
FROM (
    SELECT region,
           sales,
           RANK() OVER(PARTITION BY region ORDER BY sales DESC) AS highest_rank
    FROM sales_data
) t
WHERE highest_rank <= 3;

-- Show each order with next order's sales
SELECT
ï»¿order_id,
    sales,
    LEAD(sales) OVER(ORDER BY ï»¿order_id) AS next_sales
FROM sales_data;

-- Show highest sales order in each region
SELECT *
FROM (
    SELECT *,
           dense_RANK() OVER(
               PARTITION BY region
               ORDER BY sales DESC
           ) AS rnk
    FROM sales_data
) t
WHERE rnk = 1;










