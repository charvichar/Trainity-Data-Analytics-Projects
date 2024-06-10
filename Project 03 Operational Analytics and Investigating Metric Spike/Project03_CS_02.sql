#Case Study 2: Investigating Metric Spike
select * from users;
select * from events;
select * from email_events;


#Q1. Weekly User Engagement
SELECT 
    EXTRACT(WEEK FROM occurred_at) AS week_no,
    COUNT(DISTINCT user_id) AS active_user
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY week_no
ORDER BY week_no;

#Q2. User Growth Analysis
SELECT 
    year_no, 
    week_no, 
    total_users, 
    SUM(total_users) OVER (ORDER BY year_no, week_no) AS cumulative_users
FROM
    (SELECT 
         EXTRACT(YEAR FROM activated_at) AS year_no, 
         EXTRACT(WEEK FROM activated_at) AS week_no,
         COUNT(DISTINCT user_id) AS total_users
     FROM 
         users
     WHERE 
         state = 'active'
     GROUP BY 
         year_no, week_no) AS a;

#Q3. Weekly Retention Analysis
WITH cte1 AS (
    SELECT DISTINCT 
        user_id,
        EXTRACT(WEEK FROM occurred_at) AS signup_week
    FROM 
        events 
    WHERE 
        event_type = 'signup_flow' AND event_name = 'complete_signup' 
        AND EXTRACT(WEEK FROM occurred_at) = 18
),
cte2 AS (
    SELECT DISTINCT 
        user_id,
        EXTRACT(WEEK FROM occurred_at) AS engagement_week
    FROM 
        events 
    WHERE 
        event_type = 'engagement'
)
SELECT 
    COUNT(user_id) AS total_engaged_users,
    SUM(CASE WHEN retention_week > 8 THEN 1 ELSE 0 END) AS retained_users
FROM 
    (
    SELECT 
        a.user_id, 
        a.signup_week,
        b.engagement_week, 
        b.engagement_week - a.signup_week AS retention_week
    FROM 
        cte1 a
    LEFT JOIN 
        cte2 b ON a.user_id = b.user_id
    ORDER BY 
        a.user_id
    ) AS sub;


#Q4. Weekly Engagement Per Device
WITH cte AS (
    SELECT 
        CONCAT(EXTRACT(YEAR FROM occurred_at), '-', EXTRACT(WEEK FROM occurred_at)) AS week_no,
        device,
        COUNT(DISTINCT user_id) AS total_users
    FROM 
        events 
    WHERE 
        event_type = 'engagement'
    GROUP BY 
        week_no, device
    ORDER BY 
        week_no
)
SELECT 
    week_no,
    device, 
    total_users
FROM 
    cte;

#Q5. Email Engagement Analysis
SELECT 
    100 * SUM(CASE
        WHEN email_cat = 'email_open' THEN 1
        ELSE 0
    END) / SUM(CASE
        WHEN email_cat = 'email_sent' THEN 1
        ELSE 0
    END) AS email_open_rate,
    100 * SUM(CASE
        WHEN email_cat = 'email_clicked' THEN 1
        ELSE 0
    END) / SUM(CASE
        WHEN email_cat = 'email_sent' THEN 1
        ELSE 0
    END) AS email_click_rate
FROM
    (SELECT 
        *,
            CASE
                WHEN action IN ('sent_weekly_digest' , 'sent_reengagement_email') THEN 'email_sent'
                WHEN action IN ('email_open') THEN 'email_open'
                WHEN action IN ('email_clickthrough') THEN 'email_clicked'
            END AS email_cat
    FROM
        email_events) AS sub;
