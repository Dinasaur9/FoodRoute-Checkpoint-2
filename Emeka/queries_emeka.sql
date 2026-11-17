-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS
-- ============================================================================

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
VALUES
(13,
 'Taylor Brooks',
 'taylor.brooks@email.com',
 '209-555-3013',
 'Flexible');

-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS
-- ============================================================================

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
-- SECTION 3: COMPLEX STATEMENTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 27: Volunteer Hour Rankings
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
-- Statement 28: Recipients With No Distributions
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
-- Statement 29: Volunteer and Donor Contact Directory
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
-- Statement 30: Distribution Summary View
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
-- Statement 31: Household Size Categories
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