# 🚖 TaxiTrak - NYC Yellow Cab Data Analysis  

## 📌 Overview  
**TaxiTrak** is a data-driven project that leverages five years of NYC Yellow Cab trip data to build a scalable data warehouse. Using a **star schema** for efficient data organization, the project enables advanced **business intelligence (BI) queries and visualizations** to drive insights into taxi operations, customer behavior, and revenue optimization.  

## 🎯 Project Goals  
- **Customer Behavior Analysis**: Identify trip patterns based on passenger count, distance, fare, and payment types.  
- **Quality of Service**: Analyze trip durations and customer feedback to improve service.  
- **Revenue Maximization**: Assess pricing strategies and fare distributions for better revenue.  
- **Optimizing Operations**: Identify peak hours and high-demand locations for efficient taxi dispatch.  
- **Cost Analysis**: Minimize operational costs by analyzing surcharges and toll expenses.  

## 📊 Data & Tools  

### 📁 Dataset  
- **Source**: NYC Taxi & Limousine Commission (TLC)  
- **Timeframe**: January 2019 - November 2023  
- **Size**: ~10 million records, sampled at 5% per month  
- **Attributes**: 18 fields covering trip details, fares, locations, and timestamps  

### 🛠️ Tech Stack  
- **Python** (Pandas, SQLAlchemy) - Data extraction & transformation  
- **MySQL** - Data warehouse implementation  
- **Bash Scripting** - Automated ETL pipeline  
- **Tableau** - Data visualization and BI dashboards  

## 🌟 Star Schema Design  
TaxiTrak follows a **star schema** to optimize queries and improve analytical performance.  

**📌 Fact Table**  
- `factTableAll` - Stores core trip data (fares, duration, routes, etc.)  

**📌 Dimension Tables**  
- `vendorDimension` - Taxi service providers  
- `dateDimension` - Breakdown of trip dates  
- `timeDimension` - Time details (hour, minute, second)  
- `locationDimension` - Pickup and drop-off locations  
- `rateCodeDimension` - Fare category details  
- `paymentDimension` - Payment types  

## 📈 Business Intelligence Insights  

### 🚕 Business Use Cases  
- **Revenue Trends**  
  - Monthly revenue breakdown by vendor  
  - Seasonal revenue patterns  
- **Trip Demand Patterns**  
  - Weekday vs. weekend analysis  
  - High-demand pickup/drop-off zones  
- **Airport Route Analysis**  
  - Revenue impact of airport trips  
  - Extra charges comparison (airport vs. non-airport trips)  
- **Long-Distance Trip Efficiency**  
  - Identifying underperforming long-distance routes  
  - Optimizing fare strategies for profitability  

## **How to Run the Project**  

#### **Setup:**  
**Install Dependencies**:  
pip install pandas mysql-connector-python sqlalchemy
 **Setup the MySQL database**:  
Import the schema from schema.sql. 
**Run the ETL Pipeline**
python main.py YYYY-MM
Query and Analyze data 
Execute BI queries in MySQL to generate insights.
Connect Tableau to MySQL for real-time analytics.
## 🛠️ Tech Stack  
- **Python** (Pandas, SQLAlchemy) – Data extraction, transformation, and loading into MySQL  
- **MySQL** – Data warehouse implementation, star schema modeling, and querying  
- **Bash Scripting** – Automating ETL and incremental updates  
- **Tableau** – Data visualization, BI dashboards, and OLAP operations (drill-down, roll-up)  
- **Jupyter Notebook** – Data preprocessing and ETLT execution  
