-- trigger implementation for scd2--
CREATE TABLE records ( record_id INT,
					 record_name VARCHAR(100),
					 record_value INT,
					 date_start timestamp DEFAULT NOW(),
					 date_end timestamp DEFAULT NULL,
					 PRIMARY KEY(record_id, record_name, date_start));

INSERT INTO records (record_id, record_name, record_value)
VALUES (1, 'r1', 30), (2, 'r2', 42);

SELECT * FROM records

CREATE OR REPLACE FUNCTION public.scd2()
returns trigger
AS $BODY$
		BEGIN
				update records
				set date_end = now()
				WHERE record_name = new.record_name
				AND date_end IS NULL;
				RETURN NEW;
		END;
$BODY$
LANGUAGE plpgsql;
	
CREATE TRIGGER example_trigger before INSERT ON records
FOR EACH ROW EXECUTE PROCEDURE SCD2();

INSERT INTO RECORDS (record_id, record_name, record_value)
VALUES (1, 'r1', 45);

SELECT * FROM records;
--
DROP TABLE IF EXISTS records;
DROP TRIGGER IF EXISTS example_trigger ON records;
DROP FUNCTION IF EXISTS public.scd2()