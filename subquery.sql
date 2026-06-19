select * from customer_data;
select * from sales_data;

-- orders with sales above average 
SELECT *
FROM sales_data
WHERE sales >
(
    SELECT AVG(sales)
    FROM sales_data
);

-- highest sales order
select *
from sales_data
where sales=(select max(sales) from sales_data);

-- lowest sales order
select *
from sales_data
where sales=(select min(sales) from sales_data);

-- order with min dicount
select *
from sales_data
where discount=(select min(discount) from sales_data)
limit 1;

SELECT *
FROM sales_data
WHERE state IN (
    SELECT state
    FROM sales_data
    WHERE region = 'west'
);

SELECT *
FROM sales_data
WHERE sales > (
    SELECT MAX(sales)
    FROM sales_data
    WHERE region = 'South'
);
/*
SQL Aggregate Functions Rules

1. SELECT
✅ Aggregate functions are allowed.
Example:
SELECT dept, AVG(salary)
FROM employees
GROUP BY dept;

--------------------------------------------------

2. WHERE
❌ Aggregate functions are NOT allowed.

Wrong:
SELECT dept, AVG(salary)
FROM employees
WHERE AVG(salary) > 50000;

Reason:
WHERE filters rows before aggregation.

--------------------------------------------------

3. HAVING
✅ Aggregate functions are allowed.

Example:
SELECT dept, AVG(salary)
FROM employees
GROUP BY dept
HAVING AVG(salary) > 50000;

Reason:
HAVING filters groups after aggregation.

--------------------------------------------------

4. GROUP BY
❌ Aggregate functions cannot be used in GROUP BY.

Wrong:
SELECT dept, AVG(salary)
FROM employees
GROUP BY AVG(salary);

Correct:
SELECT dept, AVG(salary)
FROM employees
GROUP BY dept;

--------------------------------------------------

5. ORDER BY
✅ Aggregate functions are allowed.

Example:
SELECT dept, AVG(salary)
FROM employees
GROUP BY dept
ORDER BY AVG(salary) DESC;

--------------------------------------------------

6. GROUP BY Rule
Every column in SELECT must either:
✅ Be included in GROUP BY
OR
✅ Be inside an aggregate function.

Correct:
SELECT dept, AVG(salary)
FROM employees
GROUP BY dept;

Wrong:
SELECT dept, name, AVG(salary)
FROM employees
GROUP BY dept;

(name is neither grouped nor aggregated)

--------------------------------------------------

Common Aggregate Functions:
COUNT()
SUM()
AVG()
MIN()
MAX()

--------------------------------------------------

Easy Trick:
WHERE  -> Filters rows (No aggregate functions)
GROUP BY -> Creates groups
Aggregate Functions -> Calculate values for each group
HAVING -> Filters groups
ORDER BY -> Sorts the final result
*/
/*
Corelated Subquery
"Use the value from the current row of the outer query to filter the inner query."
ideal for ranking,row specific calucaltions,conditional logic
slower execution
harder for quey optimization
poor scalibility
*/
-- find hight sales order in each state
select * 
from sales_data s1
where sales=(
select max(sales)
from sales_data s2
where s1.state=s2.state
)
/*
1. Show customers whose sales are less than minimum sales in the Furniture
category.*/

SELECT customer_name, category
FROM sales_data
WHERE sales < (
    SELECT MIN(sales)
    FROM sales_data
    WHERE category = 'Furniture'
);

-- display all order where sales is maximum sales
select *
from sales_data 
where sales=(select max(sales) from sales_data);

-- Find orders where quantity is greater than average quantity.
select * 
from sales_data
where quantity>(select avg(quantity) from sales_data);

-- Show all rows where state is in the list of states that 
-- belong to Central region.
select * 
from sales_data 
where state in(select state from sales_data where region='Central')

-- Find orders where sales > ALL sales from East region.
select *
from sales_data
where sales>all(select sales from sales_data where region='East')

-- Find orders where sales are between average and maximum sales
select * 
from sales_data 
where sales between(select avg(sales) from sales_data) and (select max(sales) from sales_data)

-- Display orders where profit is above average but below maximum profit
SELECT *
FROM sales_data
WHERE profit > (SELECT AVG(profit) FROM sales_data)
AND profit < (SELECT MAX(profit) FROM sales_data);