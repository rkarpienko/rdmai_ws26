# The ladder: four steps, one constraint each

Start with a plain prompt. Climb one step only when the step below fails you in the way described. Most project work happens on steps 2 and 3.

| Step | What you add | Climb when | In this exercise |
|---|---|---|---|
| 0 Talk | Nothing. Chat, explore, throw it away | Always start here | The question asked in plain words, with the CSV files and nothing else |
| 1 Tell it what it cannot see | One short context file the agent reads at the start of every session | It invents context or asks the same thing twice | `PROJECT.md`, copied to `CLAUDE.md` or `AGENTS.md`; pasted first in a chat app |
| 2 Agree the plan before it acts | A brief built from five questions; the agent proposes a plan; you approve before anything is executed | It does the wrong thing confidently | `brief.md`, plan mode or "do not execute until I approve", one step changed |
| 3 Give it a check to run | Done is a list of yes/no checks; the agent shows evidence; you open one source and recompute one number | It says done and it is not | `python check.py`, the row counts, one number counted by hand, a line in `log.md`, a commit |
| 4 Decide what it may touch | Green, amber, red for actions; the permission mode; a few rules with no exceptions | It did something that must never happen | Not part of this exercise. In the project: a permissions table in `PROJECT.md` |

Only when all four hold does an agent run without you, and in this course that is rare.

## The brief: five questions (step 2)

1. Does it know what done looks like? Two or three yes/no checks an outsider could verify.
2. Can it check its own work? A script that re-runs, a source it can open, a count it can recompute.
3. What is it allowed to touch? Which files, which data, which tools. Never raw data, never messages, never money.
4. What stops it? A number of steps, a budget, a checkpoint where it waits for you.
5. Where does the result go, and who signs off? A file in the repo, a line in the log, a person who approves anything that cannot be taken back.

Then: "Ask me clarifying questions until you could write this brief yourself. Propose a plan. Do not execute until I approve."

## The evidence rule (step 3)

"Are you sure?" is not a check. Ask for the command and its output, the source and the quoted passage, the re-run result, the row counts. Then open one source yourself and recompute one number yourself. If you cannot explain a result without the agent, you are not done.

## What stays with you on every step

The question, the design, the interpretation, the wording, and every decision to contact someone, spend money or use personal data.

## Where the steps come from

The four steps follow Anthropic's own guidance for working with Claude Code: tell it what it cannot see, give it a check to run, enforce the rules that cannot have exceptions, and approve a plan before edits (Claude Code documentation: best practices, common workflows, memory, permission modes, checked 25 Nov 2026), together with the engineering posts "Building effective agents" (Dec 2024), "Effective context engineering for AI agents" (Sep 2025), "Effective harnesses for long-running agents" (Nov 2025) and "Demystifying evals for AI agents" (Jan 2026). The ladder itself is this course's synthesis.
