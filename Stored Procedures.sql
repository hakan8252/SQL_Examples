-- STORED PROCEDURES
-- Store organize sql
-- Optimizasyon faster execution data security 
-- View is simple showcasing data stored in the database tables
--  whereas a stored procedure is a group of statements that can be executed.
--  A view is faster as it displays data from the tables referenced whereas a
--  store procedure executes sql statements
Delimiter $$
Create procedure get_clients()
Begin
	Select * from clients;
End$$
Delimiter ;

call Get_clients();
-- Store procedure called get_invoices_with_balance to return all invoices with balance > 0

Delimiter $$
Create procedure get_invoices_with_balance()
Begin
	Select *,
    (invoice_total - payment_total) as balance
    From invoices
    Where invoice_total - payment_total > 0;
End$$
Delimiter ;

Call get_invoices_with_balance();


Delimiter $$
Create procedure get_customers_point_upper_thousand()
Begin
	Select *,
    (points * 2) as doubled_point
    From customers
    Where (points * 2) > 1000;
End$$
Delimiter ;

Call get_customers_point_upper_thousand();


-- Drop STORED PROCEDURE
Drop procedure get_clients;
Drop procedure if exists get_clients;






-- PARAMETERS
Drop procedure if exists get_clients_by_state;

Delimiter $$
Create procedure get_clients_by_state(
	state char(2) -- Varchar 
)
Begin
	Select * from clients c
    Where c.state = state;
End$$
Delimiter ;

call get_clients_by_state("NY");



-- Stored procedure return invoices for a given client
Drop procedure if exists get_invoices_by_client;

Delimiter $$
Create procedure get_invoices_by_client(
	client_id INT
)
Begin
	Select * from invoices i
    Where i.client_id = client_id;
End$$
Delimiter ;

call get_invoices_by_client(5);





-- PARAMETER DEFAULT VALUE

Drop procedure if exists get_clients_by_state;

Delimiter $$
Create procedure get_clients_by_state(
	state char(2) -- Varchar 
)
Begin
	IF state is null then
		Set state = "CA";
        End if;
	Select * from clients c
    Where c.state = state;
End$$
Delimiter ;

call get_clients_by_state(NULL);


Drop procedure if exists get_clients_by_state;
Delimiter $$
Create procedure get_clients_by_state(
	state char(2) -- Varchar 
)
Begin
	IF state is null then
		Select * from clients;
    Else
		Select * from clients c
        where c.state = state;
	End if;
End$$
Delimiter ;

call get_clients_by_state(NULL);


-- Alternative Way
Drop procedure if exists get_clients_by_state;
Delimiter $$
Create procedure get_clients_by_state(
	state char(2) -- Varchar 
)
Begin
	Select * from clients c
    Where c.state = ifnull(state, c.state);
End$$
Delimiter ;

call get_clients_by_state(NULL);



-- Write stored procedure called get_payments
-- two parameters client_id int payment method_id tinyint
-- 

Drop procedure if exists get_payments;
Delimiter $$
Create procedure get_payments(
	client_id INT,
 payment_method_id TINYINT
)
Begin
	Select * from payments p
    Where p.client_id = ifnull(client_id, p.client_id) and 
    p.payment_method = ifnull(payment_method_id, p.payment_method);
End$$
Delimiter ;

call get_payments(null, null);
call get_payments(5, null);
-- call get_payments(5, 2)







-- PARAMETER VALIDATION

Drop procedure if exists get_payments;
Delimiter $$
Create procedure make_payment(
	invoice_id INT,
    payment_amount Decimal(9, 2),
	payment_date DATE
)
Begin
	Update invoices i
	Set
    i.payment_total = payment_amount,
    i.payment_date = payment_date
    Where i.invoice_id = invoice_id;
End$$
Delimiter ;

call make_payment(3, 55.44, "2021-01-01");


Drop procedure if exists make_payment;
Delimiter $$
Create procedure make_payment(
	invoice_id INT,
    payment_amount Decimal(9, 2), 
	payment_date DATE
)
Begin
	IF payment_amount <= 0 then
		Signal SQLSTATE "22003"
        Set Message_Text = "Invalid payment amount";
	End if;
	Update invoices i
	Set
    i.payment_total = payment_amount,
    i.payment_date = payment_date
    Where i.invoice_id = invoice_id;
End$$
Delimiter ;
-- data exception 22003 numeric range out

call make_payment(3, -155, "2019-01-01");
















-- OUTPUT PARAMETERS

Delimiter $$
Create procedure get_unpaid_invoices_for_client(
	client_id INT
)
Begin
	Select 
    count(*),
    sum(invoice_total)
    From invoices i
    Where i.client_id = client_id
    And payment_total = 0; -- get_unpaid_invoices_for_client
End$$
Delimiter ;

call get_unpaid_invoices_for_client(3);



Drop procedure if exists get_unpaid_invoices_for_client;
Delimiter $$
Create procedure get_unpaid_invoices_for_client(
	 IN client_id INT,
    OUT invoices_count INT,
    OUT invoices_total Decimal(9,2)
)
Begin
	Select 
    count(*),
    sum(invoice_total)
    INTO invoices_count, invoices_total
    From invoices i
    Where i.client_id = client_id
    And payment_total = 0;
End$$
Delimiter ;











-- VARİABLES 
-- User or session variables
Set @invoices_count = 0

-- Local variable 
Delimiter $$
Create procedure get_risk_factor()
Begin
   -- risk_factor = invoices_total / invoices_count * 5
	Declare risk_factor decimal(9,2) default 0;
    Declare invoices_total decimal (9,2);
    Declare invoices_count INT;
    
    Select count(*), sum(invoice_total)
    INTO invoices_count, invoices_total
    From invoices;
    
    Set risk_factor = invoices_total / invoices_count * 5;
    Select risk_factor;
End$$
Delimiter ;

call get_risk_factor();









-- FUNCTIONS

Delimiter $$
Create Function get_risk_factor_for_client(
client_id INT
)
Returns Integer
-- -- Deterministic
Reads Sql Data
-- -- Modifies Sql Data -- insert update delete
Begin
	Declare risk_factor decimal(9,2) default 0; 
    Declare invoices_total decimal (9,2);
    Declare invoices_count INT;
    
    Select count(*), sum(invoice_total)
    INTO invoices_count, invoices_total
    From invoices i
    Where i.client_id = client_id;
    
    Set risk_factor = invoices_total / invoices_count * 5;
	Return ifnull(risk_factor,0);
End $$
Delimiter ; 

Select 
	client_id,
    name,
    get_risk_factor_for_client (client_id) as risk_factor 
From clients;

DROP FUNCTION IF EXISTS get_risk_factor_for_client;

