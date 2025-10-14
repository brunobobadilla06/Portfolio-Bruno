
EXPLAIN QUERY PLAN
SELECT o.order_id
FROM orders o
JOIN order_items oi ON oi.order_id=o.order_id
WHERE o.customer_id = 10 AND o.order_date BETWEEN '2025-01-01' AND '2025-12-31';
