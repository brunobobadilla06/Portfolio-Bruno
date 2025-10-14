
-- KPIs: revenue, AOV, activos, mensual y rolling 3m
WITH line_revenue AS (
  SELECT oi.order_id, (oi.qty * oi.unit_price) AS line_total
  FROM order_items oi
)
SELECT ROUND(SUM(line_total),2) AS gross_revenue
FROM line_revenue
JOIN orders o USING(order_id)
WHERE o.status = 'paid';

SELECT COUNT(DISTINCT o.customer_id) AS active_customers
FROM orders o
WHERE o.status = 'paid';

WITH ord_tot AS (
  SELECT o.order_id, SUM(oi.qty * oi.unit_price) AS total
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.status='paid'
  GROUP BY 1
)
SELECT ROUND(AVG(total),2) AS AOV FROM ord_tot;

WITH ord_tot AS (
  SELECT o.order_id, DATE(strftime('%Y-%m-01', o.order_date)) AS month,
         SUM(oi.qty * oi.unit_price) AS total
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.status='paid'
  GROUP BY 1,2
)
SELECT month,
       ROUND(SUM(total),2) AS revenue,
       ROUND(AVG(total),2) AS aov,
       ROUND(SUM(SUM(total)) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rev_roll_3m
FROM ord_tot
GROUP BY month
ORDER BY month;
