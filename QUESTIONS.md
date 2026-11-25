# Three questions, pick one

Each question has a short form, the way you would ask a colleague, and a precise form, the one `check.R` checks. The gap between the two is where the traps live. Your brief closes the gap; `docs/codebook.md` has the conventions.

## Q1: What do owners ask per day?

Short: do professionals ask more per day than students?

Precise: the mean `price_per_day` in euros of listings owned by professionals, and of listings owned by students. One listing counted once (the latest export). Listings without a price left out. Owners without a type left out. Two numbers, one decimal.

## Q2: What does a rental bring in?

Short: do students pay less per rental than professionals?

Precise: the mean `amount` in euros per completed rental, for student renters and for professional renters. Completed rentals only. Renters without a type left out. Every completed rental counts, whether or not its listing is still in the export. Two numbers, one decimal.

## Q3: What do students rent?

Short: which kind of gear do students rent most?

Precise: the category with the most completed rentals by student renters, and that count. One listing counted once (the latest export). One word and one integer.

## The answer file

`outputs/answer.csv`, two columns, written by a script in `analysis/` (R or Python; `write.csv(..., row.names = FALSE)` in R):

```
key,value
question,Q2
professional,123.4
student,56.7
produced_by,analysis/answer.R
```

For Q3:

```
key,value
question,Q3
category,sound
count,12
produced_by,analysis/answer.R
```

`check.R` rounds numbers to one decimal and accepts a difference of 0.1. It does not contain the answers (only salted hashes), so reading it does not help. Reading the codebook does.

## Decisions the agent makes for you unless you make them

- Which rows count: both exports or the latest one? Prices of -1? Renters without a type? Rentals of listings that are gone?
- What a column means: cents or euros? `status`, or `amount > 0`?
- Where cleaning happens: a script that writes `data/clean/`, or the CSV edited in place? Only one of these passes the check.
- What "done" means: a number in the chat, or a file in `outputs/` that a script regenerates?
