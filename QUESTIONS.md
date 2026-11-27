# Three questions, pick one

Each question comes twice: the way you would ask a colleague, and exactly what the check expects. The difference between the two is where the traps are. The conventions you need are in `docs/codebook.md`.

## Q1: What do owners ask per day?

The question: do professionals ask more per day than students?

Exactly: the average `price_per_day` (in euros) of listings owned by professionals, and of listings owned by students. Count each listing once (use the latest export). Leave out listings without a price. Leave out owners whose type is empty. Two numbers, one decimal.

## Q2: What does a rental bring in?

The question: do students pay less per rental than professionals?

Exactly: the average `amount` (in euros) per completed rental, for renters who are students and for renters who are professionals. Completed rentals only. Leave out renters whose type is empty. Count every completed rental, even if its listing is no longer in the export. Two numbers, one decimal.

## Q3: What do students rent?

The question: which kind of gear do students rent most?

Exactly: the category with the most completed rentals by student renters, and that number. Count each listing once (use the latest export). One word and one whole number.

## The answer file

The script writes `outputs/answer.csv`: two columns, `key` and `value`, one row per entry. For Q2 it looks like this:

```
key,value
question,Q2
professional,123.4
student,56.7
produced_by,analysis/answer.R
```

For Q3 the two middle rows are `category,sound` and `count,12`.

In R, the last lines of the script can be:

```r
answer <- data.frame(key   = c("question", "professional", "student", "produced_by"),
                     value = c("Q2", "123.4", "56.7", "analysis/answer.R"))
write.csv(answer, "outputs/answer.csv", row.names = FALSE, quote = FALSE)
```

The check rounds numbers to one decimal and accepts a difference of 0.1. It does not contain the answers (only scrambled versions of them), so reading `check.R` does not help. Reading the codebook does.

## Things the AI decides silently unless you decide them

- Which rows count: both exports or only the latest? Prices of -1? Renters without a type? Rentals of listings that are gone?
- What a column means: cents or euros? The `status` column, or "amount greater than zero"?
- Where cleaning happens: in a script, or by editing the CSV file? Only the script passes the check.
- What "done" means: a number in the chat, or a file in `outputs/` that a script can produce again?
