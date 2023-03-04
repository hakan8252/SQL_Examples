-- AGGREGATE FUNCTIONS

Select
 MAX(invoice_total) as Highest,
 MIN(invoice_total) as Lowest,
 avg(invoice_total) as average
From invoices;

Select
 MAX(payment_date) as Highest,
 MIN(invoice_total) as Lowest,
 avg(invoice_total) as average,
 sum(invoice_total) as total,
 count(invoice_total) as numberof,
 count(payment_date) as payment,
 count(*) as total_number 
From invoices;

Select
 MAX(payment_date) as Highest,
 MIN(invoice_total) as Lowest,
 avg(invoice_total) as average,
 sum(invoice_total) as total,
 count(*) as total_number,
 sum(invoice_total * 1.1) as incremented,
 count(DISTINCT client_id) as total_record
From invoices
Where invoice_date > "2019-07-01";

-- EXERCISE 
Select
"First half of 2019" as date_range,
sum(invoice_total) as total_sales,
sum(payment_total) as total_payment,
sum(invoice_total - payment_total) as what_we_expect -- bu da doğru
From invoices
Where invoice_date between "2019-01-01" and "2019-06-30"
Union
Select
"Second half of 2019" as date_range,
sum(invoice_total) as total_sales,
sum(payment_total) as total_payment,
(sum(invoice_total) - sum(payment_total)) as what_we_expect
From invoices
Where invoice_date between "2019-07-01" and "2019-12-31"
Union
Select
"Total" as date_range,
sum(invoice_total) as total_sales,
sum(payment_total) as total_payment,
(sum(invoice_total) - sum(payment_total)) as what_we_expect
From invoices
Where invoice_date between "2019-01-01" and "2019-12-31";



-- THE GROUP BY
Select
client_id,
Sum(invoice_total) as total_sales
From invoices
Join clients
using(client_id)
Where invoice_date >= "2019-07-01"
group by client_id
Order by total_sales Desc;

Select
state,
city,
Sum(invoice_total) as total_sales
From invoices
Join clients using(client_id)
Where invoice_date >= "2019-07-01"
group by state,city
Order by total_sales Desc;


-- EXERCISE
Select
pa.date,
pm.name,
Sum(pa.amount) as total_payments
From payments pa
Join payment_methods pm
On pa.payment_method = pm.payment_method_id
group by pa.date, pm.name
order by date;





-- HAVING CLAUSE

Select 
client_id,
SUM(invoice_total) as total_sales,
count(*) as number_of_invoices
From invoices
-- Where total_sales > 500 -- this cannot be used since it is before grouping process
group by client_id
having total_sales > 500 and number_of_invoices > 5;

Select
client_id,
sum(payment_total) as total_pay
From invoices i
group by client_id
having total_pay > 0;



-- EXERCISE customers located in virginia who have spent more than 100 and less than 1100
Select 
c.customer_id,
c.first_name,
c.last_name,
SUM(oi.quantity * oi.unit_price) as total_sales -- 
From customers c-- sql_store database
Join orders o
Using(customer_id)
Join order_items oi
Using(order_id)
Where state IN ("VA", "TX", "FL", "GA", "CT")
group by c.customer_id, c.first_name, c.last_name
Having total_sales > 100 and total_sales < 1100;


-- ROLLUP operator
Select 
state,
city,
SUM(invoice_total) as total_sales
From invoices i
Join clients c 
Using (client_id)
Group By state, city with Rollup;
-- Group By client_id with ROLLUP;
 
 
-- EXERCISE

Select 
pm.name,
SUM(pa.amount) as total
From payments pa
Join payment_methods pm
On pa.payment_method = pm.payment_method_id
Group By pm.name with Rollup;
