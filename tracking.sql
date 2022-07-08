--Tracking--
CREATE TABLE pageviews (Timestamp TIME NOT NULL,
					   Userid INTEGER NOT NULL,
					   Page VARCHAR(255) NOT NULL)
					   
INSERT INTO pageviews (Timestamp, Userid, Page)
VALUES ('14:01', 1, 'Homepage'), ('14:02', 1, 'Registrierung'),
('14:03', 1, 'Registrierung'),('14:05', 1, 'Mail'),
('15:01', 2, 'Homepage'),('15:03', 2, 'Mail'),('16:01',2, 'Homepage'),
('16:03', 2, 'Mail')

SELECT * FROM pageviews
--1A-- TRACKING
SELECT COUNT (DISTINCT timestamp) as impressions, page FROM pageviews
GROUP BY page
ORDER BY impressions DESC
--2--
SELECT COUNT(DISTINCT userid) as no_of_users_opened FROM pageviews
WHERE page = 'Homepage'
--3--
SELECT COUNT(DISTINCT userid) AS no_of_users_opened FROM pageviews
WHERE page = 'Homepage' INTERSECT SELECT COUNT(DISTINCT userid) AS no_of_users_opened
FROM pageviews WHERE page = 'Mail'
--4--
SELECT COUNT(*) FROM
(SELECT *, LEAD(page,1) OVER(PARTITION BY userid ORDER BY timestamp) AS pages_viewed
FROM pageviews) AS home_to_mail
WHERE page = 'Homepage' AND pages_viewed = 'Mail'

