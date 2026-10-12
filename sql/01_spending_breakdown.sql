SELECT * FROM customer_category_spending ORDER BY customer_id, debits_value DESC;

SELECT 
    category,
    AVG(debits_value) AS mean_including_zeros, 
    AVG(debits_value) FILTER (WHERE debits_value > 0) AS mean_excluding_zeros
FROM customer_category_spending
GROUP BY category
ORDER BY mean_including_zeros DESC;

SELECT 
    category,
    MEDIAN(debits_value) AS median_including_zeros,
    MEDIAN(debits_value) FILTER (WHERE debits_value > 0) AS median_excluding_zeros
FROM customer_category_spending
GROUP BY category
ORDER BY median_including_zeros DESC;


WITH category_spenders AS (
    SELECT 
        category,
        COUNT(DISTINCT(customer_id)) AS total_customers,
        COUNT(DISTINCT(customer_id)) FILTER (WHERE debits_value > 0) AS total_spenders,
    FROM customer_category_spending
    GROUP BY category
)
SELECT 
    category,
    total_customers,
    total_spenders,
    total_spenders/total_customers * 100 AS percentage_spenders
FROM category_spenders
ORDER BY total_spenders DESC;


-- General spending habits
/*
SELECT m.category, 
    SUM(t.amount) FILTER (WHERE t.direction = 'credit') AS total_credits,
    SUM(t.amount) FILTER (WHERE t.direction = 'debit') AS total_debits,
    SUM(CASE WHEN t.direction = 'credit' THEN t.amount ELSE -t.amount END) AS net
FROM transactions AS t
JOIN merchants AS m ON t.merchant_id = m.merchant_id
GROUP BY m.category
ORDER BY net ASC;

SELECT m.country, COUNT(*) AS num_debits, SUM(t.amount) AS debit_amount
FROM transactions AS t
JOIN merchants AS m ON t.account_id = m.merchant_id
WHERE t.direction = 'debit' GROUP BY country
ORDER BY debit_amount DESC;

SELECT category, COUNT(*) AS num_debits, AVG(amount) AS average, SUM(amount) AS total
FROM merchants m JOIN transactions t ON m.merchant_id = t.merchant_id
WHERE direction = 'debit'
GROUP BY category
ORDER BY total DESC;

-- Personalised spending habits

SELECT a.customer_id, m.category, COUNT(*) AS num_debits, AVG(t.amount) AS average, SUM(t.amount) AS total
FROM transactions t JOIN accounts a ON t.account_id = a.account_id
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE t.direction = 'debit'
GROUP BY a.customer_id, m.category
ORDER BY a.customer_id, total DESC;
*/
