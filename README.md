# The ladder exercise

Research Design and Methods with AI (RDMAI), WU Vienna, winter term 2026/27. Voluntary, not graded. Plan about an hour the first time. When you are done, post in the Canvas discussion "Ladder exercise"; you get feedback within a week.

You practise two things:

1. Putting your work on GitHub, where every project in this course will live.
2. Working with an AI in four small steps instead of one big prompt. That is the ladder from session 2.

You need no experience with Git and only basic R (reading a CSV file, `mean()`, `table()`). Everything else is explained below.

## Six words you will meet

| Word | What it means here |
|---|---|
| Repository | A project folder that GitHub keeps a history of. This page is one. |
| Fork | Your own copy of someone else's repository, on GitHub, under your name. |
| Clone | Downloading your copy to your computer, so the two stay connected. |
| Commit | Saving a snapshot of your folder with a one-line note of what changed. |
| Push | Uploading your snapshots to GitHub. |
| Agent | An AI that can read and write files and run code for you, not only chat. |

## The toy

A small invented rental marketplace: 60 users, 80 listings, 150 rentals, three CSV files in `data/raw/`, and a codebook in `docs/codebook.md` that explains every column. Nothing in it is real.

Three questions in `QUESTIONS.md`. You answer one of them with the AI, for example: do students pay less per rental than professionals?

The data has the traps real data has: an amount stored in cents, listings that appear twice, prices that were never set, a status that looks like a sale but is not. The codebook names every trap. If you simply ask the AI for the number, it will miss them and answer confidently anyway. That is what this exercise is about.

## Before you start

- A GitHub account: github.com, free. Use your WU e-mail.
- GitHub Desktop: desktop.github.com, free. It gives you buttons instead of commands. Sign in with your GitHub account.
- R, version 4.1 or newer (cran.r-project.org), and an editor such as VS Code or RStudio. The check uses plain R, no packages.
- An AI. Two ways to work:
  - **In your editor.** GitHub Copilot Chat in VS Code (GitHub offers it free to verified students), Claude Code, Cursor or Codex. These can read your folder, write files and run R for you.
  - **In a chat app.** Claude or ChatGPT in the browser. You do the file work yourself: upload the three CSV files and the codebook, paste `PROJECT.md` as the first message, and when the AI writes R code, save it as `analysis/answer.R` and run it.

## Part A: get the folder onto your computer (15 min)

1. Log in to GitHub and open this page: github.com/rkarpienko/rdmai_ws26. Click **Fork** (top right), then **Create fork**. You now have your own copy at `github.com/YOUR-NAME/rdmai_ws26`.
2. On your copy, click the green **Code** button, then **Open with GitHub Desktop**. Choose where to save the folder and click **Clone**.
3. Open the folder in your editor. RStudio: double-click `rdmai_ws26.Rproj` inside the folder. VS Code: File, Open Folder.
4. Run the check once. In the R console type:

   ```r
   source("check.R")
   ```

   You will see lines like these:

   ```
   PASS  raw data untouched: users.csv
   FAIL  PROJECT.md filled, no <...> left  (<your names>; ...)
   FAIL  outputs/answer.csv present  (missing; see QUESTIONS.md for the shape)

   3 of 7 checks pass.
   ```

   Most checks fail. That is where you start. Your job is to turn every FAIL into PASS, in four steps.

If the console says it cannot open a file, R is not looking in the right folder. Type `getwd()`; it should end in `rdmai_ws26`. If not, open the folder as described in step 3.

## Part B: the ladder (40 min)

### Step 0: just ask (5 min)

Pick one question in `QUESTIONS.md`. Ask the AI in plain words, with the data and nothing else, for example: "Here are three CSV files from a rental platform. Do students pay less per rental than professionals?"

Write down the number it gives you, and every assumption it made without asking. Then forget this answer. It goes nowhere.

### Step 1: tell it what it cannot see (5 min)

Open `PROJECT.md`. Fill in the parts in angle brackets `< >` and delete the brackets. Eight lines, one page.

Then make sure the AI reads it at the start of every conversation:

- Copilot or Codex: save a copy of the file as `AGENTS.md` in the same folder. Claude Code: save a copy as `CLAUDE.md`.
- Chat app: paste the whole file as your first message, every time.

### Step 2: agree the plan before it acts (10 min)

Open `brief.md`. Answer the five questions; most answers are already there, fill in the gaps. Give the AI the brief and say:

> Ask me clarifying questions until you could write this brief yourself. Then propose a plan: the steps, the files you will create or change, where you will stop and wait. Do not execute until I approve.

Read the plan next to the list of conventions in `docs/codebook.md`. Change at least one step: a filter it forgot, a wrong order, anything that would change the raw files. If the plan is already right, add a step: "print the number of rows after every filter". Paste the final plan at the bottom of `brief.md` and mark the step you changed. Then say: approved.

### Step 3: give it a check to run (15 min)

Let the AI work. If you use a chat app, save the code it gives you as `analysis/answer.R` and run it in the console with `source("analysis/answer.R")`.

Done means two things:

1. `source("check.R")` shows all PASS.
2. You have seen evidence. Ask the AI for the output of its script, the number of rows after every filter, and the lines of code that apply each convention. "Are you sure?" is not a check.

Then do one thing yourself. In the console:

```r
users <- read.csv("data/raw/users.csv")
table(users$type)
```

Compare the number of students with what the AI reported. If you cannot explain the final answer without the AI, you are not done.

### Step 4: save your work to GitHub (5 min)

Open `log.md` and fill in the one line at the bottom: the AI can write it, you correct it. Then open GitHub Desktop. It lists every file you changed. In the box at the bottom left, write a short summary, for example `Q2 answered, check passes`. Click **Commit to main**, then **Push origin**. Reload your page on github.com: your work is there.

If you prefer the terminal, the same three commands are:

```
git add -A
git commit -m "Q2 answered, check passes"
git push
```

## What to post in Canvas

The link to your copy on GitHub and five short lines:

1. What the AI answered in step 0 and what it assumed.
2. The step you changed in the plan.
3. The evidence you asked for.
4. The number you counted yourself, and whether it matched.
5. What `check.R` says now.

## When something goes wrong

- **The check says a raw file changed.** Something edited `data/raw/`. In GitHub Desktop, right-click that file and choose **Discard changes**. Cleaning belongs in the script, never in the raw files.
- **You opened a CSV in Excel.** Looking is fine. Do not save; Excel rewrites the file. If you did, discard the change as above.
- **`Rscript` is not recognized** in the terminal. Use the R console instead: `source("check.R")`.
- **The AI does not know the conventions.** Your `PROJECT.md` must point to `docs/codebook.md`. In a chat app you also have to upload the codebook.
- **The AI says the check passes, but it does not for you.** Run `source("check.R")` yourself. The check that counts is the one you see.
- **Anything else.** Ask in the Canvas discussion first, e-mail second.

## What is in the folder

| File | What it is |
|---|---|
| `QUESTIONS.md` | Three questions, pick one; what the answer file must look like |
| `docs/codebook.md` | Every column, every convention, every trap |
| `PROJECT.md` | Step 1: the context file you fill in |
| `brief.md` | Step 2: the five questions of a brief, and the approved plan |
| `check.R` | Step 3: the check. In the console: `source("check.R")` |
| `log.md` | Step 4: one line per session with the AI |
| `LADDER.md` | The four steps as a reference, and where they come from |
| `rdmai_ws26.Rproj` | Opens the folder as a project in RStudio. VS Code users just open the folder |
| `data/raw/` | The three CSV files. Never edited |
| `data/clean/`, `analysis/`, `outputs/` | Where the AI writes: cleaned data, the script, `answer.csv` |

The data is synthetic and was generated for this course. There are no real users, listings or rentals in it.
