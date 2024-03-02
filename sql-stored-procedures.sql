USE sakila;

-- COnvert previous query into stored procedure:
DELIMITER //

CREATE PROCEDURE GetCustomersRentingActionMovies()
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = "Action"
    GROUP BY first_name, last_name, email;
END //

DELIMITER ;
-- Calling it
CALL GetCustomersRentingActionMovies();

-- Making the stored procedure more dynamic:
DELIMITER //

CREATE PROCEDURE GetCustomersRentingMoviesByCategory(IN categoryName VARCHAR(255))
BEGIN
    SELECT 
        first_name, 
        last_name, 
        email,
        category.name AS category_name
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = categoryName
    GROUP BY first_name, last_name, email, category_name;
END //

DELIMITER ;

-- Calling it to check the results
CALL GetCustomersRentingMoviesByCategory('Action');
CALL GetCustomersRentingMoviesByCategory('Animation');

-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
-- First the query:
SELECT 
    category.name AS category_name,
    COUNT(DISTINCT film.film_id) AS movies_released
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category_name;

-- Now the stored procedure:
DELIMITER //

CREATE PROCEDURE FilterCategoriesByMovieCount(IN minMoviesReleased INT)
BEGIN
    SELECT 
        category.name AS category_name,
        COUNT(DISTINCT film.film_id) AS movies_released
    FROM category
    JOIN film_category ON category.category_id = film_category.category_id
    JOIN film ON film_category.film_id = film.film_id
    GROUP BY category_name
    HAVING movies_released > minMoviesReleased;
END //

DELIMITER ;

-- Testing it:
CALL FilterCategoriesByMovieCount(20);
CALL FilterCategoriesByMovieCount(60);

