# The ladder exercise

Research Design and Methods with AI (RDMAI), WU Vienna, WS 2026/27. Voluntary, about 40 minutes, at home after session 2. Post your result in the Canvas discussion "Ladder exercise"; you get feedback within a week. Not graded.

You practise two things: putting work on GitHub, and working with an AI agent in four steps instead of one prompt (the ladder from session 2, in `LADDER.md`).

## The toy

A small synthetic rental marketplace, loosely modelled on an equipment-sharing platform and entirely invented: 60 users, 80 listings, 150 rentals, three CSV files in `data/raw/`, one codebook in `docs/codebook.md`. Three questions in `QUESTIONS.md`; you answer one.

The data has the traps real exports have: a column in cents, listings exported twice, prices that are not set, a status that looks like revenue but is not, rentals of listings that no longer exist. The codebook names every one of them. A plain prompt finds none of them and answers confidently anyway. That is the point of the exercise.

## What you need

- A GitHub account (github.com, free).
- Git on your machine, or GitHub Desktop, or neither: a Codespace runs in the browser (green "Code" button, tab "Codespaces", "Create codespace").
- Python 3.10 or newer (`python --version`). The check needs no packages; your agent may use pandas if it is installed.
- An agent. Coding agents (Claude Code, Codex, Cursor, Copilot) work inside the repository folder. A chat app (Claude, ChatGPT) works too: upload the three CSV files and the codebook, paste `PROJECT.md` as the first message, and copy the script it writes into `analysis/` yourself.

## Part A: GitHub, 10 minutes

1. Fork this repository: the "Fork" button at the top right. You now own a copy under your account.
2. Get it onto your machine: `git clone https://github.com/<your-user>/rdmai_ws26.git`, or "Open with GitHub Desktop", or a Codespace.
3. Open the folder in your editor and run `python check.py`. Most checks fail. That is where you start.

Later you need three commands: `git add -A`, `git commit -m "message"`, `git push`.

## Part B: the ladder, 30 minutes

### Step 0: Talk (5 min)

Pick a question in `QUESTIONS.md`. Ask your agent in plain words, with the data and nothing else: "Here are three CSV files from a rental platform. Do students pay less per rental than professionals?" Write down the number it gives and every assumption it made without asking. Keep nothing else; this answer goes nowhere.

### Step 1: Tell it what it cannot see (5 min)

Fill in `PROJECT.md`: eight lines, the parts in angle brackets. Copy it to `CLAUDE.md` (Claude Code) or `AGENTS.md` (Codex, Cursor, Copilot). In a chat app, paste it as the first message. From now on every session starts there.

### Step 2: Agree the plan before it acts (10 min)

Fill in `brief.md`: five answers. Give the agent the brief and say:

> Ask me clarifying questions until you could write this brief yourself. Then propose a plan: the steps, the files you will create or change, where you will stop and wait. Do not execute until I approve.

Read the plan against the list of conventions in the codebook. Change at least one step: a missing filter, a wrong order, a step that touches `data/raw/`. If the plan is already right, add a step: "report the row count after every filter". Paste the approved plan into `brief.md` and mark the step you changed. Then approve.

### Step 3: Give it a check to run (10 min)

Let it run. Done means two things: `python check.py` passes, and you have seen evidence. Ask for the command it ran and the output, the row counts before and after each filter, the lines of the script that apply each convention. "Are you sure?" is not a check.

Then do one thing by hand. Open `data/raw/users.csv` in a spreadsheet and count the students yourself, or count the rows with status `completed` in `rentals.csv`. Compare with what the agent reported. If you cannot explain the answer without the agent, you are not done.

### Log and commit (3 min)

One line in `log.md`: the agent writes it, you correct it. Then:

```
git add -A
git commit -m "ladder exercise: Q2 answered, check passes"
git push
```

## What to post in Canvas

The link to your fork and five lines: what step 0 answered and what it assumed; the step you changed in the plan; the evidence you asked for; the number you recomputed by hand and whether it matched; what `check.py` says.

## If you get stuck

- `check.py` says a raw file changed: `git checkout -- data/raw/` restores it. Cleaning belongs in a script under `analysis/` that writes to `data/clean/`.
- The agent does not know the conventions: they are in `docs/codebook.md`, and your `PROJECT.md` should say so.
- No Python on your machine: a Codespace has it.
- Anything else: the Canvas discussion first, e-mail second.

## Files

| File | What it is |
|---|---|
| `LADDER.md` | The four steps, when to climb, where they come from |
| `QUESTIONS.md` | Three questions, pick one; the shape of the answer file |
| `docs/codebook.md` | Every column, every convention, every trap |
| `PROJECT.md` | Step 1: the context file, eight lines to fill |
| `brief.md` | Step 2: the five questions of a brief, and the approved plan |
| `check.py` | Step 3: the check. `python check.py`; add `--rerun` to re-run your script as well |
| `log.md` | One line per agent session |
| `data/raw/` | The three CSV files. Never edited |
| `data/clean/`, `analysis/`, `outputs/` | Where the agent writes: cleaned data, the script, `answer.json` |

The data is synthetic and was generated for this course. There are no real users, listings or rentals in it.
