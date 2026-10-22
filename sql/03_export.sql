--This file creates the two CSV files used by Tableau.
--The two CSV files correspond to the two main views in the setup file.

COPY (SELECT * FROM customer_category_spending)
TO 'data/customer_category_spending.csv'
(HEADER, DELIMITER ',');

COPY (SELECT * FROM customer_monthly_spending)
TO 'data/customer_monthly_spending.csv'
(HEADER, DELIMITER ',');