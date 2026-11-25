# PROJECT.md

Copy this file to `CLAUDE.md` (Claude Code) or `AGENTS.md` (Codex, Cursor, Copilot) so the agent reads it at the start of every session. In a chat app, paste it as the first message. Fill the parts in angle brackets; keep it to one page.

- Team: <your names>, course RDMAI (WU Vienna, WS 2026/27), the ladder exercise.
- Data: a synthetic rental marketplace export, three CSV files in `data/raw/`. Read `docs/codebook.md` before touching them; it names every convention.
- Question: <Q1, Q2 or Q3 from QUESTIONS.md, written out in one sentence>.
- Rules: propose a plan before changing any file and wait for approval. Show evidence for every check: the command you ran and its output, row counts before and after each filter.
- Analysis lives in `analysis/` as one script that regenerates `outputs/answer.json` from `data/raw/`. Cleaned data goes to `data/clean/`. Never edit `data/raw/`.
- Done means `python check.py` passes and the driver has seen the evidence. End every session with one line in `log.md`.
- Never: install packages without asking, delete files, send messages, post anything, invent a number.
- Style: English, short sentences. <Anything else the agent should know, or delete this sentence.>
