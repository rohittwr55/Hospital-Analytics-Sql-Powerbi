select * from [dbo].[Admission]

--Find Duplicate Admission ID
select count(distinct Admission_ID) from [dbo].[Admission] -- No Duplicate Admission ID

--Find Duplicate Patient ID
select 
count(distinct Patient_ID)
from dbo.Admission -- Out of 200 121 patient are new and 79 are old patient or came for multiple treatment
--created a flag for analysing
with CTE_flagged as 
(
SELECT *,
       COUNT(*) OVER (PARTITION BY Patient_ID) AS patient_count,
       CASE 
           WHEN COUNT(*) OVER (PARTITION BY Patient_ID) = 1 THEN 1
           ELSE 2
       END AS patient_flag
FROM dbo.Admission
)
select * from CTE_flagged
where patient_flag > 1



--Find Duplicate Doctor ID
select count(distinct Doctor_ID) from [dbo].[Admission] -- Total 20 unique Doctor ID

--Find count of Null admission date
SELECT 
    COUNT(*) AS total_rows,
    COUNT(Admission_Date) AS non_null_age,
    COUNT(*) - COUNT(Admission_Date) AS null_age_count -- Total 0 null admission date
FROM [dbo].[Admission];

--Find count Null discharge date
SELECT 
    COUNT(*) AS total_rows,
    COUNT(Discharge_Date) AS non_null_age,
    COUNT(*) - COUNT(Discharge_Date) AS null_age_count -- Total 39 null discharge date
FROM [dbo].[Admission];

--Find distinct department
SELECT 
    COUNT(*) AS total_rows,
    COUNT(Department) AS non_null_age,
    COUNT(*) - COUNT(Department) AS null_age_count -- Total 42 null Department data and distinct 4 department
FROM [dbo].[Admission];

--Total no of disease for which patient are admitted 
select distinct (Disease) from [dbo].[Admission] --Total 4 distinct disease in this dataset

--Check if admission date is after discharge date then data will be invalid
select * from [dbo].[Admission]
where Admission_Date > Discharge_Date --total 19 record are having discharge date is before admission date which mean these are invalida record

--Drop these invalid data
DELETE FROM [dbo].[Admission] where Admission_Date > Discharge_Date

--Final table after delete
select 
Admission_ID,
Patient_ID,
Doctor_ID,
cast(Admission_Date as date) as Admission_date,
Discharge_Date,
Department,
Disease,
Severity,
Admission_Type,
Outcome
from dbo.Admission

-----------Added new column Admission date and discharge date and data type is date 

select distinct Admission_Date, TRY_CONVERT(DATE, Admission_Date, 120) AS converted_date from dbo.Admission

-- Step 1: Add new column
ALTER TABLE dbo.Admission
ADD discharge_date_new DATE;

-- Step 1: Add new column
ALTER TABLE dbo.Admission
ADD admission_date_new DATE;

-- Step 2: Update the column
UPDATE dbo.Admission
SET discharge_date_new = TRY_CONVERT(DATE, Discharge_Date, 120); -- adjust format

UPDATE dbo.Admission
SET admission_date_new = TRY_CONVERT(DATE, Admission_Date, 120); -- adjust format

-- Step 3: Verify data
SELECT * FROM dbo.Admission;

-- Step 4: Drop old column
ALTER TABLE dbo.Admission
DROP COLUMN Admission_date;

ALTER TABLE dbo.Admission
DROP COLUMN Discharge_date;

--calculate Length of stay
select *, DATEDIFF(DAY, admision_date_new, discharge_date_new) from dbo.Admission

-- Step 1: Add new column
ALTER TABLE dbo.Admission
ADD LengthOfStay int;

-- Step 2: Update the column
UPDATE dbo.Admission
SET LengthOfStay = DATEDIFF(DAY, admision_date_new, discharge_date_new)

---------------Find month for both Admission date and Discharge date
select 
*,
datename(month, admision_date_new) as AdmissionMonth,
datename(month,discharge_date_new) as DischargeMonth
from dbo.Admission

-- Step 1: Add new column
ALTER TABLE dbo.Admission
ADD AdmissionMonth nvarchar(255);

ALTER TABLE dbo.Admission
ADD DischargeMonth nvarchar(255);

-- Step 2: Update the column
UPDATE dbo.Admission
SET AdmissionMonth = datename(month, admision_date_new)

UPDATE dbo.Admission
SET DischargeMonth = datename(month, discharge_date_new)

-- Patient Per Department
select 
count(Patient_ID) as Patient_Count,
Department
from dbo.Admission
group by Department

--Patient per disease

select 
COUNT(Patient_ID) as Patient_count,
Disease
from dbo.Admission
group by Disease

--Avg length of stay
select 
AVG(LengthOfStay) as AverageLengthOfstay
from dbo.Admission

--Recovery rate per disease

SELECT 
    Disease,
    ROUND(
        COUNT(CASE WHEN Outcome = 'Recovered' THEN 1 END) * 100.0 
        / COUNT(CASE WHEN Outcome IS NOT NULL THEN 1 END), 
    2) AS RecoveryRate_Percentage,
    ROUND(
        COUNT(CASE WHEN Outcome = 'Not Recovered' THEN 1 END) * 100.0 
        / COUNT(CASE WHEN Outcome IS NOT NULL THEN 1 END), 
    2) AS NotRecoverdRate_Percentage
FROM dbo.Admission
GROUP BY Disease;

--Emergency vs Routine comparision
select * from dbo.Admission

--No of patient for Enegery vs Routing
select 
count(Patient_ID),
Department,
Disease,
Severity,
Admission_Type
Outcome
from dbo.Admission
group by Admission_Type
, Department
, Disease
, Severity
, Outcome

---Rank Department by Revenue
select 
ad.Department,
SUM(tc.RevenueGenerated) AS total_revenue,
RANK() OVER (ORDER BY SUM(tc.RevenueGenerated) DESC) AS dept_rank
from dbo.Admission ad
inner join dbo.TreatmentCost tc
on ad.Admission_ID = tc.admission_ID
group by ad.Department

--Patient with multiple stay . Cohort / Repeat Analysis

SELECT ad.Patient_ID, COUNT(ad.Patient_ID) AS TotalStays, pt.Age, pt.Gender, pt.City
FROM dbo.Admission as ad
inner join dbo.Patient pt
on ad.Patient_ID = pt.Patient_ID
GROUP BY ad.Patient_ID, pt.Age, pt.Gender, pt.City
Having count(ad.Patient_ID) > 1

--Avg stay by sevirity 
select 
AVG(LengthOfStay) as AvgLengthOfStay,
Severity
from dbo.Admission
group by Severity 

--Top 20% treatments contributing to revenue by department, Disease and Admission Type

WITH treatment_revenue AS (
    SELECT 
        ad.Department,
        ad.Disease,
        ad.Admission_Type,
        SUM(tc.RevenueGenerated) AS total_revenue
    FROM dbo.Admission ad
inner join dbo.TreatmentCost tc
on ad.Admission_ID = tc.Admission_ID
    GROUP BY 
        ad.Department,
        ad.Disease,
        ad.Admission_Type
),

ranked_data AS (
    SELECT *,
        SUM(total_revenue) OVER (
            PARTITION BY ad.Department,
        ad.Disease,
        ad.Admission_Type
        ) AS group_total,

        SUM(total_revenue) OVER (
            PARTITION BY ad.Department,
        ad.Disease,
        ad.Admission_Type
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM dbo.Admission ad
inner join dbo.TreatmentCost tc
on ad.Admission_ID = tc.Admission_ID
)

SELECT *
FROM ranked_data
WHERE (cumulative_revenue * 1.0 / group_total) <= 0.2
ORDER BY Department, Disease, Admission_Type, total_revenue DESC;
