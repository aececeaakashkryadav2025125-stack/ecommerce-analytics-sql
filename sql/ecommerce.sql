CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price INT CHECK (price > 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1,'Aakash','aakash@email.com','Jamshedpur','2023-01-10'),
(2,'Rahul','rahul@email.com','Ranchi','2023-03-15'),
(3,'Priya','priya@email.com','Delhi','2023-05-20'),
(4,'Neha','neha@email.com','Mumbai','2023-07-01'),
(5,'Amit','amit@email.com','Kolkata','2023-08-12');

INSERT INTO products VALUES
(101,'Laptop','Electronics',60000),
(102,'Phone','Electronics',20000),
(103,'Shoes','Fashion',3000),
(104,'Watch','Accessories',5000),
(105,'Bag','Fashion',1500);

INSERT INTO orders VALUES
(1001,1,101,1,'2024-01-10','Delivered'),
(1002,2,102,2,'2024-01-15','Delivered'),
(1003,3,103,3,'2024-02-01','Cancelled'),
(1004,1,104,1,'2024-02-10','Delivered'),
(1005,5,105,2,'2024-03-05','Delivered');

SELECT SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered';

SELECT c.name,
SUM(p.price * o.quantity) AS total_spent,
RANK() OVER (ORDER BY SUM(p.price * o.quantity) DESC) AS rank_position
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY c.name;

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(p.price * o.quantity) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY month;

DELIMITER //
CREATE PROCEDURE GetCustomerRevenue(IN cust_id INT)
BEGIN
    SELECT c.name,
    SUM(p.price * o.quantity) AS total_revenue
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN products p ON o.product_id = p.product_id
    WHERE o.customer_id = cust_id
    GROUP BY c.name;
END //
DELIMITER ;

CALL GetCustomerRevenue(1);