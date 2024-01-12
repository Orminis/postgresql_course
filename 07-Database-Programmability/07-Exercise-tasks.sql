-- 01.User-defined Function Full Name

CREATE OR REPLACE FUNCTION fn_full_name(
	first_name VARCHAR(50)
	,last_name VARCHAR(50)
)
RETURNS VARCHAR(101)
AS
$$
	DECLARE
		full_name VARCHAR(101);
	BEGIN
		IF 
			first_name IS NULL AND last_name IS null THEN
				RETURN null;
		ELSEIF 
			first_name IS NULL THEN
				RETURN last_name;
		ELSEIF 
			last_name IS NULL THEN
				RETURN first_name;
		ELSE
			full_name := CONCAT(INITCAP(first_name), ' ', INITCAP(last_name));
			RETURN full_name;
		END IF;
	END;
$$
LANGUAGE plpgsql
;
SELECT fn_full_name('fred', 'sanford');
SELECT fn_full_name('', 'SIMPSONS');
SELECT fn_full_name('JOHN', '');
SELECT fn_full_name(NULL, NULL);


-- Second variant
CREATE OR REPLACE FUNCTION fn_full_name(
	first_name VARCHAR(50)
	,last_name VARCHAR(50)
)
RETURNS VARCHAR(101)
AS
$$
	DECLARE
		full_name VARCHAR(101);
	BEGIN
		full_name := CONCAT(INITCAP(first_name), ' ', INITCAP(last_name));
		RETURN full_name;
	END;
$$
LANGUAGE plpgsql
;

-- 02.User-defined Function Future Value

DROP FUNCTION fn_calculate_future_value;

CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	initial_sum DECIMAL
	, yearly_interest_rate DECIMAL
	, number_of_years INT)
RETURNS DECIMAL
AS
$$
	DECLARE
		future_value DECIMAL;
	BEGIN
		future_value := initial_sum * (POWER((1 + yearly_interest_rate), number_of_years));
		RETURN TRUNC(future_value, 4);
	END;
$$
LANGUAGE plpgsql
;
SELECT fn_calculate_future_value (1000, 0.1, 5);
SELECT fn_calculate_future_value (2500, 0.30, 2);
SELECT fn_calculate_future_value (500, 0.25, 10);
SELECT fn_calculate_future_value (1400, 0.15, 5);


-- 03.User-defined Function Is Word Comprised

-- DROP FUNCTION fn_is_word_comprised;

CREATE OR REPLACE FUNCTION fn_is_word_comprised(
	set_of_letters VARCHAR(50)
	,word VARCHAR(50)
	)
RETURNS BOOLEAN
AS
$$		
	BEGIN
		RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
	END;
$$
LANGUAGE plpgsql
;


-- With For loop
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
	set_of_letters VARCHAR(50)
	,word VARCHAR(50)
	)
RETURNS BOOLEAN
AS
$$	
	DECLARE
		i INT;
		letter VARCHAR;
	BEGIN
		FOR i IN 1..length(word) LOOP
			letter := substring(lower(word), i, 1);
			IF position(letter IN lower(set_of_letters)) = 0 THEN
				RETURN FALSE;
			END IF;
		END LOOP;
		
		RETURN TRUE;
	END;
$$
LANGUAGE plpgsql
;

SELECT fn_is_word_comprised('ois tmiah%f', 'halves');
SELECT fn_is_word_comprised('ois tmiah%f', 'Sofia');
SELECT fn_is_word_comprised('bobr', 'Rob');
SELECT fn_is_word_comprised('papopep', 'toe');
SELECT fn_is_word_comprised('R@o!B$B', 'Bob');

-- 04.Game Over

CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE(
	"name" VARCHAR(50)
	,game_type_id INT
	,is_finished BOOLEAN
	)
AS
$$
	BEGIN
		RETURN QUERY
		SELECT 
			g.name
			,g.game_type_id
			,g.is_finished
		FROM games as g
		WHERE g.is_finished = is_game_over;
	END;
$$
LANGUAGE plpgsql
;


-- 05. Difficulty Level


CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
RETURNS VARCHAR(50)
AS
$$
	DECLARE
		dif_level VARCHAR(50);
	BEGIN
		IF (level <= 40) THEN
			dif_level := 'Normal Difficulty';
		ELSEIF (level > 40) AND (level <= 60) THEN
			dif_level := 'Nightmare Difficulty';
		ElSEIF (level > 60) THEN
			dif_level := 'Hell Difficulty';
		END IF;
		RETURN dif_level;
	END;
$$
LANGUAGE plpgsql
;

SELECT 
	ug.user_id
	,ug.level
	,ug.cash
	,fn_difficulty_level(ug.level)

FROM 
	users_games AS ug

ORDER BY ug.user_id

-- 06. * Cash in User Games Odd Rows

CREATE OR REPLACE FUNCTION fn_cash_in_users_games (
	game_name VARCHAR(50)	
)
RETURNS TABLE (
	total_cash NUMERIC
)
AS
$$
	BEGIN
		RETURN QUERY
		WITH ranked_games AS (
			SELECT
				cash
				,ROW_NUMBER() OVER 
					(ORDER BY cash DESC) AS row_num
			FROM 
				users_games AS ug
			JOIN
				games AS g
			ON 
				ug.game_id = g.id
			WHERE 
				g.name = game_name
		)
		
		SELECT
			ROUND(SUM(cash), 2) AS total_cash
		FROM 
			ranked_games 
		WHERE 
			row_num % 2 <> 0;
	END;
$$
LANGUAGE plpgsql
;

SELECT * FROM fn_cash_in_users_games('Love in a mist');
SELECT * FROM fn_cash_in_users_games('Delphinium Pacific Giant');

-- 07. Retrieving Account Holders
CREATE PROCEDURE sp_retrieving_holders_with_balance_higher_than(
	searched_balance NUMERIC
)
AS
$$
	DECLARE
		holder_info RECORD;
	BEGIN
		FOR holder_info IN 
			SELECT 
				CONCAT(ah.first_name, ' ', ah.last_name) AS full_name
				,SUM(balance) AS total_balance
			FROM 
				account_holders AS ah
			JOIN
				accounts AS a
			ON 
				ah.id = a.account_holder_id
			GROUP BY
				full_name
			HAVING 
				SUM(balance) > searched_balance
			ORDER BY 
				full_name ASC
		LOOP
			RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
		END LOOP;	
	END
$$
LANGUAGE plpgsql;

CALL sp_retrieving_holders_with_balance_higher_than(250000);

-- 08. Deposit Money

CREATE OR REPLACE PROCEDURE sp_deposit_money(
	account_id INT
	,amount_money NUMERIC(10, 4)
)
AS 
$$
	BEGIN
		UPDATE accounts
		SET balance = balance + amount_money
		WHERE id = account_id ;
		
		-- COMMIT
	END;
$$
LANGUAGE plpgsql;

-- 

SELECT 
	account_holder_id
	,balance
FROM accounts
	WHERE account_holder_id = 2
ORDER BY 
	account_holder_id ASC;

CALL sp_deposit_money(1, 200);
CALL sp_deposit_money(2, 500);
CALL sp_deposit_money(4, 1000);

-- 09. Withdraw Money
CREATE OR REPLACE PROCEDURE sp_transfer_money(
	sender_id INT
	,receiver_id INT
	,amount NUMERIC
)
AS 
$$
DECLARE 
	current_balance NUMERIC;
BEGIN
	CALL sp_withdraw_money(sender_id, amount);
	CALL sp_deposit_money(receiver_id, amount);
	
	SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;
	
	IF current_balance < 0 THEN
		ROLLBACK;
	END IF;
END
$$
LANGUAGE plpgsql;

CALL sp_transfer_money(5, 1, 5000.0000)
;
SELECT * FROM accounts

-- 11. Drop Procedure

DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than

-- 12. Log Accounts Trigger

CREATE TABLE logs(
	id SERIAL PRIMARY KEY
	,account_id INT
	,old_sum NUMERIC(20, 4)
	,new_sum NUMERIC(20, 4)
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO 
		logs(account_id, old_sum, new_sum)
	VALUES(OLD.id, OLD.balance, NEW.balance);
	
	RETURN NEW;
END
$$

LANGUAGE plpgsql;

CREATE TRIGGER
	tr_account_balance_change
AFTER UPDATE 
	OF balance ON accounts
FOR EACH ROW
WHEN 
	(NEW.balance <> OLD.balance)
EXECUTE FUNCTION 
	trigger_fn_insert_new_entry_into_logs();
	
	
-- 13. Notification Email on Balance Change
CREATE TABLE notification_emails(
	"id" SERIAL PRIMARY KEY
	,"recipient_id" INT
	,"subject" VARCHAR(255)
	,"body" TEXT
);

CREATE OR REPLACE FUNCTION
	trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO
		notification_emails(recipient_id, subject, body)
	VALUES(
		NEW.account_id 
		,'Balance Change for account: ' || NEW.account_id
		,'On ' || DATE() || 'your balance was changed from '|| NEW.old_sum || 'to' || NEW.new_sum || '.'
		
 	);
	
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON logs
FOR EACH ROW 
WHEN (OLD.new_sum <> NEW.new_sum)
EXECUTE FUNCTION trigger_fn_send_email_on_balance_change();
