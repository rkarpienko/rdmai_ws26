# Brief: five questions, then the plan

Answer the five questions before you give the AI the task. Most answers are already written; fill in the gaps in angle brackets and delete the brackets. Then paste the whole file to the AI, followed by the sentence at the bottom.

1. **What does done look like?** Two or three checks that are either true or false.
   - `outputs/answer.csv` exists, has the shape shown in `QUESTIONS.md`, and `source("check.R")` shows all PASS.
   - The script prints the number of rows after every filter, and the number of students matches what I count myself.
   - <One more check of your own, or delete this line.>
2. **How can it check its own work?**
   - The script in `analysis/` runs from start to finish on the raw files and writes `outputs/answer.csv`. Running it twice gives the same file.
3. **What may it touch?**
   - May: `analysis/`, `data/clean/`, `outputs/`, `log.md`. May not: `data/raw/`, anything outside this folder.
   - Packages: <none, or name them, for example dplyr>.
4. **Where does it stop and wait for me?**
   - After the plan. After cleaning, before computing the answer. <Add a stop of your own, or delete this sentence.>
5. **Where does the result go, and who signs off?**
   - `outputs/answer.csv` and one line in `log.md`. I read the output and I save the work to GitHub.

Then say:

> Ask me clarifying questions until you could write this brief yourself. Then propose a plan: the steps, the files you will create or change, where you will stop and wait. Do not execute until I approve.

## The plan, as approved

<Paste the plan here and mark the step you changed.>
