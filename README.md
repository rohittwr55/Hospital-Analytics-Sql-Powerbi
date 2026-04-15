# 🏥 Hospital Patient & Treatment Analytics

## 🔹 Project Overview
This project focuses on analyzing hospital patient data to derive insights related to patient stay duration, treatment cost, recovery trends, and department performance.

The goal is to simulate a real-world healthcare analytics scenario by performing **end-to-end data analysis** using SQL and Power BI.

---

## 🔹 Problem Statement
Hospitals need data-driven insights to:
- Optimize patient stay duration  
- Reduce treatment costs  
- Improve recovery rates  
- Identify high-performing and inefficient departments  

This project answers these questions using structured data analysis.

---

## 🔹 Dataset
- 500+ rows of messy hospital data  
- Multiple tables:
  - Patients  
  - Admissions  
  - Doctors  
  - Treatments  

### Data Issues Identified:
- Missing values (Discharge Date, Department, Age, Cost)
- Duplicate records
- Invalid dates (Discharge before Admission)
- Inconsistent text values

---

## 🔹 Tools & Technologies
- SQL Server (Data Analysis)
- Power BI (Visualization & Modeling)
- Power Query (Data Cleaning)
- Excel (Dataset)

---

## 🔹 Project Workflow

### 1️⃣ Data Cleaning (SQL + Power Query)
- Identified NULL values across columns  
- Counted missing records (e.g., 39 NULL discharge dates)  
- Detected invalid records (19 rows where discharge < admission)  
- Removed incorrect data  
- Standardized categorical fields  

---

### 2️⃣ SQL Analysis

#### 🔸 Data Quality Checks
- Duplicate Patient & Admission analysis  
- NULL value analysis per column  
- Invalid date detection  

#### 🔸 Feature Engineering
- Length of Stay calculation  
- Month & Year extraction  

#### 🔸 Core Analysis
- Total Patients: 116  
- Total Admissions: 181  
- Patients by Department & Disease  

#### 🔸 Intermediate Analysis
- Average Length of Stay: 5 days  
- Recovery Rate per Disease  
- Emergency vs Routine comparison  

#### 🔸 Advanced SQL
- Window Functions (Ranking departments & treatments)  
- Repeat Patient Analysis (Cohort)  
- Severity vs Stay Analysis  
- Revenue ranking by department  

---

### 3️⃣ Data Modeling
Implemented **Star Schema**:

- **Fact Tables:**
  - Admissions  
  - Treatments  

- **Dimension Tables:**
  - Patients  
  - Doctors  
  - Date Table  

### Relationships:
- Patients → Admissions (1:M)  
- Doctors → Admissions (1:M)  
- Admissions → Treatments (1:M)  
- Date → Admissions (1:M)  

---

### 4️⃣ DAX Measures (9 Measures Created)

- Total Patients 
- Total Revenue
- Total Cost
- Total Admissions  
- Average Length of Stay  
- Recovery Rate  
- Cost per Patient  
- Revenue % Contribution
- 30 day rolling admission

<img width="243" height="323" alt="image" src="https://github.com/user-attachments/assets/c97e685a-9697-4c8a-983a-3b9d352156a9" />

---

### 5️⃣ Dashboard

## 📊 Pages Included:

### 🔹 Overview
- Total Patients  
- Total Revenue  
- Avg Length of Stay  
- Recovery Rate  
- Monthly Admission and Revenue  

---

### 🔹 Department Analysis
- Patients by Department  
- Cost by Department  
- Avg Stay by Department  

---

### 🔹 Disease & Treatment Analysis
- Patient by Diseases  
- Treatment Cost Distribution  
- Recovery Rate by Disease  

---

## 🔹 Key Insights

- ICU generates highest revenue but also has longer patient stays  
- Stroke shows highest recovery rate among diseases  
- Emergency admissions have higher cost compared to routine cases  
- Repeat patients indicate chronic disease patterns  
- Missing department data impacts accuracy of department-level analysis  

---

## 🔹 Key Learnings

- Importance of data cleaning before analysis  
- Use of SQL for deep data analysis and validation  
- Building scalable data models using star schema  
- Writing DAX for business KPIs  
- Converting data into actionable insights  
 

---

## 🔹 Dashboard Preview
<img width="1131" height="579" alt="image" src="https://github.com/user-attachments/assets/6a72a2cc-a860-4457-8deb-055e4fdda39b" />
<img width="1028" height="612" alt="image" src="https://github.com/user-attachments/assets/56ec851e-dc62-42e2-83da-2f861459a3b0" />
<img width="1004" height="606" alt="image" src="https://github.com/user-attachments/assets/0fa6543c-607c-40d2-9f7e-360f57545b71" />


