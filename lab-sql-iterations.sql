# 1.  Write a query to find what is the total business done by each store.

SELECT i.store_id, SUM(p.amount) AS total_business FROM payment p
	JOIN rental r ON p.rental_id = r.rental_id
	JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id;

# 2. Convert the previous query into a stored procedure.

DROP PROCEDURE IF EXISTS total_business;
DELIMITER //
CREATE PROCEDURE total_business()
BEGIN
SELECT i.store_id, SUM(p.amount) AS total_business FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id;
END;
//
DELIMITER;
CALL total_business();

# 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DROP PROCEDURE IF EXISTS total_business_input;
DELIMITER //
CREATE PROCEDURE total_business_input(IN param1 INTEGER)
BEGIN
SELECT i.store_id , SUM(p.amount) AS total_business FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE store_id = param1
GROUP BY store_id;
END;
//
DELIMITER;
CALL total_business_input("1");

# 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store).
# 4a) Call the stored procedure and print the results.

DELIMITER //
create procedure total_sales_value (in store_id int)
begin
	declare total_sales_value float;
	select sum(p.amount) into total_sales_value
    from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
    select total_sales_value; 
 end //
DELIMITER ;
call total_per_store_var(2);
 
# 4b)In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
# 4c) Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DELIMITER //
create procedure total_per_store_var_flag(in store_id int)
begin
	declare total_sales_value float;
    declare flag varchar(10) default "";
	select sum(p.amount) into total_sales_value
    from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
    
    if total_sales_value >= 30000 then
		set flag = 'Green';
	else
		set flag = 'Red';
	end if;
    
    
    select total_sales_value, flag; 
 end //
DELIMITER ;
call total_per_store_var_flag(2);
