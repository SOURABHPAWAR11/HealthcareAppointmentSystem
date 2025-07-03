# HealthcareAppointmentSystem - MySQL Healthcare Management System

## Overview
This MySQL project simulates a healthcare appointment system, managing 500 patients, 50 doctors, 10 clinics, and 10,000+ appointments. It demonstrates my skills in database design, querying, and optimization, providing insights like doctor availability, patient visit frequency, and clinic utilization. The project includes a stored procedure, view, trigger, index, and 15 queries (basic to light advanced).

### Objectives
- Showcase MySQL proficiency in database creation and analysis.
- Handle large datasets (10,000+ appointments) for scalability.
- Deliver actionable healthcare insights.
- Enhance portfolio for resume and interviews.

## Database Schema
- **Patients**: PatientID, FirstName, LastName, Email, Phone, Address.
- **Doctors**: DoctorID, FirstName, LastName, Specialty, ClinicID, AvailableSlots.
- **Clinics**: ClinicID, ClinicName, Address, Phone.
- **Appointments**: AppointmentID, PatientID, DoctorID, ClinicID, AppointmentDate, Status (Scheduled, Completed, Cancelled).

![ERD](ERD.png)

- **Constraints**: Foreign keys ensure relationships; CHECK for non-negative slots.
- **Index**: On `Appointments.AppointmentDate` for faster queries.

## Project Components
- **Data Generation**: Scripts insert 500 patients, 50 doctors, 10 clinics, and 10,000 appointments (2023–2025) using stored procedures and RAND().
- **Stored Procedure**: `GetAppointmentSummary` reports total and completed appointments by clinic for a date range.
- **View**: `PatientVisitHistory` precomputes patient visit metrics.
- **Trigger**: `UpdateDoctorAvailability` reduces doctor slots on scheduled appointments.
- **Queries**:
  1. Total Appointments by Clinic (Stored Procedure)
  2. Top 5 Doctors by Appointment Count
  3. Monthly Appointment Trends
  4. Doctors with Low Availability
  5. Patient Appointment Details
  6. Average Appointments per Doctor
  7. Top 5 Clinics by Completed Appointments
  8. Patients with Above-Average Visits
  9. Appointment Status Distribution
  10. Overdue Appointments
  11. Appointments by Specialty
  12. Patients with No Recent Appointments
  13. Top 3 Doctors per Clinic by Appointments
  14. Appointments with Multiple Specialties
  15. Clinic Appointment Priority

- **Outputs**: `SampleOutput.xlsx` contains results for Queries 3, 9, 13, 15.
- **Sample Data**: `patients.csv` and `doctors.csv` show data structure (data generated via script).

## Setup Instructions
1. Install MySQL and MySQL Workbench.
2. Open `HealthcareAppointmentSystem.sql` in Workbench and execute to create database and data (~1–2 minutes).
3. View `ERD.png` or generate ERD in Workbench (Database > Reverse Engineer).
4. Run queries in Workbench to analyze data.
5. (Optional) Import `patients.csv` and `doctors.csv` using `LOAD DATA INFILE`.

## Business Value
- **Operational Efficiency**: Identifies busy doctors (Query 2) and overdue appointments (Query 10) for better scheduling.
- **Patient Engagement**: Targets frequent (Query 8) and inactive patients (Query 12) for outreach.
- **Resource Planning**: Tracks trends (Query 3, 11) and prioritizes clinics (Query 15) for staffing.
- **Performance Insights**: Monitors clinic performance (Query 7) and appointment status (Query 9).

## Challenges Faced
- Optimized data generation for 10,000 appointments using stored procedures.
- Ensured data integrity with constraints and trigger testing.
- Simplified complex queries (e.g., Query 13’s ranking) for clarity.

## Future Enhancements
- Add a billing table for financial analysis.
- Develop a web interface (e.g., PHP) for appointment scheduling.
- Include wait time analysis for patient satisfaction.

## Skills Demonstrated
- MySQL
- Database Design
- Query Optimization
- Stored Procedures
- Views
- Triggers
- Indexing
- Data Analysis

## Contact
Reach out for feedback or questions!

---
*Portfolio project demonstrating MySQL skills for healthcare data management.*

