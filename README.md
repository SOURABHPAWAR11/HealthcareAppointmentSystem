# HealthcareAppointmentSystem - MySQL Healthcare Management System

## Overview
This MySQL project simulates a healthcare appointment system, managing 500 patients, 50 doctors, 10 clinics, and 1000+ appointments. It demonstrates my skills in database design, querying, and optimization, providing insights like doctor availability, patient visit frequency, and clinic utilization. The project includes a stored procedure, view, trigger, index, and 12 queries

### Objectives
- Showcase MySQL proficiency in database creation and analysis.
- Deliver actionable healthcare insights.

## Database Schema
- **Patients**: PatientID, FirstName, LastName, Email, Phone, Address.
- **Doctors**: DoctorID, FirstName, LastName, Specialty, ClinicID, AvailableSlots.
- **Clinics**: ClinicID, ClinicName, Address, Phone.
- **Appointments**: AppointmentID, PatientID, DoctorID, ClinicID, AppointmentDate, Status (Scheduled, Completed, Cancelled).

- **Constraints**: Foreign keys ensure relationships; CHECK for non-negative slots.
- **Index**: On `Appointments.AppointmentDate` for faster queries.

## Project Components
- **Data Generation**: Scripts insert 500 patients, 50 doctors, 10 clinics, and 1000 appointments (2023–2025) using stored procedures and RAND().
- **Stored Procedure**: `GetAppointmentSummary` reports total and completed appointments by clinic for a date range.
- **View**: `PatientVisitHistory` precomputes patient visit metrics.
- **Trigger**: `UpdateDoctorAvailability` reduces doctor slots on scheduled appointments.
- **Queries**:
  1. Total Appointments by Clinic (Stored Procedure)
  2. Top 5 Doctors by Appointment Count
  3. Monthly Appointment Trends
  4. Patient Appointment Details
  5. Average Appointments per Doctor
  6. Top 5 Clinics by Completed Appointments
  7. Patients with Above-Average Visits
  8. Appointment Status Distribution
  9. Overdue Appointments
  10. Appointments by Specialty
  11. Patients with No Recent Appointments
  12. Clinic Appointment Priority

- **Outputs**: `SampleOutput.xlsx` contains results for some Queries
- **Sample Data**: `patients.csv` and `doctors.csv` show data structure (data generated via script).

## Setup Instructions
1. Install MySQL and MySQL Workbench.
2. Open `healthcare.sql` in Workbench and execute to create database and data (~1–2 minutes).
3. View `ERD.png`.
4. Run queries in Workbench to analyze data.

## Skills Demonstrated
- MySQL
- Database Design
- Query Optimization
- Stored Procedures
- Views
- Triggers
- Indexing
- Data Analysis
