# SQL Query Solutions for Music Store Database

This repository contains a collection of SQL queries designed to analyze a music store database. The queries are divided into three sets based on difficulty: **Easy**, **Moderate**, and **Advanced**.

## Project Overview

The goal of this project is to solve a variety of business-related questions using SQL. The database schema includes tables such as `employee`, `customer`, `invoice`, `invoiceline`, `track`, `album`, `artist`, and `genre`. Each query demonstrates a specific SQL technique for retrieving and analyzing data.

## Query Sets

### 1. Easy
This set focuses on basic SQL operations like selecting, ordering, and grouping data.

- **Find the senior-most employee by job title.**
- **Identify countries with the highest number of invoices.**
- **Retrieve the top 3 highest invoice totals.**
- **Determine the city with the highest revenue for a potential music festival.**
- **Find the best customer based on total spending.**

### 2. Moderate
The moderate set includes more complex operations such as joins, nested queries, and aggregations.

- **List all Rock music listeners with their emails, sorted alphabetically.**
- **Return the top 10 artists based on the number of rock tracks.**
- **Find songs longer than the average song length.**

### 3. Advanced
The advanced set involves solving business-critical questions with complex SQL logic, including `WITH` clauses and recursive queries.

- **Calculate the amount each customer has spent on the top-selling artist.**
- **Find the most popular music genre for each country.**
- **Identify the top-spending customer in each country.**

## Database Schema

The project assumes the following key tables in the database:

- `customer`: Contains customer information such as name, email, and country.
- `invoice`: Stores information about each purchase, including the total and billing details.
- `invoiceline`: Contains individual items on an invoice, including price and quantity.
- `track`: Represents music tracks with details such as genre and duration.
- `album`: Links tracks to their respective albums.
- `artist`: Contains artist information.
- `genre`: Defines the genres for the tracks.

## SQL Techniques Used

- `SELECT`, `JOIN`, `GROUP BY`, and `ORDER BY`
- Subqueries and nested queries
- Common Table Expressions (CTEs) with `WITH`
- Window functions like `ROW_NUMBER()`
- Recursive queries
- Aggregate functions like `SUM()`, `COUNT()`, `AVG()`

## How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/sql-music-store.git
Import the provided queries into your SQL environment (e.g., MySQL, PostgreSQL) connected to a similar database.

Execute the queries to get insights into the dataset.

Example Queries
Here’s an example of a query that returns the top 10 rock artists based on the number of tracks:

sql
SELECT a.artist_id, a.name, COUNT(*) AS track_count
FROM track t
JOIN album al ON al.album_id = t.album_id
JOIN artist a ON a.artist_id = al.artist_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY track_count DESC
LIMIT 10;
Contributing
If you have suggestions or would like to contribute to this project, feel free to open an issue or submit a pull request.
