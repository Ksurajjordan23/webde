CREATE TABLE fact_contracts(date DATE NOT NULL,
						   brand_id INTEGER NOT NULL,
						   customers INTEGER,
						   valid_from DATE NOT NULL,
						   valid_to DATE,
						   state_id INTEGER NOT NULL);

INSERT INTO fact_contracts (date, brand_id, customers,
						   valid_from, valid_to, state_id)
						   VALUES ('01.05.2022', 1, 5, '02.05.2022', NULL,
								   1), ('01.05.2022', 2, 2, '02.05.2022', NULL, 1);

CREATE TABLE dim_brands(id INTEGER NOT NULL,
					   brand VARCHAR(20) NOT NULL,
					   marke VARCHAR(20) NOT NULL);

INSERT INTO dim_brands (id, brand,marke) VALUES (1,'GMX', 'gmx'),
						(2, 'WEB.DE', 'webde');
						
CREATE TABLE dim_state (id INTEGER NOT NULL,
					   status VARCHAR(20) NOT NULL);
INSERT INTO dim_state (id, status) VALUES (1 , 'current'),(2, 'historical');

CREATE TABLE staging_contracts (vertragsdatum DATE NOT NULL,
							   marke VARCHAR(20) NOT NULL,
							   kundennummer INTEGER NOT NULL);
							   
INSERT INTO staging_contracts (vertragsdatum, marke, kundennummer) VALUES
('01.05.2022', 'gmx', 134), ('01.05.2022', 'gmx', 42), ('01.05.2022','gmx', 751),
('01.05.2022', 'webde', 231);

SELECT * FROM staging_contracts;
SELECT * FROM fact_contracts;
--1--
--using cte--

WITH u AS(
			UPDATE fact_contracts fc
			SET state_id = 2,
				valid_to = '04.05.2022'
			FROM staging_contracts sc
			WHERE fc.date = sc.vertragsdatum AND fc.state_id = 1),
n_customers AS (
			SELECT COUNT (marke) AS customers, marke, dim_brands.id AS brand_id FROM staging_contracts sc
			JOIN dim_brands USING(marke)
			GROUP BY marke, dim_brands.id)
			INSERT INTO fact_contracts (date, brand_id, customers, valid_from, valid_to, state_id)
			SELECT fact_contracts.date, n_customers.brand_id, n_customers.customers, '05.05.2022', NULL, 1 FROM
			staging_contracts sc JOIN n_customers USING(marke) JOIN fact_contracts USING(brand_id) GROUP BY state_id, fact_contracts.date,
			n_customers.brand_id, n_customers.customers;
			
--2--
SELECT * FROM fact_contracts;


