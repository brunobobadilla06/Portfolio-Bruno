
DROP VIEW IF EXISTS v_order_totals;
CREATE VIEW v_order_totals AS
SELECT o.order_id, o.customer_id, o.order_date, o.status,
       SUM(oi.qty*oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id=o.order_id
GROUP BY 1,2,3,4;

DROP VIEW IF EXISTS v_monthly_revenue;
CREATE VIEW v_monthly_revenue AS
SELECT DATE(strftime('%Y-%m-01', order_date)) AS month,
       ROUND(SUM(order_total),2) AS revenue
FROM v_order_totals
WHERE status='paid'
GROUP BY 1;
