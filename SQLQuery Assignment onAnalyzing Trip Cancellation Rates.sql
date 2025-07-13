---Create Users table
CREATE TABLE Users (
    users_id INT PRIMARY KEY,
    banned VARCHAR(3),       -- 'Yes' or 'No'
    role VARCHAR(10)         -- 'client', 'driver', or 'partner');

-- Insert data into Users table
INSERT INTO Users (users_id, banned, role) VALUES
(1, 'No', 'client'),
(2, 'No', 'driver'),
(3, 'Yes', 'client'),
(4, 'No', 'driver'),
(5, 'No', 'client'),
(6, 'Yes', 'driver');

-- Create Trips table
CREATE TABLE Trips (
    id INT PRIMARY KEY,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(30),       -- 'completed', 'cancelled_by_client', 'cancelled_by_driver'
    request_at VARCHAR(10));    -- format: 'YYYY-MM-DD'


-- Insert data into Trips table
INSERT INTO Trips (id, client_id, driver_id, city_id, status, request_at) VALUES
-- 2013-10-01
(1, 1, 2, 1, 'completed', '2013-10-01'),                   -- valid
(2, 3, 2, 1, 'cancelled_by_client', '2013-10-01'),         -- banned client ❌
(3, 1, 6, 1, 'cancelled_by_driver', '2013-10-01'),         -- banned driver ❌
(4, 5, 4, 1, 'cancelled_by_client', '2013-10-01'),         -- valid
(9, 5, 2, 1, 'completed', '2013-10-01'),                   -- valid

-- 2013-10-02
(5, 1, 2, 1, 'completed', '2013-10-02'),                   -- valid
(6, 5, 4, 1, 'completed', '2013-10-02'),                   -- valid

-- 2013-10-03
(7, 5, 4, 1, 'cancelled_by_driver', '2013-10-03'),         -- valid
(8, 1, 2, 1, 'completed', '2013-10-03');                   -- valid

--  Calculate daily cancellation rate (2 decimal places)
SELECT
  t.request_at AS Day,
  CAST(
    ROUND(
      SUM(CASE 
            WHEN t.status IN ('cancelled_by_client', 'cancelled_by_driver') THEN 1 
            ELSE 0 
          END) * 1.0 / COUNT(*), 2
    ) AS DECIMAL(4,2)
  ) AS [Cancellation Rate]
FROM Trips t
JOIN Users c ON t.client_id = c.users_id
JOIN Users d ON t.driver_id = d.users_id
WHERE c.banned = 'No' AND c.role = 'client'
  AND d.banned = 'No' AND d.role = 'driver'
  AND t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at
ORDER BY t.request_at;


