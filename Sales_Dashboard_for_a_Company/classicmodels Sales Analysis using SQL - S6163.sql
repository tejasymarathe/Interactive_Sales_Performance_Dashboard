-- Sales insights of classicmodels dataset using SQL

use classicmodels;

-- Total Sales Amount

select sum(t.Sales) as TotalSales from 
(SELECT orderNumber, SUM(quantityOrdered * priceEach) 
AS Sales
FROM orderdetails
GROUP BY orderNumber) t;

-- Total Profit

select sum(tp.Profit) as TotalProfit from 
(SELECT SUM((quantityOrdered * priceEach) - (quantityOrdered * p.buyPrice)) AS Profit
FROM orderdetails od
JOIN orders o
ON od.orderNumber = o.orderNumber
JOIN products p 
ON od.productCode = p.productCode
group by O.orderNumber) tp;

-- Top 5 Products by Profit

SELECT productName, sum((quantityOrdered * priceEach) - (quantityOrdered * p.buyPrice)) AS profit
FROM products p 
join orderdetails od
on p.productCode = od.productCode
join orders o
on od.orderNumber = o.orderNumber
group by productName
ORDER BY profit DESC
LIMIT 5;

-- Total sales by Product Line
SELECT p.productLine, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine;

-- Order Quantity by Product line

SELECT p.productLine, SUM(od.quantityOrdered) AS totalOrderQuantity
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine;

-- Average order value

SELECT AVG(od.quantityOrdered * od.priceEach) AS averageOrderValue
FROM orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber;


-- Customer Count

SELECT COUNT(DISTINCT customerNumber) AS customerCount
FROM customers;

-- Order Count

SELECT COUNT(*) AS orderCount
FROM orders;

-- Yearwise Profit

SELECT YEAR(o.orderDate) 
AS orderYear, SUM((od.quantityOrdered * od.priceEach) - (od.quantityOrdered * p.buyPrice)) 
AS totalProfit
FROM orders o
JOIN orderdetails od 
ON o.orderNumber = od.orderNumber
JOIN products p 
ON od.productCode = p.productCode
GROUP BY orderYear
ORDER BY orderYear;

-- Best employee who is responsible for highest profit among all

SELECT 
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS totalProfit
FROM employees e
INNER JOIN customers c 
ON e.employeeNumber = c.salesRepEmployeeNumber
INNER JOIN orders o 
ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od 
ON o.orderNumber = od.orderNumber
INNER JOIN products p 
ON od.productCode = p.productCode
GROUP BY e.employeeNumber
ORDER BY totalProfit DESC
LIMIT 1;

-- Country Wise Profit

SELECT c.country, SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS totalProfit
FROM customers c
JOIN orders o 
ON c.customerNumber = o.customerNumber
JOIN orderdetails od 
ON o.orderNumber = od.orderNumber
JOIN products p 
ON od.productCode = p.productCode
GROUP BY c.country
ORDER BY totalProfit DESC;

