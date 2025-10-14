
-- Cohorte, RFM y Pareto

WITH first_order AS (
  SELECT c.customer_id,
         DATE(strftime('%Y-%m-01', MIN(o.order_date))) AS cohort_month
  FROM customers c
  JOIN orders o ON o.customer_id = c.customer_id AND o.status='paid'
  GROUP BY 1
),
activity AS (
  SELECT o.customer_id,
         DATE(strftime('%Y-%m-01', o.order_date)) AS month_active
  FROM orders o
  WHERE o.status='paid'
  GROUP BY 1,2
),
cohort_activity AS (
  SELECT f.cohort_month, a.month_active, COUNT(DISTINCT a.customer_id) AS active_customers
  FROM first_order f
  JOIN activity a ON a.customer_id = f.customer_id
  GROUP BY 1,2
)
SELECT cohort_month,
       month_active,
       CAST((julianday(month_active) - julianday(cohort_month))/30 AS INT) AS months_since_cohort,
       active_customers
FROM cohort_activity
ORDER BY cohort_month, month_active;

WITH paid_orders AS (
  SELECT o.order_id, o.customer_id, o.order_date
  FROM orders o
  WHERE o.status='paid'
),
totals AS (
  SELECT p.customer_id,
         MAX(p.order_date) AS last_order,
         COUNT(*) AS frequency,
         SUM(oi.qty*oi.unit_price) AS monetary
  FROM paid_orders p
  JOIN order_items oi ON oi.order_id=p.order_id
  GROUP BY 1
),
ranks AS (
  SELECT customer_id,
         last_order,
         frequency,
         monetary,
         NTILE(4) OVER (ORDER BY julianday('now') - julianday(last_order)) AS r,
         NTILE(4) OVER (ORDER BY frequency) AS f,
         NTILE(4) OVER (ORDER BY monetary) AS m
  FROM totals
)
SELECT customer_id, last_order, frequency, ROUND(monetary,2) AS monetary,
       (5 - r) AS recency_score, f AS frequency_score, m AS monetary_score,
       (5 - r) + f + m AS rfm_total
FROM ranks
ORDER BY rfm_total DESC
LIMIT 20;

WITH prod_rev AS (
  SELECT p.product_id, p.name,
         SUM(oi.qty*oi.unit_price) AS revenue
  FROM order_items oi
  JOIN orders o ON o.order_id=oi.order_id AND o.status='paid'
  JOIN products p ON p.product_id=oi.product_id
  GROUP BY 1,2
),
ordered AS (
  SELECT *, revenue / (SELECT SUM(revenue) FROM prod_rev) AS pct,
         SUM(revenue) OVER (ORDER BY revenue DESC) / (SELECT SUM(revenue) FROM prod_rev) AS cum_pct
  FROM prod_rev
)
SELECT product_id, name, ROUND(revenue,2) AS revenue, ROUND(cum_pct*100,1) AS cum_pct
FROM ordered
WHERE cum_pct <= 0.8
ORDER BY revenue DESC;
