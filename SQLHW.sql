USE sakila;

#1a - display all actors 
SELECT * FROM actor;

#1b - display actors name in one column 
SELECT CONCAT(first_name, ' ', last_name) AS "Actor Name" FROM actor;

#2a - First name "Joe"
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name = "Joe";

#2b - all actors whose last name contain the letters 'GEN'
SELECT *
FROM actor 
WHERE last_name LIKE '%GEN%';

#2c - all actors whose last names contain the letters LI, order the rows by last name and first name
SELECT *
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name DESC;

#2d - country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a - create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description BLOB; 

#3b - delete the description column
ALTER TABLE actor
DROP description; 

#4a - list the last names of actors, as well as how many actors have that last name
SELECT last_name,
COUNT(*) AS `count`
FROM actor
GROUP BY last_name;

#4b - only for names that are shared by at least two actors
SELECT last_name,
COUNT(*) AS `count`
FROM actor
GROUP BY last_name
HAVING count >= 2;

#4c - GROUCHO WILLIAMS - > HARPO WILLIAMS from actor table
SELECT *
FROM actor
WHERE last_name = 'WILLIAMS';

UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172; 

#4d - HARPO -> GROUCHO from actor table
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172; 

#5a - query used to re-create address table
SHOW CREATE TABLE address;

#6a - first and last names, as well as the address from staff and address
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a ON
s.address_id = a.address_id;

#6b - the total amount rung up by each staff member in August of 2005
SELECT s.first_name, s.last_name, p.amount
FROM staff s
INNER JOIN payment p ON
s.staff_id = p.staff_id;

#6c - list each film and the number of actors using inner join
SELECT f.title, 
COUNT(*) AS `count`
FROM film f
INNER JOIN film_actor fa ON
f.film_id = fa.film_id
GROUP BY f.title;


#6d - the number of film Hunchback Impossible in inventory
SELECT COUNT(*)
FROM inventory
WHERE film_id IN
(SELECT film_id
  FROM film
  WHERE title = 'Hunchback Impossible');
  
#6e - list the total paid by each customer alphabetically by last name
SELECT c.first_name, c.last_name, SUM(p.amount)
FROM customer c
INNER JOIN payment p ON
c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;

#7a - display the titles of movies starting with the letters K and Q whose language is English
SELECT title
FROM film 
WHERE title LIKE "K%" OR title LIKE "Q%" 
AND language_id IN
(
	SELECT language_id
	FROM language
	WHERE name = "English" 
);

#7b - display all actors who appear in the film Alone Trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
	(
		SELECT film_id
		FROM film
		WHERE title = "Alone Trip"
	)
);

#7c - names and email addresses of all Canadian customers
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(
	SELECT address_id
    FROM address
    WHERE city_id IN
    (
		SELECT city_id
        FROM city
        WHERE country_id IN
        (
			SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

#7d - identify all movies categorized as family films
SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

#7e - display the most frequently rented movies in descending order
SELECT f.title, COUNT(r.inventory_id)
FROM film f 
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.inventory_id) DESC;


#7f - display how much business, in dollars, each store brought in
SELECT s.store_id, SUM(p.amount)
FROM store s
INNER JOIN staff f
ON s.store_id = f.store_id
INNER JOIN payment p
ON p.staff_id = f.staff_id
GROUP BY s.store_id;


#7g - display for each store its store ID, city, and country
SELECT s.store_id, c.city, co.country
FROM store s
INNER JOIN staff f
ON s.store_id = f.store_id
INNER JOIN address a
ON a.address_id = f.address_id
INNER JOIN city c
ON c.city_id = a.city_id
INNER JOIN country co
ON c.country_id = co.country_id;


#7h - list the top five genres in gross revenue in descending order
SELECT c.name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON fc.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

#8a - create a view for top 5 genres
CREATE VIEW top_five_genres AS
SELECT c.name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON fc.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

#8b - display the view
SELECT * FROM top_five_genres;

#8c = delete the view
DROP VIEW top_five_genres;




