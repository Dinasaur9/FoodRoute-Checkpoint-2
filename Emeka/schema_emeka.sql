PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS ServedTo;
DROP TABLE IF EXISTS Staffs;
DROP TABLE IF EXISTS Distribution;
DROP TABLE IF EXISTS Volunteer;
DROP TABLE IF EXISTS Recipient;
DROP TABLE IF EXISTS FoodBank;

CREATE TABLE FoodBank (
    bank_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT,
    phone TEXT,
    manager_name TEXT
);

CREATE TABLE Recipient (
    recipient_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT,
    phone TEXT,
    household_size INTEGER,
    dietary_needs TEXT
);

CREATE TABLE Volunteer (
    volunteer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    availability TEXT
);

CREATE TABLE Distribution (
    distribution_id INTEGER PRIMARY KEY,
    bank_id INTEGER NOT NULL,
    distribution_date TEXT NOT NULL,
    method TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (bank_id)
        REFERENCES FoodBank(bank_id)
);