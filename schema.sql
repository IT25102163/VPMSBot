-- ============================================================
-- ParkSmart Database Schema
-- Component 5 - Isuru | Group 24
--
-- HOW TO USE:
-- 1. Open phpMyAdmin → http://localhost/phpmyadmin
-- 2. Click "New" → Create database called "parksmart_db"
-- 3. Select "parksmart_db" → Click "Import" tab
-- 4. Choose this file → Click "Go"
-- ============================================================

CREATE DATABASE IF NOT EXISTS parksmart_db;
USE parksmart_db;

CREATE TABLE IF NOT EXISTS parking_sessions (
    id            INT           NOT NULL AUTO_INCREMENT,
    vehicle_plate VARCHAR(20)   NOT NULL,
    slot_number   VARCHAR(10)   NOT NULL,
    entry_time    DATETIME      NOT NULL,
    exit_time     DATETIME      DEFAULT NULL,
    duration_mins INT           DEFAULT 0,
    status        ENUM('ACTIVE','COMPLETED','CANCELLED') DEFAULT 'ACTIVE',
    notes         VARCHAR(255)  DEFAULT NULL,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS payment_records (
    id             INT            NOT NULL AUTO_INCREMENT,
    session_id     INT            NOT NULL,
    vehicle_plate  VARCHAR(20)    NOT NULL,
    amount         DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    payment_method ENUM('CASH','CARD','ONLINE') DEFAULT 'CASH',
    payment_time   DATETIME       NOT NULL,
    rate_per_hour  DECIMAL(10,2)  NOT NULL DEFAULT 200.00,
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (session_id) REFERENCES parking_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS parking_slots (
    id          INT          NOT NULL AUTO_INCREMENT,
    slot_number VARCHAR(10)  NOT NULL UNIQUE,
    slot_type   ENUM('STANDARD','DISABLED','VIP','ELECTRIC') DEFAULT 'STANDARD',
    is_active   TINYINT(1)   DEFAULT 1,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO parking_slots (slot_number, slot_type) VALUES
('A1','STANDARD'),('A2','STANDARD'),('A3','STANDARD'),('A4','STANDARD'),('A5','STANDARD'),
('B1','STANDARD'),('B2','STANDARD'),('B3','STANDARD'),('B4','STANDARD'),('B5','STANDARD'),
('C1','VIP'),('C2','VIP'),('D1','DISABLED'),('D2','DISABLED'),
('E1','ELECTRIC'),('E2','ELECTRIC');

INSERT INTO parking_sessions (vehicle_plate, slot_number, entry_time, exit_time, duration_mins, status) VALUES
('ABC-1234','A1','2025-03-10 08:00:00','2025-03-10 10:30:00',150,'COMPLETED'),
('XYZ-5678','B2','2025-03-10 09:15:00','2025-03-10 11:00:00',105,'COMPLETED'),
('PQR-9012','C1','2025-03-11 07:30:00','2025-03-11 09:45:00',135,'COMPLETED'),
('LMN-3456','A3','2025-03-12 10:00:00','2025-03-12 14:00:00',240,'COMPLETED'),
('JKL-7890','B4','2025-03-13 08:45:00','2025-03-13 10:15:00',90,'COMPLETED'),
('DEF-2345','A2','2025-03-14 11:00:00','2025-03-14 13:30:00',150,'COMPLETED'),
('GHI-6789','C2','2025-03-15 09:00:00','2025-03-15 12:00:00',180,'COMPLETED'),
('ABC-1234','B1','2025-03-15 14:00:00','2025-03-15 16:00:00',120,'COMPLETED'),
('STU-1111','A4','2025-03-16 08:00:00',NULL,0,'ACTIVE'),
('VWX-2222','B3','2025-03-16 09:30:00',NULL,0,'ACTIVE');

INSERT INTO payment_records (session_id, vehicle_plate, amount, payment_method, payment_time, rate_per_hour) VALUES
(1,'ABC-1234',500.00,'CASH','2025-03-10 10:30:00',200.00),
(2,'XYZ-5678',350.00,'CARD','2025-03-10 11:00:00',200.00),
(3,'PQR-9012',450.00,'CASH','2025-03-11 09:45:00',200.00),
(4,'LMN-3456',800.00,'ONLINE','2025-03-12 14:00:00',200.00),
(5,'JKL-7890',300.00,'CASH','2025-03-13 10:15:00',200.00),
(6,'DEF-2345',500.00,'CARD','2025-03-14 13:30:00',200.00),
(7,'GHI-6789',600.00,'CASH','2025-03-15 12:00:00',200.00),
(8,'ABC-1234',400.00,'CARD','2025-03-15 16:00:00',200.00);
