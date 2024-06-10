create database Project3;
show databases;
use Project3;

#Case Study 1

#Table 1 job_data 
CREATE TABLE job_data (
    ds DATE,
    job_id INT NOT NULL,
    actor_id INT NOT NULL,
    event VARCHAR(15) NOT NULL,
    language VARCHAR(15) NOT NULL,
    time_spent INT NOT NULL,
    org CHAR(2)
);


SELECT 
    *
FROM
    job_data;
    

    
show variables like 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_data.csv"
INTO TABLE job_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ds, job_id, actor_id, event, language, time_spent, org)
SET ds = STR_TO_DATE(@ds, '%m/%d/%Y');

select * from job_data;

#Case Study 02

#Table 1 users

create table users
(
user_id int,
created_at datetime,
company_id int,
language varchar(50),
activated_at datetime,
state varchar(20)
); 


show variables like 'secure_file_priv';



LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, @created_at, company_id, language, @activated_at, state)
SET created_at = STR_TO_DATE(@created_at, '%d-%m-%Y %H:%i'),
    activated_at = STR_TO_DATE(@activated_at, '%d-%m-%Y %H:%i');
    
select * from users; 

#Table 3 Events


create table events(
user_id int null,
occurred_at datetime null,
event_type varchar(50) null,
event_name varchar(100) null,
location varchar(100) null,
device varchar(200) null,
user_type int null
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, @occurred_at, event_type, event_name, location, device, user_type)
SET occurred_at = STR_TO_DATE(@occurred_at, '%e-%m-%Y %H:%i');

select * from events;

#Table 03 email_events
#user_id	occurred_at	action	user_type
create table email_events(
user_id int null,
occurred_at datetime null,
action varchar(200) null,
user_type int null
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE email_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, @occurred_at, action, user_type)
SET occurred_at = STR_TO_DATE(@occurred_at, '%e-%m-%Y %H:%i');

 