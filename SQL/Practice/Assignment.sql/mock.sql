
----
SELECT SUBSTRING(email, POSITION('@' IN email) + 1), count(*)
FROM employees
GROUP BY SUBSTRING(email, POSITION('@' IN email) + 1)


----
SELECT gender, region_id, MIN(salary), MAX(salary), AVG(salary)
FROM employees
GROUP BY gender, region_id
ORDER BY gender, region_id

-- give name of  employees that work in Electronics Division

SELECT first_name FROM employees
WHERE department 
	IN (SELECT department FROM departments WHERE division = 'Electronics')
	
	
--- give name of employees from asia and canada and has salary more than 130000
SELECT * FROM employees
WHERE 
	(region_id IN (SELECT region_id FROM regions WHERE country IN ('Asia', 'Canada')))
AND
	(salary > 130000)
	
-- give the first_name, last_name and how much less are they paid then maximum salary
SELECT first_name, department, (SELECT MAX(salary) FROM employees) - salary as diff_salary
FROM employees
WHERE (region_id IN (SELECT region_id FROM regions WHERE country IN ('Asia', 'Canada')))
							
-- give names of all employees that work in kids division and the dates of the hiring is greater than the 
-- all of the hire dates of employees who work in maintainance department
SELECT first_name FROM employees
WHERE department IN (SELECT department FROM departments WHERE division = 'Kids')
AND hire_date > ALL(SELECT hire_date FROM employees WHERE department = 'Maintenance')
																	 
-- give the most repeated salary
SELECT salary FROM(																	 
SELECT salary, COUNT(*) FROM employees
GROUP BY salary	
ORDER BY COUNT(*) DESC, salary DESC																	 
LIMIT 1	) a												 

---																	 
CREATE TABLE dubes(
	id integer,
	name varchar(10));
				 
INSERT INTO dubes VALUES(1, 'FRANK');				 
INSERT INTO dubes VALUES(2, 'FRANK');																	 
INSERT INTO dubes VALUES(3, 'ROBERT');
INSERT INTO dubes VALUES(4, 'ROBERT');
INSERT INTO dubes VALUES(5, 'SAM');				 
INSERT INTO dubes VALUES(6, 'FRANK');				 
INSERT INTO dubes VALUES(7, 'PETER');	
				 

				 
SELECT name, MIN(id)
FROM dubes
GROUP BY name
				 
				 
-- delete duplicate records
				 
DELETE FROM dubes
WHERE id NOT IN(
SELECT MIN(id)
FROM dubes
GROUP BY name
)

DROP TABLE dubes				 
SELECT * FROM dubes	

-- Average salary excluding highest paid and lowest paid
SELECT ROUND(AVG(salary)) FROM employees
WHERE salary != (SELECT MIN(salary) FROM employees) AND salary != (SELECT MAX(salary) FROM employees)


-- case when
SELECT category, COUNT(*)
FROM (SELECT salary,
	 CASE 
	  	WHEN salary < 100000 THEN 'Under Paid'
	  	WHEN salary > 100000 AND salary < 160000 THEN 'Paid Well'
	  	WHEN salary > 160000 THEN 'Executives'
	 	ELSE 'Unpaid'
	 END AS category
	 FROM employees) as categorical
GROUP BY category
				 
---
SELECT SUM(CASE WHEN department = 'Clothing' THEN 1 ELSE 0 END) AS cloting_employee,
		SUM(CASE WHEN department = 'Tools' THEN 1 ELSE 0 END) AS tools_employee,
		SUM(CASE WHEN department = 'Computers' THEN 1 ELSE 0 END) AS computer_employee,
		SUM(CASE WHEN department = 'Sports' THEN 1 ELSE 0 END) AS sports_employee
FROM employees
				 
				 
SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id =1 ) END as r1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id =2 ) END as r2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id =3 ) END as r3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id =4 ) END as r4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id =5 ) END as r5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id =6 ) END as r6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id =7 ) END as r7
FROM employees 
	
				 
SELECT SUM(CASE WHEN r1 IS NOT NULL THEN 1 ELSE 0 END)+
				 SUM(CASE WHEN r2 IS NOT NULL THEN 1 ELSE 0 END)+
				 SUM(CASE WHEN r3 IS NOT NULL THEN 1 ELSE 0 END) AS USA,
				 SUM(CASE WHEN r4 IS NOT NULL THEN 1 ELSE 0 END)+
				 SUM(CASE WHEN r5 IS NOT NULL THEN 1 ELSE 0 END) AS ASIA,
				 SUM(CASE WHEN r6 IS NOT NULL THEN 1 ELSE 0 END)+
				 SUM(CASE WHEN r7 IS NOT NULL THEN 1 ELSE 0 END) AS CANADA
FROM(SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id =1 ) END as r1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id =2 ) END as r2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id =3 ) END as r3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id =4 ) END as r4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id =5 ) END as r5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id =6 ) END as r6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id =7 ) END as r7
FROM employees) as region_category
				 
--+++++++++++++++++++++++++++++++++++++				 
				 
SELECT COUNT(r1)+COUNT(r2)+COUNT(r3) AS usa,
		COUNT(r4)+COUNT(r5) AS asia,
		COUNT(r6)+COUNT(r7) AS canada
FROM(SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id =1 ) END as r1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id =2 ) END as r2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id =3 ) END as r3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id =4 ) END as r4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id =5 ) END as r5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id =6 ) END as r6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id =7 ) END as r7
FROM employees) as region_category
SELECT * FROM regions AS r, employees AS e
				 
				 
				 
				 
--
SELECT department, COUNT(*)
FROM employees
GROUP BY department
HAVING COUNT(*) >38
-----+++++++++++++++++++++++++++				 
SELECT department, MAX(salary)
FROM employees  e1
WHERE 38 < 	(SELECT COUNT(*) 
			 FROM employees e2
			 WHERE e1.department = e2.department
				 )
GROUP BY department

--++++++++++++++++++++++++++++++++
SELECT department, (SELECT first_name FROM employees WHERE salary IN (MAX(salary), MIN(salary))
FROM employees
GROUP BY department

SELECT department, first_name, salary, 
CASE WHEN salary = (SELECT MAX(salary) FROM employees WHERE department = e1.department) THEN 'HIGHEST' ELSE 'LOWEST' END
FROM employees e1
WHERE salary = (SELECT MAX(salary) FROM employees WHERE department = e1.department)
OR salary = (SELECT MIN(salary) FROM employees WHERE department = e1.department)
ORDER BY department																					   

																					   
--- Joins 
SELECT first_name, email, division, country
FROM employees e, departments d, regions r
WHERE e.department = d.department	
AND e.region_id = r.region_id
AND email IS NOT NULL
						
-- to show country and total employess from that country																					   
SELECT	r.country, COUNT(e.employee_id)																				   
FROM employees e, regions r
WHERE e.region_id = r.region_id																					   
GROUP BY r.country																					   

--show department that exist in deparment table but not in employees table																					   
SELECT DISTINCT (d.department)
FROM departments d	LEFT JOIN employees e ON d.department = e.department																			   
WHERE e.department IS NULL
																					
-- show departmet and employees working for that department and final row should be total and total																					   
-- number of employee																					   
SELECT	department, COUNT(*) 																			   
FROM employees																					   
GROUP BY department
UNION ALL																					   
SELECT 'Total', (COUNT(*))																					   
FROM employees																					   
																					   
---- query to generate first_name last_name,date of hire, country for the first and last hired person
(SELECT first_name, last_name, hire_date, country, 'Late' hire				   
FROM employees e INNER JOIN regions r ON e.region_id = r.region_id					   					   					   
WHERE hire_date = (SELECT MIN(hire_date) FROM employees)
)					   
UNION					   
(SELECT first_name, last_name, hire_date, country, 'Early' hire			   
FROM employees e INNER JOIN regions r ON e.region_id = r.region_id					   					   					   
WHERE hire_date = (SELECT MAX(hire_date) FROM employees) 
)					   

					   
					   
					   
--
SELECT  hire_date, salary,
(SELECT SUM(salary) FROM employees e2 WHERE hire_date BETWEEN e1.hire_date - 90 AND e1.hire_date ) as spending_pattern
FROM employees e1
ORDER BY hire_date					   

					   
--In the video lectures, we've been discussing the employees table and the departments table.
--Considering those tables, write a query that returns employees whose salary is above average for their given department					   
					   
SELECT first_name FROM					   
(SELECT first_name, salary, department, (SELECT ROUND(AVG(salary)) FROM employees e2 WHERE e1.department = e2.department) AS average
FROM employees e1) combined
WHERE average < combined.salary
					   
SELECT * FROM regions