-- FoodRoute - Emeka's tables (Checkpoint 2)
--
-- Entities:
--   FoodBank
--   Recipient
--   Volunteer
--   Distribution
--
-- Relationships:
--   Organizes (Distribution.bank_id)
--   ServedTo (Distribution.recipient_id)
--   Staffs
--   Includes
--
-- Organizes and ServedTo are folded into Distribution
-- using foreign keys, following the same approach used
-- by Dina's schema.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Includes;
DROP TABLE IF EXISTS Staffs;
DROP TABLE IF EXISTS Distribution;
DROP TABLE IF EXISTS Volunteer;
DROP TABLE IF EXISTS Recipient;
DROP TABLE IF EXISTS FoodBank;

-- FoodBank
CREATE TABLE FoodBank (
    bank_id      INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    address      TEXT,
    phone        TEXT,
    manager_name TEXT
);

-- Recipient
CREATE TABLE Recipient (
    recipient_id   INTEGER PRIMARY KEY,
    name           TEXT NOT NULL,
    phone          TEXT,
    address        TEXT,
    household_size INTEGER CHECK (household_size > 0),
    dietary_needs  TEXT
);

-- Volunteer
CREATE TABLE Volunteer (
    volunteer_id INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    email        TEXT UNIQUE,
    phone        TEXT,
    availability TEXT
);

-- Distribution
-- Organizes -> FoodBank
-- ServedTo  -> Recipient
CREATE TABLE Distribution (
    distribution_id   INTEGER PRIMARY KEY,
    bank_id           INTEGER NOT NULL,
    recipient_id      INTEGER NOT NULL,
    distribution_date TEXT NOT NULL,
    method            TEXT NOT NULL,
    status            TEXT NOT NULL,

    FOREIGN KEY (bank_id)
        REFERENCES FoodBank(bank_id),

    FOREIGN KEY (recipient_id)
        REFERENCES Recipient(recipient_id)
);

-- Staffs (Volunteer <-> Distribution)
CREATE TABLE Staffs (
    volunteer_id    INTEGER NOT NULL,
    distribution_id INTEGER NOT NULL,
    role            TEXT NOT NULL,
    hours           REAL NOT NULL CHECK (hours >= 0),

    PRIMARY KEY (volunteer_id, distribution_id),

    FOREIGN KEY (volunteer_id)
        REFERENCES Volunteer(volunteer_id),

    FOREIGN KEY (distribution_id)
        REFERENCES Distribution(distribution_id)
);

-- Includes (Distribution <-> Inventory)
CREATE TABLE Includes (
    distribution_id INTEGER NOT NULL,
    inventory_id    INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK (quantity > 0),

    PRIMARY KEY (distribution_id, inventory_id),

    FOREIGN KEY (distribution_id)
        REFERENCES Distribution(distribution_id),

    FOREIGN KEY (inventory_id)
        REFERENCES Inventory(inventory_id)
);

-- Indexes
CREATE INDEX idx_distribution_bank
    ON Distribution(bank_id);

CREATE INDEX idx_distribution_recipient
    ON Distribution(recipient_id);

CREATE INDEX idx_staffs_distribution
    ON Staffs(distribution_id);

CREATE INDEX idx_includes_inventory
    ON Includes(inventory_id);