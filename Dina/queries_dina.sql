-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- Modifications:
-- 1. Inventory: renamed the attribute "date received" to date_received (no
--    spaces) so it is a valid SQLite identifier.
-- 2. Added CHECK constraints: Donor.donor_type and Donation.status are limited
--    to fixed value lists, FoodItem.is_perishable must be 0/1,
--    DonationItem.quantity > 0, and Inventory.quantity >= 0.
-- 3. DonationItem.donation_id now uses ON DELETE CASCADE, so deleting a
--    donation also removes the line items it contained.
-- 4. Added NOT NULL / UNIQUE constraints (Donor.email, FoodItem.name UNIQUE).
-- 5. Added indexes on Donation(donor_id), Donation(bank_id), Inventory(bank_id),
--    Inventory(item_id) and Inventory(expiration_date) for joins and
--    expiration lookups.
-- 6. Added view InventoryDetails and trigger trg_DonationReceived
--    (created in Statements 25 and 26).
-- ============================================================================

PRAGMA foreign_keys = ON;
.headers on
.mode column

-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: Perishable Food Items
-- Explanation: List the name and category of every perishable food item,
--              sorted alphabetically by name.
-- ----------------------------------------------------------------------------
SELECT name, category
FROM FoodItem
WHERE is_perishable = 1
ORDER BY name;

-- ----------------------------------------------------------------------------
-- Statement 02: Organization Donors
-- Explanation: Find donors whose email address ends in '.org'.
-- ----------------------------------------------------------------------------
SELECT name, email
FROM Donor
WHERE email LIKE '%.org';

-- ----------------------------------------------------------------------------
-- Statement 03: Inventory Totals
-- Explanation: Count the inventory records and add up the total units stored
--              across all food banks.
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS total_records, SUM(quantity) AS total_units
FROM Inventory;

-- ----------------------------------------------------------------------------
-- Statement 04: Add a New Donor
-- Explanation: Insert a new restaurant donor, Harvest Table Bistro, into the
--              Donor table.
-- ----------------------------------------------------------------------------
INSERT INTO Donor (donor_id, name, donor_type, email, phone, address)
VALUES (16, 'Harvest Table Bistro', 'Restaurant', 'chef@harvesttable.com',
        '209-555-1016', '233 W Main St, Merced, CA');

-- ----------------------------------------------------------------------------
-- Statement 05: Delete a Rejected Donation
-- Explanation: Delete donation 24, which was rejected; its donation items are
--              removed automatically by ON DELETE CASCADE.
-- ----------------------------------------------------------------------------
DELETE FROM Donation
WHERE donation_id = 24;

-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Donations with Donor Names
-- Explanation: List each donation with the name of the donor who made it,
--              ordered by donation date.
-- ----------------------------------------------------------------------------
SELECT D.donation_id, DN.name AS donor_name, D.donation_date, D.status
FROM Donation D
JOIN Donor DN ON D.donor_id = DN.donor_id
ORDER BY D.donation_date;

-- ----------------------------------------------------------------------------
-- Statement 12: Total Units Donated per Food Item
-- Explanation: Add up how many units of each food item have been donated,
--              from most to least donated.
-- ----------------------------------------------------------------------------
SELECT FI.name, SUM(DI.quantity) AS total_donated
FROM FoodItem FI
JOIN DonationItem DI ON FI.item_id = DI.item_id
GROUP BY FI.name
ORDER BY total_donated DESC;

-- ----------------------------------------------------------------------------
-- Statement 13: Food Banks with Large Inventories
-- Explanation: Add up the units stored at each food bank and show only the
--              food banks holding more than 250 units.
-- ----------------------------------------------------------------------------
SELECT bank_id, SUM(quantity) AS total_units
FROM Inventory
GROUP BY bank_id
HAVING SUM(quantity) > 250;

-- ----------------------------------------------------------------------------
-- Statement 14: Food Items Never Donated
-- Explanation: Use a LEFT JOIN to find food items that do not appear in any
--              donation.
-- ----------------------------------------------------------------------------
SELECT FI.item_id, FI.name
FROM FoodItem FI
LEFT JOIN DonationItem DI ON FI.item_id = DI.item_id
WHERE DI.item_id IS NULL;

-- ----------------------------------------------------------------------------
-- Statement 15: Above-Average Inventory Records
-- Explanation: Find inventory records whose quantity is greater than the
--              average quantity of all inventory records.
-- ----------------------------------------------------------------------------
SELECT inventory_id, item_id, quantity
FROM Inventory
WHERE quantity > (SELECT AVG(quantity) FROM Inventory);

-- ----------------------------------------------------------------------------
-- Statement 16: Write Off Expired Food
-- Explanation: Set the quantity to 0 for every inventory record that expired
--              before 2026-11-16, since that food can no longer be given out.
-- ----------------------------------------------------------------------------
UPDATE Inventory
SET quantity = 0
WHERE expiration_date < '2026-11-16';

-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 22: Rank Donors by Number of Donations
-- Explanation: Use a CTE to count each donor's donations, then rank the donors
--              with DENSE_RANK from most to fewest donations.
-- ----------------------------------------------------------------------------
WITH DonationCounts AS (
    SELECT donor_id, COUNT(*) AS num_donations
    FROM Donation
    GROUP BY donor_id
)
SELECT DN.name, DC.num_donations,
       DENSE_RANK() OVER (ORDER BY DC.num_donations DESC) AS donor_rank
FROM DonationCounts DC
JOIN Donor DN ON DC.donor_id = DN.donor_id;

-- ----------------------------------------------------------------------------
-- Statement 23: Donors with No Donations
-- Explanation: Use NOT EXISTS to find donors who have never made a donation.
-- ----------------------------------------------------------------------------
SELECT DN.name, DN.email
FROM Donor DN
WHERE NOT EXISTS (
    SELECT 1 FROM Donation D WHERE D.donor_id = DN.donor_id
);

-- ----------------------------------------------------------------------------
-- Statement 24: Donated Items That Are Out of Stock
-- Explanation: Use EXCEPT to find item IDs that have been donated but have no
--              units left in any food bank's inventory.
-- ----------------------------------------------------------------------------
SELECT item_id FROM DonationItem
EXCEPT
SELECT item_id FROM Inventory WHERE quantity > 0;

-- ----------------------------------------------------------------------------
-- Statement 25: Inventory Details View
-- Explanation: Create a view that shows each inventory record with its food
--              bank and item names and a CASE label ('Use Soon' if it expires
--              before 2026-12-01, otherwise 'OK'), then query it.
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS InventoryDetails;

CREATE VIEW InventoryDetails AS
SELECT FB.name AS food_bank, FI.name AS food_item, I.quantity,
       I.expiration_date,
       CASE
           WHEN I.expiration_date < '2026-12-01' THEN 'Use Soon'
           ELSE 'OK'
       END AS label
FROM Inventory I
JOIN FoodBank FB ON I.bank_id = FB.bank_id
JOIN FoodItem FI ON I.item_id = FI.item_id;

SELECT *
FROM InventoryDetails
WHERE quantity > 0 AND label = 'Use Soon'
ORDER BY expiration_date;

-- ----------------------------------------------------------------------------
-- Statement 26: Add Received Donations to Inventory (Trigger)
-- Explanation: Create a trigger that copies a donation's items into Inventory
--              when its status changes to 'Received', then test it on donation 22.
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_DonationReceived;

CREATE TRIGGER trg_DonationReceived
AFTER UPDATE OF status ON Donation
WHEN NEW.status = 'Received'
BEGIN
    INSERT INTO Inventory (bank_id, item_id, quantity, expiration_date,
                           storage_location, date_received)
    SELECT NEW.bank_id, item_id, quantity, expiration_date,
           'Receiving Area', NEW.donation_date
    FROM DonationItem
    WHERE donation_id = NEW.donation_id;
END;

UPDATE Donation
SET status = 'Received'
WHERE donation_id = 22;

SELECT *
FROM Inventory
WHERE storage_location = 'Receiving Area';
