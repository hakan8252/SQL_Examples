-- Creating Views

Create view sales_by_client as
Select
	c.client_id,
    c.name,
    sum(invoice_total) as total_sales
from clients c
join invoices i using (client_id)
group by client_id, name;

select *
From sales_by_client
order by total_sales desc;

select *
From sales_by_client
Join clients using (client_id);


-- Exercise see balance for each client client_id name balance(payment_total-invoice total)
Create View clients_balance as
Select 
c.client_id,
c.name,
sum(i.invoice_total - i.payment_total) as balance
From clients c 
Join invoices i 
Using (client_id)
Group by client_id, name;

Select * from clients_balance;


Select 
 client_id,
 name,
 (Select sum(invoice_total) from invoices
 Where client_id = c.client_id) as total_sales,
 (Select avg(invoice_total) from invoices) as average,
 (Select total_sales - average) as difference
 From clients c
Having `total_sales` > 0;







-- ALTER DROP VIEWS

Drop view clients_balance;

Create or replace View clients_balance as
Select 
c.client_id,
c.name,
sum(i.invoice_total - i.payment_total) as balance
From clients c 
Join invoices i 
Using (client_id)
Group by client_id, name;



-- UPDATABLE VİEWS
Select * from sales_by_client;

Create or replace view invoices_with_balance as 
Select
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total as balance,
    invoice_date,
    due_date,
    payment_date
From invoices
Where (invoice_total - payment_total) > 0;

Delete from invoices_with_balance where invoice_id = 1;

Update invoices_with_balance
Set due_date = Date_add(due_date, Interval 2 day)
Where invoice_id = 2;





-- WITH OPTION CHECK
Update invoices_with_balance
Set payment_total = invoice_total
Where invoice_id = 2;


Create or replace view invoices_with_balance as 
Select
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total as balance,
    invoice_date,
    due_date,
    payment_date
From invoices
Where (invoice_total - payment_total) > 0
With check option;

Update invoices_with_balance
Set payment_total = invoice_total
Where invoice_id = 3;
