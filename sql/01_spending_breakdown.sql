--These queries were used to double-check values produced in the spending by category analysis in Tableau

SELECT * FROM customer_category_spending ORDER BY customer_id, debits_value DESC;

--Calculates mean by category, with and without zero spenders in each category
SELECT 
    category,
    AVG(debits_value) AS mean_including_zeros, 
    AVG(debits_value) FILTER (WHERE debits_value > 0) AS mean_excluding_zeros
FROM customer_category_spending
GROUP BY category
ORDER BY mean_including_zeros DESC;

----Calculates median by category, with and without zero spenders in each category
SELECT 
    category,
    MEDIAN(debits_value) AS median_including_zeros,
    MEDIAN(debits_value) FILTER (WHERE debits_value > 0) AS median_excluding_zeros
FROM customer_category_spending
GROUP BY category
ORDER BY median_including_zeros DESC;

--Calculates the percentage of customers who spent money in the corresponding merchant category
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