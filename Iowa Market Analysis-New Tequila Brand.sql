--Use this link to view the presentation associated with this data:
--https://pitch.com/public/b5414de5-6e0d-4fcf-b5bd-61f06ffbe587


-- Frame: Im a new vendor looking to sell a new brand of alcohol.
-- I want to understand which alcohol has a market opportunity in Iowa. 
--Then, what are the top selling brands, counties, & stores in terms of total bottles sold of that alcohol.					
						
																
--WAQ1.  What is the best selling tequila in terms of total bottles sold, broken down by county, store, vendor?						
SELECT SUM(bottle_qty) AS total_bottles_sold, category_name, description, county, store, vendor						
FROM sales						
WHERE category_name ILIKE '%teq%'						
GROUP BY (bottle_qty), category_name, description, county, store, vendor						
ORDER BY total_bottles_sold DESC, category_name						
;						
						
--WAQ1a. What county has the highest number of Tequila bottles sold?						
SELECT SUM(bottle_qty) AS total_bottles_sold, county						
FROM sales						
WHERE category_name ILIKE '%teq%'						
GROUP BY county						
ORDER BY SUM(bottle_qty) DESC;						
						
												
--WAQ2.  - showing the which county with fewer than 100K population has the highest AVG sale of tequila						
SELECT AVG(total), sales.county						
FROM sales						
JOIN counties ON sales.county = counties.county						
WHERE population < 100000						
AND category_name ILIKE '%teq%'						
GROUP BY sales.county						
ORDER BY AVG(total) DESC;

						
--WAQ 3. Which stores sold the most bottles of tequila, greater than 10,000 bottles? Show top 10?						
SELECT SUM(bottle_qty) AS total_bottles_sold, stores.name AS store_name, county						
FROM sales						
	JOIN stores					
		USING (store)				
WHERE category_name ILIKE '%teq%'						
GROUP BY stores.name, county						
HAVING SUM(bottle_qty) > 10000						
ORDER BY SUM(bottle_qty) DESC						
LIMIT 10;						


--WAQ4.  Which counties have the highest % sale of tequila products?						
SELECT county, ROUND((AVG(tequila)*100),2) AS pct_tequila_sales						
FROM						
(SELECT county,						
	CASE					
		WHEN category_name ILIKE '%teq%'THEN 1				
		ELSE 0				
		END AS tequila				
	FROM sales) as table1					
GROUP BY county						
ORDER BY pct_tequila_sales DESC;						


--WAQ5. What are the top ten counties in terms of mL per capita for tequila products? (per capita means you need population. And county is only found in sales and counties table. Find a new way to calculate mL in sales table						
SELECT county, ROUND((mL_total/population),2) AS mL_per_cap						
FROM counties						
	JOIN					
		(SELECT county, SUM(liter_size*bottle_qty) as mL_total				
		FROM sales				
		WHERE sales.category_name ILIKE '%teq%'				
		GROUP BY county) as table1				
	USING (county)					
ORDER BY mL_per_cap DESC						
LIMIT 10;						
						
						
--WAQ6. What is the best selling proof of Tequila in terms of total bottles sold?						
SELECT SUM(bottle_qty) AS total_bottles_sold, proof						
FROM sales						
JOIN products						
	USING (category_name)					
WHERE category_name ILIKE '%teq%'						
GROUP BY proof						
ORDER BY SUM(bottle_qty) DESC;						


--WAQ7. What are the top stores for tequila sales(in terms of bottles sold), grouped by month, between Jan 2 2014 and Feb 26 2015?						
SELECT MIN(date) as earliest_date, MAX(date) as latest_date						
FROM sales;						
												
SELECT SUM(bottle_qty) AS bottles_of_tequila, stores.name,						
	DATE_TRUNC('month', sales.date) AS month					
FROM sales						
JOIN stores						
	USING (store)					
WHERE category_name ILIKE '%teq%'						
GROUP BY stores.name, month						
ORDER BY bottles_of_tequila DESC;						


--WAQ8. Show the breakdown of bottles of tequila sold for the Hy-vee #3 / Bdi / Des Moines store by month.						
SELECT SUM(bottle_qty) AS bottles_of_tequila, stores.name,						
	DATE_TRUNC('month', sales.date) AS month					
FROM sales						
JOIN stores						
	USING (store)					
WHERE category_name ILIKE '%teq%'						
GROUP BY stores.name, month						
HAVING stores.name ='Hy-vee #3 / Bdi / Des Moines'				--same for 'Central City 2', and other top stores		
ORDER BY month DESC;						
						
												
--WAQ9. Show breakdown of bottles of tequila sold in Polk county by month?						
SELECT SUM(bottle_qty) AS bottles_of_tequila, sales.county,						
	DATE_TRUNC('month', sales.date) AS month					
FROM sales						
WHERE category_name ILIKE '%teq%'						
GROUP BY sales.county, month						
HAVING sales.county ='Polk'				--same for other top counties		
ORDER BY month DESC;						
						
						
--WAQ10. Show breakdown of bottles of tequila sold for Jose Cuervo Especial Reposado Tequila by month?						
SELECT SUM(bottle_qty) AS bottles_of_tequila, sales.description,						
	DATE_TRUNC('month', sales.date) AS month					
FROM sales						
WHERE category_name ILIKE '%teq%'						
GROUP BY sales.description, month						
HAVING sales.description ='Jose Cuervo Especial Reposado Tequila'					--same for other top tequila brands	
ORDER BY month DESC;						