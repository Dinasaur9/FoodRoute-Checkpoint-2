-- Emeka's seed data

PRAGMA foreign_keys = ON;

-- FoodBank (5 rows)
INSERT INTO FoodBank (bank_id, name, address, phone, manager_name) VALUES
 (1, 'Merced Community Food Bank', '2000 W Olive Ave, Merced, CA', '209-555-0101', 'Laura Chen'),
 (2, 'Atwater Family Pantry', '150 Bellevue Rd, Atwater, CA', '209-555-0102', 'David Ramirez'),
 (3, 'Los Banos Food Center', '820 I St, Los Banos, CA', '209-555-0103', 'Maria Gonzalez'),
 (4, 'Campus Pantry', '5200 Lake Rd, Merced, CA', '209-555-0104', 'James Lee'),
 (5, 'Livingston Hope Pantry', '410 Main St, Livingston, CA', '209-555-0105', 'Sarah Kim');

-- Recipient (15 rows)
INSERT INTO Recipient
(recipient_id, name, phone, address, household_size, dietary_needs)
VALUES
 (1, 'Jose Martinez', '209-555-2001', '101 Elm St, Merced, CA', 4, 'None'),
 (2, 'Linda Garcia', '209-555-2002', '55 Olive Ave, Atwater, CA', 3, 'Diabetic'),
 (3, 'Robert Wilson', '209-555-2003', '77 Main St, Los Banos, CA', 2, 'Low Sodium'),
 (4, 'Angela Brown', '209-555-2004', '900 G St, Merced, CA', 5, 'None'),
 (5, 'Michael Reed', '209-555-2005', '18 Cedar Rd, Livingston, CA', 1, 'Gluten Free'),
 (6, 'Patricia Young', '209-555-2006', '120 Oak St, Merced, CA', 4, 'None'),
 (7, 'Kevin Lopez', '209-555-2007', '45 Pine Ave, Atwater, CA', 2, 'Vegetarian'),
 (8, 'Teresa Scott', '209-555-2008', '780 Maple Dr, Merced, CA', 3, 'None'),
 (9, 'Daniel Perez', '209-555-2009', '600 Canal St, Merced, CA', 6, 'None'),
 (10, 'Emily Torres', '209-555-2010', '44 Palm St, Livingston, CA', 2, 'Nut Allergy'),
 (11, 'Nancy Flores', '209-555-2011', '88 Grant Ave, Los Banos, CA', 3, 'None'),
 (12, 'Samuel Rivera', '209-555-2012', '17 Vine St, Merced, CA', 5, 'Low Sugar'),
 (13, 'Jasmine Hernandez', '209-555-2013', '292 Yosemite Ave, Merced, CA', 4, 'None'),
 (14, 'Carlos Ortiz', '209-555-2014', '31 M St, Atwater, CA', 2, 'None'),
 (15, 'Maria Alvarez', '209-555-2015', '81 Loughborough Dr, Merced, CA', 7, 'Vegetarian');

-- Volunteer (12 rows)
INSERT INTO Volunteer
(volunteer_id, name, email, phone, availability)
VALUES
 (1, 'Alex Johnson', 'alex.johnson@email.com', '209-555-3001', 'Weekends'),
 (2, 'Sarah Lee', 'sarah.lee@email.com', '209-555-3002', 'Weekdays'),
 (3, 'David Kim', 'david.kim@email.com', '209-555-3003', 'Flexible'),
 (4, 'Rachel Green', 'rachel.green@email.com', '209-555-3004', 'Weekends'),
 (5, 'Brian White', 'brian.white@email.com', '209-555-3005', 'Evenings'),
 (6, 'Sophia Hall', 'sophia.hall@email.com', '209-555-3006', 'Weekdays'),
 (7, 'Jason Clark', 'jason.clark@email.com', '209-555-3007', 'Flexible'),
 (8, 'Olivia Hill', 'olivia.hill@email.com', '209-555-3008', 'Weekends'),
 (9, 'Noah Adams', 'noah.adams@email.com', '209-555-3009', 'Evenings'),
 (10, 'Chloe Baker', 'chloe.baker@email.com', '209-555-3010', 'Flexible'),
 (11, 'Ethan Cooper', 'ethan.cooper@email.com', '209-555-3011', 'Weekdays'),
 (12, 'Mia Turner', 'mia.turner@email.com', '209-555-3012', 'Weekends');

-- Distribution (15 rows)
INSERT INTO Distribution
(distribution_id, bank_id, recipient_id, distribution_date, method, status)
VALUES
 (1, 1, 1, '2026-10-01', 'Pickup', 'Completed'),
 (2, 1, 2, '2026-10-03', 'Delivery', 'Completed'),
 (3, 2, 3, '2026-10-05', 'Pickup', 'Completed'),
 (4, 3, 4, '2026-10-07', 'Mobile Pantry', 'Completed'),
 (5, 4, 5, '2026-10-10', 'Pickup', 'Completed'),
 (6, 5, 6, '2026-10-12', 'Delivery', 'Completed'),
 (7, 1, 7, '2026-10-15', 'Pickup', 'Completed'),
 (8, 2, 8, '2026-10-18', 'Mobile Pantry', 'Completed'),
 (9, 3, 9, '2026-10-22', 'Delivery', 'Completed'),
 (10, 4, 10, '2026-10-26', 'Pickup', 'Completed'),
 (11, 5, 11, '2026-11-01', 'Delivery', 'Completed'),
 (12, 1, 12, '2026-11-04', 'Mobile Pantry', 'Completed'),
 (13, 2, 13, '2026-11-07', 'Pickup', 'Completed'),
 (14, 3, 14, '2026-11-10', 'Delivery', 'Scheduled'),
 (15, 4, 15, '2026-11-13', 'Pickup', 'Scheduled');

-- Staffs (20 rows)
INSERT INTO Staffs
(volunteer_id, distribution_id, role, hours)
VALUES
 (1, 1, 'Driver', 4),
 (2, 1, 'Coordinator', 5),
 (3, 2, 'Driver', 3),
 (4, 2, 'Loader', 4),
 (5, 3, 'Coordinator', 4),
 (6, 3, 'Driver', 3),
 (7, 4, 'Driver', 4),
 (8, 4, 'Loader', 3),
 (9, 5, 'Coordinator', 5),
 (10, 5, 'Driver', 4),
 (11, 6, 'Loader', 3),
 (12, 6, 'Coordinator', 4),
 (2, 7, 'Driver', 4),
 (5, 8, 'Coordinator', 4),
 (8, 9, 'Driver', 3),
 (11, 10, 'Loader', 3),
 (1, 11, 'Coordinator', 5),
 (6, 12, 'Driver', 4),
 (9, 13, 'Coordinator', 3),
 (12, 14, 'Driver', 4);

-- Includes (20 rows)
INSERT INTO Includes
(distribution_id, inventory_id, quantity)
VALUES
 (1, 1, 5),
 (1, 2, 3),
 (2, 3, 4),
 (2, 5, 2),
 (3, 8, 2),
 (3, 9, 5),
 (4, 12, 8),
 (4, 13, 4),
 (5, 15, 6),
 (5, 17, 5),
 (6, 19, 3),
 (6, 22, 2),
 (7, 24, 7),
 (8, 25, 4),
 (9, 27, 3),
 (10, 30, 2),
 (11, 33, 2),
 (12, 38, 6),
 (13, 41, 3),
 (14, 49, 4);