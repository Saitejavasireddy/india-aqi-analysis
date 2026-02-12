# india-aqi-analysis
Analysis of air quality across 15 Indian cities to identify top 5 cities for clean air campaign.

## The Question

We had funding for 5 cities. Which ones should we target, and why?

## What I Found

**Worst 5 cities by average AQI:**
1. Kanpur (193)
2. Delhi (190)
3. Lucknow (179)
4. Patna (174)
5. Varanasi (170)

4 out of 5 are in Uttar Pradesh. That's not a coincidence.

**Main pollutant:** PM2.5 and PM10 — particulate matter from vehicles, construction, and crop burning.

**Worst months:** January and February. Winter traps pollution close to the ground.

**Best months:** May and June. Monsoon winds clear the air.

## Recommendation

Target these 5 cities. Focus on PM2.5 reduction. Run the campaign before winter (October-November) when AQI spikes.

## Tools Used

- PostgreSQL — queried the data
- Python (pandas, matplotlib, seaborn) — cleaned data and made charts
- Tableau — built the dashboard

## Files

- `aqi_india.csv` — raw data (15 cities, 6 months, 180 readings)
- `aqi_analysis.sql` — all SQL queries
- `aqi_analysis.ipynb` — Python notebook with analysis
- `chart1_city_aqi.png` — average AQI by city
- `chart2_monthly_trend.png` — AQI trend over months
- `chart3_worst_cities_trend.png` — monthly trend for worst 5 cities
- `chart4_pollutants.png` — pollutant levels comparison
- `chart5_state_aqi.png` — state-level AQI
- `aqi_dashboard.twbx` — Tableau dashboard

## Data Source

Based on India's Central Pollution Control Board AQI data structure.
