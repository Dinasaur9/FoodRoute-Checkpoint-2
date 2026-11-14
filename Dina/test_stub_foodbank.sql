-- LOCAL TESTING ONLY - stand-in for Emeka's FoodBank table.
-- Do NOT include in the final database; Emeka's real FoodBank table replaces it.
-- The only requirement on Emeka's side: bank_id values 1-5 must exist.
DROP TABLE IF EXISTS FoodBank;
CREATE TABLE FoodBank (
    bank_id      INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    address      TEXT,
    phone        TEXT,
    manager_name TEXT
);
INSERT INTO FoodBank VALUES
 (1, 'Merced Community Food Bank', '2000 W Olive Ave, Merced, CA',   '209-555-0101', 'Laura Chen'),
 (2, 'Atwater Family Pantry',      '150 Bellevue Rd, Atwater, CA',   '209-555-0102', 'David Ramirez'),
 (3, 'Los Banos Food Center',      '820 I St, Los Banos, CA',        '209-555-0103', 'Maria Gonzalez'),
 (4, 'Campus Pantry',              '5200 Lake Rd, Merced, CA',       '209-555-0104', 'James Lee'),
 (5, 'Livingston Hope Pantry',     '410 Main St, Livingston, CA',    '209-555-0105', 'Sarah Kim');
