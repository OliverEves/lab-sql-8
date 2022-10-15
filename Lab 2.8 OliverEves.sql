-- Write a query to display for each store its store ID, city, and country.
USE sakila;

SELECT s.store_id AS 'Store', c.city AS 'City', co.country AS 'Country' FROM sakila.store AS s
JOIN sakila.address AS a
ON s.address_id = a.address_id
JOIN sakila.city AS c
ON a.city_id = c.city_id
JOIN sakila.country AS co
ON c.country_id = co.country_id
GROUP BY s.store_id;

-- Write a query to display how much business, in dollars, each store brought in.

SELECT sto.store_id AS 'Store', SUM(p.amount) AS 'Income in $' FROM sakila.store AS sto
JOIN sakila.staff AS sta
ON sto.store_id = sta.store_id
JOIN sakila.payment AS p
ON sta.staff_id = p.staff_id
GROUP BY sto.store_id;

-- Which film categories are longest?

SELECT fc.category_id AS 'Film Category', AVG(f.length) AS 'Avg. Length' FROM sakila.film_category AS fc
JOIN sakila.film AS f
ON fc.film_id = f.film_id
GROUP BY fc.category_id;

-- Display the most frequently rented movies in descending order.

SELECT f.title AS 'Title', COUNT(r.rental_id) AS 'Rented' FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
JOIN sakila.rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;

-- List the top five genres in gross revenue in descending order.

SELECT fc.category_id AS 'Genre', SUM(p.amount) AS 'Gross Revenue' FROM sakila.film_category AS fc
JOIN sakila.inventory AS i
ON fc.film_id = i.film_id
JOIN sakila.rental AS r
ON i.inventory_id = r.inventory_id
JOIN sakila.payment AS p
ON r.rental_id = p.rental_id
GROUP BY fc.category_id
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.title AS 'Title', s.store_id AS 'Store' FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
JOIN sakila.store AS s
ON i.store_id = s.store_id
WHERE f.title LIKE 'Academy Dinosaur' AND s.store_id = 1
GROUP BY f.title;

-- Get all pairs of actors that worked together.

SELECT f.title AS 'Film Title', CONCAT(a1.first_name," ", a1.last_name) AS 'First Actor', CONCAT(a2.first_name, " ", a2.last_name) AS 'Second Actor' 
FROM sakila.film AS f
JOIN sakila.film_actor AS fa1
ON f.film_id = fa1.film_id
JOIN sakila.actor AS a1
ON fa1.actor_id = a1.actor_id
JOIN sakila.film_actor AS fa2
ON f.film_id = fa2.film_id
JOIN sakila.actor AS a2
ON fa2.actor_id = a2.actor_id
WHERE fa1.actor_id <> fa2.actor_id
ORDER BY f.film_id;

-- Get all pairs of customers that have rented the same film more than 3 times.
select r1.customer_id, r2.customer_id,
       count(distinct r1.film_id) as num_films
from rental r1 join
     rental r2
     on r1.film_id = r2.film_id and
        r1.customer_id < r2.customer_id
group by r1.customer_id, r2.customer_id
order by num_films desc;


SELECT f.title AS 'Film Title', CONCAT(c1.first_name," ", c1.last_name) AS '1st Customer', CONCAT(c2.first_name, " ", c2.last_name) AS '2nd Customer'
FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
JOIN sakila.rental AS r1
ON i.inventory_id = r1.inventory_id
JOIN sakila.customer AS c1
ON r1.customer_id = c1.customer_id
JOIN sakila.rental AS r2
ON i.inventory_id = r2.inventory_id
JOIN sakila.customer AS c2
ON r2.customer_id = c2.customer_id
WHERE r1.rental_id <> r2.rental_id
ORDER BY f.title;

-- For each film, list actor that has acted in more films.

SELECT a.actor_id AS Actor_ID, a.first_name AS 'First Name', a.last_name AS 'Last Name'
FROM sakila.film AS f
JOIN sakila.film_actor AS fa
ON f.film_id = fa.film_id
JOIN sakila.actor AS a
ON fa.actor_id = a.actor_id
GROUP BY Actor_ID
HAVING COUNT(a.actor_id)>1;


