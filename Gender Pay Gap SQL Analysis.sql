--Use this link to see the presentation associated with this analysis:
-- https://pitch.com/public/63a54205-3e2d-474f-ac4a-1f500e92f455

--WAQ1 How many companies are in the data set?--Answer is 10174				
SELECT COUNT(employername)				
FROM public.gender_pay_gap_21_22;				
				
				
--WAQ2. How many of them submitted their data after the reporting deadline? --Answer is 361				
SELECT COUNT(employername)				
FROM public.gender_pay_gap_21_22				
WHERE submittedafterthedeadline = 'true';				


--WAQ3. How many companies have not provided a URL? --Answer is 3700				
SELECT COUNT(companylinktogpginfo)				
FROM public.gender_pay_gap_21_22				
WHERE companylinktogpginfo = '0';				

--WAQ4. Which measures of pay gap contain too much missing data, and should not be used in our analysis?--Answer: Difference in Mean Bonus Percent is missing for 2,837 companies, and difference in median bonus percent is missing for 4,019 companies								
--Answer is 99 missing values	
SELECT COUNT(diffmeanhourlypercent)			
FROM public.gender_pay_gap_21_22				
WHERE diffmeanhourlypercent = '0'				

--Answer is 99 missing values
SELECT COUNT(diffmedianhourlypercent)			
FROM public.gender_pay_gap_21_22				
WHERE diffmeanhourlypercent = '0';				

--Answer is 2837 missing values
SELECT COUNT(diffmeanbonuspercent)				
FROM public.gender_pay_gap_21_22				
WHERE diffmeanbonuspercent = '0';				

--Answer is 4019 missing values
SELECT COUNT(diffmedianbonuspercent) 				
FROM public.gender_pay_gap_21_22				
WHERE diffmedianbonuspercent = '0';				


--WAQ5. Use an appropriate metric to find the average gender pay gap across all the companies in the data set.
--Answer is 12.31%				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_percentage_across_all_companies				
FROM public.gender_pay_gap_21_22;				
				
				
--WAQ6. What are the 10 companies with the largest pay gaps skewed towards men?				
SELECT employername, diffmedianhourlypercent, employersize				
FROM public.gender_pay_gap_21_22				
ORDER BY diffmedianhourlypercent DESC				
LIMIT 10;				

SELECT employername, diffmedianhourlypercent, employersize
FROM public.gender_pay_gap_21_22
WHERE diffmeanhourlypercent < 100
ORDER BY diffmedianhourlypercent DESC
LIMIT 100;
				

--WAQ7. Apply some additional filtering to pick out the most significant companies with large pay gaps.				
-- Filter by employer size, comparing difference in female & male low & top quartiles				
-- For Low: if positive (Ex. 64% female vs 36% male), females make up 28% more of the bottom 25% of earners. BAD				
-- for Top: if positive (ex. 64% female vs 36% male), females make up 28% more of the top 25% of earners. GOOD				
-- Do < 100 to account for potential missing data. Do companies actually pay 100% more to men than women? Are all top 25% earners men? Are all bottom 25% earners women?				
				
SELECT employername, employersize, diffmedianhourlypercent, (femalelowerquartile - malelowerquartile) AS gap_bottom_25_earners, (femaletopquartile - maletopquartile) AS gap_top_25_earners				
FROM public.gender_pay_gap_21_22				
ORDER BY diffmedianhourlypercent DESC				
LIMIT 100;				
				
SELECT employername, employersize, diffmedianhourlypercent, (femalelowerquartile - malelowerquartile) AS gap_bottom_25_earners, (femaletopquartile - maletopquartile) AS gap_top_25_earners				
FROM public.gender_pay_gap_21_22				
ORDER BY gap_bottom_25_earners DESC				
LIMIT 100;				
				
SELECT employername, employersize, diffmedianhourlypercent, (femalelowerquartile - malelowerquartile) AS gap_bottom_25_earners, (femaletopquartile - maletopquartile) AS gap_top_25_earners				
FROM public.gender_pay_gap_21_22				
ORDER BY gap_top_25_earners ASC				
LIMIT 100;				


--WAQ8. What’s the average pay gap in London versus outside London?				
--In London 13.63%				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_percentage_in_London				
FROM public.gender_pay_gap_21_22				
WHERE address ILIKE '%London%';				
				
--Outside London 11.94%				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_percentage_outside_London				
FROM public.gender_pay_gap_21_22				
WHERE address NOT ILIKE '%London%';				
				
				
--WAQ9. What’s the average pay gap in London versus Birmingham?				
--In London: 13.63%				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_percentage_in_London				
FROM public.gender_pay_gap_21_22				
WHERE address ILIKE '%London%';				
				
--In Birmingham 10.76%				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_percentage_in_Birmingham				
FROM public.gender_pay_gap_21_22				
WHERE address ILIKE '%Birmingham%';				


--WAQ10. What is the average pay gap within schools?				
-- Schools are in Education, Section P. SIC code starts with 85				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_schools				
FROM public.gender_pay_gap_21_22				
WHERE siccodes ILIKE '85%';				


--WAQ11. What is the average pay gap within banks?				
--Banks are in financial and insurance activities, section K. SIC codes are 64110 and 64191				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap_banks				
FROM public.gender_pay_gap_21_22				
WHERE siccodes = '64110' OR siccodes = '64191';				
				
				
--WAQ12. Is there a relationship between the number of employees at a company and the average pay gap?				
-- Answer: Yes, average pay gap slightly improves as the employersize increases				
SELECT AVG(diffmedianhourlypercent) AS median_hourly_gender_pay_gap, employersize				
FROM public.gender_pay_gap_21_22				
GROUP BY employersize				
ORDER BY AVG(diffmedianhourlypercent) DESC;				


--WAQ13 number of companies by employee size				
SELECT COUNT(employername), employersize				
FROM public.gender_pay_gap_21_22				
GROUP BY employersize				


--WAQ14 show the average pay by industry, ordered by highest to lowest				
SELECT				
CASE				
WHEN LEFT(siccodes, 2) BETWEEN '01' AND '03' THEN 'Agriculture'				
WHEN LEFT(siccodes, 2) BETWEEN '05' AND '09' THEN 'Mining'				
WHEN LEFT(siccodes, 2) BETWEEN '10' AND '33' THEN 'Manufacturing'				
WHEN LEFT(siccodes, 2) = '35' THEN 'Electricity'				
WHEN LEFT(siccodes, 2) BETWEEN '36' AND '39' THEN 'Waste_Management'				
WHEN LEFT(siccodes, 2) BETWEEN '41' AND '43' THEN 'Construction'				
WHEN LEFT(siccodes, 2) BETWEEN '45' AND '47' THEN 'Wholesale_retail_trade'				
WHEN LEFT(siccodes, 2) BETWEEN '49' AND '53' THEN 'Transportation'				
WHEN LEFT(siccodes, 2) BETWEEN '55' AND '56' THEN 'Food_Service'				
WHEN LEFT(siccodes, 2) BETWEEN '58' AND '63' THEN 'Information'				
WHEN LEFT(siccodes, 2) BETWEEN '64' AND '66' THEN 'Financial_Insurance'				
WHEN LEFT(siccodes, 2) = '68' THEN 'Real_Estate'				
WHEN LEFT(siccodes, 2) BETWEEN '69' AND '75' THEN 'Prof_Science_Tech'				
WHEN LEFT(siccodes, 2) BETWEEN '77' AND '82' THEN 'Admin_Support'				
WHEN LEFT(siccodes, 2) = '84' THEN 'Public_Admin'				
WHEN LEFT(siccodes, 2) = '85' THEN 'Education'				
WHEN LEFT(siccodes, 2) BETWEEN '86' AND '88' THEN 'Social_Work'				
WHEN LEFT(siccodes, 2) BETWEEN '90' AND '93' THEN 'Arts_Ent_Rec'				
WHEN LEFT(siccodes, 2) BETWEEN '94' AND '96' THEN 'Other_Service'				
WHEN LEFT(siccodes, 2) BETWEEN '97' AND '98' THEN 'Household_Activ'				
WHEN LEFT(siccodes, 2) = '99' THEN 'extra_or_dormant'				
ELSE 'Unknown'				
END AS industry,				
AVG(diffmedianhourlypercent) AS avg_pay_gap				
FROM public.gender_pay_gap_21_22				
GROUP BY industry				
ORDER BY avg_pay_gap DESC;				