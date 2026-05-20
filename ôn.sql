DROP DATABASE IF EXISTS dtb_maintenance_system_cntt6;	
CREATE DATABASE dtb_maintenance_system_cntt6;
USE dtb_maintenance_system_cntt6;

CREATE TABLE telecom_towers (
    tower_id INT PRIMARY KEY AUTO_INCREMENT,
    tower_name VARCHAR(100) NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    location_zone VARCHAR(50) NOT NULL,
    commission_date DATE NOT NULL 
);

CREATE TABLE engineers (
    engineer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    skill_level VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    safety_rating DECIMAL(2,1) DEFAULT 5.0 CHECK (safety_rating BETWEEN 0.0 AND 5.0)
);

CREATE TABLE maintenance_orders (
    order_id INT PRIMARY KEY,
    tower_id INT NOT NULL,
    engineer_id INT NOT NULL,
    scheduled_time DATETIME NOT NULL,
    operation_cost DECIMAL(15,2) NOT NULL CHECK (operation_cost > 0),
    order_status VARCHAR(20) NOT NULL CHECK (order_status IN ('Assigned','Executed','Aborted')),
    FOREIGN KEY (tower_id) REFERENCES telecom_towers(tower_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
);

CREATE TABLE technical_logs (
    log_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    hardware_status VARCHAR(100) NOT NULL,
    bandwidth_cap VARCHAR(50) NOT NULL,
    action_taken TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES maintenance_orders(order_id)
);

CREATE TABLE incident_reports (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    log_id INT NOT NULL,
    engineer_id INT NOT NULL,
    reported_time DATETIME NOT NULL,
    root_cause TEXT,
    FOREIGN KEY (log_id) REFERENCES technical_logs(log_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
);

INSERT INTO telecom_towers VALUES
(1,'Trạm Đông Đô','SN-9901-X','Zone A','1999-12-03'),
(2,'Trạm Tây Sơn','SN-9902-Y','Zone B','1996-11-25'),
(3,'Trạm Nam Hải','SN-9903-Z','Zone C','2001-07-08'),
(4,'Trạm Bắc Bình','SN-9904-W','Zone A','1998-01-19'),
(5,'Trạm Trung Trung','SN-9905-V','Zone D','2000-09-30');

INSERT INTO engineers VALUES
(1,'KS. Nguyễn Văn Hải','Bậc 5','0931112223',4.8),
(2,'KS. Trần Thu Hà','Bậc 4','0932223334',5.0),
(3,'KS. Lê Quốc Tuấn','Bậc 6','0933334445',4.6),
(4,'KS. Phạm Minh Châu','Bậc 3','0934445556',4.9),
(5,'KS. Hoàng Gia Bảo','Bậc 5','0935556667',4.7);

INSERT INTO maintenance_orders VALUES
(7001,1,1,'2024-05-20 08:00:00',200000,'Assigned'),
(7002,2,2,'2024-05-20 09:30:00',250000,'Executed'),
(7003,3,3,'2024-05-20 10:15:00',300000,'Assigned'),
(7004,4,5,'2024-05-21 07:00:00',350000,'Executed'),
(7005,5,4,'2024-05-21 08:45:00',220000,'Aborted');

INSERT INTO technical_logs VALUES
(8001,7002,'Nhiệt độ cao','150 Mbps','Xả tải, tra keo tản nhiệt','2024-05-20 10:00:00'),
(8002,7004,'Sụt nguồn nhẹ','300 Mbps','Đấu nối lại lốc nguồn phụ','2024-05-21 08:00:00'),
(8003,7001,'Nhiễu tần số','100 Mbps','Cấu hình lại bộ lọc sóng','2024-05-20 09:00:00'),
(8004,7003,'Suy hao quang','200 Mbps','Thay mới dây nhảy quang','2024-05-20 11:00:00'),
(8005,7005,'Lỗi cổng chào','0 Mbps','Không xử lý do lệnh hủy','2024-05-21 09:00:00');

INSERT INTO incident_reports VALUES
(1,8003,1,'2024-05-20 09:05:00','Đã kiểm tra xung đột tần số'),
(2,8001,2,'2024-05-20 10:05:00','Hoàn tất cấu hình phần cứng'),
(3,8004,3,'2024-05-20 11:10:00','Phát hiện đứt cáp ngầm nhẹ'),
(4,8002,5,'2024-05-21 08:10:00','Đạt độ ổn định công suất'),
(5,8005,4,'2024-05-21 09:05:00','Trạm dừng hoạt động ngoại cảnh');

-- PHẦN 2: DML – INSERT, UPDATE, DELETE (25 ĐIỂM)
-- Câu 2 – UPDATE & DELETE (10 điểm)
SET SQL_SAFE_UPDATES = 0;

UPDATE maintenance_orders AS mo
INNER JOIN telecom_towers  AS tt
ON mo.tower_id = tt.tower_id
SET operation_cost = operation_cost * 1.1
WHERE order_status = 'Excuted' AND YEAR(commission_date) < 2000;

DELETE 
FROM incident_reports
WHERE reported_time < '2024-05-20';

-- PHẦN 3: TRUY VẤN CƠ BẢN (15 ĐIỂM)
/*
Câu 1 (5 điểm): Liệt kê thông tin các kỹ sư gồm full_name, skill_level và safety_rating của những kỹ sư có điểm an toàn 
(safety_rating) lớn hơn 4.7 hoặc thuộc bậc thợ "Bậc 4".
*/
SELECT full_name, skill_level, safety_rating
FROM engineers
WHERE safety_rating > 4.7
OR skill_level = 'Bậc 4';



-- cau 2
SELECT tower_name, serial_number
FROM telecom_towers
WHERE commission_date BETWEEN "1998-01-01 " AND "2001-12-31"
AND serial_number LIKE "SN-990%";


SELECT order_id, scheduled_time, operation_cost
FROM maintenance_orders
ORDER BY operation_cost DESC
LIMIT 2 OFFSET 2;

-- PHẦN 4: TRUY VẤN NÂNG CAO (15 ĐIỂM)
-- Câu 1
SELECT tower_name, full_name, skill_level, , scheduled_time
FROM telecom_towers AS tt
INNER JOIN maintenance_orders AS mo
ON tt.tower_id = mo.tower_id
INNER JOIN engineers AS e
ON e.engineer_id = mo.engineer_id;

-- CÂU 2 
SELECT full_name, SUM(operation_cost) as total
FROM maintenance_orders m
JOIN engineers e ON e.engineer_id = m.engineer_id 
WHERE order_status = 'Executed'
GROUP BY full_name
HAVING SUM(operation_cost) > 50000;

-- CAU 3
SELECT engineer_id, full_name, safety_rating 
FROM engineers
WHERE safety_rating = (SELECT MAX(safety_rating) FROM engineers);

-- PHẦN 5: INDEX & VIEW (10 ĐIỂM)
CREATE INDEX idx_order_status_cost
ON maintenance_orders (order_status,operation_cost);

CREATE VIEW view_abc AS 
SELECT e.full_name, COUNT(m.order_id), SUM(m.operation_cost)
FROM  maintenance_orders m 
JOIN engineers e 
ON e.engineer_id = m.engineer_id 
WHERE order_status <> 'Aborted'
GROUP BY e.full_name;

SELECT * FROM view_abc ;

-- PHẦN 6: TRIGGER (10 ĐIỂM)
-- Câu 1
DELIMITER //
CREATE TRIGGER trigger_after_update_maintenance_orders
AFTER UPDATE ON maintenance_orders
FOR EACH ROW
BEGIN
	IF NEW.order_status = 'Executed' 
		THEN
			INSERT INTO incident_reports VALUES
			(NULL, (SELECT log_id FROM technical_logs as t WHERE t.order_id = NEW.order_id),
			 NEW.engineer_id, NOW(), 'System check completed');
	END IF;
END //
DELIMITER ;

UPDATE maintenance_orders
SET order_status = 'Executed'
WHERE order_id = 7001;