-- Transforming the table into  1NF using Recursive CTE
WITH RECURSIVE split_products AS (
  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS remaining
  FROM ProductDetail

  UNION ALL

  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
    SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
  FROM split_products
  WHERE remaining != ''
)

SELECT OrderID, CustomerName, Product
FROM split_products
ORDER BY OrderID;


-- To achieve 2NF, we should split the table into two tables: Orders and OrderItems.
-- 1. Orders Table - contains data that only depends on OrderID
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(255)
);

-- 2. OrderItems Table - contains data that depends on both OrderID and Product
CREATE TABLE OrderItems (
    OrderID INT,
    product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Inserting into Orders Table
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Inserting into OrderItems Table
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);
