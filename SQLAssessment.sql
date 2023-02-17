---QUESTION 1----------------
-- create schema
CREATE SCHEMA sales2;
go

-- create tables
-- Create employees table
CREATE TABLE sales2.employees (
   employee_id INT PRIMARY KEY,
   first_name VARCHAR(50),
   last_name VARCHAR(50),
   job_title VARCHAR(50),
   department VARCHAR(50)
);

-- Create sales table
CREATE TABLE sales2.sales (
   sale_id INT PRIMARY KEY,
   employee_id INT,
   product_name VARCHAR(50),
   quantity INT,
   price DECIMAL(10, 2),
   FOREIGN KEY (employee_id) REFERENCES sales2.employees (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);



-- Load sample data into employees table
INSERT INTO sales2.employees (employee_id, first_name, last_name, job_title, department)
VALUES (1, 'John', 'Doe', 'Manager', 'Sales'),
       (2, 'Jane', 'Doe', 'Sales Representative', 'Sales'),
       (3, 'Bob', 'Smith', 'Marketing Manager', 'Marketing'),
       (4, 'Sarah', 'Lee', 'Sales Representative', 'Sales'),
       (5, 'David', 'Brown', 'Account Manager', 'Finance'),
       (6, 'Karen', 'Jones', 'Sales Representative', 'Sales'),
       (7, 'Mike', 'Johnson',  'Customer Service Representative', 'Customer Service'),
       (8, 'Samantha', 'Williams',  'HR Manager', 'Human Resources'),
       (9, 'Chris', 'Jackson',  'Software Engineer', 'Engineering'),
       (10, 'Linda', 'Green', 'Marketing Coordinator', 'Marketing');

-- Load sample data into sales table
INSERT INTO sales2.sales (sale_id, employee_id, product_name, quantity, price)
VALUES (1, 2,  'Product A', 10, 1000.00),
       (2, 5,  'Product B', 5, 500.00),
       (3, 6,  'Product C', 3, 300.00),
       (4, 1,  'Product A', 20, 2000.00),
       (5, 4,  'Product B', 8, 800.00),
       (6, 3,  'Product D', 15, 1500.00),
       (7, 2,  'Product C', 4, 400.00),
       (8, 9,  'Product B', 12, 1200.00),
       (9, 8,  'Product A', 18, 1800.00),
       (10, 7, 'Product D', 6, 600.00);

SELECT * FROM sales2.employees;
SELECT * FROM sales2.sales;

SELECT e.*
FROM sales2.employees e
LEFT JOIN sales2.sales s ON e.employee_id = s.employee_id
WHERE s.employee_id IS NULL;



----QUESTION 2--------------------------
USE BikeStores;

--lists the number of customers in each city. Only include cities with more than 3 customers:
---in our case, we shall use city to represent country.
SELECT COUNT(customer_id) AS customers, city
FROM sales.customers
GROUP BY city
HAVING COUNT(customer_id) > 3
ORDER BY COUNT(customer_id) DESC;



---QUESTION 3----------------
CREATE PROCEDURE insert_or_update_employee
    @employee_id INT,
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @job_title VARCHAR(50),
    @department VARCHAR(50)
AS
BEGIN
    -- Check if employee exists
    IF EXISTS (SELECT * FROM sales2.employees WHERE employee_id = @employee_id)
    BEGIN
        -- Update employee
        UPDATE sales2.employees
        SET first_name = @first_name,
            last_name = @last_name,
            job_title = @job_title,
            department = @department

        WHERE employee_id = @employee_id;
    END
    ELSE
    BEGIN
        -- Insert new employee
        INSERT INTO sales2.employees (employee_id, first_name, last_name, job_title, department)
        VALUES (@employee_id, @first_name, @last_name,@job_title, @department);
    END
END;

---TO UPDATE
EXEC insert_or_update_employee 1, 'John', 'Doe',  'Manager', 'Sales';

EXEC insert_or_update_employee @employee_id=1 , @first_name='John', @last_name='Doe', @job_title='Manager', @department='Sales';

---TO INSERT
EXEC insert_or_update_employee 11, 'Emily', 'Jones',  'Marketing Coordinator', 'Marketing';


--QUESTION 4---------------------
-- create dummy data
CREATE TABLE EmployeeDetails (
    EmpId INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

INSERT INTO EmployeeDetails VALUES (1, 'John', 'Doe', 'john.doe@example.com');
INSERT INTO EmployeeDetails VALUES (2, 'Jane', 'Doe', 'jane.doe@example.com');
INSERT INTO EmployeeDetails VALUES (3, 'Bob', 'Smith', 'bob.smith@example.com');
INSERT INTO EmployeeDetails VALUES (4, 'Samantha', 'Lee', 'samantha.lee@example.com');
INSERT INTO EmployeeDetails VALUES (5, 'John', 'Doe', 'john.doe2@example.com');
INSERT INTO EmployeeDetails VALUES (6, 'Bob', 'Smith', 'bob.smith2@example.com');
INSERT INTO EmployeeDetails VALUES (7, 'Jane', 'Doe', 'jane.doe2@example.com');
INSERT INTO EmployeeDetails VALUES (8, 'Samantha', 'Lee', 'samantha.lee2@example.com');
INSERT INTO EmployeeDetails VALUES (9, 'John', 'Doe', 'john.doe3@example.com');
INSERT INTO EmployeeDetails VALUES (10, 'Bob', 'Smith', 'bob.smith3@example.com');

--view data
SELECT * FROM EmployeeDetails;

-- fetch duplicate records
SELECT FirstName, LastName, Email, COUNT(*) AS NumDuplicates
FROM EmployeeDetails
GROUP BY FirstName, LastName, Email
HAVING COUNT(*) > 1;


---QUESTION 5-------------------
---DUMMY DATA
CREATE TABLE LynetteTable (
    Id INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT
);

INSERT INTO LynetteTable (Id, FirstName, LastName, Age)
VALUES (1, 'John', 'Doe', 25),
       (2, 'Jane', 'Doe', 30),
       (3, 'Bob', 'Smith', 45),
       (4, 'Alice', 'Johnson', 38),
       (5, 'Mike', 'Davis', 22),
       (6, 'Karen', 'Brown', 29),
       (7, 'David', 'Lee', 41),
       (8, 'Lisa', 'Jones', 33),
       (9, 'Sam', 'Wilson', 27),
       (10, 'Olivia', 'Taylor', 36);

SELECT * FROM LynetteTable;

--function

WITH OddRows AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY Id) AS RowNum
    FROM LynetteTable
)
SELECT *
FROM OddRows
WHERE RowNum % 2 = 1;

---QUESTION 6--------------------
CREATE FUNCTION dbo.CalculateAge (@dob DATE)
RETURNS INT
AS
BEGIN
    DECLARE @age INT

    SET @age = DATEDIFF(year, @dob, GETDATE())

    -- If the person has not yet had their birthday this year, subtract 1 from the age
    IF (DATEADD(year, @age, @dob) > GETDATE())
        SET @age = @age - 1

    RETURN @age
END
