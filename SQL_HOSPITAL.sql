-- DROP ALL TABLES IF THEY EXIST--
DROP TABLE PRESCRIPTION_ITEMS CASCADE CONSTRAINTS;
DROP TABLE MEDICATION CASCADE CONSTRAINTS;
DROP TABLE PRESCRIPTIONS CASCADE CONSTRAINTS;
DROP TABLE INPATIENTS CASCADE CONSTRAINTS;
DROP TABLE ROOMS CASCADE CONSTRAINTS;
DROP TABLE OUTPATIENT CASCADE CONSTRAINTS;
DROP TABLE PHARMACISTS CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE MEDICAL_RECORD CASCADE CONSTRAINTS;
DROP TABLE NURSES CASCADE CONSTRAINTS;
DROP TABLE INSURANCE CASCADE CONSTRAINTS;
DROP TABLE APPOINTMENTS CASCADE CONSTRAINTS;
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP TABLE DOCTOR CASCADE CONSTRAINTS;

-- =========================================
-- CREATE TABLES
-- =========================================

CREATE TABLE DOCTOR (
    doctor_id NUMBER,
    last_name VARCHAR2(50) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    specialization VARCHAR2(100),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    CONSTRAINT doctor_pk PRIMARY KEY (doctor_id)
);

CREATE TABLE PATIENT (
    patient_id NUMBER,
    last_name VARCHAR2(50) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    birth_date DATE,
    gender CHAR(1),
    phone VARCHAR2(20),
    address VARCHAR2(200),
    CONSTRAINT patient_pk PRIMARY KEY (patient_id),
    CONSTRAINT chk_gender CHECK (gender IN ('L','P'))
);

CREATE TABLE APPOINTMENTS (
    appointment_id NUMBER,
    appointment_date DATE,
    status VARCHAR2(30),
    complaint VARCHAR2(200),
    patient_id NUMBER,
    doctor_id NUMBER,
    CONSTRAINT appointment_pk PRIMARY KEY (appointment_id)
);

CREATE TABLE INSURANCE (
    insurance_id NUMBER,
    provider_name VARCHAR2(100),
    policy_number VARCHAR2(50),
    valid_until DATE,
    coverage_type VARCHAR2(50),
    patient_id NUMBER,
    CONSTRAINT insurance_pk PRIMARY KEY (insurance_id)
);

CREATE TABLE NURSES (
    nurse_id NUMBER,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    shift VARCHAR2(30),
    ward VARCHAR2(50),
    phone VARCHAR2(20),
    CONSTRAINT nurse_pk PRIMARY KEY (nurse_id)
);

CREATE TABLE MEDICAL_RECORD (
    record_id NUMBER,
    diagnosis VARCHAR2(200),
    treatment VARCHAR2(200),
    record_date DATE,
    appointment_id NUMBER,
    nurse_id NUMBER,
    CONSTRAINT medical_record_pk PRIMARY KEY (record_id)
);

CREATE TABLE PAYMENT (
    payment_id NUMBER,
    payment_date DATE,
    payment_method VARCHAR2(50),
    total_amount NUMBER,
    status VARCHAR2(30),
    appointment_id NUMBER,
    insurance_id NUMBER,
    CONSTRAINT payment_pk PRIMARY KEY (payment_id)
);

CREATE TABLE PHARMACISTS (
    pharmacist_id NUMBER,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    license_no VARCHAR2(50),
    shift VARCHAR2(30),
    phone VARCHAR2(20),
    CONSTRAINT pharmacist_pk PRIMARY KEY (pharmacist_id)
);

CREATE TABLE OUTPATIENT (
    outpatient_id NUMBER,
    admission_date DATE,
    discharge_date DATE,
    condition VARCHAR2(100),
    patient_id NUMBER,
    appointment_id NUMBER,
    CONSTRAINT outpatient_pk PRIMARY KEY (outpatient_id)
);

CREATE TABLE ROOMS (
    room_id NUMBER,
    room_number VARCHAR2(20),
    room_type VARCHAR2(50),
    capacity NUMBER,
    status VARCHAR2(30),
    CONSTRAINT room_pk PRIMARY KEY (room_id)
);

CREATE TABLE INPATIENTS (
    inpatient_id NUMBER,
    admission_date DATE,
    discharge_date DATE,
    condition VARCHAR2(100),
    patient_id NUMBER,
    room_id NUMBER,
    record_id NUMBER,
    CONSTRAINT inpatient_pk PRIMARY KEY (inpatient_id)
);

CREATE TABLE PRESCRIPTIONS (
    prescription_id NUMBER,
    prescribe_date DATE,
    status VARCHAR2(30),
    record_id NUMBER,
    doctor_id NUMBER,
    pharmacist_id NUMBER,
    CONSTRAINT prescription_pk PRIMARY KEY (prescription_id)
);

CREATE TABLE MEDICATION (
    medication_id NUMBER,
    med_name VARCHAR2(100),
    category VARCHAR2(50),
    unit VARCHAR2(30),
    stock NUMBER,
    price NUMBER,
    CONSTRAINT medication_pk PRIMARY KEY (medication_id)
);

CREATE TABLE PRESCRIPTION_ITEMS (
    item_id NUMBER,
    quantity NUMBER,
    dosage VARCHAR2(50),
    frequency VARCHAR2(50),
    prescription_id NUMBER,
    medication_id NUMBER,
    CONSTRAINT prescription_item_pk PRIMARY KEY (item_id)
);

-- =========================================
-- FOREIGN KEY CONSTRAINTS
-- =========================================

ALTER TABLE APPOINTMENTS
ADD CONSTRAINT fk_appointment_patient
FOREIGN KEY (patient_id)
REFERENCES PATIENT(patient_id);

ALTER TABLE APPOINTMENTS
ADD CONSTRAINT fk_appointment_doctor
FOREIGN KEY (doctor_id)
REFERENCES DOCTOR(doctor_id);

ALTER TABLE INSURANCE
ADD CONSTRAINT fk_insurance_patient
FOREIGN KEY (patient_id)
REFERENCES PATIENT(patient_id);

ALTER TABLE MEDICAL_RECORD
ADD CONSTRAINT fk_record_appointment
FOREIGN KEY (appointment_id)
REFERENCES APPOINTMENTS(appointment_id);

ALTER TABLE MEDICAL_RECORD
ADD CONSTRAINT fk_record_nurse
FOREIGN KEY (nurse_id)
REFERENCES NURSES(nurse_id);

ALTER TABLE PAYMENT
ADD CONSTRAINT fk_payment_appointment
FOREIGN KEY (appointment_id)
REFERENCES APPOINTMENTS(appointment_id);

ALTER TABLE PAYMENT
ADD CONSTRAINT fk_payment_insurance
FOREIGN KEY (insurance_id)
REFERENCES INSURANCE(insurance_id);

ALTER TABLE OUTPATIENT
ADD CONSTRAINT fk_outpatient_patient
FOREIGN KEY (patient_id)
REFERENCES PATIENT(patient_id);

ALTER TABLE OUTPATIENT
ADD CONSTRAINT fk_outpatient_appointment
FOREIGN KEY (appointment_id)
REFERENCES APPOINTMENTS(appointment_id);

ALTER TABLE INPATIENTS
ADD CONSTRAINT fk_inpatient_patient
FOREIGN KEY (patient_id)
REFERENCES PATIENT(patient_id);

ALTER TABLE INPATIENTS
ADD CONSTRAINT fk_inpatient_room
FOREIGN KEY (room_id)
REFERENCES ROOMS(room_id);

ALTER TABLE INPATIENTS
ADD CONSTRAINT fk_inpatient_record
FOREIGN KEY (record_id)
REFERENCES MEDICAL_RECORD(record_id);

ALTER TABLE PRESCRIPTIONS
ADD CONSTRAINT fk_prescription_record
FOREIGN KEY (record_id)
REFERENCES MEDICAL_RECORD(record_id);

ALTER TABLE PRESCRIPTIONS
ADD CONSTRAINT fk_prescription_doctor
FOREIGN KEY (doctor_id)
REFERENCES DOCTOR(doctor_id);

ALTER TABLE PRESCRIPTIONS
ADD CONSTRAINT fk_prescription_pharmacist
FOREIGN KEY (pharmacist_id)
REFERENCES PHARMACISTS(pharmacist_id);

ALTER TABLE PRESCRIPTION_ITEMS
ADD CONSTRAINT fk_item_prescription
FOREIGN KEY (prescription_id)
REFERENCES PRESCRIPTIONS(prescription_id);

ALTER TABLE PRESCRIPTION_ITEMS
ADD CONSTRAINT fk_item_medication
FOREIGN KEY (medication_id)
REFERENCES MEDICATION(medication_id);

-- =========================================
-- CREATE INDEXES
-- =========================================

CREATE INDEX idx_patient_lastname
ON PATIENT(last_name);

CREATE INDEX idx_doctor_lastname
ON DOCTOR(last_name);

CREATE INDEX idx_medication_name
ON MEDICATION(med_name);

CREATE INDEX idx_room_number
ON ROOMS(room_number);

-- =========================================
-- CREATE VIEW
-- =========================================

CREATE OR REPLACE VIEW ACTIVE_PATIENT AS
SELECT patient_id, first_name, last_name, phone
FROM PATIENT
WITH READ ONLY;

-- =========================================
-- CREATE SYNONYM
-- =========================================

CREATE SYNONYM AP FOR ACTIVE_PATIENT;

-- =========================================
-- CREATE SEQUENCES
-- =========================================

CREATE SEQUENCE patient_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE doctor_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE appointment_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE prescription_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- =========================================
-- INSERT DATA
-- =========================================

INSERT INTO PATIENT
VALUES (
    patient_seq.NEXTVAL,
    'Putri',
    'Cinta',
    TO_DATE('2005-05-10','YYYY-MM-DD'),
    'P',
    '08123456789',
    'Yogyakarta'
);

INSERT INTO DOCTOR
VALUES (
    doctor_seq.NEXTVAL,
    'Budi',
    'Andi',
    'Cardiologist',
    '08987654321',
    'budi@gmail.com'
);

INSERT INTO NURSES
VALUES (
    1,
    'Sinta',
    'Ayu',
    'Morning',
    'Ward A',
    '0812222222'
);

INSERT INTO PHARMACISTS
VALUES (
    1,
    'Sari',
    'Dewi',
    'LIC001',
    'Morning',
    '0811111111'
);

INSERT INTO APPOINTMENTS
VALUES (
    appointment_seq.NEXTVAL,
    SYSDATE,
    'Scheduled',
    'Headache',
    1,
    1
);

INSERT INTO INSURANCE
VALUES (
    1,
    'BPJS',
    'POL001',
    TO_DATE('2027-12-31','YYYY-MM-DD'),
    'Full',
    1
);

INSERT INTO MEDICAL_RECORD
VALUES (
    1,
    'Flu',
    'Rest and medicine',
    SYSDATE,
    1,
    1
);

INSERT INTO PAYMENT
VALUES (
    1,
    SYSDATE,
    'Cash',
    150000,
    'Paid',
    1,
    1
);

INSERT INTO OUTPATIENT
VALUES (
    1,
    SYSDATE,
    SYSDATE + 1,
    'Stable',
    1,
    1
);

INSERT INTO ROOMS
VALUES (
    1,
    'A101',
    'VIP',
    2,
    'Available'
);

INSERT INTO INPATIENTS
VALUES (
    1,
    SYSDATE,
    SYSDATE + 3,
    'Recovering',
    1,
    1,
    1
);

INSERT INTO PRESCRIPTIONS
VALUES (
    prescription_seq.NEXTVAL,
    SYSDATE,
    'Active',
    1,
    1,
    1
);

INSERT INTO MEDICATION
VALUES (
    1,
    'Paracetamol',
    'Pain Relief',
    'Tablet',
    100,
    5000
);

INSERT INTO PRESCRIPTION_ITEMS
VALUES (
    1,
    10,
    '500mg',
    '3x a day',
    3,
    1
);