# PROJECT.md

The one page the AI reads before it does anything. Fill in the parts in angle brackets and delete the brackets. Then save a copy as `AGENTS.md` (Copilot, Codex, Cursor) or `CLAUDE.md` (Claude Code), or paste it as your first message in a chat app.

- Who: <your name or names>, course RDMAI, WU Vienna, winter term 2026/27, the ladder exercise.
- Data: an invented rental marketplace, three CSV files in `data/raw/`. Read `docs/codebook.md` before using them; it explains every column and every convention.
- Question: <Q1, Q2 or Q3 from QUESTIONS.md, written out as a full sentence>.
- How we work: first propose a plan and wait for my approval, then act. For every step, show me the output: the code you ran, the number of rows after every filter, the final numbers.
- Where things go: one R script in `analysis/` that reads `data/raw/`, writes cleaned data to `data/clean/` and the result to `outputs/answer.csv`. Run everything from the project folder, with paths like `data/raw/users.csv`.
- Never edit the files in `data/raw/`. Never install packages without asking. Never delete files. Never invent a number.
- Done means `source("check.R")` shows all PASS and I have seen the output. End with one line in `log.md`.
- Language: English, short sentences. <Anything else the AI should know, or delete this sentence.>
