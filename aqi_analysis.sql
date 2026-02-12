-- Query 1: Average AQI by city
SELECT city, ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_data
GROUP BY city
ORDER BY avg_aqi DESC;

-- Query 2: Main pollutants in worst cities
SELECT city, 
       ROUND(AVG(pm25), 2) AS avg_pm25,
       ROUND(AVG(pm10), 2) AS avg_pm10,
       ROUND(AVG(no2), 2) AS avg_no2,
       ROUND(AVG(so2), 2) AS avg_so2,
       ROUND(AVG(co), 2) AS avg_co
FROM aqi_data
WHERE city IN ('Kanpur', 'Delhi', 'Lucknow', 'Patna', 'Varanasi')
GROUP BY city
ORDER BY avg_pm25 DESC;

-- Query 3: Monthly trend
SELECT 
    EXTRACT(MONTH FROM date) AS month,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_data
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY month;

-- Query 4: Monthly trend for worst 5 cities
SELECT 
    city,
    EXTRACT(MONTH FROM date) AS month,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM aqi_data
WHERE city IN ('Kanpur', 'Delhi', 'Lucknow', 'Patna', 'Varanasi')
GROUP BY city, EXTRACT(MONTH FROM date)
ORDER BY city, month;

-- Query 5: State-level analysis
SELECT state, 
       ROUND(AVG(aqi), 2) AS avg_aqi,
       COUNT(DISTINCT city) AS num_cities
FROM aqi_data
GROUP BY state
ORDER BY avg_aqi DESC;

-- Query 6: Days in each AQI category by city
SELECT city, aqi_category, COUNT(*) AS days
FROM aqi_data
GROUP BY city, aqi_category
ORDER BY city, days DESC;

-- Query 7: Worst single readings
SELECT city, date, aqi, aqi_category, pm25, pm10
FROM aqi_data
WHERE aqi > 300
ORDER BY aqi DESC;

-- Query 8: Best vs worst months comparison
SELECT 
    city,
    ROUND(AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (1, 2) THEN aqi END), 2) AS winter_avg,
    ROUND(AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (5, 6) THEN aqi END), 2) AS summer_avg
FROM aqi_data
GROUP BY city
ORDER BY winter_avg DESC;