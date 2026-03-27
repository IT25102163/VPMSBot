CREATE DATABASE IF NOT EXISTS parking_system;
USE parking_system;

CREATE TABLE IF NOT EXISTS users (
    user_id   INT          AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    contact   VARCHAR(20)  NOT NULL,
    username  VARCHAR(50)  NOT NULL UNIQUE,
    password  VARCHAR(255) NOT NULL,
    role      VARCHAR(20)  DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_no   VARCHAR(20) PRIMARY KEY,
    vehicle_type VARCHAR(30) NOT NULL,
    user_id      INT         NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS parking_slots (
    slot_id   INT         AUTO_INCREMENT PRIMARY KEY,
    slot_name VARCHAR(10) NOT NULL,
    status    VARCHAR(20) DEFAULT 'Available',
    floor     INT         DEFAULT 1
);

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT         AUTO_INCREMENT PRIMARY KEY,
    slot_id        INT         NOT NULL,
    vehicle_no     VARCHAR(20) NOT NULL,
    user_name      VARCHAR(100),
    FOREIGN KEY (slot_id) REFERENCES parking_slots(slot_id)
);

CREATE TABLE IF NOT EXISTS parking_history (
    history_id     INT           AUTO_INCREMENT PRIMARY KEY,
    vehicle_no     VARCHAR(20),
    user_id        INT,
    slot_id        INT,
    entry_time     DATETIME,
    exit_time      DATETIME      DEFAULT NULL,
    duration       DOUBLE        DEFAULT NULL,
    total_fee      DECIMAL(10,2) DEFAULT NULL,
    payment_status VARCHAR(20)   DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS payments (
    id             INT           AUTO_INCREMENT PRIMARY KEY,
    vehicle_no     VARCHAR(20),
    amount         DECIMAL(10,2),
    method         VARCHAR(30),
    status         VARCHAR(20)   DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS feedback (
    id      INT          AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT,
    rating  INT
);

-- Sample parking slots
INSERT INTO parking_slots (slot_name, status, floor) VALUES
('A01','Available',1),('A02','Available',1),('A03','Available',1),('A04','Available',1),
('B01','Available',1),('B02','Available',1),('B03','Available',1),('B04','Available',1),
('C01','Available',2),('C02','Available',2),('C03','Available',2),('C04','Available',2);