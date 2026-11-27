# PROJECT.md

The page the AI reads first. Fill in the two gaps in angle brackets and delete the brackets. Save a copy as `AGENTS.md` (Copilot, Codex, Cursor) or `CLAUDE.md` (Claude Code); in a chat app, paste it as your first message.

- Who: <your name>, course RDMAI, WU Vienna, winter term 2026/27, the ladder exercise.
- Data: an invented rental marketplace, three CSV files in `data/raw/`. Read `codebook.md` first; it explains every column and every convention.
- Question: <Q1, Q2 or Q3 from the README, as a full sentence>.
- How we work: propose a plan and wait for my approval before you act. Show me the code you ran, the number of rows after every filter, and the final numbers.
- Where things go: one R script, `analysis/answer.R`, that reads `data/raw/` and writes `outputs/answer.csv`. Use paths like `data/raw/users.csv`.
- Never: edit files in `data/raw/`, install packages without asking, delete files, invent a number.
- Done: `source("check.R")` shows all PASS and I have seen the output. Then one line in `log.md`.
