#Healthcare Insurance Claims Analysis Pipeline

📌 Project Overview

This project focuses on building an end-to-end data analytics pipeline for healthcare insurance claims. The goal is to clean, process, analyze, and visualize claims data to derive meaningful insights such as approval rates, fraud detection, and claim trends.

The project integrates multiple technologies including Python, AWS S3, Snowflake, and Power BI.

🎯 Problem Statement

Healthcare insurance companies deal with large volumes of claims data. However:

Data is often unclean and inconsistent Difficult to identify fraudulent or high-risk claims Lack of centralized system for analysis and reporting

👉 This project solves these issues by:

Cleaning and structuring raw data Storing data in a scalable cloud system Performing analytical queries Creating interactive dashboards for decision-making 

🏗️ Architecture Raw Data → Python (Cleaning & EDA) → AWS S3 → Snowflake → Power BI Dashboard ⚙️ Tech Stack Python (Pandas, NumPy, Matplotlib, Seaborn) AWS S3 (Data Storage) AWS IAM (Access Management) Snowflake (Data Warehouse) SQL (Data Analysis) Power BI (Visualization) 🧹 Data Cleaning & EDA (Python)

Key steps performed:

Handling missing values Removing duplicates Fixing incorrect data types Outlier detection Feature engineering: High_Claim_Flag Approved_gt_Claim_Flag

Example:

q1=np.quantile(df['Claim_Amount'],0.25)
q2=np.quantile(df['Claim_Amount'],0.50) 
q3=np.quantile(df['Claim_Amount'],0.75) 
IQR=q3-q1
lower=q1-(1.5IQR) 
upper=q3+(1.5IQR) 
print(lower,q1,q2,q3,upper)

☁️ AWS S3 Setup Steps: Created S3 bucket to store cleaned dataset Uploaded processed CSV file Enabled proper permissions 🔐 IAM Role Creation Created IAM Role with: S3 Read Access Trusted relationship with Snowflake Used role for secure data access from Snowflake ❄️ Snowflake Integration Steps: Created Storage Integration Connected S3 bucket to Snowflake Created external stage Loaded data into tables

Example:

CREATE OR REPLACE STORAGE INTEGRATION PBI_Integration
TYPE = EXTERNAL_STAGE 
STORAGE_PROVIDER = 'S3' 
ENABLED = TRUE 
STORAGE_AWS_ROLE_ARN = ''
STORAGE_ALLOWED_LOCATIONS = ('s3://dataanalyst.project/')
COMMENT = 'Optional Comment'

desc integration PBI_Integration

create stage healthcare_db.claims_schema.s1
url = 's3://dataanalyst.project/' 
storage_integration=PBI_Integration

copy into claims from @s1 file_format = (type=csv field_delimiter=',' skip_header=1 ) on_error = 'continue'

📊 SQL Analysis (Snowflake)

Performed analysis such as:

Total Claims Approval Rate Average Claim Amount Fraud Detection

Example:

--Fraud Analysis

select Fraud_Flag, count(*) as total, avg(Claim_Amount) as avg_claim from claims group by Fraud_Flag;

📈 Power BI Dashboard

Connected Snowflake to Power BI and built interactive dashboards:

Key Visuals:
KPI Cards: Total Claims, Fraud Rate %, Total Approved Amount
Charts: Claims by City, Claims by Policy Type, Fraud Analysis Funnel (Total → Processed → Approved)

<img width="799" height="488" alt="Image" src="https://github.com/user-attachments/assets/762a63b3-3a69-4fee-844c-84fb7210160d" />

🔍 Key Insights
Identified high claim patterns
Detected potential fraud cases 
Found approval trends across policies 

