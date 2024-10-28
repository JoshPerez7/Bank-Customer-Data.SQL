#Customer Insights Analysis: Decoding Retention and Engagement

SELECT * FROM bankcustomer.bank_churn;

# questions 

# Retrieve all customers' surnames and their corresponding estimated salaries ordered by salary highest to lowest.

SELECT Surname, EstimatedSalary
FROM bankcustomer.bank_churn
ORDER BY EstimatedSalary DESC;

# Find the number of active members (IsActiveMember).

SELECT COUNT(CustomerId) AS 'Total Active Members'
FROM bankcustomer.bank_churn
WHERE IsActiveMember = 1;

# Identify the average credit score of customers who 
# have exited (Exited = 1).

SELECT AVG(CreditScore) AS 'Average Credit Score'
FROM bankcustomer.bank_churn
WHERE Exited = 1;

# List all customers Id and surname from "Geography" = "France" 
# who have more than one product (NumOfProducts > 1) 
# sort by last name a to z.

SELECT CustomerId, Surname
FROM bankcustomer.bank_churn
WHERE Geography = 'France' and NumOfProducts > 1
ORDER BY Surname;

# Calculate the total balance for each geography 
# and display the geography with the highest total balance
# at the top.

SELECT Geography, SUM(Balance) AS 'Total Balance'
FROM bankcustomer.bank_churn
GROUP BY Geography
ORDER BY SUM(Balance) DESC;

# Determine the average age of customers who have a credit card (HasCrCard = 1) and are active members (IsActiveMember = 1).

SELECT avg(age) AS 'Average Age'
FROM bankcustomer.bank_churn
WHERE HasCrCard = 1 and IsActiveMember = 1;

# medium

# How does customer tenure (Tenure) impact the 
# likelihood of having a credit card (HasCrCard),
# and what are the trends observed in different
# geographic locations?  find percentage to total num of customers

SELECT Geography, Tenure,
    100 * SUM(CASE WHEN HasCrCard = 1 THEN 1 ELSE 0 END) / COUNT(customerid) AS 'PercentageCreditCardHolders'
FROM bankcustomer.bank_churn
GROUP BY Geography, Tenure
ORDER BY Geography, Tenure;

# To what extent does the number of products a customer holds (NumOfProducts) correlate with their credit score (CreditScore), and how does this relationship vary by age group?

SELECT 
	CASE
		WHEN age BETWEEN 18 and 25 THEN '18 -25'
        WHEN age BETWEEN 26 and 35 THEN '26 - 35'
        WHEN age BETWEEN 36 and 45 THEN '36 - 45'
        WHEN age BETWEEN 46 and 55 THEN '46 - 55'
        WHEN age BETWEEN 56 and 65 THEN '56 - 65'
        WHEN age BETWEEN 66 and 75 THEN '66 - 75'
        WHEN age BETWEEN 76 and 85 THEN '76 - 85'
        WHEN age BETWEEN 86 and 95 THEN '86 - 95'
        ELSE 'Other'
	END AS AgeGroup,
	AVG(NumOfProducts) as 'Average Number of Products', AVG(CreditScore) as 'Average Credit Score'	
FROM bankcustomer.bank_churn
Group by AgeGroup
ORDER BY AgeGroup;

# How does being an active member (IsActiveMember) affect the balance a customer maintains, and do these trends differ between genders?

SELECT
	Gender,
    CASE 
		WHEN IsActiveMember = 1 THEN 'ActiveMember'
		WHEN IsActiveMember = 0 THEN 'NotActiveMember'
	END AS MemberType,
    AVG(Balance) AS AvgBalance
FROM bankcustomer.bank_churn
GROUP BY Gender, MemberType
ORDER BY Gender;


# What is the relationship between the estimated salary (EstimatedSalary) and the number of products held
# (NumOfProducts), and does this vary with the tenure of the customer?

SELECT 
    CASE 
        WHEN NumOfProducts = 0 THEN '0'
        WHEN NumOfProducts BETWEEN 1 AND 4 THEN CAST(NumOfProducts AS CHAR)
        ELSE 'other'
    END AS NumberOfProducts,
    CASE 
        WHEN Tenure BETWEEN 0 AND 2 THEN '0-2'
        WHEN Tenure BETWEEN 3 AND 5 THEN '3-5'
        WHEN Tenure BETWEEN 6 AND 8 THEN '6-8'
        WHEN Tenure BETWEEN 9 AND 10 THEN '9-10'
        ELSE 'other'
    END AS TenureRange,
    AVG(EstimatedSalary) AS AvgEstimatedSalary
FROM bankcustomer.bank_churn
GROUP BY NumberOfProducts, TenureRange
ORDER BY NumberOfProducts, TenureRange;
