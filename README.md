# India AQI Analysis

![dashboard_screenshot png](https://github.com/user-attachments/assets/7b73b351-5c3f-4fcb-b0a6-1451be0740cb)



**[View Interactive Dashboard on Tableau Public](https://public.tableau.com/shared/T33F4WZ7Q?:display_count=n&:origin=viz_share_link)**

---

## Business Problem

A nonprofit has funding for a clean air campaign in **5 cities**. They asked:
- Which cities should we target?
- What's causing the pollution?
- When should we launch?

## Key Findings

| Finding | Insight |
|---------|---------|
| Worst 5 cities | Kanpur (193), Delhi (190), Lucknow (179), Patna (174), Varanasi (170) |
| Pattern | 4 of 5 are in Uttar Pradesh — state-level policy needed |
| Main pollutant | PM2.5 (correlates 0.99 with PM10) — same source |
| Seasonal swing | 40-50% improvement from winter to summer |
| Root cause | Winter inversion + crop burning + vehicle emissions |

## Recommendation

**Target cities:** Kanpur, Delhi, Lucknow, Patna, Varanasi

**Focus on:** PM2.5 reduction (vehicles, crop burning, construction dust)

**Timing:** Launch in October-November, before winter AQI spike

---

## Analysis Approach

### 1. SQL Analysis
Wrote queries to answer specific business questions:
- City rankings with priority levels
- Pollutant breakdown by source type
- Seasonal patterns with % change calculations
- Correlation between pollutants
- Weighted pollution score (PM2.5 weighted 40% since it's deadliest)

### 2. Python Visualization
Created charts showing:
- City-wise AQI comparison
- Monthly trends
- Pollutant correlation matrix
- Winter vs summer comparison
- Weighted pollution scores

### 3. Tableau Dashboard
Interactive dashboard with:
- City AQI rankings
- Trend analysis
- Pollutant breakdown
- State-level view

---

## Technical Details

**Data:** 15 Indian cities, 6 months (Jan-Jun 2024), 180 readings

**Tools:**
- PostgreSQL — data storage and SQL analysis
- Python (pandas, matplotlib, seaborn) — data processing and visualization
- Tableau — interactive dashboard

**Weighted Pollution Score Formula:**
```
Score = PM2.5 × 0.40 + PM10 × 0.25 + NO2 × 0.20 + SO2 × 0.10 + CO × 0.05
```
PM2.5 weighted highest because it penetrates deepest into lungs.

---

## Files

| File | Description |
|------|-------------|
| `aqi_india.csv` | Raw data |
| `aqi_analysis.sql` | SQL queries with business context |
| `aqi_analysis.ipynb` | Python notebook |
| `chart1-8.png` | Visualizations |
| `city_summary_stats.csv` | Summary statistics |
| `aqi_dashboard.twbx` | Tableau workbook |

---

## Data Source

Based on India's Central Pollution Control Board (CPCB) AQI data structure.
