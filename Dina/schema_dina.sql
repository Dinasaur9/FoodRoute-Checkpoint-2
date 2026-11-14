-- FoodRoute - Dina's tables (Checkpoint 2)
-- Entities:      Donor, FoodItem, Donation, Inventory
-- Relationships: Makes (Donation.donor_id), Receives (Donation.bank_id),
--                Contains (DonationItem), Stores (Inventory.bank_id),
--                Of Type (Inventory.item_id)
--
-- Depends on Emeka's FoodBank(bank_id) table: Donation and Inventory both
-- reference it, so FoodBank must be created and seeded BEFORE seed_dina.sql.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS DonationItem;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Donation;
DROP TABLE IF EXISTS FoodItem;
DROP TABLE IF EXISTS Donor;

-- Relation 1: Donor
CREATE TABLE Donor (
    donor_id    INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    donor_type  TEXT    NOT NULL
                CHECK (donor_type IN ('Individual', 'Farm', 'Grocery Store',
                                      'Restaurant', 'Business', 'Organization')),
    email       TEXT    UNIQUE,
    phone       TEXT,
    address     TEXT
);

-- Relation 3: FoodItem
CREATE TABLE FoodItem (
    item_id       INTEGER PRIMARY KEY,
    name          TEXT    NOT NULL UNIQUE,
    category      TEXT    NOT NULL,
    unit          TEXT    NOT NULL,
    is_perishable INTEGER NOT NULL DEFAULT 0 CHECK (is_perishable IN (0, 1))
);

-- Relation 6: Donation (Makes + Receives folded in as foreign keys)
CREATE TABLE Donation (
    donation_id   INTEGER PRIMARY KEY,
    donor_id      INTEGER NOT NULL,
    bank_id       INTEGER NOT NULL,
    donation_date TEXT    NOT NULL,              -- 'YYYY-MM-DD'
    status        TEXT    NOT NULL DEFAULT 'Pending'
                  CHECK (status IN ('Pending', 'Received', 'Rejected')),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id),
    FOREIGN KEY (bank_id)  REFERENCES FoodBank(bank_id)
);

-- Relation 7: DonationItem (Contains, many-to-many)
CREATE TABLE DonationItem (
    donation_id     INTEGER NOT NULL,
    item_id         INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK (quantity > 0),
    expiration_date TEXT    NOT NULL,            
    PRIMARY KEY (donation_id, item_id),
    FOREIGN KEY (donation_id) REFERENCES Donation(donation_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id)     REFERENCES FoodItem(item_id)
);

-- Relation 8: Inventory (Stores + Of Type folded in as foreign keys)
CREATE TABLE Inventory (
    inventory_id     INTEGER PRIMARY KEY,
    bank_id          INTEGER NOT NULL,
    item_id          INTEGER NOT NULL,
    quantity         INTEGER NOT NULL CHECK (quantity >= 0),
    expiration_date  TEXT    NOT NULL,           
    storage_location TEXT,
    date_received    TEXT    NOT NULL,           
    FOREIGN KEY (bank_id) REFERENCES FoodBank(bank_id),
    FOREIGN KEY (item_id) REFERENCES FoodItem(item_id)
);

-- Indexes for the most common joins / filters
CREATE INDEX idx_donation_donor     ON Donation(donor_id);
CREATE INDEX idx_donation_bank      ON Donation(bank_id);
CREATE INDEX idx_inventory_bank     ON Inventory(bank_id);
CREATE INDEX idx_inventory_item     ON Inventory(item_id);
CREATE INDEX idx_inventory_exp_date ON Inventory(expiration_date);
