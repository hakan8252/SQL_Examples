Select order_id, first_name, last_name, orders.customer_id
 from orders 
 Join customers
 On orders.customer_id = customers.customer_id;


Select order_id, first_name, last_name, O.customer_id
 from orders O 
 Join customers C
 On O.customer_id = C.customer_id;


-- EXERCISE order_items ve products
Select order_id, O.product_id, quantity, O.unit_price
 from order_items O 
 Join products P
 On O.product_id = P.product_id;
 
 
Select *
From order_items oi
Join sql_inventory.products p
On oi.product_id = p.product_id;
 
 

-- SELF JOIN
Use sql_hr;

Select 
e.employee_id,
e.first_name as employee_name,
m.first_name as manager_name
FROM employees e
JOIN employees m
On e.reports_to = m.employee_id;



-- JOINING MULTIPLE TABLES

Select 
o.order_id,
o.order_date,
c.first_name,
c.last_name,
os.name AS Status_name
From orders o
Join customers c
	On o.customer_id = c.customer_id
Join order_statuses os
	On o.status = os.order_status_id;



-- EXERCISE sql_invoice payments, payment method, clients table
Select 
cl.name,
p.invoice_id,
p.date,
p.amount,
pm.name as payment_method_name
From payments p
Join clients cl
	On p.client_id = cl.client_id
Join payment_methods pm
	On pm.payment_method_id = p.payment_method;
    
    
    

-- COMPOUND JOIN CONDITIONS
 -- SQL store database
 Select * 
 From order_items oi
 Join order_item_notes oin
	On oi.order_id = oin.order_id
    And oi.product_id = oin.product_id;
    
    
-- IMPLICIT JOIN SNYTAX
Select * 
From orders o
Join customers c
	On o.customer_id = c.customer_id;

-- Implicit
Select * 
From orders o, customers c
Where o.customer_id = c.customer_id;


-- OUTER JOIN sql store
Select 
c.customer_id,
c.first_name,
o.order_id
From customers c
Join orders o 
	On c.customer_id = o.customer_id
Order By c.customer_id;

-- Join types left right join
Select 
c.customer_id,
c.first_name,
o.order_id
From customers c
Left Join orders o 
	On c.customer_id = o.customer_id
Order By c.customer_id;

-- EXERCISE product_id, name, quantity
Select 
p.product_id,
p.name,
oi.quantity
From products p
Left Join order_items oi -- no orders but have shippers
	On p.product_id = oi.product_id
Order By p.product_id;


-- OUTER JOIN BETWEEN MULTIPLE TABLES
Select 
c.customer_id,
c.first_name,
o.order_id,
sh.name as shipper
From customers c
Left Join orders o 
	On c.customer_id = o.customer_id
Left Join shippers sh 
	On o.shipper_id = sh.shipper_id
Order By c.customer_id;

-- EXERCISE
Select 
o.order_date,
o.order_id,
c.first_name,
sh.name as shipper,
os.name as status_n
From customers c
Join orders o 
	On c.customer_id = o.customer_id
Left Join shippers sh
	On o.shipper_id = sh.shipper_id
Join order_statuses os
	On o.status = os.order_status_id
Order By os.name;




-- Self Outer Joins Sql_hr
Select 
e.employee_id,
e.first_name,
m.first_name as manager_name
From employees e
Left Join employees m
	On e.reports_to = m.employee_id;


-- USING CLAUSE sql_store

Select 
o.order_id,
c.first_name,
sh.name As shipper
From orders o
Join customers c 
	-- On o.customer_id = c.customer_id
	Using (customer_id)
Left Join shippers sh
	Using (shipper_id);


-- EXERCISE sql_invoicing
Select 
p.date,
c.name,
p.amount,
pm.name as payment_type
From payments p
Join clients c 
	Using (client_id)
Join payment_methods pm
	On pm.payment_method_id = p.payment_method;


Select 
c.name,
c.address,
c.city,
inv.invoice_total,
inv.invoice_date,
ia.number
From clients c
Join invoices inv
	Using (client_id)
Join invoices_archived ia
	On inv.invoice_id = ia.invoice_id
Where inv.invoice_total > 160;



-- UNIONS sql_store
Select 
order_id,
order_date,
'Active' as status
From orders
Where order_date >= '2019-01-01'
Union
Select 
order_id,
order_date,
'Archived' as status
From orders
Where order_date < '2019-01-01';



-- EXERCISE customer_id, first_name, points, type
Select 
customer_id, 
first_name,
points,
'Bronze' as type_customer 
From customers
Where points < 2000
Union
Select 
customer_id, 
first_name,
points,
'Silver' as type_customer 
From customers
Where points between 2000 and 3000
Union
Select 
customer_id, 
first_name,
points,
'Gold' as type_customer 
From customers
Where points > 3000
Order By first_name




