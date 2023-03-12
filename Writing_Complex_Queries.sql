-- WRITING COMPLEX QUERIES


-- Find products that are more expensive than lettuce (id = 3)
Select *
From products
Where unit_price > (
	Select unit_price
    From products
    Where product_id = 3
);

-- Sql hr database find employees whose earn more than average

Select *
From employees
Where salary > (
	Select Avg(salary)
    From employees
);


-- IN OPERATOR
-- Find products that have never ordered
Select * 
From products
Where product_id NOT IN (
	Select
	distinct product_id 
	From order_items
);

-- Find client without invoices sqlinvoice
Select * 
From clients
Where client_id NOT IN (
	Select
	distinct client_id 
	From invoices
);




-- SUBQUERIES VS JOINS
Select * 
From clients
Where client_id NOT IN (
	Select
	distinct client_id 
	From invoices
);

Select * 
From clients
Left Join invoices Using (client_id)
Where invoice_id is null;


-- Find customers who have ordered lettuce (id 3 )
Select 
Distinct c.customer_id,
c.first_name,
c.last_name
From customers c
Join orders o Using (customer_id)
Join order_items oi Using (order_id)
Where oi.product_id = 3;

-- SUBQUERY 
Select 
c.customer_id,
c.first_name,
c.last_name
From customers c
Where customer_id IN (
	select 
    o.customer_id
    From order_items oi
    Join orders o using (order_id)
    where product_id = 3
);


-- THE ALL KEYWORD
Select * 
From invoices
Where invoice_total > (
Select 
Max(invoice_total)
From invoices 
Where client_id = 3
);
-- Alternative way
Select * 
From invoices
Where invoice_total > ALL(
	Select invoice_total
    From invoices
    Where client_id = 3 
);






-- THE ANY KEYWORD
Select client_id, Count(*)
From invoices
Group by client_id
Having Count(*) >= 2;

Select *
From clients
Where client_id in (
Select client_id
From invoices
Group by client_id
Having Count(*) >= 2
);

-- Alternative way
Select *
From clients
Where client_id = ANY(
Select client_id
From invoices
Group by client_id
Having Count(*) >= 2
);


-- CORRELATED SUBQUERIES
-- select employees whose salary above average
Select *,
(Select Avg(salary) From employees  Where office_id = e.office_id) as average
From employees e
Where salary > (
	Select Avg(salary)
    From employees
    Where office_id = e.office_id 
);


-- INVOISES get invoices that are larger than the clients avg invoice amount
Select *,
(Select avg(invoice_total) From invoices Where client_id = i.client_id) as average
From invoices i
Where invoice_total > (
	Select avg(invoice_total)
    From invoices
    Where client_id = i.client_id
);




-- EXIST OPERATOR
-- SELECT CLİENTS THAT HAVE INVOİCE
Select * 
From clients
Where client_id in (
	Select Distinct client_id
    From invoices
);

Select * 
From clients c
Where Exists (
	Select client_id 
    From invoices
    Where client_id = c.client_id
);
-- WHETHER any rows match



-- PRODUCTS NEVER BEEN ORDERED sql store

Select *
From products 
Where product_id NOT IN (
	Select product_id
    From order_items
);

-- Alternative way
Select *
From products p
Where Not Exists (
	Select product_id
    From order_items
    Where product_id = p.product_id
);









-- SELECT SUBQUERY İLE
Select 
invoice_id,
invoice_total,
(Select Avg(invoice_total) from invoices) as invoice_average,
-- Avg(invoice_total),
invoice_total - (select invoice_average) as difference
From invoices;



-- sql invoice

Select 
client_id,
name,
(Select sum(invoice_total) from invoices
Where client_id = c.client_id) as total_sales,
(Select avg(invoice_total) from invoices) as average,
(Select total_sales - average) as difference,
(Select difference * 2) as multiplied_difference
From clients c;



-- SUBQUERIES FROM CLAUSE
Select * 
From (
 Select 
 client_id,
 name,
 (Select sum(invoice_total) from invoices
 Where client_id = c.client_id) as total_sales,
 (Select avg(invoice_total) from invoices) as average,
 (Select total_sales - average) as difference
 From clients c
) as sales_summary 
Where total_sales is not null;
