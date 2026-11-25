#!/usr/bin/env Rscript
# The check for the ladder exercise. Pass or fail, no answers inside.
#
#   Rscript check.R            run all checks
#   Rscript check.R --rerun    also re-run your script and compare its output
#
#   From an R console (VS Code with the R extension, RStudio): source("check.R")
#   with the repository folder as the working directory.
#   To re-run the script as well: options(ladder.rerun = TRUE) first.
#
# It looks only at files in this repository: data/raw/ untouched, PROJECT.md
# and brief.md filled, outputs/answer.csv present and in the right shape, the
# script that produced it present (and reproducing it, with --rerun), one line
# in log.md, and whether the answer is right. The right answers are stored as
# salted hashes: reading this file does not help, reading docs/codebook.md does.
#
# Base R only (4.1 or newer), no packages.

# ---- where the repository is ------------------------------------------------
script_path <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
ROOT <- if (length(script_path)) normalizePath(dirname(script_path[1])) else normalizePath(getwd())
rerun <- "--rerun" %in% commandArgs(trailingOnly = TRUE) || isTRUE(getOption("ladder.rerun"))
old_wd <- setwd(ROOT)

SALT <- "rdmai-ws26-ladder"
RAW_MD5 <- c(
  "users.csv" = "927d569490abfb2c1cd4b4ce51a62395",
  "listings.csv" = "17be0c5967d4093ea639a7b773c241b5",
  "rentals.csv" = "06ee2239ee0b5cb89c749c9e2ea41f5d"
)
ANSWERS <- list(
  Q1 = list(professional = c("6c588b549ffa13d20a7c5e753cdf54d3", "9441616501537b0b55a8cbd517afddcf", "ecc7a33ad2da799a71a97954e81addc5"),
            student = c("79a585ce14ead6127a60e1c6d8d78515", "e55811d8642a68cc128d118e1a65ed1e", "ec14b4cad1c258d9d44f8a7e555168d9")),
  Q2 = list(professional = c("023da7f7d4aed757a1627853c6d86fc0", "08cc3d324923b18d01b8b1a1a4bf54bd", "8c21a00ca54e9fb5d118613a3deb0bc1"),
            student = c("30b2709f46b924ae240556f71f506008", "c8755b52287bc0c4d4ae8d58dcca2202", "fc9d82c2c79efed4ec10b1a1c32e4ecd")),
  Q3 = list(category = c("c3bc30a6cfeda8082d11f242317c57c4"), count = c("709fddb40dfb9db79ca3affdb860de95"))
)
NUMERIC <- list(Q1 = c("professional", "student"), Q2 = c("professional", "student"), Q3 = "count")

# ---- helpers ------------------------------------------------------------------
results <- list()
record <- function(name, ok, detail = "", warn = FALSE) {
  results[[length(results) + 1]] <<- list(name = name, ok = isTRUE(ok), detail = detail, warn = warn)
}
p <- function(...) file.path(ROOT, ...)

md5_of <- function(text) {
  f <- tempfile()
  on.exit(unlink(f))
  cat(SALT, "|", text, file = f, sep = "")
  unname(tools::md5sum(f))
}
md5_file_lf <- function(path) {  # line endings normalised, so a Windows checkout still passes
  bytes <- readBin(path, "raw", file.size(path))
  bytes <- bytes[bytes != as.raw(0x0d)]
  f <- tempfile()
  on.exit(unlink(f))
  writeBin(bytes, f)
  unname(tools::md5sum(f))
}
placeholders <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  unlist(regmatches(lines, gregexpr("<[^<>]{1,80}>", lines, perl = TRUE)))
}
normalise <- function(key, value, question) {
  if (is.null(value) || length(value) == 0) return(NA_character_)
  if (key %in% NUMERIC[[question]]) {
    x <- suppressWarnings(as.numeric(value))
    if (is.na(x)) return(NA_character_)
    if (key == "count") {
      if (x != round(x)) return(NA_character_)
      return(as.character(as.integer(round(x))))
    }
    return(sprintf("%.1f", round(x, 1)))
  }
  tolower(trimws(as.character(value)))
}

# 1. raw data untouched ---------------------------------------------------------
for (name in names(RAW_MD5)) {
  path <- p("data", "raw", name)
  if (!file.exists(path)) {
    record(paste("raw data present:", name), FALSE, "missing. Restore it: git checkout -- data/raw/")
    next
  }
  ok <- md5_file_lf(path) == RAW_MD5[[name]]
  record(paste("raw data untouched:", name), ok,
         if (ok) "" else "changed. Raw data is never edited: git checkout -- data/raw/ restores it; put the cleaning in a script that writes to data/clean/")
}

# 2. context file and brief filled ---------------------------------------------
for (fname in c("PROJECT.md", "brief.md")) {
  if (!file.exists(p(fname))) {
    record(paste(fname, "present"), FALSE, "missing")
    next
  }
  left <- placeholders(p(fname))
  record(paste(fname, "filled, no <...> left"), length(left) == 0, paste(head(left, 4), collapse = "; "))
}
copied <- file.exists(p(c("CLAUDE.md", "AGENTS.md")))
record("PROJECT.md copied to CLAUDE.md or AGENTS.md", any(copied),
       if (any(copied)) "" else "coding agents read these automatically; chat-app users may ignore this line", warn = TRUE)

# 3. the answer file --------------------------------------------------------------
answer <- NULL
question <- NULL
apath <- p("outputs", "answer.csv")
if (!file.exists(apath)) {
  record("outputs/answer.csv present", FALSE, "missing; see QUESTIONS.md for the shape")
} else {
  tab <- tryCatch(read.csv(apath, stringsAsFactors = FALSE, strip.white = TRUE, colClasses = "character"),
                  error = function(e) NULL)
  ok <- !is.null(tab) && all(c("key", "value") %in% names(tab))
  record("outputs/answer.csv reads as a key,value table", ok, if (ok) "" else "two columns, key and value, one row per entry")
  if (ok) {
    answer <- setNames(as.list(tab$value), tab$key)
    q <- answer[["question"]]
    keys <- setdiff(names(answer), c("question", "produced_by"))
    shape_ok <- !is.null(q) && q %in% names(ANSWERS) && setequal(keys, names(ANSWERS[[q]])) && !is.null(answer[["produced_by"]])
    record("answer.csv has the shape from QUESTIONS.md", shape_ok,
           if (shape_ok) "" else "needs the rows question (Q1, Q2 or Q3), produced_by, and exactly the keys for that question")
    if (shape_ok) question <- q
  }
}

# 4. the script that produced it ------------------------------------------------
script <- NULL
if (!is.null(question)) {
  rel <- gsub("\\\\", "/", answer[["produced_by"]])
  ok <- file.exists(p(rel)) && !dir.exists(p(rel)) && startsWith(rel, "analysis/")
  record("the script named in produced_by exists under analysis/", ok, if (ok) "" else paste(rel, "not found under analysis/"))
  if (ok) script <- rel
}

# 5. the answer ---------------------------------------------------------------------
if (!is.null(question)) {
  for (key in names(ANSWERS[[question]])) {
    norm <- normalise(key, answer[[key]], question)
    ok <- !is.na(norm) && md5_of(norm) %in% ANSWERS[[question]][[key]]
    record(sprintf("%s %s is right", question, key), ok,
           if (ok) "" else "no. Not a hint, a question: which convention in docs/codebook.md did the script skip?")
  }
}

# 6. the log ----------------------------------------------------------------------------
if (file.exists(p("log.md"))) {
  lines <- readLines(p("log.md"), warn = FALSE, encoding = "UTF-8")
  rows <- lines[startsWith(lines, "|") & !startsWith(lines, "| Date") & !startsWith(lines, "|---") & !grepl("<", lines, fixed = TRUE)]
  record("log.md has at least one real line", length(rows) > 0, if (length(rows)) "" else "the agent writes it, you correct it")
} else {
  record("log.md present", FALSE, "missing")
}

# 7. optional: re-run the script ----------------------------------------------------
if (rerun) {
  if (is.null(script)) {
    record("re-run: script reproduces answer.csv", FALSE, "no script to run")
  } else {
    rscript <- file.path(R.home("bin"), "Rscript")
    if (!file.exists(rscript) && !file.exists(paste0(rscript, ".exe"))) rscript <- "Rscript"
    python <- if (nzchar(Sys.which("python"))) "python" else "python3"
    runner <- if (grepl("\\.[Rr]$", script)) rscript else if (grepl("\\.py$", script)) python else NULL
    if (is.null(runner)) {
      record("re-run: script reproduces answer.csv", FALSE, "only .R and .py scripts can be re-run")
    } else {
      before <- readLines(apath, warn = FALSE)
      out <- tryCatch(system2(runner, shQuote(script), stdout = TRUE, stderr = TRUE, timeout = 120),
                      error = function(e) structure(conditionMessage(e), status = 1L),
                      warning = function(w) structure(conditionMessage(w), status = 1L))
      status <- attr(out, "status")
      if (is.null(status)) status <- 0L
      after <- if (file.exists(apath)) readLines(apath, warn = FALSE) else character()
      same <- status == 0L && identical(trimws(before), trimws(after))
      record("re-run: script runs and reproduces answer.csv", same,
             if (same) "" else if (status != 0L) paste0("exit status ", status, ": ", tail(out, 1)) else "output differs from the committed file")
    }
  }
}

# ---- report ----------------------------------------------------------------------------
fails <- 0L
total <- 0L
for (r in results) {
  tag <- if (r$ok) "PASS" else if (r$warn) "WARN" else "FAIL"
  if (!r$warn) {
    total <- total + 1L
    if (!r$ok) fails <- fails + 1L
  }
  cat(tag, "  ", r$name, if (!r$ok && nzchar(r$detail)) paste0("  (", r$detail, ")") else "", "\n", sep = "")
}
cat("\n", total - fails, " of ", total, " checks pass.",
    if (fails == 0L) "  Done. Now the log line and the commit." else "", "\n", sep = "")
setwd(old_wd)
if (!interactive()) quit(save = "no", status = if (fails > 0L) 1L else 0L)
