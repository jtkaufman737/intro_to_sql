/* 
******************************************** INTRO TO SQL PART ONE ****************************************************
*/

/* 

A quick note on this example. This is a real life example, ish, from my previous career as a recruiter. Most job boards are just a website that provides a UI 
for non technical people to query a candidate database. There are a lot of similarities in what I used to do to find people as a recruiter, and what i do searching 
databases directly as a software engineer now. So we are going to take that idea and run with it

*/


/*
1.1 - Creating a table 

First, we are going to create a table called candidates. This is going to go in the BUILD SCHEMA section of SQL Fiddle. You'll see 
the first line below is creating an extension called "uuid-ossp". UUIDs are a random string of numbers and letters and are very 
good to use as unique IDs, so that's why we are including them.

Below, you will see the basic syntax for our table creation. This always follows the same format: 

CREATE TABLE <table name> (
  <column name> <DATA TYPE>,
  <column name> <DATA TYPE>
);

Some things you may notice right away: 
a) our SQL is UPCASED. Not everyone writes it this way and some editors will change it for you, but upcased is the convention
b) you end statements with a ;

*/ 

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DROP TABLE IF EXISTS candidates; 
CREATE TABLE candidates(
 id uuid DEFAULT uuid_generate_v4(),
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(100) NOT NULL,
 email VARCHAR(100) NOT NULL,
 city VARCHAR(100),
 country VARCHAR(50),
 years_experience SMALLINT,
 is_jobseeker BOOLEAN,
 min_salary INT, 
 max_salary INT,
 profile_updated DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Lets check if we created our table... we will talk more about SELECT * in a minute
SELECT * FROM candidates;

/*
1.2 - Inserting Records 

Next, we are going to add some data to this table. If we want to think about CRUD (create, read, update, delete) INSERTS are 
the way we create. 

The main way this is accomplished follows the following pattern: 

INSERT INTO <table name> (
  <column 1 name>, 
  <column 2 name> 
  ...
) VALUES (
  <data for column one>,
  <data for column two>,
  ...
);

Lets begin! 
*/ 


INSERT INTO candidates(
  first_name, 
  last_name, 
  email, 
  city, 
  country, 
  years_experience, 
  is_jobseeker, 
  min_salary, 
  max_salary, 
  profile_updated
) VALUES(
  'Joy', 
  'Kaufman',
  'jtk.writes.code@protonmail.com',
  'Durham',
  'United States of America',
  4, 
  false, 
  null,
  null, 
  CURRENT_TIMESTAMP 
 );
 
INSERT INTO candidates(
  first_name, 
  last_name, 
  email, 
  city, 
  country, 
  years_experience, 
  is_jobseeker, 
  min_salary, 
  max_salary, 
  profile_updated
) VALUES(
  'Dan', 
  'Abramov',
  'react.pro@gmail.com', 
  'London',
  'United Kingdom', 
  10, 
  true, 
  220000, 
  450000, 
  CURRENT_TIMESTAMP
 );
 
INSERT INTO candidates( 
 first_name, 
  last_name, 
  email, 
  city, 
  country, 
  years_experience, 
  is_jobseeker, 
  min_salary, 
  max_salary, 
  profile_updated
) VALUES ( 
 'Evan', 
 'You',
 'vue.js@vue.org',
 'San Francisco',
 'United States of America',
 10,
 true,
 300000,
 325000,
 CURRENT_TIMESTAMP   
);

 INSERT INTO candidates(
  first_name, 
  last_name, 
  email, 
  city, 
  country, 
  years_experience, 
  is_jobseeker, 
  min_salary, 
  max_salary, 
  profile_updated
) VALUES (
  'E.F.', 
  'Codd',
  'ef.codd@ibm.com',
  'Wales',
  'United Kingdom',
  40,
  true,
  40000,
  60000, 
  CURRENT_TIMESTAMP 
);

 INSERT INTO candidates(
  first_name, 
  last_name, 
  email, 
  city, 
  country, 
  years_experience, 
  is_jobseeker, 
  min_salary, 
  max_salary, 
  profile_updated
) VALUES (
  'Yukihiro', 
  'Matsumoto',
  'matz@matz.com',
  'Kyoto',
  'Japan',
  30,
  true,
  240000,
  260000, 
  CURRENT_TIMESTAMP 
);

-- YOUR TURN! Go ahead and add yourself to your table following the format above 

/*
1.3 - Querying data 
*/ 

-- First, we are going to talk about SELECT *. SELECT * means selected all rows and all columns. This query is going to give us back all of our records 

SELECT * FROM candidates;

-- We also only have the option of only looking at a few columns. For instance, this long ID string doesn't mean too much to us, so lets get rid of it and only look at columns we are interested in

SELECT first_name, last_name, email, city, years_experience, is_jobseeker, min_salary, max_salary FROM candidates;

/*
The next really important thing we are going to talk about is the WHERE clause. The where clause is the SQL equivalent of 
if/else statements in the code you've seen before. Like expressions in regular code, you can use the boolean terms AND, OR,
and NOT in combination with your search terms. 

Lets look at some of those. Can I get a guess on how we would only search candidates who are jobseekers? 
*/ 

SELECT * FROM candidates WHERE is_jobseeker=true;

-- What if we only wanted to search candidates who lived in the United Kingdom? 

SELECT * FROM candidates WHERE country='United Kingdom';

-- What if we only wanted to search UK candidates who were in our budget for a certain job? 

SELECT * FROM candidates WHERE country = 'United Kingdom' AND max_salary < 150000;

-- What if we could hire someone in the US or UK? 

SELECT * FROM candidates WHERE country = 'United Kingdom' OR country='United States of America';

-- Another way of doing the same query would be: 

SELECT * FROM candidates WHERE country IN('United Kingdom','United States of America');

-- You can also do the opposite! 

SELECT * FROM candidates WHERE country NOT IN('United Kingdom','United States of America');


/*
1.4 - Querying data with aggregate functions 

SQL has a lot of built in methods that let you get useful insights to your data as a whole instantly. Lets go through some! 

*/

-- Lets take a look at the HIGHEST salary of our candidates 
SELECT MAX(max_salary) FROM candidates; 

-- What about the lowest? 
SELECT MIN(min_salary) from candidates;

-- You can also get the counts matching various conditions from your database 
SELECT COUNT(*) FROM candidates WHERE country = 'United States of America';

/*
1.5 - The rest of CRUD in SQL 

As you can imagine, sometimes data in a database needs to change. Like a lot of things in technology, it is important to remember that change is risk. If you are ever in a position where you are working 
on functinoality that changes or deletes data, you need to be very cautious. We're going to talk about some ways to do that today in addition to the syntax of statements to change our data. 

First: updates. 

Updates follow the format:

UPDATE <table name> SET <column_name> = <value> WHERE <... any relevant conditions ...> 

DELETES follow a similar format: 

DELETE FROM <table name> WHERE <... any relevant conditions ...> 
*/

-- First, lets update our table. United States of America is kind of a mouthful, lets shorten in 

UPDATE candidates set country = 'United States' WHERE country = 'United States of America';

/* 

Now lets test... SELECT * FROM candidates;

Lets say I decided to enter the job market and update my jobseeker status. One thing to think about critically is how foolproof you can make your WHERE clause when you are changing data. For example, if this were a real database and 
I decided to change my record, can you think of any downside to doing something like UPDATE candidates SET is_jobseeker = true WHERE last_name = 'Kaufmman'?  With these four records, its fine, but in a real database there could be multiple 
people with a last name Kaufman. 

*/ 

UPDATE candidates SET (...?); -- Lets figure out the best term to use as a group for this! 

-- DELETE in SQL is the DELETE of CRUD operations, no surprise there. Lwts find another very unique field we can use to delete safely. But before we do this, I'm going to show you one thing that will make your database updates and deletes MUCH
-- safer 

BEGIN TRANSACTION;

DELETE FROM candidates WHERE email = 'jtk.writes.code@protonmail.com';

-- Oh no! What if I accidentally ran the wrong statement and I see all of our records lost? 

SELECT * FROM candidates;

ROLLBACK;

SELECT * FROM candidates;

-- Using transactions is critical in handling data responsibly. I'm going to tell you in my experience it isn't a question of if you mess up data, but when. Using transactions is a great way to protect yourself.
-- One word of caution. When a transaction is open, it can lock the table that the statement in the transaction is being performed on. So while my transaction is open, if another user comes trying to do something to this table, 
-- it may cause them issues. Another scenario is users of your application may have problems loading data from the table that is frozen in a transaction. So they are very powerful, but accidentally leaving a transaction open 
-- can have catastrophic effects. You also have to have special privileges usually to shut down someone elses transaction so it isn't like someone else can come along and fix it if you leave a transaction open and go out for lunch, which
-- is a real story that happened to another entry level developer at my first job. Its a good practice to check for open transactions when you are at a stopping point of your database work 

/* 
1.6 Keys and Constraints 

Like we started talking about in our slide, primary keys are the way we keep column values unique. Usually there is one field 
that is the most unique thing about the record and the least likely to have duplication. There are two main ways to declare a primary 
key. Lets take a look at those ways that by making a new table

*/ 

-- When figuring out what field is a good key candidate, you can pretty much use common sense. Just look at what fields could be 
-- repeated, and which wouldn't be. With this table, what do you think the most unique field is? 

CREATE TABLE jobs(
  id uuid DEFAULT uuid_generate_v4(),
  title VARCHAR(50),
  department VARCHAR(100),
  city VARCHAR(50), 
  state VARCHAR(2), 
);  

-- If you said the ID, you are right. UUIDs are extremely unique and that's why they make great ID fields. Lets look at the two ways 
-- we could make the primary key. Number one is during table creation: 

CREATE TABLE jobs(
  id uuid DEFAULT uuid_generate_v4(),
  title VARCHAR(50),
  department VARCHAR(100),
  city VARCHAR(50), 
  state VARCHAR(2), 
  PRIMARY KEY(id)
);

-- Lets add a little data to take this further 
INSERT INTO jobs(title, department, city, state) VALUES('Software Engineer','SaaS Engineering', 'Durham', 'NC');
INSERT INTO jobs(title, department, city, state) VALUES('Software Developer','SaaS Engineering', 'Durham', 'NC');
INSERT INTO jobs(title, department, city, state) VALUES('Implementation Engineer','Marketing', 'Durham', 'NC');
INSERT INTO jobs(title, department, city, state) VALUES('Web Developer','Client Services', 'Durham', 'NC');

-- For a little more practice with this syntax, lets look at another way to add primary keys on our existing tables. 
ALTER TABLE candidates ADD CONSTRAINT candidate_id_pk PRIMARY_KEY(id);
ALTER TABLE jobs ADD CONSTRAINT job_id_pk PRIMARY_KEY(id);

-- Now, what if we wanted a table to track it when our candidates got jobs? 
CREATE TABLE candidate_role(
  candidate_id uuid, 
  job_id uuid
);

/*
This would be a great chance to use a FOREIGN KEY, or a reference to another table. In thinking about why we need this, 
should there every be a situation where a candidate in the candidate_job table is not in the candidate table? Nope, probably not.
Also every job in the candidate role table should exist in the jobs table and be a valid job. Foreign keys are a way to 
make sure that happens. So we are going to look at the second method of having constraints to do this, which is adding them
after a table was created 

This pattern is 

ALTER TABLE <table name> ADD CONSTRAINT <constraint name> <key type>(<key column>) REFERENCES <other table>(<column>);

*/ 

-- First lets practice the syntax for adding primary keys to our other tables 
ALTER TABLE candidates ADD CONSTRAINT candidate_id_pk PRIMARY KEY(id);
ALTER TABLE jobs ADD CONSTRAINT job_id_pk PRIMARY KEY(id);

-- Now lets look at the syntax for adding a foreign key 
ALTER TABLE candidate_role ADD CONSTRAINT candidate_id_fk FOREIGN KEY(candidate_id) REFERENCES candidates(id);
ALTER TABLE candidate_role ADD CONSTRAINT job_id_fk FOREIGN KEY(job_id) REFERENCES jobs(id);

/*
One last cool thing. You'll notice in our candidate role table, we don't have a primary key yet. You almost ALWAYS 
primary key on a table, but in this case the only columns are two foreign keys, and neither of them would be the right choice 
for a primary key. So the way we could get a primary key in this case is called a compound or composite key. Compound 
keys are making a primary key of TWO columns that when combined should always be unique.
*/ 

ALTER TABLE candidate_role ADD CONSTRAINT candidate_job_pk PRIMARY KEY(job_id, candidate_id);
