# Codebook: the toy marketplace export

Synthetic data generated for this course. It imitates an export from a peer-to-peer equipment rental platform. Nothing in it is real. Three files, exported on 2026-11-01.

## users.csv (60 rows, one per user)

| Column | Meaning | Values |
|---|---|---|
| `user_id` | the user | u001 to u060 |
| `type` | self-reported at sign-up | `student`, `professional`, or empty: not reported (8 users) |
| `city` | where the user is based | Vienna, Graz, Linz |
| `joined` | date of sign-up | ISO date |

A user can be an owner (`listings.owner_id`), a renter (`rentals.renter_id`), or both.

## listings.csv (90 rows, 80 listings)

| Column | Meaning | Values |
|---|---|---|
| `listing_id` | the listing | L001 to L080 |
| `owner_id` | the user who owns the item | a `user_id` |
| `category` | kind of gear | lighting, sound, video, photo |
| `title` | the item | text |
| `price_per_day` | asking price per day in euros, set by the owner | integer; **-1 means no price set yet** (6 listings) |
| `exported_at` | the export this row comes from | 2026-10-01 or 2026-11-01 |

**Two exports are stacked in this file.** Ten listings appear twice, once per export, each row with the price the owner had set at the time. Convention: one listing, one row, the latest `exported_at`. The rows are not sorted.

## rentals.csv (150 rows, one per rental)

| Column | Meaning | Values |
|---|---|---|
| `rental_id` | the rental | R001 to R150 |
| `listing_id` | what was rented | a `listing_id`. **Five rentals refer to L081 to L085, listings their owners deleted before the export.** The rentals happened; the listings are gone |
| `renter_id` | who rented | a `user_id` |
| `start_date`, `end_date` | the booked period | ISO dates; days = end minus start |
| `status` | how the rental ended | `completed`, `cancelled`, `no_show`, `requested` |
| `amount` | **what the renter was charged, in cents** | integer. Completed and no-show rentals are charged; cancelled and requested are 0 |

## The conventions, in one place

1. `amount` is in cents. Divide by 100.
2. Revenue questions use `status == completed`. A no-show is charged, but it is not a completed rental.
3. One listing, one row: keep the latest `exported_at` per `listing_id`.
4. `price_per_day == -1` is not a price. Leave those listings out of price questions.
5. An empty `type` is not a group. Leave those users out of comparisons by type.
6. Rentals of deleted listings exist. A join to listings loses them; an answer about rentals must not.
7. `data/raw/` is never edited. Cleaning is a script that writes to `data/clean/`.
