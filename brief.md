# Brief: five questions, then the plan

Fill in the five answers before you give the agent the task. Then paste the whole file and the sentence at the bottom. Half a page at most.

1. What does done look like? Two or three yes/no checks an outsider could verify.
   - `outputs/answer.csv` exists, has the shape in `QUESTIONS.md`, and `Rscript check.R` passes.
   - <one more check of your own, for example: the row counts after each filter are reported and match what I count by hand>
2. How can it check its own work? A script that re-runs, a count it can recompute.
   - <for example: analysis/answer.R re-runs from data/raw/ and writes the same answer.csv; Rscript check.R --rerun confirms it>
3. What may it touch? Files, data, tools.
   - May: `analysis/`, `data/clean/`, `outputs/`, `log.md`. May not: `data/raw/`, anything outside this folder.
   - <packages it may use, if any, for example dplyr; base R is enough>
4. What stops it? Steps, a budget, a checkpoint where it waits for you.
   - <for example: after the plan; after cleaning, before computing; before writing the log line>
5. Where does the result go, and who signs off?
   - `outputs/answer.csv` and one line in `log.md`. <who> reads the evidence and makes the commit.

Then say:

> Ask me clarifying questions until you could write this brief yourself. Then propose a plan: the steps, the files you will create or change, where you will stop and wait. Do not execute until I approve.

## The plan, as approved

<paste the plan here and mark the step you changed>
