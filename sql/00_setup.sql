CREATE VIEW customer_category_spending AS
WITH customer_category_pairs AS (
    SELECT a.customer_id, m.category
    FROM (SELECT DISTINCT customer_id FROM accounts) a CROSS JOIN (SELECT DISTINCT category FROM merchants) m
),
customer_spending AS (
    SELECT a.customer_id, m.category, SUM(t.amount) AS debits_value
    FROM transactions t JOIN accounts a ON t.account_id = a.account_id
    JOIN merchants m ON t.merchant_id = m.merchant_id
    WHERE t.direction = 'debit'
    GROUP BY a.customer_id, m.category
)
SELECT ccp.customer_id, ccp.category, COALESCE(cs.debits_value, 0) as debits_value
FROM customer_category_pairs ccp LEFT JOIN customer_spending cs ON ccp.customer_id = cs.customer_id AND ccp.category = cs.category;