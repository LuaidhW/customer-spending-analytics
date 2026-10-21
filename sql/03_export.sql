COPY (SELECT * FROM customer_category_spending)
TO 'data/customer_category_spending.csv'
(HEADER, DELIMITER ',');

COPY (SELECT * FROM customer_monthly_spending)
TO 'data/customer_monthly_spending.csv'
(HEADER, DELIMITER ',');