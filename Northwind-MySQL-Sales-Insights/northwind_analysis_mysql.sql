# 1. Top Products by Revenue

SELECT 
	p.product_name,
	ROUND(SUM(od.quantity * od.unit_price), 0) AS total_revenue
FROM order_details od
JOIN products p
	ON od.product_id = p.id
GROUP BY od.product_id
ORDER BY total_revenue DESC
LIMIT 10
;

# 2. Revenue by Employee
SELECT 
	SUM(od.quantity * od.unit_price) AS total_revenue,
    CONCAT(e.first_name, ' ', e.last_name) AS employee
FROM order_details od 
JOIN orders o
	ON od.order_id = o.id
JOIN employees e
	ON o.employee_id = e.id
GROUP BY o.employee_id
ORDER BY total_revenue DESC
LIMIT 10
;
 
# Using CTE

WITH employee_details AS (
  SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    o.id AS order_id
  FROM employees e
  JOIN orders o ON e.id = o.employee_id
)
SELECT 
  employee AS Employee,
  ROUND(SUM(od.unit_price * od.quantity), 0) AS TotalRevenue
FROM employee_details ed
JOIN order_details od ON ed.order_id = od.order_id
GROUP BY employee
ORDER BY TotalRevenue DESC
LIMIT 10;

# 3. Monthly Sales Trend

SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS Yr_Month,
    SUM(od.unit_price * od.quantity) AS Revenue
FROM orders o
JOIN order_details od ON o.id = od.order_id
GROUP BY Yr_Month
ORDER BY Yr_Month;
