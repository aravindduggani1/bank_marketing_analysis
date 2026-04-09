# 🏦 Bank Marketing Campaign — Data Analysis Project

> **Exploratory Data Analysis of a Portuguese bank's telemarketing campaign using SQL and Power BI**

---

## 📌 Project Overview

This project analyses a real-world bank marketing dataset to uncover sales performance patterns, customer segments, and revenue trends. The goal is to answer a key business question:

> *"Why is the bank's campaign conversion rate so low, and which customers, timing, and strategies would maximise subscriptions to term deposits?"*

---

## 🎯 Business Problem

A Portuguese bank ran a telemarketing campaign to sell term deposit subscriptions. Despite contacting thousands of customers, only a small fraction subscribed. This analysis identifies:

- **When** the bank should run campaigns (best/worst months)
- **Who** to target (highest-converting customer segments)
- **How** to contact customers (optimal frequency and method)
- **Why** most campaigns fail (data quality and targeting issues)

---

## 📊 Key Findings

| # | Finding | Impact |
|---|---------|--------|
| 1 | Overall conversion rate is only **11.52%** | 🔴 High |
| 2 | Subscribed customers had **2.5x longer calls** (553s vs 220s) | 🔴 High |
| 3 | **May** gets the most contacts (1,398) but worst conversion (6.65%) | 🔴 High |
| 4 | **October** converts at 46.25% but receives only 80 contacts | 🔴 High |
| 5 | **Retired customers** convert at 37.35% — highest of any segment | 🔴 High |
| 6 | **Blue-collar** workers: largest group contacted, lowest conversion (7.29%) | 🔴 High |
| 7 | Calling 7+ times drops conversion to **5.66%** vs 13.84% for first call | 🔴 High |
| 8 | **29% of database** has unknown contact type — converts at only 4.61% | 🔴 High |
| 9 | Debt-free customers convert at **16.88%** vs 6.16% for dual-loan holders | 🟡 Medium |
| 10 | High balance customers (£1,501–£5,000) convert best at **16.87%** | 🟡 Medium |

---

## 💡 Top 3 Recommendations

1. **Shift campaign timing to Q4** — October, September, and December convert at 32–46%. Reduce May/July outreach which yields only 6–8%.
2. **Prioritise retired and young customers** — Retired (37.35%) and young (20.72%) segments convert far above the 11.52% average.
3. **Implement a 2-contact maximum policy** — Conversion drops after every additional call. Stop wasting budget on customers contacted 7+ times.

---

## 🗂️ Project Structure

```
bank-marketing-analysis/
│
├── data/
│   └── bank_dataset.xlsx          # Cleaned dataset (4,521 rows, 17 columns)
│
├── sql/
│   ├── 01_create_table.sql        # Database and table setup
│   ├── 02_overall_performance.sql # Conversion rate & customer profile
│   ├── 03_monthly_trends.sql      # Month-by-month analysis
│   ├── 04_job_analysis.sql        # Job type conversion rates
│   ├── 05_balance_segments.sql    # Balance group analysis
│   ├── 06_contact_frequency.sql   # Impact of repeated calling
│   ├── 07_contact_method.sql      # Channel analysis
│   ├── 08_age_groups.sql          # Age segment analysis
│   └── 09_debt_analysis.sql       # Loan burden impact
│
├── report/
│   └── EDA_Report_Bank_Marketing.docx   # Full analysis report with findings
│
├── dashboard/
│   └── bank_sales_dashboard.pbix  # Power BI dashboard
│
└── README.md
```

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **MySQL** | Data storage, querying, and analysis |
| **MySQL Workbench** | SQL query execution and data exploration |
| **Microsoft Excel** | Data cleaning and initial inspection |
| **Power BI** | Dashboard and visualisation |
| **Microsoft Word** | EDA report documentation |

---

## 📁 Dataset

- **Source:** [UCI Machine Learning Repository — Bank Marketing Dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing)
- **Records:** 4,521 customer entries
- **Columns:** 17 attributes (demographic, financial, campaign)
- **Target variable:** `y` — Did the customer subscribe? (yes/no)
- **Data quality:** Zero null values

---

## 🚀 How to Reproduce

**1. Set up the database**
```sql
CREATE DATABASE bank;
USE bank;
```

**2. Run the table creation script**
```sql
-- See sql/01_create_table.sql
```

**3. Import the dataset**
- Use MySQL Workbench Table Data Import Wizard
- Select `data/bank_dataset.xlsx`
- Follow the import wizard steps

**4. Run queries in order**
```
sql/02_overall_performance.sql  →  sql/09_debt_analysis.sql
```

**5. Open the dashboard**
- Open `dashboard/bank_sales_dashboard.pbix` in Power BI Desktop
- Refresh data source to point to your local MySQL connection

---

## 📈 Dashboard Preview

> *Power BI dashboard covering conversion trends, segment performance, and monthly campaign analysis — see `/dashboard` folder*

---

## 👤 Author

**Data Analyst**
- 📧 aravindduggani2@gmail.com
- 🔗 [LinkedIn](www.linkedin.com/in/duggani-aravind-73b447277)
- 💻 [GitHub](https://github.com/aravindduggani1)

---

## 📄 License

This project is for educational and portfolio purposes. Dataset credit: [Moro et al., 2014] UCI Machine Learning Repository.

