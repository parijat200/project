-- AMAZON DATA ANALYSIS 

-- Feature Engineering:

-- 1. Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
--    This will help answer the question on which part of the day most sales are made.

-- 2. Add a new column named dayname that contains the extracted days of the week on which the given transaction took place 
--    (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

-- 3. Add a new column named monthname that contains the extracted months of the year on which the given transaction took place 
--    (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

-- Exploratory Data Analysis (EDA)

-- Data Information:
-- 1. Cities Count: What is the count of distinct cities in the dataset?
-- 2. Branch Correspondence: For each branch, what is the corresponding city?
-- 3. Product Lines Count: What is the count of distinct product lines in the dataset?
-- 4. Customer Types Count: What is the count of distinct customer types in the dataset?
-- 5. Payment Methods Count: What is the count of distinct payment methods in the dataset?

-- PART 1 --

-- Product Analysis:
-- Performance:
-- 1. Which product line has the highest sales?
-- 2. Which product line generated the highest revenue?
-- 3. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

-- Ratings:
-- 1. Calculate the average rating for each product line.

-- Gender Association:
-- 1. Which product line is most frequently associated with each gender?

-- PART 2 --
-- Sales Analysis:

-- Trends:
-- 1. How much revenue is generated each month?
-- 2. In which month did the cost of goods sold reach its peak?

-- Location:
-- 1. In which city was the highest revenue recorded?

-- VAT:
-- 1. Which product line incurred the highest Value Added Tax?
-- 2. Determine the city with the highest VAT percentage.
-- 3. Identify the customer type with the highest VAT payments.

-- PART 3 --
-- Customer Analysis:
-- Segments and Purchase Trends:
-- 1. Identify the customer type contributing the highest revenue.
-- 2. Identify the customer type with the highest purchase frequency.
-- 3. Which customer type occurs most frequently?

-- Demographics:
-- 1. Determine the predominant gender among customers.
-- 2. Examine the distribution of genders within each branch.

-- Ratings:
-- 1. Identify the time of day when customers provide the most ratings.
-- 2. Determine the time of day with the highest customer ratings for each branch.
-- 3. Identify the day of the week with the highest average ratings.
-- 4. Determine the day of the week with the highest average ratings for each branch.

-- PART 4 -- 

-- Time Analysis:
-- Sales:
-- 1. Count the sales occurrences for each time of day on every weekday.

-- Branch Performance:
-- 1. Identify the branch that exceeded the average number of products sold.

-- Payment Method Analysis:
-- 1. Which payment method occurs most frequently?

USE amazon_analysis;

SELECT * FROM amazon;

-- Feature Engineering:

-- 1. Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
--    This will help answer the question on which part of the day most sales are made.

-- 2. Add a new column named dayname that contains the extracted days of the week on which the given transaction took place 
--    (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

-- 3. Add a new column named monthname that contains the extracted months of the year on which the given transaction took place 
--    (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

DESC amazon;

ALTER TABLE amazon 
MODIFY COLUMN Date Date;

ALTER TABLE amazon 
MODIFY COLUMN Time Time;

SELECT * FROM amazon;

-- Add a new column named timeofday (Morning, Afternoon and Evening) 

SELECT Time,
       CASE 
         WHEN Time BETWEEN '10:00:00' AND '11:59:59' THEN 'Morning'
         WHEN Time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
         WHEN Time BETWEEN '16:00:00' AND '23:00:00' THEN 'Evening'
		ELSE 'None'
	   END AS Time_Categorise
FROM amazon;

UPDATE amazon SET TimeOfDay = CASE 
         WHEN Time BETWEEN '10:00:00' AND '11:59:59' THEN 'Morning'
         WHEN Time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
         WHEN Time BETWEEN '16:00:00' AND '23:00:00' THEN 'Evening'
		ELSE 'Non'
	END;

SELECT Time,
	   TimeOfDay
 FROM amazon;



ALTER TABLE amazon
ADD COLUMN TimeOfDay VARCHAR(30);

SELECT DISTINCT LEFT(Time,2) 
FROM amazon;

SELECT * FROM amazon;

-- Add a new column named dayname (Mon, Tue, Wed, Thur, Fri)

UPDATE amazon SET Dayname = 
                            DAYNAME(Date);


SELECT Date,
	   DAYNAME(Date) AS Days
FROM amazon;


SELECT Date,
	   Dayname
FROM amazon;

ALTER TABLE amazon
ADD COLUMN Dayname VARCHAR(30);

-- Add a new column named monthname (Jan, Feb, Mar)

ALTER TABLE amazon
ADD COLUMN Month VARCHAR(30);

UPDATE amazon SET Month = 
                         MONTHNAME(Date);

SELECT Date,
       Time,
       TimeOfDay,
       Dayname,
       Month
FROM amazon;

-- Data Information:
-- 1. Cities Count: What is the count of distinct cities in the dataset?
-- 2. Branch Correspondence: For each branch, what is the corresponding city?
-- 3. Product Lines Count: What is the count of distinct product lines in the dataset?
-- 4. Customer Types Count: What is the count of distinct customer types in the dataset?
-- 5. Payment Methods Count: What is the count of distinct payment methods in the dataset?

SELECT DISTINCT City 
FROM amazon;

SELECT DISTINCT Branch,
	   City
FROM amazon;

SELECT DISTINCT `Product line` 
FROM amazon;

SELECT DISTINCT `Customer type`
FROM amazon;

SELECT DISTINCT Payment 
FROM amazon;

-- PART 1 --

-- Product Analysis:
-- Performance:
-- 1. Which product line has the highest sales?
-- 2. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

-- Ratings:
-- 1. Calculate the average rating for each product line.

-- Gender Association:
-- 1. Which product line is most frequently associated with each gender?

-- SOLUTION PART 1

-- 1. Which product line has the highest sales?

SELECT `Product line`,
	   ROUND(SUM(Total),2) AS Total_Sales
FROM amazon
GROUP BY `Product line`
ORDER BY Total_Sales DESC;

-- 2. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

WITH CTE AS 
  (
	SELECT `Product line`,
			ROUND(SUM(Total),2) AS Total_Sales 
	FROM amazon
	GROUP BY `Product line`
    )
SELECT *,
       (SELECT ROUND(AVG(Total_Sales),2) FROM CTE) AS Avg_Sales,
	   CASE
          WHEN Total_Sales > (SELECT ROUND(AVG(Total_Sales),2) FROM CTE) THEN 'Good'
		  ELSE 'Bad'
	   END AS 'Comparison'
FROM CTE;

-- 1. Calculate the average rating for each product line.

SELECT `Product line`,
        ROUND(Avg_Rating,2) AS Avg_Rating
FROM 
   (
	SELECT DISTINCT `Product line`,
			AVG(Rating) OVER(PARTITION BY `Product line`) AS Avg_Rating  
	FROM amazon
    ) AS SUBQUERY;

-- 1. Which product line is most frequently associated with each gender?

SELECT `Product line`,
        Gender,
        Total_Count
FROM 
  (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY Total_Count DESC) AS Row_Numbers
	FROM 
	  (
		SELECT `Product line`,
				Gender,
				COUNT(*) AS Total_Count
		FROM amazon
		GROUP BY `Product line`, Gender
		) AS SUBQUERY
        ) AS SUBQUERY_2
WHERE Row_Numbers = 1;

-- PART 2 --
-- Sales Analysis:

-- Trends:
-- 1. How much revenue is generated each month?
-- 2. In which month did the cost of goods sold reach its peak?

-- Location:
-- 1. In which city was the highest revenue recorded?

-- VAT:
-- 1. Which product line incurred the highest Value Added Tax?
-- 2. Determine the city with the highest VAT percentage.
-- 3. Identify the customer type with the highest VAT payments.

-- SOLUTION PART 2

-- 1. How much revenue is generated each month?

SELECT Month,
	   ROUND(SUM(Total),2) AS Total_Revenue
FROM amazon
GROUP BY month;

-- 2. In which month did the cost of goods sold reach its peak?

SELECT Month,
	   ROUND(SUM(cogs),2) AS Total_Cost_OF_Good
FROM amazon
GROUP BY Month
ORDER BY Total_Cost_OF_Good DESC
LIMIT 1;

-- 1. In which city was the highest revenue recorded?

SELECT City,
       ROUND(SUM(Total),2) AS Total_Revenue 
FROM amazon
GROUP BY City
ORDER BY Total_Revenue DESC;

-- 1. Which product line incurred the highest Value Added Tax?

SELECT `Product line`,
        ROUND(SUM(`Tax 5%`),2) AS Total_VAT 
FROM amazon
GROUP BY `Product line`
ORDER BY Total_VAT DESC;

-- 2. Determine the city with the highest VAT percentage.

SELECT City,
       ROUND(SUM(`Tax 5%`),2) AS Total_VAT
FROM amazon
GROUP BY City
ORDER BY Total_VAT DESC;

-- 3. Identify the customer type with the highest VAT payments.

SELECT `Customer type`,
       ROUND(SUM(`Tax 5%`),2) AS Total_VAT
FROM amazon
GROUP BY `Customer type`
ORDER BY Total_VAT DESC;

-- BASICALLY THESE 3 QUESTION QURERY WRITE AGIAN AGAIN SO HERE I USE STORE PROCEDURE

-- VAT:
-- 1. Which product line incurred the highest Value Added Tax?
-- 2. Determine the city with the highest VAT percentage.
-- 3. Identify the customer type with the highest VAT payments.

DELIMITER //

CREATE PROCEDURE TotalVat(IN COL VARCHAR(30))
BEGIN
   SET @SQL = 
              CONCAT('SELECT ', COL, 
                      ', ROUND(SUM(`Tax 5%`),2) AS Total_VAT 
                      FROM amazon
                      GROUP BY ', COL,
                      ' ORDER BY Total_VAT DESC'
                      );
	PREPARE STMT FROM @SQL;
    EXECUTE STMT;
    DEALLOCATE PREPARE SMTP;
END //

DELIMITER ;

CALL TotalVat('`Product line`');

CALL TotalVat('City');

CALL TotalVat('`Customer type`');

-- PART 3 --
-- Customer Analysis:
-- Segments and Purchase Trends:
-- 1. Identify the customer type contributing the highest revenue.
-- 2. Identify the customer type with the highest purchase frequency.

-- Demographics:
-- 1. Determine the predominant gender among customers.
-- 2. Examine the distribution of genders within each branch.

-- Ratings:
-- 1. Identify the time of day when customers provide the most ratings.
-- 2. Determine the time of day with the highest customer ratings for each branch.
-- 3. Identify the day of the week with the highest average ratings.
-- 4. Determine the day of the week with the highest average ratings for each branch.

-- SOLUTION PART 3

-- 1. Identify the customer type contributing the highest revenue.

SELECT `Customer type`,
       ROUND(SUM(Total),2) AS Total_Revenue
FROM amazon
GROUP BY `Customer type`
ORDER BY Total_Revenue DESC;

-- 2. Identify the customer type with the highest purchase frequency.

SELECT `Customer type`,
       COUNT(*) AS Purchase_Frequency
FROM amazon
GROUP BY `Customer type`
ORDER BY Purchase_Frequency DESC;

-- 1. Determine the predominant gender among customers.

SELECT Gender,
       COUNT(*) AS Total_Customer 
FROM amazon
GROUP BY Gender
ORDER BY Total_Customer DESC;

-- 2. Examine the distribution of genders within each branch.

SELECT Branch,
       COUNT(*) AS Total_Customer 
FROM amazon
GROUP BY Branch
ORDER BY Total_Customer DESC;

-- 1. Identify the time of day when customers provide the most ratings.

SELECT TimeOfDay,
       COUNT(Rating) AS Rating_Count 
FROM amazon
GROUP BY TimeOfDay
ORDER BY Rating_Count DESC;

-- 2. Determine the time of day with the highest customer ratings for each branch.

SELECT Branch,
       TimeOfDay,
       Highest_Rating
FROM 
  (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Branch ORDER BY Highest_Rating DESC) AS Dense
	FROM 
	  (
		SELECT Branch,
			   TimeOfDay,
			   ROUND(AVG(Rating),2) AS Highest_Rating 
		FROM amazon
		GROUP BY Branch, TimeOfDay
		ORDER BY Highest_Rating DESC
		) AS SUBQUERY
        ) AS SUBQUERY_2
WHERE Dense = 1;

-- 3. Identify the day of the week with the highest average ratings.

SELECT Dayname,
       ROUND(AVG(Rating),2) AS Average_Rating
FROM amazon
GROUP BY Dayname
ORDER BY Average_Rating DESC;

-- 4. Determine the day of the week with the highest average ratings for each branch.

SELECT Branch,
       Dayname,
       Average_Rating
FROM 
  (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Branch ORDER BY Average_Rating DESC) AS Dense
	FROM 
	   (
		SELECT Branch,
			   Dayname,
			   ROUND(AVG(Rating),2) AS Average_Rating
		FROM amazon
		GROUP BY Branch, Dayname
		) AS SUBQUERY
        ) AS SUBQUERY_2
WHERE Dense = 1;

-- PART 4 -- 

-- Time Analysis:
-- Sales:
-- 1. Count the sales occurrences for each time of day on every weekday.

-- Branch Performance:
-- 1. Identify the branch that exceeded the average number of products sold.

-- Payment Method Analysis:
-- 1. Which payment method occurs most frequently?

-- SOLUTION PART 4

-- 1. Count the sales occurrences for each time of day on every weekday.

SELECT TimeOfDay,
       COUNT(*) AS Sales_Occurence
FROM amazon
WHERE Dayname IN ('Saturday', 'Sunday')
GROUP BY TimeOfDay;

-- 1. Identify the branch that exceeded the average number of products sold.


WITH CTE_2 AS 
  (
	WITH CTE AS 
	 (
		SELECT Branch,
			   SUM(Quantity) AS Number_OF_Product
		FROM amazon
		GROUP BY Branch
		)
	SELECT *,
		   (SELECT AVG(Number_OF_Product) FROM CTE) AS Average_Product 
	FROM CTE
    )
SELECT * 
FROM CTE_2
WHERE Number_OF_Product > Average_Product;

-- 1. Which payment method occurs most frequently?

SELECT Payment,
       COUNT(*) AS Total_Transaction 
FROM amazon
GROUP BY Payment
ORDER BY Total_Transaction DESC;




































