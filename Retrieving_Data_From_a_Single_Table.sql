Use sql_store;


Select *
From customers
Where customer_id > 1
Order By first_name asc;


Select 
first_name, 
last_name, 
points, 
points + 10 as added_point -- generate custom name
From Customers;


Select DISTINCT state from customers;


-- Exercise 1 return all products
Select name, unit_price, unit_price*1.1 as new_price from store.products;


-- WHERE Clause
Use sql_store;
Select * From customers Where points > 3000;
Select * From customers where state = 'VA';
Select * from customers where state <> 'va';
Select * from customers where birth_date > '1970-01-01';

-- Exercise 2 get the orders placed this year
Select * from orders where order_date >= '2019-01-01';

-- AND OR NOT OPERATORS.
Select * from customers where birth_date > '1990-01-01' and points > 1000;
Select * from customers where not (birth_date > '1990-01-01' or points > 1000);

-- Exercise 3 from the order_items table, get the items for order 6 where total price greater 30
Select * from order_items where order_id = 6 and ((unit_price * quantity) > 30);

-- IN operator
Select * From Customers where state IN ("VA","GA","FL");
Select * From Customers where state NOT IN ("VA","GA","FL");

-- EXERCISE 4 Return products with quantity in stock equal to 49 38 72
Select * From products where quantity_in_stock IN (49,38,72);
Select * From products where quantity_in_stock between 0 and 45 order by 
quantity_in_stock asc;

-- BETWEEN OPERATOR
Select * From customers Where points between 1000 AND 3000;

-- Exercise born between 1990 2000
Select * from customers where birth_date between "1990-01-01" and "2000-01-01";


-- LIKE OPERATOR
Select * from customers where last_name LIKE 'b%';
Select * from customers where last_name LIKE '%b%';
Select * from customers where last_name LIKE '%y';
Select * from customers where last_name LIKE '____y';

-- EXERCISE get the customers whose address contain trail avenue phone numbers end 9
Select * from customers where address LIKE '%trail%' or address LIKE '%avenue%';
Select * from customers where phone LIKE '%9';


-- REGEXP operator
Select * from customers where  last_name regexp 'field';
Select * from customers where  last_name regexp 'field$';
Select * from customers where  last_name regexp 'field|mac|rose';
Select * from customers where  last_name regexp '^field|mac|rose';
Select * from customers where  last_name regexp '[gim]e';
Select * from customers where  last_name regexp '[a-h]e';

-- EXERCISE
Select * from customers where  first_name regexp 'elka|ambur';
Select * from customers where  last_name regexp 'ey$|on$';
Select * from customers where  last_name regexp '^my|se';
Select * from customers where  last_name regexp 'b[ru]';



-- IS NULL OPERATOR
Select * from customers where phone IS NOT NULL;
Select * from orders where shipped_date IS NULL;




-- ORDER BY OPERATOR
Select * from customers order by state, first_name desc;


-- EXERCISE 
Select * from order_items where order_id = 2 order by (quantity * unit_price) desc;

-- LIMIT OPERATOR
Select * from customers limit 3;
Select * from customers limit 6, 3; -- pass first 6 observation then select 3 row

-- EXERCISE Most loyal 3 customers
Select * from customers order by points desc limit 3;


