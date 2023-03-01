-- Column Attributes

Insert Into customers
Values (default, 'John', 'Smith', '1994-01-17', Null, 'Afitap Sokak 21/9', 'New York',
		'CA', default);

Insert Into customers (first_name, last_name,
						birth_date, address, city,
                        state)
Values ('John', 'Smith', '1994-01-17', 'Afitap Sokak 21/9', 'New York',
 		'CA');



-- INSERTING MULTIPLE ROWS 
Insert Into shippers (name)
Values ("Shipper1"), ("Shipper2"), ("Shipper3");

-- EXERCISE
-- Insert Three rows in the products table
Insert Into products (name, quantity_in_stock, unit_price)
 Values ("Cake_Lemon", 24, 3.99), ("Cake_Chocolate", 25, 4.99), ("Cake_Cherry", 24, 5.99);




-- INSERTING HIERARCHİCAL ROWS
Insert Into orders (customer_id, order_date, status)
Values (1, '2019-01-02', 1); 

Insert Into order_items 
Values (LAST_INSERT_ID(), 1, 1, 2),
		(LAST_INSERT_ID(), 2, 1, 3.95);
SELECT LAST_INSERT_ID() ;







-- CREATING COPY OF A TABLE
Create Table orders_archived as 
Select * From orders;

-- Subquery
Insert Into orders_archived
Select * from orders where order_date < '2019-01-01';


Create Table invoices_archived as 
Select
i.invoice_id,
i.number,
c.name,
i.invoice_total,
i.payment_total
From invoices i
Join clients c
	Using (client_id)
Where payment_date IS NOT NULL;







-- UPDATING SINGLE ROW
Update invoices
Set payment_total = 10, payment_date = '2019-03-01'
Where invoice_id = 1;

Update invoices
Set payment_total = invoice_total * 0.5, payment_date = due_date
Where invoice_id = 1;

Update invoices
Set payment_total = invoice_total * 0.7, payment_date = due_date
Where invoice_id = 19;



-- UPDATE MULTIPLE ROWS
Update invoices
Set payment_total = invoice_total * 0.5, payment_date = due_date
Where client_id = 3;

-- EXERCISE GIVE ANY CUSTOMER born before 1990 50 extra point
Update customers
Set points = points + 50
Where birth_date < '1990-01-01';





-- USING SUBQUERIES IN UPDATES
Update invoices
Set payment_total = invoice_total * 0.5,
	payment_date = due_date
Where  client_id = 
(Select client_id
From clients
Where name = 'Myworks');

Update invoices
Set payment_total = invoice_total * 0.5,
	payment_date = due_date
Where  client_id IN
(Select client_id
From clients
Where state IN ('CA', 'NY'));


-- EXERCISE
Update orders
Set comments = 'Gold Customer'
Where customer_id IN 
(select customer_id from customers where points > 3000);

-- DELETE DATA
Delete
From invoices
Where client_id = (Select client_id From clients where name = 'Myworks');