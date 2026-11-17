-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: FoodRoute: Charity Food Distribution Management System
-- Team Members: Emeka Sha, Dina Seoudi
-- File: Checkpoint2-script.sql
-- ============================================================================

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
--    (created in Statements 24 and 25).
-- 7. Renamed the relationship tables DistributionItem and VolunteerAssignment
--    to Includes and Staffs, matching the relationship names in the ER diagram.
-- 8. Added CHECK constraints (Recipient.household_size > 0, Staffs.hours >= 0,
--    Includes.quantity > 0) and indexes on Distribution(bank_id),
--    Distribution(recipient_id), Staffs(distribution_id) and
--    Includes(inventory_id).
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: Dina: 100%, Emeka: 0%
-- Statement 02: Dina: 100%, Emeka: 0%
-- Statement 03: Dina: 100%, Emeka: 0%
-- Statement 04: Dina: 100%, Emeka: 0%
-- Statement 05: Dina: 100%, Emeka: 0%
-- Statement 06: Emeka: 100%, Dina: 0%
-- Statement 07: Emeka: 100%, Dina: 0%
-- Statement 08: Emeka: 100%, Dina: 0%
-- Statement 09: Emeka: 100%, Dina: 0%
-- Statement 10: Emeka: 100%, Dina: 0%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Dina: 100%, Emeka: 0%
-- Statement 12: Dina: 100%, Emeka: 0%
-- Statement 13: Dina: 100%, Emeka: 0%
-- Statement 14: Dina: 100%, Emeka: 0%
-- Statement 15: Dina: 100%, Emeka: 0%
-- Statement 16: Dina: 100%, Emeka: 0%
-- Statement 17: Emeka: 100%, Dina: 0%
-- Statement 18: Emeka: 100%, Dina: 0%
-- Statement 19: Emeka: 100%, Dina: 0%
-- Statement 20: Emeka: 100%, Dina: 0%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 21: Dina: 100%, Emeka: 0%
-- Statement 22: Dina: 100%, Emeka: 0%
-- Statement 23: Dina: 100%, Emeka: 0%
-- Statement 24: Dina: 100%, Emeka: 0%
-- Statement 25: Dina: 100%, Emeka: 0%
-- Statement 26: Emeka: 100%, Dina: 0%
-- Statement 27: Emeka: 100%, Dina: 0%
-- Statement 28: Emeka: 100%, Dina: 0%
-- Statement 29: Emeka: 100%, Dina: 0%
-- Statement 30: Emeka: 100%, Dina: 0%
-- ============================================================================

PRAGMA foreign_keys = ON;
.headers on
.mode column

-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Statements 1-10)
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
INSERT INTO Donor
(donor_id, name, donor_type, email, phone, address)
SELECT
16,
'Harvest Table Bistro',
'Restaurant',
'chef@harvesttable.com',
'209-555-1016',
'233 W Main St, Merced, CA'
WHERE NOT EXISTS (
    SELECT 1
    FROM Donor
    WHERE donor_id = 16
);

-- ----------------------------------------------------------------------------
-- Statement 05: Delete a Rejected Donation
-- Explanation: Delete donation 24, which was rejected; its donation items are
--              removed automatically by ON DELETE CASCADE.
-- ----------------------------------------------------------------------------
DELETE FROM Donation
WHERE donation_id = 24;

-- ----------------------------------------------------------------------------
-- Statement 06: Volunteer Availability List
-- Explanation: List every volunteer and their availability, ordered
-- alphabetically by name.
-- ----------------------------------------------------------------------------
SELECT name, availability
FROM Volunteer
ORDER BY name;

-- ----------------------------------------------------------------------------
-- Statement 07: Large Households
-- Explanation: Find recipients who live in households with more than four
-- members.
-- ----------------------------------------------------------------------------
SELECT name, household_size
FROM Recipient
WHERE household_size > 4
ORDER BY household_size DESC;

-- ----------------------------------------------------------------------------
-- Statement 08: Completed Distributions
-- Explanation: Show all distributions that have been completed, including
-- the distribution date and method.
-- ----------------------------------------------------------------------------
SELECT distribution_id, distribution_date, method
FROM Distribution
WHERE status = 'Completed'
ORDER BY distribution_date;

-- ----------------------------------------------------------------------------
-- Statement 09: Total Number of Volunteers
-- Explanation: Count the total number of volunteers currently registered.
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS total_volunteers
FROM Volunteer;

-- ----------------------------------------------------------------------------
-- Statement 10: Add a New Volunteer
-- Explanation: Insert a new volunteer into the Volunteer table.
-- ----------------------------------------------------------------------------
INSERT INTO Volunteer
(volunteer_id, name, email, phone, availability)
SELECT
13,
'Taylor Brooks',
'taylor.brooks@email.com',
'209-555-3013',
'Flexible'
WHERE NOT EXISTS (
    SELECT 1
    FROM Volunteer
    WHERE volunteer_id = 13
);

-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Statements 11-20)
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

-- ----------------------------------------------------------------------------
-- Statement 17: Food Banks and Their Distributions
-- Explanation: Show each food bank together with the distributions it has
-- organized.
-- ----------------------------------------------------------------------------
SELECT
    FB.name AS food_bank,
    D.distribution_id,
    D.distribution_date,
    D.method,
    D.status
FROM FoodBank FB
JOIN Distribution D
    ON FB.bank_id = D.bank_id
ORDER BY D.distribution_date;

-- ----------------------------------------------------------------------------
-- Statement 18: Volunteer Staffing Assignments
-- Explanation: Display volunteers assigned to each distribution, including
-- their role and hours worked.
-- ----------------------------------------------------------------------------
SELECT
    V.name AS volunteer_name,
    S.distribution_id,
    S.role,
    S.hours
FROM Volunteer V
JOIN Staffs S
    ON V.volunteer_id = S.volunteer_id
ORDER BY S.distribution_id;

-- ----------------------------------------------------------------------------
-- Statement 19: Total Volunteer Hours Per Distribution
-- Explanation: Calculate total staffing hours assigned to each distribution
-- and show only distributions with more than five volunteer hours.
-- ----------------------------------------------------------------------------
SELECT
    distribution_id,
    SUM(hours) AS total_hours
FROM Staffs
GROUP BY distribution_id
HAVING SUM(hours) > 5
ORDER BY total_hours DESC;

-- ----------------------------------------------------------------------------
-- Statement 20: Distribution Counts Per Food Bank
-- Explanation: Count how many distributions each food bank has organized.
-- ----------------------------------------------------------------------------
SELECT
    FB.name,
    COUNT(D.distribution_id) AS total_distributions
FROM FoodBank FB
LEFT JOIN Distribution D
    ON FB.bank_id = D.bank_id
GROUP BY FB.name
ORDER BY total_distributions DESC;


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Statements 21 - 30)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: Rank Donors by Number of Donations
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
-- Statement 22: Donors with No Donations
-- Explanation: Use NOT EXISTS to find donors who have never made a donation.
-- ----------------------------------------------------------------------------
SELECT DN.name, DN.email
FROM Donor DN
WHERE NOT EXISTS (
    SELECT 1 FROM Donation D WHERE D.donor_id = DN.donor_id
);

-- ----------------------------------------------------------------------------
-- Statement 23: Donated Items That Are Out of Stock
-- Explanation: Use EXCEPT to find item IDs that have been donated but have no
--              units left in any food bank's inventory.
-- ----------------------------------------------------------------------------
SELECT item_id FROM DonationItem
EXCEPT
SELECT item_id FROM Inventory WHERE quantity > 0;

-- ----------------------------------------------------------------------------
-- Statement 24: Inventory Details View
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
-- Statement 25: Add Received Donations to Inventory (Trigger)
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

-- ----------------------------------------------------------------------------
-- Statement 26: Volunteer Hour Rankings
-- Explanation: Use a Common Table Expression and DENSE_RANK to rank
-- volunteers by total hours worked.
-- ----------------------------------------------------------------------------
WITH VolunteerHours AS (
    SELECT
        volunteer_id,
        SUM(hours) AS total_hours
    FROM Staffs
    GROUP BY volunteer_id
)
SELECT
    V.name,
    VH.total_hours,
    DENSE_RANK() OVER (
        ORDER BY VH.total_hours DESC
    ) AS volunteer_rank
FROM VolunteerHours VH
JOIN Volunteer V
    ON VH.volunteer_id = V.volunteer_id;

-- ----------------------------------------------------------------------------
-- Statement 27: Recipients With No Distributions
-- Explanation: Use NOT EXISTS to find recipients who have never received
-- a distribution.
-- ----------------------------------------------------------------------------
SELECT
    R.name
FROM Recipient R
WHERE NOT EXISTS (
    SELECT 1
    FROM Distribution D
    WHERE D.recipient_id = R.recipient_id
);

-- ----------------------------------------------------------------------------
-- Statement 28: Volunteer and Donor Contact Directory
-- Explanation: Combine volunteer and donor contact information using UNION.
-- ----------------------------------------------------------------------------
SELECT
    name,
    email,
    'Volunteer' AS contact_type
FROM Volunteer

UNION

SELECT
    name,
    email,
    'Donor' AS contact_type
FROM Donor

ORDER BY name;

-- ----------------------------------------------------------------------------
-- Statement 29: Distribution Summary View
-- Explanation: Create a view that summarizes distributions, then display
-- information from the view.
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS DistributionSummary;

CREATE VIEW DistributionSummary AS
SELECT
    D.distribution_id,
    FB.name AS food_bank,
    R.name AS recipient,
    D.distribution_date,
    D.method,
    D.status
FROM Distribution D
JOIN FoodBank FB
    ON D.bank_id = FB.bank_id
JOIN Recipient R
    ON D.recipient_id = R.recipient_id;

SELECT *
FROM DistributionSummary
ORDER BY distribution_date;

-- ----------------------------------------------------------------------------
-- Statement 30: Household Size Categories
-- Explanation: Classify recipients as Small, Medium, or Large households
-- using a CASE expression.
-- ----------------------------------------------------------------------------
SELECT
    name,
    household_size,
    CASE
        WHEN household_size >= 6 THEN 'Large Household'
        WHEN household_size >= 3 THEN 'Medium Household'
        ELSE 'Small Household'
    END AS household_category
FROM Recipient
ORDER BY household_size DESC;
