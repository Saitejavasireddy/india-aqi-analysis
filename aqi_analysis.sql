-- ============================================================
-- INDIA AQI ANALYSIS - SQL QUERIES
-- Business Question: Which 5 cities should we target for a 
-- clean air campaign, and why?
-- ============================================================


-- ============================================================
-- QUESTION 1: Which cities have the worst air quality?
-- Why it matters: We need to identify where to focus our funding.
-- ============================================================

SELECT 
    city, 
    state,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    CASE 
        WHEN AVG(aqi) > 200 THEN 'Severe - Immediate Action'
        WHEN AVG(aqi) > 150 THEN 'Very Poor - High Priority'
        WHEN AVG(aqi) > 100 THEN 'Poor - Moderate Priority'
        ELSE 'Acceptable'
    END AS priority_level
FROM aqi_data
GROUP BY city, state
ORDER BY avg_aqi DESC;


-- ============================================================
-- QUESTION 2: What's driving the pollution in the worst cities?
-- Why it matters: Different pollutants need different solutions.
-- PM2.5 = vehicles/burning, NO2 = traffic, SO2 = industry
-- ============================================================

SELECT 
    city, 
    ROUND(AVG(pm25), 2) AS avg_pm25,
    ROUND(AVG(pm10), 2) AS avg_pm10,
    ROUND(AVG(no2), 2) AS avg_no2,
    ROUND(AVG(so2), 2) AS avg_so2,
    ROUND(AVG(co), 2) AS avg_co,
    ROUND(AVG(pm25) / NULLIF(AVG(no2), 0), 2) AS pm25_to_no2_ratio
FROM aqi_data
WHERE city IN ('Kanpur', 'Delhi', 'Lucknow', 'Patna', 'Varanasi')
GROUP BY city
ORDER BY avg_pm25 DESC;


-- ============================================================
-- QUESTION 3: When is pollution worst? (Seasonal pattern)
-- Why it matters: Campaign timing matters. Launch before the 
-- worst months, not during.
-- ============================================================

SELECT 
    EXTRACT(MONTH FROM date) AS month,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    ROUND(AVG(pm25), 2) AS avg_pm25,
    ROUND(
        (AVG(aqi) - LAG(AVG(aqi)) OVER (ORDER BY EXTRACT(MONTH FROM date))) 
        / NULLIF(LAG(AVG(aqi)) OVER (ORDER BY EXTRACT(MONTH FROM date)), 0) * 100
    , 2) AS pct_change_from_prev_month
FROM aqi_data
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY month;


-- ============================================================
-- QUESTION 4: Winter vs Summer - How much does AQI improve?
-- Why it matters: Shows the impact of seasonal factors 
-- (crop burning, weather patterns)
-- ============================================================

SELECT 
    city,
    ROUND(AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (1, 2) THEN aqi END), 2) AS winter_avg,
    ROUND(AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (5, 6) THEN aqi END), 2) AS summer_avg,
    ROUND(
        (AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (1, 2) THEN aqi END) - 
         AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (5, 6) THEN aqi END)) /
        NULLIF(AVG(CASE WHEN EXTRACT(MONTH FROM date) IN (1, 2) THEN aqi END), 0) * 100
    , 2) AS pct_improvement_winter_to_summer
FROM aqi_data
GROUP BY city
ORDER BY pct_improvement_winter_to_summer DESC;


-- ============================================================
-- QUESTION 5: State-level analysis - Is UP really the problem?
-- Why it matters: State-level policy affects multiple cities.
-- Targeting one state might be more efficient than 5 cities.
-- ============================================================

SELECT 
    state, 
    ROUND(AVG(aqi), 2) AS avg_aqi,
    COUNT(DISTINCT city) AS cities_monitored,
    SUM(CASE WHEN aqi > 200 THEN 1 ELSE 0 END) AS severe_days,
    ROUND(SUM(CASE WHEN aqi > 200 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_severe_days
FROM aqi_data
GROUP BY state
ORDER BY avg_aqi DESC;


-- ============================================================
-- QUESTION 6: Correlation check - Does PM2.5 track with NO2?
-- Why it matters: If they correlate, both come from the same 
-- source (likely vehicles). If not, separate interventions needed.
-- ============================================================

SELECT 
    city,
    ROUND(CORR(pm25, no2)::numeric, 3) AS pm25_no2_correlation,
    ROUND(CORR(pm25, pm10)::numeric, 3) AS pm25_pm10_correlation,
    ROUND(CORR(pm25, so2)::numeric, 3) AS pm25_so2_correlation,
    CASE 
        WHEN CORR(pm25, no2) > 0.8 THEN 'Strong - likely same source'
        WHEN CORR(pm25, no2) > 0.5 THEN 'Moderate - partial overlap'
        ELSE 'Weak - different sources'
    END AS interpretation
FROM aqi_data
GROUP BY city
ORDER BY pm25_no2_correlation DESC;


-- ============================================================
-- QUESTION 7: Create a weighted Pollution Score
-- Why it matters: AQI alone doesn't tell the full story.
-- PM2.5 is deadlier than PM10, so we weight it higher.
-- Weights: PM2.5 (40%), PM10 (25%), NO2 (20%), SO2 (10%), CO (5%)
-- ============================================================

SELECT 
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi,
    ROUND(
        AVG(pm25) * 0.40 + 
        AVG(pm10) * 0.25 + 
        AVG(no2) * 0.20 + 
        AVG(so2) * 0.10 + 
        AVG(co) * 10 * 0.05
    , 2) AS weighted_pollution_score,
    RANK() OVER (ORDER BY 
        AVG(pm25) * 0.40 + 
        AVG(pm10) * 0.25 + 
        AVG(no2) * 0.20 + 
        AVG(so2) * 0.10 + 
        AVG(co) * 10 * 0.05 
    DESC) AS pollution_rank
FROM aqi_data
GROUP BY city
ORDER BY weighted_pollution_score DESC;


-- ============================================================
-- QUESTION 8: Critical days - When did AQI cross hazardous levels?
-- Why it matters: These are the days people couldn't go outside.
-- ============================================================

SELECT 
    city, 
    date, 
    aqi, 
    aqi_category, 
    pm25, 
    pm10,
    CASE 
        WHEN aqi > 300 THEN 'Health Emergency'
        WHEN aqi > 200 THEN 'Very Unhealthy'
        ELSE 'Unhealthy'
    END AS severity
FROM aqi_data
WHERE aqi > 200
ORDER BY aqi DESC;


-- ============================================================
-- SUMMARY OF FINDINGS
-- ============================================================
-- 1. Top 5 worst cities: Kanpur, Delhi, Lucknow, Patna, Varanasi
-- 2. 4 of 5 are in Uttar Pradesh - state-level intervention needed
-- 3. PM2.5 is the primary pollutant (correlates strongly with AQI)
-- 4. Winter months (Jan-Feb) are 40-50% worse than summer
-- 5. Recommendation: Launch campaign in Oct-Nov, before winter spike
-- ============================================================