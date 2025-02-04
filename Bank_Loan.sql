SELECT *
From bank_loan;

Select count(*)
from bank_loan;

ALTER TABLE bank_loan
ADD COLUMN con_issue_date DATE;

-- Converting the date values in 'issue_date' col to a valid date format and adding values into the column 'con_issue_date'


-- NEXT CODE TO AVOID AN ERROR
SET SQL_SAFE_UPDATES = 0;
-- IGNORE UPPER CODE, ITS JUST SWITCHING OF A SAFE MODE

UPDATE bank_loan
SET con_issue_date = CASE
	WHEN issue_date LIKE '__/__/____' THEN STR_TO_DATE(issue_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN issue_date LIKE '__-__-____' THEN STR_TO_DATE(issue_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN issue_date LIKE '____-__-__' THEN STR_TO_DATE(issue_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;


Select * from bank_loan;

ALTER TABLE bank_loan
DROP COLUMN issue_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_issue_date issue_date DATE;

-- Adding column as 'con_last_credit_pull_date' to table
ALTER TABLE bank_loan
ADD COLUMN con_last_credit_pull_date DATE;

UPDATE bank_loan
SET con_last_credit_pull_date = CASE
	WHEN last_credit_pull_date LIKE '__/__/____' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN last_credit_pull_date LIKE '__-__-____' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_credit_pull_date LIKE '____-__-__' THEN STR_TO_DATE(last_credit_pull_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

ALTER TABLE bank_loan
DROP COLUMN last_credit_pull_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_last_credit_pull_date last_credit_pull_date DATE;

-- Repeating the same for 'next_payment_date' column
ALTER TABLE bank_loan
ADD COLUMN con_next_payment_date DATE;

UPDATE bank_loan
SET con_next_payment_date = CASE
	WHEN next_payment_date LIKE '__/__/____' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN next_payment_date LIKE '__-__-____' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN next_payment_date LIKE '____-__-__' THEN STR_TO_DATE(next_payment_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

ALTER TABLE bank_loan
DROP COLUMN next_payment_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_next_payment_date next_payment_date DATE;

select * from bank_loan;

-- Repeating the same for 'last_payment_date' column

ALTER TABLE bank_loan
ADD COLUMN con_last_payment_date DATE;

UPDATE bank_loan
SET con_last_payment_date = CASE
	WHEN last_payment_date LIKE '__/__/____' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN last_payment_date LIKE '__-__-____' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_payment_date LIKE '____-__-__' THEN STR_TO_DATE(last_payment_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

ALTER TABLE bank_loan
DROP COLUMN last_payment_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_last_payment_date last_payment_date DATE;

select * from bank_loan;


-- Calculating total applications recieved

Select  count(id) AS Total_Loan_Applications
from bank_loan;

-- calculation month-to-date total loan application
Select  count(id) AS MTD_Total_Loan_Applications
from bank_loan where MONTH(issue_date) = 12 and YEAR(issue_date)=2021;

-- calculation previous-month-to-date total loan application
Select  count(id) AS PMTD_Total_Loan_Applications
from bank_loan where MONTH(issue_date) = 11 and YEAR(issue_date)=2021;

-- calculating month on month total loan application
WITH MTD_app AS(
Select  count(id) AS MTD_Total_Loan_Applications
from bank_loan where MONTH(issue_date) = 12 and YEAR(issue_date)=2021),
PMTD_app AS(
Select  count(id) AS PMTD_Total_Loan_Applications
from bank_loan where MONTH(issue_date) = 11 and YEAR(issue_date)=2021)

Select ((MTD.MTD_Total_Loan_Applications - PMTD.PMTD_Total_Loan_Applications)/PMTD.PMTD_Total_Loan_Applications)*100
AS MOM_Total_Loan_Applications
From MTD_app MTD, PMTD_app PMTD;

-- Calculating the total funded amount
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan;

-- Calculating the MTD Total funded amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021;

-- Calculating the PMTD Total funded amount
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021;

-- Calculating Month on month Total funded amount
With MTD_funded as(
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021),
PMTD_funded as(
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021)

Select ((MTD.MTD_Total_Funded_Amount - PMTD.PMTD_Total_Funded_Amount)/PMTD.PMTD_Total_Funded_Amount)*100
AS MOM_Total_Funded_Amount
From MTD_funded MTD,PMTD_funded PMTD;

-- Calculating total amt recieved
SELECT SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan;

-- Calculating the MTD Total amount recieved
SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021;

-- Calculating the PMTD Total amount recieved
SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021;

-- Calculating Month on month Total amount recieved
With MTD_payment as(
SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021),
PMTD_payment as(
SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021)

Select ((MTD.MTD_Total_Amount_Recieved - PMTD.PMTD_Total_Amount_Recieved)/PMTD.PMTD_Total_Amount_Recieved)*100
AS MOM_Total_Amount_Recieved
From MTD_payment MTD,PMTD_payment PMTD;

-- Calculating avg Int Rate

select AVG(int_rate)*100 AS Avg_Interest_Rate From bank_loan;

-- Calculating MTD avg Int Rate
SELECT AVG(int_rate)*100 AS MTD_Avg_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021;

-- Calculating PMTD avg Int Rate
SELECT AVG(int_rate)*100 AS PMTD_Avg_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021;

-- Calculating Month on month avg Int Rate
With MTD_avg_int as(
SELECT AVG(int_rate)*100 AS MTD_Avg_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021),
PMTD_avg_int as(
SELECT AVG(int_rate)*100 AS PMTD_Avg_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021)

Select ((MTD.MTD_Avg_Interest_Rate - PMTD.PMTD_Avg_Interest_Rate)/PMTD.PMTD_Avg_Interest_Rate)*100
AS MOM_Avg_Interest_Rate
From MTD_avg_int MTD,PMTD_avg_int PMTD;

-- Calculating avg debt to income ratio(DTI)
select AVG(dti)*100 AS Avg_DTI From bank_loan;

-- Calculating MTD avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021;

-- Calculating PMTD avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021;

-- Calculating Month on month avg DTI
With MTD_DTI as(
SELECT AVG(dti) AS MTD_Avg_DTI
FROM bank_loan
WHERE MONTH(issue_date)=12 and YEAR(issue_date)=2021),
PMTD_DTI as(
SELECT AVG(dti) AS PMTD_Avg_DTI
FROM bank_loan
WHERE MONTH(issue_date)=11 and YEAR(issue_date)=2021)

Select ((MTD.MTD_Avg_DTI - PMTD.PMTD_Avg_DTI)/PMTD.PMTD_Avg_DTI)*100
AS MOM_DTI
From MTD_DTI MTD,PMTD_DTI PMTD;

-- Calculating good loan application percentage

SELECT (COUNT(CASE WHEN loan_status ='Fully Paid' OR loan_status = 'current' THEN id END)*100)/COUNT(id)
AS Good_Loan_Percentage
FROM bank_loan;

-- calculating total good loan applications
Select count(id) as Good_Loan_Applications
From bank_loan
where loan_status ='Fully Paid' OR loan_status = 'current';

-- Calculating the good loan funded
Select sum(loan_amount) As GOOD_Loan_Funded_Amt
From bank_loan
where loan_status ='Fully Paid' OR loan_status = 'current';

-- calculating good loan recieved amt
Select sum(total_payment) As GOOD_Loan_Amt_Recieved
From bank_loan
where loan_status ='Fully Paid' OR loan_status = 'current';

-- Calculating bad loan application percentage

SELECT (COUNT(CASE WHEN loan_status ='Charged Off' THEN id END)*100)/COUNT(id)
AS Bad_Loan_Percentage
FROM bank_loan;

-- calculating total bad loan applications
Select count(id) as Bad_Loan_Applications
From bank_loan
where loan_status ='Charged Off';

-- Calculating the bad loan funded
Select sum(loan_amount) As Bad_Loan_Funded_Amt
From bank_loan
where loan_status ='Charged Off';

-- calculating bad loan recieved amt
Select sum(total_payment) As Bad_Loan_Amt_Recieved
From bank_loan
where loan_status ='Charged Off';

-- calculating the Loan_Count, Total_Amt_Recieved, Total_Funded_Amt, Interest_Rate, DTI based on loan status
SELECT
	loan_status,
    Count(id) As Loan_Count,
    SUM(total_payment) As Total_Amt_Recieved,
    Sum(loan_amount) As Total_Funded_Amt,
    AVG(int_rate *100) As Interest_Rate,
    AVG(dti *100) As DTI
From bank_loan
group by loan_status;

-- calculating MTD_Total_Amt_Recieved, MTD_Total_Funded_Amt on the basis of loan status
Select
	loan_status,
    SUM(total_payment) As MTD_Total_Amt_Recieved,
    Sum(loan_amount) As MTD_Total_Funded_Amt
From bank_loan
Where Month(issue_date)=12 and YEAR(issue_date)=2021
Group by loan_status;

-- Calculating monthly Total_Loan_Applications, Total_Funded_Amt and Total_Amt_Recieved
-- Bank loan report | overview - month
Select
	Month(issue_date) As Month_Number,
    monthname(issue_date) As Month_Name,
    count(id) As Total_Loan_Applications,
    Sum(loan_amount) as  Total_Funded_Amt,
    sum(total_payment) as Total_Amt_Recieved
From bank_loan
Group By Month(issue_date) , monthname(issue_date)
order by Month(issue_date);

-- Bank loan report | overview - state
Select
	address_state as state,
    count(id) As Total_Loan_Applications,
    Sum(loan_amount) as  Total_Funded_Amt,
    sum(total_payment) as Total_Amt_Recieved
From bank_loan
Group By address_state
order by address_state;

-- Bank loan report | overview - term
Select
	term as Term,
    count(id) As Total_Loan_Applications,
    Sum(loan_amount) as  Total_Funded_Amt,
    sum(total_payment) as Total_Amt_Recieved
From bank_loan
Group By term
order by term;

-- Bank loan report | overview - employee length
Select
	emp_length as Employee_length,
    count(id) As Total_Loan_Applications,
    Sum(loan_amount) as  Total_Funded_Amt,
    sum(total_payment) as Total_Amt_Recieved
From bank_loan
Group By emp_length
order by emp_length;

-- Bank loan report | overview - purpose
Select
	purpose as Purpose,
    count(id) As Total_Loan_Applications,
    Sum(loan_amount) as  Total_Funded_Amt,
    sum(total_payment) as Total_Amt_Recieved
From bank_loan
Group By purpose
order by purpose;

-- Bank loan report | overview - home ownership
Select
	home_ownership as Home_Ownership,
    count(id) As Total_Loan_Applications,
    Sum(loan_amount) as  Total_Funded_Amt,
    sum(total_payment) as Total_Amt_Recieved
From bank_loan
Group By home_ownership
order by home_ownership;


select * from bank_loan