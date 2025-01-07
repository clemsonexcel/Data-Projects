/*
 Write an SQL query to identify potential fraudulent transactions by comparing the average transaction amount of each sending address to
 its individual transactions. Highlight those transactions where the amount exceeds the average by more than two standard deviations.
*/

-- potential fraudulent transactions
SELECT sending_address, 
       amount, 
       avg_amount,
       std_amount,
       two_std_dev,
       amount_diff
FROM (
    SELECT sending_address, 
           amount, 
           AVG(amount) OVER (PARTITION BY sending_address) AS avg_amount,
           STDDEV(amount) OVER (PARTITION BY sending_address) AS std_amount,
           2 * STDDEV(amount) OVER (PARTITION BY sending_address) AS two_std_dev,
           ABS(amount - AVG(amount) OVER (PARTITION BY sending_address)) AS amount_diff
    FROM metaverse
) AS subquery
WHERE amount_diff > two_std_dev; 

-- Optionally, if you want to save the output into temporary table
create temporary table potential_fraud as 
SELECT sending_address, 
       amount, 
       avg_amount,
       std_amount,
       two_std_dev,
       amount_diff
FROM (
    SELECT sending_address, 
           amount, 
           AVG(amount) OVER (PARTITION BY sending_address) AS avg_amount,
           STDDEV(amount) OVER (PARTITION BY sending_address) AS std_amount,
           2 * STDDEV(amount) OVER (PARTITION BY sending_address) AS two_std_dev,
           ABS(amount - AVG(amount) OVER (PARTITION BY sending_address)) AS amount_diff
    FROM metaverse
) AS subquery
WHERE amount_diff > two_std_dev;
