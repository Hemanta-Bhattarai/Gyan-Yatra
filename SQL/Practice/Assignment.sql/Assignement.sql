SELECT *
FROM students

SELECT *
FROM courses

SELECT *
FROM student_enrollment

SELECT *
FROM professors

SELECT *
FROM teach
 -- Query to display students name having age between 18 and 20
SELECT student_name
FROM students
WHERE age BETWEEN 18 AND 20



 
--Write a query to display all of those students that contain the
--letters "ch" in their name or their name ends with the letters  "nd".

SELECT * 
FROM students
WHERE student_name LIKE '%ch%' 
OR student_name LIKE '%nd'

--Write a query to display the name of those students that have 
--the letters "ae" or "ph" in their name and are NOT 19 years old.

SELECT *
FROM students
WHERE (students_name LIKE '%ae%' 
OR students_name LIKE '%ph%'
OR students_name LIKE '%ph')
AND age != 19


--Write a query that lists the names of students sorted by their age from largest to smallest.
SELECT student_name,age
FROM students
ORDER BY age DESC


--Write a query that displays the names and ages of the top 4 oldest students
SELECT student_name, age
FROM students
ORDER BY age DESC
LIMIT 4


-- The student must not be older than age 20 if their student_no is either between
-- 3 and 5 or their student_no is 7. Your query should also return students older 
-- than age 20 but in that case they must have a student_no that is at least 4. 

SELECT *
FROM students
WHERE (((student_no BETWEEN 3 AND 5) OR student_no = 7) AND age <= 20)
OR (age > 20 AND student_no <= 4)


--++++++++++++++++++++++++++ 

-- Write a query against the professors table that can output the following
-- in the result: "Chong works in the Science department"
SELECT last_name || ' works in the ' || department as full_info
FROM professors


--Write a SQL query against the professors table that would return the following result: 
-- "It is false that professor Chong is highly paid"
-- "It is true that professor Brown is highly paid"
-- "It is false that professor Jones is highly paid"
-- "It is true that professor Wilson is highly paid"
-- "It is false that professor Miller is highly paid"
-- "It is true that professor Williams is highly paid"
-- NOTE: A professor is highly paid if they make greater than 95000. 


SELECT 'It is ' || (salary > 95000) ||' that professor ' || last_name || ' is highly paid'
FROM professors


-- Write a query that returns all of the records and columns from the professors table but shortens
-- the department names to only the first three characters in upper case. 

SELECT *
FROM professors

SELECT last_name, UPPER(SUBSTRING(department, 1, 3)), salary, hire_date
FROM professors
								  
-- Write a query that returns the highest and lowest salary from the professors 
-- table excluding the professor named 'Wilson'

SELECT MAX(salary) as highest_salary, MIN(salary) as lowest_salary
FROM professors
WHERE last_name != 'Wilson'
								  
								  
-- Write a query that will display the hire date of the professor that has been teaching the longest.
SELECT MIN(hire_date) as early_hire
FROM professors
		

--Write a query that finds students who do not take CS180								  
SELECT DISTINCT student_name, course_no
FROM students s INNER JOIN student_enrollment se
ON se.student_no = s.student_no
WHERE (course_no != 'CS180')							  
							  
								  
--Write a query to find students who take CS110 or CS107 but not both								  

SELECT student_name, course_no
FROM students s INNER JOIN student_enrollment se
ON se.student_no = s.student_no
WHERE (course_no = 'CS110' OR course_no = 'CS107')								  
AND NOT (course_no = 'CS110' AND course_no = 'CS107')
								  
--Write a query to find students who take CS220 and no other courses.								  
SELECT student_name
FROM students s INNER JOIN student_enrollment se
ON se.student_no = s.student_no
WHERE course_no = 'CS110'							  
EXCEPT								  
SELECT student_name
FROM students s INNER JOIN student_enrollment se
ON se.student_no = s.student_no
WHERE course_no != 'CS110'	
								  
								  
								  
--Write a query that finds those students who take at most 2 courses. Your query should exclude 
--students that don't take any courses as well as those  that take more than 2 course. 
SELECT student_name, COUNT(student_name) total_course
FROM students s INNER JOIN student_enrollment se
ON se.student_no = s.student_no
GROUP BY student_name 
HAVING  COUNT(student_name) IN (1,2)

								  
--Write a query to find students who are older than at most two other students
SELECT student_name,age,agecomp FROM
(SELECT student_name, age,								  
(SELECT SUM(CASE WHEN s1.age - s2.age > 0 THEN 1 ELSE 0 END) FROM students s2) as agecomp								  
FROM students s1) combined								  
WHERE agecomp <= 2

--Write a query that shows the student's name, the courses the student is taking and the professors that teach that course. 								  

SELECT student_name, se.course_no, last_name
FROM students s INNER JOIN student_enrollment se
ON s.student_no = se.student_no
INNER JOIN teach te
ON se.course_no = te.course_no

--In question 3 you discovered why there is repeating data. How can we eliminate this redundancy? 
--Let's say we only care to see a single professor teaching a course and we don't care for all the
--other professors that teach the particular course. Write a query that will accomplish this so that
--every record is distinct								  
SELECT DISTINCT student_name, se.course_no,last_name
FROM students s INNER JOIN student_enrollment se
ON s.student_no = se.student_no
INNER JOIN (SELECT course_no, last_name	
FROM teach t1
WHERE t1.last_name = (SELECT last_name FROM teach t2 WHERE t2.course_no = t1.course_no LIMIT 1)	) te
ON se.course_no = te.course_no								  
ORDER BY student_name								  

								  
SELECT *
FROM students

SELECT *
FROM student_enrollment

SELECT *
FROM professors							

SELECT DISTINCT t1.course_no, se.course_no	
FROM teach t1 FULL OUTER JOIN student_enrollment se
ON t1.course_no = se.course_no
					  
							  