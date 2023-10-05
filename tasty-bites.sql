-- Tabel Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50)
);

-- Tabel MenuItems
CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    category VARCHAR(50)
);

-- Tabel Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    table_number INT,
    employee_id INT,
    order_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Tabel OrderItems
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

-- Tabel Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Inserting an employee record
INSERT INTO Employees(employee_id, first_name, last_name, position)
VALUES  (1, 'John', 'Doe', 'Waiter'),
        (2, 'Jane', 'Smith', 'Cashier'),
        (3, 'Michael', 'Johnson', 'Chef');

-- Inserting a menu item record
INSERT INTO MenuItems(item_id, name, description, price, category)
VALUES  (1, 'Steak', 'Grilled sirloin steak', 25.99, 'Main Course'),
        (2, 'Salad', 'Fresh garden salad', 8.99, 'Appetizer'),
        (3, 'Pizza', 'Margherita pizza', 12.99, 'Main Course'),
        (4, 'Cheesecake', 'New York style cheesecake', 6.99, 'Dessert');

-- Inserting an order record
INSERT INTO Orders(order_id, table_number, employee_id, order_date, status)
VALUES  (1, 5, 1, '2023-08-04', 'Pending'),
        (2, 3, 2, '2023-08-05', 'Completed'),
        (3, 8, 3, '2023-08-06', 'Pending');

-- Inserting an order item record
INSERT INTO OrderItems(order_item_id, order_id, item_id, quantity, subtotal)
VALUES  (1, 1, 1, 2, 51.98), 
        (2, 2, 3, 1, 12.99),
        (3, 2, 4, 1, 6.99),
        (4, 3, 2, 2, 17.98),
        (5, 3, 3, 1, 12.99);

-- Inserting a payment record
INSERT INTO Payments(payment_id, order_id, payment_date, payment_method, total_amount)
VALUES  (1, 1, '2023-08-04', 'Credit Card', 51.98),
        (2, 2, '2023-08-05', 'Cash', 19.98),
        (3, 3, '2023-08-06', 'Credit Card', 30.97);

-- Retrieve all orders with their applied discounts:
SELECT 
    Orders.order_id, 
    Orders.table_number, 
    Employees.first_name, 
    Employees.last_name, 
    Orders.order_date, 
    Orders.status, 
    SUM(MenuItems.price * OrderItems.quantity) AS total_price, 
    (SUM(MenuItems.price * OrderItems.quantity) - Payments.total_amount) AS discount
FROM Orders
JOIN Employees ON Orders.employee_id = Employees.employee_id
JOIN OrderItems ON Orders.order_id = OrderItems.order_id
JOIN MenuItems ON OrderItems.item_id = MenuItems.item_id
JOIN Payments ON Orders.order_id = Payments.order_id
GROUP BY Orders.order_id;

-- Calculate the total revenue (including discounts) for a specific day (Menghitung total pendapatan, termasuk diskon, untuk hari tertentu):
SELECT
    SUM(Payments.total_amount - 
    (SELECT SUM(OrderItems.subtotal) 
    FROM OrderItems 
    WHERE OrderItems.order_id = Orders.order_id)
    ) AS total_revenue
FROM
    Orders
JOIN
    Payments ON Orders.order_id = Payments.order_id
WHERE
    Orders.order_date = '2023-08-04';