
-- TRIGGERS
Delimiter $$
Create trigger payments_after_insert
	After Insert On payments
    For each row 
Begin
	Update invoices
    Set payment_total = payment_total + NEW.amount
	Where invoice_id = NEW.invoice_id;
End $$
Delimiter ;


-- Insert into payments values (default, 5, 3, "2019-02-01",20,1) invoices triggerlandı yeni payment ekleniyor cidden




-- Trigger fired when delete payment
Delimiter $$
Create trigger payments_after_delete
	After Delete On payments
    For each row
Begin
	Update invoices
    Set payment_total = payment_total - OLD.amount
	Where invoice_id = OLD.invoice_id;
End $$
Delimiter ;

Delete from payments where payment_id = 8;
Select * From invoices;


-- VIEWING TRIGGERS
Show triggers;
-- Show triggers like "payments%" 


-- DROPPING TRIGGERS
Drop trigger if exists payments_after_insert;



-- USING TRIGGERS FOR AUDITING Create-payments-table
CREATE TABLE payments_audit (
    `client_id` int,
    `invoice_date` date,
    `amount` decimal(9,2),
    `statement_type` varchar(10),
    `timestamp` date
);

Drop trigger payments_after_insert;
Delimiter $$
Create trigger payments_after_insert
	After Insert On payments
    For each row
Begin
	Update invoices
    Set payment_total = payment_total + NEW.amount -- payments tablosunda amount var onu ekliyoz işte
	Where invoice_id = NEW.invoice_id;
    
    Insert into payments_audit
    Values (New.client_id, new.date, new.amount, "Insert", Now());
End $$
Delimiter ;

Drop trigger payments_after_delete;
Delimiter $$
Create trigger payments_after_delete
	After Delete On payments
    For each row -- her row için etkili olcak 5 yada 1 row eklemen değiştirmez 1 kere trigger olcak
Begin
	Update invoices
    Set payment_total = payment_total - OLD.amount -- payments tablosunda amount var onu ekliyoz işte
	Where invoice_id = OLD.invoice_id;
    
	Insert into payments_audit
    Values (Old.client_id, Old.date, Old.amount, "Delete", Now());
End $$
Delimiter ;

Insert into payments values (default, 5, 3, "2019-02-01",30,1);
Delete from payments where payment_id = 11;





-- EVENTS

Show variables LIKE "event%"; 
Set Global event_scheduler = OFF
Delimiter $$
Create event yearly_delete_stale_audit_rows
On schedule
    every 1 year starts "2019-01-01" ENDS "2029-01-01"
DO begin
	Delete from payments_audit
    where action_date < now() - interval 1 year;
End $$
Delimiter ;


-- VIEWING DROPPING ALTERING EVENTS 
Show events;
Show events like "yearly%";
drop event if exists yearly_delete_stale_audit_rows;
alter event yearly_delete_stale_audit_rows DISABLE;