--#2. Count of users who activated in 2019
SELECT COUNT(DISTINCT u.playerid) as active_users_2019
FROM user u
    JOIN activity a ON u.playerid = a.playerid
    JOIN deposit d ON u.playerid = d.playerid
WHERE YEAR(u.activation_date) = 2019 
    AND d.payment_status = 'a'
    AND a.betplaceddate IS NOT NULL;


--#3. List of users with given constraints
SELECT u.playerid, u.alias, u.email, 
    SUM(a.stake) as total_stake_2019, 
    SUM(a.ggr)/SUM(a.stake) as margin_2019,
    MAX(a.betplaceddate) as last_bet_placed_date,
    SUM(d.payment_amount) as total_deposit_SB
FROM user u
    JOIN activity a ON u.playerid = a.playerid
    JOIN deposit d ON u.playerid = d.playerid
WHERE YEAR(u.activation_date) = 2019 
    AND d.payment_status = 'a'
    AND a.betplaceddate IS NOT NULL
    AND d.sb_flag = 1
GROUP BY u.playerid, u.alias, u.email;


--#4. Parlay bets as a percentage of total bet count from January to April 2019
SELECT 
    DATE_FORMAT(a.betplaceddate, '%Y-%m') as Month,
    COUNT(IF(a.bettype = 'Parlay', 1, NULL)) / COUNT(a.betid) * 100 as parlay_percentage
FROM activity a
WHERE a.betplaceddate BETWEEN '2019-01-01' AND '2019-04-30'
GROUP BY Month;


--#5. Registration to activation ratio from January to April 2019
SELECT 
    DATE_FORMAT(u.registration_date, '%Y-%m') as Month,
    COUNT(CASE WHEN u.activation_date IS NOT NULL THEN 1 END) / COUNT(u.playerid) as reg_to_act_ratio
FROM user u
WHERE u.registration_date BETWEEN '2019-01-01' AND '2019-04-30'
GROUP BY Month;


 
