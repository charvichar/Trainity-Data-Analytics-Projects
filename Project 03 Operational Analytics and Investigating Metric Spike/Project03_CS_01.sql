#Case Study 1: Job Data Analysis

#Q1. Jobs Reviewed Over Time
SELECT 
    *
FROM
    job_data;
SELECT 
    AVG(hour) AS 'jobs reviewed per day per hour',
    AVG(sec) AS 'jobs reviewed per day per second'
FROM
    (SELECT 
        ds,
            ((COUNT(job_id) * 3600) / SUM(time_spent)) AS hour,
            (COUNT(job_id) / SUM(time_spent)) AS sec
    FROM
        job_data
    WHERE
        MONTH(ds) = 11
    GROUP BY ds) job;


#Q2. Throughput Analysis
SELECT 
    ROUND(COUNT(event) / SUM(time_spent), 2) AS 'Weekly Throughput'
FROM
    job_data;

SELECT 
    ds AS Date,
    ROUND(COUNT(event) / SUM(time_spent), 2) AS 'Daily Throughput'
FROM
    job_data
GROUP BY ds
ORDER BY ds;


#Q3. Language Share Analysis
SELECT 
    language AS Language,
    ROUND(100 * COUNT(*) / total, 2) AS Percentage,
    sub.total
FROM
    job_data
        CROSS JOIN
    (SELECT 
        COUNT(*) AS Total
    FROM
        job_data) AS sub
GROUP BY language , sub.total;


#Q4. Duplicate Rows Detection
SELECT 
    actor_id, COUNT(*) AS Duplicates
FROM
    job_data
GROUP BY actor_id
HAVING COUNT(*) > 1; 