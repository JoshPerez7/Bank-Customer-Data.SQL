-- 1. Identify customers from France who hold multiple products.

SELECT CustomerId, Surname
FROM bankcustomer.bank_churn
WHERE Geography = 'France' and NumOfProducts > 1
ORDER BY Surname;

-- 2. Determine the geographic regions with the highest total account balances.

SELECT Geography, SUM(Balance) AS 'Total Balance'
FROM bankcustomer.bank_churn
GROUP BY Geography
ORDER BY SUM(Balance) DESC;

-- 3. Investigate how customer tenure influences the likelihood of owning a credit card across different geographies.

SELECT Geography, Tenure,
    100 * SUM(CASE WHEN HasCrCard = 1 THEN 1 ELSE 0 END) / COUNT(customerid) AS 'PercentageCreditCardHolders'
FROM bankcustomer.bank_churn
GROUP BY Geography, Tenure
ORDER BY Geography, Tenure;

-- 4. Explore the correlation between the number of products held and credit scores, segmented by age groups.

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

-- 5. Assess how being an active member impacts account balance and how this varies by gender.

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

-- 6. Examine the relationship between estimated salaries and the number of products held, considering the impact of customer tenure.

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
