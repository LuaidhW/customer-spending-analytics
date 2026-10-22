--These queries were used to double-check values produced in the monthly spending graph in Tableau

SELECT * FROM customer_monthly_spending ORDER BY customer_id, month;

SELECT month, AVG(debits_value) AS mean_debits_value, MEDIAN(debits_value) AS median_debits_value
FROM customer_monthly_spending
GROUP BY month
ORDER BY month;