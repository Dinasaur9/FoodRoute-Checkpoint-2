# Checkpoint 2 - Emeka Database Notes

## Assigned Entities

1. FoodBank
2. Recipient
3. Volunteer
4. Distribution

## Assigned Relationships

1. Organizes
2. Staffs
3. ServedTo
4. Includes

---

## FoodBank

Attributes:
- bank_id (PK)
- name
- address
- phone
- manager_name

---

## Recipient

Attributes:
- recipient_id (PK)
- name
- phone
- address
- household_size
- dietary_needs

---

## Volunteer

Attributes:
- volunteer_id (PK)
- name
- email
- phone
- availability

---

## Distribution

Attributes:
- distribution_id (PK)
- distribution_date
- method
- status

---

## Staffs Relationship

Connects:
- Volunteer
- Distribution

Relationship Attributes:
- role
- hours

---

## Organizes Relationship

Connects:
- FoodBank
- Distribution

---

## ServedTo Relationship

Connects:
- Distribution
- Recipient