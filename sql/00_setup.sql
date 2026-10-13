CREATE VIEW transactions_GBP AS
SELECT t.*, t.amount * CASE
                            WHEN a.currency = 'USD' THEN 0.77
                            WHEN a.currency = 'EUR' THEN 0.85
                            WHEN a.currency = 'GBP' THEN 1
                        END
                        AS amount_GBP
FROM transactions t JOIN accounts a ON t.account_id = a.account_id;


CREATE VIEW customer_category_spending AS
WITH customer_category_pairs AS (
    SELECT a.customer_id, m.category
    FROM (SELECT DISTINCT customer_id FROM accounts) a CROSS JOIN (SELECT DISTINCT category FROM merchants) m
),
customer_spending AS (
    SELECT a.customer_id, m.category, SUM(t.amount_GBP) AS debits_value
    FROM transactions_GBP t JOIN accounts a ON t.account_id = a.account_id
    JOIN merchants m ON t.merchant_id = m.merchant_id
    WHERE t.direction = 'debit'
    GROUP BY a.customer_id, m.category
)
SELECT ccp.customer_id, ccp.category, COALESCE(cs.debits_value, 0) AS debits_value
FROM customer_category_pairs ccp LEFT JOIN customer_spending cs ON ccp.customer_id = cs.customer_id AND ccp.category = cs.category;


CREATE VIEW customer_monthly_spending AS
WITH months AS (
    SELECT month
    FROM generate_series(DATE '2024-01-01', DATE '2025-12-01', INTERVAL '1 MONTH') AS t(month)
),
customer_month_pairs AS (
    SELECT a.customer_id, m.month
    FROM (SELECT DISTINCT customer_id FROM accounts) a CROSS JOIN months m
),
monthly_spending AS (
    SELECT a.customer_id, DATE_TRUNC('month', t.posted_at) AS month, SUM(t.amount_GBP) AS debits_value
    FROM transactions_GBP t JOIN accounts a ON t.account_id = a.account_id
    WHERE t.direction = 'debit'
    GROUP BY a.customer_id, month
)
SELECT cmp.customer_id, cmp.month, COALESCE(ms.debits_value, 0) AS debits_value
FROM customer_month_pairs cmp LEFT JOIN monthly_spending ms ON cmp.customer_id = ms.customer_id AND cmp.month = ms.month
