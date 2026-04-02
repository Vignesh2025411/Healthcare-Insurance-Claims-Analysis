  CREATE OR REPLACE STORAGE INTEGRATION PBI_Integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = ''
  STORAGE_ALLOWED_LOCATIONS = ('s3://dataanalyst.project/')
  COMMENT = 'Optional Comment'

  desc integration PBI_Integration

create database healthcare_db;
use healthcare_db

CREATE SCHEMA claims_schema;

CREATE OR REPLACE TABLE claims (
    Claim_ID INT,
    Patient_Age INT,
    Gender STRING,
    City STRING,
    Policy_Type STRING,
    Hospital_Type STRING,
    Claim_Amount FLOAT,
    Approved_Amount FLOAT,
    Claim_Status STRING,
    Fraud_Flag INT,
    Days_To_Settle FLOAT,
    Claim_Amount_outlier INT,
    Approval_Rate FLOAT,
    High_Claim BOOLEAN,
    Approved_gt_Claim_Flag INT

);

select * from claims

create stage healthcare_db.claims_schema.s1
url = 's3://dataanalyst.project/'
storage_integration=PBI_Integration

copy into claims
from @s1
file_format = (type=csv field_delimiter=',' skip_header=1 )
on_error = 'continue'

list @s1

--KPI Metrics

select 
    count(*) AS total_claims,
    sum(case when Claim_Status='Approved' then 1 else 0 end) as approved_claims,
    round(approved_claims*100.0/total_claims,2) AS approval_rate
from claims;

--Fraud Analysis

select 
    Fraud_Flag,
    count(*) as total,
    avg(Claim_Amount) as avg_claim
from claims
group by Fraud_Flag;

--Policy Performance

select
    Policy_Type,
    count(*) as total_claims,
    avg(Approval_Rate) as avg_approval_rate
from claims
group by Policy_Type;

--Hospital Efficiency
select 
    Hospital_Type,
    avg(Days_To_Settle) as avg_days
from claims
group by Hospital_Type;

--Suspicious anomalies

select count(*) as Issues
from claims
where Approved_gt_Claim_Flag = TRUE;

--Funnel Analysis

select
    count(*) AS total_claims,
    sum(case when Claim_Status != 'Pending' then 1 end) as processed,
    SUM(case when Claim_Status = 'Approved' then 1 end) as approved
from claims;