/* 

1.1 

Keys and constraints 

We started talking about keys and constraints in the slides, now lets put this into action. We're going to start by making a couple new tables for this work. Lets use code the dream as an example, 
and we are going to use Students, Programs, and Courses for our data. Lets begin 

*/ 

-- SQL is flexible, and it likes to give you multiple ways of doing things. For both foreign keys and primary keys, you can either define them as the table is being made, or afterwards. Lets 
-- look at both methods 

CREATE TABLE programs(
  program_id SERIAL, 
  program_name VARCHAR(50),
  program_location VARCHAR(100)
);

/*
 It looks like we forgot a primary key. Easy question, but which field do you think it should be on? 
 Adding a primary key after your table is created follows this format: 
 ALTER TABLE <table name> ADD CONSTRAINT <constraint name> PRIMARY KEY(<column name>)
*/
ALTER TABLE programs ADD CONSTRAINT program_id_pk PRIMARY KEY(program_id)

-- Now lets see what our primary key step does as we add some data 
INSERT INTO programs(program_name, program_location) VALUES('Backend', 'Durham, NC');
INSERT INTO programs(program_name, program_location) VALUES('Frontend', 'Durham, NC');

-- Lets take a look at our data now.
SELECT * FROM programs;

-- As you can see, it generated ID fields for us that are unique. Lets see what the database does if we try to violate our unique primary key 
INSERT INTO programs(program_id, program_name, program_location) VALUES(1, 'Backend', 'Durham NC')

/*
 We get an error! As we should. It is important that data not be duplicated. It takes up storage room, it can making loading data into your server side code or frontend code buggy and confusing, 
 and it is more data to maintain if you ever need to update data. Like if the program name changed, we don't want extra records to have to change. Change is risk, with databases. So duplicates are 
 a big no no
 
 Now lets look at the second method of making a table with a primary key, which I feel is a little simpler. We are going to start with a student table now, with a student_id primary key 
 */

CREATE TABLE students(
   student_id SERIAL, 
   student_name VARCHAR(50),
   program_id INT,
   -- Here's the magic!
   PRIMARY KEY(student_id)
);

INSERT INTO students(student_name, program_id) VALUES('Joy Kaufman', 1)

SELECT * FROM students

/* 
Cool, we see that it generated an ID number. If we tried to add another record with a student_id of 1, it would fail again 

This brings us to foreign keys. Like primary keys, you can make a foreign key during table creation, or add it afterwards. Since we already made our student table without a foreign key, 
lets add it separately. The syntax for that is 

ALTER TABLE <table name> ADD CONSTRAINT <constraint_name> FOREIGN KEY(<local column name>) REFERENCES <other table>(<column name>)
*/

ALTER TABLE students ADD CONSTRAINT program_id_fk FOREIGN KEY(program_id) REFERENCES programs(program_id);

/* 
So up until now we haven't talked that much about WHY you would want a foreign key. What do you think would happen to your application if you created a student record 
with a program id of 500, which doesn't exist in any of our program data? Short answer, your application would almost definitely break, or show no data, or show 
garbled data depending on what kind of data we are talking about. So the foreign key here would be used to make sure any students that enter the student table 
are in a valid program.

Now that we have our foreign key, lets take a look at what happens if we try creating a student under a bogus program
*/

INSERT INTO students(student_name, program_id) VALUES('Dan Abramov',500);
 
/*
 We get an error! As we should. So in real life that would come back to the application as an error saying, hey that program doesn't exist. The data would be corrected, and we'd make them 
 enter legitimate data 

 Now lets take a look at making a foreign key during table creation   

*/ 

CREATE TABLE courses(
  course_id SERIAL,
  course_name VARCHAR(40),
  course_subject VARCHAR(100),
  course_program INTEGER,
  FOREIGN KEY(course_program) REFERENCES programs(program_id)
);

-- I think everyone knows at this point what is going to happen, but lets give it a try anyway. Lets add a couple records. One will be legit, one will be a course with a bogus program 
INSERT INTO courses(course_name, course_subject, course_program) VALUES('Ruby/Rails I', 'Intro to ruby/rails',1);
INSERT INTO courses(course_name, course_subject, course_program) VALUES('React/Redux I', 'Intro to redux', 2); 
INSERT INTO courses(course_name, course_subject, course_program) VALUES('React/Redux II', 'Redux Part II', 3);
INSERT INTO courses(course_name, course_subject, course_program) VALUES('Ruby/Rails II', 'Ruby, Rails, and Active Record',1);

-- Now lets fix the one that failed 

INSERT INTO courses(course_name, course_subject, course_program) VALUES('React/Redux II', 'Redux Part II', 2);

SELECT * FROM courses;

/*
There's one last type of constraint we'll talk about that's really useful. Its UNIQUE. UNIQUE is great to use if you need a column's values to be unique, but it isn't your primary key. For 
our example lets say we want our course names and program names to be unique - if they had the same name it could confuse the learners. Here's the syntax for adding a unique constraint

ALTER TABLE <table name> ADD CONSTRAINT <constraint name> UNIQUE(<column name>);
*/

ALTER TABLE courses ADD CONSTRAINT course_name_uq UNIQUE(course_name);
ALTER TABLE programs ADD CONSTRAINT prog_name_uq UNIQUE(program_name);


/* 

1.2 - Joins 

Joins are the way that you get data combined in a way that is useful to you. Correct database design is usually to break things out into separate tables like we talked about earlier and then 
join them to see the bigger picture. Lets practice a join to see our student, and what program they are in.

To do a join, the first thing you want to do is find out a field that is common to both tables. Lets look at our tables to refresh our memory. Usually I do a select, and write down the 
column names to figure this out

The basic syntax for a join is 

SELECT * FROM <table a> 
JOIN <table b> 
ON <table a.column_name> = <table b.column_name> 

*/ 

SELECT * FROM students; -- student id, student_name, program_id
SELECT * FROM programs; -- program_id, program_name, program_location 
SELECT * FROM courses;  -- course_id, course_name, course_subject, course_program 

SELECT students.student_name, programs.program_name, courses.course_name, courses.course_subject 
FROM students 
JOIN programs ON programs.program_id = students.program_id
JOIN courses ON courses.course_program = programs.program_id  
