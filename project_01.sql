

-- ----------------------------------------------------------------
-- HOW TO LOAD THE DATASET:
--
-- Option A — MySQL Workbench (recommended):
--   Right-click the 'bank' table → Table Data Import Wizard
--   Select bank_dataset.xlsx → follow the steps
--
-- Option B — LOAD DATA (update the path to your local file):
--   LOAD DATA INFILE '/your/local/path/bank_dataset.csv'
--   INTO TABLE bank
--   FIELDS TERMINATED BY ','
--   ENCLOSED BY '"'
--   LINES TERMINATED BY '\n'
--   IGNORE 1 ROWS;
-- ----------------------------------------------------------------

-- Verify data loaded correctly
SELECT COUNT(*) AS total_rows FROM bank;   -- expected: 4521
SELECT * FROM bank LIMIT 5;

-- Create a working copy to preserve raw data
CREATE TABLE IF NOT EXISTS bank_s1
SELECT * FROM bank;

SELECT * FROM bank_s1 LIMIT 5;


-- ----------------------------------------------------------------
-- SECTION 2: EXPLORATORY DATA ANALYSIS
-- ----------------------------------------------------------------


-- ================================================================
-- QUERY 1: Overall subscription rate
-- Business question: How effective is the campaign overall?
-- Finding: Only 11.52% of customers subscribed — 88.48% did not.
-- ================================================================

SELECT
    COUNT(*)                                                                    AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscribed,
    SUM(CASE WHEN y = 'no'  THEN 1 ELSE 0 END)                                AS not_subscribed,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct
FROM bank_s1;


-- ================================================================
-- QUERY 2: Average customer profile — subscribed vs not subscribed
-- Business question: What does a typical subscriber look like?
-- Finding: Subscribers have 2.5x longer call duration (553s vs 220s)
-- ================================================================

SELECT
    ROUND(AVG(age), 1)                                                         AS avg_age_all,
    ROUND(AVG(CASE WHEN y = 'yes' THEN age     END), 1)                       AS avg_age_subscribed,
    ROUND(AVG(CASE WHEN y = 'no'  THEN age     END), 1)                       AS avg_age_not_subscribed,
    ROUND(AVG(balance), 0)                                                     AS avg_balance_all,
    ROUND(AVG(CASE WHEN y = 'yes' THEN balance END), 0)                       AS avg_balance_subscribed,
    ROUND(AVG(CASE WHEN y = 'no'  THEN balance END), 0)                       AS avg_balance_not_subscribed,
    ROUND(AVG(duration), 0)                                                    AS avg_call_duration_all,
    ROUND(AVG(CASE WHEN y = 'yes' THEN duration END), 0)                      AS avg_call_duration_subscribed,
    ROUND(AVG(CASE WHEN y = 'no'  THEN duration END), 0)                      AS avg_call_duration_not_subscribed
FROM bank_s1;


-- ================================================================
-- QUERY 3: Conversion rate by month
-- Business question: Which months drive the highest subscriptions?
-- Finding: Oct (46.25%) is best. May (6.65%) is worst despite
--          having the highest contact volume (1,398 contacts).
-- ================================================================

SELECT
    month,
    COUNT(*)                                                                    AS total_contacts,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct
FROM bank_s1
GROUP BY month
ORDER BY conversion_rate_pct DESC;


-- ================================================================
-- QUERY 4: Conversion rate by job type
-- Business question: Which job types are most likely to subscribe?
-- Finding: Retired (23.48%) and students (22.62%) convert best.
--          Blue-collar workers (7.29%) convert least despite being
--          the largest group contacted (946 contacts).
-- ================================================================

SELECT
    job,
    COUNT(*)                                                                    AS total_contacts,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct,
    ROUND(AVG(balance), 0)                                                     AS avg_balance
FROM bank_s1
GROUP BY job
ORDER BY conversion_rate_pct DESC;


-- ================================================================
-- QUERY 5: Conversion rate by account balance segment
-- Business question: Does financial capacity affect subscription?
-- Finding: High balance customers (1,501-5,000) convert best at
--          16.87%. Low balance is the largest group but converts
--          at only 9.30%.
-- ================================================================

SELECT
    CASE
        WHEN balance < 0                    THEN '1. Negative balance'
        WHEN balance BETWEEN 0   AND 500    THEN '2. Low (0-500)'
        WHEN balance BETWEEN 501 AND 1500   THEN '3. Medium (501-1500)'
        WHEN balance BETWEEN 1501 AND 5000  THEN '4. High (1501-5000)'
        ELSE                                     '5. Very High (5000+)'
    END                                                                         AS balance_segment,
    COUNT(*)                                                                    AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct,
    ROUND(AVG(balance), 0)                                                     AS avg_balance
FROM bank_s1
GROUP BY balance_segment
ORDER BY balance_segment;


-- ================================================================
-- QUERY 6: Impact of contact frequency on conversion
-- Business question: Does calling customers more times help?
-- Finding: First call converts at 13.84%. Drops to 5.66% at 7+
--          calls. Repeated calling actively reduces conversion.
-- ================================================================

SELECT
    CASE
        WHEN campaign = 1                    THEN '1. Called once'
        WHEN campaign = 2                    THEN '2. Called twice'
        WHEN campaign = 3                    THEN '3. Called 3 times'
        WHEN campaign BETWEEN 4 AND 6        THEN '4. Called 4-6 times'
        ELSE                                      '5. Called 7+ times'
    END                                                                         AS contact_frequency,
    COUNT(*)                                                                    AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct
FROM bank_s1
GROUP BY contact_frequency
ORDER BY contact_frequency;


-- ================================================================
-- QUERY 7: Conversion rate by contact method
-- Business question: Does the contact channel affect conversion?
-- Finding: Telephone (14.62%) and cellular (14.36%) perform almost
--          identically. Unknown contact type converts at only 4.61%
--          — 29% of the database has no contact type recorded.
-- ================================================================

SELECT
    contact,
    COUNT(*)                                                                    AS total_contacts,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct,
    ROUND(AVG(duration), 0)                                                    AS avg_call_duration_sec
FROM bank_s1
GROUP BY contact                          -- fix: GROUP BY was missing in original
ORDER BY conversion_rate_pct DESC;


-- ================================================================
-- QUERY 8: Conversion rate by age group
-- Business question: Which age groups respond best to campaigns?
-- Finding: U-shaped pattern — retired (37.35%) and young (20.72%)
--          convert far above average. Mid-career (36-45) converts
--          worst at 9.29% yet receives the 2nd highest volume.
-- ================================================================

SELECT
    CASE
        WHEN age BETWEEN 18 AND 25  THEN '1. Young (18-25)'
        WHEN age BETWEEN 26 AND 35  THEN '2. Early career (26-35)'
        WHEN age BETWEEN 36 AND 45  THEN '3. Mid career (36-45)'
        WHEN age BETWEEN 46 AND 55  THEN '4. Senior (46-55)'
        WHEN age BETWEEN 56 AND 65  THEN '5. Pre-retirement (56-65)'
        ELSE                             '6. Retired (65+)'
    END                                                                         AS age_group,
    COUNT(*)                                                                    AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct,
    ROUND(AVG(balance), 0)                                                     AS avg_balance
FROM bank_s1
GROUP BY age_group
ORDER BY age_group;


-- ================================================================
-- QUERY 9: Impact of loan burden on subscription
-- Business question: Do existing loans reduce willingness to invest?
-- Finding: Debt-free customers convert at 16.88% vs 6.16% for
--          customers with both housing and personal loans.
--          Each loan roughly halves the conversion rate.
-- ================================================================

SELECT
    housing,
    loan,
    COUNT(*)                                                                    AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)                                AS subscriptions,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2)  AS conversion_rate_pct,
    ROUND(AVG(balance), 0)                                                     AS avg_balance
FROM bank_s1
GROUP BY housing, loan
ORDER BY conversion_rate_pct DESC;


-- ================================================================
-- END OF ANALYSIS
-- For full findings and business recommendations see:
-- report/EDA_Report_Bank_Marketing.docx
-- ================================================================
