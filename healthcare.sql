select * from patients ; 
select * from doctors;
DROP DATABASE IF EXISTS HealthcareDB;
CREATE DATABASE HealthcareDB;
USE HealthcareDB;

--Tables
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(50),
    ClinicID INT,
    AvailableSlots INT NOT NULL,
    CONSTRAINT CHK_AvailableSlots CHECK (AvailableSlots >= 0)
);

CREATE TABLE Clinics (
    ClinicID INT PRIMARY KEY AUTO_INCREMENT,
    ClinicName VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    Phone VARCHAR(15)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    ClinicID INT,
    AppointmentDate DATETIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (ClinicID) REFERENCES Clinics(ClinicID)
);

--Index
CREATE INDEX IDX_Appointments_AppointmentDate ON Appointments(AppointmentDate);

-- Generating Sample Data
-- 1. Insert 10 Clinics
INSERT INTO Clinics (ClinicName, Address, Phone) VALUES
('City Health Clinic', '123 Main St, City1', '555-1001'),
('Downtown Medical Center', '456 Oak Ave, City2', '555-1002'),
('Sunrise Clinic', '789 Pine Rd, City3', '555-1003'),
('Green Valley Hospital', '101 Elm St, 	City4', '555-1004'),
('Westside Health Hub', '202 Birch Ln, City5', '555-1005'),
('North Star Clinic', '303 Cedar Dr, City1', '555-1006'),
('Riverfront Medical', '404 Maple Ave, City2', '555-1007'),
('Hilltop Wellness', '505 Spruce St, City3', '555-1008'),
('Lakeside Clinic', '606 Willow Rd, City4', '555-1009'),
('Urban Care Center', '707 Ash St, City5', '555-1010');

-- 2. Insert 500 Patients
DELIMITER //
CREATE PROCEDURE InsertPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Patients (FirstName, LastName, Email, Phone, Address)
        VALUES (
            CONCAT('Patient', i),
            CONCAT('Last', i),
            CONCAT('patient', i, '@email.com'),
            CONCAT('555-0', LPAD(i, 3, '0')),
            CONCAT(i, ' Street, City', (i % 5) + 1)
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL InsertPatients();

-- 3. Insert 50 Doctors
DELIMITER //
CREATE PROCEDURE InsertDoctors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE specialties VARCHAR(100) DEFAULT 'Cardiology,Neurology,Pediatrics,Orthopedics,General Practice';
    WHILE i <= 50 DO
        INSERT INTO Doctors (FirstName, LastName, Specialty, ClinicID, AvailableSlots)
        VALUES (
            CONCAT('Doctor', i),
            CONCAT('Last', i),
            SUBSTRING_INDEX(SUBSTRING_INDEX(specialties, ',', CEIL(RAND() * 5)), ',', -1),
            CEIL(RAND() * 10),
            FLOOR(RAND() * 20) + 10
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL InsertDoctors();

-- 4. Insert 10,000 Appointments
DELIMITER //
CREATE PROCEDURE InsertAppointments()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        SET @PatientID = (SELECT PatientID FROM Patients ORDER BY RAND() LIMIT 1);
        SET @DoctorID = (SELECT DoctorID FROM Doctors ORDER BY RAND() LIMIT 1);
        SET @ClinicID = (SELECT ClinicID FROM Doctors WHERE DoctorID = @DoctorID);
        SET @AppointmentDate = DATE_SUB('2025-06-24', INTERVAL FLOOR(RAND() * 1095) DAY) + INTERVAL FLOOR(RAND() * 1440) MINUTE;
        SET @Status = ELT(FLOOR(RAND() * 3) + 1, 'Scheduled', 'Completed', 'Cancelled');
        
        INSERT INTO Appointments (PatientID, DoctorID, ClinicID, AppointmentDate, Status)
        VALUES (@PatientID, @DoctorID, @ClinicID, @AppointmentDate, @Status);
        
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL InsertAppointments();

-- Create Trigger to Update Doctor Availability
DELIMITER //
CREATE TRIGGER UpdateDoctorAvailability
AFTER INSERT ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Scheduled' THEN
        UPDATE Doctors
        SET AvailableSlots = AvailableSlots - 1
        WHERE DoctorID = NEW.DoctorID
        AND AvailableSlots > 0;
    END IF;
END //
DELIMITER ;

-- Stored Procedure for Appointment Summary
DELIMITER //
CREATE PROCEDURE GetAppointmentSummary(
    IN p_StartDate DATE,
    IN p_EndDate DATE
)
BEGIN
    SELECT 
        c.ClinicName,
        COUNT(a.AppointmentID) AS TotalAppointments,
        SUM(CASE WHEN a.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedAppointments
    FROM Clinics c
    LEFT JOIN Appointments a ON c.ClinicID = a.ClinicID
    WHERE a.AppointmentDate BETWEEN p_StartDate AND p_EndDate
    GROUP BY c.ClinicName
    ORDER BY TotalAppointments DESC;
END //
DELIMITER ;

--View for Patient Visit History
CREATE VIEW PatientVisitHistory AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    COUNT(a.AppointmentID) AS TotalVisits,
    SUM(CASE WHEN a.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedVisits
FROM Patients p
LEFT JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName;

-- Queries for Analysis

-- 1. Total Appointments by Clinic (Using Stored Procedure)
CALL GetAppointmentSummary('2023-01-01', '2025-06-24');

-- 2. Top 5 Doctors by Appointment Count
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialty,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialty
ORDER BY TotalAppointments DESC
LIMIT 5;

-- 3. Monthly Appointment Trends
SELECT 
    DATE_FORMAT(a.AppointmentDate, '%Y-%m') AS Month,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Appointments a
GROUP BY DATE_FORMAT(a.AppointmentDate, '%Y-%m')
ORDER BY Month;

-- 4. Patient Appointment Details
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    a.AppointmentID,
    a.AppointmentDate,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    c.ClinicName,
    a.Status
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Clinics c ON a.ClinicID = c.ClinicID
WHERE a.AppointmentDate >= '2025-01-01'
ORDER BY a.AppointmentDate;

-- 5. Average Appointments per Doctor
SELECT 
    AVG(AppointmentCount) AS AvgAppointmentsPerDoctor
FROM (
    SELECT 
        d.DoctorID,
        COUNT(a.AppointmentID) AS AppointmentCount
    FROM Doctors d
    LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
    GROUP BY d.DoctorID
) AS DoctorAppointments;

-- 6. Top 5 Clinics by Completed Appointments
SELECT 
    c.ClinicName,
    COUNT(a.AppointmentID) AS CompletedAppointments
FROM Clinics c
JOIN Appointments a ON c.ClinicID = a.ClinicID
WHERE a.Status = 'Completed'
GROUP BY c.ClinicName
ORDER BY CompletedAppointments DESC
LIMIT 5;

-- 7. Patients with Above-Average Visits
SELECT 
    PatientName,
    TotalVisits
FROM PatientVisitHistory
WHERE TotalVisits > (SELECT AVG(TotalVisits) FROM PatientVisitHistory)
ORDER BY TotalVisits DESC;

-- 8. Appointment Status Distribution
SELECT 
    a.Status,
    COUNT(a.AppointmentID) AS AppointmentCount,
    ROUND(COUNT(a.AppointmentID) * 100.0 / SUM(COUNT(a.AppointmentID)) OVER (), 2) AS PercentOfTotal
FROM Appointments a
GROUP BY a.Status;

-- 9. Overdue Appointments
SELECT 
    a.AppointmentID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    a.AppointmentDate,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    DATEDIFF(CURDATE(), a.AppointmentDate) AS DaysOverdue
FROM Appointments a
JOIN Patients p ON a.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = a.DoctorID
WHERE a.Status = 'Scheduled' AND a.AppointmentDate < CURDATE()
ORDER BY DaysOverdue DESC
LIMIT 10;

-- 10. Appointments by Specialty
SELECT 
    d.Specialty,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedAppointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.Specialty
ORDER BY TotalAppointments DESC;

-- 11. Patients with No Recent Appointments
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.Email
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM Appointments a
    WHERE a.PatientID = p.PatientID
    AND DATEDIFF(CURDATE(), a.AppointmentDate) <= 180
)
ORDER BY p.PatientID;

-- 12. Clinic Appointment Priority
SELECT 
    c.ClinicName,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'Scheduled' AND a.AppointmentDate < DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN 1 ELSE 0 END) AS UrgentAppointments,
    CASE 
        WHEN SUM(CASE WHEN a.Status = 'Scheduled' AND a.AppointmentDate < DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN 1 ELSE 0 END) > 50 THEN 'High Priority'
        WHEN COUNT(a.AppointmentID) > 1000 THEN 'Medium Priority'
        ELSE 'Low Priority'
    END AS PriorityLevel
FROM Clinics c
LEFT JOIN Appointments a ON c.ClinicID = a.ClinicID
GROUP BY c.ClinicName
ORDER BY 
    CASE PriorityLevel
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        ELSE 3
    END, TotalAppointments DESC;

