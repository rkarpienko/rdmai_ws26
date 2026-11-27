# The ladder exercise

RDMAI, WU Vienna, winter term 2026/27. Voluntary, not graded, about an hour. You put a small piece of work on GitHub and let an AI answer one question about a toy dataset, in four steps instead of one prompt. When you are done, post in the Canvas discussion "Ladder exercise"; you get feedback within a week.

No Git experience needed, and only basic R: `read.csv()`, `mean()`, `table()`.

**Six words.** Repository: a project folder with a history, kept on GitHub. Fork: your own copy of it on GitHub. Clone: that copy, downloaded to your computer. Commit: a saved snapshot with a one-line note. Push: uploading your snapshots to GitHub. Agent: an AI that can read and write files and run code, not only chat.

## You need

- A GitHub account (github.com) and GitHub Desktop (desktop.github.com), both free.
- R 4.1 or newer and an editor such as VS Code or RStudio. No R packages.
- An AI, either in your editor (Copilot Chat in VS Code, Claude Code, Cursor) or in a chat app (ChatGPT, Claude). With a chat app you upload the three CSV files and `codebook.md` yourself, and you save the code it writes as `analysis/answer.R`.

## The task

Three CSV files in `data/raw/` describe an invented rental marketplace: users, listings, rentals. `codebook.md` explains every column and names every trap in the data: an amount in cents, listings that appear twice, prices never set, a status that looks like a sale but is not. Pick one question:

- **Q1. Do professionals ask more per day than students?** Average `price_per_day` in euros of listings owned by professionals, and by students. Each listing once (latest export). No price, or no owner type: leave out.
- **Q2. Do students pay less per rental than professionals?** Average `amount` in euros per completed rental, for student renters and for professional renters. Completed only. No renter type: leave out. Every completed rental counts, even if its listing is gone.
- **Q3. What do students rent most?** The category with the most completed rentals by student renters, and that count. Each listing once.

The result is the file `outputs/answer.csv`, written by `analysis/answer.R`. For Q2:

```
key,value
question,Q2
professional,123.4
student,56.7
produced_by,analysis/answer.R
```

For Q3 the two middle rows are `category,sound` and `count,12`. In R, the last lines of the script:

```r
answer <- data.frame(key = c("question", "professional", "student", "produced_by"),
                     value = c("Q2", "123.4", "56.7", "analysis/answer.R"))
write.csv(answer, "outputs/answer.csv", row.names = FALSE, quote = FALSE)
```

If you simply ask the AI for the number, it misses the traps and answers confidently anyway. The steps below exist to catch that.

## Six steps

**1. Get the folder (10 min).** On github.com/rkarpienko/rdmai_ws26 click **Fork**, then **Create fork**. On your copy click the green **Code** button, then **Open with GitHub Desktop**, then **Clone**. Open the folder in your editor (RStudio: double-click `rdmai_ws26.Rproj`; VS Code: File, Open Folder). In the R console:

```r
source("check.R")
```

Most lines say FAIL. That is the start; the goal is all PASS. If R cannot find the file, `getwd()` must end in `rdmai_ws26`.

**2. Just ask (5 min).** Ask the AI your question in plain words, with the data and nothing else. Write down the number it gives and every assumption it made without asking. Then forget that answer.

**3. Tell it what it cannot see (5 min).** Fill in `PROJECT.md`: two gaps in angle brackets. Save a copy as `AGENTS.md` (Copilot, Codex, Cursor) or `CLAUDE.md` (Claude Code), or paste it as your first message in a chat app.

**4. Agree the plan before it acts (10 min).** Send the AI this brief, with your question filled in:

> Task: answer Q2 as defined in the README. Write analysis/answer.R and outputs/answer.csv. Done when source("check.R") shows all PASS and I have seen the number of rows after every filter. You may change analysis/ and outputs/ only. Stop after the plan, and again after cleaning, before computing. Ask me clarifying questions until you could write this brief yourself. Then propose a plan. Do not execute until I approve.

Read the plan next to the conventions in `codebook.md`. Change at least one step, or add one: "print the number of rows after every filter". Then say: approved.

**5. Give it a check to run (15 min).** Let it work. In a chat app, save the code as `analysis/answer.R` and run `source("analysis/answer.R")`. Then `source("check.R")`, until all PASS. Ask the AI for the rows after every filter and the lines of code that apply each convention; "are you sure?" is not a check. Count one thing yourself:

```r
users <- read.csv("data/raw/users.csv")
table(users$type)
```

**6. Save to GitHub (5 min).** Fill in the one line in `log.md`. In GitHub Desktop, write a summary such as `Q2 answered, check passes`, click **Commit to main**, then **Push origin**. Reload your page on github.com: your work is there. (Terminal: `git add -A`, `git commit -m "..."`, `git push`.)

## Post in Canvas

The link to your copy on GitHub and three lines: what the AI assumed in step 2, what you changed in the plan, the number you counted yourself and whether it matched.

## If something goes wrong

- The check says a raw file changed: in GitHub Desktop, right-click the file and choose **Discard changes**. Cleaning belongs in the script. (Excel: look, do not save.)
- `Rscript` is not recognized: use the R console instead, `source("check.R")`.
- Anything else: the Canvas discussion.

The data is invented. There are no real users, listings or rentals in it.
