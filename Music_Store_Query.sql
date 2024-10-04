/*	Question Set 1 - Easy */

/* Q1: Find the employee with the highest job seniority based on job level. */

SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1;


/* Q2: Identify the countries with the highest number of invoices. */

SELECT COUNT(*) AS invoice_count, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;


/* Q3: Retrieve the top 3 highest invoice totals. */

SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;


/* Q4: Which city has generated the most revenue? We need to know where to host a promotional Music Festival. */

SELECT billing_city, SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;


/* Q5: Find the customer who has spent the most money. */

SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;



/* Question Set 2 - Moderate */

/* Q1: List the email, first name, and last name of all Rock music listeners, ordered alphabetically by email. */

/* Method 1 */
SELECT DISTINCT c.email, c.first_name, c.last_name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoiceline il ON i.invoice_id = il.invoice_id
WHERE il.track_id IN (
    SELECT t.track_id FROM track t
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE g.name = 'Rock'
)
ORDER BY c.email;


/* Method 2 */
SELECT DISTINCT c.email AS Email, c.first_name AS FirstName, c.last_name AS LastName, g.name AS Genre
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
JOIN invoiceline il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;


/* Q2: List the top 10 artists based on the number of rock tracks. */

SELECT a.artist_id, a.name, COUNT(*) AS track_count
FROM track t
JOIN album al ON al.album_id = t.album_id
JOIN artist a ON a.artist_id = al.artist_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY track_count DESC
LIMIT 10;


/* Q3: Return all tracks longer than the average song length, ordered by duration. */

SELECT t.name, t.milliseconds
FROM track t
WHERE t.milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY t.milliseconds DESC;



/* Question Set 3 - Advanced */

/* Q1: Calculate how much each customer has spent on the top-selling artist. */

WITH top_artist AS (
	SELECT a.artist_id, a.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_sales
	FROM invoice_line il
	JOIN track t ON t.track_id = il.track_id
	JOIN album al ON al.album_id = t.album_id
	JOIN artist a ON a.artist_id = al.artist_id
	GROUP BY a.artist_id
	ORDER BY total_sales DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, ta.artist_name, SUM(il.unit_price * il.quantity) AS amount_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album al ON al.album_id = t.album_id
JOIN top_artist ta ON ta.artist_id = al.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, ta.artist_name
ORDER BY amount_spent DESC;


/* Q2: Find the most popular music genre in each country based on the number of purchases. */

/* Method 1: Using CTE */
WITH genre_popularity AS (
    SELECT COUNT(il.quantity) AS purchases, c.country, g.name AS genre, ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS rank
    FROM invoice_line il
    JOIN invoice i ON il.invoice_id = i.invoice_id
    JOIN customer c ON c.customer_id = i.customer_id
    JOIN track t ON t.track_id = il.track_id
    JOIN genre g ON g.genre_id = t.genre_id
    GROUP BY c.country, g.name
)
SELECT country, genre, purchases
FROM genre_popularity
WHERE rank = 1;


/* Q3: Identify the highest spending customer in each country. */

/* Method 1: Using CTE */
WITH spending_per_customer AS (
    SELECT c.customer_id, c.first_name, c.last_name, c.billing_country, SUM(i.total) AS total_spent,
    ROW_NUMBER() OVER (PARTITION BY c.billing_country ORDER BY SUM(i.total) DESC) AS rank
    FROM invoice i
    JOIN customer c ON i.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.billing_country
)
SELECT customer_id, first_name, last_name, billing_country, total_spent
FROM spending_per_customer
WHERE rank = 1;
