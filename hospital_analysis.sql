-- Preview DATA
SELECT * 
FROM patients
LIMIT 5;


-- Show a doctor who has an experience more than 5 years
SELECT 
	first_name, 
	last_name,
	specialization,
	years_experience
FROM doctors
WHERE years_experience > 5
ORDER BY years_experience DESC;

-- Show patient name and doctor name make appointment
-- (Join 3 tables)
SELECT 
	patients.first_name AS patient_name,
	doctors.first_name AS doctor_name,
	appointments.appointment_date
FROM appointments
JOIN patients 
ON appointments.patient_id = patients.patient_id
JOIN doctors 
ON appointments.doctor_id = doctors.doctor_id
ORDER BY appointments.appointment_date DESC;


-- summarize how many times, each of appointment in each type 
SELECT 
	treatment_type,
	COUNT(*) AS treatment_count,
	SUM(cost) AS total_cost
FROM treatments
GROUP BY treatment_type
ORDER BY total_cost DESC;


-- revenue for the month (Included treatment from billing)
SELECT
	strftime('%Y-%m', bill_date) AS billing_month,
	SUM(amount) AS total_revenue
FROM billing
GROUP BY billing_month
ORDER BY billing_month;


-- total revenue from each doctor
SELECT 
	doctors.first_name || ' ' || doctors.last_name AS doctor_name,
	SUM(billing.amount) AS revenue
FROM billing 
JOIN treatments 
ON billing.treatment_id = treatments.treatment_id
JOIN appointments 
ON treatments.appointment_id = appointments.appointment_id
JOIN doctors 
ON appointments.doctor_id = doctors.doctor_id
GROUP BY doctor_name
ORDER BY revenue DESC;


-- patient who have most appointment 
SELECT 
	patients.first_name || ' ' || patients.last_name AS patient_name,
	COUNT(*) AS appointment_count
FROM patients 
JOIN appointments 
ON patients.patient_id = appointments.patient_id 
GROUP BY patient_name
ORDER BY appointment_count DESC
LIMIT 5;


-- for patient who did appointment but not showing up
SELECT 
	patients.first_name || ' ' || patients.last_name AS patient_name,
	COUNT(*) AS missed
FROM appointments 
JOIN patients 
ON patients.patient_id = appointments.patient_id
WHERE status = 'No-show' 
GROUP BY patient_name
ORDER BY missed DESC
LIMIT 5;



-- KPI: Income per doctor and time of appointments (รายได้ต่อหมอ + จำนวนนัด)
SELECT 
	doctors.first_name || ' ' || doctors.last_name AS doctor_name,
	COUNT(distinct appointments.appointment_id) AS num_appointment,
	SUM(billing.amount) AS total_revenue
FROM billing 
JOIN treatments ON billing.treatment_id = treatments.treatment_id
JOIN appointments ON treatments.appointment_id= appointments.appointment_id
JOIN doctors ON doctors.doctor_id  = appointments.doctor_id
GROUP BY doctor_name
ORDER BY total_revenue DESC 


-- Create View
--View for Income per month
CREATE VIEW monthly_revenue AS 
SELECT 
	strftime('%Y-%m', bill_date) AS month,
	sum(amount) AS total
FROM billing 
GROUP BY month

-- Query from view table 
SELECT *
FROM monthly_revenue


--View for doctor kpi
CREATE VIEW doctor_kpis AS 
SELECT 
	doctors.first_name || ' ' || doctors.last_name AS doctor_name,
	COUNT(distinct appointments.appointment_id) AS num_appointment,
	SUM(billing.amount) AS total_revenue
FROM billing 
JOIN treatments ON billing.treatment_id = treatments.treatment_id
JOIN appointments ON treatments.appointment_id= appointments.appointment_id
JOIN doctors ON doctors.doctor_id  = appointments.doctor_id
GROUP BY doctor_name
ORDER BY total_revenue DESC;

-- Query from view table 
SELECT *
FROM doctor_kpis
