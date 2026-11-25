#!/usr/bin/env python3
"""The check for the ladder exercise. Pass or fail, no answers inside.

    python check.py            run all checks
    python check.py --rerun    also re-run your script and compare its output

It looks only at files in this repository: data/raw/ untouched, PROJECT.md and
brief.md filled, outputs/answer.json present and in the right shape, the script
that produced it present (and reproducing it, with --rerun), one line in
log.md, and whether the answer is right. The right answers are stored as salted
hashes: reading this file does not help, reading docs/codebook.md does.

Python 3.10 or newer, standard library only.
"""
import hashlib
import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent
SALT = "rdmai-ws26-ladder"

RAW_SHA256 = {
    "users.csv": "bb2d313be43f1eca7057df2be13824bee3dfeca1fcde1b73f9222243c8a793ae",
    "listings.csv": "883246ee8f8fe14d22047e7e81b51782be763afd8dbacae336a407067d5c575b",
    "rentals.csv": "4a49f2be2d848a75bd16000a991b3a8bc2c7f33b1f9b4afc2eb148e903f00a35",
}
ANSWERS = {
    "Q1": {"professional": ['454f6b06274082820861a5ca88bd3660949eba396a679250beb894c8cfa71e3a', 'd97688de260b15033eaa80e652f9dce8a2a80fb4ed6652d56e1082c0538f7b86', 'dbe5ef5670c309e332f6ff7376aaaee433e8ac79e58dec2fc616891bd42af85a'], "student": ['57def345875cc545e268b565394271d54987d1777eb1e22f25a882282db9cc2f', '895758fa22ea82c01720b98cefd4423414a785556c555a5ed5831df569a2b9a9', 'ef800d1e1d6a7c8c4dec80a11be204b4d328a244d47b28f808207a58468e7417']},
    "Q2": {"professional": ['09aa1e7451c601be514480eaebd3d04feda73807a5da10656e584b3be77c0d58', '535e45bcb5fa31f5794be04bfb72292e0b08e29a0d21761eacfdf6838a04e8ce', 'aa80c2bec87a5b0777712b901cb739ec6841d65cef16edaf318753f053c35141'], "student": ['129a72af75e1ed15b3a1dc4cc7b7222eb92bd5f617a593886ba639d77d43ddd1', '1d8a0e050ab1cfdd904116b2c059e749a246f665852f8ac5e70cb73bff07ed56', 'd3cb9ed10914010ec2284264062a93c8d648f879ae843a41ad1444714ed90754']},
    "Q3": {"category": ['96cccc6161acd1373355ad107cc4db64918eead9c5df078ced767782187fd878'], "count": ['12da92fe0eded0c5df458ae65dbd4ce8db78c4f7367e081d42449b966649a3be']},
}
NUMERIC = {"Q1": ("professional", "student"), "Q2": ("professional", "student"), "Q3": ("count",)}
TEXT = {"Q3": ("category",)}

results = []


def record(name, ok, detail="", warn=False):
    results.append((name, ok, detail, warn))


def digest(text):
    return hashlib.sha256((SALT + "|" + text).encode("utf-8")).hexdigest()


def normalise(key, value, question):
    if key in NUMERIC.get(question, ()):
        try:
            x = round(float(value), 1)
        except (TypeError, ValueError):
            return None
        if key == "count" and float(value) != int(float(value)):
            return None
        return f"{x:.1f}" if key != "count" else str(int(x))
    return str(value).strip().lower()


def placeholders(path):
    text = (ROOT / path).read_text(encoding="utf-8", errors="replace")
    return re.findall(r"<[^<>\n]{1,80}>", text)


# 1. raw data untouched -------------------------------------------------------
for name, want in RAW_SHA256.items():
    path = ROOT / "data" / "raw" / name
    if not path.exists():
        record(f"raw data present: {name}", False, "missing. Restore it: git checkout -- data/raw/")
        continue
    got = hashlib.sha256(path.read_bytes().replace(b"\r\n", b"\n")).hexdigest()
    record(f"raw data untouched: {name}", got == want,
           "" if got == want else "changed. Raw data is never edited: git checkout -- data/raw/ restores it; "
                                  "put the cleaning in a script that writes to data/clean/")

# 2. context file and brief filled -------------------------------------------
for fname in ("PROJECT.md", "brief.md"):
    if not (ROOT / fname).exists():
        record(f"{fname} present", False, "missing")
        continue
    left = placeholders(fname)
    record(f"{fname} filled, no <...> left", not left, "; ".join(left[:4]))

copied = [n for n in ("CLAUDE.md", "AGENTS.md") if (ROOT / n).exists()]
record("PROJECT.md copied to CLAUDE.md or AGENTS.md", bool(copied),
       "" if copied else "coding agents read these automatically; chat-app users may ignore this line", warn=True)

# 3. the answer file -----------------------------------------------------------
answer = None
apath = ROOT / "outputs" / "answer.json"
if not apath.exists():
    record("outputs/answer.json present", False, "missing; see QUESTIONS.md for the shape")
else:
    try:
        answer = json.loads(apath.read_text(encoding="utf-8"))
        record("outputs/answer.json is valid JSON", True)
    except json.JSONDecodeError as e:
        record("outputs/answer.json is valid JSON", False, str(e))

question = None
if isinstance(answer, dict):
    question = answer.get("question")
    shape_ok = question in ANSWERS and isinstance(answer.get("answer"), dict) \
        and set(answer["answer"]) == set(ANSWERS[question]) and isinstance(answer.get("produced_by"), str)
    record("answer.json has the shape from QUESTIONS.md", shape_ok,
           "" if shape_ok else 'needs "question" (Q1, Q2 or Q3), "answer" with exactly the keys for that question, "produced_by"')
    if not shape_ok:
        question = None

# 4. the script that produced it ---------------------------------------------
script = None
if question:
    script = ROOT / answer["produced_by"]
    ok = script.exists() and script.is_file() and "analysis" in script.relative_to(ROOT).parts[:1]
    record("the script named in produced_by exists under analysis/", ok,
           "" if ok else f"{answer['produced_by']} not found under analysis/")
    if not ok:
        script = None

# 5. the answer ------------------------------------------------------------------
if question:
    for key in ANSWERS[question]:
        norm = normalise(key, answer["answer"].get(key), question)
        ok = norm is not None and digest(norm) in ANSWERS[question][key]
        record(f"{question} {key} is right", ok,
               "" if ok else "no. Not a hint, a question: which convention in docs/codebook.md did the script skip?")

# 6. the log -------------------------------------------------------------------------
lpath = ROOT / "log.md"
if lpath.exists():
    rows = [ln for ln in lpath.read_text(encoding="utf-8", errors="replace").splitlines()
            if ln.startswith("|") and not ln.startswith("| Date") and not ln.startswith("|---") and "<" not in ln]
    record("log.md has at least one real line", bool(rows), "" if rows else "the agent writes it, you correct it")
else:
    record("log.md present", False, "missing")

# 7. optional: re-run the script -------------------------------------------------
if "--rerun" in sys.argv:
    if script is None:
        record("re-run: script reproduces answer.json", False, "no script to run")
    else:
        before = apath.read_text(encoding="utf-8")
        try:
            proc = subprocess.run([sys.executable, str(script)], cwd=ROOT, capture_output=True, text=True, timeout=120)
            after = apath.read_text(encoding="utf-8") if apath.exists() else ""
            same = proc.returncode == 0 and json.loads(after) == json.loads(before)
            record("re-run: script runs and reproduces answer.json", same,
                   "" if same else (proc.stderr.strip().splitlines() or ["output differs from the committed file"])[-1])
        except subprocess.TimeoutExpired:
            record("re-run: script runs and reproduces answer.json", False, "took longer than 120 s")
        except json.JSONDecodeError:
            record("re-run: script runs and reproduces answer.json", False, "answer.json unreadable after the run")

# report ----------------------------------------------------------------------------
fails = 0
for name, ok, detail, warn in results:
    tag = "PASS" if ok else ("WARN" if warn else "FAIL")
    fails += (not ok) and (not warn)
    print(f"{tag}  {name}" + (f"  ({detail})" if detail and not ok else ""))
total = sum(1 for r in results if not r[3])
print(f"\n{total - fails} of {total} checks pass." + ("" if fails else "  Done. Now the log line and the commit."))
sys.exit(1 if fails else 0)
